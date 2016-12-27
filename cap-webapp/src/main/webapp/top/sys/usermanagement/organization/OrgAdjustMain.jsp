<%
  /**********************************************************************
			 * 组织调整
			 * 2014-07-30  汪超  新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
    <title>组织调整 </title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/usermanagement/organization/css/orgAdjust.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/OrganizationAction.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/GradeAdminAction.js"></script>
</head>
<body>
     <div uitype="Borderlayout" id="border" is_root="true">
        <div position="top" height="100px" id="leadingAreaDiv" >
          <div style="width: 700px;margin: 0 auto;">
        	<div class="step_1" id="leadingHead"></div>
        	<div uitype="button" on_click="preview" label="上一步" id="preview" class="leading_button_style leading_button_left_style" ></div>
        	<div uitype="button" on_click="next" label="下一步" id="next" class="leading_button_style leading_button_right_style" disable="true" style="display: block;" button_type="green-button"></div>
        	<div uitype="button" on_click="finish" label="完&nbsp;&nbsp;&nbsp;成" id="finish" class="leading_button_style leading_button_right_style" button_type="green-button"></div>
          </div>
        </div>
        <div position="center" id="operateAreaDiv" >
	         <div class="sourceDiv" id="sourceDiv"  style="text-align: left;overflow-y:auto; ">
	         <div class="operateAreaHeadStyle">源组织</div><hr>
	           &nbsp;<label style="font-size: 14px;">组织结构：</label>
			        <div uitype="radioGroup" name="orgStructureId" id="orgStructure" on_change="changeOrgStructure" radio_list="initOrgStructure"> 
					</div>
					<div uitype="tree" id="treeDiv" on_click="treeClick" on_lazy_read="lazyData" click_folder_mode="1" on_expand="onExpand" ></div>
	         </div>
			 <div class="imgDiv" id="imgDiv" style="display:inline-block;margin: 0 auto;">
			 	<img title="选中源组织到目标组织" src="${pageScope.cuiWebRoot}/top/sys/images/arrow.png" width="64px" height="64px" style="margin-bottom: 310px;"/>
			 </div>
			 <div class="destDiv" id="destDiv" style="text-align: left;overflow-y:auto; ">
			 <div class="operateAreaHeadStyle">目标组织</div><hr>
			 	&nbsp;<label style="font-size: 14px;">组织结构：</label>
			        <div uitype="radioGroup" name="orgStructureId1" id="orgStructure1" radio_list="initOrgStructure" readonly="true"> 
					</div>
					<div uitype="tree" id="treeDiv1" on_click="treeClick" on_lazy_read="lazyData" click_folder_mode="1" on_expand="onExpand" ></div>
			 </div>
			 <div class="afterAdjustDiv" id="afterAdjustDiv" style="display:none;text-align: left;margin-left: 22px;overflow-y:auto; ">
			 	<div class="operateAreaHeadStyle">调整后</div><hr>
			 	<div uitype="tree" id="previewTree" on_lazy_read="previewTreeLazyData" on_click="clickPreviewTree" click_folder_mode="1" on_expand="onExpand" ></div>
			 </div>
			 <div class="adjustOrgCodeDiv" id="adjustOrgCodeDiv" style="display:none;border: 0;margin-left: 90px;">
			 	<label class="label_head_style">调整组织编码</label>
			 	<label class="label_style">&nbsp;注：标<font color="red">“红”</font>的组织编码冲突，须调整:</label>
			 	<label class="label_style" style="padding-right: 80px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;左侧选择，右侧修改。</label>
			 	<table id="confictTable" style="clear:both;float:left;">
			 	</table>
			 </div>
			 <div class="adjustOrgTypeDiv" id="adjustOrgTypeDiv" style="display:none;border: 0;margin-left: 90px;">
			 	<label class="label_head_style">组织类型调整（可选）</label>
			 	<label class="label_style">&nbsp;注：左侧选择，右侧修改。</label>
			 	<label class="label_style">&nbsp;组织类型：</label>
			  	<span  class="label_style" uitype="singlePullDown" id="orgType" name="orgType" datasource="initOrgTypeData" on_change="selectOrgType" empty_text="请选择"
			  		editable="false" label_field="orgTypeName" value_field="orgType""></span>
			 	<table id="orgTypeTable" style="clear:both;float: left;">
			 	</table>
			 </div>
        </div>
    </div>
<script type="text/javascript">
	//管辖范围,树的根节点ID
	var rootId = '-1';
	//选中源节点id
	var selectSourceNodeId;
	//选中目标节点id
	var selectDestNodeId;
	//操作步骤，默认为1
	var step = 1;
	//上一步标识 源id:目标id
	var priviewFlag;
	//最新标识  源id:目标id
	var latestFlag;
	//带修改组织类型的组织id
	var modifyOrgId;
	//带修改组织类型的组织名称
	var modifyOrgName;
	//带修改组织类型的组织编码
	var modifyOrgCode;
	//待更新信息
	var message = [];
	//管辖范围所属组织结构id
    var manageDeptOrgStructure = '';
	//扫描，相当于渲染
	window.onload = (function(){
		if(globalUserId != 'SuperAdmin'){
		    dwr.TOPEngine.setAsync(false);
		    //查询管辖范围
		    GradeAdminAction.getGradeAdminOrgByUserId(globalUserId, function(orgId){
		    	if(orgId){
					rootId = orgId;
					OrganizationAction.queryOrgStructureId(orgId,function(data){
						manageDeptOrgStructure = data;
					});
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
       comtop.UI.scan();
       initOrgTreeData('treeDiv');
       initOrgTreeData('treeDiv1');
	}); 
	//下一步	
	function next(){
		//从第一步切换到第二步
		if(step == 1){
			//判断移动组织是否为目标组织的子节点
			var node = cui("#treeDiv").getNode(selectSourceNodeId);
			//如果该节点本身是目标节点下的子节点
			if(node.getData().data.parentOrgId==selectDestNodeId){
				cui.alert("选中的源组织已经存在于目标组织下。");
				return false;
			}
			//如果源组织选中的是根节点，也不允许跳转到第二步骤 start
			if(globalUserId != 'SuperAdmin'){
				var vOrgStructure = cui('#orgStructure').getValue();
				var vId = '-1';
				if(vOrgStructure==manageDeptOrgStructure){
					//当组织结构为非外协的时候，判断根节点与选中节点是否相等
					if(selectSourceNodeId == rootId){
						cui.alert("选中的源组织为根组织，不能调整。");
						return false;
					}
				}else{
					//外协
					if(node.getData().data.parentOrgId == '-1'){
						cui.alert("选中的源组织为根组织，不能调整。");
						return false;
					}
				}
			}else{
				if(node.getData().data.parentOrgId == '-1'){
					cui.alert("选中的源组织为根组织，不能调整。");
					return false;
				}
			}
			//end
			var sourceOrgName=node.getData().data.orgName;
			var DestOrgName=cui("#treeDiv1").getNode(selectDestNodeId).getData().data.orgName;
		
			  cui.confirm("【<font color='red'>"+sourceOrgName+"</font>】及其下级组织编码将根据【<font color='red'>"+DestOrgName+"</font>】的编码规范修改，是否继续？",{
					onYes:function(){ //继续
									//判断目标组织下是否有重名组织
									dwr.TOPEngine.setAsync(false);
									OrganizationAction.isExistSameOrgName(selectDestNodeId,selectSourceNodeId,function(data){
								         if(!data){
								      		    cui.alert("目标组织已存在重名组织，不能调整。");
								              	return false;
								       	 }else{
											step = 2;
											document.getElementById('leadingHead').className="step_2";
											document.getElementById('sourceDiv').style.display = 'none';
											document.getElementById('imgDiv').style.display = 'none';
											document.getElementById('destDiv').style.display = 'none';
											document.getElementById('afterAdjustDiv').style.display = 'inline-block';
											document.getElementById('adjustOrgCodeDiv').style.display = 'inline-block';
											//每次进入第二步，就更新最新标识
											latestFlag = selectDestNodeId+':'+selectSourceNodeId;
											//第一次，需要校验编码
											if(!priviewFlag){
												priviewFlag = latestFlag;
												changeToStepTwo();
											}else{
												//后续进入到第二步的时候，如果前后两次标识不一样，需要校验编码，重新加载
												if(priviewFlag != latestFlag){
													changeToStepTwo();
													//检验完成，将最新值赋给上一次，便于下次验证
													priviewFlag = latestFlag;
												}
											}
								       	 }
									});
									dwr.TOPEngine.setAsync(true);
									buttonShow();
					   }
			        }
			   );
		
			
			
		}else if(step == 2){
			step = 3;
			document.getElementById('leadingHead').className="step_3";
			document.getElementById('adjustOrgCodeDiv').style.display = 'none';
			document.getElementById('adjustOrgTypeDiv').style.display = 'inline-block';
		}
		buttonShow();
	}
	//上一步	
	function preview(){
		//从第二步切换到第一步
		if(step == 2){
			step = 1;
			//清除原有的编码冲突
			deleteConfictNode();
			document.getElementById('leadingHead').className="step_1";
			document.getElementById('sourceDiv').style.display = 'inline-block';
			document.getElementById('imgDiv').style.display = 'inline-block';
			document.getElementById('destDiv').style.display = 'inline-block';
			document.getElementById('afterAdjustDiv').style.display = 'none';
			document.getElementById('adjustOrgCodeDiv').style.display = 'none';
		}else if(step == 3){
			step = 2;
			document.getElementById('leadingHead').className="step_2";
			document.getElementById('sourceDiv').style.display = 'none';
			document.getElementById('imgDiv').style.display = 'none';
			document.getElementById('destDiv').style.display = 'none';
			document.getElementById('afterAdjustDiv').style.display = 'inline-block';
			document.getElementById('adjustOrgCodeDiv').style.display = 'inline-block';
			document.getElementById('adjustOrgTypeDiv').style.display = 'none';
		}
		buttonShow();
	}
	//完成、保存
	function finish(){
		dwr.TOPEngine.setAsync(false);
 		OrganizationAction.adjustOrganizaiton(message,function(resultData){
			if(resultData){
				cui.message('组织调整成功。');
				step = 4;
				//结束之后，按钮全部隐藏，全局变量清空
				buttonShow();
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	//选择值类型
	function selectOrgType(data){
		//1：修改区的值需要改变
		var tr = document.getElementById('orgTypeTable').rows[0];
		if(tr){
			var newNodeTitle = modifyOrgName + '('+ data.orgTypeName + ')';
			tr.cells[0].innerText = newNodeTitle;
			//2：树上节点显示的内容需要改变
			var node = cui('#previewTree').getNode(modifyOrgId);
			node.setData("title",newNodeTitle);
			//3：对应的orgType需要联动
			node.getData().data.orgType = data.orgType;
			//4：记录变更消息
			var objMessage = getMessage(modifyOrgId);
			if(objMessage == null){
				objMessage = {"orgStructureId":cui('#orgStructure').getValue(),"orgId":modifyOrgId,"parentOrgId":node.parent().getData().data.orgId,"orgType":data.orgType};
				message.push(objMessage);
			}else{
				objMessage.orgType = data.orgType;
			}
		}
	}
	//点击预览树，调整组织类型
	function clickPreviewTree(node){
		var data = node.getData().data;
		modifyOrgName = data.orgName;
		modifyOrgId = data.orgId;
		modifyOrgCode = data.orgCode;
		var orgTypeName = data.orgTypeName;
		var orgType = data.orgType;
		
		var table = document.getElementById('orgTypeTable');
		var rows = table.rows.length;
		if(rows > 0){
			//先将之前的记录删除掉，重新修改名称
			table.deleteRow(0);
		}
		var oTr = table.insertRow(-1);
		var oTd = oTr.insertCell(0);
		oTd.className = "td_label";
		oTd.innerHTML = modifyOrgName + "(" + orgTypeName + ")<br>";
		oTr.id = modifyOrgId;
	}
	//初始化组织类型下拉框
 	function initOrgTypeData(obj){
 		dwr.TOPEngine.setAsync(false);
	 		OrganizationAction.getOrgTypeInfo(function(resultData){
				obj.setDatasource(jQuery.parseJSON(resultData));
			});
 		dwr.TOPEngine.setAsync(true);
 	}
	
	//切换到第二步，调整组织编码
	function changeToStepTwo(){
		message = [];
		//以目标ID为根创建新的树   start-------------------------
		var emptydata=[{title:"没有数据"}];
      	//查询组织树信息
      	dwr.TOPEngine.setAsync(false);
      	var node = {orgStructureId:cui('#orgStructure').getValue(), orgId:selectDestNodeId};
      	cui("#previewTree").setDatasource(null);
      	OrganizationAction.getOrgTreeNode(node,function(data){
       		var treeData = $.parseJSON(data);
    		if(treeData!=null){
       			  cui("#previewTree").setDatasource(treeData);
    		}else{
       			  cui("#previewTree").setDatasource(emptydata);
    		}
      	});
      	dwr.TOPEngine.setAsync(true);
	    //以目标ID为根创建新的树 end-----------------------------------//
	
       //调整树结构 start-------------------------------------------
       
      	   /**
		*调整树结构
		*1、移动源节点到目标树
		*2、更新目标节点及子节点编码
		*/
		//获取目标组织
		var parentNode = cui("#previewTree").getNode(selectDestNodeId);
		var parentNodeCode= parentNode.getData().data.orgCode;
		parentNode.setData("title",parentNode.getData().data.orgName+"("+parentNodeCode+")("+parentNode.getData().data.orgTypeName+")");
		parentNode.setData({'unselectable':true});
		//移动源树到目标节点
		var node = cui("#treeDiv").getNode(selectSourceNodeId);
		//选中的将要移动的源节点移动到新树的目标节点上
		var newNode={title:node.getData().title, key:node.getData().key,isLazy:node.getData().isFolder,
				data:{orgId:node.getData().data.orgId,orgCode:node.getData().data.orgCode,
			orgName:node.getData().data.orgName,orgTypeName:node.getData().data.orgTypeName,
			orgType:node.getData().data.orgType,parentOrgId:selectDestNodeId},
				icon:'${pageScope.cuiWebRoot}/top/sys/images/closeicon.gif'};
		
		//封装源组织信息
		var objMessage = getMessage(selectSourceNodeId);
		if(objMessage == null){
			//封装 orgId，parentOrgId orgStructureId
			objMessage = {"orgStructureId":cui('#orgStructure').getValue(),"orgId":selectSourceNodeId,"parentOrgId":selectDestNodeId,"orgCode":node.getData().data.orgCode};
			message.push(objMessage);
		}
		parentNode.addChild(newNode);
		cui("#previewTree").getNode(selectSourceNodeId).expand(true);
		
		parentNode.expand(true);
		//更新源节点的子节点编码
		//遍历修改下级组织编码
		recursiveNode(parentNode,function(arrNode){
			$.each(arrNode,function(i,node){
					var oldChildCode =node.getData().data.orgCode;
					var oldChildCodeLength = oldChildCode.length;
					//截取后两位编码
					var lastCode = oldChildCode.substr(oldChildCodeLength-2,2);
					var vNewCode = node.parent().getData().data.orgCode+lastCode;
					node.getData().data.orgCode = vNewCode;
					//编码有改动
					if(vNewCode != oldChildCode){
						//封装源组织信息
						var vId = node.getData().data.orgId;
						var objMessage = getMessage(vId);
						if(objMessage == null){
							//封装 orgId，parentOrgId orgStructureId
							objMessage = {"orgStructureId":cui('#orgStructure').getValue(),"orgId":vId,"parentOrgId":node.parent().getData().data.orgId,"orgCode":vNewCode};
							message.push(objMessage);
						}else{
							objMessage.orgCode = vNewCode;
						}
					}
					node.setData("title",node.getData().data.orgName+"("+node.getData().data.orgCode+")("+node.getData().data.orgTypeName+")");
			});
		});
	    //调整树结构 end----------------------------------
		//校验新的树上的组织编码是否有冲突
		validateCode();
		buttonShow();
	}
	//获取已经封装的对象
	function getMessage(orgId){
		var tMessage=null;
		$.each(message,function(o,iMessage){
			if(iMessage.orgId==orgId){
				tMessage=iMessage;
				return tMessage;
			}
		});
	    return tMessage;
	}
	//有冲突的组织id数据
	var orgIds = [];
	//检测编码冲突
	function validateCode(){
		orgIds = [];
		deleteConfictNode();
		//是否通过检测的标识
		var rootNode = cui("#previewTree").getNode(selectDestNodeId);
		//递归检查编码冲突
		recursiveNode(rootNode,function(arrNode){
			for(var i=0;i<arrNode.length;i++){
				for(var j=i+1;j<arrNode.length;j++){
					if(arrNode[i].getData().data.orgCode==arrNode[j].getData().data.orgCode){
						arrNode[i].setStyle("color:red");
						arrNode[j].setStyle("color:red");
						//将有编码冲突的组织放到编码调整区，此处是否需要将两者都放到编辑区，还需要仔细考虑，目前放 一个
						//pushCodeConfictNode(arrNode[i]);
						pushCodeConfictNode(arrNode[j]);
					}
				}
			}
		});
	}
	//控制按钮的展示
	function buttonShow(){
		if(step == 2){
			var table = document.getElementById('confictTable');
			var rows = table.rows.length;
			cui('#preview').show();
			if(rows>0){
				cui('#next').disable(true);
			}else{
				cui('#next').show();
				cui('#next').disable(false);
			}
			cui('#preview').show();
			cui('#finish').hide();
		}else if(step == 1){
			cui('#preview').hide();
			//当选中了源组织和目标组织且两者还不相同时，显示“下一步”按钮
	   		if(selectSourceNodeId &&　selectDestNodeId){
	   			if(selectSourceNodeId != selectDestNodeId){
		   			cui('#next').disable(false);
	   			}else{
	   				cui('#next').disable(true);
	   			}
	   		}
		}else if(step == 3){
			cui('#preview').show();
			cui('#next').hide();
			cui('#finish').show();
		}else if(step == 4){
			cui('#preview').hide();
			cui('#finish').hide();
			cui('#orgType').setReadonly(true);
		}
	}
	//删除冲突
	function deleteConfictNode(){
		var table = document.getElementById('confictTable');
		var rows = table.rows.length;
		for(var i=rows;i>0;i--){ //修改为从后开始删，rows是变化的
			table.deleteRow(i-1);
		}
	}
	//将有冲突的组织放到编码调整区
	function pushCodeConfictNode(node){
		var data = node.getData().data;
		var nodeKey = data.orgId;
		var isExisted = true;
	    // 当id已经添加了之后，就不需要再添加
		for(var i=0;i<orgIds.length;i++){
			if(orgIds[i] == nodeKey){
				isExisted = false;
				break;
			}
		}
		if(isExisted){
			orgIds.push(nodeKey);
		}else{
			return;
		}
		var orgName = data.orgName;
		var orgCode = data.orgCode;
		var orgCodeLength = orgCode.length;
		//截取后两位编码
		var lastCode = orgCode.substr(orgCodeLength-2,2);
		var parentCode = orgCode.substr(0,orgCodeLength);
		var table = document.getElementById('confictTable');
		var rows = table.rows.length;
		var oTr = table.insertRow(rows);
		var oTd = oTr.insertCell(0);
		oTd.className = "td_label";
		oTd.innerHTML = orgName + "(" + parentCode + "<input type='text' maxlength='2' style='width:40px;' onblur='validateAdjustOrgCode(\"" + nodeKey + "\",\"" + lastCode + "\")' id='" + nodeKey + "' value='" + lastCode + "' />)<br>"; 
	}
	/**
	 * 当光标从输入框中移开的时候，验证修改的编码是否合法
	 * @param nodeId 修改的组织id
	 * @lastCode 修改之前的最后两位编码
	 */
	function validateAdjustOrgCode(nodeId,lastCode){
		var newLastCode = document.getElementById(nodeId).value;
		if(newLastCode == lastCode){
			return;
		}
		if(!isCode(newLastCode)){
			cui.alert('组织编码只能为英文或数字。');
			return;
		}
		modifyNodeCode(nodeId,newLastCode);
		resetTreeStyle();
		validateCode();
		buttonShow();
	}
	/**
	* 编码只能输入数字
	*/
	function isCode(code){
		var reg = new  RegExp("^[A-Za-z0-9]+$");
		return (reg.test(code));
	}
	//修改节点组织编码
	function modifyNodeCode(nodeId,lastCode){
		var node = cui('#previewTree').getNode(nodeId);
		if(lastCode.length!=2){
			cui.alert('请输入两位数字作为编码后缀。');
			return;
		}
		oldCode = node.getData().data.orgCode;
		codeLength = oldCode.length;
		var newCode = node.getData().data.orgCode.substr(0,codeLength-2)+lastCode;
		node.getData().data.orgCode = newCode;
		
		var newParentName = node.getData().data.orgName+'('+node.getData().data.orgCode+')('+node.getData().data.orgTypeName+')';
		node.setData("title",newParentName);
		
		//封装更改信息
		var objMessage = getMessage(nodeId);
		if(objMessage == null){
			objMessage = {"orgStructureId":cui('#orgStructure').getValue(),"orgId":nodeId,"parentOrgId":node.parent().getData().data.orgId,"orgCode":newCode};
			message.push(objMessage);
		}else{
			objMessage.orgCode = newCode;
		}
		//遍历修改下级组织编码
		recursiveNode(node,function(arrNode){
			$.each(arrNode,function(i,vNode){
					var oldChildcode = vNode.getData().data.orgCode;
					var oldChildcodeLength = oldChildcode.length;
					//截取后两位编码
					var lastChildCode = oldChildcode.substr(oldChildcodeLength-2,2);
					var vNewChildCode = vNode.parent().getData().data.orgCode+lastChildCode;
					vNode.getData().data.orgCode = vNewChildCode;
					var newName = vNode.getData().data.orgName+'('+vNode.getData().data.orgCode+')('+vNode.getData().data.orgTypeName+')';
					
					//封装更改信息
					var objMessage = getMessage(vNode.getData().data.orgId);
					if(objMessage == null){
						objMessage = {"orgStructureId":cui('#orgStructure').getValue(),"orgId":vNode.getData().data.orgId,"parentOrgId":vNode.parent().getData().data.orgId,"orgCode":vNewChildCode};
						message.push(objMessage);
					}else{
						objMessage.orgCode = vNewChildCode;
					}
					
					vNode.setData("title",newName);
			});
		});
	}
	//清除树中所有节点样式
	function resetTreeStyle(){
		var rootNode = cui("#previewTree").getNode(selectDestNodeId);
		recursiveNode(rootNode,function(arrNode){
			$.each(arrNode,function(i,node){
				node.removeStyle();
			});
		});
	}
 	//动态加载下级节点
   	function previewTreeLazyData(node){
   		dwr.TOPEngine.setAsync(false);
		var userChildObj={"orgId":node.getData("key"),orgStructureId:cui('#orgStructure').getValue()};
		OrganizationAction.getOrgTreeNode(userChildObj,function(data){
	    	var nodeData = $.parseJSON(data);
	    	//如果当前要展开的节点不是目标节点，且要添加的节点为源节点，则说明是源节点下的，过滤掉，不显示
	    	var children = nodeData.children;
	    	var toShow = [];
	    	var sourceId = selectSourceNodeId;
 			if(selectDestNodeId != node.getData("key")){
				for(var j=0;j<children.length;j++){
					var bAdd = true;
					var curChild = children[j];
					if(curChild.key==sourceId){
						bAdd = false;
						continue;
					}
					if(bAdd){
						toShow.push(curChild);	
					}
				}
     		}else{
     			toShow = children.slice(0);
         	}
         	
	    	//加载子节点信息
	    	 node.addChild(toShow);
		     node.setLazyNodeStatus(node.ok);
		     if(node.children()){
	        	for(var i=0;i<node.children().length;i++){
	            	var childNode=node.children()[i];
   	                //调整节点组织编码 start
					var oldCode = childNode.getData().data.orgCode;
					var oldCodeLength = oldCode.length;
					var lastCode = oldCode.substr(oldCodeLength-2,2);
					var vNewCode = node.getData().data.orgCode + lastCode;
					childNode.getData().data.orgCode = vNewCode
					
					//封装更改信息
					var objMessage = getMessage(childNode.getData().data.orgId);
					if(objMessage == null){
						objMessage = {"orgStructureId":cui('#orgStructure').getValue(),"orgId":childNode.getData().data.orgId,"parentOrgId":node.getData().data.orgId,"orgCode":vNewCode};
						message.push(objMessage);
					}else{
						objMessage.orgCode = vNewCode;
					}

					childNode.setData("title",childNode.getData().data.orgName+"("+childNode.getData().data.orgCode+")("+childNode.getData().data.orgTypeName+")");
					//调整节点组织编码 end
	            	childNode.expand(true);
	        	}
	   		  }
	     });
	    dwr.TOPEngine.setAsync(true);
   	}
 	
	//递归处理树节点
    function recursiveNode(parentNode,func){
        if(parentNode.hasChild()){
        	for(var i=0;i<parentNode.children().length;i++){
            	var childNode=parentNode.children()[i];
            	func(parentNode.children());
            	recursiveNode(childNode,func);
        	}
        }
    }
   	// 树单击事件
   	function treeClick(node,event){
   		//调整代码 below
   		var nodeId = node.getData().key;
   		var treeId = event.currentTarget.id
   		if(treeId){
   			if(treeId == 'treeDiv'){
   				if(!node.isRoot){
	   				selectSourceNodeId = nodeId;
   				}
   			}
   			if(treeId == 'treeDiv1'){
   				selectDestNodeId = nodeId;
   			}
   		}
   		buttonShow();
   	}
   	//获取查询树需要的查询条件
   	function getQueryCondition(){
   		var vOrgStructure = cui('#orgStructure').getValue();
		var vId = '-1';
		//当切换到非管辖范围内的组织结构时候，展现整棵树
		if(vOrgStructure==manageDeptOrgStructure){
			vId = rootId;
		}
		var node = {orgStructureId:vOrgStructure, orgId:vId};
		return node;
   	}
	//树初始化
	function initOrgTreeData(id){
		var obj = cui('#'+id);
		node = getQueryCondition();
		dwr.TOPEngine.setAsync(false);
		OrganizationAction.getOrgTreeNode(node,function(data){
		   	if(data&&data!==""){
	   			var treeData = jQuery.parseJSON(data);
	   			treeData.isRoot = true;
	   			obj.setDatasource(treeData);
	   		    //激活根节点
	   			obj.getNode(treeData.key).activate(true);
	   			obj.getNode(treeData.key).expand(true);
	   			//取消激活状态
	   			obj.getNode(treeData.key).deactivate();
	   			//禁用源组织树的根节点
	   			//if(id='treeDiv'){
	   				//obj.getNode(treeData.key).disable();
	   			//}
			}else{
				  var emptydata=[{title:"暂无根组织"}];
	   			  obj.setDatasource(emptydata);
	   			  $('#moveOrg').hide();
			}
   		 });
   		dwr.TOPEngine.setAsync(true);
	}
	//初始化组织结构信息
	function initOrgStructure(obj){
		dwr.TOPEngine.setAsync(false);
		OrganizationAction.getOrgStructureInfo(function(data){
			if(data){
				var arrData = jQuery.parseJSON(data)
				obj.setDatasource(arrData);
				obj.setValue(arrData[0].value,true);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	//切换组织结构，重新加载整个页面
	function changeOrgStructure(value){
		cui('#orgStructure1').setValue(value);
		initOrgTreeData('treeDiv');
	    initOrgTreeData('treeDiv1');
	    selectSourceNodeId = '';
		selectDestNodeId = '';
	}
   	//动态加载下级节点
   	function lazyData(node){
   		node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/openicon.gif');
   		dwr.TOPEngine.setAsync(false);
		var userChildObj={"orgId":node.getData().key,orgStructureId:cui('#orgStructure').getValue()};
		OrganizationAction.getOrgTreeNode(userChildObj,function(data){
	    	var treeData = jQuery.parseJSON(data);
	    	//加载子节点信息
	    	 node.addChild(treeData.children);
		         node.setLazyNodeStatus(node.ok);
	     });
	    dwr.TOPEngine.setAsync(true);
   	}

	//树节点展开合起触发
	function onExpand(flag,node){
		if(flag){
			node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/openicon.gif');
		}else{
			node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/closeicon.gif');
		}
	}
 </script>
</body>
</html>