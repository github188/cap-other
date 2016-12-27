/*
	 * MAP����ʵ��MAP����
	 *
	 * �ӿڣ�
	 * size()     ��ȡMAPԪ�ظ���
	 * isEmpty()    �ж�MAP�Ƿ�Ϊ��
	 * clear()     ɾ��MAP����Ԫ��
	 * put(key, value)   ��MAP������Ԫ�أ�key, value)
	 * remove(key)    ɾ��ָ��KEY��Ԫ�أ��ɹ�����True��ʧ�ܷ���False
	 * get(key)    ��ȡָ��KEY��Ԫ��ֵVALUE��ʧ�ܷ���NULL
	 * element(index)   ��ȡָ��������Ԫ�أ�ʹ��element.key��element.value��ȡKEY��VALUE����ʧ�ܷ���NULL
	 * containsKey(key)  �ж�MAP���Ƿ���ָ��KEY��Ԫ��
	 * containsValue(value) �ж�MAP���Ƿ���ָ��VALUE��Ԫ��
	 * values()    ��ȡMAP������VALUE�����飨ARRAY��
	 * keys()     ��ȡMAP������KEY�����飨ARRAY��
	 *
	 * ���ӣ�
	 * var map = new Map();
	 *
	 * map.put("key", "value");
	 * var val = map.get("key")
	 * ����
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
	 
	    //��ȡMAPԪ�ظ���
	    this.size = function() {
	        return this.elements.length;
	    }
	 
	    //�ж�MAP�Ƿ�Ϊ��
	    this.isEmpty = function() {
	        return (this.elements.length < 1);
	    }
	 
	    //ɾ��MAP����Ԫ��
	    this.clear = function() {
	        this.elements = new Array();
	    }
	 
	    //��MAP������Ԫ�أ�key, value)
	    this.put = function(_key, _value) {
	        this.elements.push( {
	            key : _key,
	            value : _value
	        });
	    }
	 
	    //ɾ��ָ��KEY��Ԫ�أ��ɹ�����True��ʧ�ܷ���False
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
	 
	    //��ȡָ��KEY��Ԫ��ֵVALUE��ʧ�ܷ���NULL
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
	 
	    //��ȡָ��������Ԫ�أ�ʹ��element.key��element.value��ȡKEY��VALUE����ʧ�ܷ���NULL
	    this.element = function(_index) {
	        if (_index < 0 || _index >= this.elements.length) {
	            return null;
	        }
	        return this.elements[_index];
	    }
	 
	    //�ж�MAP���Ƿ���ָ��KEY��Ԫ��
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
	 
	    //�ж�MAP���Ƿ���ָ��VALUE��Ԫ��
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
	 
	    //��ȡMAP������VALUE�����飨ARRAY��
	    this.values = function() {
	        var arr = new Array();
	        for (i = 0; i < this.elements.length; i++) {
	            arr.push(this.elements[i].value);
	        }
	        return arr;
	    }
	 
	    //��ȡMAP������KEY�����飨ARRAY��
	    this.keys = function() {
	        var arr = new Array();
	        for (i = 0; i < this.elements.length; i++) {
	            arr.push(this.elements[i].key);
	        }
	        return arr;
	    }
	}
	
	/**
	 * ����תΪΪʱ�����ʽ
	 * @param value ����
	 * @return ʱ����
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