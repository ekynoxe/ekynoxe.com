$(function() {
    var SCROLL_THRESHOLD = 200;
    $window = $(window);
    $link = $("#scrollToTop");

    $link.click(function() {
        $("html, body").animate({ scrollTop: 0 }, "slow");
        return false;
    });

    if (!$window.scrollTop()) {
        $link.hide();
    }

    $window.scroll(function() {
        var scrollPos = $(window).scrollTop();

        $('header.main').css('background-position', 'center bottom ' + (-scrollPos / 5) + 'px');
        $('header.main>.content').css('opacity', '1' - (scrollPos / 800));

        if (scrollPos <= SCROLL_THRESHOLD) {
            $link.fadeOut("fast");
        } else {
            $link.fadeIn("fast");
        }
    });
});