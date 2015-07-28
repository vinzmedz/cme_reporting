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

        InitVariables()

    End Sub

    Private Sub InitVariables()
        Dim _eLib = New CuriousBLib.EngagementLib

        LatestDeployements = _eLib.GetLatestDeployments
        If _eLib.HasError Then
            HasError = True
            ErrorMMsg = _eLib.ErrorMsg
        End If

        _eLib.Dispose()

    End Sub

End Class
