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

    Public EmailsSent As New List(Of CommLogs)

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
                            Dim CommEmails As New List(Of CommLogs)

                            While .Read
                                Dim oRR_CLogs As New CommLogs

                                oRR_CLogs.Seq = .GetValue(5)
                                oRR_CLogs.CommLog = .GetValue(0).ToString
                                oRR_CLogs.Name = .GetValue(1).ToString
                                oRR_CLogs.NumDeployed = .GetValue(2)
                                oRR_CLogs.NumReceived = .GetValue(3)
                                oRR_CLogs.DateDeployed = .GetValue(4).ToString

                                CommEmails.Add(oRR_CLogs)
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
