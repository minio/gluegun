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

    //Toggle
    $('body').on('click', '.sidebar-toggle', function (e) {
        e.preventDefault();

        $('.sidebar-backdrop').remove();
        $('.sidebar, .content').toggleClass('toggled');

        if($('.sidebar').hasClass('toggled')) {
            $('body').append('<div class="sidebar-backdrop" />');
        }
    });

    // Close
    $('body').on('click', '.sidebar__close, .sidebar-backdrop', function (e) {
        e.preventDefault();

        $('.sidebar-backdrop').remove();
        $('.sidebar, .content').removeClass('toggled');
    });


    //--| Responsive tables |--
    if($('table')[0]) {
        $('table').each(function() {
            if (!$(this).parent().is('.table-responsive')) {
                $(this).wrap('<div class="table-responsive" />'); // Wrap table with container with overflow auto style
            }
        });
    }


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


    //--| Code Copy |--
    if($('pre')[0]) {

        // Add copy button
        $('pre').each(function() {
            if ($(this).find('.copy-to-clipboard').length === 0) {
                $(this).prepend('<span class="copy-to-clipboard">Copy</span>');
            }
        });

        // Initiate Clipboard.js
        var clipboard = new ClipboardJS('.copy-to-clipboard', {
            text: function(trigger) {
                return trigger.nextElementSibling.innerText;
            }
        });

        clipboard.on('success', function(e) {
            e.trigger.textContent = 'Copied to clipboard';
            setTimeout((function() {
                e.trigger.textContent = 'Copy';
            }), 2000);
        });
    }
});