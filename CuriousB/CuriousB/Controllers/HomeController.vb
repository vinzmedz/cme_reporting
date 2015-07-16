
Public Class HomeController
    Inherits Controller

    Function Index() As ActionResult
        Dim dashb As DashboardModels = New DashboardModels

        'ViewData("strConn") = dashb.EmailEngagements
        ViewData("loggedIn") = False
        ViewData("Message") = "Engagement Over Time"
        ViewData("SideDash") = " class=""active"""
        ViewData("SideReports") = "parent"
        ViewData("IsCollapse") = ""

        Return View(dashb)
    End Function

    Function About() As ActionResult
        ViewData("Message") = "Your app description page."

        Return View()
    End Function

    Function Reports() As ActionResult
        Dim reportsb As OtherReportsModels = New OtherReportsModels

        ViewData("DateFormat") = DateTime.Now.AddDays(-1).ToString("dd-MMM-yyyy h:m:s")
        ViewData("DateTime") = Url.Content("~/Home/Reports")

        ViewData("SideDash") = ""
        ViewData("SideReports") = "parent active"
        ViewData("IsCollapse") = " in"
        Return View(reportsb)
    End Function

    Function ICluster() As ActionResult
        Dim clustering As InitialClusteringModel = New InitialClusteringModel

        ViewData("DateFormat") = DateTime.Now.AddDays(-1).ToString("dd-MMM-yyyy h:m:s")
        ViewData("DateTime") = Url.Content("~/Home/ICluster")

        ViewData("SideDash") = ""
        ViewData("SideReports") = "parent active"
        ViewData("IsCollapse") = " in"

        Return View(clustering)
    End Function

    Function Others() As ActionResult
        Dim otherssb As EmailEngagementModel = New EmailEngagementModel

        ViewData("DateFormat") = DateTime.Now.AddDays(-1).ToString("dd-MMM-yyyy h:m:s")
        ViewData("DateTime") = Url.Content("~/Home/Others")

        ViewData("SideDash") = ""
        ViewData("SideReports") = "parent active"
        ViewData("IsCollapse") = " in"

        Return View(otherssb)
    End Function

    Function Aggregate() As ActionResult
        Dim devicessb As AggregateModel = New AggregateModel

        ViewData("SideDash") = ""
        ViewData("SideReports") = "parent active"
        ViewData("IsCollapse") = " in"

        Return View(devicessb)
    End Function


    Function LatestDeployment() As ActionResult
        Dim latest As LatestDeploymentModel = New LatestDeploymentModel

        ViewData("SideDash") = ""
        ViewData("SideReports") = "parent active"
        ViewData("IsCollapse") = " in"

        Return View(latest)
    End Function

End Class
