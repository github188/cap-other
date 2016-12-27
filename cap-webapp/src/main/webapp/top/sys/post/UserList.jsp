<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
    <title>人员列表</title>
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
	    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="请输入姓名、全拼、简拼" editable="true" width="250" on_iconclick="iconclick"
        		icon="search" iconwidth="18px"></span>
       <% if(!isHideSystemBtn){ %>
		<div class="top_float_right">
		<c:choose>
			<c:when test="${param.postRelationType=='1'}">
				<top:verifyAccess pageCode="TopPostAdmin" operateCode="addOrdelUser">
					<span uiType="Button" label="添加人员" on_click="displayUserTag" id="displayUserTag"></span>
				    <span uiType="Button" label="删除人员" on_click="deleteUserFromPost" id="deleteUserFromPost"></span>
			    </top:verifyAccess>
		    </c:when>
		    <c:otherwise>
		    	<top:verifyAccess pageCode="TopOtherPostAdmin" operateCode="addOrdelUser">
			    	<span uiType="Button" label="添加人员" on_click="displayUserTag" id="displayUserTag"></span>
				    <span uiType="Button" label="删除人员" on_click="deleteUserFromPost" id="deleteUserFromPost"></span>
			    </top:verifyAccess>
		    </c:otherwise>
		</c:choose>
		</div>
	  <% } %>
 </div>
 <div id="userGridWrap">
     <table uitype="Grid" id="userGrid" primarykey="userRePostId"  sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
		<th style="width:30px"><input type="checkbox"/></th>
		<th bindName="employeeName" sort="true" style="width:12%">姓名</th>
		<th bindName="account" sort="true"  style="width:18%">账号</th>
	    <th bindName="updateTime" sort="true" style="width:15%;"  renderStyle="text-align: center" format="yyyy-MM-dd">任命日期</th>
		<th bindName="createTime" sort="true" style="width:15%;"  renderStyle="text-align: center" format="yyyy-MM-dd">创建日期</th>
		<th bindName="orgFullName" sort="true" style="width:40%;"  renderStyle="text-align: center">所属组织全路径</th>
	</table>
 
 </div>
<script language="javascript">
		var orgId = "<c:out value='${param.orgId}'/>"; 
		var classifyId = "<c:out value='${param.classifyId}'/>";//分类ID
		var postId = "<c:out value='${param.postId}'/>";
		var orgStructureId = "<c:out value='${param.orgStructureId}'/>";
		var rootOrgId = "<c:out value='${param.rootOrgId}'/>";//根组织id 
	    var keyword="";
	    var employeeState=1;  //默认显示在职用户
		var userIds="";
	    var postType=0   //1为行政 2为非行政
	    var postRelationType="<c:out value='${param.postRelationType}'/>";   //1为行政 2为非行政

	  
	  //被选中列的主键，用于新增及编辑时自动选中
		var selectedKey='';
	  

     

		window.onload = function(){
		    if(window.parent.$('#centerMain').is(":visible")){ 
		    	comtop.UI.scan();
		    }
		}
		
		
		//渲染列表数据
		function initData(grid,query){
			 
				//获取排序字段信息
			    var sortFieldName = query.sortName[0];
			    var sortType = query.sortType[0];
			    //设置查询条件
			    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:keyword,sortFieldName:sortFieldName,sortType:sortType,postId:postId,postRelationType:postRelationType,orgId:rootOrgId};
			    dwr.TOPEngine.setAsync(false);
			    PostAction.queryUserListByPostId(queryObj,function(data){
			    	var totalSize = data.count;
					var dataList = data.list;
					//加载数据源
					grid.setDatasource(dataList,totalSize);
					if(selectedKey!=''){
						grid.selectRowsByPK(selectedKey);
						selectedKey='';
					}
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
	        cui("#userGrid").setQuery({pageNo:1});
	        //刷新列表
			cui("#userGrid").loadData();
	     }
		 
		 
		    
			//从岗位删除人员操作
			function deleteUserFromPost(){
				var selectIds = cui("#userGrid").getSelectedPrimaryKey();
				var selectDatas = cui("#userGrid").getSelectedRowData();
				var delUserIds="";
				for(var i=0;i<selectDatas.length;i++){
					   //获取用户的id
					   delUserIds+=selectDatas[i].userId+";";
				   }
				//转成数组，去除最后一个";"号
			    delUserIds=delUserIds.substring(0,delUserIds.length-1);	
			    delUserIds=delUserIds.split(";");
				if(selectIds == null || selectIds.length == 0){
					cui.alert("请选择要删除的人员。");
					return;
				}
				
			     dwr.TOPEngine.setAsync(false);
				    PostAction.deletePostAndUserRelation(selectIds,delUserIds,postId,function(flag){
				    	 window.cui.message('删除人员成功。','success');
				 		cui("#userGrid").loadData();
		        	});
			     dwr.TOPEngine.setAsync(true);
			     
			   
			}   
			

			//从岗位添加人员操作
			function chooseCallback(selected){
				     userIds="";
					if(selected!=''){
						for(var i=0;i<selected.length;i++){
							   //获取用户的id
							   userIds+=selected[i].id+";";
						   }
						
						//去除最后一个";"号
					    userIds=userIds.substring(0,userIds.length-1);	
					    userIds=userIds.split(";");
					    
					}
			        if(userIds==''||userIds.length==0){
			        	cui.alert("没有选择人员。");
			        }else{
			        	 if(orgId){
			        		 postType=1; 
			        	 }else {
			        		 postType=2; 
			        	 }
			        	
					     dwr.TOPEngine.setAsync(false);
						    PostAction.insertPostAndUserRelation(postId,userIds,postType,function(flag){
						    	 window.cui.message('添加人员成功。','success');
						    	//清空查询条件
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