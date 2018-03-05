/**
 * Created by lawebshop on 15-08-18.
 */

var ready = function() {

    $("#sidebar-chaindrive li").first().find("a").click(function () {

        $("#chaindrive_file").click();
        return false;
    });

    $("#chaindrive_file").change(function () {
        $(this).parents("form").submit();
    });

    $(".datetimepicker").datetimepicker({
            dateFormat: 'dd/mm/yy'

        }
    );
};


$(document).ready(ready);
$(document).on('page:load', ready);