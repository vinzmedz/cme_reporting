<%@ Control Language="VB" Inherits="System.Web.Mvc.ViewUserControl" %>
<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#sidebar-collapse">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="#"><img src="<%: Url.Content("~/Images/cme-connect-logo.png")%>" alt="Email Engagement" /></a>
			<ul class="user-menu">
                <% If ViewData("loggedIn") then %>
				    <li class="dropdown pull-right">
					    <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-user"></span> User <span class="caret"></span></a>
					    <ul class="dropdown-menu" role="menu">
						        <li><a href="#"><span class="glyphicon glyphicon-user"></span> Profile</a></li>
						        <li><a href="#"><span class="glyphicon glyphicon-cog"></span> Settings</a></li>
						        <li><a href="#"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
					    </ul>
				    </li>
                <% Else%>
                    <li><a href="Account/Login"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
                <% End If%>
			</ul>
		</div>
							
	</div><!-- /.container-fluid -->
</nav>