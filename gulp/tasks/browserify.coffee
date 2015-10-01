gulp = require 'gulp'
gutil = require 'gulp-util'
globby = require 'globby'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
prettyHrtime = require 'pretty-hrtime'
through = require 'through2'

save = require '../common/save.coffee'
endPath = 'dist/'

browserifyTask = (srcArray, outputName, watch = false) ->
  #straight from gulp , https://github.com/gulpjs/gulp/blob/master/docs/recipes/browserify-with-globs.md
  inputGlob = srcArray
  startTime = ''

  pipeline = (stream) ->
    stream
    .on 'error', (err) ->
      conf.errorHandler 'Bundler'
    .pipe source outputName
    .pipe buffer()
    .pipe gulp.dest endPath
    .on 'end', ->
      timestamp = prettyHrtime process.hrtime startTime
      gutil.log 'Bundled', gutil.colors.blue(outputName), 'in', gutil.colors.magenta(timestamp)
    .pipe gulp.dest endPath
    stream

  # gutil.log 'pre-bundledStream'
  bundledStream = pipeline through()
  # gutil.log 'post-bundledStream'

  # gutil.log "inputGlob: #{inputGlob}"
  # gutil.log "inputGlob.length: #{inputGlob.length}"

  globby inputGlob
  .then (entries) ->
    gutil.log "entries: #{entries}"

    config =
      entries: entries

    if watch
      _.extend config, watchify.args

    b = browserify config
      .transform('brfs')

    bundle = (stream) ->
      startTime = process.hrtime()
      gutil.log 'Bundling', gutil.colors.blue(config.outputName) + '...'
      b.bundle().pipe(stream)

    if watch
      b = watchify b
      b.on 'update', () ->
        bundle pipeline through()
      gutil.log "Watching #{entries.length} files matching", gutil.colors.yellow(inputGlob)
    else
      if config.require
        b.require config.require
      if config.external
        b.external config.external

    bundle bundledStream

  .catch (err) ->
    if (err)
      bundledStream.emit('error', err)
      return

  # gutil.log 'post globby'
  bundledStream

gulp.task 'browserify', gulp.series ->
  browserifyTask(['dist/browser.js'], 'browser.js')
, ->
  gutil.log 'saving browserify dist all'
  save(gulp.src(['dist/browser.js']),undefined, true)
