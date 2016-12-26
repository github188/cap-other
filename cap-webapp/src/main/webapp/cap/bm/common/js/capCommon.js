	/***
	* 获取指定内容在数据中的位置，如果不存在则返回-1；如果存在多个则只返回第一个的位置
	*/
	function arrayIndexof(array,value){
		for(var i=0;i<array.length;i++){
			if(array[i]==value){
				return i;
			}
		}
		return -1;
	}
	
	/**
	 * 因为在IE8,js数组没有indexOf方法;在执行的时候添加上这个方法。
	 */
	function addIndexOfMethod(){
		if (!Array.prototype.indexOf){
		  	Array.prototype.indexOf = function(elt){
			    var len = this.length >>> 0;
			    var from = Number(arguments[1]) || 0;
			    from = (from < 0)? Math.ceil(from): Math.floor(from);
			    if (from < 0){
				      from += len;
			    }
			    for(; from < len; from++){
			      if (from in this && this[from] === elt){
				        return from;
			      }
			    }
			    return -1;
		  	};
		}
	}