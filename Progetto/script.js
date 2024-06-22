$().ready(function(){
    var highlight_active = false;
    
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

    $('rect').mouseover(function() {
        // alert("HELLO");
    }).mouseout(function(){
        $(this).removeClass("hovered-area");      
    });
});