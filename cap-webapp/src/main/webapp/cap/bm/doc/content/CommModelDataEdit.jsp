<%
  /**********************************************************************
	* 通用模型数据维护页面 
	* 2015-11-10 李小芬  新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
<title>通用模型数据维护页面</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/eic/js/comtop.ui.emDialog.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/CapDocAttributeDefAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/DocCommObjectAction.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/top/js/jct.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.editor.min.js"></script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
.thw_title{
	font-weight: bold;
	font-size:16px;
}
.classify_title{
  	font-family:"Microsoft Yahei";
    font-size:16px;    		
  	color:#0099FF;
}

</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_operate">
			<span uitype="button" label="保存" on_click="save"></span> 
			<span uitype="button" label="关闭" on_click="closeSelf"></span>
		</div>
	</div>
	<div id="commAttriEditDiv"  class="top_content_wrap" >

	</div>
<script type="text/javascript">
	var objectUri = "${param.uri}";//模型对象定义uri
	var objectInstanceId = "4CEC47CDC9EB4334BF82E217C28BC8BC";//"${param.objectInstanceId}";//模型对象定义uri
	var docAttributeDefList;
	var DocCommObject;
	
	var reqElements = new Array();
	
	//初始化加载  	
   	window.onload = function(){
   		//查询对象属性定义的集合
   		//循环集合，如果是textarea、input、Editor、------//PullDown、RadioGroup、CheckboxGroup展示对应控件
   		//填写值后保存到数据库，map对象 
   		dwr.TOPEngine.setAsync(false);
   		CapDocAttributeDefAction.queryObjectAttribute(objectUri,function(data){
   			docAttributeDefList = data;
   		});
   		//查询属性值 
   		var condition = {"classUri":objectUri,"id":objectInstanceId}
   		DocCommObjectAction.readObjectInstance(condition,function(data){
   			DocCommObject = data;
   		});
   		dwr.TOPEngine.setAsync(true);
   		
   		for(var i = 0; i < docAttributeDefList.length; i++){
   			reqElements.push(docAttributeDefList[i].engName);
   		}
   	 	var instance = new jCT(cui("#attributeTemplate").val());
	    instance.Build();
	    cui("#commAttriEditDiv").html(instance.GetView());
   		comtop.UI.scan();
   		
   		if(DocCommObject.docCommAttributeByReattris){
	   		for(var i = 0; i < DocCommObject.docCommAttributeByReattris.length; i++){
	   			var cuiId = "#" + DocCommObject.docCommAttributeByReattris[i].attributeUri;
	   			var cuiValue = DocCommObject.docCommAttributeByReattris[i].value;
	   			if(containsProperty(DocCommObject.docCommAttributeByReattris[i].attributeUri)){
	   				cui(cuiId).setValue(cuiValue);
	   			}
	   			
	   		}
   		}
   	}
	
	function save(){
		if(window.validater){
			var map = window.validater.validAllElement();
			var inValid = map[0];
			//验证消息
			if(inValid.length > 0) { //验证失败
				var str = "";
				for(var i=0; i<inValid.length; i++) {
					str += inValid[i].message + "<br/>";
				}
				return;
			}
		}
		var tmpData = cui(DocCommObject).databind().getValue();
		if(!DocCommObject.propertiesMap){
			DocCommObject.propertiesMap = {};
		}
		for(var attriName in tmpData){
			if(containsProperty(attriName)){
				DocCommObject.propertiesMap[attriName] = tmpData[attriName];
			}
		}
		//保存数据 
		DocCommObject.classUri = objectUri;
		if(reqElements.length > 0){
			DocCommObject.uri = objectUri + "." + curentTime();
		}else{
			cui.message('对象没有定义任何属性，不执行保存。','success');
			return;
		}
		dwr.TOPEngine.setAsync(false);
		DocCommObjectAction.saveDocCommObject(DocCommObject,function(data){
			DocCommObject.id = data;
   			//刷新列表
    	    window.parent.editCallBack(data);
 			//保存提示
			window.parent.cui.message('保存成功。','success');
   		});
   		dwr.TOPEngine.setAsync(true);
	}
	
	/**
	 * 判断是否为区域项后台基本属性
	 */
	function containsProperty(property){
		for(var i = 0; i < reqElements.length; i++){
			if(property == reqElements[i]){
				return true;
			}
		}
		return false;
	}
	
	//关闭窗口
	function closeSelf(){
		window.parent.dialog.hide();
	}
	
	function curentTime(){
		var now = new Date();
		var year = now.getFullYear(); //年
	 	var month = now.getMonth() + 1; //月
	 	var day = now.getDate(); //日
	 	var hh = now.getHours(); //时
	 	var mm = now.getMinutes(); //分
		var ss=now.getSeconds();//秒
		
	 	var clock = year +"-";
	 	if(month < 10){
	 		clock +="0";
	 	}  
	 	clock += month +"-";
	 	if(day < 10){
	 		clock +="0";
	 	}  
	 	clock += day +"";
	 	if(hh < 10){
	 		clock +="0";
	 	} 
	 	clock += " ";
	 	clock += hh +":";
	 	if (mm < 10){
	 		clock += '0';
	 	}  
	 	clock += mm+":";
	 	if (ss < 10){
	 		clock += '0'; 
	 	} 
		clock += ss;
		
		return(clock);
	}
	
</script>
<textarea id="attributeTemplate" style="display:none">
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="16%" />
				<col width="84%" />
			</colgroup>
			<!---
			if(docAttributeDefList){
				for(var i=0;i<docAttributeDefList.length;i++){
					var docAttributeDef = docAttributeDefList[i];
			-->
			<tr>
				<td class="td_label">
				<!---if(docAttributeDef.requried == 1){--><span class="top_required">*</span><!---}-->
				<span>+-docAttributeDef.chName-+:</span>
				</td>
				<td>
				<!---if(docAttributeDef.elementType==="input"){-->
					<!---if(docAttributeDef.requried){-->
					<span uitype="input" id="+-docAttributeDef.engName-+" databind="DocCommObject.+-docAttributeDef.engName-+" width="100%"  maxlength ="100" validate="不能为空"></span>
					<!---}else{-->
					<span uitype="input" id="+-docAttributeDef.engName-+" databind="DocCommObject.+-docAttributeDef.engName-+" width="100%"  maxlength ="100"></span>
					<!---}-->
				<!---}else if(docAttributeDef.elementType==="textarea"){-->
					<span style="color:#999;">您还能输入<label id="remark_tip" style="color: red;"></label>个字！</span><br/>
					<span uitype="Textarea" relation="remark_tip" id="+-docAttributeDef.engName-+" height="51px" maxlength="256" byte="true" textmode="false" 
						autoheight="false" width="99%" name="+-docAttributeDef.engName-+" databind="DocCommObject.+-docAttributeDef.engName-+" readonly="false"></span>
				<!---}else if(docAttributeDef.elementType==="editer"){-->	
					<span uitype="Editor" id="+-docAttributeDef.engName-+" width="555" min_frame_height="120"  word_count="false" textmode="false" word_count="true"  
						databind="DocCommObject.+-docAttributeDef.engName-+" toolbars="[]" focus="true" readonly="false"></span>
				<!---}-->	
				</td>
			</tr>
			<!---
				}
			}
			-->
		</table>
</textarea>
</body>
</html>