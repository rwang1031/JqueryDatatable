<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="JqueryDatatable.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"> 
     <script type="text/javascript">

         var row_selected = [];
         var row_selected_data = [];

         var table;
         var table2;

         $(function () {

             var sessionValue = getSelectedRowsFromSessionStorage();

             if (sessionValue != null) {
                 row_selected =  sessionValue;
             }

             var sessionValue2 = getSelectedRowsDataFromSessionStorage();

             if (sessionValue2 != null)
             {
                 row_selected_data = sessionValue2;
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
                     letmesee(table.fnGetData($row));
                     row_selected_data.push(table.fnGetData($row));
                     
                 } else if (!this.checked && index != -1)
                 {
                     row_selected.splice(index, 1);
                     row_selected_data.splice(index, 1);
                 }

                 saveSelectedRowsToSessionStorage()

                 if (this.checked) {
                     $row.addClass('selected');
                 } else {
                     $row.removeClass('selected');
                 }

                 e.stopPropogation();

               
             });//

             $('#table_person').on('click', 'tbody td', function (e) {
                 $(this).parent().find('input[type="checkbox"]').trigger('click');
             });//

             $('#addToListBtn').on('click', function (e) {
                 e.preventDefault();

                              
                 var existingData = table2.fnGetData();
                 var difference = [];

                  //push only what the table2 doesn't have.           
                  $.grep(row_selected_data, function (element) {

                     if ($.inArray(element, existingData) == -1)
                     {
                          difference.push(element);
                     }
                 });
                 
                 if(difference.length!=0)
                 table2.fnAddData(difference);

             });
            
         });


         function saveSelectedRowsToSessionStorage()
         {
             sessionStorage.setItem("row_selected", JSON.stringify(row_selected));
             sessionStorage.setItem("row_selected_data", JSON.stringify(row_selected_data));

         }

         function getSelectedRowsFromSessionStorage()
         {
             return JSON.parse(sessionStorage.getItem("row_selected"));
         }

         function getSelectedRowsDataFromSessionStorage() {
             return JSON.parse(sessionStorage.getItem("row_selected_data"));
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
                    table2 =  $('#table_selected').dataTable({
                         "bRetrieve": true,
                         "bPaginate": true,
                         serverSide: false,
                         columns: [{ 'data': 'PersonID', 'title': 'PersonIDs' }, { 'data': 'FirstName', 'title': 'FirstNames' }, { 'data': 'LastName', 'title': 'LastNames' }, { 'data': 'Title', 'title': 'PersonTitle' }],
                         columnDefs:[{'targets':3,'searchable':false,'orderTable':false,'className':'remove_column','render':function(data,type,full,meta){
                             return '<a class = remove_button >Remove</a>';
                         }
                         }],
                         pageLength:10,
                         "rowCallback": function (row, data, dataIndex) {

                         },
                         "drawCallback":function(settings){
                            
                             var numcolumns = this.oApi._fnVisbleColumns(settings);
                             addRows(this, numcolumns, 10);
                         }
                           ,
                         "bAutoWidth": false,
                         "iDisplayLength": 5,
                         "sPaginationType": "full"
                         //,"dom": '<"top"fr>t<"bottom"p><"clear">'
                         ,stateSave:true
                     });
                 }


                
                function letmesee(object){
                    alert(JSON.stringify(object));
                 }

    </script>

</asp:Content>
 
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

     <table id="table_person">
     </table>
     <table id="table_selected">
     </table>

     <div id="table1_buttons_div">
         <button id="addToListBtn">Add Perons To List</button>
     </div>

</asp:Content>
