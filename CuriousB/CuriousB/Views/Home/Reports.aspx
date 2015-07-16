<%@ Page Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage(of CuriousB.OtherReportsModels)" %>

<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Email Engagements Reports - New Zealand Rugby
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

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
                <div class="panel-heading">Communication History</div>
                <div class="panel-body">
                    <div class="engagement-chart">
                        <p>
                            This report explores where communications are working and which messages are suited to each audience. 
                        </p>
					    <table data-toggle="table">
						    <thead>
						    <tr>
						        <th data-field="low" data-align="left">Name</th>
						        <th data-field="dated" data-align="center">Date Deployed</th>
						        <th data-field="medium" data-align="center">Audience</th>
						        <th data-field="high" data-align="center">Open Rate</th>
						        <th data-field="total" data-align="center">Click Rate</th>
						    </tr>
						    </thead>
                            <tbody>
                                <%For Each eeList In Model.EmailCurrentState%>                                    
                                <tr>
                                    <td><span title="<%=eeList("Name").ToString%>"><%=eeList("Name")%></span></td>
                                    <td><%=eeList("iDateDeployed").ToString%></td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0:0,0}", eeList("Deployed"))%></td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0:0}%", eeList("OpenRate"))%></td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0:0}%", eeList("ClickRate"))%></td>
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
                <div class="panel-heading">Engagement Over Time Stacked Bar Chart and Area Chart
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
					    <%--<div id="barChart" style="width: 100%; height: 500px;"></div>--%>
                        <div class="margin-30"></div>
					    <div id="areaChart" style="width: 100%; height: 300px;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="EngagementOverTime" class="row" style="display:none">
        <div class="col-lg-12">
            <div class="panel panel-blue">
                <div class="panel-heading">Engagement Over Time</div>
                <div class="panel-body">
                    <div class="engagement-chart">
					    <table data-toggle="table">
						    <thead>
						    <tr>
						        <th data-field="WeekRange" data-align="center">Week Range</th>
						        <th data-field="Dormant" data-align="center">Dormant</th>
						        <th data-field="Low" data-align="center">Low</th>
						        <th data-field="Medium" data-align="center">Medium</th>
						        <th data-field="High" data-align="center">High</th>
                                <th data-field="Total" data-align="center">Total</th>
						    </tr>
						    </thead>
                            <tbody>
                                <% For Each ecList In Model.EmailEngagements%>
                                <tr>
                                    <td><%=ecList("WeekRange")%></td>
                                    <td><%=String.Format(CultureInfo.InvariantCulture, "{0,0}", ecList("Dormant"))%></td>
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

<asp:Content ID="Content3" ContentPlaceHolderID="CSSContent" runat="server">
    <link href="<%= Url.Content("~/Content/bootstrap.min.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/datepicker3.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/bootstrap-table.css")%>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/jquery.jqplot.min.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/styles.css") %>" rel="stylesheet">

    <!--[if lt IE 9]>
        <script src="<%= Url.Content("~/Scripts/html5shiv.js")%>"></script>
        <script src="<%= Url.Content("~/Scripts/respond.min.js")%>"></script>
    <![endif]-->
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="BreadcrumbContent" runat="server">
    <ol class="breadcrumb">
		<li><a href="#"><span class="glyphicon glyphicon-home"></span></a></li>
		<li class="active">Reports</li>
	</ol>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsSection" runat="server">
    <script src="<%= Url.Content("~/Scripts/jquery-1.7.1.min.js")%>"></script>
	<script src="<%= Url.Content("~/Scripts/bootstrap.min.js")%>"></script>
	<script src="<%= Url.Content("~/Scripts/bootstrap-table.js")%>"></script>

    <script type="text/javascript" src="<%= Url.Content("~/Scripts/jquery.jqplot.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.canvasTextRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.canvasAxisTickRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.categoryAxisRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.barRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.pointLabels.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.highlighter.min.js")%>"></script>

    <script type="text/javascript">
        jQuery(document).ready(function ($) {
            $('#showGrid').click(function () {
                //if (event.preventDefault) {
                //    event.preventDefault();
                //} else {
                //    event.returnValue = false;
                //}

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

        var s1 = [<%=dataLow%>]
        var s2 = [<%=dataMid%>];
        var s3 = [<%=dataHi%>];

        var a1 = [<%=countLow%>]
        var a2 = [<%=countMid%>];
        var a3 = [<%=countHi%>];

        var chartTicks = [<%=dataTicks%>];

        $(document).ready(function () {

            $.jqplot.sprintf.thousandsSeparator = ',';

            plotAreaChart('areaChart', s1, s2, s3, chartTicks);

            var seriesL = [
                    { label: 'Low' },
                    { label: 'Medium' },
                    { label: 'Hi' }
            ];
            plotBarChart('barChart', s1, s2, s3, chartTicks, seriesL, '%d\%', a1, a2, a3);
        });

        $(window).on('resize', function () {
            $('#areaChart').html('');
            $('#barChart').html('');

            plotAreaChart('areaChart', s1, s2, s3, chartTicks)

            var seriesL = [
                    { label: 'Low' },
                    { label: 'Medium' },
                    { label: 'Hi' }
            ];

            plotBarChart('barChart', s1, s2, s3, chartTicks, seriesL, '%d\%', a1, a2, a3)

            if ($(window).width() > 768) $('#sidebar-collapse').collapse('show')
        })
        $(window).on('resize', function () {
            if ($(window).width() <= 767) $('#sidebar-collapse').collapse('hide')
        })

        function plotBarChart(cont, s1, s2, s3, ticks, seriesLabels, tickString, a1, a2, a3) {
            var plotc = $.jqplot(cont, [s1, s2, s3], {
                stackSeries: true,
                seriesDefaults: {
                    renderer: $.jqplot.BarRenderer,
                    rendererOptions: {
                        fillToZero: true,
                        barMargin : 30,
                        barPadding: 2
                    }
                },

                series: seriesLabels,
                axesDefaults: {
                    tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                    tickOptions: {
                        fontSize: '8pt',
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
                    tooltipLocation:'n',
                    tooltipContentEditor: tooltipContentEditor
                }
            });
        }

        function plotAreaChart(cont, s1, s2, s3, ticks) {
            var plot1b = $.jqplot(cont, [s1, s2, s3], {
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
                },
                //highlighter: {
                //    show: true,
                //    tooltipContentEditor: tooltipContentEditor
                //}
            });

        }

        function tooltipContentEditor(str, seriesIndex, pointIndex, plot) {
            var formatted = '<table class="jqplot-highlighter">'+
                            '   <tr><td class="jqplot-highlighter-title" colspan=2>' + plot.options.axes.xaxis.ticks[pointIndex] + '</td></tr>' +
                                '<tr class="jqplot-highlighter-body"><td>' + plot.series[seriesIndex]["label"] + '</td><td>' + plot.data[seriesIndex][pointIndex] + '</td></tr>' +
                            '</table>'
            return formatted
        }

    </script>
</asp:Content>
