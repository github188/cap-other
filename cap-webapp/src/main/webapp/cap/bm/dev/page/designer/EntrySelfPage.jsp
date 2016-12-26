<%
/**********************************************************************
* 页面列表
* 2015-6-23 章尊志 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/ptc/index/image/definePage.png">
<title>页面列表</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
	
	<script type="text/javascript">
	var openType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("openType"))%>;//listToMain
	var pageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
	//packageId左侧树的模块ID
	var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	var saveType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("saveType"))%>;
	
	
	var modelPackage="";
	var page={};
	jQuery(document).ready(function() {
		dwr.TOPEngine.setAsync(false);
		PageFacade.loadModel(pageId,packageId,function(result){
			
			   page=result;
			   //如果是新增页面则自动生产一个随机id
			   if(pageId==null || pageId=="" ||saveType=="pageTemplate"){
				   pageId="page"+(new Date()).valueOf();
			   }
			   
			   modelPackage=page.modelPackage;
			   
			   var rootPath=page.modelPackage.replace("com.comtop.","");
			   page.code = rootPath;
			});
		//console.log(page);
		dwr.TOPEngine.setAsync(true);
		comtop.UI.scan();
		 showReturnOrClose();
	});
	
	   //显示关闭或者是返回按钮
	   function showReturnOrClose(){
		     if(openType=="listToMain"){
		    	 cui("#close").hide();
		     }else{
		    	 cui("#closeTemplate").hide();
		     }
	   }
	
		/**
		 * 编辑Grid数据加载
		 * @param obj {Object} Grid组件对象
		 * @param query {Object} 查询条件
		 */
		function initData(obj, query) {
			 var iSize = page.pageAttributeVOList.length;
			 obj.setDatasource(page.pageAttributeVOList,iSize);
		}
	
		//确定,选择模板为页面
		function saveToSelfPage(){
			var map = window.validater.validAllElement();
	        var inValid = map[0];
	        var valid = map[1];
	       	//验证基本属性是否通过
			if(inValid.length == 0){
			 var attibuteData = cui("#myTable").getData();	
			 if(attibuteData.length >0 ){
				 var str = "";
				 var strRow = "";
				 var rowNum ;
				 //先验证数据不为空
				 for(var i =0;i<attibuteData.length;i++){
					 strRow = "";
					 rowNum = i + 1;
					 if(attibuteData[i].attributeName == "" &&attibuteData[i].attributeType == ""){
						 strRow = "页面参数区域第" +rowNum +"行，参数名称不能为空。参数类型不能为空。<br>"
					 }else if(attibuteData[i].attributeName == "" ){
						 strRow = "页面参数区域第" +rowNum +"行，参数名称不能为空。<br>"
					 }else if(attibuteData[i].attributeType == "" ){
						 strRow = "页面参数区域第" +rowNum +"行，参数类型不能为空。<br>"
					 }
					 if(strRow!=""){
					 str += strRow;
					 }
				 }
				 if(str!=""){
				   cui.alert(str,null,{
					   title:'提示',
					   width: 420
				    });
				   return;
				 }
				 //再验证，默认值是否正确
				 for(var i =0;i<attibuteData.length;i++){
					 strRow = "";
					 rowNum = i + 1;
					 if(attibuteData[i].attributeType != "" &&attibuteData[i].attributeValue != ""){
						 if(attibuteData[i].attributeType=="int"){
							 var re=/^-?[0-9]\d*$/;
							 if(!attibuteData[i].attributeValue.match(re)){
							 strRow = "页面参数区域第" +rowNum +"行，默认值不是int类型。<br>" 
							 }
						 }else if(attibuteData[i].attributeType=="boolean"){
							 if(attibuteData[i].attributeValue!="true"&&attibuteData[i].attributeValue!="false"){
							 strRow = "页面参数区域第" +rowNum +"行，默认值不是boolean类型。<br>" 
							 }
						 }else if(attibuteData[i].attributeType=="double"){
							 var reg1=/^-?([0-9]\d*|0(?!\.0+$))\.\d+?$/;
							 var reg2=/^-?[0-9]\d*$/;
							if(!(reg1.test(attibuteData[i].attributeValue) || reg2.test(attibuteData[i].attributeValue))){
							 strRow = "页面参数区域第" +rowNum +"行，默认值不是double类型。<br>" 
							 }
						 }
						 if(strRow!=""){
							 str += strRow;
							 }
					 }
				 }
				 if(str!=""){
					   cui.alert(str,null,{
						   title:'提示',
						   width: 420
					    });
					   return;
					 }
				 saveSelfPageData();
			 }else{
				 saveSelfPageData();
			 }
			}
		  }
		
		//保存具体的页面数据
		function saveSelfPageData(){
			page = cui(page).databind().getValue();
			page.cname = page.modelName;
			page.pageAttributeVOList = cui("#myTable").getData();
			var rootCode=modelPackage.replace("com.comtop.","");
			var code = rootCode + "."+ cui("#modelName").getValue();
			page.code = code;
			page.pageType = 2;//设置为录入页面的类型
			if(page.modelId==null || saveType=="pageTemplate"){
			    page.modelId=page.modelPackage+"."+page.modelType+"."+page.modelName;
			}
			dwr.TOPEngine.setAsync(false);
		    PageFacade.saveModel(page,function(result){
		    	page.pageId = result.pageId;
		    	if(result){
			    	cui.message('页面保存成功！', 'success');
			    }else{
				    cui.error("页面保存失败！"); 
			    }
			    if(openType!="listToMain"){
					if(window.opener && window.opener.refresh){
						window.opener.refresh();
					}	
					window.focus();
				}
		    });
		    dwr.TOPEngine.setAsync(true);
		    //生成数据脚本sql文件
		    var codePath= cui.utils.getCookie("GEN_CODE_PATH_CNAME");
		    saveTopPageSQL(page, codePath);
		}
		
		 //生成数据脚本sql文件
	    function saveTopPageSQL(page, codePath) {
			//生成数据脚本sql文件
			PageFacade.saveTopPageSQL(page, codePath, function(result) {
			});
		}
		
		//单元格编辑类型
		var edittype = {
		    "attributeName" : {
		        uitype: "Input",
		        validate: [
		                   {
		                       type: 'required',
		                       rule: {
		                           m: '不能为空'
		                       }
		                   }
		               ]
		    },
		    "attributeDescription": {
		        uitype: "Input"
		    },
		    "attributeType": {
		    	uitype: "PullDown",
		        mode: "Single",
		        //value: "String",
		        select:"0", 
		        datasource: [
		            {id: "String", text: "String"},
		            {id: "int", text: "int"},
		            {id: "boolean", text: "boolean"},
		            {id: "double", text: "double"}
		        ],
		        validate: [
		                   {
		                       type: 'required',
		                       rule: {
		                           m: '不能为空'
		                       }
		                   }
		               ]
		    },
		    "attributeValue" : {
		        uitype: "Input"
		    }
		};
		
		//编码改动事件，编码随页面名称改变
		//function changeCode(){
		//	var rootCode=modelPackage.replace("com.comtop.","");
		//	var code = rootCode + "."+ cui("#modelName").getValue();
		//	cui("#code").setValue(code);
		//}
		
		/**
		 * 删除选择行
		 */
		function deleteSelectedRow() {
		    cui("#myTable").deleteSelectRow();
		}
		
		/**
		 * 插入一行数据
		 */
		function insertRow(a, b, mark) {
			cui("#myTable").insertRow({}, mark ? mark - 0 : undefined);
		}
		
		
		//返回
		function back(){
			var attr="packageId="+packageId;
			window.location="../PageHome.jsp?"+attr;	  
		}
		
		function getBodyWidth() {
		    return (document.documentElement.clientWidth || document.body.clientWidth) - 35;
		}
		
		function getBodyHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 345;
		}
		
		function openCatalogSelect(){
			var top=(window.screen.availHeight-600)/2;
    		var left=(window.screen.availWidth-400)/2;
    		window.open ('../designer/CatalogSelect.jsp?packageId='+packageId,'CatalogSelectWin','height=600,width=400,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
		}
		
		//设置上级目录
		function setCatalog(node){
			page.parentName=node.title;
			page.parentId=node.key;
			cui("#parentName").setValue(node.title);
		}
		
		   function closeWindow(){
			   if(window.parent){
				   window.parent.close();
			   }else{
				   window.close();
			   }
		   }
		
	</script>
</head>
<body style="background-color:#f5f5f5;">
<div id="pageRoot" class="cap-page">
	<div id="chooseCopyPage" class="cap-area" style="width:100%;dispaly:none;">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;padding:5px">
		        	<span id="formTitle" uitype="Label" value="自定义页面录入" class="cap-label-title" size="12pt"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;padding:5px">
		        	<span id="saveToPage" uitype="Button" onclick="saveToSelfPage()" label="保存"></span> 
					<span id="closeTemplate" uitype="Button" onclick="back()" label="返回"></span> 
					<span id="close" uitype="Button" label="关闭" onclick="closeWindow()"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span>
			        	<blockquote class="cap-form-group">
							<span>页面属性</span>
						</blockquote>
					</span>
		        </td>
		    </tr>
		</table>
		<table class="form_table" style="table-layout:fixed;">
						<tr>
							<td  class="td_label" style="text-align: right;width:15%">
								<font color="red">*</font>页面文件名称：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span uitype="input"  id="modelName" databind="page.modelName" width="90%" on_keydown="changeCode" validate="[{'type':'required', 'rule':{'m': '页面文件名称不能为空'}}]"></span>
					        </td>
							
							<td  class="td_label" style="text-align: right;width:15%">
								<font color="red">*</font>上级菜单/目录：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span uitype="clickInput" id="parentName" width="90%" databind="page.parentName" validate="[{'type':'required', 'rule':{'m': '上级菜单/目录不能为空'}}]" onclick="openCatalogSelect()"></span>
					        </td>
						</tr>
						<tr id="funcCodeTr">
							 <td class="td_label" style="text-align: right;width:15%">
					        	<font color="red">*</font>页面标题：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span uitype="input"  id="cname" width="90%" databind="page.cname" validate="[{'type':'required', 'rule':{'m': '页面标题不能为空'}}]" readonly="false"></span>
					        </td>
							 <td class="cap-td" style="text-align: right;width:100px"> <font color="red">*</font>需要授权： </td>
							<td class="cap-td"  style="text-align: left;">
								<span uitype="RadioGroup" name="hasPermission" width="100%" id="hasPermission" value="false"  databind="page.hasPermission" validate="请选择是否需要授权。"> 
									<input type="radio" name="hasPermission" value="true"/>是
	                				<input type="radio" name="hasPermission" value="false"/>否
								</span> 
							</td>
						</tr>
						<td  class="td_label" style="text-align: right;width:15%">
								<font color="red">*</font>链接地址：
					        </td>
					        <td class="td_content" colspan="3" style="text-align: left;width:90%">
					        	<span uitype="input"   id="url" width="95%" databind="page.url" readonly="false" validate="[{'type':'required', 'rule':{'m': '链接地址不能为空'}}]"></span>
					        </td>
						<tr>
							<td  class="td_label" style="text-align: right;width:10%">描述：
							</td>
							<td class="td_content" colspan="3">
								<div style="width:95%;">
									<span uitype="textarea" name="description" databind="page.description" 
										relation="remarkLength" maxlength="500" width="100%"></span>
									<div style="float:right">
										<font id="applyRemarkLengthFont" >(您还能输入<label id="remarkLength" style="color:red;"></label>&nbsp; 字符)</font>
									</div>
								</div>
							</td>
						</tr>
				</table>
	
<div>
    <table class="cap-table-fullWidth">
		<tr>
		     <td class="cap-td" style="text-align: left;padding:5px">
				  <span class="cap-form-group">页面参数</span>
		     </td>
		     <td class="cap-td" style="text-align: right;padding:5px">
		         <span uitype="button" on_click="insertRow" label="新增"></span>
                 <span uitype="button" on_click="deleteSelectedRow" label="删除"></span>
		     </td>
		</tr>
	</table>
    <div style="padding:5px">
    <table id="myTable" uitype="EditableGrid" datasource="initData" edittype="edittype" resizeheight="getBodyHeight" resizewidth="getBodyWidth" primarykey="userId" pagination="false">
       <thead>
         <tr>
            <th style="width:25px"></th>
            <th style="width:35px" renderStyle="text-align: center" bindName="1">序号</th>
            <th style="width:20%" bindName="attributeName">参数名称</th>
            <th style="width:30%" renderStyle="text-align: center" bindName="attributeDescription">参数描述</th>
            <th style="width:20%" renderStyle="text-align: center" bindName="attributeType">参数类型</th>
            <th style="width:30%" renderStyle="text-align: center" bindName="attributeValue">默认值</th>
        </tr>
      </thead>
     </table>
     </div>
</div>
	
	</div>
</div>
</body>
</html>