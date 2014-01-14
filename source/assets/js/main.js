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
        if ($window.scrollTop() <= SCROLL_THRESHOLD) {
            $link.fadeOut("fast");
        } else {
            $link.fadeIn("fast");
        }
    });
});