<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Cme.Master" Inherits="System.Web.Mvc.ViewPage(of CMEConnect.OtherReportsModels)" %>
<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="reportsTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Engagement Over Time Reports
</asp:Content>

<asp:Content ID="reportsMain" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
		<div class="col-lg-12">
			<h3 class="page-header">Email Engagement Reports</h3>
            <%=Model.DebugMsg%>
            <p><%If Model.HasError Then
                       Response.Write(Model.ErrorMMsg)
                End If%></p>
		</div>
	</div><!--/.row-->

    <div class="row">
		<div class="col-lg-12">
            <div class="panel panel-blue">
                <div class="panel-heading"><span title="Taken from stored procedure sp_CommunicationHistory.">Communication History</span></div>
                <div class="panel-body">
                    <div class="engagement-chart">
                        <p>
                            <%=Model.ChartDesc%>
                            <%--This report explores where communications are working and which messages are suited to each audience. --%>
                        </p>
					    <table data-toggle="table" data-sort-name="dated" data-sort-order="desc">
						    <thead>
						    <tr>
						        <th data-field="low" data-align="left" data-sortable="true">Name</th>
						        <th data-field="dated" data-align="center" data-sortable="true" data-sorter="dateSorter">Date Deployed</th>
						        <th data-field="medium" data-align="center" data-sortable="true" data-sorter="vinzSorter">Audience</th>
						        <th data-field="high" data-align="center" data-sortable="true" data-sorter="percentSorter">Open Rate</th>
						        <th data-field="total" data-align="center" data-sortable="true" data-sorter="percentSorter">Click Rate</th>
						        <th data-field="preview" data-align="center">Preview</th>
						    </tr>
						    </thead>
                            <tbody>
                                <%For Each eeList In Model.EmailCurrentState%>                                    
                                <tr>
                                    <td><span title="<%=eeList("Name").ToString%>"><%=eeList("Name")%></span></td>
                                    <td><%=eeList("DateDeployed").ToString%></td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0:0,0}", eeList("Deployed"))%></td>
                                    <td class="dashTotal"><%=eeList("OpenRate")%></td>
                                    <td><%=eeList("ClickRate")%></td>
                                    <td>
				                        <a id='commLog_<%=eeList("CommLog")%>' class="email-preview" href="#" title="View Email">
					                        <i class="glyphicon glyphicon-envelope"></i>
				                        </a>
                                    </td>
                                </tr>
                                <%Next%>
                            </tbody>
					    </table>
                    </div>
                </div>
            </div> 
        </div>
    </div>

    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-blue">
                <div class="panel-heading"><span title="Taken from stored procedure sp_EngagementOverTime.">Engagement Over Time</span>
		            <div class="columns btn-group pull-right">
			            <div class="columns btn-group pull-right">
				            <button id="showGrid" class="grid_hidden btn btn-default" type="button" name="toggle" title="Toggle">
					            <i class="glyphicon glyphicon glyphicon-list-alt icon-list-alt"></i>
				            </button>
		                </div>
                    </div>
                </div>
                <div class="panel-body">
                    <div id="engagement_chart" class="engagement-chart" style="position:relative;">
                        <p>
                            The calculation behind this is quite complicated but the result is a measure of not just how many people are on the database, but how engaged each of them is.
                        </p>
					    <%--<div id="barChart" style="width: 100%; height: 500px;"></div>--%>
                        <div class="margin-30"></div>
					    <div id="areaChart" style="width: 100%; height: 300px;"></div>
                        <div id="chartTooltip" style="position: absolute; z-index: 99; display: none;"></div>

                        <%
                            Dim cnt As Integer = 1
                            Dim dataLow As String = ""
                            Dim dataMid As String = ""
                            Dim dataHi As String = ""
                            Dim totLow As String = ""
                            Dim totMid As String = ""
                            Dim totHi As String = ""
                            Dim dataTicks As String = ""
                            Dim comma As String = ""
        
                            For Each rowList In Model.EmailEngagements
                                If cnt > 1 Then
                                    comma = ","
                                End If

                                dataLow = dataLow & comma & rowList("Low")
                                dataMid = dataMid & comma & rowList("Medium")
                                dataHi = dataHi & comma & rowList("High")
                                totLow = totLow & comma & rowList("TotalLow")
                                totMid = totMid & comma & rowList("TotalMedium")
                                totHi = totHi & comma & rowList("TotalHigh")
            
                                dataTicks = dataTicks & comma & "'" & rowList("WeekRange") & "'"
            
                                cnt = cnt + 1
                            Next
                        %>
                        <script type="text/javascript">
                            var s1 = [<%=dataLow%>]
                            var s2 = [<%=dataMid%>];
                            var s3 = [<%=dataHi%>];

                            var a1 = [<%=totLow%>]
                            var a2 = [<%=totMid%>];
                            var a3 = [<%=totHi%>];

                            var chartTicks = [<%=dataTicks%>];
                        </script>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="EngagementOverTime" class="row" style="display:none">
        <div class="col-lg-12">
            <div class="panel panel-blue">
                <div class="panel-heading"><span title="Taken from stored procedure sp_EngagementOverTime.">Engagement Over Time (Table View)</span></div>
                <div class="panel-body">
                    <div class="engagement-chart">
					    <table data-toggle="table" data-height="300" data-sort-name="WeekRange" data-sort-order="asc">
						    <thead>
						    <tr>
						        <th data-field="WeekRange" data-align="left" data-sortable="true" data-sorter="dateLabelSorter">Week Range</th>
						        <th data-field="Dormant" data-align="center" data-sortable="true" data-formatter="numberFormatter" data-sorter="vinzSorter">Dormant</th>
						        <th data-field="Low" data-align="center" data-sortable="true" data-sorter="percentSorter">Low</th>
						        <th data-field="Medium" data-align="center" data-sortable="true" data-sorter="percentSorter">Medium</th>
						        <th data-field="High" data-align="center" data-sortable="true" data-sorter="percentSorter">High</th>
                                <th data-field="Total" data-align="center" data-sortable="true" data-sorter="vinzSorter">Total</th>
						    </tr>
						    </thead>
                            <tbody>
                                <%  
                                    cnt = 1
                                    For Each ecList In Model.EmailEngagements
                                %>
                                <tr>
                                    <td><span style="display:none"><% Response.Write(ecList("Seq") & ". ") %></span>
                                        <%=ecList("WeekRange")%>
                                    </td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0:0,0}", ecList("Dormant"))%></td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0:0}%", ecList("Low"))%></td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0:0}%", ecList("Medium"))%></td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0:0}%", ecList("High"))%></td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0:0,0}", ecList("TotalCount"))%></td>
                                </tr>
                                <% 
                                    cnt = cnt + 1
                                Next%>
                            </tbody>
					    </table>
                    </div>
                </div>
            </div> 
        </div> 
    </div> 

</asp:Content>

<asp:Content ID="reportsCSS" ContentPlaceHolderID="CSSContent" runat="server">
    <link href="<%= Url.Content("~/Content/bootstrap.min.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/jquery.dataTables.css")%>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/bootstrap-table.css")%>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/jquery.jqplot.min.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/styles.css") %>" rel="stylesheet">
    
    <!--[if lt IE 9]>
        <script src="<%= Url.Content("~/Scripts/html5shiv.js")%>"></script>
        <script src="<%= Url.Content("~/Scripts/respond.min.js")%>"></script>
    <![endif]-->
</asp:Content>

<asp:Content ID="reportsBreadcrumb" ContentPlaceHolderID="BreadcrumbContent" runat="server">
    <ol class="breadcrumb">
		<li><a href="#"><span class="glyphicon glyphicon-home"></span></a></li>
		<li class="active">Reports</li>
	</ol>
</asp:Content>

<asp:Content ID="reportsFooter" ContentPlaceHolderID="FooterContent" runat="server">

    <div class="modal" id="emailPreviewModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		<div class="modal-dialog modal-lg">
		    <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="myModalLabel"></h4>
                </div>
                <div class="modal-body">
                    <iframe id="emailFrame" name="emailFrame"></iframe>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="reportsScripts" ContentPlaceHolderID="ScriptsSection" runat="server">
    <script src="<%= Url.Content("~/Scripts/jquery-1.7.1.min.js")%>"></script>
	<script src="<%= Url.Content("~/Scripts/bootstrap.min.js")%>"></script>
	<script src="<%= Url.Content("~/Scripts/bootstrap-table.js")%>"></script>

    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jquery.dataTables.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/jquery.jqplot.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.canvasTextRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.canvasAxisTickRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.categoryAxisRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.barRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.pointLabels.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.highlighter.min.js")%>"></script>
    
    <script type="text/javascript">
        $(document).ready(function () {
            $('#emailPreviewModal').modal('hide');

            $.jqplot.sprintf.thousandsSeparator = ',';

            var data = [s1, s2, s3];
            plotAreaChart('areaChart',data, chartTicks);

            var seriesL = [
                    { label: 'Low' },
                    { label: 'Medium' },
                    { label: 'Hi' }
            ];
            //plotBarChart('barChart', s1, s2, s3, chartTicks, seriesL, '%d\%', a1, a2, a3);

            $('#showGrid').click(function () {
                //var str = "showGrid";
                //alert( str.search );
                if ($('#showGrid').hasClass('grid_hidden')) {
                    $('#showGrid').addClass('grid_shown').removeClass('grid_hidden');
                    $('#EngagementOverTime').show();
                }
                else {
                    $('#EngagementOverTime').hide();
                    $('#showGrid').addClass('grid_hidden').removeClass('grid_shown');
                }

            });

            $('[id^="commLog_"]').click(function (event) {

                var cl = $(this).attr('id').substring(8);
                var ajax_url = '<%= Url.Content("~/Engagement/EmailPreview")%>';

                data = {
                    "CommLog": cl
                };

                $.post(ajax_url, data, function (svc_response) {

                    var emailFrame = document.getElementById("emailFrame");
                    var emailDoc = emailFrame.document;

                    if (emailFrame.contentWindow)
                        emailDoc = emailFrame.contentWindow.document;

                    emailDoc.open();
                    emailDoc.writeln(svc_response);
                    emailDoc.close();


                    $('#emailPreviewModal').modal({
                        show: true,
                    });

                }, "html").fail(function (jqXHR, textStatus, errorThrown) {

                    alert(textStatus + ": " + errorThrown);

                });
            });

        });

        $(window).on('resize', function () {
            $('#areaChart').html('');

            var data = [s1, s2, s3];
            plotAreaChart('areaChart', data, chartTicks);

            var seriesL = [
                    { label: 'Low' },
                    { label: 'Medium' },
                    { label: 'Hi' }
            ];

            if ($(window).width() > 768) $('#sidebar-collapse').collapse('show')
            if ($(window).width() <= 767) $('#sidebar-collapse').collapse('hide')
        })

        function plotAreaChart(cont, data, ticks) {
            var plot1b = $.jqplot(cont, data, {
                stackSeries: true,
                showMarker: false,
                seriesDefaults: {
                    fill: true
                },
                axesDefaults: {
                    tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                    tickOptions: {
                        fontSize: '7pt',
                    }
                },
                axes: {
                    xaxis: {
                        renderer: $.jqplot.CategoryAxisRenderer,
                        ticks: ticks,
                        tickOptions: {
                            angle: -45
                        }
                    },
                    yaxis: {
                        min: 0,
                        max: 100,
                        tickOptions: { formatString: '%d', formatter: $.jqplot.numFormatter }
                    }
                }
            });

        }

        function vinzSorter(a, b) {
            a = +a.replace(",", ""); // remove ,
            b = +b.replace(",", "");
            if (a > b) return 1;
            if (a < b) return -1;
            return 0;
        }

        function percentSorter(a, b) {
            a = +a.substring(1, a.length-1); // remove %
            b = +b.substring(1, a.length-1);
            if (a > b) return 1;
            if (a < b) return -1;
            return 0;
        }
        function numberFormatter(value) {
            if (value == '00')
                return '0'
            else
                return value;
        }

        function dateSorter(a, b) {

            if (new Date(a).getTime() > new Date(b).getTime()) return 1;
            if (new Date(a).getTime() < new Date(b).getTime()) return -1;
            return 0;
        }

        function dateLabelSorter(a, b) {
            tmp_a = a.trim();
            tmp_b = b.trim();

            tmp_a = tmp_a.replace('<span style="display:none">', '').replace('</span>', '');
            tmp_b = tmp_b.replace('<span style="display:none">', '').replace('</span>', '');

            a = +tmp_a.substring(0, tmp_a.search('. ')).trim();
            b = +tmp_b.substring(0, tmp_b.search('. ')).trim();

            if (a > b) return 1;
            if (a < b) return -1;
            return 0;
        }
    </script>

</asp:Content>

