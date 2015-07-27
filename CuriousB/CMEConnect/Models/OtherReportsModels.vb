Imports System.Globalization
Imports System.Configuration
Imports System.Configuration.ConfigurationManager
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization

Public Class OtherReportsModels
    Private dashb As DashboardModel

    Private _dbConn As MsSQLDatabase.MsSQLClass
    Private _strConn As String

    Public EmailEngagements As New List(Of Dictionary(Of String, Object))
    Public EmailCurrentState As New List(Of Dictionary(Of String, Object))
    Public ChartDesc As String = ""

    Public HasError As Boolean = False
    Public ErrorMMsg As String = ""
    Public DebugMsg As String = ""
    Public CurrentNumberFormat = New CultureInfo("en-US", False).NumberFormat

    Public Sub New()
        CurrentNumberFormat.CurrencyDecimalDigits = 2

        dashb = New DashboardModel
        _strConn = ConnectionStrings("SQLConn2").ConnectionString

        GetEmailCurrentState()
        If Not HasError Then
            Dim _elib As CuriousBLib.EngagementLib = New CuriousBLib.EngagementLib

            EmailEngagements = _elib.GetEngagementOverTime("rpt.sp_EngagementOverTime")
            ChartDesc = _elib.GetEngagementOverTimeDesc()
        End If

    End Sub

    Public Sub GetEmailCurrentState()
        Dim mSQL As String = "rpt.sp_CommunicationHistory"
        Dim jsonString As String = ""
        Dim jss As New JavaScriptSerializer

        _dbConn = New MsSQLDatabase.MsSQLClass(mSQL)

        With _dbConn
            .dbOpen(_strConn)
            If .IsConnected Then
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.STORED_QUERY
                .MyCmd.CommandType = CommandType.StoredProcedure
                .MyCmd.Parameters.Clear()

                '0-CME_CommLog, 1-Name, 2-Deployed, 3-OpenRate, 4-ClickRate, 5-DateDeployed, 6-TotalOpened, 7-TotalClicked, 8-ExpectedOpenRate
                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            Dim CStateList As New List(Of Dictionary(Of String, Object))

                            While .Read
                                Dim dict As New Dictionary(Of String, Object)

                                Dim openRate As Integer = 0
                                Dim clickRate As Integer = 0
                                Dim exptdOpenRate As Integer = 0
                                Dim icon_css As String = ""
                                Dim cell_content As String = ""

                                openRate = .GetValue(3)
                                clickRate = .GetValue(4)
                                exptdOpenRate = .GetValue(8)

                                If openRate > 0 Then
                                    If exptdOpenRate < openRate Then
                                        icon_css = "exptd-hi glyphicon glyphicon-circle-arrow-up"
                                    Else
                                        icon_css = "exptd-low glyphicon glyphicon-circle-arrow-down"
                                    End If

                                    cell_content = String.Format(CultureInfo.InvariantCulture, "{0:0}%", openRate)
                                    cell_content = String.Concat(cell_content, String.Format("<div class='histExpctd'><span class='{0}' title='Expected open rate is {1}%'></span></div>", icon_css, exptdOpenRate))

                                    dict.Add("OpenRate", cell_content)
                                Else
                                    dict.Add("OpenRate", "<span class='blank-data' title='This data was intentionally blanked out.'>-</span>")
                                End If

                                If clickRate > 0 Then
                                    dict.Add("ClickRate", String.Format(CultureInfo.InvariantCulture, "{0:0}%", openRate))
                                Else
                                    dict.Add("ClickRate", "<span class='blank-data' title='This data was intentionally blanked out.'>-</span>")
                                End If

                                dict.Add("CommLog", .GetValue(0))
                                dict.Add("DateDeployed", .GetValue(5))
                                dict.Add("Name", .GetValue(1))
                                dict.Add("Deployed", .GetValue(2))
                                dict.Add("TotalOpened", .GetValue(6))
                                dict.Add("TotalClicked", .GetValue(7))
                                CStateList.Add(dict)
                            End While

                            EmailCurrentState = CStateList

                            ErrorMMsg = jsonString
                        End If
                    End With
                Else
                    HasError = True
                    ErrorMMsg = .ErrorMsg
                End If

                .dbClose()
            Else
                HasError = True
                ErrorMMsg = .ErrorMsg
            End If

        End With

    End Sub

End Class