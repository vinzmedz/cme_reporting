Imports System.Configuration
Imports System.Configuration.ConfigurationManager
Imports System.IO
Imports System.Text

Public Class CuriousBLib

    ''' <summary>
    ''' Returns a specific connection string
    ''' </summary>
    ''' <param name="strConn"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetConnectionString(ByVal strConn As String) As String
        Return ConnectionStrings(strConn).ConnectionString
    End Function

    Public Shared Sub CreateJSONFile(ByVal json_filename As String, ByVal json_string As String)

        Dim strFile As String = "/table_data/" & json_filename & DateTime.Today.ToString("dd-MMM-yyyy") & ".json"
        Dim delFile As String = json_filename & DateTime.Now.AddHours(-1).ToString("dd-MMM-yyyy") & ".json"

        Dim sw As StreamWriter
        Try

            If (Not File.Exists(strFile)) Then
                sw = File.CreateText(strFile)
                'sw.WriteLine("Start Error Log for today")
            Else
                File.Delete(strFile)
                sw = File.CreateText(strFile)
            End If
            sw.Write(json_string)

            'sw.WriteLine("Error Message in " & function_name & " Occured at-- " & DateTime.Now)
            'sw.WriteLine("MSSQLClass.vb: " & error_msg & vbCrLf)
            sw.Close()
        Catch ex As IOException
            MsgBox("Error writing to log file.")
        End Try

    End Sub

    Public Shared Sub CreateErrorLog(ByVal function_name As String, ByVal code_filename As String, ByVal error_msg As String)
        Dim strFile As String = "D:\ErrorLog_" & DateTime.Today.ToString("dd-MMM-yyyy") & ".txt"
        Dim sw As StreamWriter
        Try
            If (Not File.Exists(strFile)) Then
                sw = File.CreateText(strFile)
                sw.WriteLine("Start Error Log for today")
            Else
                sw = File.AppendText(strFile)
            End If
            sw.WriteLine("Error Message in " & function_name & " Occured at-- " & DateTime.Now)
            sw.WriteLine("MSSQLClass.vb: " & error_msg & vbCrLf)
            sw.Close()
        Catch ex As IOException
            MsgBox("Error writing to log file.")
        End Try
    End Sub

End Class

