<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Cme.Master" Inherits="System.Web.Mvc.ViewPage(of CMEConnect.DashboardHiddenModel)" %>

<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="HiddennTitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Hidden Graphs
</asp:Content>

<asp:Content ID="HiddenMainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
		<div class="col-lg-12">
			<h3 class="page-header">Temporarily Hidden Graphs</h3>
            <%=Model.DebugMsg%>
            <p><%If Model.HasError Then
                       Response.Write(Model.ErrorMMsg)
                End If%></p>
		</div>
	</div><!--/.row-->

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
                    <div class="engagement-chart">
                        <p>
                            The calculation behind this is quite complicated but the result is a measure of not just how many people are on the database, but how engaged each of them is.
                        </p>
					    <div id="barChart" style="width: 100%; height: 300px;"></div>

                        <%
                            Dim cnt As Integer = 1
                            Dim dataLow As String = ""
                            Dim dataMid As String = ""
                            Dim dataHi As String = ""
                            Dim countLow As String = ""
                            Dim countMid As String = ""
                            Dim countHi As String = ""
                            Dim dataTicks As String = ""
                            Dim comma As String = ""
        
                            For Each rowList In Model.EmailEngagements
                                If cnt > 1 Then
                                    comma = ","
                                End If

                                dataLow = dataLow & comma & rowList("Low")
                                dataMid = dataMid & comma & rowList("Medium")
                                dataHi = dataHi & comma & rowList("High")
                                countLow = countLow & comma & rowList("TotalLow")
                                countMid = countMid & comma & rowList("TotalMedium")
                                countHi = countHi & comma & rowList("TotalHigh")
            
                                dataTicks = dataTicks & comma & "'" & rowList("WeekRange") & "'"
            
                                cnt = cnt + 1
                            Next
                        %>
                        <script type="text/javascript">
                            var s1 = [<%=dataLow%>]
                            var s2 = [<%=dataMid%>];
                            var s3 = [<%=dataHi%>];

                            var a1 = [<%=countLow%>]
                            var a2 = [<%=countMid%>];
                            var a3 = [<%=countHi%>];

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

<asp:Content ID="HiddenCSSContent" ContentPlaceHolderID="CSSContent" runat="server">
    <link href="<%= Url.Content("~/Content/bootstrap.min.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/bootstrap-table.css")%>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/jquery.jqplot.min.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/styles.css") %>" rel="stylesheet">

    <!--[if lt IE 9]><script language="javascript" type="text/javascript" src="<%= Url.Content("~/Scripts/excanvas.js")%>"></script><![endif]-->
</asp:Content>

<asp:Content ID="HiddenBreadcrumbContent" ContentPlaceHolderID="BreadcrumbContent" runat="server">
    <ol class="breadcrumb">
		<li><a href="#"><span class="glyphicon glyphicon-home"></span></a></li>
		<li class="active">Dashboard</li>
	</ol>
</asp:Content>

<asp:Content ID="HiddenFooterContent" ContentPlaceHolderID="FooterContent" runat="server">
</asp:Content>

<asp:Content ID="HiddenScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">

    <script src="<%= Url.Content("~/Scripts/jquery-1.7.1.min.js")%>"></script>
    <script src="<%= Url.Content("~/Scripts/jquery-ui-1.8.20.min.js")%>"></script>
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
            $.jqplot.sprintf.thousandsSeparator = ',';

            var seriesL = [
                    { label: 'Low' },
                    { label: 'Medium' },
                    { label: 'Hi' }
            ];

            plotStackedBarChart('barChart', s1, s2, s3, chartTicks, seriesL, '%d\%');

        });

        $(window).on('resize', function () {
            $('#areaChart').html('');
            $('#barChart').html('');
            $('#barClicks').html('');

            var seriesL = [
                    { label: 'Low' },
                    { label: 'Medium' },
                    { label: 'Hi' }
            ];

            plotStackedBarChart('barChart', s1, s2, s3, chartTicks, seriesL, '%d\%', temp);

            if ($(window).width() > 768) $('#sidebar-collapse').collapse('show')
            if ($(window).width() <= 767) $('#sidebar-collapse').collapse('hide')
        })

        function plotStackedBarChart(cont, s1, s2, s3, ticks, seriesLabels, tickString) {
            var plotc = $.jqplot(cont, [s1, s2, s3], {
                stackSeries: true,
                seriesDefaults: {
                    renderer: $.jqplot.BarRenderer,
                    rendererOptions: {
                        fillToZero: true,
                        barMargin: 30,
                        barPadding: 2
                    }
                },
                series: seriesLabels,
                axesDefaults: {
                    tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                    tickOptions: {
                        fontFamily: 'Arial',
                        fontSize: '7pt',
                    }
                },
                legend: {
                    show: true,
                    placement: 'outsideGrid'
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
                        tickOptions: {
                            formatString: tickString,
                            formatter: $.jqplot.numFormatter
                        }
                    }
                },
                highlighter: {
                    show: true,
                    tooltipContentEditor: tooltipContentEditor
                }
            });
        }

        function tooltipContentEditor(str, seriesIndex, pointIndex, plot) {
            // display series_label, x-axis_tick, y-axis value
            var formatted = '<table class="jqplot-highlighter">' +
                            '   <tr><td class="jqplot-highlighter-title" colspan=2>' + plot.options.axes.xaxis.ticks[pointIndex] + '</td></tr>' +
                                '<tr class="jqplot-highlighter-body"><td>' + plot.series[seriesIndex]["label"] + '</td><td>' + plot.data[seriesIndex][pointIndex] + '</td></tr>' +
                            '</table>'
            return formatted
        }

    </script>
</asp:Content>
