<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Cme.Master" Inherits="System.Web.Mvc.ViewPage(of CMEConnect.LatestDeploymentModel)" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Latest Deployments - New Zealand Rugby
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


    <div class="row">
		<div class="col-lg-12">
			<h3 class="page-header">Latest Deployment</h3>
            <p><%
                   If Model.HasError Then
                       Response.Write(Model.ErrorMMsg)
                   End If
               %></p>
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

</asp:Content>

<asp:Content ID="ContentCSS" ContentPlaceHolderID="CSSContent" runat="server">
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
		<li class="active">Latest Deployment</li>
	</ol>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsSection" runat="server">
    <script src="<%= Url.Content("~/Scripts/jquery-1.7.1.min.js")%>"></script>
	<script src="<%= Url.Content("~/Scripts/bootstrap.min.js")%>"></script>

    <script type="text/javascript" src="<%= Url.Content("~/Scripts/jquery.jqplot.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.barRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.donutRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.categoryAxisRenderer.min.js")%>"></script>
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


        $(document).ready(function () {
            $.jqplot.sprintf.thousandsSeparator = ',';

            var seriesC = [
                    { label: 'Deployed' },
                    { label: 'Opened' },
                    { label: 'Clicked' }
            ];

            plotBarChart('barClicks', c1, c2, c3, chartCTicks, seriesC, '%d');

            $('[id^="tt_"]').click(function () {
                event.preventDefault();

                var pid = $(this).attr('id').substring(3);
                alert("tt_" + pid);
            });

        });

        $(window).on('resize', function () {
            $('#barClicks').html('');

            var seriesC = [
                    { label: 'Deployed' },
                    { label: 'Opened' },
                    { label: 'Click' }
            ];

            plotBarChart('barClicks', c1, c2, c3, chartCTicks, seriesC, '%d')

            if ($(window).width() > 768) $('#sidebar-collapse').collapse('show')
        })
        $(window).on('resize', function () {
            if ($(window).width() <= 767) $('#sidebar-collapse').collapse('hide')
        })

        function plotBarChart(cont, s1, s2, s3, ticks, seriesLabels, tickString) {
            var plotc = $.jqplot(cont, [s1, s2, s3], {
                seriesDefaults: {
                    renderer: $.jqplot.BarRenderer,
                    rendererOptions: {
                        fillToZero: true,
                        barMargin : 30
                    }
                },

                series: seriesLabels,
                axesDefaults: {
                    tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                    tickOptions: {
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
                        ticks: ticks
                    },
                    yaxis: {
                        min: 0,
                        tickOptions: { formatString: tickString, formatter: $.jqplot.numFormatter }
                    }
                }
            });
        }

    </script>
</asp:Content>
