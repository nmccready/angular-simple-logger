angular-simple-logger (nemLogging.nemSimpleLogger)
==============
[![Dependencies](https://david-dm.org/nmccready/angular-simple-logger.png)](https://david-dm.org/nmccready/angular-simple-logger)&nbsp;
[![Dependencies](https://david-dm.org/nmccready/angular-simple-logger.png)](https://david-dm.org/nmccready/angular-simple-logger)&nbsp;
[![Build Status](https://travis-ci.org/nmccready/angular-simple-logger.png?branch=master)](https://travis-ci.org/nmccready/angular-simple-logger)


### Purpose:
To have simplified log levels where a supporting angular module's log levels are independent of the application.


### Basic use:

```js
angular.module('someApp', ['nemLogging'])
//note this can be any type of injectable angular dependency (factory, service.. etc)
.controller("someController", function ($scope, nemSimpleLogger) {
  nemSimpleLogger.doLog = true; //default is true
  nemSimpleLogger.currentLevel = nemSimpleLogger.LEVELS.debug;//defaults to error only
});  
```

### Create a Custom Independent Loggers
*(maybe 3 for one lib)*

```js
angular.module('someApp', ['nemLogging'])
//note this can be any type of injectable angular dependency (factory, service.. etc)
.service("apiLogger", function ($scope, nemSimpleLogger) {
  var logger = nemSimpleLogger.spawn();
  logger.currentLevel = logger.LEVELS.warn;
  return logger;
})
.service("businessLogicLogger", function ($scope, nemSimpleLogger) {
  var logger = nemSimpleLogger.spawn();
  logger.currentLevel = logger.LEVELS.error;
  return logger;
})
.service("terseLogger", function ($scope, nemSimpleLogger) {
  var logger = nemSimpleLogger.spawn();
  logger.currentLevel = logger.LEVELS.info;
  return logger;
});
```

### Use your new creations!

```js
angular.module('someApp', ['nemLogging'])
//note this can be any type of injectable angular dependency (factory, service.. etc)
.service("booksApi", function (apiLogger, $http) {
  //do something with your books
  $http.get("/ap/books").then(function(data){
    apiLogger.debug("books have come yay!");
  });
})
.controller("businessCtrl", function ($scope, businessLogicLogger, book) {
  businessLogicLogger.debug("new book");
  var b = new book();
  $scope.books = [b];
})
.controller("appCtrl", function ($rootScope, terseLogger) {
  $rootScope.$on "error", function(){
    terseLogger.error("something happened");
  }
});
```

### Override all of $log (optional decorator)

Optionally (default is off) decorate $log to utilize log levels globally within the app.

Note this logger's currentLevel is debug! Where the order is debug, info, warn, error, log.

```js
angular.module('someApp', ['nemLogging']))
.config(function($provide, nemSimpleLoggerProvider) {
  return $provide.decorator.apply(null, nemSimpleLoggerProvider.decorator);
})
.config(function($provide, nemSimpleLoggerProvider) {
  var logger = $provide.decorator.apply(null, nemSimpleLoggerProvider.decorator);
  //override level at config
  logger.currentLevel = logger.LEVELS.error;
  return logger;
})
.run(function($log){
  //at run time
  //override the default log level globally
  $log.currentLevel = $log.LEVELS.error;
});
```

### Optional Debug Levels via [debug](https://github.com/visionmedia/debug)

If you choose to use the [full version of this library](./dist/angular-simple-logger.js) and no the [light](./dist/angular-simple-logger.light.js).

You can add finer grain debug levels via the [visionmedia/debug API](https://github.com/visionmedia/debug).

To use:

```js
angular.module('someApp', ['nemLogging']))
//as a provider
.config(function(nemDebugProvider) {
  var debug = nemDebugProvider.debug;
  debug.enable("worker:*");
})
.service('LoggerLevelA', function(nemSimpleLogger) {
  //will have debug, info, warn, error, and log at disposal as before, but now debug is using the visionmedia/debug fn
  return nemSimpleLogger.spawn("worker:a");
})
.service('LoggerLevelB', function(nemSimpleLogger) {
  return nemSimpleLogger.spawn("worker:b");
})
//heck maybe you don't want all of the logger interface only want debug.. then
.service('JustDebugC',function(nemDebug) {
  return nemDebug("worker:c");
})
.run(function(nemDebug){
  //enable another debug level
  nemDebug.enable("coolStuff:*");
});
```

### API
Underneath it all it is still calling `$log` so calling the logger for logging itself is the same.

- LEVELS: available are `debug, info, warn, error, log`

- doLog (boolean) - deaults to true. If set to false all logging for that logger instance is disabled.

- currentLevel (number) - defaults to `error: 4` corresponds to the current log level provided by `LEVELS`.

- spawn - create a independent logger accepts a logger or a string (see visionmedia debug notes above). Defaults to $log
