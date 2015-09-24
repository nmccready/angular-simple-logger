gulp = require 'gulp'
bump = require 'gulp-bump'
git = require 'gulp-git'
{log} = require 'gulp-util'


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

  if doCommit
    if dryRun
      log "DryRun: commit: #{if semverLevel then semverLevel else 'patch'}"
      return stream
    stream.pipe git.commit("chore(bump): Bumped #{if semverLevel then semverLevel else 'patch'}")
  stream

['', 'minor', 'major'].forEach (name) ->
  taskName = if name then '-' + name else ''

  gulp.task "bump-@#{taskName}", ->
    bumpThis(name)

  gulp.task "bump-@#{taskName}-dry", ->
    bumpThis(name, true, true)

  gulp.task "bump-@#{taskName}-no-commit", ->
    bumpThis(name,false)

  gulp.task "bump-@#{taskName}-no-commit-dry", ->
    bumpThis(name,false, true)
