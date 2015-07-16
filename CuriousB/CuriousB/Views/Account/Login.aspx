<%@ Page Language="VB" MasterPageFile="~/Views/Shared/Login.Master" Inherits="System.Web.Mvc.ViewPage(Of CuriousB.LoginModel)" %>

<asp:Content ID="loginTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Log in
</asp:Content>

<asp:Content ID="loginContent" ContentPlaceHolderID="MainContent" runat="server">
		<div class="col-xs-10 col-xs-offset-1 col-sm-8 col-sm-offset-2 col-md-4 col-md-offset-4">
			<div class="login-panel panel panel-default">
				<div class="panel-heading">Log in</div>
				<div class="panel-body">
                    <% Using Html.BeginForm(New With { .ReturnUrl = ViewData("ReturnUrl") }) %>
                        <%: Html.AntiForgeryToken() %>
                        <%: Html.ValidationSummary(true) %>

						<fieldset>
							<div class="form-group">
                                <%: Html.LabelFor(Function(m) m.UserName) %>
                                <%: Html.TextBoxFor(Function(m) m.UserName) %>
                                <%: Html.ValidationMessageFor(Function(m) m.UserName) %>
							</div>
							<div class="form-group">
                                <%: Html.LabelFor(Function(m) m.Password) %>
                                <%: Html.PasswordFor(Function(m) m.Password) %>
                                <%: Html.ValidationMessageFor(Function(m) m.Password) %>
							</div>
							<div class="checkbox">
								<label>
                                    <%: Html.CheckBoxFor(Function(m) m.RememberMe) %>
                                    <%: Html.LabelFor(Function(m) m.RememberMe, New With { .Class = "checkbox" }) %>
								</label>
							</div>
                            <input type="submit" value="Log in" />
						</fieldset>
                    <% End Using %>
				</div>
			</div>
		</div><!-- /.col-->

    <section class="social" id="socialLoginForm">
        <h2>Use another service to log in.</h2>
        <% Html.Action("ExternalLoginsList", New With { .ReturnUrl = ViewData("ReturnUrl") }) %>
    </section>
</asp:Content>

<asp:Content ID="scriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/jqueryval") %>
</asp:Content>
