gulp = require 'gulp'
gulpif = require 'gulp-if'
coffeelint = require 'gulp-coffeelint'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
{log} = require 'gulp-util'
insert = require 'gulp-insert'
{header} = require './wrap.coffee'

build = (source, out = 'index.js') ->
  gulp.src source
  .pipe gulpif(/[.]coffee$/,coffeelint())
  .pipe gulpif(/[.]coffee$/,coffeelint.reporter())
  .pipe gulpif(/[.]coffee$/,coffee(require '../coffeeOptions.coffee').on('error', log))
  .pipe concat out
  .pipe gulp.dest 'dist'

gulp.task 'build', gulp.series 'wrapDebug', ->
  build [ 'src/module.coffee', 'tmp/debugCommonJS.js', 'src/*.coffee'], 'browser.js'

gulp.task 'buildCommonJS', gulp.series 'wrapDebug', ->
  build [ 'src/module.coffee', 'tmp/debugCommonJS.js', 'src/*.coffee']
  .pipe insert.prepend("var angular = require('angular');\n\n")
  .pipe insert.prepend(header())
  .pipe concat 'index.js'
  .pipe gulp.dest 'dist'

gulp.task 'buildLight', gulp.series 'wrapDebugLight', ->
  build [ 'src/module.coffee', 'tmp/debugLight.js', 'src/*.coffee'], 'index.light.js'
