###global spyOn:true, angular:true, inject:true, expect:true###
describe 'nemLogging.nemSimpleLogger', ->
  beforeEach ->
    @createSpyLogger = ->
      @log = ->
      @info = ->
      @debug = ->
      @warn = ->
      @error = ->

      spyOn(@, 'log')
      spyOn(@, 'info')
      spyOn(@, 'debug')
      spyOn(@, 'warn')
      spyOn(@, 'error')
      @

    $log = @createSpyLogger()
    @loggger = $log

    angular.module('nemLogging').config ($provide) ->
      #decorate w/ spys
      $provide.decorator '$log', ($delegate) ->
        return $log

    angular.mock.module('nemLogging')
    inject (nemSimpleLogger) =>
      @subject = nemSimpleLogger

  it 'exists', ->
    expect(@subject).toBeDefined()

  describe 'default', ->
    ['debug', 'info', 'warn', {called:'error'}, {called:'log'}].forEach (testName) ->
      {called} = testName
      testName = if typeof testName == 'string' then testName else testName.called
      it testName, ->
        @subject[testName]('blah')
        if called
          expect(@loggger[testName]).toHaveBeenCalled()
          return expect(@loggger[testName]).toHaveBeenCalledWith('blah')
        expect(@loggger[testName]).not.toHaveBeenCalled()


  describe 'all on', ->
    beforeEach ->
      inject (nemSimpleLogger) =>
        nemSimpleLogger.currentLevel = nemSimpleLogger.LEVELS.debug
        @subject = nemSimpleLogger
    describe 'single arg', ->
      ['debug', 'info', 'warn', 'error', 'log'].forEach (testName) ->
        it testName, ->
          @subject[testName]('blah')
          expect(@loggger[testName]).toHaveBeenCalled()
          expect(@loggger[testName]).toHaveBeenCalledWith('blah')

    describe 'multi arg', ->
      ['debug', 'info', 'warn', 'error', 'log'].forEach (testName) ->
        it testName, ->
          @subject[testName]('blah','HI')
          expect(@loggger[testName]).toHaveBeenCalled()
          expect(@loggger[testName]).toHaveBeenCalledWith('blah', 'HI')

  describe 'all off', ->
    describe 'by LEVELS +1', ->
      beforeEach ->
        inject (nemSimpleLogger) =>
          nemSimpleLogger.currentLevel = nemSimpleLogger.LEVELS.log + 1
          @subject = nemSimpleLogger

      ['debug', 'info', 'warn', 'error', 'log'].forEach (testName) ->
        it testName, ->
          @subject[testName]('blah')
          expect(@loggger[testName]).not.toHaveBeenCalled()

    describe 'by doLog', ->
      beforeEach ->
        inject (nemSimpleLogger) =>
          nemSimpleLogger.doLog = false
          @subject = nemSimpleLogger

      ['debug', 'info', 'warn', 'error', 'log'].forEach (testName) ->
        it testName, ->
          @subject[testName]('blah')
          expect(@loggger[testName]).not.toHaveBeenCalled()

  describe 'spawn', ->
    beforeEach ->
      @newLogger = @subject.spawn()
      @newLog = @createSpyLogger()

    it 'can create a new logger', ->
      expect(@newLogger.debug).toBeDefined()
      expect(@newLogger != @subject).toBeTruthy()

    it 'underlying logger is still $log', ->
      expect(@newLogger.$log == @loggger).toBeTruthy()

    describe 'throws', ->

      it 'bad logger', ->
        expect( => @subject.spawn({})).toThrow('@$log is invalid')

      it 'partial logger', ->
        expect( =>
          @subject.spawn
            log: ->
            debug: ->
            error: ->
        ).toThrow('@$log is invalid')

      it 'partial logger', ->
        expect( =>
          @subject.spawn
            log: ->
            debug: ->
            error: ->
        ).toThrow('@$log is invalid')

      it 'undefined decorated logger', ->
        expect =>
          @subject.$log = undefined
          @subject.spawn()
        .toThrow('internalLogger undefined')

    describe 'Has Independent', ->
      it 'logLevels', ->
        @newLogger.currentLevel = @newLogger.LEVELS.debug
        expect(@newLogger.currentLevel != @subject.currentLevel).toBeTruthy()
        @newLogger.debug('blah')
        expect(@loggger.debug).toHaveBeenCalled()
        @newLogger.debug('blah')
        @subject.debug('blah')
        expect(@newLog.debug).toHaveBeenCalled()

  describe 'decorate', ->
    beforeEach ->
      angular.module('nemLogging')
      .config ($provide, nemSimpleLoggerProvider) ->
        #decorate w/ nemSimpleLogger which will call spys internally
        $provide.decorator nemSimpleLoggerProvider.decorator...

      inject ($log) =>
        @subject = $log

    it 'error', ->
      @subject.error('blah')
      expect(@loggger.error).toHaveBeenCalled()

    it 'debug', ->
      @subject.debug('blah')
      expect(@loggger.debug).toHaveBeenCalled()

    it 'info', ->
      @subject.info('blah')
      expect(@loggger.info).toHaveBeenCalled()

    it 'warn', ->
      @subject.warn('blah')
      expect(@loggger.warn).toHaveBeenCalled()
