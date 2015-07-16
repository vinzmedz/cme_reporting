Imports System.Data
Imports System.Data.SqlClient
Imports MsSQLDatabase

Public Class EngagementLib

    Protected _ListResult As List(Of Dictionary(Of String, Object))

#Region "Get and Set Definitions"
    Public Property ListResult() As List(Of Dictionary(Of String, Object))
        Get
            Return _ListResult
        End Get
        Set(ByVal value As List(Of Dictionary(Of String, Object)))
            _ListResult = value
        End Set
    End Property

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

    Public ReadOnly Property StartDate As String
        Get
            Return _startDate
        End Get
    End Property

    Public ReadOnly Property EndDate As String
        Get
            Return _endDate
        End Get
    End Property

    Public ReadOnly Property CommName As String
        Get
            Return _commName
        End Get
    End Property

    Public ReadOnly Property DeployDate As DateTime
        Get
            Return _deployDate
        End Get
    End Property
#End Region

    Protected _strConn As String = ""
    Protected _hasError As Boolean = False

    Protected _errMsg As String = ""
    Protected _startDate As String
    Protected _endDate As String
    Protected _deployDate As DateTime
    Protected _commName As String

    ''' <summary>
    ''' Constructor for class called when NEW instance created
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub New()
        _strConn = CuriousBLib.GetConnectionString("SQLConn2")

    End Sub
    Public Function GetEmailContent(ByVal connlog As Guid) As String
        Dim msql As String = "SELECT "
        Return ""
    End Function

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

    Public Sub GetLatestDate()
        Dim mSQL As String

        mSQL = "SELECT TOP 1 CAST(Engagement_date AS date), CAST(GETDATE() AS date) " & _
               "FROM [EngagementHistory] " & _
               "ORDER BY Engagement_date ASC"

        Dim dbConn As New MsSQLClass(mSQL)
        With dbConn
            .dbOpen(_strConn)
            If .IsConnected Then
                .Query = mSQL
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.SELECT_QUERY
                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            Dim sDate As DateTime
                            Dim eDate As DateTime
                            While .Read
                                sDate = .GetValue(0)
                                eDate = .GetValue(1)
                            End While

                            _startDate = Format(sDate, "yyyy-MM-dd 00:00:00")
                            _endDate = Format(eDate, "yyyy-MM-dd 23:59:59")

                            '_startDate = sDate & " 00:00:00"
                            '_startDate = "05/01/2015 00:00:00"
                            '_endDate = "06/19/2015 23:59:59"
                            '_endDate = eDate & " 23:59:59"
                        End If
                        .Close()
                    End With
                End If
            Else
                _hasError = True
                _errMsg = .ErrorMsg
            End If
        End With

    End Sub

    ''' <summary>
    ''' Reset contents of member variables
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub GetEngagementHistory()
        Dim mSQL As String = "SELECT * " & _
                             "FROM EngagementHistory"

        Dim dbConn As New MsSQLClass(mSQL)

        dbConn.dbOpen(_strConn)
        dbConn.SQLType = MsSQLClass.QueryType.SELECT_QUERY

        dbConn.ExecuteQuery()
        If dbConn.MyRdr.HasRows Then
            Dim _ListResult As New List(Of Dictionary(Of String, Object))

            While dbConn.MyRdr.Read
                Dim dict As New Dictionary(Of String, Object)
                For count As Integer = 0 To (dbConn.MyRdr.FieldCount - 1)
                    If Not dict.ContainsKey(dbConn.MyRdr.GetName(count)) Then
                        dict.Add(dbConn.MyRdr.GetName(count), dbConn.MyRdr(count))
                    End If
                Next
                'dict.Add('band', )
                _ListResult.Add(dict)

            End While

        End If

    End Sub


    ''' <summary>
    ''' Retrieve data from a database row into the member variables of the class
    ''' </summary>
    ''' <param name="oDR"></param>
    ''' <remarks></remarks>
    Public Sub DataReaderToMemberVariables(ByRef oDR As Dictionary(Of String, Object))

    End Sub
End Class

Public Class Engagements
    Public Seq As Integer
    Public Edm As String
    Public Deployed As Integer
    Public Opened As Integer
    Public Clicked As Integer
    Public EngagementScore As Double
End Class