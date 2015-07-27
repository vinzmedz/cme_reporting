Imports System.Globalization
Imports System.Configuration
Imports System.Configuration.ConfigurationManager
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Imports CuriousBLib

Public Class AggregateModel
    Private _strConn As String
    Private _dbConn As MsSQLDatabase.MsSQLClass
    Private _totalCount As Int64
    Private _dataList As New List(Of Dictionary(Of String, Object))

    Public CountriesByClicks As New List(Of Dictionary(Of String, Object))
    Public CountriesByOpens As New List(Of Dictionary(Of String, Object))
    Public CountriesByUnqClicks As New List(Of Dictionary(Of String, Object))
    Public CountriesByUnqOpens As New List(Of Dictionary(Of String, Object))

    Public TotalOpens As Int64
    Public TotalClicks As Int64
    Public TotalUnqOpens As Int64
    Public TotalUnqClicks As Int64

    Public ISPsByDelivered As New List(Of Dictionary(Of String, Object))
    Public ISPsByClicks As New List(Of Dictionary(Of String, Object))
    Public ISPsByOpens As New List(Of Dictionary(Of String, Object))
    Public ISPsByBlocks As New List(Of Dictionary(Of String, Object))
    Public ISPsBySpam As New List(Of Dictionary(Of String, Object))

    Public TotalISPDelivered As Int64
    Public TotalISPClicks As Int64
    Public TotalISPOpens As Int64
    Public TotalISPBlocks As Int64
    Public TotalISPSpam As Int64

    Public TopWebmails As New List(Of Dictionary(Of String, Object))
    Public TopDevices As New List(Of Dictionary(Of String, Object))
    Public TopEmailClients As New List(Of Dictionary(Of String, Object))
    Public TopPhones As New List(Of Dictionary(Of String, Object))
    Public TopTablets As New List(Of Dictionary(Of String, Object))


    Public HasError As Boolean = False
    Public ErrorMMsg As String = ""
    Public CurrentNumberFormat = New CultureInfo("en-US", False).NumberFormat

    Public Sub New()
        CurrentNumberFormat.CurrencyDecimalDigits = 2

        _dbConn = New MsSQLDatabase.MsSQLClass()
        _strConn = ConnectionStrings("SQLConn2").ConnectionString

        With _dbConn
            .dbOpen(_strConn)

            GetGeography()
            GetISPs()
            GetDevices()

        End With
        _dbConn.dbClose()
        _dbConn = Nothing
    End Sub

    Private Sub GetGeography()

        ' Countries by Open
        GetOpenClicksbyCountry("open")
        ' Countries by Click
        GetOpenClicksbyCountry("click")

        ' Countries by Unique Open
        GetUnqOpenClicksbyCountry("open")

        ' Countries by Unique Clicks
        GetUnqOpenClicksbyCountry("click")

    End Sub

    Private Sub GetISPs()
        _dataList = New List(Of Dictionary(Of String, Object))
        GetISPResult("delivered")
        ISPsByDelivered = _dataList
        TotalISPDelivered = GetTotalISPs("delivered")

        _dataList = New List(Of Dictionary(Of String, Object))
        GetISPResult("open")
        ISPsByOpens = _dataList
        TotalISPOpens = GetTotalISPs("open")

        _dataList = New List(Of Dictionary(Of String, Object))
        GetISPResult("click")
        ISPsByClicks = _dataList
        TotalISPClicks = GetTotalISPs("click")

        _dataList = New List(Of Dictionary(Of String, Object))
        GetISPResult("dropped")
        ISPsByBlocks = _dataList
        TotalISPBlocks = GetTotalISPs("dropped")

        _dataList = New List(Of Dictionary(Of String, Object))
        GetISPResult("spamreport")
        ISPsBySpam = _dataList
        TotalISPSpam = GetTotalISPs("spamreport")
    End Sub

    Private Sub GetDevices()
        Dim mSQL As String

        _dataList = New List(Of Dictionary(Of String, Object))
        mSQL = "[rpt].[sp_DesktopClients]" '[cme].[sp_DesktopClients]
        GetDevicesResult(mSQL)
        TopEmailClients = _dataList

        _dataList = New List(Of Dictionary(Of String, Object))
        mSQL = "[rpt].sp_Sendgrid_Devices" '[cme].[sp_Sendgrid_Devices]
        GetDevicesResult(mSQL)
        TopDevices = _dataList

        _dataList = New List(Of Dictionary(Of String, Object))
        mSQL = "[rpt].sp_WebmailClients" '[cme].[sp_Webmail_Clients]
        GetDevicesResult(mSQL)
        TopWebmails = _dataList

        _dataList = New List(Of Dictionary(Of String, Object))
        mSQL = "[rpt].sp_Sendgrid_Phones" 'cme.sp_Sendgrid_Phones
        GetDevicesResult(mSQL)
        TopPhones = _dataList

        _dataList = New List(Of Dictionary(Of String, Object))
        mSQL = "[rpt].sp_Sendgrid_Tablets" 'cme.sp_Sendgrid_Tablets
        GetDevicesResult(mSQL)
        TopTablets = _dataList

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="query"></param>
    ''' <remarks></remarks>
    Private Sub GetDevicesResult(ByVal query As String)

        With _dbConn
            If .IsConnected Then
                .Query = query
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.STORED_QUERY
                .MyCmd.CommandType = CommandType.StoredProcedure

                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            Dim DataList As New List(Of Dictionary(Of String, Object))

                            While .Read
                                Dim dict As New Dictionary(Of String, Object)
                                dict.Add("Name", .GetValue(0))
                                dict.Add("Percent", .GetValue(2))

                                DataList.Add(dict)
                            End While

                            _dataList = DataList
                        End If

                        .Close()
                    End With
                Else
                    HasError = True
                    ErrorMMsg = .ErrorMsg
                End If

            Else
                HasError = True
                ErrorMMsg = .ErrorMsg
            End If

        End With
    End Sub

    Private Sub GetISPResult(ByVal _event As String)
        Dim mSQL As String
        mSQL = "SELECT TOP 4 LEFT(a.EmailDomain, CHARINDEX('.', a.EmailDomain)-1) Domain, " & _
               "    COUNT(a.EmailDomain) EmailCount " & _
               "FROM ( " & _
               "    SELECT [event], RIGHT(email, LEN(email) - CHARINDEX('@', email)) EmailDomain " & _
               "    FROM sendgrid_event  sg " & _
               "         JOIN [CME_CommInst] ci ON sg.cme_id=ci.CommInstID " & _
               "    WHERE [event] = '" & _event & "' " & _
               "    ) a " & _
               "GROUP BY a.EmailDomain " & _
               "ORDER BY EmailCount DESC"

        With _dbConn
            If .IsConnected Then
                .Query = mSQL
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.SELECT_QUERY
                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            Dim DataList As New List(Of Dictionary(Of String, Object))
                            Dim totalcnt As Integer = 0

                            While .Read
                                Dim dict As New Dictionary(Of String, Object)
                                Dim percent As Double = 0

                                totalcnt = totalcnt + .GetValue(1)

                                dict.Add("ISP", .GetValue(0))
                                dict.Add("TotalCnt", .GetValue(1))

                                DataList.Add(dict)
                            End While

                            _totalCount = totalcnt
                            _dataList = DataList
                        Else
                            _totalCount = 0
                        End If
                        .Close()
                    End With
                End If
            Else
                HasError = True
                ErrorMMsg = .ErrorMsg
                _totalCount = 0
            End If
        End With
    End Sub

    Private Sub GetUnqOpenClicksbyCountry(ByVal _event As String)
        Dim mSQL As String

        mSQL = "SELECT TOP 5 a.Address_Country,  COUNT(a.Address_Country) UnqOpenCnt " & _
              "FROM ( " & _
              "        SELECT DISTINCT ci.CME_CommLog, " & _
              "            ic.Address_Country " & _
              "        FROM [sendgrid_event] sg  " & _
              "            JOIN [CME_CommInst] ci ON sg.cme_id=ci.CommInstID " & _
              "		        JOIN CME_I_CAR ic ON ci.Individual=ic.CME_I_CAR " & _
              "        WHERE sg.event = '" & _event & "' " & _
              "    ) a " & _
              "GROUP BY a.Address_Country " & _
              "ORDER BY UnqOpenCnt DESC"
        GetResult(mSQL)

        If HasError = False Then
            If _event = "open" Then
                CountriesByUnqOpens = _dataList
                TotalUnqOpens = _totalCount
            Else
                CountriesByUnqClicks = _dataList
                TotalUnqClicks = _totalCount
            End If
        End If
    End Sub

    Private Sub GetOpenClicksbyCountry(ByVal _event As String)
        Dim mSQL As String

        mSQL = "SELECT TOP 5 ic.Address_Country, COUNT(ic.Address_Country) OpenCnt " & _
               "FROM [sendgrid_event] sg " & _
               "            JOIN [CME_CommInst] ci ON sg.cme_id=ci.CommInstID " & _
               "                JOIN CME_I_CAR ic ON ci.Individual=ic.CME_I_CAR " & _
               "WHERE sg.event = '" & _event & "' " & _
               "GROUP BY sg.[event], ic.Address_Country " & _
               "ORDER BY OpenCnt DESC"
        GetResult(mSQL)
        If HasError = False Then
            If _event = "open" Then
                CountriesByOpens = _dataList
                TotalOpens = _totalCount
            Else
                CountriesByClicks = _dataList
                TotalClicks = _totalCount
            End If
        End If
    End Sub

    Private Function GetTotalISPs(ByVal _event As String) As Int64
        Dim mSQL As String

        mSQL = "SELECT COUNT(sg.email) TotalEmails " & _
               "FROM sendgrid_event  sg " & _
               "     JOIN [CME_CommInst] ci ON sg.cme_id=ci.CommInstID " & _
               "WHERE [event] = '" & _event & "'"

        With _dbConn
            If .IsConnected Then
                Dim totalISPs As Int64 = 0

                .Query = mSQL
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.SELECT_QUERY
                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            While .Read
                                totalISPs = .GetValue(0)
                            End While
                        Else
                            totalISPs = 0
                        End If
                        .Close()
                    End With
                End If

                Return totalISPs
            Else
                HasError = True
                ErrorMMsg = .ErrorMsg
                Return 0
            End If
        End With

        Return 0
    End Function

    Private Sub GetResult(ByVal query As String)

        With _dbConn
            If .IsConnected Then
                .Query = query
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.SELECT_QUERY
                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            Dim DataList As New List(Of Dictionary(Of String, Object))
                            Dim totalcnt As Integer = 0

                            While .Read
                                Dim dict As New Dictionary(Of String, Object)
                                Dim percent As Double = 0

                                totalcnt = totalcnt + .GetValue(1)

                                dict.Add("Country", .GetValue(0))
                                dict.Add("TotalCnt", .GetValue(1))

                                DataList.Add(dict)
                            End While

                            _totalCount = totalcnt
                            _dataList = DataList
                        Else
                            _totalCount = 0
                        End If

                        .Close()
                    End With
                End If
            Else
                HasError = True
                ErrorMMsg = .ErrorMsg
                _totalCount = 0
            End If
        End With
    End Sub

End Class
