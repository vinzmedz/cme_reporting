Imports System.Data.SqlClient

Public Class MsSQLClass

#Region "ENUMS"

    Public Enum QueryType
        SELECT_QUERY = 1
        INSERT_QUERY = 2
        UPDATE_QUERY = 3
        DELETE_QUERY = 4
        STORED_QUERY = 5
    End Enum

    Public Enum FieldType
        STR_TYPE = 1
        INT_TYPE = 2
    End Enum

#End Region

#Region "Public Variables"

    Public MyCmd As New SqlCommand
    Public MyDta As SqlDataAdapter
    Public MyRdr As SqlDataReader

    Public ErrorMsg As String = ""

#End Region

#Region "Local Variables"

    Private _connStr As String
    Private Conn As SqlConnection

    Private _tableName As String

    Private sql As String
    Private _querytype As QueryType

    Private _intField As Int64
    Private _strField As String

    Private _isConneted As Boolean
    Private _dbAccess As DBAccess
#End Region

#Region "Methods"
    Public Sub New(Optional ByVal SQL_Query As String = "")

        _dbAccess = New DBAccess
        If SQL_Query <> "" Then
            sql = SQL_Query
        End If
    End Sub

    Public Sub dbOpen(ByVal cnstr As String)

        Try
            'ConnStr = "Server=" & _dbAccess.Servername & ";Database=" & _dbAccess.DatabaseName & ";User Id=" & _dbAccess.Username & ";Password=" & _dbAccess.Password & ";"

            _connStr = cnstr
            Conn = New SqlConnection(_connStr)

            Conn.Open()

            _isConneted = True
        Catch ex As SqlException
            'MsgBox("Error connecting to the database: " & _connStr)
            ErrorMsg = ex.ErrorCode & ": " & ex.Message

            _isConneted = False
        End Try
    End Sub

    Public Sub dbClose()
        _isConneted = False
        Conn.Close()
        Conn.Dispose()
    End Sub

#End Region

#Region "Functions"
    Public Sub GetField(ByVal Field As String, ByVal Table As String, ByVal Where As String, ByVal fType As FieldType)
        Dim mCmd As New SqlCommand
        Dim mDta As New SqlDataAdapter
        Dim mRdr As SqlDataReader

        Dim mSQL As String = "SELECT " & Field & " mField FROM " & Table & " " & Where
        mCmd.Connection = Conn
        mCmd.CommandText = mSQL
        mDta.SelectCommand = mCmd

        mRdr = mCmd.ExecuteReader

        If mRdr.HasRows Then
            Dim cntr As Integer = 0
            mRdr.Read()
            If fType = FieldType.STR_TYPE Then
                _strField = mRdr.GetString("mField").ToString
            End If

            If fType = FieldType.INT_TYPE Then
                _intField = mRdr.GetInt64("mField")
            End If
            mRdr.Close()
        End If
    End Sub

    Public Function ExecuteQuery() As Boolean
        Try
            MyCmd.Connection = Conn
            MyCmd.CommandText = sql

            If _querytype = QueryType.STORED_QUERY Then
                MyRdr = MyCmd.ExecuteReader
                Return True
            End If

            If _querytype = QueryType.SELECT_QUERY Then
                MyCmd.CommandType = CommandType.Text
                MyRdr = MyCmd.ExecuteReader
                Return True
            End If

            If _querytype = QueryType.INSERT_QUERY Then
                MyCmd.ExecuteNonQuery()
                Return True
            End If

            If _querytype = QueryType.UPDATE_QUERY Or _querytype = QueryType.DELETE_QUERY Then
                MyCmd.ExecuteNonQuery()
                Return True
            End If

        Catch ex As Exception
            'MsgBox("There was an error reading from the database.")
            ErrorMsg = ex.HResult & ": " & ex.Message
            Return False
        End Try

        Return False
    End Function


#End Region

#Region "Properties"
    Public Property TableName As String
        Get
            Return _tableName
        End Get
        Set(value As String)
            _tableName = value
        End Set
    End Property

    Public ReadOnly Property IsConnected As Boolean
        Get
            Return _isConneted
        End Get
    End Property

    Public WriteOnly Property DB_Access
        Set(value)
            _dbAccess = value
        End Set
    End Property

    Public ReadOnly Property IntField As Int64
        Get
            Return _intField
        End Get
    End Property

    Public ReadOnly Property StrField As String
        Get
            Return _strField
        End Get
    End Property

    Public Property SQLType As QueryType
        Get
            Return _querytype
        End Get
        Set(value As QueryType)
            _querytype = value
        End Set
    End Property

    Public Property Query As String
        Set(value As String)
            sql = value
        End Set
        Get
            Return sql
        End Get
    End Property

#End Region

End Class

Public Class DBAccess
    Public DatabaseName As String
    Public Servername As String
    Public Username As String
    Public Password As String
End Class


