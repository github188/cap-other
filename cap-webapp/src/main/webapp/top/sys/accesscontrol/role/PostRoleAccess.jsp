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
<div uitype="Borderlayout" id="body"  is_root="true">

<div  uitype="bpanel" id="leftMain" position="left" width="288"  show_expand_icon="true">       
         <table width="95%" style="margin-left: 10px">
				<tr id="tr_moduleTree">
					<td style="height: 5px" ></td>
				</tr>
				<tr>
					
				</tr>
				
				
			</table>
         </div>
         
         <div  uitype="bpanel"  position="center" id="centerMain2" header_title="角色列表"   
          height="500">
			
		</div>
	
</div>
<script type="text/javascript">
     var subjectId="<c:out value='${param.postId}'/>";
     var subjectTypeCode="";
     // queryCondition={};
	  $(document).ready(function (){
		comtop.UI.scan(); 
		roleList();
	  });  
	  function roleList() {
			cui('#body').setContentURL(
					"center",
					'RoleList.jsp?subjectId=' + subjectId + "&subjectTypeCode="+ subjectTypeCode);
		}
	//快速查询
		/*function fastQuery(){
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
		}*/
	
		//搜索框图片点击事件
       /* var gridKeyword="";
   	 	function iconclick() {
   	 	   gridKeyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
   	 	   gridKeyword = gridKeyword.replace(new RegExp("'", "gm"), "''");
   	 	   gridKeyword = gridKeyword.replace(new RegExp("%", "gm"), "/%");
   	 	   gridKeyword = gridKeyword.replace(new RegExp("_", "gm"), "/_");
           cui("#roleGrid").setQuery({pageNo:1});
	   	   cui("#roleGrid").loadData();
        }*/
		//渲染列表数据
    	/*function initGridData(grid,query){
			//
    	    var sortFieldName = query.sortName[0];
    	    var sortType = query.sortType[0];
    	    queryCondition.pageNo=query.pageNo;
    	    queryCondition.pageSize=query.pageSize;
    	    queryCondition.subjectId=subjectId;
    	    queryCondition.fastQueryValue=gridKeyword;
    	    queryCondition.sortFieldName=sortFieldName;
    	   // queryCondition.subjection
    	    queryCondition.sortType=sortType;
    	    alert("dfdf");
    	    SubjectRoleAction.queryRoleBySubjectId(queryCondition,function(data){
     	     	var totalSize = data.count;
     	    	var dataList = data.list;
    			grid.setDatasource(dataList,totalSize);
            });
      	}*/
      	
        //Grid组件自适应宽度回调函数，返回高度计算结果即可
    	/*function resizeWidth(){
			return $('body').width() - 292;
    		//return (document.documentElement.clientWidth || document.body.clientWidth) - 297;
    	}*/

    	//Grid组件自适应高度回调函数，返回宽度计算结果即可
    	/*function resizeHeight(){
    		return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
    	}*/

    	function title (rowData, bindName) {
    		//if(bindName == 'operator'){
	    	//	return "导出  授权  删除";
    		//}
        }

    	function addCallBack(){
    		alert("dfdfsdfds=============");
        	//清空查询条件，清除题头排序条件
        	cui("#myClickInput").setValue("");
        	gridKeyword="";
    		cui("#roleGrid").setQuery({pageNo:1,sortType:[],sortName:[]});
    		cui("#roleGrid").loadData();
    		//cui("#roleGrid").selectRowsByPK(roleId);
    	}
    	//列渲染
    	function columnRenderer(data,field) {
    		//if(field == 'operator'){
        		//if(globalUserId == data["creatorId"] || globalUserId == 'SuperAdmin' ){
	    			//return "<a class='a_link' href='javascript:exportRoleAccess(\""+data["roleId"]+"\");'>导出</a>"
	    			// + "&nbsp;&nbsp;&nbsp;<a class='a_link' href='javascript:setRoleAccess(\""+data["roleId"]+"\",\""+data["roleName"]+"\");'>授权</a>"
	    			// + "&nbsp;&nbsp;&nbsp;<a class='a_link' href='javascript:deleteOneRole(\""+data["roleId"]+"\",\""+data["roleName"]+"\");'>删除</a>";
            	/*}else{
            		return "导出"
            		+ "&nbsp;&nbsp;&nbsp;<a class='a_link' href='javascript:setRoleAccess(\""+data["roleId"]+"\",\""+data["roleName"]+"\",\"app\");'>授权</a>"
            		+ "&nbsp;&nbsp;&nbsp;删除";
                }*/
    		//}
    		//if(field == 'roleName'){
    			//if(globalUserId == data["creatorId"] || globalUserId == 'SuperAdmin' ){
    			//	return "<a class='a_link' href='javascript:eidtRole(\""+data["roleId"]+ "\",\""+data["creatorId"]+"\");'>"+data["roleName"]+"</a>";
    		    //}
    		//}
        }

	</script>
</body>
</html>