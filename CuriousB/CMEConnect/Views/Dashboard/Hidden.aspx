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
                <div class="panel-heading" title="Latest Deployements">Latest Deployements</div>
                <div class="panel-body">
                    <div class="engagement-chart">
					    <div id="barClicks" style="width: 100%; height: 500px;"></div>
                        <%
                            Dim comma As String = ""
                            Dim cnt As Integer = 1

                            Dim dataDep As String = ""
                            Dim dataOpn As String = ""
                            Dim dataClk As String = ""
                            Dim dataCTicks As String = ""
                            Dim label As String = ""
                            comma = ""
                            
                            'Name, DateDeployed, Deployed, Opened, Clicked, Rank
                            For Each rowClicks In Model.LatestDeployements
                                If cnt > 1 Then
                                    comma = ","
                                End If

                                dataDep = dataDep & comma & rowClicks("Deployed")
                                dataOpn = dataOpn & comma & rowClicks("Opened")
                                dataClk = dataClk & comma & rowClicks("Clicked")
                                
                                label = ""
                                If rowClicks("Rank") = "High" Then
                                    label = "'<div id=""tt_" & cnt & """ class=""chart-series""><span class=""rank-hi rank-margin glyphicon glyphicon-circle-arrow-up""></span>" & rowClicks("Name") & "</div>Deploy Date:" & rowClicks("DateDeployed") & "'"
                                ElseIf rowClicks("Rank") = "Medium" Then
                                    label = "'<div id=""tt_" & cnt & """ class=""chart-series""><span class=""rank-mid rank-margin glyphicon glyphicon-circle-arrow-right""></span>" & rowClicks("Name") & "</div>Deploy Date:" & rowClicks("DateDeployed") & "'"
                                Else
                                    label = "'<div id=""tt_" & cnt & """ class=""chart-series""><span class=""rank-low rank-margin glyphicon glyphicon-circle-arrow-down""></span>" & rowClicks("Name") & "</div>Deploy Date:" & rowClicks("DateDeployed") & "'"
                                End If
                                dataCTicks = dataCTicks & comma & label
            
                                cnt = cnt + 1
                            Next
                        %>
                        <script type="text/javascript">
                            var c1 = [<%=dataDep%>];
                            var c2 = [<%=dataOpn%>];
                            var c3 = [<%=dataClk%>];
                            var chartCTicks = [<%=dataCTicks%>];
                        </script>
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
                    <div class="engagement-chart">
                        <p>
                            The calculation behind this is quite complicated but the result is a measure of not just how many people are on the database, but how engaged each of them is.
                        </p>
					    <div id="barChart" style="width: 100%; height: 300px;"></div>
                        <%
                            Dim dataLow As String = ""
                            Dim dataMid As String = ""
                            Dim dataHi As String = ""
                            Dim countLow As String = ""
                            Dim countMid As String = ""
                            Dim countHi As String = ""
                            Dim dataTicks As String = ""
                            If Not IsNothing(Model.EmailEngagements) Then

                                cnt = 1
                                comma = ""
        
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
                            End If
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

</asp:Content>

<asp:Content ID="HiddenCSSContent" ContentPlaceHolderID="CSSContent" runat="server">
    <link href="<%= Url.Content("~/Content/bootstrap.min.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/bootstrap-table.css")%>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/jquery.jqplot.min.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/styles.css") %>" rel="stylesheet">


    <!--[if lt IE 9]>
        <script src="<%= Url.Content("~/Scripts/html5shiv.js")%>"></script>
        <script src="<%= Url.Content("~/Scripts/respond.min.js")%>"></script>
    <![endif]-->
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
            var xAxisL = {
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
            };

            var seriesC = [
                   { label: 'Deployed' },
                   { label: 'Opened' },
                   { label: 'Click' }
            ];
            var xAxisC = {
                xaxis: {
                    renderer: $.jqplot.CategoryAxisRenderer,
                    ticks: chartCTicks
                },
                yaxis: {
                    min: 0,
                    tickOptions: { formatString: '%d', formatter: $.jqplot.numFormatter }
                }
            };

            plotStackedBarChart('barClicks', [c1, c2, c3], seriesC, false, xAxisC, false);
            plotStackedBarChart('barChart', [s1, s2, s3], seriesL, true, xAxisL, true);

            $('[id^="tt_"]').click(function () {
                event.preventDefault();

                var pid = $(this).attr('id').substring(3);
                alert("tt_" + pid);
            });

        });

        $(window).on('resize', function () {
            $('#barChart').html('');
            $('#barClicks').html('');

            var seriesL = [
                    { label: 'Low' },
                    { label: 'Medium' },
                    { label: 'Hi' }
            ];
            var xAxisL = {
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
            };

            var seriesC = [
                   { label: 'Deployed' },
                   { label: 'Opened' },
                   { label: 'Click' }
            ];
            var xAxisC = {
                xaxis: {
                    renderer: $.jqplot.CategoryAxisRenderer,
                    ticks: chartCTicks
                },
                yaxis: {
                    min: 0,
                    tickOptions: { formatString: '%d', formatter: $.jqplot.numFormatter }
                }
            };


            plotStackedBarChart('barChart', [s1, s2, s3], seriesL, true, xAxisL, true);
            plotStackedBarChart('barClicks', [c1, c2, c3], seriesC, false, xAxisC, false);

            if ($(window).width() > 768) $('#sidebar-collapse').collapse('show')
            if ($(window).width() <= 767) $('#sidebar-collapse').collapse('hide')
        })

        function plotStackedBarChart(cont, data, seriesLabels, isStack, xTickOptions, hlighter) {
            var plotc = $.jqplot(cont, data, {
                stackSeries: isStack,
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

                axes: xTickOptions,
                highlighter: {
                    show: hlighter,
                    tooltipContentEditor: tooltipContentEditor
                }
            });

            //$('#' + cont).bind('jqplotDataHighlight',
            //    function (ev, seriesIndex, pointIndex, data) {
            //        nEvents = nEvents + 1;
            //        $('#info1').html(nEvents);
            //    }
            //);

            //$('#' + cont).bind('jqplotDataUnhighlight',
            //    function (ev) {
            //        $('#info1').html('Nothing');
            //        nEvents = 0;
            //    }
            //);
        }

        function tooltipContentEditor(str, seriesIndex, pointIndex, plot) {
            var formatted = '<table class="jqplot-highlighter">' +
                            '   <tr><td class="jqplot-highlighter-title" colspan=2>' + plot.options.axes.xaxis.ticks[pointIndex] + '</td></tr>' +
                                '<tr class="jqplot-highlighter-body"><td>' + plot.series[seriesIndex]["label"] + '</td><td>' + plot.data[seriesIndex][pointIndex] + '</td></tr>' +
                            '</table>'
            return formatted
        }

        function numberWithCommas(x) {
            return x.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
        }

   </script>
</asp:Content>
