//execute the code on page load
$( document ).ready(function() {

    //button tooltip definition:
    $("#delete_preset_id").attr("title", "Click to delete the current Preset, you must remove all options before deleting the preset otherwise the deletion will fail").addClass("custom_tooltip");

    //initialize tooltips:
    $("button.custom_tooltip").tooltip({
            position: {
              my: "center bottom-20",
              at: "center top",
              using: tooltip_arrows
            }
          });
});
