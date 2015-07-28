<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Cme.Master" Inherits="System.Web.Mvc.ViewPage(of CMEConnect.InitialClusteringModel)" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Email Engagements Initial Clustering - New Zealand Rugby
</asp:Content>

<asp:Content ID="ClusteringContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
		<div class="col-lg-12">
			<h3 class="page-header"><span title="Taken from stored procedure sp_Initial_Clustering.">Initial Clustering Report</span></h3>
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
                        <%--Cluster, Clicked, Opened, Age, Female--%>
					    <table data-toggle="table">
						    <thead>
						        <tr>
						            <th></th>
						            <th data-field="Cluster_1" data-align="center">Cluster 1</th>
						            <th data-field="Cluster_2" data-align="center">Cluster 2</th>
						            <th data-field="Cluster_3" data-align="center">Cluster 3</th>
						            <th data-field="Cluster_4" data-align="center">Cluster 4</th>
						            <th data-field="Cluster_5" data-align="center">Cluster 5</th>
						            <th data-field="Cluster_6" data-align="center">Cluster 6</th>
						        </tr>
						    </thead>
                            <tbody>
                                <%For Each rowList In Model.EmailInitialCluster%>
                                <tr>
                                    <td><%=CMEConnect.cbHelpers.ClusterName(rowList("Name"))%></td>
                                    <td><%=rowList("Cluster_1")%></td>
                                    <td><%=rowList("Cluster_2")%></td>
                                    <td><%=rowList("Cluster_3")%></td>
                                    <td><%=rowList("Cluster_4")%></td>
                                    <td><%=rowList("Cluster_5")%></td>
                                    <td><%=rowList("Cluster_6")%></td>
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
        <li class="active">Initial Clustering</li>
	</ol>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsSection" runat="server">
    <script src="<%= Url.Content("~/Scripts/jquery-1.7.1.min.js")%>"></script>
	<script src="<%= Url.Content("~/Scripts/bootstrap.min.js")%>"></script>
	<script src="<%= Url.Content("~/Scripts/bootstrap-table.js")%>"></script>
</asp:Content>
