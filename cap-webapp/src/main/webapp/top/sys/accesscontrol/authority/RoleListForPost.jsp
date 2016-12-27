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
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/AuthorityFinderAction.js"></script>
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
 <div id="userGridWrap">
     <table uitype="Grid" id="roleGrid" primarykey="ROLE_ID"   sorttype="1" datasource="initData" pagination="false"
     	 resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
            <th id="checkboxId"  style="width:30px;"><input type="checkbox"></th>
			<th bindName="ROLE_NAME" >角色名称</th>
			<th bindName="ROLE_DESC" >描述</th>
			<th bindName="CLASSIFY_NAME" renderStyle="text-align: center" >所属分类</th>
	</table>
 </div>
<script language="javascript">
	
		var postId ="<c:out value='${param.postId}'/>";
		var userId = "<c:out value='${param.userId}'/>";
		var funcId = "<c:out value='${param.funcId}'/>";

		window.onload = function(){
			comtop.UI.scan();
		}
		
		//渲染列表数据
		function initData(grid,query){
			//获取排序字段信息
		    var sortFieldName = query.sortName[0];
		    var sortType = query.sortType[0];
		    //设置查询条件
		    var queryObj = {sortFieldName:sortFieldName,sortType:sortType,classifyId:postId,userId:userId,funcId:funcId};
		    dwr.TOPEngine.setAsync(false);
		    AuthorityFinderAction.queryPersonPostRoleListByFuncId(queryObj, function(data){
		    	var totalSize = data.count;
				var dataList = data.list;
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
			return (document.documentElement.clientHeight || document.body.clientHeight) - 25;
		}

</script>
</body>
</html>