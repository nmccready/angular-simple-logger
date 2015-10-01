gulp = require 'gulp'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
gutil = require 'gulp-util'

module.exports = (stream, maybeLight = '', buildOutFullName) ->
  if maybeLight
    stream.pipe concat "index.#{maybeLight}js"
    .pipe gulp.dest 'dist'

  if buildOutFullName
    # gutil.log 'should buildOutFullName'
    stream.pipe concat "angular-simple-logger.#{maybeLight}js"
    .pipe gulp.dest 'dist'
    .pipe uglify()
    .pipe concat "angular-simple-logger.#{maybeLight}min.js"
    .pipe gulp.dest 'dist'

  stream
