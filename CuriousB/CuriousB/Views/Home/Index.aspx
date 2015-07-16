<%@ Page Title=" Dashboard - New Zealand Rugby" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(of CuriousB.DashboardModels)" %>
<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="homeTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Dashboard - New Zealand Rugby
</asp:Content>

<asp:Content ID="indexCSS" ContentPlaceHolderID="CSSContent" runat="server">
    <link href="<%= Url.Content("~/Content/bootstrap.min.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/datepicker3.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/jquery.jqplot.min.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/styles.css") %>" rel="stylesheet">

    <!--[if lt IE 9]><script language="javascript" type="text/javascript" src="<%= Url.Content("~/Scripts/excanvas.js")%>"></script><![endif]-->

</asp:Content>

<asp:Content ID="indexBreadcrumb" ContentPlaceHolderID="BreadcrumbContent" runat="server">
    <ol class="breadcrumb">
		<li><a href="#"><span class="glyphicon glyphicon-home"></span></a></li>
		<li class="active">Dashboard</li>
	</ol>
</asp:Content>

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
		<div class="col-lg-12">
			<h3 class="page-header">Email Engagement Dashboard</h3>
            <p><%
                   If Model.HasError Then
                       Response.Write(Model.ErrorMMsg)
                   End If%></p>
		</div>
	</div>
<!--/.row-->

<%--	<div class="row">
		<div class="col-lg-12">
			<h4 class="page-header">Select Date</h4>--%>
            <%--<%:Html.DropDownList("Countries", DirectCast(Model.CountryList, SelectList),  New With {.onChange = "GetBedCity();", .class = "input-block-level"})%>--%>
<%--		</div>
	</div>--%>

    <div class="row">
        <div class="col-lg-12">
            <div class="panel">
                <div class="panel-heading panel-blue">Latest Deployment: <strong><%=Model.LatestDeployed("CommLogName")%></strong></div>
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
                                            <%=Model.DeployDate%>
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
                                            <%If Model.LatestDeployed("OpenRank") = "High" Then%>
                                                <div class="dashRank"><span class="rank-hi glyphicon glyphicon-circle-arrow-up" title="Previous open rate is <%=Model.LatestDeployed("PrevOpened")%>%"></span></div>
                                            <%Else%>
                                                <div class="dashRank"><span class="rank-low glyphicon glyphicon-circle-arrow-down" title="Previous open rate is <%=Model.LatestDeployed("PrevOpened")%>%"></span></div>
                                            <%End If%>
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
                                            <%If Model.ClickRank = "High" Then%>
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
                <div class="panel-heading">Engagement Over Time Stacked Bar Chart</div>
                <div class="panel-body">
                    <div class="engagement-chart">
                        <p>
                            The calculation behind this is quite complicated but the result is a measure of not just how many people are on the database, but how engaged each of them is.
                        </p>
					    <div id="barChart" style="width: 100%; height: 500px;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="indexScriptsSection" ContentPlaceHolderID="ScriptsSection" runat="server">
    <script src="<%= Url.Content("~/Scripts/jquery-1.7.1.min.js")%>"></script>
    <script src="<%= Url.Content("~/Scripts/jquery-ui-1.8.20.min.js")%>"></script>
	<script src="<%= Url.Content("~/Scripts/bootstrap.min.js")%>"></script>

    <script type="text/javascript" src="<%= Url.Content("~/Scripts/jquery.jqplot.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.canvasTextRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.canvasAxisTickRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.categoryAxisRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.barRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.pointLabels.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.highlighter.min.js")%>"></script>

    <script type="text/javascript">
        (function ($) {
            $.jqplot.numFormatter = function (format, val) {
                if (!format) {
                    format = '%.1f';
                }
                return numberWithCommas($.jqplot.sprintf(format, val));
            };

            function numberWithCommas(x) {
                return x.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
            }
        })(jQuery);

        <% 
        Dim cnt As Integer = 1
        Dim dataLow As String = ""
        Dim dataMed As String = ""
        Dim dataHi As String = ""
        Dim dataTicks As String = ""
        Dim comma As String = ""
        
        For Each rowList In Model.EmailEngagements
            If cnt > 1 Then
                comma = ","
            End If

            dataLow = dataLow & comma & rowList("Low")
            dataMed = dataMed & comma & rowList("Medium")
            dataHi = dataHi & comma & rowList("High")
            dataTicks = dataTicks & comma & "'" & rowList("WeekRange") & "'"
            
            cnt = cnt + 1
        Next
        %>

        var s1 = [<%=dataLow%>]
        var s2 = [<%=dataMed%>];
        var s3 = [<%=dataHi%>];
        var chartTicks = [<%=dataTicks%>];

        <%
        Dim dataISPs As String = ""
        cnt = 1
        comma = ""
        For Each rowISPs In Model.TopISPs
            If cnt > 1 Then
                comma = ","
            End If

            dataISPs = dataISPs & comma & "['" & rowISPs("Domain") & "', " & rowISPs("EmailPercent") & "]"
            
            cnt = cnt + 1
        Next
        %>
        
        var pieISPData = [<%=dataISPs%>];

        $(document).ready(function () {
            temp = {
                seriesStyles: {
                    seriesColors: ['red', 'orange', 'green'],
                },
                legend: {
                    fontSize: '8pt'
                },
                grid: {
                    backgroundColor: 'rgb(211, 233, 195)'
                }
            };

            $(document).tooltip();
            $.jqplot.sprintf.thousandsSeparator = ',';

            var seriesL = [
                    { label: 'Low' },
                    { label: 'Medium' },
                    { label: 'Hi' }
            ];

            //plotAreaChart('areaChart', s1, s2, s3, chartTicks, seriesL);

            plotStackedBarChart('barChart', s1, s2, s3, chartTicks, seriesL, '%d\%', temp);

        });

        $(window).on('resize', function () {
            $('#areaChart').html('');
            $('#barChart').html('');
            $('#barClicks').html('');

           // plotAreaChart('areaChart', s1, s2, s3, chartTicks)

            var seriesL = [
                    { label: 'Low' },
                    { label: 'Medium' },
                    { label: 'Hi' }
            ];

            plotStackedBarChart('barChart', s1, s2, s3, chartTicks, seriesL, '%d\%', temp);

            if ($(window).width() > 768) $('#sidebar-collapse').collapse('show')
        })
        $(window).on('resize', function () {
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
                        //pad: 1.05,
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

        function plotBarChart(cont, s1, s2, s3, ticks, seriesLabels, tickString, theme) {
            var plotc = $.jqplot(cont, [s1, s2, s3], {
                seriesDefaults: {
                    renderer: $.jqplot.BarRenderer,
                    rendererOptions: { fillToZero: true }
                },

                series: seriesLabels,

                legend: {
                    show: true,
                    placement: 'outsideGrid'
                },
                axes: {
                    xaxis: {
                        renderer: $.jqplot.CategoryAxisRenderer,
                        ticks: ticks
                    },
                    yaxis: {
                        min: 0,
                        max: 100,
                        tickOptions: { formatString: tickString, formatter: $.jqplot.numFormatter }
                    }
                }
            });

            plotc.themeEngine.newTheme('vnzTheme', theme);
            plotc.themeEngine.activateTheme('vnzTheme');
        }

        function plotPieChart( pieCont, pieData ) {
            var plot3 = $.jqplot(pieCont, [pieData], {
                seriesDefaults: {
                    // make this a donut chart.
                    renderer: $.jqplot.DonutRenderer,
                    rendererOptions: {
                        // Donut's can be cut into slices like pies.
                        sliceMargin: 3,
                        // Pies and donuts can start at any arbitrary angle.
                        startAngle: -90,
                        showDataLabels: true,
                        // By default, data labels show the percentage of the donut/pie.
                        // You can show the data 'value' or data 'label' instead.
                        dataLabels: 'value'
                    }
                },
                legend: {
                    show: true, location: 'e'
                }
            });
        }

        function plotAreaChart(cont, s1, s2, s3, ticks, seriesLabels) {
            var plot1b = $.jqplot(cont, [s1, s2, s3], {
                stackSeries: true,
                showMarker: false,
                seriesDefaults: {
                    fill: true
                },
                legend: {
                    show: true, location: 'e'
                },
                axes: {
                    xaxis: {
                        renderer: $.jqplot.CategoryAxisRenderer,
                        ticks: ticks
                    },
                    yaxis: {
                        min: 0,
                        tickOptions: { formatString: '%d', formatter: $.jqplot.numFormatter }
                    }
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
