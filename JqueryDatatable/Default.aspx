<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="JqueryDatatable.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"> 
     <script type="text/javascript">
         $(function () {


             $.ajax({
                 type: "GET",
                 dataType: 'json',
                 url: "PersonService.svc/GetPersons",
                 contentType: "application/json; charset=utf-8",
                 success: function (result) {
                     alert(JSON.stringify(result));
                 },
                 error: function (error) {
                     alert(JSON.stringify(error));
                 }
             });//ajax end;


         });

         function Person(PersonID, FirstName, LastName, Title) {
             this.PersonID = PersonID
             this.FirstName = FirstName;
             this.LastName = LastName;
             this.Title = Title;
         }
    </script>

</asp:Content>

 
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
</asp:Content>
