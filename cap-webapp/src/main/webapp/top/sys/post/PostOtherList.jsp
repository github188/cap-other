<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
    <title>非行政岗位列表</title>
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
		    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="请输入岗位名称、全拼、简拼" editable="true" width="250" on_iconclick="iconclick"  on_change="iconChange"
	        		icon="search" iconwidth="18px"></span>&nbsp;&nbsp;&nbsp;&nbsp;
	       <div uitype="checkboxGroup" id="showAllPost" name="showAllPost" on_change="showAllPostList">
			 		<input type="checkbox" name="showAll" id="showAllCheckBox"  value="1">级联显示所有岗位 
			 </div>
	   </div>
	     <% if(!isHideSystemBtn){ %>
			<div class="top_float_right">
				<top:verifyAccess pageCode="TopOtherPostAdmin" operateCode="updateOtherPost">
		       		<span uiType="Button" label="新增岗位" on_click="insertPost" id="insertPostButton" ></span>
		       	</top:verifyAccess>
		       	<top:verifyAccess pageCode="TopOtherPostAdmin" operateCode="addOrdelUser">
		       		<span uiType="Button" label="添加人员" on_click="addUsers" id="addUsersButton" ></span>
		       	</top:verifyAccess>
		       	<top:verifyAccess pageCode="TopOtherPostAdmin" operateCode="addOrdelRole">
		       		<span uiType="Button" label="添加角色" on_click="addRoles" id="addRolesButton" ></span>
		       	</top:verifyAccess>
			</div>
			<% } %>	
	 </div>
 <div id="postGridWrap">
     <table uitype="Grid" id="postGrid"     pageno="<c:out value='${param.pageNo}'/>"   pagesize="<c:out value='${param.pageSize}'/>"    primarykey="otherPostId"  sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
		<th style="width:30px"><input type="checkbox"/></th>
		<th bindName="otherPostName" sort="true" style="width:30%">岗位名称</th>
		<th bindName="otherPostCode" sort="true"  style="width:10%">岗位编码</th>
		<th bindName="classifyFullPath" sort="true" style="width:50%;"  renderStyle="text-align: center">所属分类全路径</th>
		<th bindName="otherPostFlag" sort="true"  style="width:10%" renderStyle="text-align: center">是否标准岗位</th>
	</table>
 
 </div>
<script language="javascript">
		var  classifyId= "<c:out value='${param.classifyId}'/>";//节点ID
		var classifyName = decodeURIComponent(decodeURIComponent( "<c:out value='${param.classifyName}'/>"));//节点名称
		var parentName = decodeURIComponent(decodeURIComponent( "<c:out value='${param.parentName}'/>"));//父节点名称 
		var parentId = "<c:out value='${param.parentId}'/>";//父节点id
	    var keyword="";
	    var associateType =""; //为1 时级联查询，2为不级联
	    var postFlag = "<c:out value='${param.postFlag}'/>";//岗位节点标记  1为分类 2为岗位节点
	    var pageNo="<c:out value='${param.pageNo}'/>"; 
	    var pageSize="<c:out value='${param.pageSize}'/>"; 
	    var operate="<c:out value='${param.operate}'/>";    //为1时点返回
	    var standandFlag = "<c:out value='${param.standandFlag}'/>";//标准岗位标识,0为其他，1为标准岗位标识
	    var operateFlag="<c:out value='${param.operateFlag}'/>";
	    
	    //管辖部门ID
    	var rootOrgId = "";
	    
	    
	    
		window.onload = function(){
		    	comtop.UI.scan();
		    	
		    	 if(globalUserId != 'SuperAdmin'){
					    dwr.TOPEngine.setAsync(false);
					    //查询管辖范围
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
// 		    		//清除原有的缓存
// 		    		setCookie("associateType","");
// 		    		setCookie("postKeyword","");
// 		    	}
		    	
		    	if(operateFlag =='0'){
		    		setCookie("associateTypeOther","");
		    	}
		    	
		    	//当associateType值为空的时候，从缓存中取出
		    	if(associateType == ""){
		    		associateType = getCookie("associateTypeOther");
		    		if(associateType == 1){
		    			cui('#showAllPost').selectAll();
		    		}
		    	}
		}
		
		
		//渲染列表数据
		function initData(grid,query){
			
			
// 			 if(operate==1){
// 				    keyword = getCookie("postOtherKeyword");
// 				    cui("#myClickInput").setValue(keyword);
// 	         }
		    pageNo=query.pageNo;
		    pageSize= query.pageSize;
		 
			 
				//获取排序字段信息
			    var sortFieldName = query.sortName[0];
			    var sortType = query.sortType[0];
			   
			    if(associateType==null){
			    	//默认为不级联
			    	associateType=2;
			    }
			    //设置查询条件
			    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,otherPostName:keyword,sortFieldName:sortFieldName,sortType:sortType,classifyId:classifyId,associateType:associateType};
			    dwr.TOPEngine.setAsync(false);
			    if(globalUserId == 'SuperAdmin'){
				    PostOtherAction.queryPosOthertByClassifyId(queryObj,function(data){
				    	var totalSize = data.count;
						var dataList = data.list;
						//加载数据源
						grid.setDatasource(dataList,totalSize);
		        	});
			    } else {
			    	queryObj.creatorId = globalUserId;
			    	PostOtherAction.queryAssignPostOther(queryObj,function(data){
				    	var totalSize = data.count;
						var dataList = data.list;
						//加载数据源
						grid.setDatasource(dataList,totalSize);
		        	});
			    }
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
		
		
		//列渲染
		function columnRenderer(data,field) {
			
			if(field == 'otherPostName'){
				//替换显示
				var otherPostName = data["otherPostName"];
				return "<a class='a_link'    onclick='javascript:readPost(\""+data["otherPostId"]+ "\",\""+data["otherPostName"]+ "\");'>"+otherPostName+"</a>";
			}
			
			
	    	if(field == 'otherPostFlag'){
				if(data["otherPostFlag"]==1){
					   return "否";
				   }
				if(data["otherPostFlag"]==2){
					   return "是";
				  }
			}
		}
		
		
		
		 //搜索框图片点击事件
		 function iconclick() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
// 			setCookie("postOtherKeyword",keyword);
	        cui("#postGrid").setQuery({pageNo:1});
	        //刷新列表
			cui("#postGrid").loadData();
	     }
		 
		 //搜索框图片点击事件
		 function iconChange() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
// 			setCookie("postOtherKeyword",keyword);
	     }
		 
		 
		  //级联显示岗位
		  function showAllPostList(){
			  var values = cui('#showAllPost').getValue(); 
				if(values &&  values.length == 1 && values[0] == 1){
					associateType=1;
				} else {
					associateType=0;
				}
				setCookie("associateTypeOther",associateType);
			     //刷新列表
			    cui("#postGrid").loadData();
		  }
           
		  //进入新增岗位页面
		  function insertPost(){
			  operate=1;
			  //跳转到新增岗位的页面
			  window.parent.cui('#border').setContentURL("center","PostOtherEdit.jsp?classifyId=" + classifyId + "&postFlag=" + 1+ "&classifyName=" + encodeURIComponent(encodeURIComponent(classifyName))+'&pageNo='+pageNo+'&pageSize='+pageSize+'&operate='+operate+"&rootOrgId="+rootOrgId+ "&standandFlag=" + standandFlag);
		  }
		
		  
		  //进入读取岗位页面
		  function readPost(postId,postName){
			  operate=1;
			  window.parent.cui('#border').setContentURL("center","PostOtherEdit.jsp?classifyId=" + postId + "&postFlag=" +2+ "&classifyName=" + encodeURIComponent(encodeURIComponent(postName)) +"&parentName=" + encodeURIComponent(encodeURIComponent(classifyName))+ "&parentId=" + classifyId+'&pageNo='+pageNo+'&pageSize='+pageSize+'&operate='+operate+"&rootOrgId="+rootOrgId+ "&standandFlag=" + standandFlag);   
		  }
		  
		//写cookies 
		  function setCookie(name,value) { 
		      var Days = 30; 
		      var exp = new Date(); 
		      exp.setTime(exp.getTime() + Days*24*60*60*1000); 
		      document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString(); 
		  } 

		  //读取cookies 
		  function getCookie(name) { 
		      var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
		      if(arr=document.cookie.match(reg)){
		          return unescape(arr[2]); 
		      } else{
		          return null; 
		      } 
		  } 

		  
		  //批量添加人员
		  function addUsers(){
			  
				var selectIds = cui("#postGrid").getSelectedPrimaryKey();
				//获取选择的数据
				var selectRowData=cui("#postGrid").getSelectedRowData();
				
				for(var i=0;i<selectRowData.length;i++){
					var standardPostFlag=selectRowData[i].otherPostFlag;
					if(standardPostFlag==2){
						cui.alert("选择的岗位不能包含标准岗位。");
	 				    return;
					}
				}
				
				
				
				if(selectIds == null || selectIds.length == 0){
					cui.alert("请选择要添加人员的岗位。");
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
		  
		  
			//从岗位添加共同人员
			function chooseCallback(selected){
				   //选择的岗位
				  var selectPostIds = cui("#postGrid").getSelectedPrimaryKey();
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
					     dwr.TOPEngine.setAsync(false);
					     PostAction.addUsersInPostIds(selectPostIds,userIds,2,function(){
						    	 window.cui.message('添加人员成功。','success');
				        	});
						  dwr.TOPEngine.setAsync(true);
			        }
			} 
			
			
			 //批量添加共同角色
			  function addRoles(){
				 
					//获取选择的数据
					var selectRowData=cui("#postGrid").getSelectedRowData();
					
					var selectIds = cui("#postGrid").getSelectedPrimaryKey();
					if(selectIds == null || selectIds.length == 0){
						cui.alert("请选择要添加角色的岗位。");
						return;
					}
					
					var url='${pageScope.cuiWebRoot}/top/sys/post/RoleSelectMain.jsp';
					var height =  750;
					var width =  500;
					cui.extend.emDialog({
						id: 'selectRole',
						title : '角色选择页面',
						src : url,
						width : height,
						height : width
				    }).show(url);
			  }
			 
			//选择角色后回调操作
				function addRoleToPost(roleIds){
					var selectPostIds = cui("#postGrid").getSelectedPrimaryKey();
						 dwr.TOPEngine.setAsync(false);
						    PostAction.addRolesInPostIds(selectPostIds,roleIds,2,function(){
						    	window.cui.message('添加角色成功。','success');
				        	});
						  dwr.TOPEngine.setAsync(true);
					
				} 
			
		    

</script>
</body>
</html>