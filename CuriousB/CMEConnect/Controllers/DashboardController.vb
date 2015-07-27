Imports System.Net
Imports System.Web.Http

Public Class DashboardController
    Inherits Controller

    Function Index() As ActionResult
        Dim dashb As DashboardModel = New DashboardModel

        ViewData("indexTitle") = "Dashboard - New Zealand Rugby"
        ViewData("loggedIn") = False
        ViewData("SideDash") = "parent active"
        ViewData("SideReports") = "parent"
        ViewData("IsDashCollapse") = " in"
        ViewData("IsCollapse") = ""

        Return View(dashb)
    End Function

    Function Hidden() As ActionResult
        Dim dashb As DashboardHiddenModel = New DashboardHiddenModel
        Dim latest As LatestDeploymentModel = New LatestDeploymentModel

        ViewData("loggedIn") = False
        ViewData("SideDash") = "parent active"
        ViewData("SideReports") = "parent"
        ViewData("IsDashCollapse") = " in"
        ViewData("IsCollapse") = ""

        Return View(dashb)
    End Function

End Class
