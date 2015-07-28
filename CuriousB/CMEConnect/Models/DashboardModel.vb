Imports System.Globalization
Imports System.Configuration.ConfigurationManager

Public Class DashboardModel

    Private _dbConn As MsSQLDatabase.MsSQLClass
    Private _strConn As String

    Public LatestDeployed As New Dictionary(Of String, Object)
    Public EmailEngagements As New List(Of Dictionary(Of String, Object))
    Public ChartDesc As String = ""

    Public HasError As Boolean = False
    Public ErrorMMsg As String = ""
    Public DebugMsg As String = ""
    Public CurrentNumberFormat = CultureInfo.InvariantCulture

    Public Sub New()

        _strConn = ConnectionStrings("SQLConn2").ConnectionString
        _dbConn = New MsSQLDatabase.MsSQLClass()

        GetEngagementObjects()

    End Sub

    Private Sub GetEngagementObjects()
        Dim _eLib = New CuriousBLib.EngagementLib

        EmailEngagements = _eLib.GetEngagementOverTime("rpt.sp_EngagementOverTime")
        If _eLib.HasError Then
            HasError = True
            ErrorMMsg = _eLib.ErrorMsg
        Else
            ChartDesc = _eLib.GetEngagementOverTimeDesc()
            LatestDeployed = _eLib.GetCommunicationSummary("rpt.sp_GetEventsSummary")
        End If

        _eLib.Dispose()
    End Sub

    'Public Sub GetEmailEngagements()

    '    Dim mSQL As String = "rpt.sp_EngagementOverTime"
    '    'Dim mSQL As String = "rpt.sp_Engagement_Over_Time"
    '    With _dbConn

    '        If .IsConnected Then
    '            .Query = mSQL
    '            .SQLType = MsSQLDatabase.MsSQLClass.QueryType.STORED_QUERY
    '            .MyCmd.CommandType = CommandType.StoredProcedure
    '            .MyCmd.Parameters.Clear()

    '            If .ExecuteQuery Then
    '                With .MyRdr
    '                    If .HasRows Then
    '                        Dim _EngagementList As New List(Of Dictionary(Of String, Object))

    '                        Dim _Result = New ArrayList

    '                        'WeekNo, WeekRange, Low, Medium, High, TotalCount

    '                        While .Read
    '                            Dim dict As New Dictionary(Of String, Object)
    '                            Dim hi, mi, lo, tot As Int64

    '                            lo = .GetValue(2)
    '                            mi = .GetValue(3)
    '                            hi = .GetValue(4)
    '                            tot = .GetValue(5)

    '                            dict.Add("WeekNo", .GetValue(0))
    '                            dict.Add("WeekRange", .GetValue(0))
    '                            dict.Add("Low", Math.Round(lo / tot * 100))
    '                            dict.Add("Medium", Math.Round(mi / tot * 100))
    '                            dict.Add("High", Math.Round(hi / tot * 100))
    '                            dict.Add("TotalCount", tot)
    '                            dict.Add("TotalLow", lo)
    '                            dict.Add("TotalMedium", mi)
    '                            dict.Add("TotalHigh", hi)
    '                            dict.Add("Dormant", .GetValue(1))
    '                            dict.Add("Seq", .GetValue(6))

    '                            _EngagementList.Add(dict)
    '                        End While
    '                        EmailEngagements = _EngagementList

    '                    End If
    '                    .Close()
    '                End With
    '            Else
    '                HasError = True
    '                ErrorMMsg = .ErrorMsg
    '            End If
    '        Else
    '            HasError = True
    '            ErrorMMsg = .ErrorMsg
    '        End If
    '    End With

    'End Sub

    Private Function GetTextTemplate() As String
        Dim txtString As String = ""
        'Dim deployeDate As Date

        '_deployDate()
        Return txtString
    End Function

End Class
