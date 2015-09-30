require './spec.coffee'
gulp = require 'gulp'


gulp.task 'dist', gulp.series('build', 'wrapDist', 'browserify')

gulp.task 'distCommonJS', gulp.series('buildCommonJS')

gulp.task 'distLight', gulp.series('buildLight', 'wrapDistLight')

gulp.task 'distAll', gulp.series 'clean', gulp.parallel('dist', 'distCommonJS', 'distLight'), 'spec'
