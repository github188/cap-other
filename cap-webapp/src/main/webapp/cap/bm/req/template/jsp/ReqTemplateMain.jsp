<%
  /**********************************************************************
	* CAP功能模块----需求模板配置
	* 2015-9-22 姜子豪  新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
	<head>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:link href="/eic/css/eic.css" />
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/eic/js/comtop.eic.js" />
		<top:script src="/eic/js/comtop.ui.emDialog.js"/>
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/dwr/interface/TemplateTypeAction.js" />
		<top:script src="/cap/dwr/interface/TemplateInfoAction.js" />
	</head>
	<style>
		.divTreeBtn {
			  margin-left :15px;
		}
		.divGridBtn {
				float:right;
				margin-right:15px;
				margin-top:4px;
				margin-bottom:4px;
		}
		 .d {display: none; font-size: 12px;}
        .form_table{
		position:relative;
		padding: 2px 5px 8px 15px;
		}
							th{
    font-weight: bold;
    font-size:14px;
}
	</style>
	<body>
		<div class="d" id="form">
		<table class="form_table" style="table-layout:fixed;">
			<tr>
				<td class="td_label" width="30%"><span style="padding-left: 10px;">父节点<span class="top_required">*</span>：</span></td>
        		<td><span uitype="Input" id="parentNode" maxlength="50" align="left" width="70%" databind="insertNode.parentNode" readonly="true"></span></td>
    		</tr>
    		<tr>
    			<td class="td_label" width="30%"><span style="padding-left: 10px;">子节点<span class="top_required">*</span>：</span></td>
        		<td><span uitype="Input" id="typeName" maxlength="50" validate="validateFortypeName" align="left" databind="insertNode.typeName" width="70%" ></span></td>
    		</tr>
		</table>
		</div>
		<div class="d" id="changeName">
		<table class="form_table" style="table-layout:fixed;">
    		<tr>
    			<td class="td_label" width="30%"><span style="padding-left: 10px;">节点名称:<span class="top_required">*</span>：</span></td>
        		<td><span uitype="Input" id="changeNode" maxlength="50" validate="validateForUpdate" align="left" width="70%" ></span></td>
    		</tr>
		</table>
		</div>
		<div uitype="Borderlayout" id="border" is_root="true" style="position:relative;width: 100%;height:auto;">
			<div position="left" width="150">
				<div class="divTreeBtn">
			    	<span id="addNode" uitype="button" label="新增" on_click="addNode"></span> 
					<span id="deleteNode" uitype="button" label="删除" on_click="deleteNode" ></span>
				</div>
				<div id="tree" uitype="Tree" checkbox="false" select_mode="1" children="templateTypeData" on_click="onclickNode" on_dbl_click="changeNodeName"></div>
			</div>
			<div position="center" >
				<div class="divGridBtn">
					<span id="addGrid" uitype="button" label="新增" on_click="addGrid"></span> 
					<span id="deleteGrid" uitype="button" label="删除" on_click="deleteGrid" ></span>
				</div>
				<table uitype="grid" id="templateInfo" pagesize="18" gridheight="500px" ellipsis="true" colhidden="true" pageno="1" colmaxheight="auto" gridwidth="600px" pagination_model="pagination_min_1" config="config" oddevenclass="cardinal_row" sortstyle="1" selectrows="multi" datasource="initData" fixcolumnnumber="0" selectall_callback="selectAllCallback" adaptive="true" resizeheight="getBodyHeight" titleellipsis="true"  resizewidth="getBodyWidth" loadtip="true" pagesize_list="[18, 30, 50]" colmove="false" primarykey="id" onstatuschange="onstatuschange" pagination="true" oddevenrow="false">
			        <tr>
			        	<th style="width:50px"></th>
			            <th bindName="templateName" renderStyle="text-align:left" style="width:15%;" render="templateInfoEdit">名称</th>
			            <th bindName="descInfo" renderStyle="text-align:left" style="width:85%;" >描述</th>
			        </tr>
	    		</table>
			</div>
		</div>
		<script type="text/javascript">
		var rootId;
		var insertNode={};
		var templateTypeId;
		var deleteNodeList=[];
		var validateFortypeName=[{
		        type: 'required',
		        rule: {
		            m: '子节点不能为空'
		        }
		    }];
		
		var validateForUpdate=[{
	        type: 'required',
	        rule: {
	            m: '节点名称不能为空'
	        }
	    }];
		//初始化 
		window.onload = function(){
			comtop.UI.scan();
			childNodeLode(rootId);
			templateTypeId=rootId;
			cui("#tree").getNode(templateTypeId).activate(true);
			cui("#deleteNode").disable(true);
			cui('#templateInfo').loadData();
	   	}
		
		//初始化grid加载 
	    function initData (gridObj, query) {
	    	dwr.TOPEngine.setAsync(false);
	    	TemplateInfoAction.queryTemplateInfoList(query,templateTypeId,function(data){
				gridObj.setDatasource(data.list, data.count);
			});
			dwr.TOPEngine.setAsync(true);
	    }
	    
	    //grid宽度自适应
	    function getBodyWidth () {
	        return (document.documentElement.clientWidth || document.body.clientWidth) - 165;
	    }
	    
	    //grid高度自适应
	    function getBodyHeight () {
	        return (document.documentElement.clientHeight || document.body.clientHeight) - 40;
	    }
	    
		//初始加载根节点 (tree)
		function templateTypeData(obj){
			dwr.TOPEngine.setAsync(false);
			TemplateTypeAction.reqTemplateTypeIDLst(function(data){
				var initData = [];
		    	for(var i=0;i<data.list.length;i++){
		    		if(data.list[i].paterId==null || data.list[i].paterId==""){
		    			rootId=data.list[i].id;
		    			var item={'title':data.list[i].typeName,'key':data.list[i].id,expand:true};
			    		initData.push(item);
		    		}
		    	}
		    	obj.setDatasource(initData);
				});
			dwr.TOPEngine.setAsync(true);
		}
		
		//加载子节点(tree)(递归加载) 
		function childNodeLode(rootId){
			dwr.TOPEngine.setAsync(false);
			TemplateTypeAction.reqTemplateTypeIDLst(function(data){
				for(var i=0;i<data.list.length;i++){
					if(data.list[i].paterId == rootId){
						cui("#tree").getNode(rootId).addChild({'title':data.list[i].typeName,'key':data.list[i].id});
						childNodeLode(data.list[i].id);
					}
				}
				});
			dwr.TOPEngine.setAsync(true);
		}
		
		//新增节点 (tree)
		function addNode(){
			var selectNode=cui("#tree").getActiveNode();
			if(selectNode == null || selectNode == ""){
				cui.alert("请选中待插入节点的父节点。");
				return;
			}
			var selectNodeTitle=selectNode.getData('title');
			var selectNodeKey=selectNode.getData('key');
			cui("#form").dialog({
	            title:"添加节点",
	            width:300,
	            height:100,
	            buttons : [
	                {
	                    name : '保存',
	                    handler : function() {
	                		if(window.validater){
	                			window.validater.notValidReadOnly = true;
	                			var map = window.validater.validOneElement("typeName");
	                			var valid = map.valid;
	                			//验证消息
	                			if(!valid) { 
	                				return false;
	                			}
	                		}
	            			selectNode=cui("#tree").getActiveNode();
	            			selectNodeTitle=selectNode.getData('title');
	            			selectNodeKey=selectNode.getData('key');
	                    	var templateTypeVO = cui(insertNode).databind().getValue();
	                    	templateTypeVO.paterId=selectNodeKey;
	                    	templateTypeVO.id="";
	                    	dwr.TOPEngine.setAsync(false);
	            			TemplateTypeAction.insetTemplateType(templateTypeVO,function(data){
	            				if(data){
	            					cui.message('保存成功。','success');
	            					selectNode.addChild({'title':cui("#typeName").getValue(),'key':data});
	            					cui("#tree").getNode(data).activate(true);
	            					cui("#tree").selectNode(data,true);
	            					cui("#deleteNode").disable(false);
	            					templateTypeId=data;
	            					cui('#templateInfo').loadData();
	            				}
	            			});
	            			dwr.TOPEngine.setAsync(true);
	            			cui("#form").hide();
	                    }
	                }, {
	                    name : '取消',
	                    handler : function() {
	                    	cui("#form").hide();
	                    }
	                }
	            ]
	        }).show();
			cui(insertNode).databind().setEmpty();
			cui("#parentNode").setValue(selectNodeTitle);
		}
		
		//删除节点(tree)
		function deleteNode(){
			var selectNode=cui("#tree").getActiveNode();
			if(selectNode == null || selectNode == ""){
				cui.alert("请选择需要删除的节点(根节点不可删除)。");
				return;
			}
			var selectNode=cui("#tree").getActiveNode();
			getDeleteNodeList(selectNode);
			dwr.TOPEngine.setAsync(false);
			TemplateTypeAction.deleteTemplateType(deleteNodeList,function(data){
				if(!data){
					cui.message('删除失败。','warn');
				}
				else{
					cui.message('删除成功。','success');
					templateTypeId=selectNode.parent().getData('key');
					selectNode.remove();
					cui("#tree").getNode(templateTypeId).activate(true);
					if(cui("#tree").getNode(templateTypeId).getData('key')==rootId){
						cui("#deleteNode").disable(true);
					}
					else{
						cui("#deleteNode").disable(false);
					}
					cui('#templateInfo').loadData();
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		//点击树节点事件
		function onclickNode(node, event){
			if(node.getData("key") == rootId){
				cui("#deleteNode").disable(true);
			}
			else{
				cui("#deleteNode").disable(false);
			}
			templateTypeId=node.getData("key");
			cui('#templateInfo').loadData();
        }
		
		//grid新增事件（新增需求明细）
		function addGrid(){
			window.open('TemplateInfoEdit.jsp?templateTypeId='+templateTypeId);
		}
		
		//grid删除事件（删除需求明细）
		function deleteGrid(){
			var selects = cui("#templateInfo").getSelectedRowData();
			if(selects == null || selects.length == 0){
				cui.alert("请选择要删除的数据。");
				return;
			}	
			cui.confirm("确定要删除这"+selects.length+"条数据吗？",{
				onYes:function(){
					dwr.TOPEngine.setAsync(false);
					TemplateInfoAction.deleteTemplateInfoList(cui("#templateInfo").getSelectedRowData(),function(msg){
					 	cui("#templateInfo").loadData();
					 	cui.message("成功删除"+selects.length+"条数据","success");
					 	});
					dwr.TOPEngine.setAsync(true);
				}
			});
		}
		
		//名称行渲染（点击进入编辑界面）
		function templateInfoEdit(rd,index,col){
			return "<a href='javascript:;' onclick='edit(\"" +rd.id+"\");'>" + HTMLEnCode(rd[col.bindName]) + "</a>";
			
		}
		
		//点击grid名称行事件
		function edit(id){
	    	var rd = cui("#templateInfo").getRowsDataByPK(id)[0];
	    	window.open('TemplateInfoEdit.jsp?TemplateInfoId='+rd.id + "&templateTypeId="+templateTypeId);
	    }
		
		//保存后处于列表首位 
		function fresh(index){
			cui("#templateInfo").selectRowsByPK(index, true);
			var index=cui("#templateInfo").getSelectedIndex();
			var changeData=cui("#templateInfo").getRowsDataByIndex(index);
			cui("#templateInfo").removeData(index);
			cui("#templateInfo").addData(changeData, 0);
		}
		
		//获取待删除模板列表  
		function getDeleteNodeList(selectNode){
			var id=selectNode.getData('key');
			var templateTypeName=selectNode.getData('title');
			var item={'id':id,'teamName':templateTypeName};
			deleteNodeList.push(item);
			if(cui("#tree").getNode(id).children()){
				var childNode=cui("#tree").getNode(id).children();
				for(var i=0;i<childNode.length;i++){
					getDeleteNodeList(childNode[i]);
				}
			}
		}
		
		//修改需求模板名称 
		function changeNodeName(node,event){
			cui("#changeNode").setValue(node.getData('title'));
			cui("#changeName").dialog({
	            title:"添加节点",
	            width:350,
	            height:50,
	            buttons : [
	                {
	                    name : '保存',
	                    handler : function() {
	                		if(window.validater){
	                			window.validater.notValidReadOnly = true;
	                			var map = window.validater.validOneElement("changeNode");
	                			var valid = map.valid;
	                			//验证消息
	                			if(!valid) { 
	                				return false;
	                			}
	                		}
	                    	var templateTypeVO={};
	                    	var parentNode=node.parent();
	                    	var paterId=parentNode.getData("key");
	                    	if(paterId === "_1" || !paterId){
	                    		templateTypeVO.paterId=null;
	                    	}
	                    	else{
	                    		templateTypeVO.paterId=paterId;
	                    	}
	                    	templateTypeVO.id=node.getData('key');
	                    	templateTypeVO.typeName=cui("#changeNode").getValue();
	                    	dwr.TOPEngine.setAsync(false);
	            			TemplateTypeAction.updateTemplateType(templateTypeVO,function(data){
	            				if(data){
	            					cui.message('保存成功。','success');
	            					node.setTitle(cui("#changeNode").getValue());
	            				}
	            			});
	            			dwr.TOPEngine.setAsync(true);
	            			cui("#changeName").hide();
	                    }
	                }, {
	                    name : '取消',
	                    handler : function() {
	                    	cui("#changeName").hide();
	                    }
	                }
	            ]
	        }).show();
		}
		</script>
	</body>
</html>
