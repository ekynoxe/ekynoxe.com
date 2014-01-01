// javascript
$(function() {
    $window = $(window);
    $link = $("#scrollToTop"); // your link to show when user scrolls down
    $link.click(function() {
        $("html, body").animate({ scrollTop: 0 }, "slow"); // this is the gist of the script, scroll to top (scrollTop: 0)
    });

    $window.scroll(function() {
        if ($window.scrollTop() <= 200) {
            $link.fadeOut("fast");
        } else {
            $link.fadeIn("fast");
        }
    });
});