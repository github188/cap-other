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
	    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="�������ɫ����" editable="true" width="250" on_iconclick="iconclick"
        		icon="search" iconwidth="18px"></span>
 </div>
 <div id="userGridWrap">
     <table uitype="Grid" id="roleGrid" primarykey="subjectRoleId"   sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
		                    <th  id="checkboxId"  style="width:30px;"><input type="checkbox"></th>
							<th  bindName="roleName" sort="true">��ɫ����</th>
							<th  bindName="roleDescription" sort="true" >����</th>
							<th  bindName="createTime" sort="true"  renderStyle="text-align: center"  format="yyyy-MM-dd">��������</th>
							<th  bindName="strRoleType"  sort="true"  renderStyle="text-align: center" >��ɫ����</th>
	</table>
 
 </div>
<script language="javascript">
		var orgId = "<c:out value='${param.orgId}'/>"; 
		var postId ="<c:out value='${param.postId}'/>";
		var orgStructureId = "<c:out value='${param.orgStructureId}'/>";
		var rootOrgId = "<c:out value='${param.rootOrgId}'/>";//����֯id 
	    var keyword="";
		var roleIds="";
	    var postRelationType= "<c:out value='${param.postRelationType}'/>";   //1Ϊ���� 2Ϊ������

	    
	  //��ѡ���е������������������༭ʱ�Զ�ѡ��
		var selectedKey='';
	  

     

		window.onload = function(){
			comtop.UI.scan();
		}
		
		
		//��Ⱦ�б�����
		function initData(grid,query){
			
				//��ȡ�����ֶ���Ϣ
			    var sortFieldName = query.sortName[0];
			    var sortType = query.sortType[0];
			    //���ò�ѯ����
			    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:keyword,sortFieldName:sortFieldName,sortType:sortType,postId:postId,creatorId:'SuperAdmin'};
			    dwr.TOPEngine.setAsync(false);
			    PostAction.queryRoleListByPostId(queryObj,function(data){
			    	var totalSize = data.count;
					var dataList = data.list;
					//��������Դ
					grid.setDatasource(dataList,totalSize);
					if(selectedKey!=''){
						grid.selectRowsByPK(selectedKey);
						selectedKey='';
					}
	        	});
			    dwr.TOPEngine.setAsync(true);
			
	  	}
	    //Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth)-20;
		}

		//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 60;
		}
		
		
		 //������ͼƬ����¼�
		 function iconclick() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
	        cui("#roleGrid").setQuery({pageNo:1});
	        //ˢ���б�
			cui("#roleGrid").loadData();
	     }
		 
		 
		    
			//�Ӹ�λɾ����ɫ����
			function deleteRoleFromPost(){
				var selectIds = cui("#roleGrid").getSelectedPrimaryKey();
				var selectDatas = cui("#roleGrid").getSelectedRowData();
				for(var i=0;i<selectDatas.length;i++){
					   //��ȡ��ɫ��id
					   roleIds+=selectDatas[i].roleId+";";
				   }
				//ת�����飬ȥ�����һ��";"��
			    roleIds=roleIds.substring(0,roleIds.length-1);	
			    roleIds=roleIds.split(";");
				if(selectIds == null || selectIds.length == 0){
					cui.alert("��ѡ��Ҫɾ���Ľ�ɫ��");
					return;
				}
				
			     dwr.TOPEngine.setAsync(false);
				    PostAction.deletePostAndRoleRelation(selectIds,roleIds,postId,postRelationType,function(flag){
				    	 window.cui.message('ɾ����ɫ�ɹ���','success');
				 		cui("#roleGrid").loadData();
		        	});
			     dwr.TOPEngine.setAsync(true);
			}   
			

			//ѡ���ɫ����
			function  selectRole(){
				var url='${pageScope.cuiWebRoot}/top/sys/post/RoleSelectMain.jsp?postId='+postId;
				var height =  750;
				var width =  500;
				
				cui.extend.emDialog({
					id: 'selectRole',
					title : '��ɫѡ��ҳ��',
					src : url,
					width : height,
					height : width
			    }).show(url);
				
			} 
			

			//��ӽ�ɫ����
			function addRoleToPost(roleIds){
				
					 dwr.TOPEngine.setAsync(false);
					    PostAction.insertPostAndRoleRelation(postId,roleIds,postRelationType,function(flag){
					    	window.cui.message('��ӽ�ɫ�ɹ���','success');
					 		cui("#roleGrid").loadData();
			        	});
					  dwr.TOPEngine.setAsync(true);
				
			} 
		    

</script>
</body>
</html>