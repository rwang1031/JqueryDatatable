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

              //select funds by clicking on the row
             $('#table_person tbody').on('click', 'input[type="checkbox"]', function (e) {
                
                 var row = this.closest('tr');
                 var data = table.fnGetData(row);

                 var rowid = data[0];
                 var index = $.inArray(rowid, row_selected);
                 if (this.checked && index == -1) {
                     row_selected.push(rowid);
                     row_selected_data.push(data);
                     
                 } else if (!this.checked && index != -1)
                 {
                     row_selected.splice(index, 1);
                     row_selected_data.splice(index, 1);
                 }

                 saveSelectedRowsToSessionStorage()

                 if (this.checked) {
                     $(row).addClass('selected');
                 } else {
                     $(row).removeClass('selected');
                 }
                 e.stopPropogation();
             });//


             $('#table_person').on('click', 'tbody td', function (e) {
                 $(this).parent().find('input[type="checkbox"]').trigger('click');
             });//


            // Add selected funds to table2.
             $('#addToListBtn').on('click', function (e) {
                 e.preventDefault();
                  
                 var existingData = [];

                 existingData = table2.fnGetData();

                 var existingInstrumentIDs = [];

                
                 for (i = 0; i < existingData.length; i++)
                 {
                     existingInstrumentIDs.push(existingData[i][0]);
                 }
           
                 var difference = [];


                  //push only what the table2 doesn't have.           
                  $.grep(row_selected_data, function (element) {

                      if ($.inArray(element[0], existingInstrumentIDs) == -1)
                     {                         
                         var clone = [];

                         for (i = 0; i < element.length; i++)
                         {
                             clone.push(element[i]);

                         }
                             clone.push("{remove}")

                          difference.push(clone);
                     }
                 });
                 
                 if(difference.length!=0)
                     table2.fnAddData(difference);

             });

             //clear selected from table1
             $('#clearTableBtn').on('click', function (e) {
                 e.preventDefault();

             row_selected = [];
             row_selected_data = [];
             sessionStorage.setItem("row_selected", row_selected);

             sessionStorage.setItem("row_selected_data", row_selected_data);
             table.fnDraw();
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


             function InitiatePersonTable1() {

                 table = $('#table_person').dataTable({
                     "bRetrieve": true,
                     "bPaginate": true
                     , "bServerSide": true
                     , "sAjaxSource": 'PersonService.svc/GetFundsLegacy'
                      , "aoColumnDefs": [{
                          'aTargets': [0], 'bSearchable': false, 'mRender': function (data, type, full) {
                              return '<input type="checkbox">';
                          }
                      }]
                     , "fnRowCallback": function (row, data, dataIndex,displayIndexFull) {

                         var rowId = data[0]

                         var index = $.inArray(rowId, row_selected);

                         if (index !== -1) {
                             $(row).find('input[type="checkbox"]').prop('checked', true);
                             $(row).addClass('selected');
                         }

                     }
                     ,"bJQueryUI":false
                     , "bAutoWidth": false
                     , "iDisplayLength": 10
                     //, "sPaginationType": "full"
                     ,"sDom": '<"top"fr>t<"bottom"p><"clear">'
                     //, stateSave: true
                     , 'aoColumns': [{ "sTitle": "InstrumentID", "sWidth": "20%" },
                                     { "sTitle": "Fund Serve Code", "sWidth": "20%", "bSearchable": true },
                                     { "sTitle": "Fund Name", "sWidth": "20%", "bSearchable": true },
                                     { "sTitle": "Fund Type", "sWidth": "20%", "bSearchable": true }
                     ],
                 });
                     
             }


                 function InitiatePersonTable2()
                 {
                    table2 =  $('#table_selected').dataTable({
                         "bRetrieve": true,
                         "bPaginate": true,
                         "bServerSide": false
                         ,"aoColumnDefs":[{'aTargets':[4],'mRender':function(data,type,full){
                             return '<a class="remove_button" href="" >Remove</a>';
                         }
                         }]
                         , 'aoColumns': [{ "sTitle": "InstrumentID", "sWidth": "20%", "bSearchable": true, "bVisible": false },
                                          { "sTitle": "Fund Serve Code", "sWidth": "20%", "bSearchable": true },
                                          { "sTitle": "Fund Name",  "sWidth": "20%", "bSearchable": true },
                                          { "sTitle": "Fund Type", "sWidth": "20%", "bVisible": true },
                                          { "sTitle": "Remove", "sWidth": "20%", "bVisible": true }]
                        
                         , "fnRowCallback": function (row, data, dataIndex) {

                             $(row).on('click','a', function (e) {
                                 e.preventDefault();
                                 table2.fnDeleteRow(row);
                                 e.stopPropogation();
                             });

                         }
                         ,"fnDrawCallback":function(settings){
                            
                             var numcolumns = this.oApi._fnVisbleColumns(settings);
                             addRows(this, numcolumns, 10);
                             
                         }
                         ,"bAutoWidth": false
                         , "iDisplayLength": 10
                         ,"sDom": '<"top"fr>t<"bottom"p><"clear">'
                    });

                 }


                
                   function letmesee(object){
                    alert(JSON.stringify(object));
                 }

    </script>

</asp:Content>
 
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

     <div id="content_wrapper">
     <table id="table_person">
     </table>
     <table id="table_selected">
     </table>
     <div id="table1_buttons_div">
         <button id="addToListBtn">Add Perons To List</button>&nbsp;&nbsp; <button id="clearTableBtn">Clear</button>
     </div>
      </div>

</asp:Content>
