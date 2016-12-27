<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>行政岗位列表</title>
	<meta http-equiv="X-UA-Compatible" content="edge" />
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/comtop.ui.emDialog.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostOtherAction.js"></script>
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
	  <div class="top_float_left">
		    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="请输入岗位名称、全拼、简拼" editable="true" width="250" on_iconclick="iconclick"  on_change="iconChange"
	        		icon="search" iconwidth="18px"></span>
	   </div>
	   <top:verifyAccess pageCode="TopOtherPostAdmin" operateCode="addOrdelPost">
			<div class="top_float_right">
		       <span uiType="Button" label="添加行政岗位" on_click="selectPost" id="addPostButton" ></span>
		        <span uiType="Button" label="删除行政岗位" on_click="deletePost" id="deletePostButton" ></span>
			</div>
	   </top:verifyAccess>		
	 </div>
 <div id="postGridWrap">
     <table uitype="Grid" id="postGrid"   pageno="<c:out value='${param.pageNo}'/>"   pagesize="<c:out value='${param.pageSize}'/>"   primarykey="postId"  sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
		<th style="width:30px"><input type="checkbox"/></th>
		<th bindName="postName" sort="true" style="width:30%">岗位名称</th>
		<th bindName="postCode" sort="true"  style="width:20%">岗位编码</th>
		<th bindName="orgFullName" sort="true" style="width:50%;"  renderStyle="text-align: center">所属组织全路径</th>
	</table>
 
 </div>
<script language="javascript">
	   
	   //标准岗位id
        var postId ="<c:out value='${param.postId}'/>";
        var rootOrgId = "<c:out value='${param.rootOrgId}'/>";//根组织id 
	    var keyword="";
	    
		
		window.onload = function(){
		    	comtop.UI.scan();
		}
		
		
		//渲染列表数据
		function initData(grid,query){

				//获取排序字段信息
			    var sortFieldName = query.sortName[0];
			    var sortType = query.sortType[0];
			  
			    //设置查询条件
			    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,postName:keyword,sortFieldName:sortFieldName,sortType:sortType,postId:postId};
			    dwr.TOPEngine.setAsync(false);
			    PostOtherAction.queryPostListByStandard(queryObj,function(data){
			    	var totalSize = data.count;
					var dataList = data.list;
					//加载数据源
					grid.setDatasource(dataList,totalSize);
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
	        cui("#postGrid").setQuery({pageNo:1});
	        //刷新列表
			cui("#postGrid").loadData();
	     }
		 
	
		 
		 //搜索框图片点击事件
		 function iconChange() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
	     }
		 
			//选择行政岗位
			function  selectPost(){
				var url='${pageScope.cuiWebRoot}/top/sys/post/PostSelectMain.jsp?rootOrgId='+rootOrgId+"&postId="+postId;
				var height =  750;
				var width =  500;
				
				cui.extend.emDialog({
					id: 'selectPost',
					title : '岗位选择页面',
					src : url,
					width : height,
					height : width
			    }).show(url);
				
			} 
			
			//删除行政岗位
			function  deletePost(){
			
				  var selectIds = cui("#postGrid").getSelectedPrimaryKey();

					if(selectIds == null || selectIds.length == 0){
						cui.alert("请选择删除的岗位。");
						return;
					}

					 dwr.TOPEngine.setAsync(false);
					 PostOtherAction.updatePostStandardRelation(postId,selectIds,2,function(){
					    	window.cui.message('删除成功。','success');
					 		cui("#postGrid").loadData();
			     	 });
					 dwr.TOPEngine.setAsync(true);
			} 
			
		 
		 

</script>
</body>
</html>