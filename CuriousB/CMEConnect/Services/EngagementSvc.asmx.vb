Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.ComponentModel

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
Public Class EngagementSvc
    Inherits WebService

    <WebMethod()> _
    Public Function EmailPreview(ByVal CommLog As Guid) As String
        Return String.Concat("Hello World ", CommLog)
    End Function

End Class