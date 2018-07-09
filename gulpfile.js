'use strict';
var gulp = require('gulp');
var $ = require('gulp-load-plugins')();
var sass = require('gulp-sass');
var postcss = require('gulp-postcss');
var minifyjs = require('gulp-js-minify');
var watch = require('gulp-watch');
var pump = require('pump');
var autoprefixer = require('autoprefixer');
var cssmin = require('gulp-cssmin');
var runSequence = require('run-sequence');


// Paths
var files = {
    scss:       './lib/scss/**/*.scss',
    scssMain:   './lib/scss/gluegun.scss',
    js:         './lib/js/gluegun.js',
    jsMin:      './lib/js/gluegun.min.js',
    css:        './lib/css/gluegun.css',
    cssMin:     './lib/css/gluegun.min.css',
    img:        './lib/img/**/*.*',
    vendors:    './lib/vendors/**/*.*'
};


// Compile SASS
gulp.task('sass', function () {
    return gulp.src(files.scssMain)
        .pipe(sass().on('error', sass.logError))
        .pipe(gulp.dest('./lib/css/'));
});


// Post CSS
gulp.task('postcss', ['sass'], function () {
    var plugins = [
        autoprefixer({browsers: ['last 2 version']})
    ];
    return gulp.src(files.css)
        .pipe(postcss(plugins))
        .pipe(gulp.dest('./lib/css/'));
});


// Minify CSS
gulp.task('cssmin', ['postcss'], function () {
    gulp.src(files.css)
        .pipe(cssmin({
            keepSpecialComments: 0
        }))
        .pipe($.rename({suffix: '.min'}))
        .pipe(gulp.dest('./lib/css'));
});


// Copy CSS
gulp.task('copy-css', ['cssmin'], function () {
    gulp.src([files.cssMin, files.css])
        //.pipe(wait(500))
        .pipe(gulp.dest('./docs/css'));
});



// Build CSS
gulp.task('build-style', function () {
    runSequence(
        'sass',
        'postcss',
        'cssmin',
        'copy-css'
    )
});


// Minify and Copy JS
gulp.task('copy-js', function(){
    gulp.src(files.js)
        .pipe(minifyjs())
        .pipe($.rename({suffix: '.min'}))
        .pipe(gulp.dest('./lib/js/'))
        .pipe(gulp.dest('./docs/js'));

    gulp.src([files.js])
        .pipe(gulp.dest('./docs/js'));
});


// Copy Images
gulp.task('copy-img', function () {
    gulp.src(files.img)
        .pipe(gulp.dest('./docs/img'));
});


// Copy Vendors
gulp.task('copy-vendors', function () {
    gulp.src(files.vendors)
        .pipe(gulp.dest('./docs/vendors'));
});


// Watch
gulp.task('watch', function() {
    gulp.watch(files.scss, ['build-style']);
    gulp.watch(files.cssMin, ['copy-css']);
    gulp.watch(files.js, ['copy-js']);
});


// Build
gulp.task('default', ['build-style'], function () {
    runSequence(
        'copy-css',
        'copy-js',
        'copy-img',
        'copy-vendors'
    )
});