<%@ Control Language="VB" Inherits="System.Web.Mvc.ViewUserControl" %>
<div id="sidebar-collapse" class="col-sm-3 col-lg-2 sidebar">
	<ul class="nav menu">
		<li class="<%=ViewData("SideDash")%>">
            <a href="#">
                <span class="glyphicon glyphicon-dashboard"></span> Dashboards <span data-toggle="collapse" href="#dashboard-1" class="icon pull-right"><em class="glyphicon glyphicon-s glyphicon-plus"></em></span> 
            </a>
            <ul class="children collapse<%=ViewData("IsDashCollapse")%>" id="dashboard-1">
                <li><a href="<%= Url.Content("~/Dashboard/Index")%>"><span class="dash-menu">Single deployment drill down</span></a></li>
                <li><a href="<%= Url.Content("#")%>"><span class="dash-menu">Which content is effective?</span></a></li>
                <li><a href="<%= Url.Content("#")%>"><span class="dash-menu">Users are we engaging successfully</span></a></li>
                <li><a href="<%= Url.Content("~/Dashboard/Hidden")%>"><span class="dash-menu">Hidden Charts</span></a></li>
            </ul>
        </li>
		<li class="<%=ViewData("SideReports")%>">
			<a href="#">
                <span class="glyphicon glyphicon-list"></span> Email Engagement Reports <span data-toggle="collapse" href="#sub-item-1" class="icon pull-right"><em class="glyphicon glyphicon-s glyphicon-plus"></em></span> 
			</a>
            <ul class="children collapse<%=ViewData("IsCollapse")%>" id="sub-item-1">
                <li><a href="<%= Url.Content("~/Engagement/Index")%>"><span class="glyphicon glyphicon-list"></span> Email Engagement</a></li>
                <li><a href="<%= Url.Content("~/Engagement/ICluster")%>"><span class="glyphicon glyphicon-list"></span> Initial Clustering</a></li>
                <li><a href="<%= Url.Content("~/Engagement/Aggregate")%>"><span class="glyphicon glyphicon-list"></span> Aggregate Reports</a></li>
                <li><a href="<%= Url.Content("~/Engagement/LatestDeployment")%>"><span class="glyphicon glyphicon-list"></span> Latest Deployment</a></li>
            </ul>
        </li>
	</ul>
</div><!--/.sidebar-->
