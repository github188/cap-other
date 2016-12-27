<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
    <title>��Ա�б�</title>
	<meta http-equiv="X-UA-Compatible" content="edge" />
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/comtop.ui.emDialog.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostAction.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/js/userOrgUtil.js"></script>
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
	    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="������������ȫƴ����ƴ" editable="true" width="250" on_iconclick="iconclick"
        		icon="search" iconwidth="18px"></span>
       <% if(!isHideSystemBtn){ %>
		<div class="top_float_right">
		<c:choose>
			<c:when test="${param.postRelationType=='1'}">
				<top:verifyAccess pageCode="TopPostAdmin" operateCode="addOrdelUser">
					<span uiType="Button" label="�����Ա" on_click="displayUserTag" id="displayUserTag"></span>
				    <span uiType="Button" label="ɾ����Ա" on_click="deleteUserFromPost" id="deleteUserFromPost"></span>
			    </top:verifyAccess>
		    </c:when>
		    <c:otherwise>
		    	<top:verifyAccess pageCode="TopOtherPostAdmin" operateCode="addOrdelUser">
			    	<span uiType="Button" label="�����Ա" on_click="displayUserTag" id="displayUserTag"></span>
				    <span uiType="Button" label="ɾ����Ա" on_click="deleteUserFromPost" id="deleteUserFromPost"></span>
			    </top:verifyAccess>
		    </c:otherwise>
		</c:choose>
		</div>
	  <% } %>
 </div>
 <div id="userGridWrap">
     <table uitype="Grid" id="userGrid" primarykey="userRePostId"  sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
		<th style="width:30px"><input type="checkbox"/></th>
		<th bindName="employeeName" sort="true" style="width:12%">����</th>
		<th bindName="account" sort="true"  style="width:18%">�˺�</th>
	    <th bindName="updateTime" sort="true" style="width:15%;"  renderStyle="text-align: center" format="yyyy-MM-dd">��������</th>
		<th bindName="createTime" sort="true" style="width:15%;"  renderStyle="text-align: center" format="yyyy-MM-dd">��������</th>
		<th bindName="orgFullName" sort="true" style="width:40%;"  renderStyle="text-align: center">������֯ȫ·��</th>
	</table>
 
 </div>
<script language="javascript">
		var orgId = "<c:out value='${param.orgId}'/>"; 
		var classifyId = "<c:out value='${param.classifyId}'/>";//����ID
		var postId = "<c:out value='${param.postId}'/>";
		var orgStructureId = "<c:out value='${param.orgStructureId}'/>";
		var rootOrgId = "<c:out value='${param.rootOrgId}'/>";//����֯id 
	    var keyword="";
	    var employeeState=1;  //Ĭ����ʾ��ְ�û�
		var userIds="";
	    var postType=0   //1Ϊ���� 2Ϊ������
	    var postRelationType="<c:out value='${param.postRelationType}'/>";   //1Ϊ���� 2Ϊ������

	  
	  //��ѡ���е������������������༭ʱ�Զ�ѡ��
		var selectedKey='';
	  

     

		window.onload = function(){
		    if(window.parent.$('#centerMain').is(":visible")){ 
		    	comtop.UI.scan();
		    }
		}
		
		
		//��Ⱦ�б�����
		function initData(grid,query){
			 
				//��ȡ�����ֶ���Ϣ
			    var sortFieldName = query.sortName[0];
			    var sortType = query.sortType[0];
			    //���ò�ѯ����
			    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:keyword,sortFieldName:sortFieldName,sortType:sortType,postId:postId,postRelationType:postRelationType,orgId:rootOrgId};
			    dwr.TOPEngine.setAsync(false);
			    PostAction.queryUserListByPostId(queryObj,function(data){
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
	        cui("#userGrid").setQuery({pageNo:1});
	        //ˢ���б�
			cui("#userGrid").loadData();
	     }
		 
		 
		    
			//�Ӹ�λɾ����Ա����
			function deleteUserFromPost(){
				var selectIds = cui("#userGrid").getSelectedPrimaryKey();
				var selectDatas = cui("#userGrid").getSelectedRowData();
				var delUserIds="";
				for(var i=0;i<selectDatas.length;i++){
					   //��ȡ�û���id
					   delUserIds+=selectDatas[i].userId+";";
				   }
				//ת�����飬ȥ�����һ��";"��
			    delUserIds=delUserIds.substring(0,delUserIds.length-1);	
			    delUserIds=delUserIds.split(";");
				if(selectIds == null || selectIds.length == 0){
					cui.alert("��ѡ��Ҫɾ������Ա��");
					return;
				}
				
			     dwr.TOPEngine.setAsync(false);
				    PostAction.deletePostAndUserRelation(selectIds,delUserIds,postId,function(flag){
				    	 window.cui.message('ɾ����Ա�ɹ���','success');
				 		cui("#userGrid").loadData();
		        	});
			     dwr.TOPEngine.setAsync(true);
			     
			   
			}   
			

			//�Ӹ�λ�����Ա����
			function chooseCallback(selected){
				     userIds="";
					if(selected!=''){
						for(var i=0;i<selected.length;i++){
							   //��ȡ�û���id
							   userIds+=selected[i].id+";";
						   }
						
						//ȥ�����һ��";"��
					    userIds=userIds.substring(0,userIds.length-1);	
					    userIds=userIds.split(";");
					    
					}
			        if(userIds==''||userIds.length==0){
			        	cui.alert("û��ѡ����Ա��");
			        }else{
			        	 if(orgId){
			        		 postType=1; 
			        	 }else {
			        		 postType=2; 
			        	 }
			        	
					     dwr.TOPEngine.setAsync(false);
						    PostAction.insertPostAndUserRelation(postId,userIds,postType,function(flag){
						    	 window.cui.message('�����Ա�ɹ���','success');
						    	//��ղ�ѯ����
						         cui("#myClickInput").setValue("");
						         keyword="";
						 		cui("#userGrid").loadData();
						 		
				        	});
						  dwr.TOPEngine.setAsync(true);
			        	
						 
			        }
			   
				  
				  
			} 
			
			function displayUserTag(){
				  
				  var obj ={};
				  obj.chooseMode = 0;
				  obj.chooseType = 'user';
				  obj.userType = 1;
				  obj.callback = "chooseCallback";
				  obj.orgStructureId=orgStructureId;
					  if(postRelationType==1){
					    obj.rootId = orgId;
					  }
					  if(postRelationType==2){
						    obj.rootId = rootOrgId;
					 }
				  displayUserOrgTag(obj);
			}
		    

</script>
</body>
</html>