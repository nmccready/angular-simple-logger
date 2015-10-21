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
    it 'debug', ->
      @subject.debug('blah')
      expect(@loggger.debug).not.toHaveBeenCalled()

    it 'info', ->
      @subject.info('blah')
      expect(@loggger.info).not.toHaveBeenCalled()

    it 'warn', ->
      @subject.warn('blah')
      expect(@loggger.warn).not.toHaveBeenCalled()

    it 'error', ->
      @subject.error('blah')
      expect(@loggger.error).toHaveBeenCalled()

    it 'log', ->
      @subject.log('blah')
      expect(@loggger.log).toHaveBeenCalled()


  describe 'all on', ->
    beforeEach ->
      inject (nemSimpleLogger) =>
        nemSimpleLogger.currentLevel = nemSimpleLogger.LEVELS.debug
        @subject = nemSimpleLogger

    it 'debug', ->
      @subject.debug('blah')
      expect(@loggger.debug).toHaveBeenCalled()

    it 'info', ->
      @subject.info('blah')
      expect(@loggger.info).toHaveBeenCalled()

    it 'warn', ->
      @subject.warn('blah')
      expect(@loggger.warn).toHaveBeenCalled()

    it 'error', ->
      @subject.error('blah')
      expect(@loggger.error).toHaveBeenCalled()

    it 'log', ->
      @subject.log('blah')
      expect(@loggger.log).toHaveBeenCalled()

  describe 'all off', ->
    describe 'by LEVELS +1', ->
      beforeEach ->
        inject (nemSimpleLogger) =>
          nemSimpleLogger.currentLevel = nemSimpleLogger.LEVELS.log + 1
          @subject = nemSimpleLogger

      it 'debug', ->
        @subject.debug('blah')
        expect(@loggger.debug).not.toHaveBeenCalled()

      it 'info', ->
        @subject.info('blah')
        expect(@loggger.info).not.toHaveBeenCalled()

      it 'warn', ->
        @subject.warn('blah')
        expect(@loggger.warn).not.toHaveBeenCalled()

      it 'error', ->
        @subject.error('blah')
        expect(@loggger.error).not.toHaveBeenCalled()

      it 'log', ->
        @subject.log('blah')
        expect(@loggger.log).not.toHaveBeenCalled()

    describe 'by doLog', ->
      beforeEach ->
        inject (nemSimpleLogger) =>
          nemSimpleLogger.doLog = false
          @subject = nemSimpleLogger

      it 'debug', ->
        @subject.debug('blah')
        expect(@loggger.debug).not.toHaveBeenCalled()

      it 'info', ->
        @subject.info('blah')
        expect(@loggger.info).not.toHaveBeenCalled()

      it 'warn', ->
        @subject.warn('blah')
        expect(@loggger.warn).not.toHaveBeenCalled()

      it 'error', ->
        @subject.error('blah')
        expect(@loggger.error).not.toHaveBeenCalled()

      it 'log', ->
        @subject.log('blah')
        expect(@loggger.log).not.toHaveBeenCalled()

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
