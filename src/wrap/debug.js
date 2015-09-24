angular.module('nemLogging').provider('nemDebug', function (){
  var ourDebug = null;
  function saveDebugCb (module){
    ourDebug = module;
  }
  //INJECT https://github.com/visionmedia/debug here
  (function (callback) {
    var debugOrig = window.debug;

    <%= contents %>

    var debugModule = window.debug;

    //RESTET browser debug
    window.debug = debugOrig;
    callback(debugModule);
  })(saveDebugCb);
  //END INJECT

  this.$get =  function(){
    //avail as service
    return ourDebug;
  };

  //avail at provider, config time
  this.debug = ourDebug;

  return this;
});
