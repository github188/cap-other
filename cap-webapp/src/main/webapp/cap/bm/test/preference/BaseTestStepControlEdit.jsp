<%
/**********************************************************************
* 基本测试步骤控件选项编辑页面
* 2015-7-1 zhangzunzhi 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='baseTestStepControl'>
<head>
<meta charset="UTF-8">
<title>基本测试步骤帮助编辑</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.editor.min.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/jct/js/jct.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/ComponentFacade.js'></top:script>
    <script type="text/javascript">
	var flag=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("flag"))%>;
	var componetId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("componetId"))%>;
	var index = parseInt(flag);
	var data = window.parent.scope.arguments[index].ctrl.options==null?{}:window.parent.scope.arguments[index].ctrl.optionMap;
   	var _=cui.utils;
   	var scope =null;
   	
   	angular.module('baseTestStepControl', ["cui"]).controller('baseTestStepControlCtrl', function ($scope, $compile) {
		$scope.data=data;
		$scope.componentVO ={};
		
		$scope.ready=function(){
			dwr.TOPEngine.setAsync(false);
			ComponentFacade.loadModel(componetId, function(result){
				$scope.componentVO = result;
	 		})
	 		dwr.TOPEngine.setAsync(true);
			scope=$scope;
			  //属性模板解析
			$('#div_property').html(new jCT($('#ctrlPropertiesTemplate').html()).Build().GetView()); 	
			//行为模板解析
			//$('#div_action').html(new jCT($('#ctrlActionsTemplate').html()).Build().GetView()); 
			var height = scope.componentVO.properties.length*20 + 25;
			var size = {width:850, height:height};
			window.parent.ctrlDialog.setSize(size);
			comtop.UI.scan();
			$compile($('#chooseCopyPage').contents())($scope);
	    };

	   
   	});
   	
   	//确定保存数据
   	function saveCtrl(){
   		var required = window.parent.scope.arguments[index].required;
   		data.required = required;
   		var ctrlOptions = JSON.stringify(data); 
   		window.parent.scope.arguments[index].ctrl.options = ctrlOptions;
   		closeCtrl();
   	}
   	
   	//关闭窗口
   	function closeCtrl(){
   		window.parent.ctrlDialog.hide();
   	}
   	
   	//控件ID校验函数
   	function isExistComponentId(){
   		return true;
   	}
   	
   	//checkboxGroup checkbox_list选择设置
   	//ListBox  datasource选择设置
   	//RadioGroup   radio_list选择设置
   	//Pulldown         datasource选择设置
		var codeEditDialog;
function openCodeEditAreaWindow(event, self){
	var width=800; //窗口宽度
    var height=600; //窗口高度
    var top=(window.screen.availHeight-height)/2;
    var left=(window.screen.availWidth-width)/2;
    var propertyName=self.options.name;
    var url='CustomDataModel.jsp?propertyName='+propertyName+'&callbackMethod=openWindowCallback';
    if(!codeEditDialog){
    	codeEditDialog = cui.dialog({
		  	title : '基本测试步骤控件选项编辑',
		  	src : url,
		    width : 750,
		    height : 500
		});
	} 
    codeEditDialog.show(url);
}
   	
/**
 * 复杂模型回调函数
 * @param propertyName 属性名称
 * @param propertyValue 属性值
 */
function openWindowCallback(propertyName, propertyValue){
	cui("#"+propertyName).setValue(propertyValue);
}   	
	</script>
	<!-- 控件属性展示模板 -->
	<script type="text/template" id="ctrlPropertiesTemplate">
        <table class="form_table" style="table-layout:fixed">
<!---
          var properties = scope.componentVO.properties;
          var propertiesTemp = [];
          for(var j=0,len=properties.length;j<len;j++){
           if(properties[j].ename!='uitype'&&properties[j].hide!=true&&properties[j].ename!='mask'&&properties[j].ename!='maskoptions'
             &&properties[j].ename!='validate'&&properties[j].ename!='databind'&&properties[j].ename!='readonly'&&properties[j].ename!='dictionary'
             &&properties[j].ename!='enumdata'){
              propertiesTemp.push(properties[j]);
            }
         }
          var property = {};
          var nextProperty = {};
          var hashNext = true;
          var propertiesSize = propertiesTemp.length-1;
          for(var i=propertiesSize;i>=0;i--){
          property = propertiesTemp[i];
          var nextIndex = i-1;
          if(nextIndex>=0){
         	 nextProperty = propertiesTemp[nextIndex];
          }else{
            hashNext = false;
           }
          var propertyEditorUI = property.propertyEditorUI;
            i--;
-->
          <tr>
			<td  class="td_label" style="text-align: right;width:19%">
	          <!---
				if (property.requried){
			 -->
				<font color="red">*</font>
             <!---
				}  
			-->
           <!--- if (property.label != null){ -->+-property.label-+：<!---} else {-->+-property.ename-+：<!--- } -->
			</td>
			<!---
			var attr = '';
			var propertyVo = propertyEditorUI.script;
			propertyVo = typeof(propertyVo) == 'object' ? propertyVo : eval("("+propertyVo+")");
			for(var key in propertyVo){
				if(key !='radio_list'){
					var value = propertyVo[key];
					if(key === 'ng-model' && scope.componentVO.prefix != null){
						value = scope.componentVO.prefix + '.' + propertyVo[key];
					}
					attr += ' '+ key + '="' + value + '"';
				}
			}
           if(property.ename=="id"||property.ename=="name"){
                  attr += ' '+"readOnly=true";  
            }
            -->
			<td class="td_content" style="text-align: left;width:40%">
                <!---
                  var componentName =propertyEditorUI.componentName;
                  -->
						<span +-componentName-+ +-attr-+ width="90%" valuetype="+-propertyVo.type-+">
							<!---
								if(propertyVo.radio_list != null){
									for(var j=0;j<propertyVo.radio_list.length;j++){
										var propertyRadio = propertyVo.radio_list[j];
							-->
								<!---
									if (propertyRadio.readonly == 'undefinded'){
								-->
									<input type="radio" value="+-propertyRadio.value-+" text="+-propertyRadio.text-+"/>
								<!---
									}else{
								-->
									<input type="radio" value="+-propertyRadio.value-+" text="+-propertyRadio.text-+" />
							<!---
										} 
									}
								}
							-->
						</span>
			</td>
			<td  class="td_label" style="text-align: right;width:19%">
	          <!---
                 if(hashNext){
				if (nextProperty.requried){
			 -->
				<font color="red">*</font>
             <!---
				}  
			-->
           <!--- if (nextProperty.label != null){ -->+-nextProperty.label-+：<!---} else {-->+-nextProperty.ename-+：<!--- } -->
			<!---}-->
           </td>
            <!---
			var nextAttr = '';
            var nextPropertyEditorUI = nextProperty.propertyEditorUI;
			var nextPropertyVo = nextPropertyEditorUI.script;
			nextPropertyVo = typeof(nextPropertyVo) == 'object' ? nextPropertyVo : eval("("+nextPropertyVo+")");
			for(var key in nextPropertyVo){
				if(key !='radio_list'){
					var value = nextPropertyVo[key];
					if(key === 'ng-model' && scope.componentVO.prefix != null){
						value = scope.componentVO.prefix + '.' + nextProperty[key];
					}
					nextAttr += ' '+ key + '="' + value + '"';
				}
			}
            if(nextProperty.ename=="id"||nextProperty.ename=="name"){
                  nextAttr += ' '+"readOnly=true";  
            }
            -->
			<td class="td_content" style="text-align: left;width:40%">
               <!---if(hashNext){-->
                <!---
                  var nextComponentName =nextPropertyEditorUI.componentName;
                  -->
						<span +-nextComponentName-+ +-nextAttr-+ width="90%" valuetype="+-nextProperty.type-+">
							<!---
								if(nextPropertyVo.radio_list != null){
									for(var j=0;j<nextPropertyVo.radio_list.length;j++){
										var nextPropertyRadio = nextPropertyVo.radio_list[j];
							-->
								<!---
									if (nextPropertyRadio.readonly == 'undefinded'){
								-->
									<input type="radio" value="+-nextPropertyRadio.value-+" text="+-nextPropertyRadio.text-+"/>
								<!---
									}else{
								-->
									<input type="radio" value="+-nextPropertyRadio.value-+" text="+-nextPropertyRadio.text-+" />
							<!---
										} 
									}
								}
							-->
						</span>
             <!---}-->
			</td>
		  </tr>
<!---
}
-->
        </table>
    </script>
</head>
<style>
	.top_header_wrap{
		padding-right:5px;
	}
</style>
<body ng-controller="baseTestStepControlCtrl" data-ng-init="ready()">
<div id="pageRoot" class="cap-page">
	<div id="chooseCopyPage" class="cap-area" style="width:100%;dispaly:none;">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: right;padding:5px">
		        	<span id="saveCtrl" uitype="Button" onclick="saveCtrl()" label="确定"></span> 
					<span id="closeCtrl" uitype="Button" onclick="closeCtrl()" label="取消"></span> 
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span>
			        	<blockquote class="cap-form-group">
							<span class="cap-label-title" size="12pt">控件属性</span>
						</blockquote>
					</span>
		        </td>
		    </tr>
		</table>
		<div id="div_property"></div>
	</div>
</div>
</body>
</html>