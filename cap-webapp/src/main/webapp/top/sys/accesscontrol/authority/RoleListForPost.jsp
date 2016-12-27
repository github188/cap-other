<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>��ɫ�б�</title>
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
			<th bindName="ROLE_NAME" >��ɫ����</th>
			<th bindName="ROLE_DESC" >����</th>
			<th bindName="CLASSIFY_NAME" renderStyle="text-align: center" >��������</th>
	</table>
 </div>
<script language="javascript">
	
		var postId ="<c:out value='${param.postId}'/>";
		var userId = "<c:out value='${param.userId}'/>";
		var funcId = "<c:out value='${param.funcId}'/>";

		window.onload = function(){
			comtop.UI.scan();
		}
		
		//��Ⱦ�б�����
		function initData(grid,query){
			//��ȡ�����ֶ���Ϣ
		    var sortFieldName = query.sortName[0];
		    var sortType = query.sortType[0];
		    //���ò�ѯ����
		    var queryObj = {sortFieldName:sortFieldName,sortType:sortType,classifyId:postId,userId:userId,funcId:funcId};
		    dwr.TOPEngine.setAsync(false);
		    AuthorityFinderAction.queryPersonPostRoleListByFuncId(queryObj, function(data){
		    	var totalSize = data.count;
				var dataList = data.list;
				grid.setDatasource(dataList,totalSize);
		    }); 
		    dwr.TOPEngine.setAsync(true);
	  	}
		
	    //Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth)-20;
		}

		//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 25;
		}

</script>
</body>
</html>