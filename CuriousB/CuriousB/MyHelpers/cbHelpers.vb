Imports System.Runtime.CompilerServices

Public Class cbHelpers
    Public Shared Function CutString(ByVal cString As String, Optional ByVal stringLen As Integer = 50) As String

        If cString.Length > stringLen Then

            Return cString.Substring(0, stringLen) & "..."

        End If

        Return cString
    End Function

    Public Shared Function ClusterName(ByVal cName As String) As String

        Select Case cName
            Case "click"
                Return "Click Rate"
            Case "opend"
                Return "Open Rate"
            Case "age"
                Return "Age Average"
            Case "female"
                Return "Female %"
        End Select

        Return Nothing
    End Function
End Class
