Imports System.Globalization
Imports System.Configuration
Imports System.Configuration.ConfigurationManager
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Imports CuriousBLib

Public Class EmailEngagementModel

    Private _dbConn As MsSQLDatabase.MsSQLClass
    Private _strConn As String

    Public EmailsSent As New List(Of Dictionary(Of String, Object))
    'Public EmailsSent As New List(Of CommLogs)

    Public HasError As Boolean = False
    Public ErrorMMsg As String = ""
    Public CurrentNumberFormat = New CultureInfo("en-US", False).NumberFormat

    Public Sub New()
        CurrentNumberFormat.CurrencyDecimalDigits = 2

        _strConn = ConnectionStrings("SQLConn2").ConnectionString

        GetEmailsSent()

    End Sub

    Public Sub GetEmailsSent()
        'Dim cList = (From dc In myP.GetCountriesTours Select dc.CountryID, dc.Country).Distinct
        Dim mSQL As String = "rpt.sp_ListCommlogs"

        _dbConn = New MsSQLDatabase.MsSQLClass(mSQL)

        With _dbConn
            .dbOpen(_strConn)

            If .IsConnected Then
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.STORED_QUERY
                .MyCmd.CommandType = CommandType.StoredProcedure

                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            Dim CommEmails As New List(Of Dictionary(Of String, Object))

                            While .Read
                                Dim dict As New Dictionary(Of String, Object)

                                dict.Add("Seq", .GetValue(5))
                                dict.Add("CommLog", .GetValue(0).ToString)
                                dict.Add("Name", .GetValue(1).ToString)
                                dict.Add("NumDeployed", String.Format(CultureInfo.InvariantCulture, "{0:0}%", .GetValue(2)))
                                dict.Add("NumReceived", String.Format(CultureInfo.InvariantCulture, "{0:0}%", .GetValue(3)))
                                dict.Add("DateDeployed", .GetValue(4).ToString)

                                CommEmails.Add(dict)
                            End While
                            EmailsSent = CommEmails

                        End If
                    End With
                Else
                    ErrorMMsg = ErrorMMsg & "<br>" & .ErrorMsg
                End If

                .dbClose()
            Else
                HasError = True
                ErrorMMsg = .ErrorMsg
            End If
        End With

    End Sub

End Class
