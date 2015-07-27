Imports System.Net
Imports System.Web.Http

Public Class EngagementApiController
    Inherits ApiController

    ' GET api/<controller>
    Public Function GetValues() As IEnumerable(Of String)
        Return New String() {"value1", "value2"}
    End Function

    ' GET api/<controller>/5
    Public Function GetValue(ByVal iCommLog As String) As String
        Return String.Concat("POST api/<controller>", iCommLog)
    End Function

    ' POST api/<controller>
    Public Function EmailPreview(ByVal CommLog As String) As String
        'Dim elib As New CuriousBLib.EngagementLib

        Return CommLog
        'Return elib.GetEmailContent(CommLog)

    End Function

    ' PUT api/<controller>/5
    Public Function PutValue(ByVal id As Integer, <FromBody()> ByVal value As String) As String
        Dim elib As New CuriousBLib.EngagementLib
        Return elib.GetEmailContent(value) & id
    End Function

    ' DELETE api/<controller>/5
    Public Sub DeleteValue(ByVal id As Integer)

    End Sub
End Class
