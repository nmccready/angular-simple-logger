gulp = require 'gulp'
Karma = require('karma').Server
open  = require 'gulp-open'
{log} = require 'gulp-util'

karmaRunner = (done, karmaConf = require.resolve('../../karma.conf.coffee')) ->
  log '-- Karma Setup --'
  try
    server = new Karma
      configFile: karmaConf
      singleRun: true, (code) ->
        log "Karma Callback Code: #{code}"
        done(code)
    server.start()
  catch e
    log "KARMA ERROR: #{e}"
    done(e)

gulp.task 'karma', (done) ->
  karmaRunner(done)

gulp.task 'karmaBrowserify', (done) ->
  karmaRunner(done, require.resolve('../../karma.browserify.conf.coffee'))


gulp.task 'karmaLight', (done) ->
  karmaRunner(done, require.resolve('../../karma.light.conf.coffee'))

gulp.task 'spec', gulp.parallel 'karma', 'karmaLight', 'karmaBrowserify'

doOpen = (name = '') ->
  ->
    gulp.src('')
    .pipe open
      uri: "dist/coverage/lib#{name}/index.html"
      app: 'Google Chrome' #osx , linux: google-chrome, windows: chrome


gulp.task 'coverage', gulp.parallel doOpen(), doOpen('Light')
