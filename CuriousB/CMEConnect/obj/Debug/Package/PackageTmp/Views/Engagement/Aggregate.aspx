<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Cme.Master" Inherits="System.Web.Mvc.ViewPage(of CMEConnect.AggregateModel)" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
Devices
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
	    <div class="col-lg-12">
		    <h3 class="page-header">Aggregate Reports</h3>
            <p>
                <%
                    Dim dataPies As String = ""
                    Dim comma As String = ""
                    Dim cnt As Integer = 1
                    Dim pct As Integer
                                    
                    If Model.HasError Then
                        Response.Write(Model.ErrorMMsg)
                    End If
                %>
            </p>
	    </div>
    </div><!--/.row-->

    <div class="row"><%--Geography--%>
		<div class="col-lg-12">
            <div class="panel panel-blue">
                <div class="panel-heading">Geography</div>
                <div class="panel-body">
                    <div class="engagement-chart">
                        <div class="row">
                            <div class="col-md-3">
                                <div id="pieChartOpenByCountry" style="width: 100%; height: 200px;"></div>
                                <%
                                    Dim ctyOpens As Integer = 0
                                    comma = ""
                                    dataPies = ""
                                    pct = 0
                                    For Each rowOpen In Model.CountriesByOpens
                                        If cnt > 1 Then
                                            comma = ","
                                        End If
                                        pct = Math.Round(rowOpen("TotalCnt") / Model.TotalOpens * 100)
                                        ctyOpens = rowOpen("TotalCnt")
                                        dataPies = dataPies & comma & "['" & rowOpen("Country") & " " & pct & "%', " & pct & "]"
                                        cnt = cnt + 1
                                    Next
                                %>
                                <script type="text/javascript">
                                    var pieOpenByCountryData = [<%=dataPies%>];
                                </script>
                            </div>
                            <div class="col-md-3">
                                <div id="pieChartClickByCountry" style="width: 100%; height: 200px;"></div>
                                <%
                                    comma = ""
                                    dataPies = ""
                                    pct = 0
                                    cnt = 1
                                    For Each rowClick In Model.CountriesByClicks
                                        If cnt > 1 Then
                                            comma = ","
                                        End If
                                        pct = Math.Round(rowClick("TotalCnt") / Model.TotalOpens * 100)
                                        
                                        dataPies = dataPies & comma & "['" & rowClick("Country") & " " & pct & "%', " & pct & "]"
                                        cnt = cnt + 1
                                    Next
                                %>
                                <script type="text/javascript">
                                    var pieClickByCountryData = [<%=dataPies%>];
                                </script>
                            </div>
                            <div class="col-md-3">
                                <div id="pieChartUnqOpenByCountry" style="width: 100%; height: 200px;"></div>
                                <%
                                    comma = ""
                                    dataPies = ""
                                    pct = 0
                                    cnt = 1
                                    For Each rowUnqOpen In Model.CountriesByUnqOpens
                                        If cnt > 1 Then
                                            comma = ","
                                        End If
                                        pct = Math.Round(rowUnqOpen("TotalCnt") / Model.TotalUnqOpens * 100)
                                        
                                        dataPies = dataPies & comma & "['" & rowUnqOpen("Country") & " " & pct & "%', " & pct & "]"
                                        cnt = cnt + 1
                                    Next
                                %>
                                <script type="text/javascript">
                                    var pieUnqOpenByCountryData = [<%=dataPies%>];
                                </script>
                            </div>
                            <div class="col-md-3">
                                <div id="pieChartUnqClickByCountry" style="width: 100%; height: 200px;"></div>
                                <%
                                    comma = ""
                                    dataPies = ""
                                    pct = 0
                                    cnt = 1
                                    For Each rowUnqClick In Model.CountriesByUnqClicks
                                        If cnt > 1 Then
                                            comma = ","
                                        End If
                                        pct = Math.Round(rowUnqClick("TotalCnt") / Model.TotalUnqClicks * 100)
                                        
                                        dataPies = dataPies & comma & "['" & rowUnqClick("Country") & " " & pct & "%', " & pct & "]"
                                        cnt = cnt + 1
                                    Next
                                %>
                                <script type="text/javascript">
                                    var pieUnqClickByCountryData = [<%=dataPies%>];
                                </script>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
		<div class="col-sm-12">
            <div class="panel panel-blue">
                <div class="panel-heading">ISPs</div>
                <div class="panel-body panel-white">
                    <div class="engagement-chart">
                        <div class="col-sm-7 five-three">
                            <div class="row">
                                <div class="col-md-4">
                                    <div id="pieISPsSentTo" style="width: 100%; height: 200px;"></div>
                                    <%
                                        comma = ""
                                        dataPies = ""
                                        pct = 0
                                        cnt = 1
                                        For Each rowISPelivered In Model.ISPsByDelivered 
                                            If cnt > 1 Then
                                                comma = ","
                                            End If
                                            pct = Math.Round(rowISPelivered("TotalCnt") / Model.TotalISPDelivered  * 100)
                                        
                                            dataPies = dataPies & comma & "['" & rowISPelivered("ISP") & " " & pct & "%', " & pct & "]"
                                            cnt = cnt + 1
                                        Next
                                    %>
                                    <script type="text/javascript">
                                        var pieISPsSentToData = [<%=dataPies%>];
                                    </script>
                                </div>
                                <div class="col-md-4">
                                    <div id="pieISPsByOpen" style="width: 100%; height: 200px;"></div>
                                    <%
                                        comma = ""
                                        dataPies = ""
                                        pct = 0
                                        cnt = 1
                                        For Each rowISPByOpens In Model.ISPsByOpens
                                            If cnt > 1 Then
                                                comma = ","
                                            End If
                                            pct = Math.Round(rowISPByOpens("TotalCnt") / Model.TotalISPOpens * 100)
                                        
                                            dataPies = dataPies & comma & "['" & rowISPByOpens("ISP") & " " & pct & "%', " & pct & "]"
                                            cnt = cnt + 1
                                        Next
                                    %>
                                    <script type="text/javascript">
                                        var pieISPsByOpenData = [<%=dataPies%>];
                                    </script>
                                </div>
                                <div class="col-md-4">
                                    <div id="pieISPsByClick" style="width: 100%; height: 200px;"></div>
                                    <%
                                        comma = ""
                                        dataPies = ""
                                        pct = 0
                                        cnt = 1
                                        For Each rowISPByClicks In Model.ISPsByClicks
                                            If cnt > 1 Then
                                                comma = ","
                                            End If
                                            pct = Math.Round(rowISPByClicks("TotalCnt") / Model.TotalISPClicks * 100)
                                        
                                            dataPies = dataPies & comma & "['" & rowISPByClicks("ISP") & " " & pct & "%', " & pct & "]"
                                            cnt = cnt + 1
                                        Next
                                    %>
                                    <script type="text/javascript">
                                        var pieISPsByClicksData = [<%=dataPies%>];
                                    </script>
                                </div>
                                <div class=".clear-fix"></div>
                            </div>
                        </div>
                        <div class="col-sm-5 five-two">
                            <div class="row">
                                <div class="col-md-6">
                                    <div id="pieISPsByBlocks" style="width: 100%; height: 200px;"></div>
                                    <%
                                        comma = ""
                                        dataPies = ""
                                        pct = 0
                                        cnt = 1
                                        For Each rowISPByBlocks In Model.ISPsByBlocks
                                            If cnt > 1 Then
                                                comma = ","
                                            End If
                                            pct = Math.Round(rowISPByBlocks("TotalCnt") / Model.TotalISPBlocks * 100)
                                        
                                            dataPies = dataPies & comma & "['" & rowISPByBlocks("ISP") & " " & pct & "%', " & pct & "]"
                                            cnt = cnt + 1
                                        Next
                                    %>
                                    <script type="text/javascript">
                                        var pieISPsByBlocksData = [<%=dataPies%>];
                                    </script>
                                </div>
                                <div class="col-md-6">
                                    <div id="pieISPsBySpam" style="width: 100%; height: 200px;"></div>
                                    <%
                                        comma = ""
                                        dataPies = ""
                                        pct = 0
                                        cnt = 1
                                        For Each rowISPBySpam In Model.ISPsBySpam
                                            If cnt > 1 Then
                                                comma = ","
                                            End If
                                            pct = Math.Round(rowISPBySpam("TotalCnt") / Model.TotalISPSpam * 100)
                                        
                                            dataPies = dataPies & comma & "['" & rowISPBySpam("ISP") & " " & pct & "%', " & pct & "]"
                                            cnt = cnt + 1
                                        Next
                                    %>
                                    <script type="text/javascript">
                                        var pieISPsBySpamData = [<%=dataPies%>];
                                    </script>
                                </div>
                                <div class=".clear-fix"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
		<div class="col-sm-12">
            <div class="panel panel-blue">
                <div class="panel-heading">Devices</div>
                <div class="panel-body panel-white">
                    <div class="engagement-chart">
                        <div class="col-sm-7 five-three">
                            <div class="row">
                                <div class="col-md-4">
                                    <div id="pieTopEmailClients" style="width: 100%; height: 200px;"></div>
                                    <%
                                        comma = ""
                                        dataPies = ""
                                        cnt = 1
                                        For Each rowTopEmailClients In Model.TopEmailClients
                                            If cnt > 1 Then
                                                comma = ","
                                            End If
                                            dataPies = dataPies & comma & "['" & rowTopEmailClients("Name") & " " & rowTopEmailClients("Percent") & "%', " & rowTopEmailClients("Percent") & "]"
                                            cnt = cnt + 1
                                        Next
                                    %>
                                    <script type="text/javascript">
                                        var pieTopEmailClientsData = [<%=dataPies%>];
                                    </script>
                                </div>
                                <div class="col-md-4">
                                    <div id="pieTopDevices" style="width: 100%; height: 200px;"></div>
                                    <%
                                        comma = ""
                                        dataPies = ""
                                        cnt = 1
                                        For Each rowTopDevices In Model.TopDevices
                                            If cnt > 1 Then
                                                comma = ","
                                            End If
                                        
                                            dataPies = dataPies & comma & "['" & rowTopDevices("Name") & " " & rowTopDevices("Percent") & "%', " & rowTopDevices("Percent") & "]"
                                            cnt = cnt + 1
                                        Next
                                    %>
                                    <script type="text/javascript">
                                        var pieTopDevicesData = [<%=dataPies%>];
                                    </script>
                                </div>
                                <div class="col-md-4">
                                    <div id="pieTopWebmails" style="width: 100%; height: 200px;"></div>
                                    <%
                                        comma = ""
                                        dataPies = ""
                                        pct = 0
                                        cnt = 1
                                        For Each rowTopWebmails In Model.TopWebmails
                                            If cnt > 1 Then
                                                comma = ","
                                            End If
                                        
                                            dataPies = dataPies & comma & "['" & rowTopWebmails("Name") & " " & rowTopWebmails("Percent") & "%', " & rowTopWebmails("Percent") & "]"
                                            cnt = cnt + 1
                                        Next
                                    %>
                                    <script type="text/javascript">
                                        var pieTopWebmailsData = [<%=dataPies%>];
                                    </script>
                                </div>
                                <div class=".clear-fix"></div>
                            </div>
                        </div>
                        <div class="col-sm-5 five-two">
                            <div class="row">
                                <div class="col-md-6">
                                    <div id="pieTopPhones" style="width: 100%; height: 200px;"></div>
                                    <%
                                        comma = ""
                                        dataPies = ""
                                        cnt = 1
                                        For Each rowTopPhones In Model.TopPhones
                                            If cnt > 1 Then
                                                comma = ","
                                            End If
                                        
                                            dataPies = dataPies & comma & "['" & rowTopPhones("Name") & " " & rowTopPhones("Percent") & "%', " & rowTopPhones("Percent") & "]"
                                            cnt = cnt + 1
                                        Next
                                    %>
                                    <script type="text/javascript">
                                        var pieTopPhonesData = [<%=dataPies%>];
                                    </script>
                                </div>
                                <div class="col-md-6">
                                    <div id="pieTopTablets" style="width: 100%; height: 200px;"></div>
                                    <%
                                        comma = ""
                                        dataPies = ""
                                        cnt = 1
                                        For Each rowTopTablets In Model.TopTablets
                                            If cnt > 1 Then
                                                comma = ","
                                            End If
                                        
                                            dataPies = dataPies & comma & "['" & rowTopTablets("Name") & " " & rowTopTablets("Percent") & "%', " & rowTopTablets("Percent") & "]"
                                            cnt = cnt + 1
                                        Next
                                    %>
                                    <script type="text/javascript">
                                        var pieTopTabletsData = [<%=dataPies%>];
                                    </script>
                                </div>
                                <div class=".clear-fix"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="CSSContent" runat="server">
    <link href="<%= Url.Content("~/Content/bootstrap.min.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/datepicker3.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/styles.css") %>" rel="stylesheet">
    <link href="<%= Url.Content("~/Content/jquery.jqplot.min.css") %>" rel="stylesheet">

    <!--[if lt IE 9]><script language="javascript" type="text/javascript" src="<%= Url.Content("~/Scripts/excanvas.js")%>"></script><![endif]-->
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsSection" runat="server">
    <script src="<%= Url.Content("~/Scripts/jquery-1.7.1.min.js")%>"></script>
	<script src="<%= Url.Content("~/Scripts/bootstrap.min.js")%>"></script>

    <script type="text/javascript" src="<%= Url.Content("~/Scripts/jquery.jqplot.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.donutRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.canvasTextRenderer.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.pointLabels.min.js")%>"></script>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/plugins/jqplot.highlighter.min.js")%>"></script>

    <script type="text/javascript">

        $(document).ready(function () {
            $.jqplot.sprintf.thousandsSeparator = ',';

            plotPieChart('pieChartOpenByCountry', pieOpenByCountryData, 'Top 5 Countries by Opens');
            plotPieChart('pieChartClickByCountry', pieClickByCountryData, 'Top 5 Countries by Clicks');
            plotPieChart('pieChartUnqOpenByCountry', pieUnqOpenByCountryData, 'Top 5 Countries by Unique Opens');
            plotPieChart('pieChartUnqClickByCountry', pieUnqClickByCountryData, 'Top 5 Countries by Unique Clicks');

            plotPieChart('pieISPsSentTo', pieISPsSentToData, 'Top 5 ISPs Sent To');
            plotPieChart('pieISPsByOpen', pieISPsByOpenData, 'Top 5 ISPs by Opens');
            plotPieChart('pieISPsByClick', pieISPsByClicksData, 'Top 5 ISPs by Clicks');
            plotPieChart('pieISPsByBlocks', pieISPsByBlocksData, 'Top 5 ISPs by Blocks');
            plotPieChart('pieISPsBySpam', pieISPsBySpamData, 'Top 5 ISPs by Spam Reports');

            plotPieChart('pieTopEmailClients', pieTopEmailClientsData, 'Top Email Clients');
            plotPieChart('pieTopDevices', pieTopDevicesData, 'Top Devices');
            plotPieChart('pieTopWebmails', pieTopWebmailsData, 'Top Webmails');
            plotPieChart('pieTopPhones', pieTopPhonesData, 'Top Phones');
            plotPieChart('pieTopTablets', pieTopTabletsData, 'Top Tablets');
        });

        $(window).on('resize', function () {
            $('#pieChartOpenByCountry').html('');
            $('#pieChartClickByCountry').html('');
            $('#pieChartUnqOpenByCountry').html('');
            $('#pieChartUnqClickByCountry').html('');

            $('#pieISPsSentTo').html('');
            $('#pieISPsByOpen').html('');
            $('#pieISPsByClick').html('');
            $('#pieISPsByBlocks').html('');
            $('#pieISPsBySpam').html('');

            $('#pieTopEmailClients').html('');
            $('#pieTopDevices').html('');
            $('#pieTopWebmails').html('');
            $('#pieTopPhones').html('');
            $('#pieTopTablets').html('');

            plotPieChart('pieChartOpenByCountry', pieOpenByCountryData, 'Top 5 Countries by Opens');
            plotPieChart('pieChartClickByCountry', pieClickByCountryData, 'Top 5 Countries by Clicks');
            plotPieChart('pieChartUnqOpenByCountry', pieUnqOpenByCountryData, 'Top 5 Countries by Unique Opens');
            plotPieChart('pieChartUnqClickByCountry', pieUnqClickByCountryData, 'Top 5 Countries by Unique Clicks');

            plotPieChart('pieISPsSentTo', pieISPsSentToData, 'Top 5 ISPs Sent To');
            plotPieChart('pieISPsByOpen', pieISPsByOpenData, 'Top 5 ISPs by Opens');
            plotPieChart('pieISPsByClick', pieISPsByClicksData, 'Top 5 ISPs by Clicks');
            plotPieChart('pieISPsByBlocks', pieISPsByBlocksData, 'Top 5 ISPs by Blocks');
            plotPieChart('pieISPsBySpam', pieISPsBySpamData, 'Top 5 ISPs by Spam Reports');

            plotPieChart('pieTopEmailClients', pieTopEmailClientsData, 'Top Email Clients');
            plotPieChart('pieTopDevices', pieTopDevicesData, 'Top Devices');
            plotPieChart('pieTopWebmails', pieTopWebmailsData, 'Top Webmails');
            plotPieChart('pieTopPhones', pieTopPhonesData, 'Top Phones');
            plotPieChart('pieTopTablets', pieTopTabletsData, 'Top Tablets');

            if ($(window).width() > 768) $('#sidebar-collapse').collapse('show')
        })
        $(window).on('resize', function () {
            if ($(window).width() <= 767) $('#sidebar-collapse').collapse('hide')
        })

        function plotPieChart(pieCont, pieData, title) {
            var plot3 = $.jqplot(pieCont, [pieData], {
                title: title,
                seriesDefaults: {
                    // make this a donut chart.
                    renderer: $.jqplot.DonutRenderer,
                    rendererOptions: {
                        // Donut's can be cut into slices like pies.
                        sliceMargin: 3,
                        padding: 5,
                        // Pies and donuts can start at any arbitrary angle.
                        startAngle: -90,
                        showDataLabels: false,
                        // By default, data labels show the percentage of the donut/pie.
                        // You can show the data 'value' or data 'label' instead.
                        shadowOffset: 1.5,
                        shadowDepth: 1,
                        shadowAlpha: 0.5,
                        dataLabels: 'value'
                    }
                },
                grid: {
                    //borderColor: '#000000',
                    borderWidth: 0.1,
                    shadowWidth: 2,
                    shadowDepth: 1,
                    shadowAlpha: 0.3
                },
                legend: {
                    show: true,
                    fontSize: '0.75em'
                },
                highlighter: {
                    show: true,
                    tooltipLocation: 'e',
                    useAxesFormatters: false,
                    formatString: "%s<br><div style='display:none'>%d</div>%s",
                   // tooltipContentEditor: tooltipContentEditor
            }
            });
        }


        function tooltipContentEditor(str, seriesIndex, pointIndex, plot) {
            var formatted = '<table class="jqplot-highlighter">' +
                            '   <tr><td class="jqplot-highlighter-title" colspan=2>' + plot.options.axes.xaxis.ticks[pointIndex] + '</td></tr>' +
                                '<tr class="jqplot-highlighter-body"><td>' + plot.series[seriesIndex]["label"] + '</td><td>' + plot.data[seriesIndex][pointIndex] + '</td></tr>' +
                            '</table>'
            return formatted
        }

    </script>
</asp:Content>
