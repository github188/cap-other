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
         <div  uitype="bpanel"  position="center" id="centerMain" header_title="��ɫ�б�"    height="500">
			<div class="list_header_wrap" style="">
				<div class="top_float_left">
					<span uitype="ClickInput" id="myClickInput" name="clickInput" editable="true" emptytext="�������ɫ����" on_keydown="keyDowngGridQuery"
			         width="280" on_iconclick="iconclick" icon="${pageScope.cuiWebRoot}/top/sys/images/querysearch.gif"></span>
				</div>
				<div class="top_float_right">
					<span uitype="button" id="addRoleButton" label="������ɫ" on_click="addRole"></span>
					<span uitype="button" id="deleteRoleButton" label="ɾ����ɫ" on_click="deleteRole"></span>
				</div>
			</div>
			<div id="grid_wrap">
			<table uitype="grid" id="roleGrid" sorttype="1" datasource="initGridData" pagesize_list="[10,20,30]" pagesize="10"
			      primarykey="roleId" resizewidth="resizeWidth" resizeheight="resizeHeight"  colrender="columnRenderer" titlerender="title">
							<th  style="width:30px;"><input type="checkbox"></th>
							<th  bindName="roleName" sort="true">��ɫ����</th>
							<th  bindName="description" sort="true" >����</th>
							<th  bindName="creatorName"  sort="true"  renderStyle="text-align: center" >������</th>
							<th  bindName="createTime" sort="true"  renderStyle="text-align: center"  format="yyyy-MM-dd">��������</th>
							<th  bindName="strRoleType"  sort="true"  renderStyle="text-align: center" >��ɫ����</th>
							
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
	//���ٲ�ѯ
		function fastQuery(){
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
		}
	
		//������ͼƬ����¼�
        var gridKeyword="";
   	 	function iconclick() {
   	 	   gridKeyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
   	 	   gridKeyword = gridKeyword.replace(new RegExp("'", "gm"), "''");
   	 	   gridKeyword = gridKeyword.replace(new RegExp("%", "gm"), "/%");
   	 	   gridKeyword = gridKeyword.replace(new RegExp("_", "gm"), "/_");
           cui("#roleGrid").setQuery({pageNo:1});
	   	   cui("#roleGrid").loadData();
        }
		//��Ⱦ�б�����
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
      	
        //Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
    	function resizeWidth(){
        	//alert()
			return $('body').width()-5 ;
    		//return (document.documentElement.clientWidth || document.body.clientWidth) - 297;
    	}

    	//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
    	function resizeHeight(){
    		return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
    	}

    	function addRole(){
    		
    		var url='${pageScope.cuiWebRoot}/top/sys/accesscontrol/role/AddRole.jsp?subjectId='+subjectId;
  			 var title="������ɫ";
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
        	//��ղ�ѯ�����������ͷ��������
        	cui("#myClickInput").setValue("");
        	gridKeyword="";
    		cui("#roleGrid").setQuery({pageNo:1,sortType:[],sortName:[]});
    		cui("#roleGrid").loadData();
    		//cui("#roleGrid").selectRowsByPK(roleId);
    	}

    	
    	
    	//ɾ����ť
   		function deleteRole(){
   			var selectIds = cui("#roleGrid").getSelectedPrimaryKey();//��ȡҪɾ����������
   			if(selectIds == null || selectIds.length == 0){
   				cui.alert("��ѡ��Ҫɾ���Ľ�ɫ��");
   				return;
   			}
   			var message = "ȷ���Ӹ�λ��ɾ����"+selectIds.length+"����ɫ��";
   			deleteRoles(selectIds,message);//ɾ����ɫ
   		}

   		//ɾ����ɫ
   	    function deleteRoles(selectIds,message){
   			cui.confirm(message, {
				buttons: [{
					name: 'ȷ��',
					handler: function(){
						dwr.TOPEngine.setAsync(false);
	   					RoleAction.deleteRoles(selectIds,function(){
	   						cui("#roleGrid").removeData(cui("#roleGrid").getSelectedIndex());
	   						cui("#roleGrid").loadData();
	   						cui.message("ɾ��"+selectIds.length+"����ɫ�ɹ�","success");
	   			        });
	   					dwr.TOPEngine.setAsync(true);
   			  		}
				}
				,{
					name: 'ȡ��',
					handler: function(){
					}
				}]
			});
			
    	}
	</script>
</body>
</html>