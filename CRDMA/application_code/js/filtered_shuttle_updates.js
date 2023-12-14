var htmldb_delete_message='"DELETE_CONFIRM_MSG"';

var lSpinner$; 

/*

//should we implement an ajax callback?
	On filter checkbox click send the selected values and Filter List checkbox to server process
	
	//query the DB and return the json that contains the options
	In javascript clear both sides of the shuttle, parse the JSON, set the options on the left side and then set the options on the right side
	
*/



//function update_options will parse a json object (pData) and refresh an APEX shuttle item with an id of shuttle_id with the parsed option data 
function update_options(pData, shuttle_id)
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
		
//                var temp = ig$.interactiveGrid("getActions").invoke("row-add-row");

//                console.log('the new row was added successfully');  
	}

//	left_shuttle.refresh();
//	right_shuttle.refresh();

//	console.log ('the options have been refreshed');
	
	
	
	
	
	
	
}

//function that hides the spinner and re-enables the apex items in the item_array and enables the buttons for the HTML element id properties stored in the button_array
function enable_shuttle_form (item_array, button_array)
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


function disable_shuttle_form (item_array, button_array)
{
	console.log ('running disable_shuttle_form()');
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