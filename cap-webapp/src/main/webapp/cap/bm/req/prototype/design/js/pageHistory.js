/*===============================
=            History历史模块    =
===============================*/
define(function(require,exports,module){
  var _ = require('lodash/lodash');
  function pageHistory(){
        this.histroy =[];
        this.i = -1;
      }
  _.assign(pageHistory.prototype,{
    add:function (obj) {
      this.histroy.push(_.cloneDeep( obj ));
      this.i = this.histroy.length -1;
    },
    isEnd:function(isPrev){
      if(this.i == 0 && isPrev){
        return false;
      }else if(this.i ==(this.histroy.length-1) && !isPrev){
        return false;
      }else{
        return true;
      }
    },
    prev:function(){
      this.i = this.i - 1;
      return this.histroy[this.i]
    },
    next:function(){
      this.i = this.i + 1;
      return  this.histroy[this.i]
    }
  })
  module.exports = pageHistory;
})


