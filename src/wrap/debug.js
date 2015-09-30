angular.module('nemLogging').provider('nemDebug', function (){
  var ourDebug = null;
  <%= contents %>
  this.$get =  function(){
    //avail as service
    return ourDebug;
  };

  //avail at provider, config time
  this.debug = ourDebug;

  return this;
});
