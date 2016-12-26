/**
 * CAP建模公共JS
 * Created by 郑重 on 2015-05-22.
 */

//cap命名空间
var cap = cap?cap:{};
/**
 * 会话本地存储封装类
 */
(function (cap) {
    var SessionStorage = (function () {

        //会话存储方式
        var session = window.sessionStorage;

        /**
         * 构造函数
         * @param namespace 模型ID，用来做命名空间
         * @constructor
         */
        function SessionStorage(namespace) {
            if (namespace != null) {
                this.namespace = namespace + ".";
            } else {
                this.namespace = "";
            }
        }

        /**
         * 设置值到session
         * @param key
         * @param value
         */
        SessionStorage.prototype.set = function (key, value) {
            session.setItem(this.namespace + key, value);
        };

        /**
         * 根据key获取值
         * @param key
         * @returns {*}
         */
        SessionStorage.prototype.get = function (key) {
            return session.getItem(this.namespace + key);
        };

        /**
         * 移除key对应的项
         * @param key
         */
        SessionStorage.prototype.remove = function (key) {
            session.removeItem(this.namespace + key);
        };

        /**
         * 清除当前命名空间下的所有项
         */
        SessionStorage.prototype.clear = function () {
            if (this.namespace != "") {
                for (var i = 0; i < session.length; i++) {
                    var name = session.key(i);
                    if (name.indexOf(this.namespace) != -1) {
                        session.removeItem(name);
                    }
                }
            }
        };
        return SessionStorage;
    })();
    cap.SessionStorage = SessionStorage;
})(cap || (cap = {}));


/**
 * 页面存储封装类
 * 
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2015-09-06
 */
(function (cap) {
	cap.PageStorage = (function () {

        /**
         * 构造函数
         * @param namespace 模型ID，用来做命名空间
         * @constructor
         */
        function PageStorage(namespace) {
            if (namespace != null) {
                this.namespace = namespace + ".";
            } else {
                this.namespace = "";
            }
        }

        /**
         * 根据key和value设置页面存储数据
         * @param key value
         */
        PageStorage.prototype.createPageAttribute = function (key, value) {
        	window[this.namespace + key] = value;
        };
        
        /**
         * 根据key获取值
         * @param key
         * @returns {*}
         */
        PageStorage.prototype.get = function (key) {
        	var _key = this.namespace + key;
        	var _targetWindow = cap.searchParentWindow(_key);
        	return _targetWindow ? _targetWindow[_key] : _targetWindow;
        };

        return PageStorage;
    })();
})(cap || (cap = {}));


/**
 * if the iteratively window has parent and the parent is not itself and the parent is not current window,
 * then judge the parent window has or hasn't we need <code>key</code>.
 * if has,return immediately,else assignment the parent window to the iteratively window,then enter the next each.
 *  
 * else if the iteratively window has opener and the opener is not itself and the opener is not current window,
 * then judge the opener window has or hasn't we need <code>key</code>.
 * if has,return immediately,else assignment the opener window to the iteratively window,then enter the next each.
 * 
 * if the iteratively window has not parent and opener,return null.
 * 
 * @author lingchen WWW.SZCOMTOP.COM 
 * @Date 2015-09-02
 * @param key the key for search parent window
 */
(function(cap){
	cap.searchParentWindow = function(key){
		//get key from current window
		if(window[key]){
			return window;
		}
		
		var _window = window;
		//each window
		while(true){
			try{
				if(_window.parent && _window.parent != _window && _window.parent != window){
					if(_window.parent[key]){
						return _window.parent;
					}else{
						_window = _window.parent;
					}
				}else if(_window.opener && _window.opener != _window && _window.opener != window){
					if(_window.opener[key]){
						return _window.opener;
					}else{
						_window = _window.opener;
					}
				}else if(_window == window){
					return null;
				}else{
					return null;
				}
			}catch(err){
				return null;
			}
		}
	};
})(cap || (cap = {}));


/**
 * 消息发送器
 * 
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2015-09-06
 */

(function (cap) {
	cap.MessageManager = (function () {
        
		//单例对象
		var msgManagerInstance;
    	
		/**
		 * 获取MessageManager的单例
		 * @param 构造单例对象需要的参数
		 */
    	function getInstance(methodName){
    		if(msgManagerInstance == undefined){
    			msgManagerInstance = new MessageManager(methodName);
    		}
    		return msgManagerInstance;
    	}
        
        
        /**
         * 构造函数
         * @param methodName 主页面发通知的方法的名称
         * @constructor
         */
        function MessageManager(methodName) {
        	if (methodName != null) {
                this.methodName = methodName;
            } else {
                this.methodName = "sendMessage";
            }
        }

        /**
         * 发送消息
         * @param iframeId 发送的目的地iframe
         * @param data 发送的数据.{type:'消息标识',data:数据}
         * @return true 发送成功;false 发送失败（找不到页面存在methodName）
         */
        MessageManager.prototype.sendMessage = function (iframeId,data) {
        	//get method from current window
        	if(window[this.methodName]){
        		window[this.methodName](iframeId,data);
        		return true; 
        	}
        	
        	var _window = window;
        	//each window
        	while(true){
        		if(_window.parent && _window.parent != _window && _window.parent != window){
        			if(_window.parent[this.methodName]){
        				_window.parent[this.methodName](iframeId,data);
        				return true;
        			}else{
        				_window = _window.parent;
        			}
        		}else if(_window.opener && _window.opener != _window && _window.opener != window){
        			if(_window.opener[this.methodName]){
        				_window.opener[this.methodName](iframeId,data);
        				return true;
        			}else{
        				_window = _window.opener;
        			}
        		}else if(_window == window){
        			return false;
        		}else{
        			return false;
        		}
        	}
        };

        return {'getInstance':getInstance};
    })();
})(cap || (cap = {}));


/**
 * 本地数据库类
 */
(function (cap) {
	
    var DBStorage = (function () {

        //数据库
        var db=null;
        var dbName="CAPDatabase";
        var tableName="MetaTable"

        /**
         * 构造函数
         * @param namespace 模型ID，用来做命名空间
         * @param isSynchronization 是否同步
         * @constructor
         */
        function DBStorage(namespace,fun) {
        	var that=this;
            if (namespace != null) {
                this.namespace = namespace + ".";
            } else {
                this.namespace = "";
            }
            
            var request = indexedDB.open(dbName);
            
    		request.onerror = function(event) {
    		  alert("无法创建/打开数据库，请使用chrome浏览器!");
    		};
    		
    		request.onsuccess = function(event) {
    		  	db = request.result;
    		  	db.onerror = function(event) {
        			console.error("数据操作错误: " + event.target.errorCode);
    			};
    			if(fun!=null){
    		  		fun.call(that);
    		  	}
    		};

    		request.onupgradeneeded = function (evt) {
    			var store = evt.currentTarget.result.createObjectStore(tableName, {});
    	    };
        }

        /**
         * 设置值到session
         * @param key
         * @param value
         */
        DBStorage.prototype.set = function (key, value) {
        	if(db!=null){
        		var transaction = db.transaction(tableName, "readwrite");
        		var objectStore = transaction.objectStore(tableName);
        		objectStore.put(value,this.namespace + key);
        	}else{
        		console.error("DB对象未被初始化，请检查代码确定异步调用顺序");
        	}
        };

        /**
         * 根据key获取值
         * @param key
         * @returns {*}
         */
        DBStorage.prototype.get = function (key,fun) {
        	if(db!=null){
        		var transaction = db.transaction(tableName, "readwrite");
        		var objectStore = transaction.objectStore(tableName);
                var request=objectStore.get(this.namespace + key);
                var value=null;
                request.onsuccess=function(e){ 
                    value=e.target.result;
                    if(fun!=null){
                    	fun.call(window,value);
                    }
                };
        	}else{
        		console.error("DB对象未被初始化，请检查代码确定异步调用顺序");
        	}
        };

        /**
         * 移除key对应的项
         * @param key
         */
        DBStorage.prototype.remove = function (key) {
        	if(db!=null){
        		var transaction=db.transaction(tableName,'readwrite'); 
    			var objectStore=transaction.objectStore(tableName); 
    			objectStore.delete(this.namespace + key); 
        	}else{
        		console.error("DB对象未被初始化，请检查代码确定异步调用顺序");
        	}
        };
        
        /**
         * 清除当前命名空间下的所有项
         */
        DBStorage.prototype.clear = function () {
        	if(db!=null){
				var transaction=db.transaction(tableName,'readwrite'); 
				var objectStore=transaction.objectStore(tableName); 
				objectStore.clear();
        	}else{
        		console.error("DB对象未被初始化，请检查代码确定异步调用顺序");
        	}
        };

        return DBStorage;
    })();
    cap.DBStorage = DBStorage;
})(cap || (cap = {}));

/**
 *  深度遍历对象添加监听方法
 * @type {*}
 */
cap.addObserve=function(obj,fun){
	if(typeof(obj) == "object" && obj!=null && obj!=undefined){
        Object.observe(obj,fun);
    }
    for(var i in obj) {
        if(typeof(obj[i]) == "object" || typeof(obj[i]) == "function") {
        	cap.addObserve(obj[i],fun);
        }
    }
};

/**
 * 集合操作封装
 */
(function (cap) {
    var CollectionUtil= (function () {

        /**
         * 构造函数
         * @param d 被操作的集合数据
         * @constructor
         */
        function CollectionUtil(d) {
            this.data =d;
        }


        /**
         * 查询方法
         * @param exp 查询表达式
         * @param sortName 排序字段
         * @param sortType 排序类型
         * @returns {*}
         */
        CollectionUtil.prototype.query = function (exp,sortName,sortType) {
            var sql={
                Select: ['*'],
                From: this.data,
                Where: function(){
                    return eval(exp);
                }
            }
            if(sortName !=null){
                sql.OrderBy=[sortName,'|'+sortType+'|']
            }
            return SQLike.q(sql);
        };

        /**
         * 新增方法
         * @param obj 新增对象
         */
        CollectionUtil.prototype.insert = function (obj) {
            SQLike.q(
                {
                    InsertInto: this.data,
                    Values: obj
                }
            )
        };

        /**
         * 修改对象
         * @param exp 表达式
         * @param obj 修改对象
         */
        CollectionUtil.prototype.update = function (exp,obj) {
            SQLike.q(
                {
                    Update: this.data,
                    Set: function(){
                        if(obj!=null){
                            for(var item in obj){
                                this[item]=obj[item];
                            }
                        }
                    },
                    Where: function(){return eval(exp);}
                }
            )
        };

        /**
         * 删除方法
         * @param exp 删除表达式
         */
        CollectionUtil.prototype.delete = function (exp) {
            SQLike.q(
                {
                    DeleteFrom: this.data,
                    Where:function(){return eval(exp);}
                }
            )
        };

        return CollectionUtil;
    })();
    cap.CollectionUtil = CollectionUtil;
})(cap || (cap = {}));

/**
 * 校验类
 */
(function (cap) {
    var Validate= (function () {
    	
    	var validate={
			/**
	         * 验证是否存在(扩展字段 req)
	         * 参数 解释数据
	         * m: 出错信息字符串
	         * emptyVal:包含在其中的也算为空
	         */
	        required: function(value, paramsObj){
	            var params = $.extend({
	                m: "不能为空!"
	            }, paramsObj || {});
	            if(value === null || value === undefined) {
	            	validate.fail(params.m);
	            }
	            if(typeof value ==="string"&&$.trim(value)===''){
	            	validate.fail(params.m);
	            }
	            if (params.emptyVal) {
	                $.each(params.emptyVal, function(i, item) {
	                    if (value == item) {
	                    	validate.fail(params.m);
	                    }
	                });
	            }
	            if ($.type(value) === 'array') {
	                if(value.length === 0){
	                	validate.fail(params.m);
	                }else{
	                    for (var i = 0; i < value.length; i++) {
	                        if ($.trim(value[i]) === '' || value[i] === null || value[i] === undefined) {
	                        	validate.fail(params.m);
	                            break;
	                        }
	                    }
	                }
	            }
	            return true;
	        },
	
	        /**
	         * 验证数值类型(扩展字段 num)
	         * 参数 解释                                 数据
	         *  oi： 是否只能为Integer （onlyInteger）     true/false
	         *  min: 最小数                               数字
	         *  max: 最大数                               数字
	         *  is:  必须和该数字相等                      数字
	         *  wrongm: 输入不和 is 相等的数字时提示信息       数字
	         *  notnm：不为数字时提示信息                    字符串
	         *  notim：不为整数时提示信息                    字符串
	         *  minm：小于 min 数字时提示信息               字符串
	         *  maxm：大于 max 数字时提示信息               字符串
	         */
	        numeric: function(value, paramsObj){
	            var suppliedValue = value;
	            if ('' === value) return true;
	            var value = Number(value);
	            var paramsObj = paramsObj || {};
	            var params = {
	                notANumberMessage:  paramsObj.notnm || "必须为数字!",
	                notAnIntegerMessage: paramsObj.notim || "必须为整数!",
	                wrongNumberMessage: paramsObj.wrongm || "必须为 " + paramsObj.is + "!",
	                tooLowMessage:         paramsObj.minm || "必须大于 " + paramsObj.min + "!",
	                tooHighMessage:        paramsObj.maxm || "必须小于 " + paramsObj.max + "!",
	                is:                            ((paramsObj.is) || (paramsObj.is == 0)) ? paramsObj.is : null,
	                minimum:                   ((paramsObj.min) || (paramsObj.min == 0)) ? paramsObj.min : null,
	                maximum:                  ((paramsObj.max) || (paramsObj.max == 0)) ? paramsObj.max : null,
	                onlyInteger:               paramsObj.oi || false
	            };
	            if (!isFinite(value))  validate.fail(params.notANumberMessage);
	            if (params.onlyInteger && !/^\d+$/.test(String(suppliedValue))) {
	                validate.fail(params.notAnIntegerMessage);
	            }
	            switch(true){
	                case (params.is !== null):
	                    if( value != Number(params.is) ) validate.fail(params.wrongNumberMessage);
	                    break;
	                case (params.minimum !== null && params.maximum !== null):
	                    validate.numeric(value, {minm: params.tooLowMessage, min: params.minimum});
	                    validate.numeric(value, {maxm: params.tooHighMessage, max: params.maximum});
	                    break;
	                case (params.minimum !== null):
	                    if( value < Number(params.minimum) ) validate.fail(params.tooLowMessage);
	                    break;
	                case (params.maximum !== null):
	                    if( value > Number(params.maximum) ) validate.fail(params.tooHighMessage);
	                    break;
	            }
	            return true;
	        },
	
	        /**
	         * 正则表达式验证 (扩展字段 format)
	         *  参数   解释                                 数据
	         *  m:     出错信息                             字符串
	         *  pattern: 验证正则表达式                     字符串
	         *  negate: 是否忽略本次验证（negate）           true/false
	         */
	        format: function(value, paramsObj){
	            var value = String(value);
	            if ('' == value) return true;
	            var params = $.extend({
	                m: "不符合规定格式!",
	                pattern:           /./ ,
	                negate:            false
	            }, paramsObj || {});
	            params.pattern = $.type(params.pattern) == "string" ? new RegExp(params.pattern) : params.pattern;
	            if(!params.negate) {//不忽略
	                if(!params.pattern.test(value)) { //不忽略,且验证不过
	                    validate.fail(params.m);
	                }
	            }
	            return true;
	        },
	
	        /**
	         * 邮箱格式验证 (扩展字段 email)
	         * 参数 解释                                 数据
	         *  m:   出错信息                             字符串
	         */
	        email: function(value, paramsObj){
	            if ('' == value) return true;
	            var params = $.extend({
	                m: "邮箱格式输入不合法!"
	            }, paramsObj || {});
	            validate.format(value, {
	                m: params.m,
	                pattern: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
	            });
	            return true;
	        },
	
	        /**
	         * 日期格式验证 (扩展字段 date)考虑了闰年、二月等因素
	         * 参数 解释                                 数据
	         *  m:   出错信息                            字符串
	         */
	        dateFormat : function(value, paramsObj) {
	            var params = $.extend({
	                m: "日期格式必须为yyyy-MM-dd形式！"
	            }, paramsObj || {});
	            validate.format(value, {
	                m: params.m,
	                pattern: /^((((((0[48])|([13579][26])|([2468][048]))00)|([0-9][0-9]((0[48])|([13579][26])|([2468][048]))))-02-29)|(((000[1-9])|(00[1-9][0-9])|(0[1-9][0-9][0-9])|([1-9][0-9][0-9][0-9]))-((((0[13578])|(1[02]))-31)|(((0[1,3-9])|(1[0-2]))-(29|30))|(((0[1-9])|(1[0-2]))-((0[1-9])|(1[0-9])|(2[0-8]))))))$/i
	            });
	            return true;
	        },
	
	        /**
	         * 长度验证(扩展字段 len)
	         * 参数 解释                               数据
	         *  m:   出错信息                          字符串
	         *  min: 最小长度                          数字
	         *  max: 最大长度                          数字
	         *  is:  必须和该长度相等                     数字
	         *  wrongm: 输入长度和 is 不相等时提示信息        数字
	         *  minm：长度小于 min 数字时提示信息            字符串
	         *  maxm：长度大于 max 数字时提示信息            字符串
	         */
	        length: function(value, paramsObj){
	            var value = String(value);
	            var paramsObj = paramsObj || {};
	            var params = {
	                wrongLengthMessage: paramsObj.wrongm || "长度必须为 " + paramsObj.is + " 字节!",
	                tooShortMessage:      paramsObj.minm || "长度必须大于 " + paramsObj.min + " 字节!",
	                tooLongMessage:       paramsObj.maxm || "长度必须小于 " + paramsObj.max + " 字节!",
	                is:                           ((paramsObj.is) || (paramsObj.is == 0)) ? paramsObj.is : null,
	                minimum:                  ((paramsObj.min) || (paramsObj.min == 0)) ? paramsObj.min : null,
	                maximum:                 ((paramsObj.max) || (paramsObj.max == 0)) ? paramsObj.max : null
	            }
	            switch(true){
	                case (params.is !== null):
	                    if( value.replace(/[^\x00-\xff]/g, "xx").length != Number(params.is) ) {
	                        validate.fail(params.wrongLengthMessage);
	                    }
	                    break;
	                case (params.minimum !== null && params.maximum !== null):
	                    validate.length(value, {minm: params.tooShortMessage, min: params.minimum});
	                    validate.length(value, {maxm: params.tooLongMessage, max: params.maximum});
	                    break;
	                case (params.minimum !== null):
	                    if( value.replace(/[^\x00-\xff]/g, "xx").length < Number(params.minimum) ) {
	                        validate.fail(params.tooShortMessage);
	                    }
	                    break;
	                case (params.maximum !== null):
	                    if( value.replace(/[^\x00-\xff]/g, "xx").length > Number(params.maximum) ) {
	                        validate.fail(params.tooLongMessage);
	                    }
	                    break;
	                default:
	                    throw new validate.error("validate::Length - 长度验证必须提供长度值!");
	            }
	            return true;
	        },
	
	        /**
	         * 包含验证 (扩展字段 inc)
	         * 参数 解释                                 数据
	         *  m:   出错信息                             字符串
	         *  negate: 是否忽略                          true/false
	         *  caseSensitive: 大小写敏感(caseSensitive)   true/false
	         *  allowNull: 是否可以为空                    数字
	         *  within:  集合                             数组
	         *  partialMatch: 是否部分匹配                 true/false
	         */
	        inclusion: function(value, paramsObj){
	            var params = $.extend({
	                m: "",
	                within:           [],
	                allowNull:        false,
	                partialMatch:   false,
	                caseSensitive: true,
	                negate:          false
	            }, paramsObj || {});
	            params.m = params.m || value + "没有包含在数组" + params.within.join(',') + "中";
	            if(params.allowNull && !value) return true;
	            if(!params.allowNull && !value) validate.fail(params.m);
	            if(!params.caseSensitive){
	                var lowerWithin = [];
	                $.each(params.within, function(index, item){
	                    if(typeof item == 'string') item = item.toLowerCase();
	                    lowerWithin.push(item);
	                });
	                params.within = lowerWithin;
	                if(typeof value == 'string') value = value.toLowerCase();
	            }
	
	            var found = false;
	            $.each(params.within, function(index, item) {
	                if (item == value) found = true;
	                if (params.partialMatch) {
	                    if (value.indexOf(item) != -1) {
	                        found = true;
	                    }
	                }
	            });
	            if( (!params.negate && !found) || (params.negate && found) ) validate.fail(params.m);
	            return true;
	        },
	
	        /**
	         * 不包含验证 (扩展字段 exc)
	         * 参数 解释                                 数据
	         *  m:   出错信息                             字符串
	         *  caseSensitive: 大小写敏感(caseSensitive)   true/false
	         *  allowNull: 是否可以为空                    数字
	         *  within:  集合                             数组
	         *  partialMatch: 是否部分匹配                 true/false
	         */
	        exclusion: function(value, paramsObj){
	            var params = $.extend({
	                m: "",
	                within:             [],
	                allowNull:          false,
	                partialMatch:     false,
	                caseSensitive:   true
	            }, paramsObj || {});
	            params.m = params.m || value + "不应该在数组" + params.within.join(',') + "中！";
	            params.negate = true;// set outside of params so cannot be overridden
	            validate.inclusion(value, params);
	            return true;
	        },
	
	        /**
	         * 组合匹配一致验证，如用户名和密码 (扩展字段 confirm)
	         * 参数 解释                                 数据
	         *  m:   出错信息                             字符串
	         *  match: 验证与之匹配的元素引用              元素或元素id
	         */
	        confirmation: function(value, paramsObj){
	            if(!paramsObj.match) {
	                throw new Error("validate::Confirmation - 与之匹配的元素引用或元素id必须被提供!");
	            }
	            var params = $.extend({
	                m: "两者不一致!",
	                match:            null
	            }, paramsObj || {});
	            params.match = $.type(params.match) == 'string' ? cui('#' + params.match) : params.match;
	            if(!params.match || params.match.length == 0) {
	                throw new Error("validate::Confirmation - 与之匹配的元素引用或元素不存在!");
	            }
	            if(value != params.match.getValue()) {
	            	validate.fail(params.m);
	            }
	            return true;
	        },
	
	        /**
	         * 验证值是否为true 主要是验证checkbox (扩展字段 accept)
	         * 参数 解释                                 数据
	         *  m:   出错信息                             字符串
	         */
	        acceptance: function(value, paramsObj){
	            var params = $.extend({
	                m: "必须选择!"
	            }, paramsObj || {});
	            if(!value) {
	            	validate.fail(params.m);
	            }
	            return true;
	        },
	
	        /**
	         * 自定义验证函数 (扩展字段 custom)
	         * 参数 解释                                 数据
	         *  m:   出错信息                             字符串
	         *  against:  自定义的函数                    function
	         *  args:   自定义的函数的参数                 对象
	         * */
	        custom: function(value, paramsObj){
	            var params = $.extend({
	                against: function(){ return true; },
	                args: {},
	                m: "不合法!"
	            }, paramsObj || {});
	            var cusFunction = params.against;
	            if ($.type(cusFunction) == 'string') {
	                cusFunction = window[cusFunction];
	            }
	            if(!cusFunction(value, params.args,params)) {
	            	validate.fail(params.m);
	            }
	            return true;
	        },
	
	
	        error: function(errorMessage){
	            this.message = errorMessage;
	            this.name = 'ValidationError';
	        },
	
	        fail: function(errorMessage){
	            throw new validate.error(errorMessage);
	        }
    	}
    	
        /**
         * 构造函数
         * @param d 被操作的集合数据
         * @constructor
         */
        function Validate() {
        }

        /**
    	 * 对单一规则进行验证
    	 * @param validationFunction 验证函数
    	 * @param validationParamsObj 参数
    	 * @param value 值
    	 */
        Validate.prototype.validateElement = function(validationFunction,validationParamsObj,value) {
    		var result = {validFlag:true,message:''};
    		try {
    			var f=eval('validate.'+validationFunction);
    			validate[validationFunction](value,validationParamsObj);
    		} catch (error) {
    			result.message = error.message;
    			result.validFlag = false;
    		}
    		return result;
    	}
        
        function isArray(arr){
            return Object.prototype.toString.call(arr) === "[object Array]";
        }
        
        /**
    	 * 校验对象/数组集合
    	 * @param obj 对象/数组集合
    	 * @param validateRule 校验规则
    	 * @param message 默认提示语
    	 */
        Validate.prototype.validateAllElement = function(obj, validateRule, message) {
        	var result = {validFlag:true,message:''};
        	message = message != null ? message : '';
        	//如果是数组
        	if(obj!=null && obj!=undefined && isArray(obj)){
        		for(var i=0;i<obj.length;i++){
        			var validateResult =this.validateAllElement(obj[i],validateRule);
        			result.validFlag=result.validFlag && validateResult.validFlag;
        			if(!validateResult.validFlag){
        				result.message += message.replace('{value}', i+1) + validateResult.message;
        			}
        		}
            }else if(obj!=null && obj!=undefined && typeof(obj) == "object"){
            	for(var name in obj) {
            		if(validateRule[name]!=null){
            			for(var i=0;i<validateRule[name].length;i++){
            				var type=validateRule[name][i].type;
                			var rule=validateRule[name][i].rule;
                			var validateResult = this.validateElement(type,rule,obj[name]);
                			result.validFlag=result.validFlag && validateResult.validFlag;
                			if(!validateResult.validFlag){
                				result.message+=message+validateResult.message+"<br/>";
                			}
            			}
            		}
                }
            }
        	return result;
    	}
        
        return Validate;
    })();
    cap.Validate = Validate;
})(cap || (cap = {}));

/**
 * 合成多个校验结果
 *
 * @param <code>resultArr</code>各类校验结果组成的集合,如：[{validFlag: false, message: "中文名称不能为空<br/>参数名称不能为空<br/>"},{validFlag: true, message: ""}]
 */
cap.finalValiResComposite = function(resultArr){
	var finalResult = {validFlag : true, message : ''};
	resultArr.forEach(function(item){
		if(!item.validFlag){
			finalResult.validFlag = false;
			finalResult.message += item.message;
		}
	});
	return finalResult;
}

/**
 * 根据页面参数生成URL字符串
 */
cap.buildPageAttrString=function(pageAttributeVOList){
	var result="";
	for(var i=0;i<pageAttributeVOList.length;i++){
		if(pageAttributeVOList[i].attributeName!=null && pageAttributeVOList[i].attributeName!=""){
			if(pageAttributeVOList[i].attributeValue!=null && pageAttributeVOList[i].attributeValue!=""){
				if(pageAttributeVOList[i].attributeValue.indexOf("@{")!=-1){
					var attributeValue=pageAttributeVOList[i].attributeValue;
					attributeValue=attributeValue.replace("@{","");
					attributeValue=attributeValue.replace("}","");
					result+="+'&"+pageAttributeVOList[i].attributeName+"='"+"+"+attributeValue;
				}else{
					result+="+'&"+pageAttributeVOList[i].attributeName+"="+pageAttributeVOList[i].attributeValue+"'";
				}
			}
		}
	}
	if(result !=""){
		result="+'?"+result.substring(3)
	}
	return result;
};

//判断输入的字符是否为整数    
cap.isInt = function(value){
	return /^[-+]?\d*$/.test(value);
};
//是否布尔类型
cap.isBoolean = function(value) {
	if(typeof value ==="string"){
		if (value === 'true' || value === 'false'){ 
		 return true; 
		} else { 
		 return false; 
		} 
	}else if(typeof value==="boolean"){
		return true;
	}else{
		return false;
	}
};
//判断输入的字符是否为双精度    
cap.isDouble = function(value) {
	return /^[-\+]?\d+(\.\d+)?$/.test(value);
};

cap.digestValue = function(scope){
	var phase = scope.$root.$$phase;
    if (phase != '$apply' && phase != '$digest') {
    	try {
    	scope.$digest();
    	}catch (error){
    		
    	}
    }
};

/**
 * 
 * 本函数实现数组删除元素的功能。
 * 
 * 说明：
 * 1.支持js原始类型数据的删除，e.g.: boolean\number(包括Infinity和-Infinity,但不包括NaN)\string\null\undefined
 * 2.支持js中typeof运算后为object的对象数据删除。但不支持使用原始数据类型的包装器类型new出的对象(e.g.: new Number(1)\new Boolean(false)\new String("hello"))以及空对象(e.g.: new Oject()\{})
 * 3.支持js中自定义的类对象删除，要求对象必须至少有一个属性来承担比较的key.注意：本函数只支持单key比较，key为对象元素for in出来的第一个属性，即target数组里面的对象元素for in出来的第一个属性为key，若有多个属性，除第一个属性外，其他属性将被忽略。
 * 4.不支持function类型元素的删除。
 * 5.不支持对多维数组元素的删除，只支持一纬数组。
 * <pre>
 * function Human(name,age){
 * 		this.name = name;
 * 		this.age = age;
 * }
 * 
 * var source = [1,2,3,1,4,3,5,true,"false",null,undefined,Infinity,new Human("z3",20),new Human("w5",22),{id:20,text:"some data"}];
 * var target = [0,1,3,5,"false","true",null,undefined,Infinity,new Human("z3",55),{name:"w5"},{id:20}];
 * 
 * var result = cap.array.remove(source,target,true);
 * 
 * result:[2,4,true]
 * </pre>
 * 
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2015-09-16
 * 
 * @param source 需要删除元素的数组 (必须) e.g.: [1,2,5,3,4,3,5] 
 * @param target 哪些元素需要删除组成的数组 (必须) e.g.: [3,5,6],3、5、6就是需要从source里面准备删除的元素
 * @param flag 是否从source里面一并删除重复的元素 true or false （可选） e.g.: source里面的重复项3、5在删除的时候是全部删掉还是只删除第一个。(号外：如果target里面也有两个3、5，则就算falg = false，也会把source里面的重复项3、5一起删除)
 * @return source经过删除后的结果（同一引用）。
 */
(function(cap){
	cap.array = {
		remove : function(source,target,flag) {
			//验证输入合法性
			if(arguments.length < 2){
				throw new Error("the remove method must have two parameters of the array type at least.");
			}
			if(Object.prototype.toString.call(arguments[0]) !== "[object Array]" || Object.prototype.toString.call(arguments[1]) !== "[object Array]"){
				throw new Error("the first two parameters for the remove method must all be the type of array.");
			}
			if(arguments.length >= 3 && typeof arguments[2] != "boolean"){
				throw new Error("the thirdly parameter for the remove method must be the type of boolean, e.g.: true or false.");
			}
			
			//定义是否匹配到了源数组的元素。
			var matched = false;
			
			//开始进行匹配
			for(var i = 0, len = target.length; i < len; i++){
				for(var k = 0, _len = source.length; k < _len; k++){
					//对象类型匹配,不支持new Boolean(true)\new String("123")\new Number(123)\new Object或{}空对象\function类型\NaN进行匹配。
					//不支持多维数组匹配。
					if(target[i] && typeof target[i] == "object"){ 
						if(source[k] && typeof source[k] == "object"){
							
							//深度遍历对象属性进行匹配
							var recursion = function(_target,_source){
								var key;
								for(var attr in _target){
									key =  attr;
									break;
								}
								if(key){
									if(typeof _target[key] == "object" && typeof _source[key] == "object"){
										return arguments.callee(_target[key],_source[key]); //递归深度遍历属性
									}else{
										if(_target[key] === _source[key]){
											return true;
										}
										return false;
									}
								}
								return false;
							}
							
							var result = recursion(target[i],source[k]);
							
							if(result){
								matched = true;
								source.splice(k,1);//删除
								break;
							}
						}
					}else{ //原始类型匹配
						if(target[i] === source[k]){
							matched = true;
							source.splice(k,1);//删除
							break;
						}
					}
				}
				if(matched && flag){ //开启源数组重复项全部删除
					--i;
					matched = false;
				}
			}
			
			return source;
		}	
	};
})(cap || (cap = {}));

/**
*
* 本函数实现对目标对象中的字符串属性进行trim操作。
*
* 目标对象：可以是基础类型的字符串，可以是String对象，也可以是数组或Object。
*
* 该函数支持是否对目标对象的属性（如对象中的Object、Array、String属性）深度遍历进行trim操作。但永远不会对原型链上的属性进行trim。
*
* 调用方式如下：
* <pre>
*
* var result = cap.trim(target);
* 或
* var result = cap.trim(target, true);
* 或
* var result = cap.trim(target, false);
*
* </pre>
*
* @author lingchen WWW.SZCOMTOP.COM
* @Date 2016-05-10
*
* @param target 目标对象
* @param true/false 是否对目标对象进行深入遍历trim(若不传此参数，则默认为深度遍历)
* @return target经过trim后的结果（同一引用）。
*/
(function(cap){
    cap.trim = function(){
        //trim函数必须至少要有一个参数
        if(arguments.length === 0){
            throw new Error("the trim function needs to have at least one parameter.");
        }
        //有第二个参数，就必须是boolean类型
        if(arguments.length >= 2 && typeof arguments[1] !== "boolean"){
            throw new Error("the second parameter of the trim function must be a boolean variable.");
        }
        
        //默认为深度遍历
        var flag = true;
        if(arguments.length >= 2){
            flag = arguments[1];
        }
        var target = arguments[0];
        //处理字符串类型
        if(typeof target === "string"){
            return target.replace(/^(\s|\u00A0)+/,'').replace(/(\s|\u00A0)+$/,'');
        }
        //处理对象类型
        if(Object.prototype.toString.call(target) === "[object Object]"){
            for(var attr in target){
                //原型链上的属性不处理
                if(Object.prototype.hasOwnProperty.call(target,attr) && !( /^jQuery\d+$/.test(attr))){
                    if(flag || typeof target[attr] === "string"){
                        target[attr] = arguments.callee(target[attr]);
                    }
                }
            }
        }
        //处理String对象
        if(Object.prototype.toString.call(target) === "[object String]"){
            target = new String(target.replace(/^(\s|\u00A0)+/,'').replace(/(\s|\u00A0)+$/,''));
        }
        //处理数组类型
        if(Object.prototype.toString.call(target) === "[object Array]"){
            for(var k = 0; k < target.length; k++){
                if(flag || typeof target[k] === "string"){
                    target[k] = arguments.callee(target[k]);
                }
            }
        }

        return target;
    };
})(cap || (cap = {}));

/**
 * cap.money.format实现对金额的格式化;
 * cap.money.parse实现对格式化的金额字符串转number类型。
 *
 * 格式化规则为从整数末尾计算，每三位后加个英文逗号分隔符，如12,735,920.64
 * 解析金额字符串规则为去英文逗号
 *
 * 格式化函数支持接收string类型和number类型的金额格式化，支持正负数，支持.52这种格式的参数。
 * 格式化校验规则，以下被认定为非法金额数：
 * 1、number类型的NaN|Infinity|-Infinity；
 * 2、string类型包含两个及以上的小数点；
 * 3、string类型不包含任何数字。
 *
 * e.g.:
 * <pre>
 *     var formatStr = cap.money.format("+123456.520"); // +123,456.520
 *     var formatStr = cap.money.format("+.520"); //+.520
 *     var formatStr = cap.money.format(+123456.520); // 123,456.52
 *     var formatStr = cap.money.format("123a456b.52d0"); // 123,456.520
 *
 *     var parseNum = cap.money.parse("123,456.520"); // 123456.52
 *     var parseNum = cap.money.parse("+12a3,4b56.5d20"); // 123456.52
 *     var parseNum = cap.money.parse("-123,456.5"); // -123456.5
 *     var parseNum = cap.money.parse("+123,456.5"); // 123456.5
 *     var parseNum = cap.money.parse("+.5"); // 0.5
 * </pre>
 *
 * 解析函数只支持接收string类型参数。
 * 解析校验规则，以下被认定为非法金额数：
 * 1、非string类型；
 * 2、string类型包含两个及以上的小数点；
 * 3、string类型不包含任何数字。
 *
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2016-05-26
 *
 * @param money 金额的字符串表现形式或number类型的数据
 *
 * @return 金额格式化后的字符串表现形式或解析后的金额的number类型数值
 */
(function(cap){
    cap.money = {
        format : function() {
            //must have on parameter at least
            if(arguments.length == 0){
                throw new Error("the format method must have one parameter at least.");
            }
            //parameter must be string or number
            if(Object.prototype.toString.call(arguments[0]) !== "[object String]" && Object.prototype.toString.call(arguments[0]) !== "[object Number]"){
                throw new Error("the parameter is illegal.");
            }
            //exclude NaN|Infinity|-Infinity
            if(arguments[0] !== arguments[0] || arguments[0] === Infinity || arguments[0] === -Infinity){
                throw new Error("the parameter is illegal.");
            }

            //validate and process
            var moneyStr = cap.money.innerFunction(arguments[0]);

            var _array = /([\d\-\+]*)[.]?(\d*)/g.exec(moneyStr);
            //process integer
            var integer = '';
            if(_array[1]){
                //string reverse
                var _revers = _array[1].split("").reverse().join("");
                for(var i = 1; i <= _revers.length; i++){
                    integer += _revers.charAt(i-1);
                    if(i % 3 === 0 && i !== _revers.length && /[^\-\+]/.test(_revers.charAt(i))){
                        integer += ",";
                    }
                }
            }
            //reverse ingeter
            if(integer){
                integer = integer.split("").reverse().join("");
            }
            //append decimals and return
            return integer + (_array[2] ? ("." + _array[2]) : "");
        },
        parse : function() {
            //must have on parameter at least
            if(arguments.length == 0){
                throw new Error("the parse method must have one parameter at least.");
            }

            //parameter must be string
            if(Object.prototype.toString.call(arguments[0]) !== "[object String]"){
                throw new Error("the parameter is illegal.");
            }

            //validate and process
            var moneyStr = cap.money.innerFunction(arguments[0]);
            //drop "," char
            moneyStr = moneyStr.replace(/[,]/g,"");

            return parseFloat(moneyStr);
        },
        innerFunction : function() {
            //case to string
            var moneyStr = arguments[0] + "";
            //exclude have two point
            var matcher = moneyStr.match(/\./g);
            if(matcher && matcher.length > 1){
                throw new Error("the parameter is illegal.");
            }

            //drop the illegal chars
            moneyStr = moneyStr.replace(/[^\d\.\-\+]/g, '');
            if(moneyStr === ''){
                throw new Error("the parameter is illegal.");
            }

            //drop extra '-' and '+' chars
            var moneyFirstChar = moneyStr.substring(0, 1);
            moneyStr = moneyFirstChar + moneyStr.substring(1).replace(/[\-\+]/g, '');

            //if the last char is point, drop it
            if(moneyStr.charAt(moneyStr.length-1) === "."){
                moneyStr = moneyStr.substring(0, moneyStr.length-1);
                if(moneyStr === ''){
                    throw new Error("the parameter is illegal.");
                }
            }
            return moneyStr;
        }
    };
})(cap || (cap={}));


/*

 SQLike version 1.021
 [JavaScript]/ActionScript 2/ActionScript 3-based SQL-like query engine
 copyright 2010 Thomas Frank

 This EULA grants you the following rights:

 Installation and Use. You may install and use an unlimited number of copies of the SOFTWARE PRODUCT.

 Reproduction and Distribution. You may reproduce and distribute an unlimited number of copies of the SOFTWARE PRODUCT either in whole or in part; each copy should include all copyright and trademark notices, and shall be accompanied by a copy of this EULA. Copies of the SOFTWARE PRODUCT may be distributed as a standalone product or included with your own product.

 Commercial Use. You may sell for profit and freely distribute scripts and/or compiled scripts that were created with the SOFTWARE PRODUCT.

 */
SQLike={q:function(B){var aQ,aP,aO,aM,aK,aJ,aI,aH,aG,aF,aE,aD,aC,aB,az,ay,ax,aw,av,au,at,ar,aq,ao,an,al,D,aA,M,ak,am,ab,ai,Y,L,P,aN,aa,ad,aL,X,Z,G,ah,T,E,S,R,ac,A,J,I,U,V,N,F,ag,af,ap,W,Q,ae,C,H,K,aj,O;if(arguments.length>1){aQ=arguments,aw=ac;for(aG=0;aG<aQ.length;aG++){aw=arguments.callee(aQ[aG])}return aw}az={};for(aG in B){az[aG.toUpperCase().split("_").join("")]=B[aG]}if(az.DELETE&&az.FROM){az.DELETEFROM=az.FROM}F=!!az.UNIONDISTINCT+!!az.UNION+!!az.UNIONALL+!!az.INTERSECTDISTINCT+!!az.INTERSECT+!!az.INTERSECTALL+!!az.MINUS+!!az.EXCEPTDISTINCT+!!az.EXCEPT+!!az.EXCEPTALL;if(F+!!az.SELECT+!!az.SELECTDISTINCT+!!az.INSERTINTO+!!az.UPDATE+!!az.DELETEFROM+!!az.UNPACK+!!az.PACK!=1){return[]}else{if(az.TESTSUB){return"issub"}}aM=(az.SELECT||az.SELECTDISTINCT)?az.FROM:az.INSERTINTO||az.UPDATE||az.DELETEFROM||az.PACK||az.UNPACK,A=aM;if(aM&&typeof aM=="object"&&!aM.push){J={TESTSUB:true};for(aG in aM){J[aG]=aM[aG]}if(arguments.callee(J)=="issub"){aM=arguments.callee(aM)}}if(az.LIMIT){ao=az.LIMIT;az.LIMIT=ac;return arguments.callee(az).slice(0,ao)}if(az.INTO&&az.INTO.push){U=az.INTO;az.INTO=ac;U.splice.apply(U,[U.length,0].concat(arguments.callee(az)));return U}if(az.INSERTINTO){aM.push(az.VALUES);return aM}if(F){aj={f:function(s,aU){var n=[],l,m,r=[],aR={},t={},y={},u,s,p,b={},g,c,aT=[],aS=s.UNIONDISTINCT||s.UNION||s.UNIONALL||s.INTERSECTDISTINCT||s.INTERSECT||s.INTERSECTALL||s.MINUS||s.EXCEPTDISTINCT||s.EXCEPT||s.EXCEPTALL,q=aS.length;for(var e in s){if(s[e]===aS){var v=e.toUpperCase();l=v.split("ALL").length>1;m=v.split("UNION").length>1?1:v.split("INTERSECT").length>1?2:3;if(v=="MINUS"){m=3;l=false}}}for(var w=0;w<aS.length;w++){r.push(aU(aS[w]))}for(w=0;w<q;w++){for(v in r[w][0]){if(!aR[v]){aR[v]=0}aR[v]++}}for(w in aR){if(aR[w]==q){t[w]=true}}for(w=0;w<q;w++){for(v=0;v<r[w].length;v++){s={},p=[];for(u in t){s[u]=r[w][v][u];p.push(r[w][v][u])}p=p.join("|||");n.push(s);if(!b[p]){b[p]=[]}b[p].push({indexNo:n.length-1,tableNo:"t"+w})}}if(m==1&&l){return n}for(w in b){g={},c=0;for(v=0;v<b[w].length;v++){g[b[w][v].tableNo]=true}for(v in g){c++}for(v=0;v<b[w].length;v++){if((m==2&&c!=q)||(m==3&&(c!=1||g.t1))||(!l&&v>0)){aT[b[w][v].indexNo]=true}}}for(w=n.length-1;w>=0;w--){if(aT[w]){n.splice(w,1)}}return n}};return aj.f(az,arguments.callee)}if(az.UNPACK){aO=az.COLUMNS;if(!aO){return false}for(aG=0;aG<aM.length;aG++){az={};for(aF=0;aF<aO.length;aF++){az[aO[aF]]=aM[aG][aF]}aM[aG]=az}return aM}if(az.PACK){if(!az.COLUMNS){az.COLUMNS=[];for(aG in aM[0]){az.COLUMNS.push(aG)}}aO=az.COLUMNS;for(aG=0;aG<aM.length;aG++){aQ=[];for(aF=0;aF<aO.length;aF++){aQ[aF]=aM[aG][aO[aF]]}aM[aG]=aQ}return aM}if(az.ORDERBY&&!az.ORDERBY.prep){az.ORDERBY.prep=true;ao=arguments.callee(az),M=[];if(az.GROUPBY){ao=[ao,ao]}for(aG=0;aG<ao[0].length;aG++){aQ={},Y=0;for(aF in ao[0][aG]){Y++;aQ[aF]=ao[0][aG][aF]}for(aF in ao[1][aG]){Y++;if(aQ[aF]===ac){aQ[aF]=ao[1][aG][aF]}}aQ.__sqLikeSelectedData=ao[0][aG];M.push(aQ)}ak={a:[],d:[]},aQ=az.ORDERBY||[],aJ;ao=ak;for(aG=0;aG<aQ.length;aG++){if(aQ[aG]=="|desc|"||aQ[aG]=="|asc|"){continue}ao.d.push(aQ[aG+1]=="|desc|"?-1:1);ao.a.push(aQ[aG])}M.sort(function(a,b){aQ=ak.a;aM=ak.d;aw=0;for(aG=0;aG<aQ.length;aG++){if(typeof a+typeof b!="objectobject"){return typeof a=="object"?-1:1}aC,aB;if(typeof aQ[aG]=="function"){aC=aQ[aG].apply(a);aB=aQ[aG].apply(b)}else{aC=a[aQ[aG]];aB=b[aQ[aG]]}if((aC===true||aC===false)&&(aB===true||aB===false)){aC*=-1;aB*=-1}aw=aC-aB;if(isNaN(aw)){aw=aC>aB?1:aC<aB?-1:0}if(aw!=0){return aw*aM[aG]}}return aw});aw=[];for(aG=0;aG<M.length;aG++){aw.push(M[aG].__sqLikeSelectedData)}return aw}if(az.HAVING){am=az.HAVING;az.HAVING=ac;ao=arguments.callee(az);aw=arguments.callee({SELECT:["*"],FROM:ao,WHERE:am});return aw}if(az.GROUPBY){au=[],ax={SELECTDISTINCT:az.GROUPBY,FROM:az.FROM,WHERE:az.WHERE};aI=arguments.callee(ax);for(aG=0;aG<aI.length;aG++){ax={};for(aF in az){ax[aF]=az[aF]}ax.GROUPBY=ax.ORDERBY=ac;V=az.WHERE||function(){return true};N=aI[aG];ax.WHERE=function(){var a=V.apply(this);for(var b in N){a=a&&this[b]==N[b]}return a};au.push(arguments.callee(ax)[0])}return au}az.JOIN=az.JOIN||az.INNERJOIN||az.NATURALJOIN||az.CROSSJOIN||az.LEFTOUTERJOIN||az.RIGHTOUTERJOIN||az.LEFTJOIN||az.RIGHTJOIN||az.FULLOUTERJOIN||az.OUTERJOIN||az.FULLJOIN;if(az.NATURALJOIN||az.USING){for(aF in az.JOIN){if(!aM[aF]){aM[aF]=az.JOIN[aF]}}aJ={},H=[],K=0;for(aG in aM){K++;for(aF in aM[aG][0]){if(!aJ[aF]){aJ[aF]=0}aJ[aF]++}}for(aG in aJ){if(aJ[aG]==K){H.push(aG)}}az.USING=az.USING||H,aP={};for(aG=0;aG<az.USING.length;aG++){aP[az.USING[aG]]=true}for(aG in aM){ao=aM[aG];aM[aG]=[];for(aE=0;aE<ao.length;aE++){J={},aH=[];for(aF in ao[aE]){J[aF]=ao[aE][aF]}for(aF=0;aF<az.USING.length;aF++){aH.push(ao[aE][az.USING[aF]])}J.__SQLikeHash__=aH.join("|");aM[aG][aE]=J}}az.ON=function(){var c=arguments.callee;if(c.LEN==2){return this[c.TABLELABEL[0]].__SQLikeHash__==this[c.TABLELABEL[1]].__SQLikeHash__?c.USINGOBJ:false}if(c.LEN==3){return this[c.TABLELABEL[0]].__SQLikeHash__==this[c.TABLELABEL[1]].__SQLikeHash__&&this[c.TABLELABEL[0]].__SQLikeHash__==this[c.TABLELABEL[2]].__SQLikeHash__?c.USINGOBJ:false}var b=this[c.TABLELABEL[0]].__SQLikeHash__;for(var d in this){if(this[d].__SQLikeHash__!=b){return false}}return c.USINGOBJ};az.ON.TABLELABEL=[];for(aG in aM){az.ON.TABLELABEL.push(aG)}az.ON.USINGOBJ=aP;az.ON.LEN=K;az.NATURALJOIN=az.USING=ac}if(az.CROSSJOIN){az.ON=function(){return true};az.CROSSJOIN=false}if(az.JOIN&&az.ON&&!aM.join&&!az.JOIN.join){for(aF in az.JOIN){if(!aM[aF]){aM[aF]=az.JOIN[aF]}}ab={},aE;for(aF in aM){if(az.FULLOUTERJOIN||az.FULLJOIN||az.OUTERJOIN){aE=true;ab[aF]=true}if((az.LEFTOUTERJOIN||az.LEFTJOIN)&&!az.JOIN[aF]){aE=true;ab[aF]=true}if((az.RIGHTOUTERJOIN||az.RIGHTJOIN)&&az.JOIN[aF]){aE=true;ab[aF]=true}}az.OUTERTABLES=aE?ab:false;aJ=az.WHERE||function(){return true};az.WHERE=az.ON;az.WHERE.org=aJ;az.JOIN=az.INNERJOIN=az.NATURALJOIN=az.CROSSJOIN=az.LEFTOUTERJOIN=az.RIGHTOUTERJOIN=az.LEFTJOIN=az.RIGHTJOIN=az.FULLOUTERJOIN=az.OUTERJOIN=az.FULLJOIN=az.ON=ac;return arguments.callee(az)}if(!aM.join){O={f:function(l,g,n){var j=[],i=[],b=[],k=[],h=[],f=0,c=[];for(aG in l){b.push(l[aG].length);h.push(aG);c.push([]);k.push(0);f++}while(k[f-1]<b[f-1]){var a={};for(aG=0;aG<f;aG++){a[h[aG]]=l[h[aG]][k[aG]]}ax=g.apply(a);if(ax){if(n){for(aG=0;aG<f;aG++){c[aG][k[aG]]=true}}B={};for(aG=0;aG<f;aG++){for(aF in a[h[aG]]){if(aF=="__SQLikeHash__"){continue}B[(typeof ax=="object"&&ax[aF]?"":h[aG]+"_")+aF]=a[h[aG]][aF]}}j.push(B);i.push(a)}for(aG=0;aG<f;aG++){k[aG]++;if(k[aG]<b[aG]){break}if(aG<f-1){k[aG]=0}}}if(n){for(aG=0;aG<f;aG++){if(!n[h[aG]]){continue}for(aF=0;aF<b[aG];aF++){if(!c[aG][aF]){a=l[h[aG]][aF],J={},I={};for(aE=0;aE<f;aE++){I[h[aE]]={}}for(aE in a){I[h[aG]][aE]=a[aE];J[h[aG]+"_"+aE]=a[aE]}j.push(J);i.push(I)}}}}if(g.org){for(aG=j.length-1;aG>=0;aG--){if(!g.org.apply(i[aG])){j.splice(aG,1)}}}return j}};aM=O.f(aM,az.WHERE,az.OUTERTABLES)}else{aA=[],aN=[];for(aG=0;aG<aM.length;aG++){if(!az.WHERE||az.WHERE.apply(aM[aG])){aA.push(aM[aG]);aN.push(aG)}}aM=aA}if(az.DELETEFROM){for(aG=aN.length-1;aG>=0;aG--){A.splice(aN[aG],1)}return A}if(az.UPDATE&&az.SET){for(aG=0;aG<=aN.length;aG++){az.SET.apply(A[aN[aG]])}return A}aa=!!az.SELECTDISTINCT;az.SELECT=az.SELECT||az.SELECTDISTINCT;if(az.SELECT&&az.SELECT.length>0){aA=[],ad={},aL={},X=0,av=az.SELECT;if(av[0]=="|count|"&&av[1]=="*"){return[{count:aM.length}]}for(aG=0;aG<av.length;aG++){if(av[aG]=="*"){aH={},au=[];for(aE=0;aE<aM.length;aE++){for(aF in aM[aE]){if(!aH[aF]){au.push(aF);aH[aF]=true}}}av.splice(aG,1);for(aF=au.length-1;aF>=0;aF--){av.splice(aG,0,au[aF])}break}}for(aG=0;aG<aM.length;aG++){Z,B={},G;for(aF=0;aF<av.length;aF++){ah=av[aF],T=ah,E=aM[aG][T];if(typeof av[aF]=="string"&&av[aF].toLowerCase()=="|as|"){aF+=1;continue}if(typeof av[aF]=="string"&&av[aF].charAt(0)=="|"&&av[aF].charAt(av[aF].length-1)=="|"){continue}if(typeof ah=="function"){E=ah.apply(aM[aG]);Y=1;ah="udf_1";while(B[ah]){Y++;ah="udf_"+Y}}if(typeof av[aF+1]=="string"&&typeof av[aF+2]=="string"&&av[aF+1].toLowerCase()=="|as|"){ah=av[aF+2]}if(typeof av[aF-1]=="string"&&av[aF-1].charAt(0)=="|"&&av[aF-1].charAt(av[aF-1].length-1)=="|"){S=av[aF-1].split("|")[1];ah=S+"_"+ah;aL[ah]={type:S,count:0,sum:0,avg:0}}if(az.JHELP&&!az.JHELP[ah]){ah=az.JTNAME+ah}Z=ah;B[ah]=E;if(aG==0){X++}}if(aa){ao=[];for(aE in B){ao.push(B[aE])}G=ao.join("|||")}if(!aa||!ad[G]){aA.push(B)}if(aa){ad[G]=true}}R=0;for(aG in aL){R++;an=aL[aG];for(aF=0;aF<aA.length;aF++){ao=aA[aF][aG];if(ao!==ac){an.count++;if(an.min===ac){an.min=ao}if(an.max===ac){an.max=ao}if(an.min>ao){an.min=ao}if(an.max<ao){an.max=ao}if(ao/1==ao){an.sum+=ao}}}an.avg=an.sum/an.count;aA[0][aG]=aL[aG][aL[aG].type]}if(R>0){aA=[aA[0]];aM=[aA[0]]}if(az.ORDERBY&&az.ORDERBY.prep){return[aA,aM]}return aA}return[]}};

/*!
 * Object.observe polyfill - v0.2.4
 * by Massimo Artizzu (MaxArt2501)
 *
 * https://github.com/MaxArt2501/object-observe
 *
 * Licensed under the MIT License
 * See LICENSE for details
 */

// Some type definitions
/**
 * This represents the data relative to an observed object
 * @typedef  {Object}                     ObjectData
 * @property {Map<Handler, HandlerData>}  handlers
 * @property {String[]}                   properties
 * @property {*[]}                        values
 * @property {Descriptor[]}               descriptors
 * @property {Notifier}                   notifier
 * @property {Boolean}                    frozen
 * @property {Boolean}                    extensible
 * @property {Object}                     proto
 */
/**
 * Function definition of a handler
 * @callback Handler
 * @param {ChangeRecord[]}                changes
*/
/**
 * This represents the data relative to an observed object and one of its
 * handlers
 * @typedef  {Object}                     HandlerData
 * @property {Map<Object, ObservedData>}  observed
 * @property {ChangeRecord[]}             changeRecords
 */
/**
 * @typedef  {Object}                     ObservedData
 * @property {String[]}                   acceptList
 * @property {ObjectData}                 data
*/
/**
 * Type definition for a change. Any other property can be added using
 * the notify() or performChange() methods of the notifier.
 * @typedef  {Object}                     ChangeRecord
 * @property {String}                     type
 * @property {Object}                     object
 * @property {String}                     [name]
 * @property {*}                          [oldValue]
 * @property {Number}                     [index]
 */
/**
 * Type definition for a notifier (what Object.getNotifier returns)
 * @typedef  {Object}                     Notifier
 * @property {Function}                   notify
 * @property {Function}                   performChange
 */
/**
 * Function called with Notifier.performChange. It may optionally return a
 * ChangeRecord that gets automatically notified, but `type` and `object`
 * properties are overridden.
 * @callback Performer
 * @returns {ChangeRecord|undefined}
 */

Object.observe || (function(O, A, root, _undefined) {
    "use strict";

        /**
         * Relates observed objects and their data
         * @type {Map<Object, ObjectData}
         */
    var observed,
        /**
         * List of handlers and their data
         * @type {Map<Handler, Map<Object, HandlerData>>}
         */
        handlers,

        defaultAcceptList = [ "add", "update", "delete", "reconfigure", "setPrototype", "preventExtensions" ];

    // Functions for internal usage

        /**
         * Checks if the argument is an Array object. Polyfills Array.isArray.
         * @function isArray
         * @param {?*} object
         * @returns {Boolean}
         */
    var isArray = A.isArray || (function(toString) {
            return function (object) { return toString.call(object) === "[object Array]"; };
        })(O.prototype.toString),

        /**
         * Returns the index of an item in a collection, or -1 if not found.
         * Uses the generic Array.indexOf or Array.prototype.indexOf if available.
         * @function inArray
         * @param {Array} array
         * @param {*} pivot           Item to look for
         * @param {Number} [start=0]  Index to start from
         * @returns {Number}
         */
        inArray = A.prototype.indexOf ? A.indexOf || function(array, pivot, start) {
            return A.prototype.indexOf.call(array, pivot, start);
        } : function(array, pivot, start) {
            for (var i = start || 0; i < array.length; i++)
                if (array[i] === pivot)
                    return i;
            return -1;
        },

        /**
         * Returns an instance of Map, or a Map-like object is Map is not
         * supported or doesn't support forEach()
         * @function createMap
         * @returns {Map}
         */
        createMap = root.Map === _undefined || !Map.prototype.forEach ? function() {
            // Lightweight shim of Map. Lacks clear(), entries(), keys() and
            // values() (the last 3 not supported by IE11, so can't use them),
            // it doesn't handle the constructor's argument (like IE11) and of
            // course it doesn't support for...of.
            // Chrome 31-35 and Firefox 13-24 have a basic support of Map, but
            // they lack forEach(), so their native implementation is bad for
            // this polyfill. (Chrome 36+ supports Object.observe.)
            var keys = [], values = [];

            return {
                size: 0,
                has: function(key) { return inArray(keys, key) > -1; },
                get: function(key) { return values[inArray(keys, key)]; },
                set: function(key, value) {
                    var i = inArray(keys, key);
                    if (i === -1) {
                        keys.push(key);
                        values.push(value);
                        this.size++;
                    } else values[i] = value;
                },
                "delete": function(key) {
                    var i = inArray(keys, key);
                    if (i > -1) {
                        keys.splice(i, 1);
                        values.splice(i, 1);
                        this.size--;
                    }
                },
                forEach: function(callback/*, thisObj*/) {
                    for (var i = 0; i < keys.length; i++)
                        callback.call(arguments[1], values[i], keys[i], this);
                }
            };
        } : function() { return new Map(); },

        /**
         * Simple shim for Object.getOwnPropertyNames when is not available
         * Misses checks on object, don't use as a replacement of Object.keys/getOwnPropertyNames
         * @function getProps
         * @param {Object} object
         * @returns {String[]}
         */
        getProps = O.getOwnPropertyNames ? (function() {
            var func = O.getOwnPropertyNames;
            try {
                arguments.callee;
            } catch (e) {
                // Strict mode is supported

                // In strict mode, we can't access to "arguments", "caller" and
                // "callee" properties of functions. Object.getOwnPropertyNames
                // returns [ "prototype", "length", "name" ] in Firefox; it returns
                // "caller" and "arguments" too in Chrome and in Internet
                // Explorer, so those values must be filtered.
                var avoid = (func(inArray).join(" ") + " ").replace(/prototype |length |name /g, "").slice(0, -1).split(" ");
                if (avoid.length) func = function(object) {
                    var props = O.getOwnPropertyNames(object);
                    if (typeof object === "function")
                        for (var i = 0, j; i < avoid.length;)
                            if ((j = inArray(props, avoid[i++])) > -1)
                                props.splice(j, 1);

                    return props;
                };
            }
            return func;
        })() : function(object) {
            // Poor-mouth version with for...in (IE8-)
            var props = [], prop, hop;
            if ("hasOwnProperty" in object) {
                for (prop in object)
                    if (object.hasOwnProperty(prop))
                        props.push(prop);
            } else {
                hop = O.hasOwnProperty;
                for (prop in object)
                    if (hop.call(object, prop))
                        props.push(prop);
            }

            // Inserting a common non-enumerable property of arrays
            if (isArray(object))
                props.push("length");

            return props;
        },

        /**
         * Return the prototype of the object... if defined.
         * @function getPrototype
         * @param {Object} object
         * @returns {Object}
         */
        getPrototype = O.getPrototypeOf,

        /**
         * Return the descriptor of the object... if defined.
         * IE8 supports a (useless) Object.getOwnPropertyDescriptor for DOM
         * nodes only, so defineProperties is checked instead.
         * @function getDescriptor
         * @param {Object} object
         * @param {String} property
         * @returns {Descriptor}
         */
        getDescriptor = O.defineProperties && O.getOwnPropertyDescriptor,

        /**
         * Sets up the next check and delivering iteration, using
         * requestAnimationFrame or a (close) polyfill.
         * @function nextFrame
         * @param {function} func
         * @returns {number}
         */
        nextFrame = root.requestAnimationFrame || root.webkitRequestAnimationFrame || (function() {
            var initial = +new Date,
                last = initial;
            return function(func) {
                return setTimeout(function() {
                    func((last = +new Date) - initial);
                }, 17);
            };
        })(),

        /**
         * Sets up the observation of an object
         * @function doObserve
         * @param {Object} object
         * @param {Handler} handler
         * @param {String[]} [acceptList]
         */
        doObserve = function(object, handler, acceptList) {
            var data = observed.get(object);

            if (data) {
                performPropertyChecks(data, object);
                setHandler(object, data, handler, acceptList);
            } else {
                data = createObjectData(object);
                setHandler(object, data, handler, acceptList);

                if (observed.size === 1)
                    // Let the observation begin!
                    nextFrame(runGlobalLoop);
            }
        },

        /**
         * Creates the initial data for an observed object
         * @function createObjectData
         * @param {Object} object
         */
        createObjectData = function(object, data) {
            var props = getProps(object),
                values = [], descs, i = 0,
                data = {
                    handlers: createMap(),
                    frozen: O.isFrozen ? O.isFrozen(object) : false,
                    extensible: O.isExtensible ? O.isExtensible(object) : true,
                    proto: getPrototype && getPrototype(object),
                    properties: props,
                    values: values,
                    notifier: retrieveNotifier(object, data)
                };

            if (getDescriptor) {
                descs = data.descriptors = [];
                while (i < props.length) {
                    descs[i] = getDescriptor(object, props[i]);
                    values[i] = object[props[i++]];
                }
            } else while (i < props.length)
                values[i] = object[props[i++]];

            observed.set(object, data);

            return data;
        },

        /**
         * Performs basic property value change checks on an observed object
         * @function performPropertyChecks
         * @param {ObjectData} data
         * @param {Object} object
         * @param {String} [except]  Doesn't deliver the changes to the
         *                           handlers that accept this type
         */
        performPropertyChecks = (function() {
            var updateCheck = getDescriptor ? function(object, data, idx, except, descr) {
                var key = data.properties[idx],
                    value = object[key],
                    ovalue = data.values[idx],
                    odesc = data.descriptors[idx];

                if ("value" in descr && (ovalue === value
                        ? ovalue === 0 && 1/ovalue !== 1/value
                        : ovalue === ovalue || value === value)) {
                    addChangeRecord(object, data, {
                        name: key,
                        type: "update",
                        object: object,
                        oldValue: ovalue
                    }, except);
                    data.values[idx] = value;
                }
                if (odesc.configurable && (!descr.configurable
                        || descr.writable !== odesc.writable
                        || descr.enumerable !== odesc.enumerable
                        || descr.get !== odesc.get
                        || descr.set !== odesc.set)) {
                    addChangeRecord(object, data, {
                        name: key,
                        type: "reconfigure",
                        object: object,
                        oldValue: ovalue
                    }, except);
                    data.descriptors[idx] = descr;
                }
            } : function(object, data, idx, except) {
                var key = data.properties[idx],
                    value = object[key],
                    ovalue = data.values[idx];

                if (ovalue === value ? ovalue === 0 && 1/ovalue !== 1/value
                        : ovalue === ovalue || value === value) {
                    addChangeRecord(object, data, {
                        name: key,
                        type: "update",
                        object: object,
                        oldValue: ovalue
                    }, except);
                    data.values[idx] = value;
                }
            };

            // Checks if some property has been deleted
            var deletionCheck = getDescriptor ? function(object, props, proplen, data, except) {
                var i = props.length, descr;
                while (proplen && i--) {
                    if (props[i] !== null) {
                        descr = getDescriptor(object, props[i]);
                        proplen--;

                        // If there's no descriptor, the property has really
                        // been deleted; otherwise, it's been reconfigured so
                        // that's not enumerable anymore
                        if (descr) updateCheck(object, data, i, except, descr);
                        else {
                            addChangeRecord(object, data, {
                                name: props[i],
                                type: "delete",
                                object: object,
                                oldValue: data.values[i]
                            }, except);
                            data.properties.splice(i, 1);
                            data.values.splice(i, 1);
                            data.descriptors.splice(i, 1);
                        }
                    }
                }
            } : function(object, props, proplen, data, except) {
                var i = props.length;
                while (proplen && i--)
                    if (props[i] !== null) {
                        addChangeRecord(object, data, {
                            name: props[i],
                            type: "delete",
                            object: object,
                            oldValue: data.values[i]
                        }, except);
                        data.properties.splice(i, 1);
                        data.values.splice(i, 1);
                        proplen--;
                    }
            };

            return function(data, object, except) {
                if (!data.handlers.size || data.frozen) return;

                var props, proplen, keys,
                    values = data.values,
                    descs = data.descriptors,
                    i = 0, idx,
                    key, value,
                    proto, descr;

                // If the object isn't extensible, we don't need to check for new
                // or deleted properties
                if (data.extensible) {

                    props = data.properties.slice();
                    proplen = props.length;
                    keys = getProps(object);

                    if (descs) {
                        while (i < keys.length) {
                            key = keys[i++];
                            idx = inArray(props, key);
                            descr = getDescriptor(object, key);

                            if (idx === -1) {
                                addChangeRecord(object, data, {
                                    name: key,
                                    type: "add",
                                    object: object
                                }, except);
                                data.properties.push(key);
                                values.push(object[key]);
                                descs.push(descr);
                            } else {
                                props[idx] = null;
                                proplen--;
                                updateCheck(object, data, idx, except, descr);
                            }
                        }
                        deletionCheck(object, props, proplen, data, except);

                        if (!O.isExtensible(object)) {
                            data.extensible = false;
                            addChangeRecord(object, data, {
                                type: "preventExtensions",
                                object: object
                            }, except);

                            data.frozen = O.isFrozen(object);
                        }
                    } else {
                        while (i < keys.length) {
                            key = keys[i++];
                            idx = inArray(props, key);
                            value = object[key];

                            if (idx === -1) {
                                addChangeRecord(object, data, {
                                    name: key,
                                    type: "add",
                                    object: object
                                }, except);
                                data.properties.push(key);
                                values.push(value);
                            } else {
                                props[idx] = null;
                                proplen--;
                                updateCheck(object, data, idx, except);
                            }
                        }
                        deletionCheck(object, props, proplen, data, except);
                    }

                } else if (!data.frozen) {

                    // If the object is not extensible, but not frozen, we just have
                    // to check for value changes
                    for (; i < props.length; i++) {
                        key = props[i];
                        updateCheck(object, data, i, except, getDescriptor(object, key));
                    }

                    if (O.isFrozen(object))
                        data.frozen = true;
                }

                if (getPrototype) {
                    proto = getPrototype(object);
                    if (proto !== data.proto) {
                        addChangeRecord(object, data, {
                            type: "setPrototype",
                            name: "__proto__",
                            object: object,
                            oldValue: data.proto
                        });
                        data.proto = proto;
                    }
                }
            };
        })(),

        /**
         * Sets up the main loop for object observation and change notification
         * It stops if no object is observed.
         * @function runGlobalLoop
         */
        runGlobalLoop = function() {
            if (observed.size) {
                observed.forEach(performPropertyChecks);
                handlers.forEach(deliverHandlerRecords);
                nextFrame(runGlobalLoop);
            }
        },

        /**
         * Deliver the change records relative to a certain handler, and resets
         * the record list.
         * @param {HandlerData} hdata
         * @param {Handler} handler
         */
        deliverHandlerRecords = function(hdata, handler) {
            var records = hdata.changeRecords;
            if (records.length) {
                hdata.changeRecords = [];
                handler(records);
            }
        },

        /**
         * Returns the notifier for an object - whether it's observed or not
         * @function retrieveNotifier
         * @param {Object} object
         * @param {ObjectData} [data]
         * @returns {Notifier}
         */
        retrieveNotifier = function(object, data) {
            if (arguments.length < 2)
                data = observed.get(object);

            /** @type {Notifier} */
            return data && data.notifier || {
                /**
                 * @method notify
                 * @see http://arv.github.io/ecmascript-object-observe/#notifierprototype._notify
                 * @memberof Notifier
                 * @param {ChangeRecord} changeRecord
                 */
                notify: function(changeRecord) {
                    changeRecord.type; // Just to check the property is there...

                    // If there's no data, the object has been unobserved
                    var data = observed.get(object);
                    if (data) {
                        var recordCopy = { object: object }, prop;
                        for (prop in changeRecord)
                            if (prop !== "object")
                                recordCopy[prop] = changeRecord[prop];
                        addChangeRecord(object, data, recordCopy);
                    }
                },

                /**
                 * @method performChange
                 * @see http://arv.github.io/ecmascript-object-observe/#notifierprototype_.performchange
                 * @memberof Notifier
                 * @param {String} changeType
                 * @param {Performer} func     The task performer
                 * @param {*} [thisObj]        Used to set `this` when calling func
                 */
                performChange: function(changeType, func/*, thisObj*/) {
                    if (typeof changeType !== "string")
                        throw new TypeError("Invalid non-string changeType");

                    if (typeof func !== "function")
                        throw new TypeError("Cannot perform non-function");

                    // If there's no data, the object has been unobserved
                    var data = observed.get(object),
                        prop, changeRecord,
                        thisObj = arguments[2],
                        result = thisObj === _undefined ? func() : func.call(thisObj);

                    data && performPropertyChecks(data, object, changeType);

                    // If there's no data, the object has been unobserved
                    if (data && result && typeof result === "object") {
                        changeRecord = { object: object, type: changeType };
                        for (prop in result)
                            if (prop !== "object" && prop !== "type")
                                changeRecord[prop] = result[prop];
                        addChangeRecord(object, data, changeRecord);
                    }
                }
            };
        },

        /**
         * Register (or redefines) an handler in the collection for a given
         * object and a given type accept list.
         * @function setHandler
         * @param {Object} object
         * @param {ObjectData} data
         * @param {Handler} handler
         * @param {String[]} acceptList
         */
        setHandler = function(object, data, handler, acceptList) {
            var hdata = handlers.get(handler);
            if (!hdata)
                handlers.set(handler, hdata = {
                    observed: createMap(),
                    changeRecords: []
                });
            hdata.observed.set(object, {
                acceptList: acceptList.slice(),
                data: data
            });
            data.handlers.set(handler, hdata);
        },

        /**
         * Adds a change record in a given ObjectData
         * @function addChangeRecord
         * @param {Object} object
         * @param {ObjectData} data
         * @param {ChangeRecord} changeRecord
         * @param {String} [except]
         */
        addChangeRecord = function(object, data, changeRecord, except) {
            data.handlers.forEach(function(hdata) {
                var acceptList = hdata.observed.get(object).acceptList;
                // If except is defined, Notifier.performChange has been
                // called, with except as the type.
                // All the handlers that accepts that type are skipped.
                if ((typeof except !== "string"
                        || inArray(acceptList, except) === -1)
                        && inArray(acceptList, changeRecord.type) > -1)
                    hdata.changeRecords.push(changeRecord);
            });
        };

    observed = createMap();
    handlers = createMap();

    /**
     * @function Object.observe
     * @see http://arv.github.io/ecmascript-object-observe/#Object.observe
     * @param {Object} object
     * @param {Handler} handler
     * @param {String[]} [acceptList]
     * @throws {TypeError}
     * @returns {Object}               The observed object
     */
    O.observe = function observe(object, handler, acceptList) {
        if (!object || typeof object !== "object" && typeof object !== "function")
            throw new TypeError("Object.observe cannot observe non-object");

        if (typeof handler !== "function")
            throw new TypeError("Object.observe cannot deliver to non-function");

        if (O.isFrozen && O.isFrozen(handler))
            throw new TypeError("Object.observe cannot deliver to a frozen function object");

        if (acceptList === _undefined)
            acceptList = defaultAcceptList;
        else if (!acceptList || typeof acceptList !== "object")
            throw new TypeError("Third argument to Object.observe must be an array of strings.");

        doObserve(object, handler, acceptList);

        return object;
    };

    /**
     * @function Object.unobserve
     * @see http://arv.github.io/ecmascript-object-observe/#Object.unobserve
     * @param {Object} object
     * @param {Handler} handler
     * @throws {TypeError}
     * @returns {Object}         The given object
     */
    O.unobserve = function unobserve(object, handler) {
        if (object === null || typeof object !== "object" && typeof object !== "function")
            throw new TypeError("Object.unobserve cannot unobserve non-object");

        if (typeof handler !== "function")
            throw new TypeError("Object.unobserve cannot deliver to non-function");

        var hdata = handlers.get(handler), odata;

        if (hdata && (odata = hdata.observed.get(object))) {
            hdata.observed.forEach(function(odata, object) {
                performPropertyChecks(odata.data, object);
            });
            nextFrame(function() {
                deliverHandlerRecords(hdata, handler);
            });

            // In Firefox 13-18, size is a function, but createMap should fall
            // back to the shim for those versions
            if (hdata.observed.size === 1 && hdata.observed.has(object))
                handlers["delete"](handler);
            else hdata.observed["delete"](object);

            if (odata.data.handlers.size === 1)
                observed["delete"](object);
            else odata.data.handlers["delete"](handler);
        }

        return object;
    };

    /**
     * @function Object.getNotifier
     * @see http://arv.github.io/ecmascript-object-observe/#GetNotifier
     * @param {Object} object
     * @throws {TypeError}
     * @returns {Notifier}
     */
    O.getNotifier = function getNotifier(object) {
        if (object === null || typeof object !== "object" && typeof object !== "function")
            throw new TypeError("Object.getNotifier cannot getNotifier non-object");

        if (O.isFrozen && O.isFrozen(object)) return null;

        return retrieveNotifier(object);
    };

    /**
     * @function Object.deliverChangeRecords
     * @see http://arv.github.io/ecmascript-object-observe/#Object.deliverChangeRecords
     * @see http://arv.github.io/ecmascript-object-observe/#DeliverChangeRecords
     * @param {Handler} handler
     * @throws {TypeError}
     */
    O.deliverChangeRecords = function deliverChangeRecords(handler) {
        if (typeof handler !== "function")
            throw new TypeError("Object.deliverChangeRecords cannot deliver to non-function");

        var hdata = handlers.get(handler);
        if (hdata) {
            hdata.observed.forEach(function(odata, object) {
                performPropertyChecks(odata.data, object);
            });
            deliverHandlerRecords(hdata, handler);
        }
    };

})(Object, Array, this);
