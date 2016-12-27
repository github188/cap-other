<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>工作流节点信息</title>
    <meta http-equiv="X-UA-Compatible" content="edge" />
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/comtop.ui.emDialog.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/WorkflowAction.js"></script>
    <style type="text/css">
    	.ie6_list_header_wrap{
    		_height:25px;
    		_overflow:hidden;
    	}
    </style>
</head>
<body>

  <div class="list_header_wrap ie6_list_header_wrap">
	    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="请输入流程名称或节点名称" editable="true" width="250" on_iconclick="iconclick"
        		icon="search" iconwidth="18px"></span>
		<div class="top_float_right">
		<top:verifyAccess pageCode="TopPostAdmin" operateCode="addOrdelWorkflow">
			<span uiType="Button" label="关联流程节点" on_click="selectWorkflow" id="selectWorkflow"></span>
		    <span uiType="Button" label="删除流程节点" on_click="deleteWorkflowFromPost" id="deleteWorkflowFromPost"></span>
		</top:verifyAccess>
		</div>
 </div>
 <div id="userGridWrap">
     <table uitype="Grid" id="workflowGrid" primarykey="nodePostRelId"  gridheight="auto" sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
        <th  style="width:30px;"><input type="checkbox"></th>
		<th  bindName="processName" sort="true">工作流名称</th>
		<th  bindName="nodeName" sort="true" >节点名称</th>
		<th  bindName="userGroupValue" sort="true" >人员分组</th>
		<th  bindName="moduleName"  sort="false"  renderStyle="text-align: center" >所属模块</th>
	</table>
 
 </div>
<script language="javascript">
		var postId = "<c:out value='${param.postId}'/>"; 
		var postName = decodeURIComponent(decodeURIComponent("<c:out value='${param.postName}'/>"));
		var orgName= decodeURIComponent(decodeURIComponent("<c:out value='${param.orgName}'/>"));
	    var keyword="";
	  
	  //被选中列的主键，用于新增及编辑时自动选中
		var selectedKey='';
	  
		$(document).ready(function(){
			comtop.UI.scan();
		});
		
		
		//渲染列表数据
		function initData(grid,query){
			//获取排序字段信息
		    var sortFieldName = query.sortName[0];
		    var sortType = query.sortType[0];
		    //设置查询条件
		    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:keyword,sortFieldName:sortFieldName,sortType:sortType,postId:postId};
		    WorkflowAction.queryWorkflowList(queryObj,{
		    	callback:function(data){
			    	var totalSize = data.count;
					var dataList = data.list;
					//加载数据源
					grid.setDatasource(dataList,totalSize);
					if(selectedKey!=''){
						grid.selectRowsByPK(selectedKey);
						selectedKey='';
					}
	        	},
	        	errorHander:function(){
	        		cui.error("查询工作流信息出错。");
	        	},
	        	exceptionHandler:function(){cui.error("查询工作流信息出错。");}
		    });
	  	}
	    //Grid组件自适应宽度回调函数，返回高度计算结果即可
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth)-20;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 60;
		}
		
		
		 //搜索框图片点击事件
		 function iconclick() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
	        cui("#workflowGrid").setQuery({pageNo:1});
	        //刷新列表
			refresh();
	     }
		 
		 
		    
		//从岗位删除角色操作
		function deleteWorkflowFromPost(){
			var selectIds = cui("#workflowGrid").getSelectedPrimaryKey();
			if(!selectIds||selectIds.length==0){
				cui.alert("请选择要删除的流程节点。");
				return;
			}
			WorkflowAction.deleteWorkflowFromPost(selectIds,{
				callback:function(){
			    	window.cui.message('流程节点删除成功。','success');
			    	refresh();
	        	},
				errorHander:function(){
	        		cui.error("删除工作流节点出错。");
	        	},
	        	exceptionHandler:function(){cui.error("删除工作流节点出错。");}
			});
		}   
		
		/***
		刷新列表
		*/
		function refresh(){
			cui("#workflowGrid").loadData();
		}

		//打开关联工作流页面
		function  selectWorkflow(){
			var url='${pageScope.cuiWebRoot}/top/sys/post/WorkFlowRelate.jsp?postId='+postId+"&postName="+encodeURIComponent(encodeURIComponent(postName))+"&orgName="+encodeURIComponent(encodeURIComponent(orgName));
			var height = $(window.top).height()-100;
			var width =  $(window.top).width();
			var dialog ;
			if(window.top.cuiEMDialog&&window.top.cuiEMDialog.dialogs){
				dialog = window.top.cuiEMDialog.dialogs["selectWorkflow"];
			}
			if(!dialog){
				dialog=	cui.extend.emDialog({
					id: 'selectWorkflow',
					title : '关联工作流节点',
					src : url,
					width : width,
					height : height,
					onClose:refresh
			    });
			}else{
				dialog.reload(url);
			}
			dialog.show();
		} 
</script>
</body>
</html>