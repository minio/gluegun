'use strict';

$(document).ready(function () {

    //--| Syntax highlighting |--
    if($('code')[0]) {
        $('pre[lang]:not([lang="sh"]) code').each(function(i, block) {
            hljs.highlightBlock(block);
        });
    }


    //--| Sidebar dock links |--
    $('body').on('click', '.doc-link__header', function(e) {
        e.preventDefault();

        if ($(this).parent().is('.toggled')) {
            $('.doc-link__category').removeClass('toggled');
            $('.doc-link__items').stop(true, false).slideUp(300);
        } else {
            $('.doc-link__category').removeClass('toggled');
            $('.doc-link__items').stop(true, false).slideUp(300);
            $(this).parent().addClass('toggled');
            $(this).next().stop(true, false).slideDown(300);
        }
    });


    //--| Sidebar toggle |--

    //Open
    $('body').on('click', '.sidebar-toggle', function (e) {
        e.preventDefault();

        // Open
        $('.sidebar').addClass('toggled');
        $('body').append('<div class="sidebar-backdrop" />').addClass('body-locked'); // Use a backdrop to detect outside click
    });

    // Close
    $('body').on('click', '.sidebar-backdrop, .sidebar__close', function (e) {
        e.preventDefault();

        $('.sidebar').removeClass('toggled');
        $('body').removeClass('body-locked');
        $('.sidebar-backdrop').remove(); // Backdrop is no longer needed if sidebar is hidden
    });


    //--| Responsive tables |--
    if($('table')[0]) {
        $('table').each(function() {
            if (!$(this).parent().is('.table-responsive')) {
                $(this).wrap('<div class="table-responsive" />'); // Wrap table with container with overflow auto style
            }
        });
    }


    //--| Load doclink previews |--
    $('body').on('click', '.doc-link__items > li > a', function (e) {
        e.preventDefault();

        var $targetPreview = $(this).attr('href'); // Get target doclink preview ID
        window.location.hash = $targetPreview; // Set hash

        $('.doc-preview__item.active').removeClass('active').fadeOut(300); // Hide active doclink preview
        $('.doc-preview__item' + $targetPreview).addClass('active').fadeIn(300); // Show current one
    });


    //--| Image previews |--
    function closeImgPreview () {
        $('body').removeClass('body-locked');
        $('.img-preview').fadeOut(300);
        setTimeout(function () {
            $('.img-preview').remove();
        }, 300);
    }

    if($('img')[0]) {

        // Open
        $('body').on('click', '.content *:not("a") > img:not(".img-preview__img")', function () {
            var $imgSrc = $ (this).attr ('src'); // Get image source
            var $imgWrap =  '<div class="img-preview">' + // Create a wrapper
                                '<div class="img-preview__actions">' +
                                    '<a class="img-preview__download" href='+ $imgSrc +' download></a>' +
                                    '<a class="img-preview__close" href=""></a>' +
                                '</div>' +
                                '<img class="img-preview__item" src=' + $imgSrc + ' alt="">' +
                            '</div>';

            $('body').addClass('body-locked').append($imgWrap); // Load the wrapper
            $('.img-preview').fadeIn(300);
        });

        // Close on 'x' click
        $('body').on('click', '.img-preview__close', function (e) {
            e.preventDefault();
            closeImgPreview();
        });

        // Close on ESC key
        $(document).keyup(function(e) {
            if ($('.img-preview')[0]) {
                if (e.keyCode === 27) {
                    closeImgPreview();
                }
            }
        });
    }


    //--| Dropdowns |--
    if($('.dropdown')[0]) {

        // Open
        $('body').on('click', '.dropdown__toggle', function (e) {
            e.preventDefault();

            var $dropdownParent = $(this).closest('.dropdown');

            $dropdownParent.append('<div class="dropdown__backdrop" />');
            $dropdownParent.toggleClass('dropdown--active');
        });

        // Close
        $('body').on('click', '.dropdown__backdrop', function() {
            $(this).closest('.dropdown').removeClass('dropdown--active');
            $(this).remove();
        });
    }
});