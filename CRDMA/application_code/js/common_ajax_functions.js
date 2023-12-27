var htmldb_delete_message='"DELETE_CONFIRM_MSG"';

var lSpinner$;

/*

//should we implement an ajax callback?
	On filter checkbox click send the selected values and Filter List checkbox to server process

	//query the DB and return the json that contains the options
	In javascript clear both sides of the shuttle, parse the JSON, set the options on the left side and then set the options on the right side

*/



//function update_shuttle_options will parse a json object (pData) and refresh an APEX shuttle item with an id of shuttle_id with the parsed option data
function update_shuttle_options(pData, shuttle_id)
{

//	console.log('the value of pData is: '+pData);



	//parse the json array to get each record's value:
	var json_array = jQuery.parseJSON(pData);


//	console.log (json_array);

//	console.log ('the value of \$v("'+shuttle_id+'") is: '+$v(shuttle_id));

//	console.log ($("#"+shuttle_id));

	//construct the array of
	var selected_option_array = $v(shuttle_id).split(":");


//	console.log('clear the left shuttle');
	//clear the options from the shuttle
	var left_shuttle = $("#"+shuttle_id+"_LEFT").empty();
	//left_shuttle.find('option').remove();

//	console.log('clear the right shuttle');
	var right_shuttle = $("#"+shuttle_id+"_RIGHT").empty();
//			right_shuttle.find('option').remove();

//	$("#"+shuttle_id+"_LEFT").refresh();
//	console.log(left_shuttle);

//	$("#"+shuttle_id+"_RIGHT").refresh();

//	console.log(right_shuttle);


//	alert('the shuttle options have been cleared');

//	console.log ('the value of the selected_option_array is: ');

//	console.log (selected_option_array);


	var found = false;


	//create a new blank row for each associated other species records:
	for (var i = 0; i < json_array['options'].length; i++)
	{

		//initialize the boolean to indicate when a matching shuttle element has been found:
		found = false;

//		console.log(json_array['options'][i]);

		for (var j = 0; ((j < selected_option_array.length) && (!found)); j ++)
		{
			//check if the current select_option_array element matches the current shuttle option's OPTION_ID value
			found = (selected_option_array[j] == json_array['options'][i]['OPTION_ID']);

		}


		//construct the HTML for the current option value
		var current_option = '<option value="'+json_array['options'][i]['OPTION_ID']+'">'+json_array['options'][i]['OPTION_VALUE']+'</option>';

//		console.log ('the value of current_option is: '+current_option);

		//check if the shuttle option is selected, if so add it to the right shuttle if not add it to the left shuttle
		if (found)
		{
//			console.log ('the shuttle option is selected, add it to the right shuttle');
			right_shuttle.append(current_option);
		}
		else
		{
//			console.log ('the shuttle option is NOT selected, add it to the left shuttle');
			left_shuttle.append(current_option);
		}

//								var temp = ig$.interactiveGrid("getActions").invoke("row-add-row");

//								console.log('the new row was added successfully');
	}

//	left_shuttle.refresh();
//	right_shuttle.refresh();

//	console.log ('the options have been refreshed');







}



//function update_select_options will parse a json object (pData) and refresh an APEX select item with an id of select_id with the parsed option data.	The function will also set the selected option before the request to the selected option after the Ajax request has been processed
function update_select_options(pData, select_id)
{

//	console.log('the value of pData is: '+pData);

	console.log ('running update_select_options: '+select_id);

	//parse the json array to get each record's value:
	var json_array = jQuery.parseJSON(pData);


//	console.log (json_array);

//	console.log ('the value of \$v("'+select_id+'") is: '+$v(select_id));

//	console.log ($("#"+select_id));

	//save the currently selected select form field option
	var selected_option = $v(select_id);
//	console.log('the value of the selected option is: '+selected_option);

	//clear the options from the select element
	var select_item = $("#"+select_id).empty();

	//add the blank default option:
	var current_option = '<option value="">-</option>';

	//add the current option to the select item
	select_item.append(current_option);

//	alert('the select options have been cleared');

	//create a new blank row for each associated other species records:
	for (var i = 0; i < json_array['options'].length; i++)
	{
		//construct the HTML for the current option value, if it matches the currently selected item then add the "selected" attribute to the HTML element
		current_option = '<option value="'+json_array['options'][i]['OPTION_ID']+'"'+(selected_option == json_array['options'][i]['OPTION_ID'] ? " selected" : "")+'>'+json_array['options'][i]['OPTION_VALUE']+'</option>';


		//add the current option to the select item
		select_item.append(current_option);
//		console.log ('the value of current_option is: '+current_option);
	}

}

//function that hides the spinner and re-enables the apex items in the item_array and enables the buttons for the HTML element id properties stored in the button_array
function enable_form_fields (item_array, button_array)
{

	//re-enable all items in the item_array variable
	for (var i = 0; i < item_array.length; i ++)
	{
		//enable the current item in the page
		apex.item (item_array[i]).enable();
	}

	//re-enable buttons in the button_array variable
	for (i = 0; i < button_array.length; i ++)
	{
		//enable the current button using the button ID
		$("#"+button_array[i]).attr("disabled", false);
	}

	//hide the spinner
	lSpinner$.remove();
}


function disable_form_fields (item_array, button_array)
{
	console.log ('running disable_form_fields()');
	 	//show the spinner to indicate a request has been sent to the server
	lSpinner$ = apex.util.showSpinner();


	//disable all items in the item_array variable
	for (var i = 0; i < item_array.length; i ++)
	{
//		console.log ("disable the current apex item: "+item_array[i]);
		//disable the current item in the page
		apex.item (item_array[i]).disable();
	}

	//disable all buttons in the button_array variable
	for (i = 0; i < button_array.length; i ++)
	{
		//disable the current button using the button ID
		$("#"+button_array[i]).attr("disabled", true);
	}

}

//function to update interactive grids based on JSON data (json_array) returned from Ajax callbacks.	The function is intended for use on a parent region with child regions implemented as tabs
//parent_region_id is the parent region that implements the other regions as tabs
//ig_id is the interactive grid's static id that will be updated based on the data in json_array
function update_interactive_grid (json_array, parent_region_id, ig_id)
{
//	console.log('the value of the selected tab (a href) is: '+$('#'+parent_region_id+' a[aria-selected="true"]').attr('href'));

	var selected_tab_href = $('#'+parent_region_id+' a[aria-selected="true"]').attr('href');

	//in order to populate the tabular form it must be selected, switch to the update region tabular form and populate the values and then switch back to the tab that was selected when the page loaded

	//check if the update region tab is selected.
	if (selected_tab_href != '#SR_'+ig_id)
	{
//		console.log ('the selected tab when the page loaded was not the update region tab, switch to the update region tab so it can be populated via ajax request');
		$('#'+parent_region_id+' a[href="#SR_'+ig_id+'"]').trigger('click');
//		console.log('selected the update region tab');
	}



	var ig$ = apex.region(ig_id).widget();
//	console.log('ig is: '+ig$);
	var model = ig$.interactiveGrid("getViews", "grid").model;
//	console.log('model is: '+model);



	//create a new blank row for each associated other species records:
	for (var i = 0; i < json_array['options'].length; i++)
	{
//			console.log('add the new row ('+i+')');

//			console.log(json_array['options'][i]);
			var temp = ig$.interactiveGrid("getActions").invoke("row-add-row");

//			console.log('the new row was added successfully');
	}

	//re-initialize the counter for setting the values for each record
	i = 0;
	model.forEach(function(r, index, id)
	{
//			console.log('the current value of r is: ');
//			console.log(r);

//			console.log('the value of row ID is: '+r[1]);


			$.each(json_array['options'][i], function(i, item)
						{
//									console.log('set the field ('+i+') value to item: '+item);
									
									//set the value explicitly to a string value:
									model.setValue(r, i, String(item));


//									console.log('set the focus to the newly set cell ("gotoCell", '+r[1]+', '+i+')');
									apex.region(ig_id).widget().interactiveGrid("getViews").grid.view$.grid("gotoCell", r[1], i);
									
//									console.log('the focus has been successfully set to the newly set cell ("gotoCell", '+r[1]+', '+i+')');

						}
						);
			
			//increment the counter:
			i ++;
			
			
	});


	//check if the update region tab was originally selected, if not switch back to the originally selected tab
	if (selected_tab_href != '#SR_'+ig_id)
	{
			$('#'+parent_region_id+' a[href="'+selected_tab_href+'"]').trigger('click');
//			console.log('selected the '+selected_tab_href+' tab');
	}

	//set focus to the first enabled/visible form element:
	$(document).find('input[type=text],textarea,select').filter(':visible:first').focus();



}
