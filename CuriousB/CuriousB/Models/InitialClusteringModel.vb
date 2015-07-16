Imports System.Globalization
Imports System.Configuration
Imports System.Configuration.ConfigurationManager
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Imports CuriousBLib

Public Class InitialClusteringModel
    Private _dbConn As MsSQLDatabase.MsSQLClass
    Private _strConn As String

    Public EmailInitialCluster As New List(Of Dictionary(Of String, Object))

    Public HasError As Boolean = False
    Public ErrorMMsg As String = ""
    Public CurrentNumberFormat = New CultureInfo("en-US", False).NumberFormat

    Public Sub New()
        CurrentNumberFormat.CurrencyDecimalDigits = 2

        _strConn = ConnectionStrings("SQLConn2").ConnectionString

        GetInitialClustering()

    End Sub

    Public Sub GetInitialClustering()
        Dim mSQL As String = "rpt.sp_Initial_Clustering"

        _dbConn = New MsSQLDatabase.MsSQLClass(mSQL)

        With _dbConn
            .dbOpen(_strConn)
            If .IsConnected Then
                .SQLType = MsSQLDatabase.MsSQLClass.QueryType.STORED_QUERY
                .MyCmd.CommandType = CommandType.StoredProcedure

                'Cluster, Clicked, Opened, Age, Female
                If .ExecuteQuery Then
                    With .MyRdr
                        If .HasRows Then
                            Dim InitialClusterList As New List(Of Dictionary(Of String, Object))

                            While .Read
                                Dim dict As New Dictionary(Of String, Object)

                                dict.Add("Name", .GetValue(0))
                                dict.Add("Cluster_1", .GetValue(1))
                                dict.Add("Cluster_2", .GetValue(2))
                                dict.Add("Cluster_3", .GetValue(3))
                                dict.Add("Cluster_4", .GetValue(4))
                                dict.Add("Cluster_5", .GetValue(5))
                                dict.Add("Cluster_6", .GetValue(6))
                                dict.Add("Cluster_7", .GetValue(7))
                                dict.Add("Cluster_8", .GetValue(8))
                                dict.Add("Cluster_9", .GetValue(9))

                                InitialClusterList.Add(dict)
                            End While

                            EmailInitialCluster = InitialClusterList

                        End If
                    End With
                Else
                    HasError = True
                    ErrorMMsg = .ErrorMsg
                End If

                .dbClose()
            Else
                HasError = True
                ErrorMMsg = .ErrorMsg
            End If

        End With

    End Sub

End Class
