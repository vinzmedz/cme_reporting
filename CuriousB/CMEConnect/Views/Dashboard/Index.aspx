<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Cme.Master" Inherits="System.Web.Mvc.ViewPage(of CMEConnect.DashboardModel)" %>
<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="indexTitle" ContentPlaceHolderID="TitleContent" runat="server">
    CME Connect - Dashboard
</asp:Content>

<asp:Content ID="indexMain" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
		<div class="col-lg-12">
			<h3 class="page-header">Email Engagement Dashboard</h3>
            <p><%
                   
                   'Response.Write(Model.LatestDeployed("DateText"))
                   If Model.HasError Then
                       Response.Write(Model.ErrorMMsg)
                   End If%></p>
		</div>
	</div>

    <div class="row">
        <div class="col-lg-12">
            <div class="panel">
                <div class="panel-heading panel-blue">Latest Deployment: <span title="Taken from stored procedure sp_GetEventsSummary."><strong><%=Model.LatestDeployed("CommLogName")%></strong></span>
		            <div class="columns btn-group pull-right">
			            <div class="columns btn-group pull-right">
				            <button id="viewEmail" class="btn btn-default" type="button" title="View Email">
					            <i class="glyphicon glyphicon-envelope"></i>
				            </button>
		                </div>
                    </div>
                </div>
                <div class="panel-body">
                    <div class="engagement-chart">
		                <div class="col-xs-12 col-md-6 col-lg-3">
			                <div class="panel panel-blue panel-widget ">
				                <div class="row no-padding">
					                <div class="col-sm-3 col-lg-4 widget-left">
						                <em class="glyphicon glyphicon glyphicon-send glyphicon-l"></em>
					                </div>
					                <div class="col-sm-9 col-lg-8 widget-right">
						                <div class="large"><%=String.Format(CultureInfo.InvariantCulture, "{0:0,0}", Model.LatestDeployed("Deployed"))%></div>
						                <div class="text-muted">
                                            Deployed<br />
                                            <%=Model.LatestDeployed("DeployDate")%>
						                </div>
					                </div>
				                </div>
			                </div>
		                </div>
		                <div class="col-xs-12 col-md-6 col-lg-3">
			                <div class="panel panel-teal panel-widget">
				                <div class="row no-padding">
					                <div class="col-sm-3 col-lg-4 widget-left">
						                <em class="glyphicon glyphicon-folder-open glyphicon-l"></em>
					                </div>
					                <div class="col-sm-9 col-lg-7 widget-right">
						                <div class="large dashTotal"><%=Model.LatestDeployed("Opened")%>%
                                            <%  Dim icon_css As String = ""
                                                If Model.LatestDeployed("ExpectedOpenRate") < Model.LatestDeployed("Opened") Then
                                                    icon_css = "exptd-hi glyphicon glyphicon-circle-arrow-up"
                                                Else
                                                    icon_css = "exptd-low glyphicon glyphicon-circle-arrow-down"
                                                End If%>
                                                <div class="dashExpctd"><span class="<%=icon_css%>" title="Expected open rate is <%=Model.LatestDeployed("ExpectedOpenRate")%>%"></span></div>                                          
                                                                                
                                            <%  icon_css = ""
                                                If Model.LatestDeployed("OpenRank") = "High" Then
                                                    icon_css = "rank-hi glyphicon glyphicon-circle-arrow-up"
                                                Else
                                                    icon_css = "rank-low glyphicon glyphicon-circle-arrow-down"
                                                                                                          End If%>
                                                <div class="dashRank"><span class="<%=icon_css%>" title="Previous open rate is <%=Model.LatestDeployed("PrevOpened")%>%"></span></div>
						                </div>
						                <div class="text-muted">Opened<br />Total: <%=String.Format(CultureInfo.InvariantCulture, "{0:0,0}", Model.LatestDeployed("TotalOpened"))%></div>
					                </div>
				                </div>
			                </div>
		                </div>
		                <div class="col-xs-12 col-md-6 col-lg-3">
			                <div class="panel panel-red panel-widget">
				                <div class="row no-padding">
					                <div class="col-sm-3 col-lg-4 widget-left">
						                <em class="glyphicon glyphicon-save glyphicon-l"></em>
					                </div>
					                <div class="col-sm-9 col-lg-7 widget-right">
						                <div class="large dashTotal"><%=Model.LatestDeployed("Clicked")%>%
                                            <%If Model.LatestDeployed("ClickRank") = "High" Then%>
                                                <div class="dashRank"><span class="rank-hi glyphicon glyphicon-circle-arrow-up" title="Previous click rate is <%=Model.LatestDeployed("PrevClicked")%>%"></span></div>
                                            <%Else%>
                                                <div class="dashRank"><span class="rank-low glyphicon glyphicon-circle-arrow-down" title="Previous click rate is <%=Model.LatestDeployed("PrevClicked")%>%"></span></div>
                                            <%End If%>
						                </div> 
						                <div class="text-muted">Clicked<br />Total: <%=String.Format(CultureInfo.InvariantCulture, "{0:0,0}", Model.LatestDeployed("TotalClicked"))%></div>
					                </div>
				                </div>
			                </div>
		                </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-blue">
                <div class="panel-heading"><span title="Taken from stored procedure sp_EngagementOverTime.">Engagement Over Time Stacked Bar Chart</span>
		            <div class="columns btn-group pull-right">
			            <div class="columns btn-group pull-right">
				            <button id="showGrid" class="grid_hidden btn btn-default" type="button" title="Show Table View">
					            <i class="glyphicon glyphicon-list-alt icon-list-alt"></i>
				            </button>
		                </div>
                    </div>
                </div>
                <div class="panel-body">
                    <div id="engagement_chart" class="engagement-chart" style="position:relative;">
                        <p>
                            <%=Model.ChartDesc%>
                        </p>
                        <div><span>Events: </span><span id="info1">Nothing yet</span></div>                        
					    <div id="barChart" style="width: 100%; height: 500px;"></div>
                        <div id="chartTooltip" style="position: absolute; z-index: 99; display: none;"></div>
                        <% 
                            Dim cnt As Integer = 1
                            Dim dataLow As String = ""
                            Dim dataMed As String = ""
                            Dim dataHi As String = ""
                            Dim totLow As String = ""
                            Dim totMed As String = ""
                            Dim totHi As String = ""
                            Dim dataTicks As String = ""
                            Dim comma As String = ""
        
                            For Each rowList In Model.EmailEngagements
                                If cnt > 1 Then
                                    comma = ","
                                End If

                                dataLow = dataLow & comma & rowList("Low")
                                dataMed = dataMed & comma & rowList("Medium")
                                dataHi = dataHi & comma & rowList("High")
                                totLow = totLow & comma & rowList("TotalLow")
                                totMed = totMed & comma & rowList("TotalMedium")
                                totHi = totHi & comma & rowList("TotalHigh")
                                dataTicks = dataTicks & comma & "'" & rowList("WeekRange") & "'"
            
                                cnt = cnt + 1
                            Next
                        %>
                        <script type="text/javascript">
                            var s1 = [<%=dataLow%>]
                            var s2 = [<%=dataMed%>];
                            var s3 = [<%=dataHi%>];
                            var m1 = [<%=totLow%>]
                            var m2 = [<%=totMed%>];
                            var m3 = [<%=totHi%>];
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
                <div class="panel-heading">Engagement Over Time Table View</div>
                <div class="panel-body">
                    <div class="engagement-chart">
					    <table class="table-hover" data-toggle="table" data-height="300" data-sort-name="WeekRange" data-sort-order="desc">
						    <thead>
						    <tr>
						        <th data-field="WeekRange" data-align="left" data-sortable="true">Week Range</th>
						        <th data-field="Dormant" data-align="center" data-sortable="true" data-formatter="numberFormatter" data-sorter="vinzSorter">Dormant</th>
						        <th data-field="Low" data-align="center" data-sortable="true" data-sorter="percentSorter">Low</th>
						        <th data-field="Medium" data-align="center" data-sortable="true" data-sorter="percentSorter">Medium</th>
						        <th data-field="High" data-align="center" data-sortable="true" data-sorter="percentSorter">High</th>
                                <th data-field="Total" data-align="center" data-sortable="true" data-sorter="vinzSorter">Total</th>
						    </tr>
						    </thead>
                            <tbody>
                                <% For Each ecList In Model.EmailEngagements%>
                                <tr>
                                    <td><%=ecList("WeekRange")%></td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0:0,0}", ecList("Dormant"))%></td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0:0}%", ecList("Low"))%></td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0:0}%", ecList("Medium"))%></td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0:0}%", ecList("High"))%></td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0:0,0}", ecList("TotalCount"))%></td>
                                </tr>
                                <%Next%>
                            </tbody>
					    </table>
                    </div>
                </div>
            </div> 
        </div> 
    </div>

</asp:Content>

<asp:Content ID="indexCSSContent" ContentPlaceHolderID="CSSContent" runat="server">
    <link href="<%= Url.Content("~/Content/bootstrap.min.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/bootstrap-table.css")%>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/jquery.jqplot.min.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/styles.css") %>" rel="stylesheet">


    <!--[if lt IE 9]>
        <script src="<%= Url.Content("~/Scripts/html5shiv.js")%>"></script>
        <script src="<%= Url.Content("~/Scripts/respond.min.js")%>"></script>
    <![endif]-->
</asp:Content>

<asp:Content ID="indexBreadcrumb" ContentPlaceHolderID="BreadcrumbContent" runat="server">
    <ol class="breadcrumb">
		<li><a href="#"><span class="glyphicon glyphicon-home"></span></a></li>
		<li class="active">Dashboard</li>
	</ol>
</asp:Content>

<asp:Content ID="indexFooter" ContentPlaceHolderID="FooterContent" runat="server">

    <div class="modal" id="emailPreviewModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		<div class="modal-dialog modal-lg">
		    <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="myModalLabel"><%=Model.LatestDeployed("CommLogName")%></h4>
                </div>
                <div class="modal-body">
                    <div id="emailContent" style="display:none"><%=Model.LatestDeployed("EmailPreview")%></div>
                    <iframe id="emailFrame" name="emailFrame"></iframe>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="indexScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">

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
            $.jqplot.numFormatter = function (format, val) {
                if (!format) {
                    format = '%.1f';
                }
                return numberWithCommas($.jqplot.sprintf(format, val));
            };

            var seriesL = [
                    { label: 'Low' },
                    { label: 'Medium' },
                    { label: 'Hi' }
            ];

            $.jqplot.sprintf.thousandsSeparator = ',';

            plotStackedBarChart('barChart', [s1, s2, s3], chartTicks, seriesL, '%d\%', [m1, m2, m3]);


            $('#emailPreviewModal').modal('hide');

            $('#viewEmail').click(function () {
                var content = document.getElementById("emailContent").innerHTML;
                var emailFrame = document.getElementById("emailFrame");
                var emailDoc = emailFrame.document;

                if (emailFrame.contentWindow)
                    emailDoc = emailFrame.contentWindow.document;

                emailDoc.open();
                emailDoc.writeln(content);
                emailDoc.close();

                $('#emailPreviewModal').modal({
                    show: true,
                });
            });

            $('#showGrid').click(function () {
                if ($('#showGrid').hasClass('grid_hidden')) {
                    $('#showGrid').addClass('grid_shown').removeClass('grid_hidden');
                    $('#EngagementOverTime').show();
                }
                else {
                    $('#EngagementOverTime').hide();
                    $('#showGrid').addClass('grid_hidden').removeClass('grid_shown');
                }

            });

        });

        $(window).on('resize', function () {
            $('#barChart').html('');

            var seriesL = [
                    { label: 'Low' },
                    { label: 'Medium' },
                    { label: 'Hi' }
            ];

            plotStackedBarChart('barChart', [s1, s2, s3], chartTicks, seriesL, '%d\%', [m1, m2, m3]);

            if ($(window).width() > 768) $('#sidebar-collapse').collapse('show')
            if ($(window).width() <= 767) $('#sidebar-collapse').collapse('hide')
        })

        function plotStackedBarChart(cont, data, chartTicks, seriesLabels, tickString, mdat) {

            var mdata = mdat;
            var plotc = $.jqplot(cont, data, {
                stackSeries: true,
                seriesDefaults: {
                    renderer: $.jqplot.BarRenderer,
                    rendererOptions: {
                        fillToZero: true,
                        barMargin: 30
                    }
                },
                series: seriesLabels,
                axesDefaults: {
                    tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                    tickOptions: { fontSize: '7pt' }
                },
                legend: {
                    show: true,
                    placement: 'outsideGrid'
                },
                axes: {
                    xaxis: {
                        renderer: $.jqplot.CategoryAxisRenderer,
                        ticks: chartTicks,
                        tickOptions: {
                            angle: -45
                        }
                    },
                    yaxis: {
                        min: 0,
                        max: 100,
                        tickOptions: {
                            formatString: '%d\%',
                            formatter: $.jqplot.numFormatter
                        }
                    }
                }
                //,highlighter: {
                //    show: true,
                //    tooltipContentEditor: tooltipContentEditor
                //}
            });

            $('#' + cont).bind('jqplotDataHighlight',
                function (ev, seriesIndex, pointIndex, data) {
                    var chart_left = $('.jqplot-event-canvas').offset().left;
                    var chart_top = $('.jqplot-event-canvas').offset().top;
                    var x = ev.pageX;
                    var y = ev.pageY;
                    var left = -60;
                    var top = 35;

                    //console.log("chart_left = " + chart_left);
                    if (plotc.axes.xaxis.u2p) {
                        left = left + plotc.axes.xaxis.u2p(data[0]); // convert x axis units to pixels on grid
                    }

                    if (plotc.series[0].barDirection === "vertical") left -= plotc.series[0].barWidth / 2;
                    else if (plotc.series[0].barDirection === "horizontal") top -= plotc.series[0].barWidth / 2;
                    //for stacked chart
                    var sum = 0;
                    for (var i = 0; i < seriesIndex + 1; i++)
                        sum += plotc.series[i].data[pointIndex][1];

                    top += plotc.axes.yaxis.u2p(sum); //(data[1]);
                    var seriesName = plotc.series[seriesIndex].label;

                    var chartTooltipHTML =
                                    '<table class="jqplot-highlighter">' +
                                    '   <tr><td class="jqplot-highlighter-title" colspan=2>' + plotc.options.axes.xaxis.ticks[pointIndex] + '</td></tr>' +
                                    '   <tr class="jqplot-highlighter-body"><td>' + plotc.series[seriesIndex]["label"] + '</td><td>' + data[1] + '%</td></tr>' +
                                    '   <tr class="jqplot-highlighter-body"><td>People:</td><td>' + numberWithCommas(mdata[seriesIndex][pointIndex]) + '</td></tr>' +
                                    '</table>'

                    var ct = $('#chartTooltip');
                    ct.css({
                        left: left,
                        top: top
                    }).html(chartTooltipHTML).show();

                    if (plotc.series[0].barDirection === "vertical") {
                        var totalH = ct.height();
                        ct.css({
                            top: top - totalH
                        });
                        //console.log('Top vertical: ' + top);
                    }
                }
            );

            $('#' + cont).bind('jqplotDataUnhighlight',
                function (ev) {
                    $('#chartTooltip').empty().hide();
                }
            );
        }

        function tooltipContentEditor(str, seriesIndex, pointIndex, plot) {
            // display series_label, x-axis_tick, y-axis value
            var formatted = '<table class="jqplot-highlighter">' +
                            '   <tr><td class="jqplot-highlighter-title" colspan=2>' + plot.options.axes.xaxis.ticks[pointIndex] + '</td></tr>' +
                                '<tr class="jqplot-highlighter-body"><td>' + plot.series[seriesIndex]["label"] + '</td><td>' + numberWithCommas(plot.data[seriesIndex][pointIndex]) + '</td></tr>' +
                            '</table>'
            return formatted
        }

        function numberWithCommas(x) {
            return x.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
        }

        function vinzSorter(a, b) {
            a = +a.replace(",", ""); // remove ,
            b = +b.replace(",", "");

            if (a > b) return 1;
            if (a < b) return -1;
            return 0;
        }

        function percentSorter(a, b) {
            a = +a.substring(1, a.length - 1); // remove %
            b = +b.substring(1, a.length - 1);
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

  </script>
</asp:Content>
