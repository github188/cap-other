<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB18030">
<title>��λ��Ȩ</title>
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
         
         <div  uitype="bpanel"  position="center" id="centerMain2" header_title="��ɫ�б�"   
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
	//���ٲ�ѯ
		/*function fastQuery(){
			var keyword = cui('#keyword').getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("'", "gm"), "''");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_", "gm"), "/_");
			if(keyword == ''){
				switchTreeListStyle("tree");
				//TODO ����ѡ��ڵ㣬��ˢ���Ҳ�iframe
				var node = cui('#roleClassifyTree').getNode(curNodeId);
				if(node){
					treeClick(node);
				}
			}else{
				switchTreeListStyle("list");
				listBoxData(cui('#fastQueryList'),keyword);
			}
		}*/
	
		//������ͼƬ����¼�
       /* var gridKeyword="";
   	 	function iconclick() {
   	 	   gridKeyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
   	 	   gridKeyword = gridKeyword.replace(new RegExp("'", "gm"), "''");
   	 	   gridKeyword = gridKeyword.replace(new RegExp("%", "gm"), "/%");
   	 	   gridKeyword = gridKeyword.replace(new RegExp("_", "gm"), "/_");
           cui("#roleGrid").setQuery({pageNo:1});
	   	   cui("#roleGrid").loadData();
        }*/
		//��Ⱦ�б�����
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
      	
        //Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
    	/*function resizeWidth(){
			return $('body').width() - 292;
    		//return (document.documentElement.clientWidth || document.body.clientWidth) - 297;
    	}*/

    	//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
    	/*function resizeHeight(){
    		return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
    	}*/

    	function title (rowData, bindName) {
    		//if(bindName == 'operator'){
	    	//	return "����  ��Ȩ  ɾ��";
    		//}
        }

    	function addCallBack(){
    		alert("dfdfsdfds=============");
        	//��ղ�ѯ�����������ͷ��������
        	cui("#myClickInput").setValue("");
        	gridKeyword="";
    		cui("#roleGrid").setQuery({pageNo:1,sortType:[],sortName:[]});
    		cui("#roleGrid").loadData();
    		//cui("#roleGrid").selectRowsByPK(roleId);
    	}
    	//����Ⱦ
    	function columnRenderer(data,field) {
    		//if(field == 'operator'){
        		//if(globalUserId == data["creatorId"] || globalUserId == 'SuperAdmin' ){
	    			//return "<a class='a_link' href='javascript:exportRoleAccess(\""+data["roleId"]+"\");'>����</a>"
	    			// + "&nbsp;&nbsp;&nbsp;<a class='a_link' href='javascript:setRoleAccess(\""+data["roleId"]+"\",\""+data["roleName"]+"\");'>��Ȩ</a>"
	    			// + "&nbsp;&nbsp;&nbsp;<a class='a_link' href='javascript:deleteOneRole(\""+data["roleId"]+"\",\""+data["roleName"]+"\");'>ɾ��</a>";
            	/*}else{
            		return "����"
            		+ "&nbsp;&nbsp;&nbsp;<a class='a_link' href='javascript:setRoleAccess(\""+data["roleId"]+"\",\""+data["roleName"]+"\",\"app\");'>��Ȩ</a>"
            		+ "&nbsp;&nbsp;&nbsp;ɾ��";
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