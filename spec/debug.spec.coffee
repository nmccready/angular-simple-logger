describe 'nemLogging.nemDebug', ->
  beforeEach ->
    angular.mock.module('nemLogging')
    inject (nemDebug, $log) =>
      @subject = nemDebug
      @$log = $log

  describe 'as a service', ->
    it 'exists', ->
      expect(@subject).toBeDefined()

    it 'is Function', ->
      expect(typeof @subject).toBe('function')

    it 'has debug API', ->
      ['coerce', 'disable', 'enable', 'enabled', 'humanize'].forEach (fnName) =>
        expect(typeof @subject[fnName]).toBe('function')

  describe 'as a provider', ->
    beforeEach ->
      angular.module('nemLogging')
      .config (nemDebugProvider) ->

        @subject = nemDebugProvider.debug

      inject (nemSimpleLogger) =>
        @simpleLogger = nemSimpleLogger

    it 'exists', ->
      expect(@subject).toBeDefined()

    it 'is Function', ->
      expect(typeof @subject).toBe('function')

    it 'has debug API', ->
      ['coerce', 'disable', 'enable', 'enabled', 'humanize'].forEach (fnName) =>
        expect(typeof @subject[fnName]).toBe('function')

    describe 'spawn a debug level', ->
      it 'disabled logger', ->
        newLogger = @simpleLogger.spawn('worker:a')
        expect(newLogger.debug).toBeDefined()
        expect(newLogger.debug.namespace).toBe('worker:a')
        expect(newLogger.debug.enabled).toBeFalsy()
        ['debug', 'info', 'warn', 'error', 'log'].forEach (fnName) ->
          expect(typeof newLogger[fnName]).toBe('function')

      it 'enabled logger', ->
        @subject.enable('worker:*')
        newLogger = @simpleLogger.spawn('worker:a')
        expect(newLogger.debug.enabled).toBeTruthy()

      it 'underlying logger is NOT still $log', ->
        #the ref is diff, but all logging functions are $log except debug
        newLogger = @simpleLogger.spawn('worker:b')
        expect(newLogger.$log == @$log).toBeFalsy()
