describe 'nemLogging.nemSimpleLogger', ->
  describe 'Array extensions (bad practice)', ->
    beforeEach ->
      Array::contains = ->

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

    it 'does not run over to logger', ->
      hasContains = false
      for key, val of @subject.LEVELS
        if typeof(key) != 'string'
          hasContains = true
      expect(hasContains).toBeFalsy()
