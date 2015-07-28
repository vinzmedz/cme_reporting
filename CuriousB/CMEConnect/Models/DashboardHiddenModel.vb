Imports System.Globalization
Imports System.Configuration.ConfigurationManager

Public Class DashboardHiddenModel

    Private _dbConn As MsSQLDatabase.MsSQLClass
    Private _strConn As String

    Public EmailEngagements As New List(Of Dictionary(Of String, Object))
    Public LatestDeployements As New List(Of Dictionary(Of String, Object))

    Public HasError As Boolean = False
    Public ErrorMMsg As String = ""
    Public DebugMsg As String = ""
    Public CurrentNumberFormat = CultureInfo.InvariantCulture

    Public Sub New()

        _strConn = ConnectionStrings("SQLConn2").ConnectionString
        _dbConn = New MsSQLDatabase.MsSQLClass()

        GetEmailEngagements()

    End Sub

    Private Sub GetEmailEngagements()
        Dim _EmailEngagements As New List(Of Dictionary(Of String, Object))

        Dim _eLib = New CuriousBLib.EngagementLib

        EmailEngagements = _eLib.GetEngagementOverTime("rpt.sp_EngagementOverTime")
        LatestDeployements = _eLib.GetLatestDeployments
        If _eLib.HasError Then
            HasError = True
            ErrorMMsg = _eLib.ErrorMsg
        End If

        _eLib.Dispose()

    End Sub

End Class
