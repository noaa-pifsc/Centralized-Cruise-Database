function update_DVM_IG_row_colors ()
{

    console.log('running update_IG_row_colors()');

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
/*        console.log('the current value of r is: ');
        console.log(r);

        console.log('the value of data ID is: '+r[0]);
//        console.log('the value of row ID is: '+r[1]);

        console.log('the selector value is: '+'*[data-id="'+r[8]+'"]');
*/
        var tr_elem = $('*[data-id="'+r[8]+'"]');

/*        console.log('the value of tr_elem is: ');
        console.log(tr_elem);

        console.log('Add the class to the row element: '+r[14]);

        console.log('after the class was added the value of tr_elem is: ');
        console.log(tr_elem);
*/



				//add the css row class to the current row (based on ROW_CLASS value - currently in element [14] in the result set):
        tr_elem.addClass(r[14]);

				//add the alternative text/title attributes for the given data issue
				if (r[14] == 'resolved-issue')
				{
					var temp_msg = "This cruise issue has been resolved (Issue Resolution was defined)";
					tr_elem.attr("title", temp_msg);
//					tr_elem.title = temp_msg;
					tr_elem.attr("alt", temp_msg);
				}
				else if (r[14] == 'unresolved-error')
				{
					var temp_msg = "This cruise error has not been resolved (Issue Resolution was not defined)";
					tr_elem.attr("alt", temp_msg);
					tr_elem.attr("title", temp_msg);

				}
				else if (r[14] == 'unresolved-warning')
				{
					var temp_msg = "This cruise warning has not been resolved (Issue Resolution was not defined)";
					tr_elem.attr("title", temp_msg);
					tr_elem.attr("alt", temp_msg);
				}




        //increment the counter:
        i ++;
    });
}
