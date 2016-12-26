
function HashMap() {
	// 定义长度
	var length = 0;
	// 创建一个对象
	var obj = new Object();

	/**
	 * 判断Map是否为空
	 */
	this.isEmpty = function() {
		return length == 0;
	};

	/**
	 * 判断对象中是否包含给定Key
	 */
	this.containsKey = function(key) {
		return (key in obj);
	};

	/**
	 * 判断对象中是否包含给定的Value
	 */
	this.containsValue = function(value) {
		for ( var key in obj) {
			if (obj[key] == value) {
				return true;
			}
		}
		return false;
	};

	/**
	 * 向map中添加数据
	 */
	this.put = function(key, value) {
		if (!this.containsKey(key)) {
			length++;
		}
		obj[key] = value;
	};

	/**
	 * 根据给定的Key获得Value
	 */
	this.get = function(key) {
		return this.containsKey(key) ? obj[key] : null;
	};

	/**
	 * 根据给定的Key删除一个值
	 */
	this.remove = function(key) {
		if (this.containsKey(key) && (delete obj[key])) {
			length--;
		}
	};

	/**
	 * 获得Map中的所有Value
	 */
	this.values = function() {
		var _values = new Array();
		for ( var key in obj) {
			_values.push(obj[key]);
		}
		return _values;
	};

	/**
	 * 获得Map中的所有Key
	 */
	this.keySet = function() {
		var _keys = new Array();
		for ( var key in obj) {
			_keys.push(key);
		}
		return _keys;
	};

	/**
	 * 获得Map的长度
	 */
	this.size = function() {
		return length;
	};

	/**
	 * 清空Map
	 */
	this.clear = function() {
		length = 0;
		obj = new Object();
	};
}


//CAP模块
window.CAP = window.CAP || {};
$.extend(CAP,{
	isScroll:function(el){
	    // test targets
	    var elems = el ? [el] : [document.documentElement, document.body];
	    var scrollX = false, scrollY = false;
	    for (var i = 0; i < elems.length; i++) {
	        var o = elems[i];
	        // test horizontal
	        var sl = o.scrollLeft;
	        o.scrollLeft += (sl > 0) ? -1 : 1;
	        o.scrollLeft !== sl && (scrollX = scrollX || true);
	        o.scrollLeft = sl;
	        // test vertical
	        var st = o.scrollTop;
	        o.scrollTop += (st > 0) ? -1 : 1;
	        o.scrollTop !== st && (scrollY = scrollY || true);
	        o.scrollTop = st;
	    }
	    // ret
	    return {
	        scrollX: scrollX,
	        scrollY: scrollY
	    }
	},
	param:function(){
	    var result = {}, queryString = location.search.substring(1),
	        re = /([^&=]+)=([^&]*)/g, m;
	    while (m = re.exec(queryString)) {
	        result[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
	    }
	    return result;
	},
	Modules:new HashMap(),
	namespace:function(ns){
		if (!ns || !ns.length) {
	        return null;
	     }

	    var levels = ns.split(".");
	    var nsobj = window;

	    for (var i=(levels[0] == "CAP") ? 1 : 0; i<levels.length; ++i) {
	         nsobj[levels[i]] = nsobj[levels[i]] || {};
	         nsobj = nsobj[levels[i]];
	     }

	    return nsobj;
	},
	/**
	 * @param ns空间名
	 * @param depend，require依赖
	 * @param fn初始化函数一个参数（一个空间名对象）
	 */
	Module:function(ns,depend,fn){
		var obj= CAP.namespace(ns);
		CAP.Modules.put(ns,obj);//放入全局HashMap中
		fn.call(this,obj);
		require(depend||[],function(){
			obj.init && obj.init.call();
		})
	}
});
$.extend($.fn,{
	capLoad:function(url,fn){
		$(this).attr("Module",url).load(url,function(){
			$(this).attr("Module",url).data("isLoad",true);
			fn.call(this);
		});
		return this;
	}
});


