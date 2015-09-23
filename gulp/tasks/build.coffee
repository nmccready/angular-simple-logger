gulp = require 'gulp'
gulpif = require 'gulp-if'
coffeelint = require 'gulp-coffeelint'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
{log} = require 'gulp-util'
require './wrap.coffee'

build = (source, out = 'index.js') ->
  gulp.src source
  .pipe gulpif(/[.]coffee$/,coffeelint())
  .pipe gulpif(/[.]coffee$/,coffeelint.reporter())
  .pipe gulpif(/[.]coffee$/,coffee(require '../coffeeOptions.coffee').on('error', log))
  .pipe concat out
  .pipe gulp.dest 'dist'

gulp.task 'build', gulp.series 'wrapDebug', ->
  build [ 'src/module.coffee', 'tmp/debug.js', 'src/*.coffee']

gulp.task 'buildLight', gulp.series 'wrapDebug', ->
  build [ 'src/module.coffee', 'src/debug.light.js', 'src/*.coffee'], 'index.light.js'
