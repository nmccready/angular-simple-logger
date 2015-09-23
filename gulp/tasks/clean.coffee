gulp = require 'gulp'
del = require 'del'

gulp.task 'clean', (done) ->
  del ['tmp', 'dist', '*.log'], done


gulp.task 'cleanTmp', (done) ->
  del ['tmp'], done
