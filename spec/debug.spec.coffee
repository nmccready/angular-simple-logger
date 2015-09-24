describe 'nemLogging.nemDebug', ->
  beforeEach ->
    angular.mock.module('nemLogging')
    inject (nemDebug, $log) =>
      @subject = nemDebug
      @$log = $log

  it 'window.debug is left untouched', ->
    expect(window.debug).not.toBe(@subject)

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

      it 'disable an enabled logger', ->
        @subject.enable('worker:*')
        c = @simpleLogger.spawn('worker:c')
        #note this doesnt really work yet in visionmedia
        #https://github.com/visionmedia/debug/issues/150
        @subject.disable()
        d = @simpleLogger.spawn('worker:d')
        expect(c.debug.enabled).toBeTruthy()
        expect(d.debug.enabled).toBeTruthy()


      it 'underlying logger is NOT still $log', ->
        #the ref is diff, but all logging functions are $log except debug
        newLogger = @simpleLogger.spawn('worker:b')
        expect(newLogger.$log == @$log).toBeFalsy()

      it 'throws if $log is lost', ->
        #the ref is diff, but all logging functions are $log except debug
        @simpleLogger.$log = undefined
        expect =>
          @simpleLogger.spawn('worker:c')
        .toThrow '@$log is invalid'
