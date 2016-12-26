/**
 * 根据id获取对应控件值
 * @param id id值
 */
function getValue(id){
	return cui("#"+id).getValue();
}

/**
 * 跳转到编写代码文本域界面(js/css/dom)
 * @param event 事件
 * @param self 组件本身对象
 */
function openCodeEditAreaWindow(event, self){
	var width=800; //窗口宽度
    var height=600; //窗口高度
    var top=(window.screen.availHeight-height)/2;
    var left=(window.screen.availWidth-width)/2;
    var propertyName=self.options.name;
    var url=webPath+'/cap/bm/dev/page/uilibrary/CustomDataModel.jsp?propertyName='+propertyName+'&callbackMethod=openWindowCallback&packageId='+ packageId+"&modelId="+pageId+'&type='+type;
    window.open(url, "codeEditArea", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
}

/**
 * 跳转到校验组件界面(js/css/dom)
 * @param event 事件
 * @param self 组件本身对象
 */
function openValidateAreaWindow(event, self){
	var width=850; //窗口宽度
    var height=700; //窗口高度
    var top=(window.screen.availHeight-height)/2;
    var left=(window.screen.availWidth-width)/2;
    var propertyName=self.options.name;
    currSelectDataModelVal=self.$input[0].value;
    var url=webPath+'/cap/bm/dev/page/uilibrary/ValidateComponent.jsp?propertyName='+propertyName+'&callbackMethod=openWindowCallback&valuetype='+self.options.valuetype;
    window.open(url, "validateArea", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
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
    var url=webPath+'/cap/bm/dev/page/uilibrary/TabComponent.jsp?propertyName='+propertyName+'&callbackMethod=openWindowCallback&valuetype='+self.options.valuetype+'&packageId='+ packageId+"&modelId="+pageId;
    window.open(url, "tabEdit", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
}

/**
 * 打开input组件的mask属性编辑窗口(js/css/dom)
 * @param event 事件
 * @param self 组件本身对象
 */
function openSelectInputMaskWindow(event, self){
	var width=450; //窗口宽度
    var height=300; //窗口高度
    var top=(window.screen.availHeight-height)/2;
    var left=(window.screen.availWidth-width)/2;
    var propertyName=self.options.name;
    var maskValue = cui("#mask").getValue();
    var maskOptValue = escape(cui("#maskoptions").getValue());
    var url=webPath+'/cap/bm/dev/page/uilibrary/SelectInputMask.jsp?mask='+maskValue+'&callbackMethod=openWindowCallback&valuetype='+self.options.valuetype+'&maskoptions='+maskOptValue;
    window.open(url, "selectInputMask", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
}

/**
 * 跳转到grid配置表头界面
 * @param event 事件
 * @param self 组件本身对象
 */
function openCustomGridTheadWindow(event, self){
	var width=830; //窗口宽度
    var height=600; //窗口高度
    var top=(window.screen.availHeight-height)/2;
    var left=(window.screen.availWidth-width)/2;
    var propertyName=self.options.name;
    var gridType=scope.data.uitype;
    var url=webPath+'/cap/bm/dev/page/uilibrary/CustomGridThead.jsp?packageId='+packageId+"&pageId="+pageId+'&propertyName='+propertyName+'&gridType='+gridType+'&callbackMethod=openWindowCallback';
    window.open(url, "customGridThead", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
}

/**
 * 跳转到editableGrid配置表头界面
 * @param event 事件
 * @param self 组件本身对象
 */
function openCustomEditableGridTheadWindow(event, self){
	var width=830; //窗口宽度
    var height=600; //窗口高度
    var top=(window.screen.availHeight-height)/2;
    var left=(window.screen.availWidth-width)/2;
    var propertyName=self.options.name;
    var gridType=scope.data.uitype;
    var url=webPath+'/cap/bm/dev/page/uilibrary/CustomEditableGridThead.jsp?packageId='+packageId+"&pageId="+pageId+'&propertyName='+propertyName+'&gridType='+gridType+'&callbackMethod=openWindowCallback';
    window.open(url, "customEditableGridThead", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
}

/**
 * 跳转到grid配置表头界面
 * @param event 事件
 * @param self 组件本身对象
 */
function openCustomGridSortNameWindow(event, self){
	var width=350; //窗口宽度
    var height=450; //窗口高度
    var top=(window.screen.availHeight-height)/2;
    var left=(window.screen.availWidth-width)/2;
    var url=webPath+'/cap/bm/dev/page/uilibrary/CustomGridSortName.jsp?callbackMethod=openWindowCallback';
    window.open(url, "customGridSortName", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
}

/**
 * 跳转到grid配置表头界面
 * @param event 事件
 * @param self 组件本身对象
 */
function openComponentSelect(event, self){
	var width=600; //窗口宽度
    var height=500; //窗口高度
    var top=(window.screen.availHeight-height)/2;
    var left=(window.screen.availWidth-width)/2;
    var propertyName=self.options.name;
    var url = '../designer/PageComponentSelect.jsp?pageId='+pageId;
    window.open(url, "componentSelect", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
}

/**
 * 导入控件
 * @param nodes 元素节点集
 */
function getSelectData(nodes){
	for(var i=0;i<nodes.length;i++){
		var node=nodes[i];
		if(node.options.uitype === 'Button'){
			var value = "{search:{btn: '#"+node.options.id+"'}}";
			scope.data.operation = value;
			scope.$digest();
			break;
		}
	}
}

/**
 * 打开数据模型选择界面
 * @param event 事件
 * @param self 组件本身对象
 */
function openDataStoreSelect(event, self) {
	var propertyName = self.options.name;
	var url = '../designer/DataStoreSelect.jsp?packageId=' + packageId+"&modelId="+pageId+"&flag="+propertyName;
	if(propertyName =="url"){
		url += "&selectType="+propertyName;
	}else if(propertyName === "databind" || propertyName === "primarykey" 
		|| propertyName === "idName" || propertyName === "valueName"||propertyName === "opts" || propertyName === "objId"){
		url += "&selectType=dataStoreAttribute";
	}
	var top=(window.screen.availHeight-600)/2;
	var left=(window.screen.availWidth-800)/2;
	window.open (url,'importRoleAccess','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
}

/**
 * 打开页面选择界面
 * @param event 事件
 * @param self 组件本身对象
 */
function openPageUrlSelect(event, self){
	var propertyName = self.options.name;
	var url = '../designer/CopyPageListMain.jsp?systemModuleId=' + packageId+"&modelId="+pageId+"&flag="+propertyName+"&selectType=jsp";
	var top=(window.screen.availHeight-600)/2;
	var left=(window.screen.availWidth-800)/2;
	window.open (url,'openPageUrlSelect','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
}

/**
 * 页面选择回调
 * @param selectData 页面对象（pageVO）
 * @param openType 打开类型
 * @param flag 属性名称
 */
function selectPageData(selectData, openType, flag){
	var data = scope.component.prefix != null ? (scope.data[scope.component.prefix] != null ? scope.data[scope.component.prefix].data : scope[scope.component.prefix].data) : scope.data;
	data[flag] = selectData.url;
    scope.$digest();
}

/**
 * 数据模型选择回调
 * @param variableSelect 回调值
 * @param flag 属性名称
 * @param isWrap 是否对回调值进行处理（如："@{"+value+"}"）
 * @param selectDataStoreVO 辅助对象（回调值对应的数据集对象，用于是否自动生成校验信息）
 */
function importDataStoreVariableCallBack(variableSelect, flag, isWrap, selectDataStoreVO){
	var data = scope.component.prefix != null ? (scope.data[scope.component.prefix] != null ? scope.data[scope.component.prefix].data : scope[scope.component.prefix].data) : scope.data;
	if(!variableSelect || variableSelect === '') {
		variableSelect = '';
	} else if(flag == 'primarykey'){
		variableSelect = variableSelect.substr(variableSelect.lastIndexOf(".")+1, variableSelect.length);
	} else {
		var attribute = {};
		var isAttribute = false;
		if(cui("#validate").options != null){
			var englishName = variableSelect.substr(variableSelect.lastIndexOf(".")+1, variableSelect.length);
			var attributes = selectDataStoreVO.entityVO.attributes;
			for(var i in attributes){
				if(englishName == attributes[i].engName){
					isAttribute =true;
					attribute = attributes[i];
					break;
				}
			}
			if(isAttribute){
			var validate = generateValidate(attribute, data.uitype);
			}
			if(isAttribute&&validate.length > 0){
				data.validate = JSON.stringify(validate);
			} else {
				data.validate = '';
			}
		}
		if(data.name != null && data.uitype != "EditableGrid"){
			if(scope.uitype === "ChooseUser" || scope.uitype === "ChooseOrg"){ //编辑网格上的columns和edittype页面上的scope才有uitype属性
				variableSelect = variableSelect.substr(variableSelect.lastIndexOf(".")+1, variableSelect.length);
			} else {
				data.name = variableSelect.substr(variableSelect.lastIndexOf(".")+1, variableSelect.length);
				if((data.uitype === "ChooseUser" || data.uitype === "ChooseOrg") && flag === 'idName' && typeof data.databind != 'undefined'){// 人员（组织）控件databind根据idName值自动赋值
					data.databind = variableSelect + data.uitype;
				}
			}
		} 
 		if(data.label != null && attribute.chName != null){
			data.label = attribute.chName;
		}
 		if(data.uitype === 'AtmSep' && flag === 'objId'){
 			variableSelect = '$' + variableSelect; 
 		}
	}
	//人员、组织opts属性选择回调
	if(flag==="opts" && (data.uitype === "ChooseUser"||data.uitype === "ChooseOrg")){
		data[flag] = variableSelect ? "{'codeName':'"+ variableSelect+"'}" : "";
	}else{
	    data[flag] = variableSelect;
	}
	scope.$digest();
}

/**
 * 根据databind绑定的属性，生成对应校验规则
 * @param attribute 属性对象
 * @param uitype 控件类型
 */
function generateValidate(attribute, uitype){
	var validate = [];
	var cname = attribute.chName;
	if(!attribute.allowNull){// 校验是否为空
		validate.push({'type':'required', 'rule':{m: cname+'不能为空'}});
	}
	var attributeType = attribute.attributeType.type;
	if(uitype != 'ChooseUser' && uitype != 'ChooseOrg' && uitype != 'RadioGroup' 
		&& uitype != 'CheckboxGroup' && uitype != 'PullDown'
		&& attributeType != 'java.sql.Date' && attributeType != 'java.sql.Timestamp'){
		if(attribute.attributeLength > 0){// 最大长度
			if(attribute.precision > 0){
				//小数点+1
				validate.push({'type':'length', 'rule':{max:attribute.attributeLength+1,maxm: cname+'长度不能大于'+(attribute.attributeLength+1)+'个字符'}});
			}else{
				validate.push({'type':'length', 'rule':{max:attribute.attributeLength,maxm: cname+'长度不能大于'+attribute.attributeLength+'个字符'}});
			}
		}
		if(attribute.precision > 0){// 校验数字精度
//			var regex = '^[0-9]+(.[0-9]{'+attribute.precision+'})?$';
//			validate.push({'type':'format', 'rule':{pattern: regex,m: "精度是"+attribute.precision+'位小数点'}});
			
			var regex = '^[0-9]{1,' + (attribute.attributeLength-attribute.precision) + '}(\\.[0-9]{1,'+attribute.precision+'})?$';
			validate.push({'type':'format', 'rule':{pattern: regex,m: "整数最多为"+(attribute.attributeLength-attribute.precision)+"位，小数最多为"+attribute.precision+'位'}});
		}
	}
	return validate;
}

/**
 * 打开数据字典选择界面
 * @param event 事件
 * @param self 组件本身对象
 */
function openDictionarySelect(event, self) {
	var propertyName = self.options.name;
	var url = '../dictionary/SelectDictionary.jsp?sourceModuleId=' + packageId + '&propertyName='+propertyName+'&code='+self.$input.val()+'&callbackMethod=openWindowCallback';
	var top=(window.screen.availHeight-600)/2;
	var left=(window.screen.availWidth-800)/2;
	window.open (url,'dictionarySelect','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
}

/**
 * 跳转到entityType配置
 * @param event 事件
 * @param self 组件本身对象
 */
function openCustomEditGridEntityType(event, self){
	var width=800; //窗口宽度
    var height=600; //窗口高度
    var top=(window.screen.availHeight-height)/2;
    var left=(window.screen.availWidth-width)/2;
    var propertyName=self.options.name;
    var url=webPath+'/cap/bm/dev/page/uilibrary/CustomEditableGridEntityType.jsp?propertyName='+propertyName+'&callbackMethod=openWindowCallback';
    window.open(url, "customEditGridEntityType", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
}

/**
 * 复杂模型回调函数
 * @param propertyName 属性名称
 * @param propertyValue 属性值
 */
function openWindowCallback(propertyName, propertyValue){
	cui("#"+propertyName).setValue(propertyValue);
}

//打开Borderlayout属性编辑器
function openBorderlayoutEditor() {
	var items = scope.data.items ? scope.data.items : '[]';
	var fixed = scope.data.fixed ? scope.data.fixed : '{}';
	var url = webPath+'/cap/bm/dev/page/uilibrary/BorderlayoutEditor.jsp?packageId=' + packageId+"&modelId="+pageId+"&items="+items+"&fixed="+fixed;
	var top=(window.screen.availHeight-600)/2;
	var left=(window.screen.availWidth-800)/2;
	window.open (url,'importRoleAccess','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
}

/**
 * 设置Borderlayout属性编辑器
 * @param items 边框布局控件的items属性值
 * @param fixed 边框布局控件的fixed属性值
 */
function setBorderlayoutItems(items, fixed) {
	scope.data.items = items;
	scope.data.fixed = fixed;
	cap.digestValue(scope);
}
