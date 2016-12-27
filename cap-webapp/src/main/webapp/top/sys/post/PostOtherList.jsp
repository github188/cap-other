<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
    <title>��������λ�б�</title>
	<meta http-equiv="X-UA-Compatible" content="edge" />
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/comtop.ui.emDialog.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/cfg/dwr/interface/PostOtherAction.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/cfg/dwr/interface/PostAction.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/GradeAdminAction.js"></script>
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
	  <div class="top_float_left">
		    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="�������λ���ơ�ȫƴ����ƴ" editable="true" width="250" on_iconclick="iconclick"  on_change="iconChange"
	        		icon="search" iconwidth="18px"></span>&nbsp;&nbsp;&nbsp;&nbsp;
	       <div uitype="checkboxGroup" id="showAllPost" name="showAllPost" on_change="showAllPostList">
			 		<input type="checkbox" name="showAll" id="showAllCheckBox"  value="1">������ʾ���и�λ 
			 </div>
	   </div>
	     <% if(!isHideSystemBtn){ %>
			<div class="top_float_right">
				<top:verifyAccess pageCode="TopOtherPostAdmin" operateCode="updateOtherPost">
		       		<span uiType="Button" label="������λ" on_click="insertPost" id="insertPostButton" ></span>
		       	</top:verifyAccess>
		       	<top:verifyAccess pageCode="TopOtherPostAdmin" operateCode="addOrdelUser">
		       		<span uiType="Button" label="�����Ա" on_click="addUsers" id="addUsersButton" ></span>
		       	</top:verifyAccess>
		       	<top:verifyAccess pageCode="TopOtherPostAdmin" operateCode="addOrdelRole">
		       		<span uiType="Button" label="��ӽ�ɫ" on_click="addRoles" id="addRolesButton" ></span>
		       	</top:verifyAccess>
			</div>
			<% } %>	
	 </div>
 <div id="postGridWrap">
     <table uitype="Grid" id="postGrid"     pageno="<c:out value='${param.pageNo}'/>"   pagesize="<c:out value='${param.pageSize}'/>"    primarykey="otherPostId"  sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
		<th style="width:30px"><input type="checkbox"/></th>
		<th bindName="otherPostName" sort="true" style="width:30%">��λ����</th>
		<th bindName="otherPostCode" sort="true"  style="width:10%">��λ����</th>
		<th bindName="classifyFullPath" sort="true" style="width:50%;"  renderStyle="text-align: center">��������ȫ·��</th>
		<th bindName="otherPostFlag" sort="true"  style="width:10%" renderStyle="text-align: center">�Ƿ��׼��λ</th>
	</table>
 
 </div>
<script language="javascript">
		var  classifyId= "<c:out value='${param.classifyId}'/>";//�ڵ�ID
		var classifyName = decodeURIComponent(decodeURIComponent( "<c:out value='${param.classifyName}'/>"));//�ڵ�����
		var parentName = decodeURIComponent(decodeURIComponent( "<c:out value='${param.parentName}'/>"));//���ڵ����� 
		var parentId = "<c:out value='${param.parentId}'/>";//���ڵ�id
	    var keyword="";
	    var associateType =""; //Ϊ1 ʱ������ѯ��2Ϊ������
	    var postFlag = "<c:out value='${param.postFlag}'/>";//��λ�ڵ���  1Ϊ���� 2Ϊ��λ�ڵ�
	    var pageNo="<c:out value='${param.pageNo}'/>"; 
	    var pageSize="<c:out value='${param.pageSize}'/>"; 
	    var operate="<c:out value='${param.operate}'/>";    //Ϊ1ʱ�㷵��
	    var standandFlag = "<c:out value='${param.standandFlag}'/>";//��׼��λ��ʶ,0Ϊ������1Ϊ��׼��λ��ʶ
	    var operateFlag="<c:out value='${param.operateFlag}'/>";
	    
	    //��Ͻ����ID
    	var rootOrgId = "";
	    
	    
	    
		window.onload = function(){
		    	comtop.UI.scan();
		    	
		    	 if(globalUserId != 'SuperAdmin'){
					    dwr.TOPEngine.setAsync(false);
					    //��ѯ��Ͻ��Χ
					    GradeAdminAction.getGradeAdminOrgByUserId(globalUserId, function(orgId){
					    	if(orgId){
								rootOrgId = orgId;
							}else{
								rootOrgId = null;
							}
						});
						dwr.TOPEngine.setAsync(true);
					}
		    	
		    	
		    	
// 		    	if(operate==""){
// 		    		//���ԭ�еĻ���
// 		    		setCookie("associateType","");
// 		    		setCookie("postKeyword","");
// 		    	}
		    	
		    	if(operateFlag =='0'){
		    		setCookie("associateTypeOther","");
		    	}
		    	
		    	//��associateTypeֵΪ�յ�ʱ�򣬴ӻ�����ȡ��
		    	if(associateType == ""){
		    		associateType = getCookie("associateTypeOther");
		    		if(associateType == 1){
		    			cui('#showAllPost').selectAll();
		    		}
		    	}
		}
		
		
		//��Ⱦ�б�����
		function initData(grid,query){
			
			
// 			 if(operate==1){
// 				    keyword = getCookie("postOtherKeyword");
// 				    cui("#myClickInput").setValue(keyword);
// 	         }
		    pageNo=query.pageNo;
		    pageSize= query.pageSize;
		 
			 
				//��ȡ�����ֶ���Ϣ
			    var sortFieldName = query.sortName[0];
			    var sortType = query.sortType[0];
			   
			    if(associateType==null){
			    	//Ĭ��Ϊ������
			    	associateType=2;
			    }
			    //���ò�ѯ����
			    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,otherPostName:keyword,sortFieldName:sortFieldName,sortType:sortType,classifyId:classifyId,associateType:associateType};
			    dwr.TOPEngine.setAsync(false);
			    if(globalUserId == 'SuperAdmin'){
				    PostOtherAction.queryPosOthertByClassifyId(queryObj,function(data){
				    	var totalSize = data.count;
						var dataList = data.list;
						//��������Դ
						grid.setDatasource(dataList,totalSize);
		        	});
			    } else {
			    	queryObj.creatorId = globalUserId;
			    	PostOtherAction.queryAssignPostOther(queryObj,function(data){
				    	var totalSize = data.count;
						var dataList = data.list;
						//��������Դ
						grid.setDatasource(dataList,totalSize);
		        	});
			    }
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
		
		
		//����Ⱦ
		function columnRenderer(data,field) {
			
			if(field == 'otherPostName'){
				//�滻��ʾ
				var otherPostName = data["otherPostName"];
				return "<a class='a_link'    onclick='javascript:readPost(\""+data["otherPostId"]+ "\",\""+data["otherPostName"]+ "\");'>"+otherPostName+"</a>";
			}
			
			
	    	if(field == 'otherPostFlag'){
				if(data["otherPostFlag"]==1){
					   return "��";
				   }
				if(data["otherPostFlag"]==2){
					   return "��";
				  }
			}
		}
		
		
		
		 //������ͼƬ����¼�
		 function iconclick() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
// 			setCookie("postOtherKeyword",keyword);
	        cui("#postGrid").setQuery({pageNo:1});
	        //ˢ���б�
			cui("#postGrid").loadData();
	     }
		 
		 //������ͼƬ����¼�
		 function iconChange() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
// 			setCookie("postOtherKeyword",keyword);
	     }
		 
		 
		  //������ʾ��λ
		  function showAllPostList(){
			  var values = cui('#showAllPost').getValue(); 
				if(values &&  values.length == 1 && values[0] == 1){
					associateType=1;
				} else {
					associateType=0;
				}
				setCookie("associateTypeOther",associateType);
			     //ˢ���б�
			    cui("#postGrid").loadData();
		  }
           
		  //����������λҳ��
		  function insertPost(){
			  operate=1;
			  //��ת��������λ��ҳ��
			  window.parent.cui('#border').setContentURL("center","PostOtherEdit.jsp?classifyId=" + classifyId + "&postFlag=" + 1+ "&classifyName=" + encodeURIComponent(encodeURIComponent(classifyName))+'&pageNo='+pageNo+'&pageSize='+pageSize+'&operate='+operate+"&rootOrgId="+rootOrgId+ "&standandFlag=" + standandFlag);
		  }
		
		  
		  //�����ȡ��λҳ��
		  function readPost(postId,postName){
			  operate=1;
			  window.parent.cui('#border').setContentURL("center","PostOtherEdit.jsp?classifyId=" + postId + "&postFlag=" +2+ "&classifyName=" + encodeURIComponent(encodeURIComponent(postName)) +"&parentName=" + encodeURIComponent(encodeURIComponent(classifyName))+ "&parentId=" + classifyId+'&pageNo='+pageNo+'&pageSize='+pageSize+'&operate='+operate+"&rootOrgId="+rootOrgId+ "&standandFlag=" + standandFlag);   
		  }
		  
		//дcookies 
		  function setCookie(name,value) { 
		      var Days = 30; 
		      var exp = new Date(); 
		      exp.setTime(exp.getTime() + Days*24*60*60*1000); 
		      document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString(); 
		  } 

		  //��ȡcookies 
		  function getCookie(name) { 
		      var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
		      if(arr=document.cookie.match(reg)){
		          return unescape(arr[2]); 
		      } else{
		          return null; 
		      } 
		  } 

		  
		  //���������Ա
		  function addUsers(){
			  
				var selectIds = cui("#postGrid").getSelectedPrimaryKey();
				//��ȡѡ�������
				var selectRowData=cui("#postGrid").getSelectedRowData();
				
				for(var i=0;i<selectRowData.length;i++){
					var standardPostFlag=selectRowData[i].otherPostFlag;
					if(standardPostFlag==2){
						cui.alert("ѡ��ĸ�λ���ܰ�����׼��λ��");
	 				    return;
					}
				}
				
				
				
				if(selectIds == null || selectIds.length == 0){
					cui.alert("��ѡ��Ҫ�����Ա�ĸ�λ��");
					return;
				}
				
				 var obj ={};
				  obj.chooseMode = 0;
				  obj.chooseType = 'user';
				  obj.userType = 1;
				  obj.callback = "chooseCallback";
				  obj.rootId = rootOrgId;
				  displayUserOrgTag(obj);
				
		  }
		  
		  
			//�Ӹ�λ��ӹ�ͬ��Ա
			function chooseCallback(selected){
				   //ѡ��ĸ�λ
				  var selectPostIds = cui("#postGrid").getSelectedPrimaryKey();
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
					     dwr.TOPEngine.setAsync(false);
					     PostAction.addUsersInPostIds(selectPostIds,userIds,2,function(){
						    	 window.cui.message('�����Ա�ɹ���','success');
				        	});
						  dwr.TOPEngine.setAsync(true);
			        }
			} 
			
			
			 //������ӹ�ͬ��ɫ
			  function addRoles(){
				 
					//��ȡѡ�������
					var selectRowData=cui("#postGrid").getSelectedRowData();
					
					var selectIds = cui("#postGrid").getSelectedPrimaryKey();
					if(selectIds == null || selectIds.length == 0){
						cui.alert("��ѡ��Ҫ��ӽ�ɫ�ĸ�λ��");
						return;
					}
					
					var url='${pageScope.cuiWebRoot}/top/sys/post/RoleSelectMain.jsp';
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
			 
			//ѡ���ɫ��ص�����
				function addRoleToPost(roleIds){
					var selectPostIds = cui("#postGrid").getSelectedPrimaryKey();
						 dwr.TOPEngine.setAsync(false);
						    PostAction.addRolesInPostIds(selectPostIds,roleIds,2,function(){
						    	window.cui.message('��ӽ�ɫ�ɹ���','success');
				        	});
						  dwr.TOPEngine.setAsync(true);
					
				} 
			
		    

</script>
</body>
</html>