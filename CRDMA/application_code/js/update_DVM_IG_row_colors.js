function update_DVM_IG_row_colors ()
{

//    console.log('running update_IG_row_colors()');

    var ig$ = apex.region("data_validation_issues").widget();
//    console.log('ig is: ');
//    console.log(ig$);
    var model = ig$.interactiveGrid("getViews", "grid").model;
//    console.log('model is: ');
//    console.log(model);


    //re-initialize the counter for setting the values for each record
    i = 0;
    model.forEach(function(r, index, id)
    {
//        console.log('the current value of r is: ');
//        console.log(r);

				//retrieve the ROW_CLASS based on the issue category
				var row_class_val = model.getValue( r, "ROW_CLASS");
//        console.log('the value of row_class_val is: '+row_class_val);

				//retrieve the ISS_ID primary key value
				var data_id = model.getValue( r, "ISS_ID");

//        console.log('the value of data ID is: '+data_id);

//        console.log('the selector value is: '+'*[data-id="'+data_id+'"]');

//        console.log('the value of data ID is: '+r[0]);

				//retrieve the table row element based on the data_id value
        var tr_elem = $('*[data-id="'+data_id+'"]');

//        console.log('the value of tr_elem is: ');
        console.log(tr_elem);

//        console.log('Add the class to the row element: '+row_class_val);





				//add the css row class to the current row (based on ROW_CLASS column value):
        tr_elem.addClass(row_class_val);


				//add the alternative text/title attributes for the given data issue
				if (row_class_val == 'resolved-issue')
				{
					var temp_msg = "This validation issue has been resolved (Issue Resolution was defined)";
					tr_elem.attr("title", temp_msg);
//					tr_elem.title = temp_msg;
					tr_elem.attr("alt", temp_msg);
				}
				else if (row_class_val == 'unresolved-error')
				{
					var temp_msg = "This validation error has not been resolved (Issue Resolution was not defined)";
					tr_elem.attr("alt", temp_msg);
					tr_elem.attr("title", temp_msg);

				}
				else if (row_class_val == 'unresolved-warning')
				{
					var temp_msg = "This validation warning has not been resolved (Issue Resolution was not defined)";
					tr_elem.attr("title", temp_msg);
					tr_elem.attr("alt", temp_msg);
				}




        //increment the counter:
        i ++;
    });
}
