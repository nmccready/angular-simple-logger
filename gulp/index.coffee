require './tasks/'
gulp = require 'gulp'

gulp.task 'dist', gulp.series('build', 'wrapDist')

gulp.task 'distLight', gulp.series('buildLight', 'wrapDistLight')

gulp.task 'default', gulp.series 'clean', gulp.parallel('dist', 'distLight'), 'spec'
