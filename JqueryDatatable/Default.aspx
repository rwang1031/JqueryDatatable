<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="JqueryDatatable.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"> 
     <script type="text/javascript">

         var row_selected = [];

         var table;

         $(function () {


             var sessionValue = getSelectedRowsFromSessionStorage();


             if (sessionValue != null) {
                 row_selected = getSelectedRowsFromSessionStorage();
             }

             
             InitiatePersonTable1();

             InitiatePersonTable2();

             $('#table_person tbody').on('click', 'input[type="checkbox"]', function (e) {

                 var $row = $(this).closest('tr');
                 var data = table.fnGetData($row);

                 var rowid = data.PersonID;
                 var index = $.inArray(rowid, row_selected);
                 if (this.checked && index == -1) {
                     row_selected.push(rowid);
                 } else if (!this.checked && index != -1)
                 {
                     row_selected.splice(index, 1);
                 }

                 saveSelectedRowsToSessionStorage()

                 if (this.checked) {
                     $row.addClass('selected');
                 } else {
                     $row.removeClass('selected');
                 }

                 e.stopPropogation();

               
             });

             $('#table_person').on('click', 'tbody td', function (e) {
                 $(this).parent().find('input[type="checkbox"]').trigger('click');
             });
         
         });


         function saveSelectedRowsToSessionStorage()
         {
             sessionStorage.setItem("row_selected", JSON.stringify(row_selected));
         }

         function getSelectedRowsFromSessionStorage()
         {
             return JSON.parse(sessionStorage.getItem("row_selected"));
         }

         function Person(PersonID, FirstName, LastName, Title) {
             this.PersonID = PersonID
             this.FirstName = FirstName;
             this.LastName = LastName;
             this.Title = Title;
         }

             function GetPersons()
             {
                 $.ajax({
                     type: "GET",
                     dataType: 'json',
                     url: "PersonService.svc/GetPersons",
                     contentType: "application/json; charset=utf-8",
                     success: function(){},
                     error: function (error) {
                         alert(JSON.stringify(error));
                     }
                 });//ajax end;
             }

             function InitiatePersonTable1() {

                 table = $('#table_person').dataTable({
                     "bRetrieve": true,
                     "bPaginate": true,
                     serverSide: true,
                     ajax: 'PersonService.svc/GetPersons',
                     columns: [{ 'data': 'PersonID', 'title': 'PersonIDs' }, { 'data': 'FirstName', 'title': 'FirstNames' }, { 'data': 'LastName', 'title': 'LastNames' }, { 'data': 'Title', 'title': 'PersonTitle' }],
                     columnDefs: [{
                         'targets': 0, 'searchable': false, 'orderTable': false, 'className': 'checkbox_column', 'render': function (data, type, full, meta) {
                             return '<input type="checkbox">';
                         }
                     }],
                     "rowCallback": function (row, data, dataIndex) {


                         var rowId = data.PersonID;

                         var index = $.inArray(rowId, row_selected);

                         if (index !== -1) {
                             $(row).find('input[type="checkbox"]').prop('checked', true);
                             $(row).addClass('selected');
                         }

                     },
                     "bAutoWidth": false,
                     "iDisplayLength": 5,
                     "sPaginationType": "full"
                     //,"dom": '<"top"fr>t<"bottom"p><"clear">'
                     , stateSave: true
                 });
             }


                 function InitiatePersonTable2()
                 {
                       $('#table_selected').dataTable({
                         "bRetrieve": true,
                         "bPaginate": true,
                         serverSide: false,
                         columns: [{ 'data': 'PersonID', 'title': 'PersonIDs' }, { 'data': 'FirstName', 'title': 'FirstNames' }, { 'data': 'LastName', 'title': 'LastNames' }, { 'data': 'Title', 'title': 'PersonTitle' }],
                         columnDefs:[{'targets':3,'searchable':false,'orderTable':false,'className':'remove_column','render':function(data,type,full,meta){
                             return '<a class = remove_button  type="checkbox">Remove</a>';
                         }
                         }],
                         pageLength:5,
                         "rowCallback": function (row, data, dataIndex) {

                         },
                         "bAutoWidth": false,
                         "iDisplayLength": 5,
                         "sPaginationType": "full"
                         //,"dom": '<"top"fr>t<"bottom"p><"clear">'
                         ,stateSave:true
                     });
             }

    </script>

</asp:Content>
 
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

     <table id="table_person">
      </table>
      <table id="table_selected">
      </table>

</asp:Content>
