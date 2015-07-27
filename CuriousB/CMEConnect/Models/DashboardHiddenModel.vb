Imports System.Globalization
Imports System.Configuration.ConfigurationManager

Public Class DashboardHiddenModel

#Region "Properties"
    Public ReadOnly Property EmailEngagements As List(Of Dictionary(Of String, Object))
        Get
            Return _emailEmgagements
        End Get
    End Property
#End Region


    Private _dbConn As MsSQLDatabase.MsSQLClass
    Private _strConn As String
    Private _emailEmgagements As List(Of Dictionary(Of String, Object))

    Public LatestDeployed As New Dictionary(Of String, Object)

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

        _emailEmgagements = _eLib.GetEngagementOverTime("rpt.sp_Engagement_Over_Time")
        If _eLib.HasError Then
            HasError = True
            ErrorMMsg = _eLib.ErrorMsg
        End If

        _eLib.Dispose()

    End Sub
End Class
