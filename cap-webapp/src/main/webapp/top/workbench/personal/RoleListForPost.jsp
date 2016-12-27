<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>角色列表</title>
    <meta http-equiv="X-UA-Compatible" content="edge" />
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/comtop.ui.emDialog.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostAction.js"></script>
    <style type="text/css">
    	.ie6_list_header_wrap{
    		_height:25px;
    		_overflow:hidden;
    	}
    	th{
		    font-weight: bold;
		    font-size:14px;
		}
    </style>
</head>
<body>

  <div class="list_header_wrap ie6_list_header_wrap" style="padding:0 0 10px 0px;">
	    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="请输入角色名称" editable="true" width="250" on_iconclick="iconclick"
        		icon="search" iconwidth="18px"></span>
 </div>
 <div id="userGridWrap">
     <table uitype="Grid" id="roleGrid" primarykey="subjectRoleId"   sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
		                    <th  id="checkboxId"  style="width:30px;"><input type="checkbox"></th>
							<th  bindName="roleName" sort="true">角色名称</th>
							<th  bindName="roleDescription" sort="true" >描述</th>
							<th  bindName="createTime" sort="true"  renderStyle="text-align: center"  format="yyyy-MM-dd">创建日期</th>
							<th  bindName="strRoleType"  sort="true"  renderStyle="text-align: center" >角色类型</th>
	</table>
 
 </div>
<script language="javascript">
		var orgId = "<c:out value='${param.orgId}'/>"; 
		var postId ="<c:out value='${param.postId}'/>";
		var orgStructureId = "<c:out value='${param.orgStructureId}'/>";
		var rootOrgId = "<c:out value='${param.rootOrgId}'/>";//根组织id 
	    var keyword="";
		var roleIds="";
	    var postRelationType= "<c:out value='${param.postRelationType}'/>";   //1为行政 2为非行政

	    
	  //被选中列的主键，用于新增及编辑时自动选中
		var selectedKey='';
	  

     

		window.onload = function(){
			comtop.UI.scan();
		}
		
		
		//渲染列表数据
		function initData(grid,query){
			
				//获取排序字段信息
			    var sortFieldName = query.sortName[0];
			    var sortType = query.sortType[0];
			    //设置查询条件
			    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:keyword,sortFieldName:sortFieldName,sortType:sortType,postId:postId,creatorId:'SuperAdmin'};
			    dwr.TOPEngine.setAsync(false);
			    PostAction.queryRoleListByPostId(queryObj,function(data){
			    	var totalSize = data.count;
					var dataList = data.list;
					//加载数据源
					grid.setDatasource(dataList,totalSize);
					if(selectedKey!=''){
						grid.selectRowsByPK(selectedKey);
						selectedKey='';
					}
	        	});
			    dwr.TOPEngine.setAsync(true);
			
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
	        cui("#roleGrid").setQuery({pageNo:1});
	        //刷新列表
			cui("#roleGrid").loadData();
	     }
		 
		 
		    
			//从岗位删除角色操作
			function deleteRoleFromPost(){
				var selectIds = cui("#roleGrid").getSelectedPrimaryKey();
				var selectDatas = cui("#roleGrid").getSelectedRowData();
				for(var i=0;i<selectDatas.length;i++){
					   //获取角色的id
					   roleIds+=selectDatas[i].roleId+";";
				   }
				//转成数组，去除最后一个";"号
			    roleIds=roleIds.substring(0,roleIds.length-1);	
			    roleIds=roleIds.split(";");
				if(selectIds == null || selectIds.length == 0){
					cui.alert("请选择要删除的角色。");
					return;
				}
				
			     dwr.TOPEngine.setAsync(false);
				    PostAction.deletePostAndRoleRelation(selectIds,roleIds,postId,postRelationType,function(flag){
				    	 window.cui.message('删除角色成功。','success');
				 		cui("#roleGrid").loadData();
		        	});
			     dwr.TOPEngine.setAsync(true);
			}   
			

			//选择角色操作
			function  selectRole(){
				var url='${pageScope.cuiWebRoot}/top/sys/post/RoleSelectMain.jsp?postId='+postId;
				var height =  750;
				var width =  500;
				
				cui.extend.emDialog({
					id: 'selectRole',
					title : '角色选择页面',
					src : url,
					width : height,
					height : width
			    }).show(url);
				
			} 
			

			//添加角色操作
			function addRoleToPost(roleIds){
				
					 dwr.TOPEngine.setAsync(false);
					    PostAction.insertPostAndRoleRelation(postId,roleIds,postRelationType,function(flag){
					    	window.cui.message('添加角色成功。','success');
					 		cui("#roleGrid").loadData();
			        	});
					  dwr.TOPEngine.setAsync(true);
				
			} 
		    

</script>
</body>
</html>