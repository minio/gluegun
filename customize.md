# Gluegun Theming Guide
Gluegun offers many configurable theming options. Override the default theme easily.

## Theme File 
Fork gluegun repository and edit the file scss/inc/_variables.scss to create your own themes.

```
// Responsive breakpoints
$screen-xs-min: 480px;
$screen-sm-min: 768px;
$screen-md-min: 992px;
$screen-lg-min: 1200px;
$screen-xs-max: ($screen-sm-min - 1);
$screen-sm-max: ($screen-md-min - 1);
$screen-md-max: ($screen-lg-min - 1);


// Theme colors
$border-color: #f0f0f0;
$border-inverse-color: #2f2f2f;
$muted-bg: #f9f9f9;
$text-muted-color: #777;

// Colors
$black: #000;
$white: #fff;


// Body
$body-bg: $white;
$body-color: $black;


// Links
$link-color: #2d91e6;


// Font
$font-size-base: 18px;
$font-family: 'Roboto', sans-serif;
$font-weight-bold: 500;
$font-weight-base: normal;


// Sidebar
$sidebar-z-index: 10;
$sidebar-width: 350px;
$sidebar-bg: #151515;
$doclink-header-color: $white;
$doclink-color: rgba($white, 0.75);
$doclink-hover-color: rgba($white, 0.875);
$doclink-active-color: $white;


// Header
$header-bg: $white;
$header-height: 90px;


// Pre
$pre-bg: #f8f8f8;


// Headings
$h1-font-size: $font-size-base * 1.7;
$h2-font-size: $font-size-base * 1.5;
$h3-font-size: $font-size-base * 1.3;
$h4-font-size: $font-size-base * 1.1;
$h5-font-size: $font-size-base * 0.9;
$h6-font-size: $font-size-base * 0.7;
$headings-color: $body-color;


// Blockquote
$blockquote-bg: darken($border-color, 10%);


// Table
$table-bg: $white;
$table-border-color: #f3f3f3;
$th-bg: $white;
$th-color: $headings-color;


// Images
$image-border-color: #f8f8f8;


// Dropdown
$dropdown-z-index: 10;
$dropdown-active-z-index: 100;
$dropdown-bg: $white;
$dropdown-box-shadow: 0 2px 10px 0 rgba($black,.05);
$dropdown-border-color: #efefef;
$dropdown-item-hover-bg: #f7f7f7;
$dropdown-item-color: $text-muted-color;


// Footer text color
$footer-text-color: $text-muted-color;

```