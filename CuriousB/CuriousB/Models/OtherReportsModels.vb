Imports System.Globalization
Imports System.Configuration
Imports System.Configuration.ConfigurationManager
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization

Public Class OtherReportsModels
    Private dashb As DashboardModels

    Private _dbConn As MsSQLDatabase.MsSQLClass
    Private _strConn As String

    Public EmailsSent As New List(Of CommLogs)
    Public EmailEngagements As New List(Of Dictionary(Of String, Object))
    Public EmailCurrentState As New List(Of Dictionary(Of String, Object))

    Public HasError As Boolean = False
    Public ErrorMMsg As String = ""
    Public DebugMsg As String = ""
    Public CurrentNumberFormat = New CultureInfo("en-US", False).NumberFormat

    Public Sub New()
        CurrentNumberFormat.CurrencyDecimalDigits = 2

        dashb = New DashboardModels
        _strConn = ConnectionStrings("SQLConn2").ConnectionString

        GetEmailCurrentState()
        If Not HasError Then
            EmailEngagements = dashb.EmailEngagements
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

                'iCME_CommLog, iName, Deployed, OpenRate, ClickRate
                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            Dim CStateList As New List(Of Dictionary(Of String, Object))

                            While .Read
                                Dim dict As New Dictionary(Of String, Object)
                                dict.Add("iDateDeployed", .GetValue(0))
                                dict.Add("Name", .GetValue(1))
                                dict.Add("Deployed", .GetValue(2))
                                dict.Add("OpenRate", .GetValue(3))
                                dict.Add("ClickRate", .GetValue(4))
                                dict.Add("Rank", .GetValue(5))
                                If .GetValue(5) = "High" Then
                                    dict.Add("Icon", "rank-hi glyphicon glyphicon-circle-arrow-up")
                                ElseIf .GetValue(5) = "Medium" Then
                                    dict.Add("Icon", "rank-mid glyphicon glyphicon-circle-arrow-right")
                                Else
                                    dict.Add("Icon", "rank-low glyphicon glyphicon-circle-arrow-down")
                                End If

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

Public Class CommLogs
    'cl.CME_CommLog, cb.Name, cl.NumDeployed, ci.NumReceived, cl.DateDeployed, seq
    Public Seq As Integer
    Public CommLog As String
    Public Name As String
    Public DateDeployed As String
    Public NumDeployed As Int64
    Public NumReceived As Int64
End Class

