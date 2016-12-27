<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
    <title>��λ�б�</title>
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
	  <div class="top_float_left">
		    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="�������λ���ơ�ȫƴ����ƴ" editable="true" width="250" on_iconclick="iconclick"  on_change="iconChange"
	        		icon="search" iconwidth="18px"></span>&nbsp;&nbsp;&nbsp;&nbsp;
	       <div uitype="checkboxGroup" id="showAllPost" name="showAllPost" on_change="showAllPostList">
			 		<input type="checkbox" name="showAll" id="showAllCheckBox"  value="1">������ʾ���и�λ 
			 </div>
	   </div>
	   <% if(!isHideSystemBtn){ %>
			<div class="top_float_right">
			<top:verifyAccess pageCode="TopPostAdmin" operateCode="updatePost">
		       <span uiType="Button" label="������λ" on_click="insertPost" id="insertPostButton" ></span>
		   </top:verifyAccess>
		   <top:verifyAccess pageCode="TopPostAdmin" operateCode="addOrdelRole">
		        <span uiType="Button" label="��ӽ�ɫ" on_click="addRoles" id="addRolesButton" ></span>
		   </top:verifyAccess>
			</div>
		<% } %>	
	 </div>
 <div id="postGridWrap">
     <table uitype="Grid" id="postGrid"   pageno="<c:out value='${param.pageNo}'/>"   pagesize="<c:out value='${param.pageSize}'/>"   primarykey="postId"  sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
		<th style="width:30px"><input type="checkbox"/></th>
		<th bindName="postName" sort="true" style="width:30%">��λ����</th>
		<th bindName="postCode" sort="true"  style="width:20%">��λ����</th>
		<th bindName="orgFullName" sort="true" style="width:50%;"  renderStyle="text-align: center">������֯ȫ·��</th>
	</table>
 
 </div>
<script language="javascript">
		var orgId = "<c:out value='${param.orgId}'/>"; 
		var orgStructureId = "<c:out value='${param.orgStructureId}'/>";
		var rootOrgId = "<c:out value='${param.rootOrgId}'/>";//��Ͻ��֯id 
	    var keyword="";
	    var associateType =""; //Ϊ1 ʱ������ѯ��2Ϊ������
	    var orgName = decodeURIComponent(decodeURIComponent("<c:out value='${param.orgName}'/>"));//��֯���� 
	    var pageNo="<c:out value='${param.pageNo}'/>"; 
	    var pageSize="<c:out value='${param.pageSize}'/>"; 
	    var operate="<c:out value='${param.operate}'/>";    //Ϊ1ʱ�㷵��
	    var operateFlag="<c:out value='${param.operateFlag}'/>";
	   
	    
		window.onload = function(){
			  
		    	comtop.UI.scan();
		    	
// 		    	if(operate==""){
		    		//���ԭ�еĻ���
// 		    		setCookie("associateType","");
// 		    		setCookie("postKeyword","");
// 		    	}

				if(operateFlag == '0'){
					setCookie("associateType","");
				}
		    	
		    	//��associateTypeֵΪ�յ�ʱ�򣬴ӻ�����ȡ��
		    	if(associateType == ""){
		    		associateType = getCookie("associateType");
		    		if(associateType == 1){
		    			cui('#showAllPost').selectAll();
		    		}
		    	}
		}
		
		
		//��Ⱦ�б�����
		function initData(grid,query){
// 				 if(operate==1){
// 					    keyword = getCookie("postKeyword");
// 					    cui("#myClickInput").setValue(keyword);
// 		         }
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
			    var queryObj = {pageNo:pageNo,pageSize:pageSize,postName:keyword,sortFieldName:sortFieldName,sortType:sortType,orgId:orgId,associateType:associateType};
			    dwr.TOPEngine.setAsync(false);
			    PostAction.queryPostListByOrgId(queryObj,function(data){
			    	var totalSize = data.count;
					var dataList = data.list;
					//��������Դ
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
			return (document.documentElement.clientHeight || document.body.clientHeight) - 60;
		}
		
		
		//����Ⱦ
		function columnRenderer(data,field) {
			
			if(field == 'postName'){
				//�滻��ʾ
				var postName = data["postName"];
				return "<a class='a_link'    onclick='javascript:readPost(\""+data["postId"]+ "\",\""+data["postName"]+ "\");'>"+postName+"</a>";
			}
		}
		
		
		
		 //������ͼƬ����¼�
		 function iconclick() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
// 			setCookie("postKeyword",keyword);
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
// 			setCookie("postKeyword",keyword);
	     }
		 
		 
		  //������ʾ��λ
		  function showAllPostList(){
			  var values = cui('#showAllPost').getValue(); 
				if(values &&  values.length == 1 && values[0] == 1){
					associateType=1;
				} else {
					associateType=0;
				}
				setCookie("associateType",associateType);
			     //ˢ���б�
			    cui("#postGrid").loadData();
		  }
           
		  //����������λҳ��
		  function insertPost(){
			   operate=1;
			  //��ת��������λ��ҳ��
			  window.parent.cui("#postBorderlayout").setContentURL("center","PostEdit.jsp?orgId="+orgId+"&orgName="+ encodeURIComponent(encodeURIComponent(orgName))+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId+'&pageNo='+pageNo+'&pageSize='+pageSize+'&operate='+operate); 
		    }
		
		  
		  //�����ȡ��λҳ��
		  function readPost(postId,postName){
			   operate=1;
	   			 window.parent.cui("#postBorderlayout").setContentURL("center","PostEdit.jsp?postId="+ postId+"&postName="+ encodeURIComponent(encodeURIComponent(postName))+"&orgId="+orgId+"&orgName="+ encodeURIComponent(encodeURIComponent(orgName))+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId+'&pageNo='+pageNo+'&pageSize='+pageSize+'&operate='+operate);   
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
		  
		//������ӹ�ͬ��ɫ
		  function addRoles(){
			  
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
					    PostAction.addRolesInPostIds(selectPostIds,roleIds,1,function(){
					    	window.cui.message('��ӽ�ɫ�ɹ���','success');
			        	});
					  dwr.TOPEngine.setAsync(true);
				
			} 
		    

</script>
</body>
</html>