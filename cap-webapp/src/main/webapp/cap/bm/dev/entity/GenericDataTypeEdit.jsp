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
    <title>泛型设置界面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/EntityFacade.js'></top:script>
    <top:script src="/cap/bm/common/jct/js/jct.js"></top:script>
	<style type="text/css">
		img{
		  margin-left:5px;
		}
	</style>
</head>
<body>
		<table class="cap-table-fullWidth" width="100%">
		<tr>
		    <td class="cap-td" style="text-align: left;width:70px;padding-left:15px" nowrap="nowrap">
				<span uitype="Label" value="属性来源："></span>
			</td>
			<td class="cap-td" style="text-align: left;width:80%" nowrap="nowrap">
				<span id="attributeTypeSource" uitype="PullDown" databind="" select="0" editable="false" on_change="attributeTypeSourceChangeEvent" value_field="id" label_field="text" width="100%">
							<a value="primitive">基本类型</a>
							<a value="entity">关联实体</a>
							<a value="collection">集合</a>
							<a value="javaObject">对象</a>
							<a value="thirdPartyType">第三方类型</a>
				</span>
			</td>
			</tr>
			<tr id="primitive">
			<td class="cap-td" style="text-align: left;width:100px;padding-left:15px" nowrap="nowrap">
				<span uitype="Label" value="属性类型："></span>
			</td>
			<td class="cap-td" style="text-align: left;width:80%" nowrap="nowrap">
				<span  id="primitiveAttributeType" uitype="PullDown" databind="" select="0" editable="false" on_change="primitiveTypeChangeEvent"  value_field="id" label_field="text" width="100%">
					<a value="String">String</a>
					<a value="int">int</a>
					<a value="boolean">boolean</a>
					<a value="double">double</a>
					<a value="byte">byte</a>
					<a value="shot">shot</a>
					<a value="long">long</a>
					<a value="float">float</a>
					<a value="char">char</a>
					<a value="java.sql.Date">java.sql.Date</a>
					<a value="java.sql.Timestamp">java.sql.Timestamp</a>
				</span>
			</td>
		   </tr>
		   <tr id="collection">
			<td class="cap-td" style="text-align: left;width:100px;padding-left:15px" nowrap="nowrap">
				<span uitype="Label" value="属性类型："></span>
			</td>
			<td class="cap-td" style="text-align: left;width:80%" nowrap="nowrap">
				<span  id="collectionAttributeType" uitype="PullDown" databind="" select="0" editable="false" on_change="collectionTypeChangeEvent" value_field="id" label_field="text" width="100%">
					<a value="java.util.List">java.util.List</a>
					<a value="java.util.Map">java.util.Map</a>
				</span>
				<!-- <span id="addCollection" uitype="Button" onclick="addCollection()" label="增加"></span>  -->
			</td>
		   </tr>
		   <tr id="javaObject">
			<td class="cap-td" style="text-align: left;width:100px;padding-left:15px" nowrap="nowrap">
				<span uitype="Label" value="属性类型："></span>
			</td>
			<td class="cap-td" style="text-align: left;width:80%" nowrap="nowrap">
				<span  id="javaObjectAttributeType" uitype="Input" value="java.lang.Object" readonly="true" databind="" editable="false" width="100%">
				</span>
			</td>
		   </tr>
		   <tr id="thirdPartyType">
			<td class="cap-td" style="text-align: left;width:100px;padding-left:15px" nowrap="nowrap">
				<span uitype="Label" value="属性类型："></span>
			</td>
			<td class="cap-td" style="text-align: left;width:80%" nowrap="nowrap">
				<span  id="thirdPartyTypeAttributeType" uitype="Input" databind="" width="85%">
				</span>
				<span id="addThirdPartyType" uitype="Button" onclick="addThirdPartyType()" label="增加"></span> 
			</td>
		   </tr>
		   <tr id ="entity">
			<td class="cap-td" style="text-align: left;width:100px;padding-left:15px" nowrap="nowrap">
				<span uitype="Label" value="关联实体："></span>
			</td>
			<td class="cap-td" style="text-align: left;width:80%" nowrap="nowrap">
				<span id="otherEntityAttributeTypeValue"  uitype="ClickInput" databind="" on_iconclick="selEntity" width="100%"></span>
			</td>
		   </tr>
		</table>
	<script type="text/javascript">
	var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
	var node = window.parent.getCurrentNode();
	//识别触发泛型是否来之服务实体
	$(document).ready(function(){
		comtop.UI.scan();   //扫描
		showAttributeType(node.getData().source);
		if(node.getData().rootflag==true){
			cui("#attributeTypeSource").setReadonly(true);
	    	cui("#collectionAttributeType").setReadonly(true);
	    	cui("#collectionAttributeType").setWidth("100%");
	    	cui("#addCollection").hide();
	    }else{
	    	cui("#attributeTypeSource").setReadonly(false); 
	    	cui("#collectionAttributeType").setReadonly(false);
	    	cui("#collectionAttributeType").setWidth("85%");
	    	cui("#addCollection").show();
	    }
		setEditorUIValue();
	});
	
	//根据属性来源显示属性类型
	function showAttributeType(attributeSource){
		cui("#primitive").css('display', 'none');  
		cui("#entity").css('display', 'none');  
		cui("#collection").css('display', 'none');  
		cui("#collection1").css('display', 'none');  
		cui("#javaObject").css('display', 'none');  
		cui("#thirdPartyType").css('display', 'none');  
		if(attributeSource=="primitive"){
			cui("#primitive").css('display', '');  
		}else if(attributeSource=="entity"){
			cui("#entity").css('display', ''); 
		}else if(attributeSource=="collection"){
			cui("#collection").css('display', '');
		}else if(attributeSource=="javaObject"){
			cui("#javaObject").css('display', '');  
		}else if(attributeSource=="thirdPartyType"){
			cui("#thirdPartyType").css('display', '');  
		}
	}
	
	function setEditorUIValue(){
		var attributeSource = node.getData().source;
		var attributeType = node.getData().type
		cui("#attributeTypeSource").setValue(attributeSource);
	    if(attributeSource=="primitive"){
	        cui("#primitiveAttributeType").setValue(attributeType);
	    }else if(attributeSource=="collection"){
	        cui("#collectionAttributeType").setValue(attributeType); 
	    }else if(attributeSource=="javaObject"){
	        cui("#javaObjectAttributeType").setValue(attributeType);  
	    }else if(attributeSource=="thirdPartyType"){
	        cui("#thirdPartyTypeAttributeType").setValue(node.getData().value);
	    }else if(attributeSource=="entity"){
	        cui("#otherEntityAttributeTypeValue").setValue(node.getData().value);  
	    }
	}
	
	//属性来源改变事件
	function attributeTypeSourceChangeEvent(data,oldData){
		if(data==null){
			return;
		}
		if(node.getData().rootflag==true){
			return;
		}
		var attributeSource = data.id;
		showAttributeType(attributeSource);
		if(attributeSource != node.getData().source){
			node.removeChildren();
			node.getData().children=null;
			node.getData().source = attributeSource;
			setNodeTitle(data.text);
			if(attributeSource=="javaObject"){
				var objType = 'java.lang.Object'; 
				setNodeTitle(objType);
				node.getData().type = objType;
				node.getData().value = "";
				refreshNode(node);
			}
			else if(attributeSource == 'collection'){
				var objType = 'java.util.List';
				setNodeTitle(objType);
				node.getData().type = objType;
				node.getData().value = "";
				var childNode = window.parent.createCollectionChild(objType, node.getData().key);
				node.addChild(childNode);
				node.setLazyNodeStatus(node.ok);
			}else if(attributeSource == 'entity'){
				setNodeTitle(modelId);
				node.getData().type = "entity";
				node.getData().value = modelId;
				refreshNode(node);
			}else if(attributeSource == 'thirdPartyType'){
				setNodeTitle('第三方类型');
				node.getData().type = 'thirdPartyType';
				node.getData().value = 'java.lang.Object'; 
				refreshNode(node);
			}else if(attributeSource=='primitive'){
				var objType = 'String';
				setNodeTitle(objType);
				node.getData().type = objType;
				node.getData().value = "";
				refreshNode(node);
			}
			setEditorUIValue();
		}
	}
	
	function setNodeTitle(title){
		var titlePrefix = '';
		if(node.getData().childrenType != ''){
			titlePrefix = node.getData().childrenType+':'
		}
		node.getData().title = titlePrefix+title;
	}
	
	function refreshNode(newNode){
		var parentNode = window.parent.getCurrentNodeParent();
		var newNodeData = newNode.getData();
		newNodeData.activate = true;
		parentNode.addChild(newNodeData,newNode);
		parentNode.setLazyNodeStatus(parentNode.ok);
		newNode.remove();
		node = window.parent.getCurrentNode();
	}
	
	//基本类型，属性类型发生变化
	function primitiveTypeChangeEvent(data,oldData){
		if(data==null){
			return;
		}
		node.getData().type= data.id;
		setNodeTitle(data.text);
		node.getData().value = "";
		refreshNode(node);
	}
	
	//属性类型改变事件
	function collectionTypeChangeEvent(data,oldData){
		if(data==null){
			return;
		}
		if(node.getData().rootflag==true){
			return;
		}
		node.removeChildren();
		node.getData().type= data.id;
		setNodeTitle(data.text);
		node.getData().value = "";
		if(data.id == 'java.util.List' || data.id == 'java.util.Map'){
			var childNode = window.parent.createCollectionChild(data.id, node.getData().key);
			node.addChild(childNode);
		}
		node.setLazyNodeStatus(node.ok);
	}
	
	//第三方类型添加后的保存
	function addThirdPartyType(){
		var thirdPartyType = cui("#thirdPartyTypeAttributeType").getValue();
		if(thirdPartyType == '' || !checkClassExist(thirdPartyType)){
			cui.alert('第三方类型不存在，请重新输入。');
			return;
		}
		node.getData().type = node.getData().source;
		setNodeTitle(thirdPartyType);
		node.getData().value = thirdPartyType;
		refreshNode(node);
	}
	
	//检查第三方类型是否还存在
	function checkClassExist(thirdPartyType){
		var isExist = false;
		dwr.TOPEngine.setAsync(false);
		EntityFacade.checkClassExist(thirdPartyType,function(result){
			isExist = result;
		});
		dwr.TOPEngine.setAsync(true);
		return isExist;
	}

	//实体选择
	var dialog;
	function selEntity(){
		var sourceEntityId = cui("#otherEntityAttributeTypeValue").getValue();
		sourceEntityId = sourceEntityId ? sourceEntityId : modelId;

		var url = "SelSystemModelMain.jsp?sourcePackageId=" + packageId + "&isSelSelf=true&showClean=false&sourceEntityId="+sourceEntityId;
		var title="选择目标实体";
		var height = 600; //600
		var width =  400; // 680;
		var top = '2%';
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height,
			top : top
		})
		dialog.show(url);
	}
	
	//实体选择界面取消按钮
	function closeEntityWindow(){
		if(dialog){
			dialog.hide();
		}
	}
	
	//实体选择回调
	function selEntityBack(selectNodeData) {
		cui("#otherEntityAttributeTypeValue").setValue(selectNodeData.modelId);
		node.getData().type = node.getData().source;
		setNodeTitle(selectNodeData.modelId);
		node.getData().value = selectNodeData.modelId;
		if(dialog){
			dialog.hide();
		}
		refreshNode(node);
	}


	</script>
</body>
</html>