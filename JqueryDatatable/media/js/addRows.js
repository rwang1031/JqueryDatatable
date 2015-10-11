var addRows = function (obj, numberColumns, targetRows) {
    var tableRows = obj.find('tbody tr'), // data rows objects currently in the DOM
  numberNeeded = targetRows - tableRows.length, // how many blank rows are needed to fill up to targetRows
  lastRow = tableRows.last(), // cache the last data row
  lastRowCells = lastRow.children('td'), // how many visible columns are there?
  cellString,
  highlightColumn,
  rowClass;

    // The first row to be added actually ends up being the last row of the table.
    // Check to see if it should be odd or even. Expand logic if more than even/odd needed.
    if (targetRows % 2) {
        rowClass = "odd";
    } else {
        rowClass = "even"; //
    }

    // We only sort on 1 column, so let's find it based on its classname
    lastRowCells.each(function (index) {
        if ($(this).hasClass('sorting_1')) {
            highlightColumn = index;
        }
    });

    /* Iterate through the number of blank rows needed, building a string that will
    * be used for the HTML of each row. Another iterator inside creates the desired
    * number of columns, adding the sorting class to the appropriate TD.
    */
    for (i = 0; i < numberNeeded; i++) {
        cellString = "";
        for (j = 0; j < numberColumns; j++) {
            if (j === highlightColumn) {
                cellString += '<td class="sorting_1"> </td>';
            } else {
                cellString += '<td> </td>';
            }
        }

        // Add the TR and its contents to the DOM, then toggle the even/odd class
        // variable in preparation for the next.
        lastRow.after('<tr class="' + rowClass + ' dummyrows">' + cellString + '</tr>');
        rowClass = (rowClass === "even") ? "odd" : "even";
    }
};

