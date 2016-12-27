/*
	 * MAP对象，实现MAP功能
	 *
	 * 接口：
	 * size()     获取MAP元素个数
	 * isEmpty()    判断MAP是否为空
	 * clear()     删除MAP所有元素
	 * put(key, value)   向MAP中增加元素（key, value)
	 * remove(key)    删除指定KEY的元素，成功返回True，失败返回False
	 * get(key)    获取指定KEY的元素值VALUE，失败返回NULL
	 * element(index)   获取指定索引的元素（使用element.key，element.value获取KEY和VALUE），失败返回NULL
	 * containsKey(key)  判断MAP中是否含有指定KEY的元素
	 * containsValue(value) 判断MAP中是否含有指定VALUE的元素
	 * values()    获取MAP中所有VALUE的数组（ARRAY）
	 * keys()     获取MAP中所有KEY的数组（ARRAY）
	 *
	 * 例子：
	 * var map = new Map();
	 *
	 * map.put("key", "value");
	 * var val = map.get("key")
	 * ……
	 *
	 */
;(function($){
	if(navigator.userAgent.indexOf("MSIE")!=-1) { 
		currentLang = navigator.browserLanguage.toLowerCase();
	} else{
		currentLang = navigator.language.toLowerCase();
	}
//	if(!+[1,]){
//		currentLang = navigator.browserLanguage.toLowerCase();
//	}else{
//		currentLang = navigator.language.toLowerCase();
//	}
	var root = $("script").last().attr("src");
	var index = root.lastIndexOf("/");
	root = root.substring(0,index);
	if(window.i18n==null||window.i18n==""){
		var script = window.document.createElement("script");
		script.setAttribute("type","text/javascript");
		script.setAttribute("src",root+"/i18n/message-"+currentLang+".js");
		window.document.getElementsByTagName("head")[0].appendChild(script);
	}
})(jQuery)
	function Map() {
	    this.elements = new Array();
	 
	    //获取MAP元素个数
	    this.size = function() {
	        return this.elements.length;
	    }
	 
	    //判断MAP是否为空
	    this.isEmpty = function() {
	        return (this.elements.length < 1);
	    }
	 
	    //删除MAP所有元素
	    this.clear = function() {
	        this.elements = new Array();
	    }
	 
	    //向MAP中增加元素（key, value)
	    this.put = function(_key, _value) {
	        this.elements.push( {
	            key : _key,
	            value : _value
	        });
	    }
	 
	    //删除指定KEY的元素，成功返回True，失败返回False
	    this.remove = function(_key) {
	        var bln = false;
	        try {
	            for (i = 0; i < this.elements.length; i++) {
	                if (this.elements[i].key == _key) {
	                    this.elements.splice(i, 1);
	                    return true;
	                }
	            }
	        } catch (e) {
	            bln = false;
	        }
	        return bln;
	    }
	 
	    //获取指定KEY的元素值VALUE，失败返回NULL
	    this.get = function(_key) {
	        try {
	            for (i = 0; i < this.elements.length; i++) {
	                if (this.elements[i].key == _key) {
	                    return this.elements[i].value;
	                }
	            }
	        } catch (e) {
	            return null;
	        }
	    }
	 
	    //获取指定索引的元素（使用element.key，element.value获取KEY和VALUE），失败返回NULL
	    this.element = function(_index) {
	        if (_index < 0 || _index >= this.elements.length) {
	            return null;
	        }
	        return this.elements[_index];
	    }
	 
	    //判断MAP中是否含有指定KEY的元素
	    this.containsKey = function(_key) {
	        var bln = false;
	        try {
	            for (i = 0; i < this.elements.length; i++) {
	                if (this.elements[i].key == _key) {
	                    bln = true;
	                }
	            }
	        } catch (e) {
	            bln = false;
	        }
	        return bln;
	    }
	 
	    //判断MAP中是否含有指定VALUE的元素
	    this.containsValue = function(_value) {
	        var bln = false;
	        try {
	            for (i = 0; i < this.elements.length; i++) {
	                if (this.elements[i].value == _value) {
	                    bln = true;
	                }
	            }
	        } catch (e) {
	            bln = false;
	        }
	        return bln;
	    }
	 
	    //获取MAP中所有VALUE的数组（ARRAY）
	    this.values = function() {
	        var arr = new Array();
	        for (i = 0; i < this.elements.length; i++) {
	            arr.push(this.elements[i].value);
	        }
	        return arr;
	    }
	 
	    //获取MAP中所有KEY的数组（ARRAY）
	    this.keys = function() {
	        var arr = new Array();
	        for (i = 0; i < this.elements.length; i++) {
	            arr.push(this.elements[i].key);
	        }
	        return arr;
	    }
	}
	
	/**
	 * 毫秒转为为时分秒格式
	 * @param value 毫秒
	 * @return 时分秒
	 */
	function formatSeconds(msd) {
		var time = parseFloat(msd) /1000;
        if (null!= time && "" != time) {
            if (time >60&& time <60*60) {
                time = parseInt(time /60.0) +i18n.minute+ parseInt((parseFloat(time /60.0) -
                parseInt(time /60.0)) *60) +i18n.second;
            }else if (time >=60*60&& time <60*60*24) {
                time = parseInt(time /3600.0) +i18n.hour+ parseInt((parseFloat(time /3600.0) -
                parseInt(time /3600.0)) *60) +i18n.minute+
                parseInt((parseFloat((parseFloat(time /3600.0) - parseInt(time /3600.0)) *60) -
                parseInt((parseFloat(time /3600.0) - parseInt(time /3600.0)) *60)) *60) +i18n.second;
            }else {
                time = parseInt(time) +i18n.second;
            }
        }else{
            time = "0"+i18n.second;
        }
        return time;
   } 