Imports System.Data
Imports System.Data.SqlClient
Imports MsSQLDatabase

Public Class EngagementLib : Implements IDisposable


    Protected _ListResult As List(Of Dictionary(Of String, Object))

#Region "Get and Set Definitions"

    Public ReadOnly Property HasError As Boolean
        Get
            Return _hasError
        End Get
    End Property

    Public ReadOnly Property ErrorMsg As String
        Get
            Return _errMsg
        End Get
    End Property

    Public Property CommLog As Guid
        Get
            Return _commLog
        End Get
        Set(value As Guid)
            _commLog = value
        End Set
    End Property

#End Region

    Private _dbConn As New MsSQLDatabase.MsSQLClass
    Private _strConn As String = ""

    Protected _hasError As Boolean = False
    Protected _errMsg As String = ""

    Protected _emailEngagements As New List(Of Dictionary(Of String, Object))

    Protected _deployDate As DateTime
    Protected _commName As String
    Protected _commLog As Guid

    ''' <summary>
    ''' Constructor for class called when NEW instance created
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub New()
        _strConn = CuriousBLib.GetConnectionString("SQLConn2")

        _dbConn = New MsSQLDatabase.MsSQLClass()
        _dbConn.dbOpen(_strConn)

    End Sub


#Region "Engagement Report Methods and Functions"

    Public Function GetLatestDeployments() As List(Of Dictionary(Of String, Object))
        Dim _LatestDeployements As New List(Of Dictionary(Of String, Object))
        Dim mSQL As String = "[rpt].[sp_LatestDeployment]"

        _hasError = False
        With _dbConn
            If .IsConnected Then
                .Query = mSQL
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.STORED_QUERY
                .MyCmd.CommandType = CommandType.StoredProcedure

                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            Dim LatestDeploymentsList As New List(Of Dictionary(Of String, Object))
                            Dim _Result = New ArrayList
                            '--Name, DateDeployed, Deployed, Opened, Clicked, Total
                            'Name	DateDeployed	deployed	opened	clicked	Rank	expectedOpenRate
                            While .Read
                                Dim dict As New Dictionary(Of String, Object)
                                Dim dep As Integer = .GetValue(2)
                                Dim opn As Integer = .GetValue(3)
                                Dim clk As Integer = .GetValue(4)



                                dict.Add("DateDeployed", .GetValue(1))
                                dict.Add("Name", .GetValue(0).ToString)
                                dict.Add("Deployed", dep)
                                dict.Add("Opened", opn)
                                dict.Add("Clicked", clk)
                                dict.Add("Rank", .GetValue(5))
                                dict.Add("ExpOpen", .GetValue(6))
                                LatestDeploymentsList.Add(dict)
                            End While
                            _LatestDeployements = LatestDeploymentsList
                        Else
                            _hasError = True
                            _errMsg = "Empty result."
                        End If
                        .Close()
                    End With
                Else
                    _hasError = True
                    _errMsg = .ErrorMsg
                End If

            Else
                _hasError = True
                _errMsg = .ErrorMsg
            End If

        End With

        If _hasError Then
            Return Nothing
        Else
            Return _LatestDeployements
        End If
    End Function

    Public Function GetEmailContent(ByVal commlog As String) As String

        Dim msql As String = String.Format("SELECT TOP 1 FullHTML FROM CME_CommInst WHERE CME_CommLog='{0}' AND FullHTML IS NOT NULL", commlog)
        Dim emailContent As String = ""

        emailContent = GetField(msql)

        If emailContent = Nothing Then
            Return "No Preview"
        Else
            Return emailContent
        End If

    End Function

    Public Function GetEngagementOverTimeDesc() As String
        Dim msql As String = "rpt.sp_EngagementOverTime_Desc"
        Dim mstr As String = ""

        _hasError = False
        With _dbConn
            .dbOpen(_strConn)

            If .IsConnected Then
                .Query = "rpt.sp_EngagementOverTime_Desc"
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.STORED_QUERY
                .MyCmd.CommandType = CommandType.StoredProcedure
                .MyCmd.Parameters.Clear()

                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then

                            'WeekRange, Dormant, Low, Medium, High, TotalCount, Seq
                            .Read()

                            mstr = .GetValue(0)
                        Else
                            _hasError = True
                            _errMsg = "Empty result."
                        End If

                        .Close()    'Close datareader
                    End With
                Else
                    _hasError = True
                    _errMsg = .ErrorMsg
                End If
            Else
                _hasError = True
                _errMsg = .ErrorMsg
            End If
        End With

        If _hasError Then
            Return Nothing
        Else
            Return mstr
        End If


    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetLatestCommunication() As Guid
        Dim mSQL As String
        mSQL = "rpt.sp_GetLatestCommLog"

        Dim dbConn As New MsSQLClass(mSQL)
        With dbConn
            .dbOpen(_strConn)
            If .IsConnected Then
                .Query = mSQL
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.STORED_QUERY
                .MyCmd.CommandType = CommandType.StoredProcedure
                .MyCmd.Parameters.Clear()

                .MyCmd.Parameters.Add("@CommLog", SqlDbType.UniqueIdentifier)
                .MyCmd.Parameters("@CommLog").Direction = ParameterDirection.Output
                .MyCmd.Parameters.Add("@DateDeploy", SqlDbType.DateTime)
                .MyCmd.Parameters("@DateDeploy").Direction = ParameterDirection.Output
                .MyCmd.Parameters.Add("@CommName", SqlDbType.VarChar, 50)
                .MyCmd.Parameters("@CommName").Direction = ParameterDirection.Output

                If .ExecuteQuery Then
                    _deployDate = .MyCmd.Parameters("@DateDeploy").Value
                    _commName = .MyCmd.Parameters("@CommName").Value
                    Return .MyCmd.Parameters("@CommLog").Value
                    .MyRdr.Close()
                Else
                    _hasError = True
                    _errMsg = .ErrorMsg
                End If
            Else
                _hasError = True
                _errMsg = .ErrorMsg
            End If
        End With
    End Function

    ''' <summary>
    ''' "rpt.sp_GetEventsSummary"
    ''' </summary>
    ''' <param name="query"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetCommunicationSummary(ByVal query As String) As Dictionary(Of String, Object)
        Dim latestDeployed As New Dictionary(Of String, Object)

        With _dbConn
            If .IsConnected Then
                .Query = query
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.STORED_QUERY
                .MyCmd.CommandType = CommandType.StoredProcedure
                .MyCmd.Parameters.Clear()

                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            While .Read
                                '0 CommLog
                                '1 TotalDeployed
                                '2 PctOpened
                                '3 PctClicked
                                '4 TotOpened
                                '5 TotClicked
                                '6 CommName
                                '7 OpenedRank
                                '8 ClickedRank

                                latestDeployed.Add("Deployed", .GetValue(1))
                                latestDeployed.Add("Opened", .GetValue(2))
                                latestDeployed.Add("Clicked", .GetValue(3))
                                latestDeployed.Add("TotalOpened", .GetValue(4))
                                latestDeployed.Add("TotalClicked", .GetValue(5))
                                latestDeployed.Add("CommLogName", .GetValue(6))
                                latestDeployed.Add("PrevOpened", .GetValue(7))
                                latestDeployed.Add("PrevClicked", .GetValue(8))
                                latestDeployed.Add("OpenRank", .GetValue(9))
                                latestDeployed.Add("ClickRank", .GetValue(10))
                                latestDeployed.Add("ExpectedOpenRate", .GetValue(11))
                                latestDeployed.Add("DeployDate", .GetValue(12))
                                latestDeployed.Add("EmailPreview", .GetValue(13))
                                'latestDeployed.Add("DateText", GenerateDateDeployText(.GetValue(12)))
                            End While
                        Else
                            _hasError = True
                            _errMsg = "Empty result."
                        End If
                        .Close()
                    End With
                Else
                    _hasError = True
                    _errMsg = .ErrorMsg
                End If
            Else
                _hasError = True
                _errMsg = .ErrorMsg
            End If
        End With

        If _hasError Then
            Return Nothing
        Else
            Return latestDeployed
        End If

    End Function

    ''' <summary>
    ''' This procedure accepts 2 types of engagement over time report
    ''' 1. weekly report
    ''' 2. rows by weeks, months and quarter
    ''' but only returns the same column result
    ''' </summary>
    ''' <param name="query">a stored procedure for that returns Engagement Over Time table</param>
    ''' <returns>
    ''' WeekRange, Dormant, Low, Medium, High, TotalCount
    ''' </returns>
    ''' <remarks></remarks>
    Public Function GetEngagementOverTime(ByVal query As String) As List(Of Dictionary(Of String, Object))
        Dim _EngagementList As New List(Of Dictionary(Of String, Object))

        _hasError = False

        With _dbConn
            .dbOpen(_strConn)

            If .IsConnected Then
                .Query = query
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.STORED_QUERY
                .MyCmd.CommandType = CommandType.StoredProcedure
                .MyCmd.Parameters.Clear()

                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then

                            'WeekRange, Dormant, Low, Medium, High, TotalCount, Seq
                            While .Read
                                Dim dict As New Dictionary(Of String, Object)
                                Dim hi, mi, lo, tot As Int64

                                lo = .GetValue(2)
                                mi = .GetValue(3)
                                hi = .GetValue(4)
                                tot = .GetValue(5)

                                dict.Add("WeekNo", .GetValue(0))
                                dict.Add("WeekRange", .GetValue(0))
                                dict.Add("Low", Math.Round(lo / tot * 100))
                                dict.Add("Medium", Math.Round(mi / tot * 100))
                                dict.Add("High", Math.Round(hi / tot * 100))
                                dict.Add("TotalCount", tot)
                                dict.Add("TotalLow", lo)
                                dict.Add("TotalMedium", mi)
                                dict.Add("TotalHigh", hi)
                                dict.Add("Dormant", .GetValue(1))
                                dict.Add("Seq", .GetValue(6))

                                _EngagementList.Add(dict)
                            End While

                            .Close()    'Close datareader
                        Else

                            _hasError = True
                            _errMsg = "Empty result."

                        End If

                    End With
                Else

                    _hasError = True
                    _errMsg = .ErrorMsg

                End If

            Else
                _hasError = True
                _errMsg = .ErrorMsg
            End If

        End With

        If _hasError Then
            Return Nothing
        Else
            Return _EngagementList
        End If

    End Function



#End Region

#Region "Private Functions"

    Private Function GenerateDateDeployText(ByVal _datedeploy As String) As String
        'Dim nDate As Date = DateTime.ParseExact(_datedeploy, "mm/dd/yyyy", System.Globalization.DateTimeFormatInfo.InvariantInfo)
        Dim dateNow As Date = Date.Now


        'Return nDate & "<br>" & dateNow
        Return ""
        'Get number of years 

    End Function

    ''' <summary>
    ''' Retrieve data from a database row into the member variables of the class
    ''' </summary>
    ''' <param name="query"></param>
    ''' <remarks></remarks>
    Private Function GetField(ByRef query As String) As Object
        Dim returnValue As Object = Nothing

        _hasError = False

        With _dbConn
            If .IsConnected Then
                .Query = query
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.SELECT_QUERY
                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            .Read()
                            returnValue = .GetValue(0)
                        Else
                            _hasError = True
                        End If
                        .Close()
                    End With
                Else
                    _hasError = True
                    _errMsg = .ErrorMsg
                End If
            Else
                _hasError = True
                _errMsg = .ErrorMsg
            End If
        End With

        If _hasError Then
            Return Nothing
        Else
            Return returnValue
        End If

    End Function

#End Region

#Region "IDisposable Support"
    Private disposedValue As Boolean ' To detect redundant calls

    ' IDisposable
    Protected Overridable Sub Dispose(disposing As Boolean)
        If Not Me.disposedValue Then
            If disposing Then
                ' TODO: dispose managed state (managed objects).
            End If

            ' TODO: free unmanaged resources (unmanaged objects) and override Finalize() below.
            ' TODO: set large fields to null.

            If _dbConn.IsConnected Then
                _dbConn.dbClose()
            End If

            _dbConn = Nothing

        End If
        Me.disposedValue = True
    End Sub

    ' TODO: override Finalize() only if Dispose(ByVal disposing As Boolean) above has code to free unmanaged resources.
    'Protected Overrides Sub Finalize()
    '    ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
    '    Dispose(False)
    '    MyBase.Finalize()
    'End Sub

    ' This code added by Visual Basic to correctly implement the disposable pattern.
    Public Sub Dispose() Implements IDisposable.Dispose
        ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        Dispose(True)
        GC.SuppressFinalize(Me)
    End Sub
#End Region

End Class