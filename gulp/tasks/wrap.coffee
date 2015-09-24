gulp = require 'gulp'
gulpif = require 'gulp-if'
coffeelint = require 'gulp-coffeelint'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
{log} = require 'gulp-util'
wrap = require 'gulp-wrap'
replace = require 'gulp-replace'
uglify = require 'gulp-uglify'
date = new Date()
insert = require 'gulp-insert'
require './clean.coffee'
jf = require 'jsonfile'

pkgFn = ->
  jf.readFileSync 'package.json' #always get latest!

header = ->
  ourPackage = pkgFn()
  """
  /**
   *  #{ourPackage.name}
   *
   * @version: #{ourPackage.version}
   * @author: #{ourPackage.author}
   * @date: #{date.toString()}
   * @license: #{ourPackage.license}
   */
  """

gulp.task 'wrapDebug', ->
  gulp.src 'bower_components/visionmedia-debug/dist/debug.js'
  .pipe wrap src: 'src/wrap/debug.js'
  .pipe gulp.dest 'tmp'


wrapDist = (source = 'dist/index.js', maybeLight = '') ->
  gulp.src source
  .pipe wrap src: 'src/wrap/dist.js'
  # .pipe replace(/;(?=[^;]*;[^;]*$)/, '') #remove bade semicolon
  .pipe insert.prepend(header())
  .pipe concat "index.#{maybeLight}js"
  .pipe gulp.dest 'dist'
  .pipe concat "angular-simple-logger.#{maybeLight}js"
  .pipe gulp.dest 'dist'
  .pipe uglify()
  .pipe concat "angular-simple-logger.#{maybeLight}min.js"
  .pipe gulp.dest 'dist'

gulp.task 'wrapDist', ->
  wrapDist()
, 'cleanTmp'

gulp.task 'wrapDistLight', ->
  wrapDist('dist/index.light.js', 'light.')

module.exports = wrapDist
