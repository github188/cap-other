<%
/**********************************************************************
* 属性泛型设置界面
* 2015-10-9 章尊志 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>属性泛型设置界面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/jct/js/jct.js"></top:script>
	<style type="text/css">
		img{
		  margin-left:5px;
		}
	</style>
</head>
<body>
<div uitype="Borderlayout"  id="body"  is_root="true"> 
		<div id="leftMain" position="left" style="overflow:hidden" width="200" collapsable="true" show_expand_icon="false">       
			<div id="genericTree" uitype="Tree" children="genericData" 
                     on_dbl_click="dbClickNode" on_lazy_read="loadNode" on_click="treeClick" click_folder_mode="1">
            </div>
       	</div>
		<div id="centerMain" position ="center">
			<div uitype="Borderlayout"  id="AttributeLayout"  is_root="false"> 
				<div position="top" height="42">
					<table id ="buttonTable" class="cap-table-fullWidth" width="100%">
		    			<tr>
		        			<td class="cap-td" style="text-align: left;padding:5px">
		        				<span id="formTitle" uitype="Label" value="属性泛型编辑" class="cap-label-title" size="12pt"></span>
		        			</td>
		        			<td class="cap-td" style="text-align: right;padding:5px">
		            			<!--   <span id="add" uitype="Button" onclick="add()" label="新增"></span>  -->
		        	 			<span id="addGeneric" uitype="Button" onclick="addGeneric()" label="确定"></span> 
			         			<span id="cancel" uitype="Button" onclick="cancel()" label="关闭"></span> 
		        			</td>
		    			</tr>
					</table>
				</div>
				<div id = "dataTypeEditDiv" position="center">
				</div>
		</div>
	</div>
</div>
	<script type="text/javascript">
	//获得传递参数
    var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
    var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
    var openType = 'newWin' == <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("openType"))%>?true:false;
	var genericList = getGenericList();
    var attributeType = getType();
    function getGenericList(){
    	if(openType){
    		return window.opener.getGenericList();
    	}
    	if(window.parent.getDataTypeGenericList){
    		return window.parent.getDataTypeGenericList();
    	}
    	return window.parent.scope.selectEntityAttributeVO.attributeType.generic==null?[]:window.parent.scope.selectEntityAttributeVO.attributeType.generic;
    }
    function getType(){
    	if(openType){
    		return window.opener.getType();
    	}
    	if(window.parent.getDataType){
    		return window.parent.getDataType();
    	}
    	return window.parent.scope.selectEntityAttributeVO.attributeType.type;
    }
    //组装泛型树形数据
    if(genericList.length>0){
    	//根据泛型初始化树
    	var genericData =initTreeData();
    }else{
    	var genericData = createCollectionNode(attributeType);
    }
	    //根据泛型初始化树
    function initTreeData(){
    	var iNum = getNodeKeyRandomNum();
       	var genericData =[{ 
           title:attributeType,
	       key:"div_"+iNum,
	       expand: true,
	       isFolder: true,
	       activate:true,
	       source:"collection",
	       type:attributeType,
	       value:"",
	       rootflag:true,
	       children:[]
		  }];
       getChildren(genericList,genericData[0].children,genericData[0]);
       return genericData;
	}  
	    
	 //迭代初始化树数据
	function getChildren(genericList,resultArr,parentNode){
	    for(var i = 0, len = genericList.length; i < len; i++){
	    	var objGeneric = genericList[i];
	    	var showTitle = objGeneric.type;
	    	if(objGeneric.type=="entity" || objGeneric.type=="thirdPartyType"){
	    		showTitle = objGeneric.value;
	    	}
	    	var genericChildren = {
	    		       expand: true,
	    		       isFolder: true,
	    		       source:objGeneric.source,
	    		       type:objGeneric.type,
	    		       value:objGeneric.value,
	    		       childrenType:strChildrenType,
	    		       parentType:parentNode.type,
	    		       children:[]};
	    	var strChildrenType ="";
	    	var keySufix='_Item_Type';
	    	if(parentNode.type=="java.util.Map"){
	    		if(i==0){
	    			keySufix = '_Key_Type';
	    			strChildrenType ="key";
	    			showTitle = "key:"+showTitle
	    		}else if(i==1){
	    			strChildrenType ="value";
	    			keySufix = '_Value_Type';
	    			showTitle = "value:"+showTitle
	    		}
	    	}
	    	genericChildren.title= showTitle;
	    	genericChildren.key=parentNode.key+keySufix
	    	genericChildren.childrenType = strChildrenType;
	    	resultArr.push(genericChildren);
	    	if(Array.isArray(objGeneric.generic) && objGeneric.generic.length > 0){
	    		arguments.callee(objGeneric.generic,genericChildren.children,genericChildren);
	    	}
	    }
	 }

	function createCollectionNode(attType){
		var iNum = getNodeKeyRandomNum();
		var mapNode = [{ 
				 title:attType,
				 key:"div_"+iNum,
				 expand: true,
				 isFolder: true,
				 source:"collection",
				 type:attType,
				 value:"",
				 childrenType:"",
				 rootflag:true,
				 activate:true,
				 children:[]		 	
		}];
		mapNode[0].children = createCollectionChild(attType,mapNode[0].key);
		return mapNode;
	}
		
	function getNodeKeyRandomNum(){
		return Math.ceil(Math.random()*100000000);
	}

	function createCollectionChild(attType,parentKey){
			var childNode = [];
			if('java.util.List' == attType){
				childNode = [{
			    	 title:"java.lang.Object",
					 key:parentKey+'_Item_Type',
					 expand: true,
					 isFolder: true,
					 source:"javaObject",
					 type:"java.lang.Object",
					 value:"",
					 childrenType:"",
					 parentType:"java.util.List",
					 children:[]
			     }];
			}else if('java.util.Map' == attType){
				childNode = [{
					 title:"key:java.lang.Object",
					 key:parentKey+'_Key_Type',
					 expand: true,
					 isFolder: true,
					 source:"javaObject",
					 type:"java.lang.Object",
					 value:"",
					 childrenType:"key",
					 parentType:"java.util.Map",
					 children:[]
				 },{
					 title:"value:java.lang.Object",
					 key:parentKey+'_Value_Type',
					 expand: true,
					 isFolder: true,
					 source:"javaObject",
					 type:"java.lang.Object",
					 value:"",
					 childrenType:"value",
					 parentType:"java.util.Map",
					 children:[]
				 }]	;
			}
			return childNode;
	}
	
	//树单击事件,根据点击事件，设置右边的属性编辑值
	function treeClick(node){
		var url='GenericDataTypeEdit.jsp?nodeKey='+node.key+'&packageId='+packageId+'&modelId='+modelId;
		cui('#AttributeLayout').setContentURL('center', url);
	}
	
	function getCurrentNode(){
		return cui("#genericTree").getActiveNode();
	}
	
	function getCurrentNodeParent(){
		return cui("#genericTree").getActiveNode().parent();
	}
	 
	$(document).ready(function(){
		comtop.UI.scan();   //扫描
		var url='GenericDataTypeEdit.jsp?packageId='+packageId+'&modelId='+modelId;
		cui('#AttributeLayout').setContentURL('center', url);
	});
	
	//泛型字符串设置
	var genericString = "";
	var iCount =0;
	//新增泛型类型
	function addGeneric(){
		var treeData = cui("#genericTree").getDatasource();
		getGenericString(treeData);
		for(var i = 0;i<iCount ;i++){
			genericString += ">";
		}
		var genericDataList = [];
		mergeGeneric(treeData[0].children,genericDataList);
		if(openType){
			window.opener.setGeneric(genericString,genericDataList);
			window.close();
		}else{
			window.parent.setGeneric(genericString,genericDataList);
		}
	}
	
	
	function getGenericString(genericData){
		 for(var i = 0, len = genericData.length; i < len; i++){
			 var objChildren = genericData[i];
			 if(objChildren.type=="java.util.List"||objChildren.type=="java.util.Map"){
				 genericString += objChildren.type +"<";
				 iCount++;
			 }else{
				 if(objChildren.childrenType=="key"){
					 if(objChildren.parentType=="java.util.List"){
						 if(objChildren.type=="entity"|| objChildren.type=="thirdPartyType"){
						     genericString += objChildren.value + ">,"; 
						 }else{
							 genericString += objChildren.type + ">,";  
						 }
						 iCount--;
					 }else{
						 if(objChildren.type=="entity"|| objChildren.type=="thirdPartyType"){
							 genericString += objChildren.value + ","; 
						 }else{
						     genericString += objChildren.type + ","; 
						 }
					 }
					 
				 }else if(objChildren.childrenType=="value"){
					 if(objChildren.parentType=="java.util.List"){
						 if(objChildren.type=="entity"|| objChildren.type=="thirdPartyType"){
							 genericString += objChildren.value + ">>";
						 }else{
						     genericString += objChildren.type + ">>";
						 }
						 iCount--;
						 iCount--;
					 }else{
						 if(objChildren.type=="entity" || objChildren.type=="thirdPartyType"){
							 genericString += objChildren.value + ">";
						 }else{
							 genericString += objChildren.type + ">";
						 }
						
						 iCount--;
					 }
				 }else{
					 if(objChildren.type=="entity" || objChildren.type=="thirdPartyType"){
						 genericString += objChildren.value + ">"; 
					 }else{
						 genericString += objChildren.type + ">"; 
					 }
					 iCount--;
				 }
			 }
			 if(Array.isArray(objChildren.children) && objChildren.children.length > 0){
				 	arguments.callee(objChildren.children);
		    } 
		 }	
	}
	
	//组装后台需要的泛型数据
	function mergeGeneric(childrens,genericDataList){
        for(var i = 0, len = childrens.length; i < len; i++){
        	var objChildren = childrens[i];
        	var dataTypeVO = {source:objChildren.source,type:objChildren.type,value:objChildren.value,generic:[]};
        	if(objChildren.childrenType=="value"){
        		genericDataList.splice(1,0,dataTypeVO);
        	}else if(objChildren.childrenType=="key"){
        		genericDataList.splice(0,0,dataTypeVO);
        	}else{
	        	genericDataList.push(dataTypeVO);
        	}
        	if(Array.isArray(objChildren.children) && objChildren.children.length > 0){
	    		arguments.callee(objChildren.children,dataTypeVO.generic);
	    	}
        }
	}
	
	//实体选择界面取消按钮
	function closeEntityWindow(){
		if(dialog){
			dialog.hide();
		}
	}
	
	function cancel(){
		if(openType){
			window.close();
		}else{
			window.parent.genericDialog.hide();
		}
	}
	</script>
</body>
</html>