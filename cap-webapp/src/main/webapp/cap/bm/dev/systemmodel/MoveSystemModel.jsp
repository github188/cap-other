<%
  /**********************************************************************
	* CIP元数据建模----选择父节点
	* 2015-5-8  李杰 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>


<!doctype html>
<html>
<head>
<title>选择父节点</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/SystemModelAction.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/top/component/topui/cui/js/jquery.dynatree.min.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/top/component/topui/cui/js/comtop.ui.tree.js'></script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	<div id="leftMain" position="left" width="300" collapsabltie="true"
		show_expand_icon="true" collapsable="true">
		<table width="95%" style="margin-left: 10px">
			<tr height="40px;">
				<td><span uitype="ClickInput" id="keyword" name="keyword"
					emptytext="请输入系统，目录或应用名称关键字查询" on_iconclick="fastQuery"
					icon="search" enterable="true" editable="true" width="200"
					on_keydown="keyDownQuery"></span>
					<span uitype="button" label="确定" on_click="determineFunc"></span>
					<span uitype="button" label="取消" on_click="closeFun"></span>
				</td>
			</tr>
			<tr>
				<td>
					<div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div>
				</td>
			</tr>
			<tr id="tr_moduleTree">
				<td>
					<div id="moduleTree" uitype="Tree" children="initData"
						on_dbl_click="dbClickNode" min_expand_level="1"
						on_lazy_read="loadNode" on_click="treeClick" click_folder_mode="1"></div>
				</td>
			</tr>			
		</table>
	</div>


	<script type="text/javascript">
		var addType = '';
		
		var moveObjId = "${param.moveObjId}";
		
		var moveObj = null;
		
		//选中的树节点
		var selectedNodeId = "-1";
		$(document).ready(function(){
			comtop.UI.scan();   //扫描
			queryMoveObj();
		});
		
		function queryMoveObj(){
			if(moveObjId!=null && moveObjId!=''){
				SystemModelAction.getModuleInfo(moveObjId,function(resultData){
					if(resultData!=null){
						moveObj = resultData;
					}
				});
			}
		}
		
		//初始化数据 
		function initData(obj) {
			var moduleObj={"parentModuleId":"-1"};
			SystemModelAction.queryChildrenModule(moduleObj,function(data){
				if(data != null && data != "") {
					var treeData = jQuery.parseJSON(data);
					treeData.expand = true;
					treeData.activate = true;
					if(treeData.children) {
						treeData.children = addSomeChildNode(treeData.children);
					}
			    	obj.setDatasource(treeData);
			    	
			    	var node=cui('#moduleTree').getNode(treeData.key);
					if(node){
						treeClick(node);
					}
				}
		     });
		}
		
		//点击click事件加载节点方法
		function loadNode(node) {
			selectedNodeId = node.getData().key;
			dwr.TOPEngine.setAsync(false);
			var moduleObj={"parentModuleId":node.getData().key};
			SystemModelAction.queryChildrenModule(moduleObj,function(data){
		    	var treeData = jQuery.parseJSON(data);
		    	var childData = treeData.children;
		    	childData = addSomeChildNode(childData);
		    	treeData.activate = true;
		    	node.addChild(childData);
				node.setLazyNodeStatus(node.ok);
		     });
			dwr.TOPEngine.setAsync(true);
		}
		
		// 增加指定目录节点
		function addSomeChildNode(childData) {
			for(var i=0; i<childData.length; i++) { 
	    		if(childData[i].data.moduleType == 2) {
	    			if(childData[i].isFolder) {
	    				dwr.TOPEngine.setAsync(false);
	    				var moduleObj = {"parentModuleId":childData[i].key};
	    				SystemModelAction.queryChildrenModule(moduleObj,function(data){
	    			    	var treeData = jQuery.parseJSON(data);
	    			    	var childChildData = treeData.children;
	    			    	if(childChildData) {
	    			    		addSomeChildNode(childChildData);
	    			    	}
	    			     });
	    				dwr.TOPEngine.setAsync(true);
	    			}
	    		}
	    	} 
			return childData;
		}
		
		var moveTargetModel = null;
		//树点击事件
		function treeClick(node) {
			var data = node.getData().data;
			moveTargetModel = {};
			moveTargetModel.id = data.moduleId;
			moveTargetModel.type = data.moduleType;
		}
		
		var isFastQuery = false;
		//快速查询
		function fastQuery(){
			var keyword = cui('#keyword').getValue();
			if(keyword==''){
				moveTargetModel = null;
				isFastQuery = false;
				$('#fastQueryList').hide();
				$('#moduleTree').show();
				addType = '';
				var node=cui('#moduleTree').getNode(selectedNodeId);
				if(node){
					treeClick(node);
				}
			}else{
				moveTargetModel = null;
				isFastQuery = true;
				$('#fastQueryList').show();
				$('#moduleTree').hide();
				listBoxData(cui('#fastQueryList'));
				addType = 'fastQueryType';
			}
		}

		//键盘回车键快速查询 
		function keyDownQuery() {
			if ( event.keyCode ==13) {
				fastQuery();
			}
		}

		//快速查询列表数据源
		function listBoxData(obj){
			initBoxData = [];
			var keyword = cui("#keyword").getValue().replace(new RegExp("/","gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
			dwr.TOPEngine.setAsync(false);
			SystemModelAction.fastQueryModule(keyword,function(data){
				var len = data.length ;
				if(len != 0) {
					$.each(data,function(i,cData){
						if(cData.moduleName.length > 31) {
							path=cData.moduleName.substring(0,31)+"..";
						} else {
							path = cData.moduleName;
						}
						initBoxData.push({href:"#",name:path,title:cData.moduleName,onclick:"clickRecord('"+cData.moduleId+"','"+cData.moduleName+"')"});
					});
				} else {
					initBoxData.push({href:"#",name:"没有数据",title:"",onclick:""});
				}
			});
			cui("#fastQueryList").setDatasource(initBoxData);
			dwr.TOPEngine.setAsync(true);
		}
		
		//单击列表记录
		function clickRecord(moduleId, modulePath){
			var selectedModuleId = moduleId;
			dwr.TOPEngine.setAsync(false);
			SystemModelAction.getModuleInfo(selectedModuleId,function(data){
				var moduleVO = data;
				moveTargetModel = {};
				moveTargetModel.id = moduleVO.moduleId;
				moveTargetModel.type = moduleVO.moduleType;
			});	
			dwr.TOPEngine.setAsync(true);
		}
		
		function determineFunc(){
			var result = verification(moveTargetModel);
			if(result){
				dwr.TOPEngine.setAsync(false);
				SystemModelAction.moveSystemModel(moveObj,moveTargetModel.id,function(data){
					window.parent.cui.message('保存成功','succse');
					moveObj.parentModuleId = moveTargetModel.id;
					window.parent.moveSystemCallBack(moveObj);
				});
				dwr.TOPEngine.setAsync(true);
			}
		}
		
		function verification(moveTargetModel){
			var result = true;
			if(moveObj!=null){
				if(moveTargetModel!=null && moveTargetModel.id!=null && moveTargetModel.type!=null){
					if(moveObj.moduleId == moveTargetModel.id){
						result = false;
						window.parent.cui.error('移动目标不能为移动对象。','error');
					}
					
					var moduleType = moveObj.moduleType;
					//判断移动对象是否为应用
					if(moduleType!=2){
						//判断移动目标是否应用
						if(moveTargetModel.type==2){
							//无法将非应用移动到应用之下
							result = false;
							window.parent.cui.error('无法将非应用移动到应用之下。','error');
						}
					}	
				}else{
					result = false;
					window.parent.cui.error('请选择移动目标对象','error');
				}
			}else{
				//移动对象为空
				result = false;
				window.parent.cui.error('未查询到移动对象。','error');
			}
			return result;
		}
		
		function closeFun(){
			window.parent.dialog.hide();
		}

	</script>
</body>
</html>