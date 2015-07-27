<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Cme.Master" Inherits="System.Web.Mvc.ViewPage(of CMEConnect.EmailEngagementModel)" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
Others
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
		<div class="col-lg-12">
			<h3 class="page-header">Deployed Over Received Emails</h3>
            <p><%If Model.HasError Then
                       Response.Write(Model.ErrorMMsg)
                End If%></p>
		</div>
	</div><!--/.row-->

    <div class="row">
		<div class="col-lg-12">
            <div class="panel panel-blue">
                <div class="panel-body">
                    <div class="engagement-chart">
					    <table data-toggle="table">
						    <thead>
						        <tr>
						            <th></th>
						            <th>CommLog</th>
						            <th data-field="name">Name</th>
						            <th data-field="deployed">Total Deployed</th>
						            <th data-field="received">Total Received</th>
                                    <th data-field="datedeployed">Date Deployed</th>
						        </tr>
						    </thead>
                            <tbody>
                                <%For Each rowList In Model.EmailsSent%>
                                <tr>
                                    <td><%=rowList("Seq")%></td>
                                    <td><%=rowList("CommLog")%></td>
                                    <td><%=rowList("Name")%></td>
                                    <td><%=rowList("NumDeployed")%></td>
                                    <td><%=rowList("NumReceived")%></td>
                                    <td><%=rowList("DateDeployed")%></td>
                                </tr>
                                <%Next%>
                            </tbody>
                        </table>
                    </div>
                </div> 
            </div> 
		</div>
	</div><!--/.row-->

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="CSSContent" runat="server">
    <link href="<%= Url.Content("~/Content/bootstrap.min.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/datepicker3.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/bootstrap-table.css")%>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/styles.css") %>" rel="stylesheet">

    <!--[if lt IE 9]>
        <script src="<%= Url.Content("~/Scripts/html5shiv.js")%>"></script>
        <script src="<%= Url.Content("~/Scripts/respond.min.js")%>"></script>
    <![endif]-->
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="BreadcrumbContent" runat="server">
    <ol class="breadcrumb">
		<li><a href="#"><span class="glyphicon glyphicon-home"></span></a></li>
		<li class="active">Others</li>
	</ol>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsSection" runat="server">
    <script src="<%= Url.Content("~/Scripts/jquery-1.7.1.min.js")%>"></script>
	<script src="<%= Url.Content("~/Scripts/bootstrap.min.js")%>"></script>
	<script src="<%= Url.Content("~/Scripts/bootstrap-table.js")%>"></script>
</asp:Content>
