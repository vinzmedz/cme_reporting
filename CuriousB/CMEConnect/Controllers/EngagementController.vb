Imports System.Net
Imports System.Web.Http

Public Class EngagementController
    Inherits Controller

    Function Index() As ActionResult
        Dim reportsb As OtherReportsModels = New OtherReportsModels

        ViewData("SideDash") = "parent"
        ViewData("SideReports") = "parent active"
        ViewData("IsDashCollapse") = ""
        ViewData("IsCollapse") = " in"
        Return View(reportsb)
    End Function

    Function ICluster() As ActionResult
        Dim clustering As InitialClusteringModel = New InitialClusteringModel

        ViewData("SideDash") = "parent"
        ViewData("SideReports") = "parent active"
        ViewData("IsDashCollapse") = ""
        ViewData("IsCollapse") = " in"

        Return View(clustering)
    End Function

    Function Aggregate() As ActionResult
        Dim devicessb As AggregateModel = New AggregateModel

        ViewData("SideDash") = "parent"
        ViewData("SideReports") = "parent active"
        ViewData("IsDashCollapse") = ""
        ViewData("IsCollapse") = " in"

        Return View(devicessb)
    End Function

    Function Others() As ActionResult
        Dim otherssb As EmailEngagementModel = New EmailEngagementModel

        ViewData("DateFormat") = DateTime.Now.AddDays(-1).ToString("dd-MMM-yyyy h:m:s")
        ViewData("DateTime") = Url.Content("~/Home/Others")

        ViewData("SideDash") = "parent"
        ViewData("SideReports") = "parent active"
        ViewData("IsDashCollapse") = ""
        ViewData("IsCollapse") = " in"

        Return View(otherssb)
    End Function

    Function LatestDeployment() As ActionResult
        Dim latestm As LatestDeploymentModel = New LatestDeploymentModel

        ViewData("SideDash") = "parent"
        ViewData("SideReports") = "parent active"
        ViewData("IsDashCollapse") = ""
        ViewData("IsCollapse") = " in"

        Return View(latestm)
    End Function

    Function EmailPreview(ByVal CommLog As String) As String
        Dim el As CuriousBLib.EngagementLib = New CuriousBLib.EngagementLib

        Return el.GetEmailContent(CommLog)
    End Function

End Class
