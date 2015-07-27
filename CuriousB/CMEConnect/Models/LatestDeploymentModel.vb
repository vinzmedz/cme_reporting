Imports System.Globalization.CultureInfo
Imports System.Configuration
Imports System.Configuration.ConfigurationManager
Imports System.Data
Imports System.Data.SqlClient
Imports System.Globalization

Public Class LatestDeploymentModel
    Private _dbConn As MsSQLDatabase.MsSQLClass
    Private _strConn As String

    Private _startDate As String
    Private _endDate As String
    Private _commName As String
    Private _deployDate As DateTime

    Public LatestDeployements As New List(Of Dictionary(Of String, Object))
    Public DeployDate As String
    Public CommName As String

    Public HasError As Boolean = False
    Public ErrorMMsg As String = ""
    Public DebugMsg As String = ""

    Public Sub New()
        _strConn = ConnectionStrings("SQLConn2").ConnectionString
        _dbConn = New MsSQLDatabase.MsSQLClass()

        InitVariables()
        With _dbConn
            .dbOpen(_strConn)

            GetLatestDeployments()
        End With
        _dbConn.dbClose()
        _dbConn = Nothing

    End Sub

    Private Sub InitVariables()
        Dim _eLib = New CuriousBLib.EngagementLib

        _eLib.GetLatestCommunication()

        DeployDate = _deployDate.ToString("g")
    End Sub

    Public Sub GetLatestDeployments()
        Dim mSQL As String = "[rpt].[sp_LatestDeployment]"

        DebugMsg = DebugMsg & mSQL
        With _dbConn
            If .IsConnected Then
                .Query = mSQL
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.STORED_QUERY
                .MyCmd.CommandType = CommandType.StoredProcedure

                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            Dim LatestDeploymentsList As New List(Of Dictionary(Of String, Object))
                            Dim _Result = New ArrayList
                            '--Name, DateDeployed, Deployed, Opened, Clicked, Total
                            'Name	DateDeployed	deployed	opened	clicked	Rank	expectedOpenRate
                            While .Read
                                Dim dict As New Dictionary(Of String, Object)
                                Dim dep As Integer = .GetValue(2)
                                Dim opn As Integer = .GetValue(3)
                                Dim clk As Integer = .GetValue(4)



                                dict.Add("DateDeployed", .GetValue(1))
                                dict.Add("Name", .GetValue(0).ToString)
                                dict.Add("Deployed", dep)
                                dict.Add("Opened", opn)
                                dict.Add("Clicked", clk)
                                dict.Add("Rank", .GetValue(5))
                                dict.Add("ExpOpen", .GetValue(6))
                                LatestDeploymentsList.Add(dict)
                            End While
                            LatestDeployements = LatestDeploymentsList

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


End Class
