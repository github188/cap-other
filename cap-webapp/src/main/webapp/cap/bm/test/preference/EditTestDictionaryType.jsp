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
    <top:script src='/cap/dwr/interface/TestmodelDicClassifyAction.js'></top:script>
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
				<span uitype="button" id="saveDictionaryType" label="保存"  on_click="saveDictionaryType" ></span>
				<span uitype="button" id="close" label="关闭"  on_click="closeDictionary" ></span>
			</div>
		</div>
		<div class="cap-area" style="width:100%;padding:25px 0px 20px 0px">
			<table class="cap-table-fullWidth">
				<colgroup>
					<col width="27%" />
					<col width="73%" />
				</colgroup>
				<tr>
					<td class="cap-td" style="text-align: right;"><font color="red">*</font>分类目录：</td>
					<td class="cap-td" style="text-align: left;">
				        <span id="directory" uitype="PullDown" mode="Single" databind="data.directory" value_field="id" label_field="text" datasource="initData" width="92%" value="same"></span>
				    </td>
				</tr>
				<tr>
					<td class="cap-td" style="text-align: right;"><font color="red">*</font>全局编码：</td>
					<td class="cap-td" style="text-align: left;">
						<span uitype="Input" id="dictionaryCode" name="dictionaryCode" databind="data.dictionaryCode" width="92%" validate="validateDictionaryCode"></span>
				    </td>
				</tr>
				<tr>
					<td class="cap-td" style="text-align: right;"><font color="red">*</font>分类名称：</td>
					<td class="cap-td" style="text-align: left;">
						<span uitype="Input" id="dictionaryName" name="dictionaryName" databind="data.dictionaryName" width="92%" validate="validateDictionaryName"></span>
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
		var dictionaryClassifyId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("id"))%>;
		var dictionaryClassifyParentId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("parentId"))%>;
		var data = {};
		
		//页面装载方法
		$(document).ready(function(){
			if(operationType=="edit"){
				dwr.TOPEngine.setAsync(false);
		 		TestmodelDicClassifyAction.readClassifyVOById(dictionaryClassifyId, function(result){
		 			data = result;
		 		})
		 		dwr.TOPEngine.setAsync(true);
			}
			comtop.UI.scan();
			if(operationType=="edit"){
				cui("#directory").setReadonly(true);
				cui("#dictionaryCode").setReadonly(true);
			}
			//只有一个根节点
			if(dictionaryClassifyParentId=="-1"){
				if(dictionaryClassifyId=="0"){
					cui("#directory").setValue("same");
					cui("#directory").setReadonly(true);
				}else{
					cui("#directory").setValue("child");
					cui("#directory").setReadonly(true);
				}
			}
		});
		
		var initData=[
	 				{id:'same',text:'同级目录'},
	 				{id:'child',text:'下级目录'}
 				]
		
		//保存模板
		function saveDictionaryType(){
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
				var directory = saveData.directory;
				if(operationType=="add"){
					if(directory=="same"){
						saveData.parentId = dictionaryClassifyParentId;
					}else{
						saveData.parentId = dictionaryClassifyId;
					}
					dwr.TOPEngine.setAsync(false);
			 		TestmodelDicClassifyAction.insertClassifyVO(saveData, function(data){
			 			if(data){
			 			//返回ID
				 			parent.addRefreshTree(data,saveData.parentId,directory);
				 			window.parent.cui.message('分类新增成功。',"success");
			 			}else{
			 				window.parent.cui.message('分类新增失败。',"error");
			 			}
			 			closeDictionary();
			 		})
			 		dwr.TOPEngine.setAsync(true);
				}else if(operationType=="edit"){
					var updateData = cui(data).databind().getValue();
					dwr.TOPEngine.setAsync(false);
			 		TestmodelDicClassifyAction.updateClassifyVO(updateData, function(data){
			 			if(data){
				 			parent.editRefreshTree(updateData.id,updateData.parentId,updateData.dictionaryName);
				 			window.parent.cui.message('分类修改成功。',"success");
			 			}else{
			 				window.parent.cui.message('分类修改失败。',"error");
			 			}
			 			closeDictionary();
			 		})
			 		dwr.TOPEngine.setAsync(true);
				}
			}
		}
		
		//关闭窗口
		function closeDictionary(){
			window.parent.addDictionaryDialog.hide();
		}
		
		//系统目录名称和编码的检测
		var validateDictionaryCode = [
                 {'type':'required','rule':{'m':'编码不能为空。'}},
                 {'type':'length','rule':{'max':'50','maxm':'长度不能大于50'}},
	             {'type':'custom','rule':{'against':checkCode, 'm':'编码只能为数字、字母、下划线。'}},
                 {'type':'custom','rule':{'against':isExistDictionaryTypeCode, 'm':'字典分类编码已存在。'}}
		    ],
		    validataParentemplateType = [
            	{'type':'required','rule':{'m':'父级模版分类不能为空。'}}
         	],
         	validateDictionaryName = [
                 {'type':'required','rule':{'m':'名称不能为空。'}},
                 {'type':'length','rule':{'max':'50','maxm':'长度不能大于50'}},
	             {'type':'custom','rule':{'against':checkName, 'm':'名称只能为汉字、数字、字母、下划线、正斜杠、中英文括号。'}},
	             {'type':'custom','rule':{'against':isExistDictionaryTypeName, 'm':'字典分类名称已存在。'}}
		    ];
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
		function isExistDictionaryTypeCode(typeCode){
			var isExist = false;
			if(operationType=="edit"){
			   var checkVO = {id:dictionaryClassifyId,dictionaryCode:typeCode};
			}else{
			   var checkVO = {dictionaryCode:typeCode};
			}
			dwr.TOPEngine.setAsync(false);
			TestmodelDicClassifyAction.isExitClassifyCode(checkVO, function(data){
				isExist = !data;
			});
			dwr.TOPEngine.setAsync(true); 
			return isExist;
		}
		
		/**     
		 * 检查类型模版分类名称是否存在
		 */  
		function isExistDictionaryTypeName(typeName){
			var isExist = false;
			if(operationType=="edit"){
			   var checkVO = {id:dictionaryClassifyId,dictionaryName:typeName};
			}else{
			   var checkVO = {dictionaryName:typeName};
			}
			dwr.TOPEngine.setAsync(false);
			TestmodelDicClassifyAction.isExitClassifyName(checkVO, function(data){
				isExist = !data;
			});
			dwr.TOPEngine.setAsync(true); 
			return true;
		}
	</script>
</body>
</html>