
function get_leg_alias_copy (cruise_leg_id_copy)
{
    console.log('this is the get leg aliases initialization code');

    
    apex.server.process(
    'get_leg_alias_copy',                             // Process or AJAX Callback name
    {x01: cruise_leg_id_copy},  // Parameter "x01"
    {
      success: function (pData) 
      {             
            // Success Javascript

            console.log('the value of pData is: '+pData);  
          
            //parse the json array to get each record's value:
            var json_array = jQuery.parseJSON(pData);
          
            console.log('the value of the selected tab (li) is: '+$('#leg_attributes_region li[aria-selected="true"]').attr('id'));

            console.log('the value of the selected tab (a href) is: '+$('#leg_attributes_region li[aria-selected="true"] > a ').attr('href'));
          
            var selected_tab_href = $('#leg_attributes_region li[aria-selected="true"] > a ').attr('href');

            //in order to populate the tabular form it must be selected, switch to the leg alias tabular form and populate the values and then switch back to the tab that was selected when the page loaded
          
            //check if the leg alias tab is selected.
            if (selected_tab_href != '#SR_leg_alias_id')
            {
                console.log ('the selected tab when the page loaded was not the leg alias tab, switch to the leg alias tab so it can be populated via ajax request');
                $('#leg_attributes_region a[href="#SR_leg_alias_id"]').trigger('click');
                console.log('selected the leg alias tab');  
            }
                
                
          
            var ig$ = apex.region("leg_alias_id").widget();
            console.log('ig is: '+ig$);
            var model = ig$.interactiveGrid("getViews", "grid").model;
            console.log('model is: '+model);

            
          
            //create a new blank row for each associated other species records:
            for (var i = 0; i < json_array['leg_alias'].length; i++)
            {
                console.log('add the new row ('+i+')');  

                console.log(json_array['leg_alias'][i]);  
                var temp = ig$.interactiveGrid("getActions").invoke("row-add-row");

                console.log('the new row was added successfully');  
            }
          
            //re-initialize the counter for setting the values for each record
            i = 0;
            model.forEach(function(r)
            {
                console.log('the current value of r is: ');
                console.log(r);
                
                console.log('the value of row ID is: '+r[1]);
                
                
                $.each(json_array['leg_alias'][i], function(i, item)
                      {
                            console.log('set the field ('+i+') value to item: '+item);
                            model.setValue(r, i, item);
                    
                    
                            console.log('set the focus to the newly set cell ("gotoCell", '+r[1]+', '+i+')');
                            apex.region("leg_alias_id").widget().interactiveGrid("getViews").grid.view$.grid("gotoCell", r[1], i);

                      }
                      );
                //increment the counter:
                i ++;
            });
          
            
            //check if the leg alias tab was originally selected, if not switch back to the originally selected tab
            if (selected_tab_href != '#SR_leg_alias_id')
            {
                $('#leg_attributes_region a[href="'+selected_tab_href+'"]').trigger('click');
                console.log('selected the '+selected_tab_href+' tab');  
            }

            //set focus to the first enabled/visible form element:
            $(document).find('input[type=text],textarea,select').filter(':visible:first').focus();
      },
      dataType: "text"                        // Response type (here: plain text)
    }
  );    
    
    
}

function check_DAS_warning()
{
    var date1 = new Date($v("P230_LEG_START_DATE"));
    var date2 = new Date($v("P230_LEG_END_DATE"));

    // To calculate the time difference of two dates 
    var Difference_In_Time = date2.getTime() - date1.getTime();     
    
    //calculate the difference in days between the two dates and then include the start date (add 1 day)
    var Difference_In_Days = (Difference_In_Time / (1000 * 3600 * 24)) + 1;     

    console.log('the value of Difference_In_Days is: '+Difference_In_Days);

    if (Difference_In_Days > 30)
    {
        console.log('This is more than 30 days');

        //there are no options selected in the gear shuttle field:
        apex.message.clearErrors();

        apex.message.showErrors([
            {
                type:       "error",
                location:   [ "inline" ],
                pageItem:   "P230_LEG_START_DATE",
                message:    "Warning (Unusually High Leg Days at Sea): The Leg is unusually long (> 30 days), based on start and end dates: "+Difference_In_Days+" days",
                unsafe:     false
            },
            {
                type:       "error",
                location:   [ "inline" ],
                pageItem:   "P230_LEG_END_DATE",
                message:    "Warning (Unusually High Leg Days at Sea): The Leg is unusually long (> 30 days), based on start and end dates: "+Difference_In_Days+" days",
                unsafe:     false
            }]);
    }
    else
    {

        console.log('This is less than or equal to 30 days');

        //clear the errors from the last evaluation
        apex.message.clearErrors();

    }
}




//code to execute once the APEX objects have been initialized
apex.jQuery(window).on('theme42ready', function() {

    //call the initialize all tooltips code
    setTimeout(initialize_all_tooltips, 500);
    
    //call the leg alias ajax code
    ajax_request_leg_aliases();
    

});

//initialize all tooltips
function initialize_all_tooltips ()
{
    console.log ('running initialize_all_tooltips()');
    
    //tab tooltip definitions:
    $("#SR_leg_summary_tab > a.t-Tabs-link").attr("title", "Click to view the Summary information for the current Cruise Leg").addClass("custom_tooltip");
    $("#SR_regional_ecosystems_tab > a.t-Tabs-link").attr("title", "Click to view/define Regional Ecosystems for the current Cruise Leg").addClass("custom_tooltip");
    $("#SR_gear_tab > a.t-Tabs-link").attr("title", "Click to view/define Gear for the current Cruise Leg").addClass("custom_tooltip");
    $("#SR_regions_tab > a.t-Tabs-link").attr("title", "Click to view/define Regions for the current Cruise Leg").addClass("custom_tooltip");
    $("#SR_leg_alias_id_tab > a.t-Tabs-link").attr("title", "Click to view/define Leg Aliases for the current Cruise Leg").addClass("custom_tooltip");
    $("#SR_data_validation_issues_tab > a.t-Tabs-link").attr("title", "Click to view the QC Validation Issues for the associated Cruise").addClass("custom_tooltip");
    $("#SR_leg_data_sets_id_tab > a.t-Tabs-link").attr("title", "Click to view/define Leg Data Sets for the current Cruise Leg").addClass("custom_tooltip");
	
	
    
    //classic report tooltip definitions:    
    $("#LEG_NAME").attr("title", "The name of the given cruise leg").addClass("custom_tooltip");
    $("#FORMAT_LEG_START_DATE").attr("title", "The start date for the given research cruise leg in MM/DD/YYYY format").addClass("custom_tooltip");
    $("#FORMAT_LEG_END_DATE").attr("title", "The end date for the given research cruise leg in MM/DD/YYYY format").addClass("custom_tooltip");
    $("#LEG_DAS").attr("title", "The total number of days at sea for the given cruise leg (based on the start and end dates of the leg)").addClass("custom_tooltip");
    $("#LEG_FISC_YEAR").attr("title", "The NOAA fiscal year for the given cruise leg (based on the leg start date)").addClass("custom_tooltip");
    $("#PLAT_TYPE_NAME").attr("title", "Platform Type for the given research cruise leg").addClass("custom_tooltip");
    $("#VESSEL_NAME").attr("title", "Name of the given research vessel").addClass("custom_tooltip");
    $("#REG_ECOSYSTEM_BR_LIST").attr("title", "List of Regional Ecosystems associated with the given cruise leg").addClass("custom_tooltip");
    $("#GEAR_NAME_BR_LIST").attr("title", "List of Gear associated with the given cruise leg").addClass("custom_tooltip");
    $("#REGION_NAME_BR_LIST").attr("title", "List of Regions associated with the given cruise leg").addClass("custom_tooltip");
    $("#LEG_ALIAS_BR_LIST").attr("title", "List of aliases for the given cruise leg").addClass("custom_tooltip");
    $("#CRUISE_LEG_ID_VAL").attr("title", "Edit the given cruise leg").addClass("custom_tooltip");
    $("#CRUISE_LEG_ID_COPY").attr("title", "Click to copy the cruise leg and associated records so they can be modified and saved to streamline data entry.  The copied cruise leg is not saved until you click the \"Create\" or \"Create Another\" button on the View/Edit Cruise Leg page and the action is successfully processed").addClass("custom_tooltip");
 

    //button tooltip definitions:
    $("#delete_leg_id").attr("title", "Click to delete the current Cruise Leg, you must remove all Leg Attributes before deleting the Cruise Leg otherwise the deletion will fail").addClass("custom_tooltip");

    //initialize the tooltips:
    $("th.custom_tooltip, a.custom_tooltip, button.custom_tooltip").tooltip({
            position: {
              my: "center bottom-20",
              at: "center top",
              using: tooltip_arrows
            }
          });    
    
    
 
    $("th.custom_tooltip, a.custom_tooltip, button.custom_tooltip").tooltip({
            position: {
              my: "center bottom-20",
              at: "center top",
              using: tooltip_arrows
            }
          });

}


function ajax_request_leg_aliases ()
{

    console.log('running get_leg_alias_copy');
   
    console.log('running get_leg_alias_copy('+$v("P230_CRUISE_LEG_ID_COPY")+')');

//    console.log('the value of this.tabs$.id is: '+this.tabs$.id);    
    
    //send an ajax request for all of the associated other species records associated with the copied cruise ID: 
    get_leg_alias_copy($v("P230_CRUISE_LEG_ID_COPY"));    
    
}



//function to execute the ajax request
function ajax_request_reg_ecosystems ()
{
    console.log('running ajax_request_reg_ecosystems('+$v("P230_REG_ECO_SHUTTLE")+', '+$v("P230_REG_ECO_SHOW_FILT_LIST")+', '+$v("P230_CRUISE_LEG_ID")+', '+$v("P230_CRUISE_LEG_ID_COPY")+')');

    //send an ajax request for all of the associated other species records associated with the copied cruise ID: 
	
//	console.log ('P230_REG_ECO_SHUTTLE is: '+$v("P230_REG_ECO_SHUTTLE"));
//	console.log ('P230_REG_ECO_SHOW_FILT_LIST is: '+$v("P230_REG_ECO_SHOW_FILT_LIST"));
//	console.log ('P230_CRUISE_LEG_ID is: '+$v("P230_CRUISE_LEG_ID"));
//	console.log ('P230_CRUISE_LEG_ID_COPY is: '+$v("P230_CRUISE_LEG_ID_COPY"));
	
    get_reg_ecosystem_options($v("P230_REG_ECO_SHUTTLE"), $v("P230_REG_ECO_SHOW_FILT_LIST"), $v("P230_CRUISE_LEG_ID"), $v("P230_CRUISE_LEG_ID_COPY"));    
}

//function get_leg_alias_copy (cruise_leg_id_copy)
function get_reg_ecosystem_options (REG_ECO_SHUTTLE, REG_ECO_SHOW_FILT_LIST, CRUISE_LEG_ID, CRUISE_LEG_ID_COPY)
{
    console.log('this is the get_reg_ecosystem_options() initialization code');

    
    apex.server.process(
    'get_reg_ecosystem_options',                             // Process or AJAX Callback name
    {x01: REG_ECO_SHUTTLE,
	x02: REG_ECO_SHOW_FILT_LIST,
	x03: CRUISE_LEG_ID,
	x04: CRUISE_LEG_ID_COPY},
    {
      success: function (pData) 
      {             
            // Success Javascript
		
		//update the shuttle options
		update_options(pData, 'P230_REG_ECO_SHUTTLE');


      },
      dataType: "text"                        // Response type (here: plain text)
    }
  );    
    
    
}




//function to execute the ajax request
function ajax_request_gear ()
{
    console.log('running ajax_request_gear('+$v("P230_GEAR_SHUTTLE")+', '+$v("P230_GEAR_SHOW_FILT_LIST")+', '+$v("P230_CRUISE_LEG_ID")+', '+$v("P230_CRUISE_LEG_ID_COPY")+')');

    //send an ajax request for all of the associated other species records associated with the copied cruise ID: 
	
//	console.log ('P230_GEAR_SHUTTLE is: '+$v("P230_GEAR_SHUTTLE"));
//	console.log ('P230_GEAR_SHOW_FILT_LIST is: '+$v("P230_GEAR_SHOW_FILT_LIST"));
//	console.log ('P230_CRUISE_LEG_ID is: '+$v("P230_CRUISE_LEG_ID"));
//	console.log ('P230_CRUISE_LEG_ID_COPY is: '+$v("P230_CRUISE_LEG_ID_COPY"));
	
    get_gear_options($v("P230_GEAR_SHUTTLE"), $v("P230_GEAR_SHOW_FILT_LIST"), $v("P230_CRUISE_LEG_ID"), $v("P230_CRUISE_LEG_ID_COPY"));    
}

//function get_leg_alias_copy (cruise_leg_id_copy)
function get_gear_options (GEAR_SHUTTLE, GEAR_SHOW_FILT_LIST, CRUISE_LEG_ID, CRUISE_LEG_ID_COPY)
{
    console.log('this is the get_gear_options() initialization code');

    
    apex.server.process(
    'get_gear_options',                             // Process or AJAX Callback name
    {x01: GEAR_SHUTTLE,
	x02: GEAR_SHOW_FILT_LIST,
	x03: CRUISE_LEG_ID,
	x04: CRUISE_LEG_ID_COPY},
    {
      success: function (pData) 
      {             
            // Success Javascript
		
		//update the shuttle options
		update_options(pData, 'P230_GEAR_SHUTTLE');


      },
      dataType: "text"                        // Response type (here: plain text)
    }
  );    
    
    
}

