//初始化验证规则
function addValid() {
    var validate = window.validater;
    validate.add('configItemFullCode', 'custom', {
        against: isCodeContainSpecial,
        //m: '全编码只能为英文、数字、下划线或点号。'
        m: '\u5168\u7F16\u7801\u53EA\u80FD\u4E3A\u82F1\u6587\u3001\u6570\u5B57\u3001\u4E0B\u5212\u7EBF\u6216\u70B9\u53F7\u3002'
    });
    validate.add('configItemFullCode', 'custom', {
        against: checkUnique,
        //m: '全编码已存在。'
        m: '\u5168\u7F16\u7801\u5DF2\u5B58\u5728\u3002'
    });
    validate.add('configItemValue', 'required', {
    	//m: '数据值不能为空。'
        m: '\u6570\u636E\u503C\u4E0D\u80FD\u4E3A\u7A7A\u3002'
    });
    validate.add('configItemValue', 'custom', {
    	against:checkNum,
    	// m: "请输入数字。"
        m: "\u8BF7\u8F93\u5165\u6570\u5B57\u3002"
    });  
    validate.add('configItemValue', 'custom', {
    	against:checkFloat,
    	//m: "请输入浮点数。"
        m: "\u8BF7\u8F93\u5165\u6D6E\u70B9\u6570\u3002"
    });  
}
//取消验证
function disValidFormValidater(id, flag) {
    if (window.validater) { 
        window.validater.disValid(id, flag); 
    }
}
//显示字段域
function showFormFiled(dataType,action) { 
    var showItem = function (item) { 
        var items = ["configItemValue", "calender", "booleanConfigValue", "userTable"];
        for (var i = 0, len = items.length; i < len; i++) {
            if (items[i] == item) {
	            if(items[i] == 'userTable'){
	            	$("#showValue").hide();
	            	if('edit' == action){
	            		jointNotTable();         
	            	}
		        }else{
		        	$("#showValue").show();                 
			    }
                $("#" + items[i]).show();                 
                disValidFormValidater(items[i], false);
                continue;
            }
            $("#" + items[i]).hide();             
            disValidFormValidater(items[i], true);
        }
    }
   var type="";
    switch (dataType) {
	    case "3":
	    	type="calender";
	        break;
	    case "4":
	        type="booleanConfigValue";
	        break;
	    case "5":
	        type="userTable";	        
	        break;
	    default:
	        type="configItemValue";
    }
    showItem(type);  
    cui(data).databind().setValue({"configItemType":dataType});
}
/**
 * function:检测编码是否唯一
 */
function checkUnique() {
    var flag = true;
    var value = cui("#configItemFullCode").getValue();
    if (value != "") {
        var classifyVO = {configItemFullCode: value,configItemId:configItemId};
        dwr.TOPEngine.setAsync(false);
        ConfigItemAction.configItemCodeUnique(classifyVO, function(result) {
            if (result) {
                flag = false;
            }
        });
        dwr.TOPEngine.setAsync(true);
    }
    return flag;
}
//判空
function isEmpty(str) {
    if ($.trim(str) == '') {
        return false;
    }
    return true;
}
//检查是否为数字
function checkNum(){
  var value=cui("#configItemValue").getValue(),
  	  type=cui("#configItemType").getValue();
	  var reg;
  if(type=="1"){
	 reg=/^-?[0-9]\d*$/;
	 return reg.test(value);	  
   }else{
     return true;
  }
}
//检查是否为浮点数
function checkFloat(){
	var value=cui("#configItemValue").getValue(),
	  type=cui("#configItemType").getValue();
	var reg1=/^-?([0-9]\d*|0(?!\.0+$))\.\d+?$/;
	var reg2=/^-?[0-9]\d*$/;
	if(type=="2"){
	   return reg1.test(value) || reg2.test(value);
	}else{
	   return true;
	}
}
/*
 * 判断编码是否包含特殊字符
 */
function isCodeContainSpecial() {
    var name = cui("#configItemFullCode").getValue();
    if (name == "")
        return true;
    var reg = new RegExp("^[A-Za-z0-9_.]+$");
    return (reg.test(name));
} 
//编码特殊字符验证
function isAttrCodeContainSpecialChar() {
    var name = cui("#attrCode").getValue();
    if (name == "")
        return true;
    var reg = new RegExp("^[\u4e00-\u9fa5a-zA-Z0-9_]+$");
    return (reg.test(name));
} 