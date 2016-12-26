<%
/**********************************************************************
* 测试字典分类编辑界面
* 2016-6-23 zhangzunzhi 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>编辑字典分类</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/TestmodelDicItemAction.js'></top:script>
</head>
<style>
	.top_header_wrap{
		padding-right:5px;
	}
</style>
<body>
	<div uitype="Borderlayout" id="body" is_root="true">	
		<div class="top_header_wrap" style="padding:10px 30px 10px 25px">
			<div class="thw_operate" style="float:right;height: 28px;">
				<span uitype="button" id="saveDictionaryItem" label="保存"  on_click="saveDictionaryItem" ></span>
				<span uitype="button" id="close" label="关闭"  on_click="closeDictionaryItem" ></span>
			</div>
		</div>
		<div class="cap-area" style="width:100%;padding:25px 0px 20px 0px">
			<table class="cap-table-fullWidth">
				<colgroup>
					<col width="27%" />
					<col width="73%" />
				</colgroup>
				<tr>
					<td class="cap-td" style="text-align: right;"><font color="red">*</font>全局编码：</td>
					<td class="cap-td" style="text-align: left;">
						<span uitype="Input" id="dictionaryCode" name="dictionaryCode" databind="data.dictionaryCode" width="92%" validate="validateDictionaryCode"></span>
				    </td>
				</tr>
				<tr>
					<td class="cap-td" style="text-align: right;"><font color="red">*</font>字典名称：</td>
					<td class="cap-td" style="text-align: left;">
						<span uitype="Input" id="dictionaryName" name="dictionaryName" databind="data.dictionaryName" width="92%" validate="validateDictionaryName"></span>
					</td>
				</tr>
				<tr>
					<td class="cap-td" style="text-align: right;"><font color="red">*</font>数据类型：</td>
					<td class="cap-td" style="text-align: left;">
				        <span id="dictionaryType" uitype="PullDown" mode="Single" databind="data.dictionaryType" value_field="id" label_field="text" datasource="initData" on_change="itemTypeChange" width="92%" value="String"></span>
				    </td>
				</tr>
				<tr>
					<td class="cap-td" style="text-align: right;"><font color="red">*</font>数据值：</td>
					<td class="cap-td" style="text-align: left;">
						<span uitype="Input" id="stringValue" name="dictionaryValue" databind="data.dictionaryValue" width="92%" validate="数据值不能为空"></span>
						<span uitype="Input" id="intValue" name="intValue" databind="data.dictionaryValue" width="92%" validate="validateInt"></span>
					    <span uitype="Calender" id="calender" name="calender" databind="data.dictionaryValue" validate="数据值不能为空" ></span>
					    <span id="booleanValue" uitype="RadioGroup" name="booleanValue" databind="data.dictionaryValue" value="true">
				        <input type="radio" name="booleanValue" value="true" />
				        true
				        <input type="radio" name="booleanValue" value="false" />
				        false 
				        </span>
					</td>
				</tr>
				<tr>
					<td class="cap-td" style="text-align: right;">分类描述：</td>
					<td class="cap-td" style="text-align: left;">
						<span uitype="Textarea" id="dictionaryDes" name="dictionaryDes" databind="data.dictionaryDes" width="92%" height="50px"></span>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<script type="text/javascript">
	    //操作类型，新增还是编辑
		var operationType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("operationType"))%>;
		var dictionaryItemId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("id"))%>;
		//字典分类ID
		var dictionaryClassifyId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("classifyId"))%>;
		var data = {};
		
		//页面装载方法
		$(document).ready(function(){
			if(operationType=="edit"){
				dwr.TOPEngine.setAsync(false);
				TestmodelDicItemAction.readDicItemVOById(dictionaryItemId, function(result){
		 			data = result;
		 		})
		 		dwr.TOPEngine.setAsync(true);
			}
			comtop.UI.scan();
			if(operationType=="edit"){
				cui("#dictionaryCode").setReadOnly(true);
			}
			//控制字典值不同类型的显示
			var dictionaryType = cui("#dictionaryType").getValue();
			checkDictionaryValue(dictionaryType);
		});
		
		var initData=[
				{id:"String",text:"字符串"},
	        	{id:"Time",text:"数字"},
	        	{id:"Number",text:"日期型"},
	        	{id:"Bool",text:"布尔型"}
 			]
		
		//控制字典值不同类型的显示
		function checkDictionaryValue(dictionaryType){
			var type="";
		    switch (dictionaryType) {
			    case "String":
			    	type="stringValue";
			        break;
			    case "Time":
			        type="intValue";
			        break;
			    case "Number":
			        type="calender";	        
			        break;
			    case "Bool":
			        type="booleanValue";	        
			        break;
			    default:
			        type="stringValue";
		    }
			 var items = ["stringValue", "intValue", "calender", "booleanValue"];
			for(var i=0,leng=items.length;i<leng;i++){
				if(items[i]===type){
					 $("#" + items[i]).show(); 
					 if(window.validater){
					 window.validater.disValid(items[i], false); 
					 }
				}else{
					 $("#" + items[i]).hide();   
					 if(window.validater){
					 window.validater.disValid(items[i], true); 
					 }
				}
			}    
		}
		
		function itemTypeChange(data,oldData){
			checkDictionaryValue(data.id);
			cui("#stringValue").setValue("");
			cui("#intValue").setValue("");
			cui("#calender").setValue("");
		}
		
		//保存模板
		function saveDictionaryItem(){
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
				if(operationType=="add"){
					saveData.classifyId = dictionaryClassifyId;
					if(saveData.dictionaryType==="Bool"&&saveData.dictionaryValue===""){
						saveData.dictionaryValue ="true";
					}
					dwr.TOPEngine.setAsync(false);
					TestmodelDicItemAction.insertDicItemVO(saveData, function(data){
			 			if(data){
			 			   //返回ID
				 			window.parent.cui.message('字典新增成功。',"success");
				 			window.parent.editCallBack("add",data);
			 			}else{
			 				window.parent.cui.message('字典新增失败。',"error");
			 			}
			 			closeDictionaryItem();
			 		})
			 		dwr.TOPEngine.setAsync(true);
				}else if(operationType=="edit"){
					var updateData = cui(data).databind().getValue();
					dwr.TOPEngine.setAsync(false);
					TestmodelDicItemAction.updateDicItemVO(updateData, function(data){
			 			if(data){
				 			window.parent.cui.message('字典修改成功。',"success");
				 			window.parent.editCallBack("edit",updateData.id);
			 			}else{
			 				window.parent.cui.message('字典修改失败。',"error");
			 			}
			 			closeDictionaryItem();
			 		})
			 		dwr.TOPEngine.setAsync(true);
				}
			}
		}
		
		//关闭窗口
		function closeDictionaryItem(){
			window.parent.addDicItemDialog.hide();
		}
		
		//系统目录名称和编码的检测
		var validateDictionaryCode = [
                 {'type':'required','rule':{'m':'编码不能为空。'}},
                 {'type':'length','rule':{'max':'50','maxm':'长度不能大于50'}},
	             {'type':'custom','rule':{'against':checkCode, 'm':'编码只能为数字、字母、下划线。'}},
                 {'type':'custom','rule':{'against':isExistDictionaryItemCode, 'm':'字典分类编码已存在。'}}
		    ],
         	validateDictionaryName = [
                 {'type':'required','rule':{'m':'名称不能为空。'}},
                 {'type':'length','rule':{'max':'50','maxm':'长度不能大于50'}},
	             {'type':'custom','rule':{'against':checkName, 'm':'名称只能为汉字、数字、字母、下划线、正斜杠、中英文括号。'}}
	            // {'type':'custom','rule':{'against':isExistDictionaryTypeName, 'm':'字典分类名称已存在。'}}
		    ],
		    validateInt = [
		                 {'type':'required','rule':{'m':'数据值不能为空。'}},
		                 {'type':'length','rule':{'max':'100','maxm':'长度不能大于100'}},
		   	             {'type':'custom','rule':{'against':checkNum, 'm':'请输入数字。'}}
		                 	];
		
		//检查是否为数字
		function checkNum(){
		  var value=cui("#intValue").getValue(),
		  	  type=cui("#dictionaryType").getValue();
			  var reg;
		  if(type=="Time"){
			 reg=/^-?[0-9]\d*$/;
			 return reg.test(value);	  
		   }else{
		     return true;
		  }
		}

		/**     
		 * 只能为汉字、数字、字母、下划线
		 */     
		function checkName(data) {  
			var flag = true;
			if(data == null || data == ''){
				return flag;
			}
			var patrn = /^[\u4E00-\u9FA5A-Za-z0-9_/\(（\)）]+$/; 
			if (!patrn.exec(data)) flag= false;
			return flag;
		}
		
		//只能为 英文、数字、下划线
		function checkCode(data) {
			if(data){
				var reg = new RegExp("^[A-Za-z0-9_]+$");
				return (reg.test(data));
			}
			return true;
		}
		
		/**     
		 * 检查类型模版分类编码的是否已存在
		 */  
		function isExistDictionaryItemCode(typeCode){
			var isExist = false;
			if(operationType=="edit"){
			   var checkVO = {id:dictionaryItemId,dictionaryCode:typeCode};
			}else{
			   var checkVO = {dictionaryCode:typeCode};
			}
			dwr.TOPEngine.setAsync(false);
			TestmodelDicItemAction.isExitDicItemCode(checkVO, function(data){
				isExist = !data;
			});
			dwr.TOPEngine.setAsync(true); 
			return isExist;
		}
		
		/**     
		 * 检查类型模版分类名称是否存在
		 */  
		function isExistDictionaryTypeName(typeName){
			/* var isExist = false;
			dwr.TOPEngine.setAsync(false);
			MetadataTmpTypeFacade.isExistMetadataTmpTypeByTypeName(typeName, templateTypeCode, function(data){
				isExist = !data;
			});
			dwr.TOPEngine.setAsync(true); */
			return true;
		}
	</script>
</body>
</html>