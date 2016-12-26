//打开选择界面
function openDataStoreSelect(event, self) {
	var url = 'SelectUrl.jsp?reqFunctionSubitemId=' + reqFunctionSubitemId + '&propertyName=' + self.options.name + '&callbackMethod=selectUrlCallback&value=' + self.$input[0].value;
	var top=(window.screen.availHeight-600)/2;
	var left=(window.screen.availWidth-800)/2;
	window.open(url,'selectUrl','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
}

/**
 * 选择界面回调函数
 * @param propertyName 属性名称
 * @param propertyValue 属性值
 */
function selectUrlCallback(propertyName, data){
	var url = '';
	if(data && data.url != ''){
		url = '"' + cap.getRelativeURL(data.url, modelPackage) + '"';
	}
	cui("#"+propertyName).setValue(url);
}

//打开Borderlayout属性编辑器
function openBorderlayoutEditor() {
	var items = scope.data.items ? scope.data.items : '[]';
	var fixed = scope.data.fixed ? scope.data.fixed : '{}';
	var url = 'BorderlayoutEditor.jsp?namespaces=' + namespaces + '&reqFunctionSubitemId=' + reqFunctionSubitemId + '&items='+items+'&fixed='+fixed;
	var top=(window.screen.availHeight-600)/2;
	var left=(window.screen.availWidth-800)/2;
	window.open (url,'borderlayoutEditor','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
}

/**
 * 跳转到grid配置表头界面
 * @param event
 * @param self
 */
function openCustomGridTheadWindow(event, self){
	var width=830; //窗口宽度
    var height=600; //窗口高度
    var top=(window.screen.availHeight-height)/2;
    var left=(window.screen.availWidth-width)/2;
    var propertyName=self.options.name;
    var gridType=scope.data.uitype;
    var url='CustomGridThead.jsp?namespaces=' + namespaces + '&reqFunctionSubitemId=' + reqFunctionSubitemId + '&propertyName='+propertyName+'&callbackMethod=openWindowCallback';
    window.open(url, "customGridThead", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
}

/**
 * 跳转到editableGrid配置表头界面
 * @param event
 * @param self
 */
function openCustomEditableGridTheadWindow(event, self){
	var width=830; //窗口宽度
    var height=600; //窗口高度
    var top=(window.screen.availHeight-height)/2;
    var left=(window.screen.availWidth-width)/2;
    var propertyName=self.options.name;
    var gridType=scope.data.uitype;
    var url='CustomEditableGridThead.jsp?namespaces=' + namespaces + '&reqFunctionSubitemId=' + reqFunctionSubitemId + '&propertyName='+propertyName+'&callbackMethod=openWindowCallback';
    window.open(url, "customEditableGridThead", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
}

/**
 * 跳转到entityType配置
 * @param event
 * @param self
 */
function openCustomEditGridEntityType(event, self){
	var width=800; //窗口宽度
    var height=600; //窗口高度
    var top=(window.screen.availHeight-height)/2;
    var left=(window.screen.availWidth-width)/2;
    var propertyName=self.options.name;
    var url='CustomEditableGridEntityType.jsp?namespaces=' + namespaces + '&reqFunctionSubitemId=' + reqFunctionSubitemId + '&propertyName='+propertyName+'&callbackMethod=openWindowCallback';
    window.open(url, "customEditGridEntityType", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
}

/**
 * 跳转tab设置界面(js/css/dom)
 * @param event 事件
 * @param self 组件本身对象
 */
function openTabEditWindow(event, self){
	var width=800; //窗口宽度
    var height=600; //窗口高度
    var top=(window.screen.availHeight-height)/2;
    var left=(window.screen.availWidth-width)/2;
    var propertyName=self.options.name;
    currSelectDataModelVal=self.$input[0].value;
    var url='TabComponent.jsp?reqFunctionSubitemId=' + reqFunctionSubitemId + '&propertyName='+propertyName+'&callbackMethod=openWindowCallback&valuetype='+self.options.valuetype+'&namespaces='+namespaces;
    window.open(url, "tabEdit", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
}