gulp = require 'gulp'
tag = require 'gulp-tag-version'

gulp.task 'tag', ->
  gulp.src './package.json'
  .pipe tag
    prefix: ''
    push: false
    label: 'Released as %t'
