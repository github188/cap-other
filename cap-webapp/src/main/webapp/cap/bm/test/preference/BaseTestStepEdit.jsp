<%
/**********************************************************************
* 基本测试步骤编辑页面
* 2015-6-29 zhangzunzhi 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='baseTestStep'>
<head>
<style>
	.icon-img {
		margin-left: 10px;
		margin-bottom:-5px;
	     display: inline-block;
        *display: inline;
        *zoom: 1;
        width: 20px;
        height: 20px;
        text-align: center;
        background-size: 100% 100% !important;
    }
    </style>
<meta charset="UTF-8">
<title>基本测试步骤编辑页面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/test/css/icons.css"></top:link>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/StepFacade.js'></top:script>
	<top:script src="/cap/dwr/interface/StepGroupsFacade.js"></top:script>
	<script type="text/javascript">
	var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
	var data={};
	
	angular.module('baseTestStep', [ "cui"]).controller('baseTestStepCtrl', function ($scope) {
		$scope.arguments=[];
		
		$scope.ready=function(){
			dwr.TOPEngine.setAsync(false);
			StepFacade.loadBasicStepById(modelId, function(result){
	 			data = result;
	 			for(var i in result.arguments){
	 				result.arguments[i].required = result.arguments[i].required+"";
	 		   	}
	 			$scope.arguments = result.arguments;
	 		})
	 		dwr.TOPEngine.setAsync(true);
			$(".icon-img").attr("class","icon-img "+data.icon);
	    	comtop.UI.scan();
	    	scope=$scope;
	    };
	    
	});
/**
 * 编辑Grid数据加载
 * @param obj {Object} Grid组件对象
 * @param query {Object} 查询条件
 */
function initData(obj, query) {
	 var result = data.arguments;
	 obj.setDatasource(result,result.length);
}
	
		//保存
		function save(){
			var map = window.validater.validAllElement();
		    var inValid = map[0];
		    var valid = map[1];
		   	//验证消息
			if(inValid.length > 0){//验证失败
				var str = "";
		        for (var i = 0; i < inValid.length; i++) {
					str += inValid[i].message + "<br />";
				}
			}else{
				var saveData = cui(data).databind().getValue();
				dwr.TOPEngine.setAsync(false);
				StepFacade.saveBasicStep(modelId,saveData, function(data){
		 			if(data){
			 			cui.message('步骤修改成功。',"success");
		 			}else{
		 				cui.message('步骤修改失败。',"error");
		 			}
		 		})
		 		dwr.TOPEngine.setAsync(true);
			}
		  }
		
		var dialog;
		// 图标选择
		function showIconSelector() {
			var height = 450;
			var width = 673;
			var url ='IconsSelector.jsp';
			if(!dialog){
				dialog = cui.dialog({
				  	title : "图标选择",
				  	src : url,
				    width : width,
				    height : height,
				    top: "12%"
				});
			}
		 	dialog.show(url);
		}

		//关闭图标窗口
		function closeWindow(){
			dialog.hide();
		}
		
		function updateIcon(icon){
			cui("#icon").setValue(icon);
			$(".icon-img").attr("class","icon-img "+icon);
		}
		
		//返回
		function back(){
			var attr="modelId="+modelId;
			window.location="BaseTestStepManager.jsp?"+attr;	  
		}
		
		function getBodyWidth() {
		    return (document.documentElement.clientWidth || document.body.clientWidth) - 45;
		}
		
		function getBodyHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 410;
		}
		
	  var validateDefinition=[
	                          {'type':'required','rule':{'m':'步骤定义不能为空。'}},
	                          {'type':'length','rule':{'max':'80','maxm':'长度不能大于80'}},
	         	              {'type':'custom','rule':{'against':checkDefinition, 'm':'编码只能为数字、字母、下划线。'}},
	                          {'type':'custom','rule':{'against':isExistStepDefinition, 'm':'步骤定义已存在。'}}
	         		    ];
	  
		//只能为 英文、数字、下划线
		function checkDefinition(data) {
			if(data){
				var reg = new RegExp("^[A-Za-z0-9_]+$");
				return (reg.test(data));
			}
			return true;
		}
		
		/**     
		 * 检查类型模版分类编码的是否已存在
		 */  
		function isExistStepDefinition(definition){
			var stepCode = cui("#group").getValue();
			var isExist = false;
			dwr.TOPEngine.setAsync(false);
			StepFacade.isExitDefinition(modelId,stepCode,definition, function(data){
				isExist = !data;
			});
			dwr.TOPEngine.setAsync(true); 
			return isExist;
		}
		
		//初始化步骤分组
	   function initStepGroup(obj){
			dwr.TOPEngine.setAsync(false);
			var result = [];
			StepGroupsFacade.loadStepGroups(function(data){
				if(data&&data.groups){
					result = data.groups;
				}
				obj.setDatasource(result);
			});
			dwr.TOPEngine.setAsync(true);
		} 
		
		//步骤参数帮助编辑
		var helpDialog;
		function openHelp(index,help,attrName){
			var url = 'BaseTestStepHelpEdit.jsp?flag='+index+"&attrName=" +attrName;
			if(!helpDialog){
				helpDialog = cui.dialog({
				  	title : '基本测试步骤帮助编辑',
				  	src : url,
				    width : 600,
				    height : 400
				});
			} 
			helpDialog.show(url);
		}
		
		//关闭窗口
		function closeWindowCallback(){
			helpDialog.hide();
		}
		
		//控件脚本编辑
		var scriptDialog;
		function openCtrlScript(index,script,attrName){
			var url = 'BaseTestStepControlScriptEdit.jsp?flag='+index+"&attrName=" +attrName;
			if(!scriptDialog){
				scriptDialog = cui.dialog({
				  	title : '基本测试步骤控件脚本编辑',
				  	src : url,
				    width : 650,
				    height : 650
				});
			} 
			scriptDialog.show(url);
		}
		
		
		//步骤参数控件选项编辑
		var ctrlDialog;
		function openCtrlOptions(index,ctrlOptions){
			var ctrlTypeIndex = parseInt(index);
			var ctrlType = scope.arguments[ctrlTypeIndex].ctrl.type;
			var componetId = getUIComponetIdByCtrlType(ctrlType);
			var url = 'BaseTestStepControlEdit.jsp?flag='+index+"&componetId="+componetId;
			if(!ctrlDialog){
				ctrlDialog = cui.dialog({
				  	title : '基本测试步骤控件选项编辑',
				  	src : url,
				    width : 850,
				    height : 380
				});
			} 
			ctrlDialog.show(url);
		}
		
	  var initDataCtrlType=[{id:"Input",text:"Input"},
							{id:"ClickInput",text:"ClickInput"},
							{id:"CheckboxGroup",text:"CheckboxGroup"},
							{id:"ListBox",text:"ListBox"},
							{id:"Calender",text:"Calender"},
							{id:"RadioGroup",text:"RadioGroup"},
							{id:"Pulldown",text:"Pulldown"},
							{id:"Textarea",text:"Textarea"}
	  ];
	  
	  //根据控件类型获取设计器中的控件ID
	 function getUIComponetIdByCtrlType(ctrlType){
		var componetId = "";
		switch(ctrlType){
			case "Input":
				componetId = "uicomponent.common.component.input";
				break;
			case "ClickInput":
				componetId = "uicomponent.common.component.clickInput";
				break;
			case "CheckboxGroup":
				componetId = "uicomponent.common.component.checkboxGroup";
				break;
			case "ListBox":
				componetId = "uicomponent.common.component.listBox";
				break;
			case "Calender":
				componetId = "uicomponent.common.component.calender";
				break;
			case "RadioGroup":
				componetId = "uicomponent.common.component.radioGroup";
				break;
			case "Pulldown":
				componetId = "uicomponent.common.component.pullDown";
				break;
			case "Textarea":
				componetId = "uicomponent.common.component.textarea";
				break;	
			default:
				componetId = "uicomponent.common.component.input";
		}
		return componetId;
	  }
		
	</script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="baseTestStepCtrl" data-ng-init="ready()">
<div id="pageRoot" class="cap-page">
	<div id="chooseCopyPage" class="cap-area" style="width:100%;dispaly:none;">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: right;padding:5px">
		        	<span id="saveToPage" uitype="Button" onclick="save()" label="保存"></span> 
					<span id="closeTemplate" uitype="Button" onclick="back()" label="返回"></span> 
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span>
			        	<blockquote class="cap-form-group">
							<span class="cap-label-title" size="12pt">步骤基本信息</span>
						</blockquote>
					</span>
		        </td>
		    </tr>
		</table>
		<table class="form_table" style="table-layout:fixed;">
						<tr>
							<td  class="td_label" style="text-align: right;width:15%">
								<font color="red">*</font>步骤名称：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span uitype="input"  id="name" databind="data.name" width="90%" readOnly="true"></span>
					        </td>
							
							<td  class="td_label" style="text-align: right;width:15%">
								引用资源：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					           <span uitype="input"  id="resources" databind="data.resources" width="90%" readOnly="true"></span>
					        </td>
						</tr>
						<tr>
							<td  class="td_label" style="text-align: right;width:15%">
								引用库：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span uitype="input"  id="libraries" databind="data.libraries" width="90%" readOnly="true"></span>
					        </td>
							
							<td  class="td_label" style="text-align: right;width:15%">
								<font color="red">*</font>步骤定义：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span uitype="input" id="definition" width="90%" databind="data.definition" validate="validateDefinition" readOnly="true"></span>
					        </td>
						</tr>
						<tr id="funcCodeTr">
							 <td class="td_label" style="text-align: right;width:15%">
					        	<font color="red">*</font>步骤分组：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        <span uitype="PullDown" id ="group" mode="Single" databind="data.group"  editable="false" value_field="code" label_field="name" width="90%" datasource="initStepGroup" ></span>
					        </td>
							 <td class="cap-td" style="text-align: right;width:100px"> 
							 <font color="red">*</font>图标：
							 </td>
							<td class="cap-td" style="text-align: left;white-space:nowrap">
							  <div>
							  <span uitype="ClickInput" id="icon" name="icon" databind="data.icon" validate="[{'type':'required', 'rule':{'m': '图标不能为空'}}]" maxlength="28" width="220px" on_change="iconChanged" enterable="false" readonly="false" icon="picture-o" on_iconclick="showIconSelector"></span>
					            <div class="icon-img"></div>
					            </div>
							</td>
						</tr>
						<tr>
						<td  class="td_label" style="text-align: right;width:15%">
								脚本：
					        </td>
					        <td class="td_content" colspan="3" style="text-align: left;width:90%">
					        	<span uitype="input"   id="description" width="95%" databind="data.macro" readonly="true"></span>
					        </td>
					    </tr> 
						<tr>
						<td  class="td_label" style="text-align: right;width:15%">
								步骤描述：
					        </td>
					        <td class="td_content" colspan="3" style="text-align: left;width:90%">
					        	<span uitype="input"   id="description" width="95%" databind="data.description" readonly="false"></span>
					        </td>
					    </tr>    
						<tr>
							<td  class="td_label" style="text-align: right;width:10%">帮助：
							</td>
							<td class="td_content" colspan="3" style="text-align: left;">
								<div style="width:95%;">
									<span uitype="textarea" name="help" databind="data.help" 
										relation="remarkLength" maxlength="500" width="100%"></span>
								</div>
							</td>
						</tr>
				</table>
	
<div>
    <table class="cap-table-fullWidth">
		<tr>
		     <td class="cap-td" style="text-align: left;padding:5px">
				  <blockquote class="cap-form-group">
					 <span class="cap-label-title" size="12pt">步骤参数</span>
				  </blockquote>
		     </td>
		     <td class="cap-td" style="text-align: right;padding:5px">
		     </td>
		</tr>
	</table>
    <div style="padding:5px">
     <table class="custom-grid" style="width: 100%">
       <thead>
           <tr>
           	   <th style="width:30px">
           		序号
               </th>
                <th style="width:150px">
                  	参数名
               </th>
               <th style="width:90px">
                  	是否必填
               </th>
               <th style="width:80px">
                  	值类型
               </th>
               <th style="width:80px">
                  	控件脚本
               </th>
               <th style="width:150px">
                  	控件类型
               </th>
               <th style="width:80px">
                  	控件选项
               </th>
               <th>
                  	描述
               </th>
               <th style="width:80px">
                  	帮助
               </th>
           </tr>
       </thead>
        <tbody>
            <tr ng-repeat="argumentVO in arguments track by $index">
                <td style="text-align: center;">
                    {{($index + 1)}}
                </td>
               <td style="text-align:center;">
                   {{argumentVO.name}}
              </td>
              <td style="text-align: left;">
              	<span cui_radioGroup id="{{'required'+($index + 1)}}" ng-model="argumentVO.required" name="{{'required'+($index + 1)}}" width="100%" readOnly="true">
              		<input type="radio" name="{{'required'+($index + 1)}}" value="true" />是
					<input type="radio" name="{{'required'+($index + 1)}}" value="false" />否
              	</span>
             </td>
             <td style="text-align:left;">
               	<span cui_pulldown id="{{'valueType'+($index + 1)}}" ng-model="argumentVO.valueType" width="100%">
              		<a value="STRING">字符串</a>
     			    <a value="NUMBER">数字</a>
     			    <a value="TIME">日期型</a>
     			    <a value="BOOL">布尔型</a>
              	</span>
             </td>
              <td style="text-align: left;">
               &nbsp&nbsp{{argumentVO.ctrl.script==null||argumentVO.ctrl.script==""?"未配置":"已配置"}}
               <img alt="" style="cursor:pointer" bind="{{$index}}" ctrlScript="{{argumentVO.ctrl.script}}" src="${pageScope.cuiWebRoot}/top/cfg/images/edit.png" id="{{'macro'+($index + 1)}}" onclick="openCtrlScript(jQuery(this).attr('bind'),jQuery(this).attr('ctrlScript'),'ctrl.script');"></img>
             </td>
             <td style="text-align: left;">
             	<span cui_pulldown id="{{'ctrlType'+($index + 1)}}" ng-model="argumentVO.ctrl.type" value_field="id" label_field="text" datasource="initDataCtrlType" width="100%" select="0">
              	</span>
             </td>
              <td style="text-align: left;">
               &nbsp&nbsp{{argumentVO.ctrl.options==null||argumentVO.ctrl.options==""?"未配置":"已配置"}}
               <img alt="" style="cursor:pointer" bind="{{$index}}" ctrlOptions="{{argumentVO.ctrl.options}}" src="${pageScope.cuiWebRoot}/top/cfg/images/edit.png" id="{{'ctrlOptions'+($index + 1)}}" onclick="openCtrlOptions(jQuery(this).attr('bind'),jQuery(this).attr('ctrlOptions'));"></img>
             </td>
             <td style="text-align: left;">
               <span cui_input id="{{'description'+($index + 1)}}" ng-model="argumentVO.description" width="100%">
             </td>
              <td style="text-align: left;">
               &nbsp&nbsp{{argumentVO.help==null||argumentVO.help==""?"未配置":"已配置"}}
               <img alt="" style="cursor:pointer" bind="{{$index}}" help="{{argumentVO.help}}" src="${pageScope.cuiWebRoot}/top/cfg/images/edit.png" id="{{'help'+($index + 1)}}" onclick="openHelp(jQuery(this).attr('bind'),jQuery(this).attr('help'),'help');"></img>
             </td>
            </tr>
       </tbody>
   </table>

   </div>
</div>
	
	</div>
</div>
</body>
</html>