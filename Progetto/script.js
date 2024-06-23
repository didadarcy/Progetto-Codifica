$().ready(function(){
    var highlight_active = false;
    // $("#highlights").hide();
    
    $("#highlight-button").click(function(){
        if(highlight_active) {
            highlight_active = false;
            $(".active").removeClass("active");
            $(this).text("Annotazioni (mostra)");
            $("#colors").css("display", "none");
        } else {
            highlight_active = true;
            $(".term, .eventName, .date, .persName, .placeName, .orgName").addClass("active");
            $(this).text("Annotazioni (nascondi)");
            $("#colors").css("display", "block");
        }
    });

    $('rect, polygon').mouseover(function() {
        var facs = $(this).attr('id');
        $(this).addClass("highlighted");
        $('*[data-facs="#' + facs + '"]').addClass("highlighted");
    }).mouseout(function(){
        var facs = $(this).attr('id');
        $(this).removeClass("highlighted");
        $('*[data-facs="#' + facs + '"]').removeClass("highlighted");  
    });

    $('*[data-facs]').mouseover(function() {
        var facs = $(this).attr('data-facs').substring(1);
        $(this).addClass("highlighted");
        $('*[id="' + facs + '"]').addClass("highlighted");
    }).mouseout(function(){
        var facs = $(this).attr('data-facs').substring(1);
        $(this).removeClass("highlighted");
        $('*[id="' + facs + '"]').removeClass("highlighted");  
    });

    $(window).scroll(function(){
        if($(window).scrollTop() > $("main").offset().top){
            $("#highlights").show();
        } else {
            $("#highlights").hide();
        }
    });
});