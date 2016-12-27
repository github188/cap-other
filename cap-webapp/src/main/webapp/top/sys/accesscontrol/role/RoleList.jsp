<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB18030">
<title>岗位授权</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">

<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/RoleAction.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/SubjectRoleAction.js"></script>
<style type="text/css">
    body,html{margin:0;width:100%;}
</style>
</head>
<body>
         <div  uitype="bpanel"  position="center" id="centerMain" header_title="角色列表"    height="500">
			<div class="list_header_wrap" style="">
				<div class="top_float_left">
					<span uitype="ClickInput" id="myClickInput" name="clickInput" editable="true" emptytext="请输入角色名称" on_keydown="keyDowngGridQuery"
			         width="280" on_iconclick="iconclick" icon="${pageScope.cuiWebRoot}/top/sys/images/querysearch.gif"></span>
				</div>
				<div class="top_float_right">
					<span uitype="button" id="addRoleButton" label="新增角色" on_click="addRole"></span>
					<span uitype="button" id="deleteRoleButton" label="删除角色" on_click="deleteRole"></span>
				</div>
			</div>
			<div id="grid_wrap">
			<table uitype="grid" id="roleGrid" sorttype="1" datasource="initGridData" pagesize_list="[10,20,30]" pagesize="10"
			      primarykey="roleId" resizewidth="resizeWidth" resizeheight="resizeHeight"  colrender="columnRenderer" titlerender="title">
							<th  style="width:30px;"><input type="checkbox"></th>
							<th  bindName="roleName" sort="true">角色名称</th>
							<th  bindName="description" sort="true" >描述</th>
							<th  bindName="creatorName"  sort="true"  renderStyle="text-align: center" >创建人</th>
							<th  bindName="createTime" sort="true"  renderStyle="text-align: center"  format="yyyy-MM-dd">创建日期</th>
							<th  bindName="strRoleType"  sort="true"  renderStyle="text-align: center" >角色类型</th>
							
			</table>
			</div>
		</div>
	

<script type="text/javascript">
     var subjectId="1";
     var subjectId="1";
     var subjectTypeCode="POST";
      queryCondition={};
      var dialog;
	  $(document).ready(function (){
		comtop.UI.scan();  
	  });  
	//快速查询
		function fastQuery(){
			var keyword = cui('#keyword').getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("'", "gm"), "''");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_", "gm"), "/_");
			if(keyword == ''){
				switchTreeListStyle("tree");
				//TODO 必须选择节点，并刷新右侧iframe
				var node = cui('#roleClassifyTree').getNode(curNodeId);
				if(node){
					treeClick(node);
				}
			}else{
				switchTreeListStyle("list");
				listBoxData(cui('#fastQueryList'),keyword);
			}
		}
	
		//搜索框图片点击事件
        var gridKeyword="";
   	 	function iconclick() {
   	 	   gridKeyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
   	 	   gridKeyword = gridKeyword.replace(new RegExp("'", "gm"), "''");
   	 	   gridKeyword = gridKeyword.replace(new RegExp("%", "gm"), "/%");
   	 	   gridKeyword = gridKeyword.replace(new RegExp("_", "gm"), "/_");
           cui("#roleGrid").setQuery({pageNo:1});
	   	   cui("#roleGrid").loadData();
        }
		//渲染列表数据
    	function initGridData(grid,query){
			//
    	    var sortFieldName = query.sortName[0];
    	    var sortType = query.sortType[0];
    	    queryCondition.pageNo=query.pageNo;
    	    queryCondition.pageSize=query.pageSize;
    	    queryCondition.subjectId=subjectId;
    	    queryCondition.fastQueryValue=gridKeyword;
    	    queryCondition.sortFieldName=sortFieldName;
    	    queryCondition.subjectClassifyCode=subjectTypeCode;
    	    queryCondition.sortType=sortType;
    	    SubjectRoleAction.queryRoleBySubjectId(queryCondition,function(data){
     	     	var totalSize = data.count;
     	    	var dataList = data.list;
    			grid.setDatasource(dataList,totalSize);
            });
      	}
      	
        //Grid组件自适应宽度回调函数，返回高度计算结果即可
    	function resizeWidth(){
        	//alert()
			return $('body').width()-5 ;
    		//return (document.documentElement.clientWidth || document.body.clientWidth) - 297;
    	}

    	//Grid组件自适应高度回调函数，返回宽度计算结果即可
    	function resizeHeight(){
    		return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
    	}

    	function addRole(){
    		
    		var url='${pageScope.cuiWebRoot}/top/sys/accesscontrol/role/AddRole.jsp?subjectId='+subjectId;
  			 var title="新增角色";
 			var height = 800;
  			var width = 900;
 			 dialog = cui.dialog({
 				 title:title,
 				 src:url,
 				width:width,
 				height:height
 			 });
 			dialog.show(url);
    			
    	}
    	
    	function addCallBack(){
        	//清空查询条件，清除题头排序条件
        	cui("#myClickInput").setValue("");
        	gridKeyword="";
    		cui("#roleGrid").setQuery({pageNo:1,sortType:[],sortName:[]});
    		cui("#roleGrid").loadData();
    		//cui("#roleGrid").selectRowsByPK(roleId);
    	}

    	
    	
    	//删除按钮
   		function deleteRole(){
   			var selectIds = cui("#roleGrid").getSelectedPrimaryKey();//获取要删除的数据组
   			if(selectIds == null || selectIds.length == 0){
   				cui.alert("请选择要删除的角色。");
   				return;
   			}
   			var message = "确定从岗位中删除这"+selectIds.length+"条角色吗？";
   			deleteRoles(selectIds,message);//删除角色
   		}

   		//删除角色
   	    function deleteRoles(selectIds,message){
   			cui.confirm(message, {
				buttons: [{
					name: '确定',
					handler: function(){
						dwr.TOPEngine.setAsync(false);
	   					RoleAction.deleteRoles(selectIds,function(){
	   						cui("#roleGrid").removeData(cui("#roleGrid").getSelectedIndex());
	   						cui("#roleGrid").loadData();
	   						cui.message("删除"+selectIds.length+"条角色成功","success");
	   			        });
	   					dwr.TOPEngine.setAsync(true);
   			  		}
				}
				,{
					name: '取消',
					handler: function(){
					}
				}]
			});
			
    	}
	</script>
</body>
</html>