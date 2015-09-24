gulp = require 'gulp'
bump = require 'gulp-bump'
git = require 'gulp-git'
{log} = require 'gulp-util'
require './dist.coffee'

bumpThis = (semverLevel, doCommit = true, dryRun = false, files = ['bower.json', 'package.json']) ->
  stream = gulp.src files
  if semverLevel
    semverType =
      type: semverLevel

  if dryRun
    log "DryRun: semverType: #{JSON.stringify(semverType)} to bump"
  else
    stream
    .pipe(bump semverType)
    .pipe gulp.dest './'

  stream

commitFiles = [
  'dist/*.js'
  'bower.json'
  'package.json'
  'package.js'
  'spec/**/*'
  'src/**/*'
]

commit = (semverLevel, doCommit = true, dryRun = false, files = commitFiles) ->
  ->
    stream = gulp.src files
    if doCommit
      if dryRun
        log "DryRun: commit: #{if semverLevel then semverLevel else 'patch'}"
        return stream
      stream.pipe git.commit("chore(bump): Bumped #{if semverLevel then semverLevel else 'patch'}")
    stream

bumpDistCommmit = (semverLevel, doCommit, dryRun) ->
  tasks = []

  tasks.push ->
    bumpThis(semverLevel, doCommit, dryRun)

  if !dryRun
    tasks.push 'distAll'

  tasks.push commit(semverLevel, doCommit, dryRun)

  gulp.series tasks...

['', 'minor', 'major'].forEach (name) ->
  taskName = if name then '-' + name else ''

  gulp.task "bump-@#{taskName}", bumpDistCommmit(name)

  gulp.task "bump-@#{taskName}-dry", bumpDistCommmit(name, true, true)

  gulp.task "bump-@#{taskName}-no-commit", bumpDistCommmit(name,false)

  gulp.task "bump-@#{taskName}-no-commit-dry", bumpDistCommmit(name,false, true)
