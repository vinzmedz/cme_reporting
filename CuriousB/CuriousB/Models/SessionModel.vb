Imports System.ComponentModel
Imports System.ComponentModel.DataAnnotations

Public Class SessionModel

End Class

Public Class DatabaseAccess : Implements IDatabaseAccess

    Private _databaseName As String
    Private _servername As String
    Private _dbUsername As String
    Private _dbPassword As String

    Public Property DatabaseName As String Implements IDatabaseAccess.DatabaseName
        Get
            Return _databaseName
        End Get
        Set(value As String)
            _databaseName = value
        End Set
    End Property

    Public Property ServerName As String Implements IDatabaseAccess.ServerName
        Get
            Return _servername
        End Get
        Set(value As String)
            _servername = value
        End Set
    End Property

    <Required()> _
    Public Property DbUsername As String Implements IDatabaseAccess.DbUsername
        Get
            Return _dbUsername
        End Get
        Set(value As String)
            _dbUsername = value
        End Set
    End Property

    <Required()> _
    Public Property DbPassword As String Implements IDatabaseAccess.DbPassword
        Get
            Return _dbPassword
        End Get
        Set(value As String)
            _dbPassword = value
        End Set
    End Property
End Class

Public Interface IDatabaseAccess
    Property DatabaseName As String
    Property ServerName As String
    Property DbUsername As String
    Property DbPassword As String
End Interface

Public Interface ISessionService
    Property UserID As Integer
    Property Username As String
End Interface