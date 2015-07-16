Imports System.Globalization.CultureInfo
Imports System.Configuration
Imports System.Configuration.ConfigurationManager
Imports System.Data
Imports System.Data.SqlClient
Imports System.Globalization

Public Class DashboardModels

    Private _dbConn As MsSQLDatabase.MsSQLClass
    Private _strConn As String

    Private _clicks As IList
    Private _startDate As String
    Private _endDate As String
    Private _lastCommLog As Guid
    Private _dateCommlog As String
    Private _deployDate As DateTime

    Public LatestDeployed As New Dictionary(Of String, Object)
    Public Deployed, Opened, TotalOpened, Clicked, TotalClicked As Integer
    Public OpenRank As String
    Public ClickRank As String
    Public CommLogName As String
    Public DeployDate As String


    Public EmailEngagements As New List(Of Dictionary(Of String, Object))
    'Public EmailEngagements As New List(Of EngagementOverTime)
    Public TopISPs As New List(Of Dictionary(Of String, Object))

    Public HasError As Boolean = False
    Public ErrorMMsg As String = ""
    Public DebugMsg As String = ""
    Public CurrentNumberFormat = CultureInfo.InvariantCulture

    Public Sub New()

        _strConn = ConnectionStrings("SQLConn2").ConnectionString
        _dbConn = New MsSQLDatabase.MsSQLClass()

        InitVariables()

        With _dbConn
            .dbOpen(_strConn)

            GetEmailEngagements()
            GetEventTotals()
            GetISPs()

        End With
        _dbConn.dbClose()
        _dbConn = Nothing

    End Sub

    Private Sub InitVariables()
        Dim _eLib = New CuriousBLib.EngagementLib

        _eLib.GetLatestDate()
        _lastCommLog = _eLib.GetLatestCommunication
        If _eLib.HasError Then
            HasError = True
            ErrorMMsg = _eLib.ErrorMsg
        End If

        _deployDate = _eLib.DeployDate
        _startDate = _eLib.StartDate
        _endDate = _eLib.EndDate

        DeployDate = _deployDate.ToString("g")
    End Sub

    Public Sub GetISPs()
        Dim mSQL As String

        mSQL = "SELECT TOP 4 LEFT(a.EmailDomain, CHARINDEX('.', a.EmailDomain)-1) Domain, " & _
               "    COUNT(a.EmailDomain) EmailCount, a.TotalEmails " & _
               "FROM ( " & _
               "    SELECT RIGHT(email, LEN(email) - CHARINDEX('@', email)) EmailDomain, " & _
               "        (SELECT COUNT(x.email) FROM sendgrid_event x WHERE LEN(x.email) > 0) TotalEmails " & _
               "FROM sendgrid_event " & _
               "WHERE Len(email) > 0 " & _
               "    ) a " & _
               "GROUP BY a.EmailDomain, a.TotalEmails " & _
               "ORDER BY EmailCount DESC"

        '_dbConn = New MsSQLDatabase.MsSQLClass(mSQL)
        With _dbConn
            '.dbOpen(_strConn)
            If .IsConnected Then
                .Query = mSQL
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.SELECT_QUERY
                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            Dim TopIspList As New List(Of Dictionary(Of String, Object))
                            Dim total4 As Integer = 0
                            Dim totals As Integer = 0

                            While .Read
                                Dim dict As New Dictionary(Of String, Object)
                                Dim percent As Double = 0

                                totals = .GetValue(2)
                                total4 = total4 + .GetValue(1)
                                percent = .GetValue(1) / .GetValue(2) * 100

                                dict.Add("Domain", .GetValue(0))
                                dict.Add("EmailPercent", percent)

                                TopIspList.Add(dict)
                            End While
                            Dim odict As New Dictionary(Of String, Object)
                            Dim otherPcnt As Double = (totals - total4) / totals * 100

                            odict.Add("Domain", "Others")
                            odict.Add("EmailPercent", otherPcnt)
                            TopIspList.Add(odict)

                            TopISPs = TopIspList

                        End If
                        .Close()
                    End With
                End If

                '.dbClose()
            Else
                HasError = True
                ErrorMMsg = .ErrorMsg
            End If
        End With

    End Sub

    Public Sub GetEventTotals()
        Dim mSQL = "rpt.sp_GetEventsSummary"
        With _dbConn
            If .IsConnected Then
                .Query = mSQL
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.STORED_QUERY
                .MyCmd.CommandType = CommandType.StoredProcedure
                .MyCmd.Parameters.Clear()

                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            While .Read
                                '0 CommLog
                                '1 TotalDeployed
                                '2 PctOpened
                                '3 PctClicked
                                '4 TotOpened
                                '5 TotClicked
                                '6 CommName
                                '7 OpenedRank
                                '8 ClickedRank

                                LatestDeployed.Add("Deployed", .GetValue(1))
                                LatestDeployed.Add("Opened", .GetValue(2))
                                LatestDeployed.Add("Clicked", .GetValue(3))
                                LatestDeployed.Add("TotalOpened", .GetValue(4))
                                LatestDeployed.Add("TotalClicked", .GetValue(5))
                                LatestDeployed.Add("CommLogName", .GetValue(6))
                                LatestDeployed.Add("PrevOpened", .GetValue(7))
                                LatestDeployed.Add("PrevClicked", .GetValue(8))
                                'LatestDeployed.Add("OpenRank", .GetValue(9))
                                LatestDeployed.Add("OpenRank", "High")
                                LatestDeployed.Add("ClickRank", .GetValue(10))
                            End While
                        End If
                        .Close()
                    End With
                End If
            Else
                HasError = True
                ErrorMMsg = .ErrorMsg
            End If
        End With
    End Sub

    Public Sub GetEmailEngagements()

        Dim mSQL As String = "rpt.sp_EngagementOverTime"
        'Dim mSQL As String = "rpt.sp_Engagement_Over_Time"
        With _dbConn

            If .IsConnected Then
                .Query = mSQL
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.STORED_QUERY
                .MyCmd.CommandType = CommandType.StoredProcedure
                .MyCmd.Parameters.Clear()

                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            Dim _EngagementList As New List(Of Dictionary(Of String, Object))

                            Dim _Result = New ArrayList

                            'WeekNo, WeekRange, Low, Medium, High, TotalCount

                            While .Read
                                Dim dict As New Dictionary(Of String, Object)
                                Dim hi, mi, lo, tot As Int64

                                lo = .GetValue(2)
                                mi = .GetValue(3)
                                hi = .GetValue(4)
                                tot = .GetValue(5)

                                dict.Add("WeekNo", .GetValue(0))
                                dict.Add("WeekRange", .GetValue(0))
                                dict.Add("Low", Math.Round(lo / tot * 100))
                                dict.Add("Medium", Math.Round(mi / tot * 100))
                                dict.Add("High", Math.Round(hi / tot * 100))
                                dict.Add("TotalCount", tot)
                                dict.Add("TotalLow", lo)
                                dict.Add("TotalMedium", mi)
                                dict.Add("TotalHigh", hi)
                                dict.Add("Dormant", .GetValue(1))

                                _EngagementList.Add(dict)
                            End While
                            EmailEngagements = _EngagementList

                        End If
                        .Close()
                    End With
                Else
                    HasError = True
                    ErrorMMsg = .ErrorMsg
                End If
            Else
                HasError = True
                ErrorMMsg = .ErrorMsg
            End If
        End With

    End Sub

    Private Function GetTextTemplate() As String
        Dim txtString As String = ""
        'Dim deployeDate As Date

        '_deployDate()
        Return txtString
    End Function

End Class

Public Class EngagementClicks
    Public Seq As Integer
    Public Edm As String
    Public Deployed As Int64
    Public Opened As Int64
    Public Click As Int64
End Class

Public Class EngagementOverTime
    Public Seq As Integer
    Public Edm As String
    Public Low As Int64
    Public Meduim As Int64
    Public High As Int64
    Public Total As Int64
End Class
