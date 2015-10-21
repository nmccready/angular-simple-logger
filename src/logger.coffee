angular.module('nemLogging').provider 'nemSimpleLogger',[ 'nemDebugProvider', (nemDebugProvider) ->

  nemDebug = nemDebugProvider.debug

  _fns = ['debug', 'info', 'warn', 'error', 'log']
  LEVELS = {}
  for val, key in _fns
    LEVELS[val] = key

  _maybeExecLevel = (level, current, fn) ->
    fn() if level >= current

  _isValidLogObject = (logObject) ->
    isValid = false
    return  isValid unless logObject
    for val in _fns
      isValid = logObject[val]? and typeof logObject[val] is 'function'
      break unless isValid
    isValid

  ###
    Overide logeObject.debug with a nemDebug instance
    see: https://github.com/visionmedia/debug/blob/master/Readme.md
  ###
  _wrapDebug = (debugStrLevel, logObject) ->
    debugInstance = nemDebug(debugStrLevel)
    newLogger = {}
    for val in _fns
      newLogger[val] = if val == 'debug' then debugInstance else logObject[val]
    newLogger

  class Logger
    constructor: (@$log) ->
      throw 'internalLogger undefined' unless @$log
      throw '@$log is invalid' unless _isValidLogObject @$log
      @doLog = true
      logFns = {}

      for level in _fns
        do (level) =>
          logFns[level] = (msg) =>
            if @doLog
              _maybeExecLevel LEVELS[level], @currentLevel, =>
                @$log[level](msg)
          @[level] = logFns[level]

      @LEVELS = LEVELS
      @currentLevel = LEVELS.error

    spawn: (newInternalLogger) =>
      if typeof newInternalLogger is 'string'
        throw '@$log is invalid' unless _isValidLogObject @$log
        unless nemDebug
          throw 'nemDebug is undefined this is probably the light version of this library sep debug logggers is not supported!'
        return _wrapDebug newInternalLogger, @$log

      new Logger(newInternalLogger or @$log)

  @decorator = ['$log', ($delegate) ->
    #app domain logger enables all logging by default
    log = new Logger($delegate)
    log.currentLevel = LEVELS.debug
    log
  ]

  @$get = [ '$log', ($log) ->
    # console.log $log
    #default logging is error for specific domain
    new Logger($log)
  ]
  @
]
