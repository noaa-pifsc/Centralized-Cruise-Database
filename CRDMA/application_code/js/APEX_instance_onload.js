//purpose:
//this code is intended to be executed on each page in a given application to clearly indicate to the users and developers which APEX instance the application is running on.  When it is on the development or test servers the application will display a background image and append text to the logo to indicate the server instance.  This is intended to prevent users from using/viewing/downloading development/test data by mistake

//Page Template setup:
//this code requires the implemented APEX page template to define the dev_bg_image and test_bg_image variables as the paths to the development and test background images respectively for the Static Application Files in the APEX workspace in the "Function and Global Variable Declaration"
//this file should be uploaded as a "Static Application File" and included in the implemented APEX page template in the JavaScript section's "File URLs" field

//run the code when the page has finished initializing
$( document ).ready(function()
{

	//set the background image based on the value of the app_bg_image variable
	$("div.t-Body-content-bg-image").css("background-image", 'url("'+app_bg_image+'")');

	//check to see which APEX server instance this code is running on (based on hostname):
	if (window.location.hostname == 'midd.pic.gov')	//this is the development server instance
	{
		//this is the development server, use the development background image and append a string to the header logo to indicate it is the development server

		//set the background image to the development background
		$("div.t-Body").css("background-image", 'url("'+dev_bg_image+'")');

		//append the " (DEVELOPMENT VERSION)" string to the end of the logo content
		$("div.t-Header-logo a.t-Header-logo-link span").append(" (DEVELOPMENT VERSION)");

	}
	else if (window.location.hostname == 'midt.pic.gov')	//this is the test server instance
	{
		//this is the test server, use the test background image and append a string to the header logo to indicate it is the test server

		//set the background image to the test background
		$("div.t-Body").css("background-image", 'url("'+test_bg_image+'")');

		//append the " (TEST VERSION)" string to the end of the logo content
		$("div.t-Header-logo a.t-Header-logo-link span").append(" (TEST VERSION)");

	}

});
