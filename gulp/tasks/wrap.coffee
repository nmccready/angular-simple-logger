gulp = require 'gulp'
gulpif = require 'gulp-if'
coffeelint = require 'gulp-coffeelint'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
{log} = require 'gulp-util'
wrap = require 'gulp-wrap'
replace = require 'gulp-replace'

date = new Date()
insert = require 'gulp-insert'
require './clean.coffee'
jf = require 'jsonfile'

save = require '../common/save.coffee'

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
   */\n
  """

gulp.task 'wrapDebug', ->
  gulp.src 'src/wrap/contents/debugCommonJS.js'
  .pipe wrap src: 'src/wrap/debug.js'
  .pipe gulp.dest 'tmp'

gulp.task 'wrapDebugLight', ->
  gulp.src 'src/wrap/contents/debugLight.js'
  .pipe wrap src: 'src/wrap/debug.js'
  .pipe gulp.dest 'tmp'

wrapDist = (source = 'dist/index.js', maybeLight = '', buidOutFullName = false) ->
  save(
    gulp.src(source)
    .pipe(wrap src: 'src/wrap/dist.js')
    # .pipe replace(/;(?=[^;]*;[^;]*$)/, '') #remove bade semicolon
    .pipe(insert.prepend(header()))
  , maybeLight, buidOutFullName)

gulp.task 'wrapDist', ->
  wrapDist('browser.js')
, 'cleanTmp'

gulp.task 'wrapDistLight', ->
  wrapDist('dist/index.light.js', 'light.', true)

module.exports =
  header: header
  wrapDist: wrapDist
