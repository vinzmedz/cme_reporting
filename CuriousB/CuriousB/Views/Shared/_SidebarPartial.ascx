<%@ Control Language="VB" Inherits="System.Web.Mvc.ViewUserControl" %>
<div id="sidebar-collapse" class="col-sm-3 col-lg-2 sidebar">
	<ul class="nav menu">
		<li<%=ViewData("SideDash")%>><a href="<%= Url.Content("~/Home/Index")%>"><span class="glyphicon glyphicon-dashboard"></span> Dashboard</a></li>
		<li class="<%=ViewData("SideReports")%>">
			<a href="<%= Url.Content("~/Home/Reports")%>">
                <span class="glyphicon glyphicon-list"></span> Email Engagement Reports <span data-toggle="collapse" href="#sub-item-1" class="icon pull-right"><em class="glyphicon glyphicon-s glyphicon-plus"></em></span> 
			</a>
            <ul class="children collapse<%=ViewData("IsCollapse")%>" id="sub-item-1">
                <li><a href="<%= Url.Content("~/Home/Reports")%>"><span class="glyphicon glyphicon-list"></span> Email Engagement</a></li>
                <li><a href="<%= Url.Content("~/Home/ICluster")%>"><span class="glyphicon glyphicon-list"></span> Initial Clustering</a></li>
                <li><a href="<%= Url.Content("~/Home/Aggregate")%>"><span class="glyphicon glyphicon-list"></span> Aggregate Reports</a></li>
                <li><a href="<%= Url.Content("~/Home/LatestDeployment")%>"><span class="glyphicon glyphicon-list"></span> Latest Deployment</a></li>
                <li><a href="<%= Url.Content("~/Home/Others")%>"><span class="glyphicon glyphicon-list"></span> Others</a></li>
            </ul>
        </li>
	</ul>
</div><!--/.sidebar-->
