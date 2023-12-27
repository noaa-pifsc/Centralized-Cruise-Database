
//function to send the ajax request for other target species of the cruise that is being copied (if any)
function get_oth_spp_cruise_copy (cruise_id_copy)
{
    console.log('this is the get_oth_spp_cruise_copy() initialization code:');
	console.log(cruise_id_copy);

    
	//check if the cruise_id_copy is blank
    if (cruise_id_copy != "")
	{
		//the cruise_id_copy is not blank, send the ajax request for the other target species for the copied cruise

		apex.server.process(
		'get_oth_spp_cruise_copy',                             // Process or AJAX Callback name
		{x01: cruise_id_copy},  // Parameter "x01"
		{
		  success: function (pData) 
		  {             
				// Success Javascript

				console.log('the value of pData is: '+pData);  
			  
				//parse the json array to get each record's value:
				var json_array = jQuery.parseJSON(pData);
			  
				//update the interactive grid based on the JSON data returned from the Ajax request
				update_interactive_grid(json_array, 'cruise_attributes_region', 'other_species_id');


		  },
		  dataType: "text"                        // Response type (here: plain text)
		}
	  );    
	}
    
}



//function to execute the ajax request
function ajax_request_oth_spp ()
{
    console.log('running get_oth_spp_cruise_copy('+$v("P220_CRUISE_ID_COPY")+')');

    //send an ajax request for all of the associated other species records associated with the copied cruise ID: 
    get_oth_spp_cruise_copy($v("P220_CRUISE_ID_COPY"));    
}



//code to execute once the APEX objects have been initialized
apex.jQuery(window).on('theme42ready', function() {

    //call the initialize all tooltips code
    setTimeout(initialize_all_tooltips, 500);
    
    //call oth spp ajax code
    ajax_request_oth_spp ();
    

});

//initialize all tooltips
function initialize_all_tooltips ()
{
    //tab tooltip definitions:
    $("#SR_cruise_summary_tab > a.t-Tabs-link").attr("title", "Click to view the Summary information for the current Cruise").addClass("custom_tooltip");
    $("#SR_data_validation_issues_tab > a.t-Tabs-link").attr("title", "Click to view the QC Validation Issues for the current Cruise").addClass("custom_tooltip");
    $("#SR_cruise_legs_tab > a.t-Tabs-link").attr("title", "Click to view the associated Cruise Legs or create a new Cruise Leg for the current Cruise").addClass("custom_tooltip");
    $("#SR_pri_svy_cat_tab > a.t-Tabs-link").attr("title", "Click to view/define the Primary Survey Categories for the current Cruise").addClass("custom_tooltip");
    $("#SR_sec_svy_cat_tab > a.t-Tabs-link").attr("title", "Click to view/define the Secondary Survey Categories for the current Cruise").addClass("custom_tooltip");
    $("#SR_esa_spp_tab > a.t-Tabs-link").attr("title", "Click to view/define the ESA Target Species for the current Cruise").addClass("custom_tooltip");
    $("#SR_mmpa_spp_tab > a.t-Tabs-link").attr("title", "Click to view/define the MMPA Target Species for the current Cruise").addClass("custom_tooltip");
    $("#SR_fssi_spp_tab > a.t-Tabs-link").attr("title", "Click to view/define the FSSI Target Species for the current Cruise").addClass("custom_tooltip");
    $("#SR_exp_spp_cat_tab > a.t-Tabs-link").attr("title", "Click to view/define the Expected Species Categories for the current Cruise").addClass("custom_tooltip");
    $("#SR_other_species_id_tab > a.t-Tabs-link").attr("title", "Click to view/define the Target Species - Other Species for the current Cruise").addClass("custom_tooltip");
    
    //button tooltip definitions:
    $("#deep_copy_cruise_id").attr("title", "Click the button if you would like to copy the Cruise and all of the associated Legs as well, unsaved changes to the Cruise will not be included in the copied cruise.  Following successful processing you will be redirected to the View/Edit Cruise page for the copied Cruise so it can be modified accordingly").addClass("custom_tooltip");
    $("#delete_cruise_id").attr("title", "Click to delete the current Cruise, you must remove all Cruise Attributes and associated Cruise Legs before deleting the Cruise otherwise the deletion will fail").addClass("custom_tooltip");

    
    //initialize tooltips:
    $("th.custom_tooltip, a.custom_tooltip, button.custom_tooltip").tooltip({
            position: {
              my: "center bottom-20",
              at: "center top",
              using: tooltip_arrows
            }
          });

}




//function to execute the ajax request
function ajax_request_mmpa_spp ()
{
    console.log('running ajax_request_mmpa_spp('+$v("P220_TGT_MMPA_SPP_SHUTTLE")+', '+$v("P220_MMPA_SHOW_FILT_LIST")+', '+$v("P220_CRUISE_ID")+', '+$v("P220_CRUISE_ID_COPY")+')');

    //send an ajax request for all of the MMPA species records associated with the cruise ID, current selected shuttle options, and based on the filtered flag: 
    get_mmpa_spp_options($v("P220_TGT_MMPA_SPP_SHUTTLE"), $v("P220_MMPA_SHOW_FILT_LIST"), $v("P220_CRUISE_ID"), $v("P220_CRUISE_ID_COPY"));    
}

//function get_leg_alias_copy (cruise_leg_id_copy)
function get_mmpa_spp_options (TGT_MMPA_SPP_SHUTTLE, MMPA_SHOW_FILT_LIST, CRUISE_ID, CRUISE_ID_COPY)
{
    console.log('running get_mmpa_spp_options()');

	//define the list of MMPA apex page items
	var form_items = ["P220_TGT_MMPA_SPP_SHUTTLE", "P220_MMPA_SHOW_FILT_LIST", "P220_TGT_MMPA_SPP_PRESETS"];

	//define the list of MMPA apex buttons
	var form_buttons = ["mmpa_preset_button_id"];

	//disable the shuttle form
	disable_form_fields(form_items, form_buttons);

	//send the ajax request to the ajax callback
    apex.server.process(
    'get_mmpa_spp_options',                             // Process or AJAX Callback name
    {x01: TGT_MMPA_SPP_SHUTTLE,
	x02: MMPA_SHOW_FILT_LIST,
	x03: CRUISE_ID,
	x04: CRUISE_ID_COPY},
    {
      success: function (pData) 
      {             
            // Success Javascript
		
		//update the shuttle options
		update_shuttle_options(pData, 'P220_TGT_MMPA_SPP_SHUTTLE');

		//re-enable the shuttle form
		enable_form_fields(form_items, form_buttons);

      },
	  error: function( jqXHR, textStatus, errorThrown ) 
	  {
        // handle error

		//re-enable the MMPA shuttle form
		enable_form_fields(form_items, form_buttons);
		
		//alert the user to the error
		alert ('there was an error refreshing the shuttle options, please try again.  If the error persists contact the application administrator');

	  },
      dataType: "text"                        // Response type (here: plain text)
    }
  );    
    
    
}




//function to execute the ajax request
function ajax_request_esa_spp ()
{
    console.log('running ajax_request_esa_spp('+$v("P220_TGT_ESA_SPP_SHUTTLE")+', '+$v("P220_ESA_SHOW_FILT_LIST")+', '+$v("P220_CRUISE_ID")+', '+$v("P220_CRUISE_ID_COPY")+')');

    //send an ajax request for all of the ESA species records associated with the cruise ID, current selected shuttle options, and based on the filtered flag: 
    get_esa_spp_options($v("P220_TGT_ESA_SPP_SHUTTLE"), $v("P220_ESA_SHOW_FILT_LIST"), $v("P220_CRUISE_ID"), $v("P220_CRUISE_ID_COPY"));    
}

//function get_leg_alias_copy (cruise_leg_id_copy)
function get_esa_spp_options (TGT_ESA_SPP_SHUTTLE, ESA_SHOW_FILT_LIST, CRUISE_ID, CRUISE_ID_COPY)
{
    console.log('running get_esa_spp_options()');

	//define the list of ESA apex page items
	var form_items = ["P220_TGT_ESA_SPP_SHUTTLE", "P220_ESA_SHOW_FILT_LIST", "P220_TGT_ESA_SPP_PRESETS"];

	//define the list of ESA apex buttons
	var form_buttons = ["esa_preset_button_id"];

	//disable the shuttle form
	disable_form_fields(form_items, form_buttons);

    apex.server.process(
    'get_esa_spp_options',                             // Process or AJAX Callback name
    {x01: TGT_ESA_SPP_SHUTTLE,
	x02: ESA_SHOW_FILT_LIST,
	x03: CRUISE_ID,
	x04: CRUISE_ID_COPY},
    {
      success: function (pData) 
      {             
            // Success Javascript
		
		//update the shuttle options
		update_shuttle_options(pData, 'P220_TGT_ESA_SPP_SHUTTLE');

		//re-enable the shuttle form
		enable_form_fields(form_items, form_buttons);

      },
	  error: function( jqXHR, textStatus, errorThrown ) 
	  {
        // handle error

		//re-enable the MMPA shuttle form
		enable_form_fields(form_items, form_buttons);
		
		//alert the user to the error
		alert ('there was an error refreshing the shuttle options, please try again.  If the error persists contact the application administrator');

	  },
      dataType: "text"                        // Response type (here: plain text)
    }
  );    
    
    
}









//function to execute the ajax request
function ajax_request_fssi_spp ()
{
    console.log('running ajax_request_fssi_spp('+$v("P220_TGT_FSSI_SPP_SHUTTLE")+', '+$v("P220_FSSI_SHOW_FILT_LIST")+', '+$v("P220_CRUISE_ID")+', '+$v("P220_CRUISE_ID_COPY")+')');

    //send an ajax request for all of the FSSI species records associated with the cruise ID, current selected shuttle options, and based on the filtered flag: 
    get_fssi_spp_options($v("P220_TGT_FSSI_SPP_SHUTTLE"), $v("P220_FSSI_SHOW_FILT_LIST"), $v("P220_CRUISE_ID"), $v("P220_CRUISE_ID_COPY"));    
}

//function get_leg_alias_copy (cruise_leg_id_copy)
function get_fssi_spp_options (TGT_FSSI_SPP_SHUTTLE, FSSI_SHOW_FILT_LIST, CRUISE_ID, CRUISE_ID_COPY)
{
    console.log('running get_fssi_spp_options()');

    
	//define the list of FSSI apex page items
	var form_items = ["P220_TGT_FSSI_SPP_SHUTTLE", "P220_FSSI_SHOW_FILT_LIST", "P220_TGT_FSSI_SPP_PRESETS"];

	//define the list of FSSI apex buttons
	var form_buttons = ["fssi_preset_button_id"];
	
	//disable the shuttle form
	disable_form_fields(form_items, form_buttons);

	
    apex.server.process(
    'get_fssi_spp_options',                             // Process or AJAX Callback name
    {x01: TGT_FSSI_SPP_SHUTTLE,
	x02: FSSI_SHOW_FILT_LIST,
	x03: CRUISE_ID,
	x04: CRUISE_ID_COPY},
    {
      success: function (pData) 
      {             
            // Success Javascript
		
		//update the shuttle options
		update_shuttle_options(pData, 'P220_TGT_FSSI_SPP_SHUTTLE');

		//re-enable the shuttle form
		enable_form_fields(form_items, form_buttons);

      },
	  error: function( jqXHR, textStatus, errorThrown ) 
	  {
        // handle error

		//re-enable the FSSI shuttle form
		enable_form_fields(form_items, form_buttons);
		
		//alert the user to the error
		alert ('there was an error refreshing the shuttle options, please try again.  If the error persists contact the application administrator');

	  },
      dataType: "text"                        // Response type (here: plain text)
    }
  );    
    
    
}












//function to execute the ajax request
function ajax_request_exp_spp_cat ()
{
    console.log('running ajax_request_exp_spp_cat('+$v("P220_EXP_SPP_CAT_SHUTTLE")+', '+$v("P220_EXP_SPP_CAT_SHOW_FILT_LIST")+', '+$v("P220_CRUISE_ID")+', '+$v("P220_CRUISE_ID_COPY")+')');

    //send an ajax request for all of the expected species category records associated with the cruise ID, current selected shuttle options, and based on the filtered flag: 
	
    get_exp_spp_cat_options($v("P220_EXP_SPP_CAT_SHUTTLE"), $v("P220_EXP_SPP_CAT_SHOW_FILT_LIST"), $v("P220_CRUISE_ID"), $v("P220_CRUISE_ID_COPY"));    
}

//function get_leg_alias_copy (cruise_leg_id_copy)
function get_exp_spp_cat_options (EXP_SPP_CAT_SHUTTLE, EXP_SPP_CAT_SHOW_FILT_LIST, CRUISE_ID, CRUISE_ID_COPY)
{
    console.log('running get_exp_spp_cat_options()');

	//define the list of MMPA apex page items
	var form_items = ["P220_EXP_SPP_CAT_SHUTTLE", "P220_EXP_SPP_CAT_SHOW_FILT_LIST", "P220_EXP_SPP_CAT_PRESETS"];

	//define the list of MMPA apex buttons
	var form_buttons = ["exp_spp_cat_preset_button_id"];

	//disable the shuttle form
	disable_form_fields(form_items, form_buttons);
    
    apex.server.process(
    'get_exp_spp_cat_options',                             // Process or AJAX Callback name
    {x01: EXP_SPP_CAT_SHUTTLE,
	x02: EXP_SPP_CAT_SHOW_FILT_LIST,
	x03: CRUISE_ID,
	x04: CRUISE_ID_COPY},
    {
      success: function (pData) 
      {             
            // Success Javascript
		
		//update the select options
		update_shuttle_options(pData, 'P220_EXP_SPP_CAT_SHUTTLE');

		//re-enable the select form fields
		enable_form_fields(form_items, form_buttons);

      },
	  error: function( jqXHR, textStatus, errorThrown ) 
	  {
        // handle error

		//re-enable the expected species category shuttle form
		enable_form_fields(form_items, form_buttons);
		
		//alert the user to the error
		alert ('there was an error refreshing the shuttle options, please try again.  If the error persists contact the application administrator');

	  },
      dataType: "text"                        // Response type (here: plain text)
    }
  );    
    
    
}








//function to execute the ajax request
function ajax_request_std_svy_name ()
{
    console.log('running ajax_request_std_svy_name('+$v("P220_STD_SVY_NAME")+', '+$v("P220_STD_SVY_NAME_FILT")+', '+$v("P220_CRUISE_ID")+', '+$v("P220_CRUISE_ID_COPY")+')');

    //send an ajax request for all of the standard survey name records associated with the cruise ID, current selected field option, and based on the filtered flag: 
	
    get_std_svy_name_options($v("P220_STD_SVY_NAME"), $v("P220_STD_SVY_NAME_FILT"), $v("P220_CRUISE_ID"), $v("P220_CRUISE_ID_COPY"));    
}

//function get_leg_alias_copy (cruise_leg_id_copy)
function get_std_svy_name_options (STD_SVY_NAME, STD_SVY_NAME_FILT, CRUISE_ID, CRUISE_ID_COPY)
{
    console.log('running get_std_svy_name_options(STD_SVY_NAME: '+STD_SVY_NAME+', STD_SVY_NAME_FILT: '+STD_SVY_NAME_FILT+', CRUISE_ID: '+CRUISE_ID+', CRUISE_ID_COPY: '+ CRUISE_ID_COPY+')');

	//define the list of standard survey name apex page items
	var form_items = ["P220_STD_SVY_NAME", "P220_STD_SVY_NAME_FILT"];

	//define the list of standard survey name apex buttons
	var form_buttons = [];

	//disable the standard survey name form fields
	disable_form_fields(form_items, form_buttons);
    
	//send the Ajax request:
    apex.server.process(
    'get_std_svy_name_options',                             // Process or AJAX Callback name
    {x01: STD_SVY_NAME,
	x02: STD_SVY_NAME_FILT,
	x03: CRUISE_ID,
	x04: CRUISE_ID_COPY},
    {
      success: function (pData) 
      {             
            // Success Javascript
		
		//update the standard survey name field options
		update_select_options(pData, 'P220_STD_SVY_NAME');

		//re-enable the standard survey name form fields
		enable_form_fields(form_items, form_buttons);

      },
	  error: function( jqXHR, textStatus, errorThrown ) 
	  {
        // handle error

		//re-enable the standard survey name form fields
		enable_form_fields(form_items, form_buttons);
		
		//alert the user to the error
		alert ('there was an error refreshing the select options, please try again.  If the error persists contact the application administrator');

	  },
      dataType: "text"                        // Response type (here: plain text)
    }
  );    
    
    
}

