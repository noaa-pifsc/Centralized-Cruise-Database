
function get_oth_spp_cruise_copy (cruise_id_copy)
{
    console.log('this is the other species cruise copy initialization code');

    
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
          

//            console.log('the value of the selected tab (li) is: '+$('#cruise_attributes_region li[aria-selected="true"]').attr('id'));

//            console.log('the value of the selected tab (a href) is: '+$('#cruise_attributes_region li[aria-selected="true"] > a ').attr('href'));
          
            var selected_tab_href = $('#cruise_attributes_region li[aria-selected="true"] > a ').attr('href');

            //in order to populate the tabular form it must be selected, switch to the leg alias tabular form and populate the values and then switch back to the tab that was selected when the page loaded
          
            //check if the leg alias tab is selected.
            if (selected_tab_href != '#SR_other_species_id')
            {
                console.log ('the selected tab when the page loaded was not the other species tab, switch to the other species tab so it can be populated via ajax request');
                $('#cruise_attributes_region a[href="#SR_other_species_id"]').trigger('click');
                console.log('selected the other species tab');  
            }
          
          
          
            var ig$ = apex.region("other_species_id").widget();
            console.log('ig is: '+ig$);
            var model = ig$.interactiveGrid("getViews", "grid").model;
            console.log('model is: '+model);

          
            //create a new blank row for each associated other species records:
            for (var i = 0; i < json_array['oth_spp'].length; i++)
            {
                var temp = ig$.interactiveGrid("getActions").invoke("row-add-row");
                
                console.log('added the new row');
                console.log(temp);

                
            }
          
            //re-initialize the counter for setting the values for each record
            i = 0;
            model.forEach(function(r)
            {
                console.log('the current value of r is: ');
                console.log(r);
                
                console.log('the value of row ID is: '+r[1]);
                
                
                $.each(json_array['oth_spp'][i], function(i, item)
                      {
                            console.log('set the field ('+i+') value to item: '+item);
                            model.setValue(r, i, item);
                    
                    
                            console.log('set the focus to the newly set cell ("gotoCell", '+r[1]+', '+i+')');
                            apex.region("other_species_id").widget().interactiveGrid("getViews").grid.view$.grid("gotoCell", r[1], i);

                      }
                      );
                //increment the counter:
                i ++;
            });

            //check if the leg alias tab was originally selected, if not switch back to the originally selected tab
            if (selected_tab_href != '#SR_other_species_id')
            {
                $('#cruise_attributes_region a[href="'+selected_tab_href+'"]').trigger('click');
                console.log('selected the '+selected_tab_href+' tab');  
            }

          //set focus to the first enabled/visible form element:
            $(document).find('input[type=text],textarea,select').filter(':visible:first').focus();
      },
      dataType: "text"                        // Response type (here: plain text)
    }
  );    
    
    
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
function ajax_request_oth_spp ()
{
    console.log('running get_oth_spp_cruise_copy('+$v("P220_CRUISE_ID_COPY")+')');

    //send an ajax request for all of the associated other species records associated with the copied cruise ID: 
    get_oth_spp_cruise_copy($v("P220_CRUISE_ID_COPY"));    
}





//function to execute the ajax request
function ajax_request_mmpa_spp ()
{
    console.log('running ajax_request_mmpa_spp('+$v("P220_TGT_MMPA_SPP_SHUTTLE")+', '+$v("P220_MMPA_SHOW_FILT_LIST")+', '+$v("P220_CRUISE_ID")+', '+$v("P220_CRUISE_ID_COPY")+')');

    //send an ajax request for all of the associated other species records associated with the copied cruise ID: 
	
//	console.log ('P220_TGT_MMPA_SPP_SHUTTLE is: '+$v("P220_TGT_MMPA_SPP_SHUTTLE"));
//	console.log ('P220_MMPA_SHOW_FILT_LIST is: '+$v("P220_MMPA_SHOW_FILT_LIST"));
//	console.log ('P220_CRUISE_ID is: '+$v("P220_CRUISE_ID"));
//	console.log ('P220_CRUISE_ID_COPY is: '+$v("P220_CRUISE_ID_COPY"));
	
    get_mmpa_spp_options($v("P220_MMPA_SHOW_FILT_LIST"), $v("P220_TGT_MMPA_SPP_SHUTTLE"), $v("P220_CRUISE_ID"), $v("P220_CRUISE_ID_COPY"));    
}

//function get_leg_alias_copy (cruise_leg_id_copy)
function get_mmpa_spp_options (TGT_MMPA_SPP_SHUTTLE, MMPA_SHOW_FILT_LIST, CRUISE_ID, CRUISE_ID_COPY)
{
    console.log('this is the get_mmpa_spp_options() initialization code');

    
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
		update_options(pData, 'P220_TGT_MMPA_SPP_SHUTTLE');


      },
      dataType: "text"                        // Response type (here: plain text)
    }
  );    
    
    
}




//function to execute the ajax request
function ajax_request_esa_spp ()
{
    console.log('running ajax_request_esa_spp('+$v("P220_TGT_ESA_SPP_SHUTTLE")+', '+$v("P220_ESA_SHOW_FILT_LIST")+', '+$v("P220_CRUISE_ID")+', '+$v("P220_CRUISE_ID_COPY")+')');

    //send an ajax request for all of the associated other species records associated with the copied cruise ID: 
	
//	console.log ('P220_TGT_ESA_SPP_SHUTTLE is: '+$v("P220_TGT_ESA_SPP_SHUTTLE"));
//	console.log ('P220_ESA_SHOW_FILT_LIST is: '+$v("P220_ESA_SHOW_FILT_LIST"));
//	console.log ('P220_CRUISE_ID is: '+$v("P220_CRUISE_ID"));
//	console.log ('P220_CRUISE_ID_COPY is: '+$v("P220_CRUISE_ID_COPY"));
	
    get_esa_spp_options($v("P220_ESA_SHOW_FILT_LIST"), $v("P220_TGT_ESA_SPP_SHUTTLE"), $v("P220_CRUISE_ID"), $v("P220_CRUISE_ID_COPY"));    
}

//function get_leg_alias_copy (cruise_leg_id_copy)
function get_esa_spp_options (TGT_ESA_SPP_SHUTTLE, ESA_SHOW_FILT_LIST, CRUISE_ID, CRUISE_ID_COPY)
{
    console.log('this is the get_esa_spp_options() initialization code');

    
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
		update_options(pData, 'P220_TGT_ESA_SPP_SHUTTLE');


      },
      dataType: "text"                        // Response type (here: plain text)
    }
  );    
    
    
}









//function to execute the ajax request
function ajax_request_fssi_spp ()
{
    console.log('running ajax_request_fssi_spp('+$v("P220_TGT_FSSI_SPP_SHUTTLE")+', '+$v("P220_FSSI_SHOW_FILT_LIST")+', '+$v("P220_CRUISE_ID")+', '+$v("P220_CRUISE_ID_COPY")+')');

    //send an ajax request for all of the associated other species records associated with the copied cruise ID: 
	
//	console.log ('P220_TGT_FSSI_SPP_SHUTTLE is: '+$v("P220_TGT_FSSI_SPP_SHUTTLE"));
//	console.log ('P220_FSSI_SHOW_FILT_LIST is: '+$v("P220_FSSI_SHOW_FILT_LIST"));
//	console.log ('P220_CRUISE_ID is: '+$v("P220_CRUISE_ID"));
//	console.log ('P220_CRUISE_ID_COPY is: '+$v("P220_CRUISE_ID_COPY"));
	
    get_fssi_spp_options($v("P220_FSSI_SHOW_FILT_LIST"), $v("P220_TGT_FSSI_SPP_SHUTTLE"), $v("P220_CRUISE_ID"), $v("P220_CRUISE_ID_COPY"));    
}

//function get_leg_alias_copy (cruise_leg_id_copy)
function get_fssi_spp_options (TGT_FSSI_SPP_SHUTTLE, FSSI_SHOW_FILT_LIST, CRUISE_ID, CRUISE_ID_COPY)
{
    console.log('this is the get_fssi_spp_options() initialization code');

    
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
		update_options(pData, 'P220_TGT_FSSI_SPP_SHUTTLE');


      },
      dataType: "text"                        // Response type (here: plain text)
    }
  );    
    
    
}












//function to execute the ajax request
function ajax_request_exp_spp_cat ()
{
    console.log('running ajax_request_exp_spp_cat('+$v("P220_EXP_SPP_CAT_SHUTTLE")+', '+$v("P220_EXP_SPP_CAT_SHOW_FILT_LIST")+', '+$v("P220_CRUISE_ID")+', '+$v("P220_CRUISE_ID_COPY")+')');

    //send an ajax request for all of the associated other species records associated with the copied cruise ID: 
	
//	console.log ('P220_EXP_SPP_CAT_SHUTTLE is: '+$v("P220_EXP_SPP_CAT_SHUTTLE"));
//	console.log ('P220_EXP_SPP_CAT_SHOW_FILT_LIST is: '+$v("P220_EXP_SPP_CAT_SHOW_FILT_LIST"));
//	console.log ('P220_CRUISE_ID is: '+$v("P220_CRUISE_ID"));
//	console.log ('P220_CRUISE_ID_COPY is: '+$v("P220_CRUISE_ID_COPY"));
	
    get_exp_spp_cat_options($v("P220_EXP_SPP_CAT_SHOW_FILT_LIST"), $v("P220_EXP_SPP_CAT_SHUTTLE"), $v("P220_CRUISE_ID"), $v("P220_CRUISE_ID_COPY"));    
}

//function get_leg_alias_copy (cruise_leg_id_copy)
function get_exp_spp_cat_options (EXP_SPP_CAT_SHUTTLE, EXP_SPP_CAT_SHOW_FILT_LIST, CRUISE_ID, CRUISE_ID_COPY)
{
    console.log('this is the get_exp_spp_cat_options() initialization code');

    
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
		
		//update the shuttle options
		update_options(pData, 'P220_EXP_SPP_CAT_SHUTTLE');


      },
      dataType: "text"                        // Response type (here: plain text)
    }
  );    
    
    
}
