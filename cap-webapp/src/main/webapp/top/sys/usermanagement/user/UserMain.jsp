
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<%@ page import="com.comtop.top.sys.usermanagement.user.util.UomCommonUtil" %>
<%		
	//是否隐藏系统人员组织功能按钮 true 隐藏 false 不隐藏
    boolean isHideSystemBtnInUserOrg = UomCommonUtil.getHideSystemBtnInUserOrgCfg();
%>
<html>
<head>
    <title>人员基本信息</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/OrganizationAction.js"></script>
	 <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/UserManageAction.js"></script>
	 <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/GradeAdminAction.js"></script>
	  <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostAction.js"></script>
	 <style type="text/css">
		th{
		    font-weight: bold;
		    font-size:14px;
		}
	</style>
</head>
<body>
 <div uitype="borderlayout"  id="le" is_root="true" >           
      <div uitype="bpanel"  style="overflow:hidden" position="left" id="leftMain" width="280"  >
      	 <div style="padding-top:80px;width:100%;position:relative;">
          <div style="position:absolute;top:0;left:0;height:80px;width:100%;">
        &nbsp;&nbsp;<label style="font-size: 12px;">组织结构：</label>
        <div uitype="radioGroup" name="orgStructureId" id="orgStructure" on_change="changeOrgStructure" radio_list="initOrgStructure"> 
		</div>
		<div uitype="clickInput" id="orgNameText" name="orgNameText" emptytext="请输入组织名称" enterable="true" editable="true"
		 	 width="240px" icon="search" on_iconclick="quickSearch" style="font-size: 12px;padding-left: 5px"></div>
		 <div id="associateDiv" style="text-align: left;width:186px;font:12px/25px Arial;margin-left: 3px;margin-bottom: 1px;" >
			<div style="float: left;padding-left: 4px;padding-top: 2px;"><input type="checkbox" id="associateQuery" align="middle"  title="级联查询" onclick="setAssociate(0)" style="cursor:pointer;"/></div>
			<div style=""><label  onclick="setAssociate(1)" style="cursor:pointer;" id="label">&nbsp;级联查询用户</label></div>
		</div>
		 </div>     
        <div  id="treeDivHight" style="overflow:auto;height:100%;">
		 <div style="width:259px; border:1px solid #ccc;font: 12px/25px Arial;" id="orgNameDivBox">
			   <div uitype="multiNav" id="orgNameBox" datasource="initBoxData"></div>
		</div>
		<div>
		  <div uitype="tree" id="treeDiv" on_click="treeClick" on_lazy_read="lazyData" click_folder_mode="1" on_expand="onExpand" ></div>
	    </div>  
	   </div>
	   </div>
      </div>         
      <div uitype="bpanel"  position="center" id="centerMain" header_title="人员列表" style="overflow:hidden;">
             <div class="list_header_wrap ie6_list_header_wrap"  style="padding:15px 0 15px 15px;">
				    <div class="top_float_left">
				    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="请输入姓名、全拼、简拼" editable="true" width="220" on_iconclick="iconclick"
			        		icon="search" iconwidth="18px"></span>
			        &nbsp;&nbsp;&nbsp;&nbsp;状态：<span uiType="PullDown"   mode="Single"  id="employeeState" name="employeeState"  width="60" datasource="stateSource" label_field="text" value_field="id" select="0" on_change="changeUserState"></span>          
					</div>
					<div class="top_float_right" style="padding-right: 5px;">
					<% if(!isHideSystemBtn){ %>
					     <% if(!isHideSystemBtnInUserOrg){ %>
						<top:verifyAccess pageCode="TopUserAdmin" operateCode="updateUser">
						    <span uiType="Button" label="录入" on_click="addUser" id="addUser"></span>
						    <span uiType="Button" label="注销" on_click="deleteUser" id="deleteUser"></span>
						</top:verifyAccess>
						<span uiType="Button" label="导入人员" on_click="excelImport" id="excelImport"></span>
						<% } %>
					<% } %>
					    <span uiType="Button" label="导出人员" on_click="exportUser" id="exportUser"></span>
					<% if(!isHideSystemBtn){ %>
					      <% if(!isHideSystemBtnInUserOrg){ %>
						<span uiType="Button" label="下载模板" on_click="downEmployeeTemplate" id="downEmployeeTemplate"></span>
					     <% } %>	
					<% } %>	
					</div>
			 </div>
		 <div id="userGridWrap" style="padding:0 15px 0 15px">
		     <table uitype="Grid" id="userGrid" primarykey="userId"   sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight"  colrender="columnRenderer">
				<th style="width:30px"><input type="checkbox"/></th>
				<th bindName="employeeName" sort="true" style="width:25%">姓名</th>
				<th bindName="account" sort="true"  style="width:20%">账号</th>
				<th bindName="createTime" sort="true" style="width:15%;"  renderStyle="text-align: center" format="yyyy-MM-dd">创建日期</th>
				<th bindName="nameFullPath" sort="true" style="width:50%;"  >所属组织全路径</th>
			</table>
		 </div>
      </div> 
 </div>
 
<script type="text/javascript">
	var curOrgStrucId = '';
	var parentNodeId = '';
	var selectNodeId = '';
	var selectNodeName = '';
	var orgResultList;
	var searchType = "tree";
	var checkId = '';
	//初始化查询的组织数据   
	var initBoxData=[];
	 //管辖范围,树的根节点ID
    var rootId = '-1';
    //快速查询选中的结果
    var fastQueryRecordId='';
    var fastQueryRecordOrgName='';
    //管辖范围所属组织结构id
    var manageDeptOrgStructure = '';
    //当前选中的树节点
	var curNodeId = '';
    
    /********************组织树以及编辑页面的初始化   start **************************************************************/
	//扫描，相当于渲染
	window.onload = (function(){
		if(globalUserId != 'SuperAdmin'){
		    dwr.TOPEngine.setAsync(false);
		    //查询管辖范围
		    GradeAdminAction.getGradeAdminOrgByUserId(globalUserId, function(orgId){
		    	if(orgId){
					rootId = orgId;
					OrganizationAction.queryOrgStructureId(orgId,function(data){
						manageDeptOrgStructure = data;
					});
				}else{
					rootId = null;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
	      comtop.UI.scan();
	      $("#treeDivHight").height($("#leftMain").height()-80);
	      initOrgTreeData(cui('#treeDiv'));
	      $("#orgNameDivBox").hide();
	}); 
    
	window.onresize= function(){
		setTimeout(function(){
			$("#treeDivHight").height($("#leftMain").height()-80);
		},300);
    }
	//树初始化
	function initOrgTreeData(obj){
		var vOrgStructure = cui('#orgStructure').getValue();
		var vId = '-1';
		//当切换到非管辖范围内的组织结构时候，展现整棵树
		if(vOrgStructure==manageDeptOrgStructure){
			vId = rootId;
		}
		var node = {orgStructureId:vOrgStructure, orgId:vId};
		dwr.TOPEngine.setAsync(false);
		OrganizationAction.getOrgTreeNode(node,function(data){
		   	if(data&&data!==""){
	   			var treeData = jQuery.parseJSON(data);
	   			treeData.isRoot = true;
	   			obj.setDatasource(treeData);
	   			//激活根节点
	   			obj.getNode(treeData.key).activate(true);
	   			obj.getNode(treeData.key).expand(true);
	   			curNodeId = data.key;
	  			
	   			treeClick(obj.getActiveNode());
	   			//有数据的情况下，按钮可用
	   			 cui("#addUser").disable(false);
	   			 cui("#exportUser").disable(false);
	   			 cui("#downEmployeeTemplate").disable(false);
	   			 cui("#excelImport").disable(false);
	   			 cui("#deleteUser").disable(false);
			}else{
				  var emptydata=[{title:"没有数据"}];
	   			  obj.setDatasource(emptydata);
	   			    //设置右边的页面链接
		   			 selectNodeId = "";
			   		 selectNodeName= "";
			   		 parentNodeId =  "";
			   		 curOrgStrucId =  "";
		   			 cui("#userGrid").loadData();
		   			 //没有数据的情况下 按钮置灰
		   			 cui("#addUser").disable(true);
		   			 cui("#exportUser").disable(true);
		   			 cui("#downEmployeeTemplate").disable(true);
		   			 cui("#excelImport").disable(true);
		   			 cui("#deleteUser").disable(true);
		   			
			}
   		 });
   		dwr.TOPEngine.setAsync(true);
	}
	//切换组织结构，重新加载整个页面
	function changeOrgStructure(){
		//清空查询条件，隐藏查询结果，显示树，searchType修改为tree
		cui('#orgNameText').setValue('');
		$("#orgNameDivBox").hide();
		cui("#treeDiv").show();
		searchType = "tree";
		curOrgStrucId = cui('#orgStructure').getValue();
		initOrgTreeData(cui('#treeDiv'));
	}
	
	
	//初始化组织结构信息
	function initOrgStructure(obj){
		dwr.TOPEngine.setAsync(false);
		OrganizationAction.getOrgStructureInfo(function(data){
			if(data){
				var arrData = jQuery.parseJSON(data)
				obj.setDatasource(arrData);
				obj.setValue(arrData[0].value,true);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	
   	//动态加载下级节点
   	function lazyData(node){
   		// 更改文件夹图片
   		node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/openicon.gif');
   		curNodeId = node.getData().key;
   		curOrgStrucId = cui('#orgStructure').getValue();
   		dwr.TOPEngine.setAsync(false);
		var userChildObj={"orgId":node.getData().key,orgStructureId:curOrgStrucId};
		OrganizationAction.getOrgTreeNode(userChildObj,function(data){
	    	var treeData = jQuery.parseJSON(data);
	    	//加载子节点信息
	    	 node.addChild(treeData.children);
		     node.setLazyNodeStatus(node.ok);
	     });
	    dwr.TOPEngine.setAsync(true);
   	}

	//树节点展开合起触发 更改文件夹图片
	function onExpand(flag,node){
		if(flag){
			node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/openicon.gif');
		}else{
			node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/closeicon.gif');
		}
	}

   	// 树单击事件
    var isAdmin =""; 
    var associateType =""; //为1 时级联查询
   	function treeClick(node){
    	
   		checkId=node.getData().key;
   		curNodeId = node.getData().key; //为空查询的时候用到
   		selectNodeId = node.getData().key;
   		selectNodeName=node.getData().title;
   		parentNodeId = node.getData().data.parentOrgId;
   		curOrgStrucId = cui('#orgStructure').getValue();
   	   
  	    var isRootNode = false;
		var curNode = cui('#treeDiv').getNode(selectNodeId);
		if(curNode&&curNode.getData("isRoot") === true) {
			isRootNode = true;
		}
		
		if(rootId == null){
			isAdmin="no";
		}
	     
   		cui("#userGrid").loadData();
   	}

   	
    /********************组织树以及编辑页面的初始化   end **************************************************************/
    
    
    
         //设置级联  1为 级联查询，0为默认
    	function setAssociate(type){
    		var associate=$('#associateQuery')[0].checked;
    		if(type==1){
        		if(associate)$('#associateQuery')[0].checked=false;
        		else $('#associateQuery')[0].checked=true;
        	}
    		 //为1 级联查询
      	    associateType=$('#associateQuery')[0].checked==true?1:0;
    		//执行查询
        	if(searchType == "tree"){
	     	   var node=cui('#treeDiv').getActiveNode();
	     	   treeClick(node);
            }else{
            	fastQuerySelect(curOrgStrucId,parentNodeId,fastQueryRecordId,fastQueryRecordOrgName);
            }
        }
    
    
    /********************快速查询    start  **************************************************************/
	/**
	快速查询选中记录
	*/
	function fastQuerySelect(chooseOrgStructureId,chooseParentNodeId,orgId,orgName){
		 //记录快速查询的结果
		 fastQueryRecordId = orgId;
		 fastQueryRecordOrgName = orgName;
		 
		    selectNodeId = orgId;
	   		selectNodeName=orgName;
	   		parentNodeId = chooseParentNodeId;
	   		curOrgStrucId = chooseOrgStructureId;
	   		cui("#userGrid").loadData();
	}

	//快速查询
	function quickSearch(){
	    initBoxData=[];
	    cui("#orgNameBox").setDatasource(initBoxData);
	    $("#orgNameDivBox").hide();
	    var keyword = cui("#orgNameText").getValue().replace(new RegExp("/", "gm"), "//");
		keyword = keyword.replace(new RegExp("%", "gm"), "/%");
		keyword = keyword.replace(new RegExp("_", "gm"), "/_");
		
		if(!keyword){
		    cui("#orgNameDivBox").hide();
			cui("#treeDiv").show();
			var node = cui('#treeDiv').getNode(curNodeId);
			if(node){
    			treeClick(node);
   			}
			searchType="tree";
		}else{
			dwr.TOPEngine.setAsync(false);
			if(rootId != null){
				//刷新选择框的数据
				var obj;
				if(rootId != '-1'){
					obj = {keyword:keyword,orgStructureId:curOrgStrucId,orgId:rootId};
					if(obj.orgStructureId != manageDeptOrgStructure){ //外协单位不用管辖范围
	                	 obj.orgId = '';
		    		}
				} else {
					obj = {keyword:keyword,orgStructureId:curOrgStrucId};
				}
				OrganizationAction.quickSearchOrg(obj,function(datas){
					cui("#treeDiv").hide();
					if (datas && datas.length > 0) {
						var path="";
						$.each(datas,function(i,cData){
							 if(cData.nameFullPath.length>21){
								    path=cData.nameFullPath.substring(0,21)+"..";
								 }else{
									 path=cData.nameFullPath;
								 }
								initBoxData.push({href:"#",name:path,title:cData.nameFullPath,onclick:"fastQuerySelect('"+curOrgStrucId+"','"+cData.parentOrgId+"','"+cData.orgId+"','"+cData.orgName+"')"});
						});
					}else{
						initBoxData = [{name:'没有数据',title:'没有数据'}];
					}
				});
				dwr.TOPEngine.setAsync(true);
			}else {
				initBoxData = [{name:'没有数据',title:'没有数据'}];
			}
			cui("#orgNameBox").setDatasource(initBoxData);
			cui("#treeDiv").hide();
			$("#orgNameDivBox").show();
		    searchType="box";
		}
	}
	
	/********************快速查询    end **************************************************************/
	
	/********************人员列表   start **************************************************************/
	
	
	   
	
	    var keyword="";
	    var employeeState=1;  //默认显示在职用户
	  
	  //被选中列的主键，用于新增及编辑时自动选中
		var selectedKey=''
			
		//状态数据
	    var stateSource=[  
	    		                    {id:"1",text:"在职"},
	    		                    {id:"2",text:"注销"}
	    		                    ];
	    
	    
		//渲染列表数据
		function initData(grid,query){
			 
				//获取排序字段信息
			    var sortFieldName = query.sortName[0];
			    var sortType = query.sortType[0];
			    //设置查询条件,keyword需要重新获取
			    keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
				keyword = keyword.replace(new RegExp("%", "gm"), "/%");
				keyword = keyword.replace(new RegExp("_","gm"), "/_");
				keyword = keyword.replace(new RegExp("'","gm"), "''");
				
			    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,orgId:selectNodeId,state:employeeState,userState:employeeState,fastQueryValue:keyword,sortFieldName:sortFieldName,sortType:sortType,associateType:associateType};
			    dwr.TOPEngine.setAsync(false);
			    UserManageAction.queryUserList(queryObj,function(data){
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
		function resizeWidth() {
			return $('body').width() -300;
			//return (document.documentElement.clientWidth || document.body.clientWidth) - 297;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 58;
		}
		
		
		//列渲染
		function columnRenderer(data,field) {
			
			if(field == 'employeeName'){
				//替换显示
				var employeeName = data["employeeName"];
				return "<a class='a_link'    onclick='javascript:editUser(\""+data["userId"]+ "\",\""+data["orgId"]+ "\");'>"+employeeName+"</a>";
			}
		}
		
		
		 
		 
		 //人员新增
		var dialog;
		function addUser(){
			var url='${pageScope.cuiWebRoot}/top/sys/usermanagement/user/UserEdit.jsp?orgId='+selectNodeId+"&orgName="+encodeURIComponent(encodeURIComponent(selectNodeName))+"&orgStructureId="+curOrgStrucId+"&state="+employeeState;
			var width = (document.documentElement.clientWidth || document.body.clientWidth) - 300; // 700;
			var height =  (document.documentElement.clientHeight || document.body.clientHeight)-100; //400
		  if(!dialog){//防止重复创建对象
			dialog = cui.dialog({
				title : '人员信息录入',
				src : url,
				width : width,
				height : height
			})
		  }
			dialog.show(url);
			
		}
		 
		 //人员编辑
		function editUser(userId,orgId){
			 
			var url='${pageScope.cuiWebRoot}/top/sys/usermanagement/user/UserEdit.jsp?orgId='+selectNodeId+"&orgStructureId="+curOrgStrucId+"&userId="+userId+"&state="+employeeState;
			var width = (document.documentElement.clientWidth || document.body.clientWidth) - 300; // 700;
			var height =  (document.documentElement.clientHeight || document.body.clientHeight)-100; //400
			 if(!dialog){//防止重复创建对象
				dialog = cui.dialog({
					title : '人员信息编辑',
					src : url,
					width : width,
					height : height
				})
			 }
			dialog.show(url);
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
		 
		 //改变用户状态
		 function  changeUserState(){
			 employeeState=cui("#employeeState").getValue();
			 cui("#userGrid").setQuery({pageNo:1});
		        //刷新列表
		     cui("#userGrid").loadData();
		     //只显示导出按钮 其他隐藏
		     if(employeeState==2){
			     cui('#addUser').hide();
			     cui('#downEmployeeTemplate').hide();
			     cui('#excelImport').hide();
			     cui('#deleteUser').hide();
		     }else{
		    	 cui('#addUser').show();
			     cui('#downEmployeeTemplate').show();
			     cui('#excelImport').show();
			     cui('#deleteUser').show();
		    	 
		     }
			
		 }
		 
		 
		    //编辑页面回调函数 执行多任务的时候可以带参数，根据参数来判断执行什么操作。
			function editCallBack(type,key){
				selectedKey=key;
				//新增信息
				if(type=="add"){
					cui("#myClickInput").setValue("");
					keyword="";
					cui("#userGrid").setQuery({pageNo:1,sortType:[],sortName:[]});
				}
				cui("#userGrid").loadData();
				cui("#userGrid").selectRowsByPK(selectedKey);
			}
		    
			function refreshList() {
				cui("#userGrid").loadData();
			}
		    
		    
			//注销人员操作
			function deleteUser(){
				var selectIds = cui("#userGrid").getSelectedPrimaryKey();
				if(selectIds == null || selectIds.length == 0){
					cui.alert("请选择要注销的人员。");
					return;
				}
				cui.confirm("确定要注销这"+selectIds.length+"个人员信息吗？",{
					onYes:function(){
						dwr.TOPEngine.setAsync(false);
						//判断用户是否有工作流提醒数据
						  PostAction.queryUserTaskInALlProcess(selectIds,function(data){
										 if(data.flag){//true 都没有提醒待办数据，可以注销
									
													UserManageAction.deleteUsers(selectIds,function(data){
															cui("#userGrid").removeData(cui("#userGrid").getSelectedIndex());
															cui("#userGrid").loadData();
															cui.message("注销"+selectIds.length+"个人员信息成功","success");
											        });
									 	 }else{
								    		 //提示不能注销的人员
								    		 cui.alert("【<font color='red'>"+data.usrNames+"</font>】存在未处理待办数据，不能注销。");
								    	 }
								    	
						     });
						dwr.TOPEngine.setAsync(true);
				  	}
				});
				
			}    
			
			 
			//下载人员导入模板
			function downEmployeeTemplate(){
				var url = '${pageScope.cuiWebRoot}/top/sys/user/downloadUserImportTemplate.ac';
				 window.open(url,'_self');
			}
			
			//导出人员信息
			function exportUser(){
				var fastQueryValue = "";
				var vos =  cui("#userGrid").getSelectedPrimaryKey();
				fastQueryValue= cui("#myClickInput").getValue();
				//jodd请求，不能为/后面不能为""空
				if(fastQueryValue == ""){
					fastQueryValue = null;
				}
				 associateType=$('#associateQuery')[0].checked==true?1:0;
				 
				 cui.confirm('请选择导出的数据类型', {
			            buttons: [
			                {
			                    name: '人员基本信息',
			                    handler: function () {
			        				 var url = "${pageScope.cuiWebRoot}/top/sys/user/userExport.ac?orgId="+selectNodeId+"&orgStructureId="+curOrgStrucId+"&fastQueryValue="+fastQueryValue+"&state="+employeeState+"&associateType="+associateType+"&selectedIds="+vos;
			        			     location.href = url;
			                    }
			                },
			                {
			                    name: ' 人员岗位信息',
			                    handler: function () {
			                    	 var url = "${pageScope.cuiWebRoot}/top/sys/user/userPostExport.ac?orgId="+selectNodeId+"&orgStructureId="+curOrgStrucId+"&fastQueryValue="+fastQueryValue+"&state="+employeeState+"&associateType="+associateType+"&selectedIds="+vos;
			        			     location.href = url;
			                    }
			                },
			                {
			                    name: ' 取消',
			                    handler: function () {
			                    	return;
			                    }
			                }
			            ]
			        });
				 

			}
			
		     //导入人员信息
			 function excelImport(){
				 var vWidth =450;
				 var vHeight =180;
				 var vTopPos =(window.screen.height-180)/2;
				 var vLeftPos =(window.screen.width-450)/2;
				 var vHeight =180;
				 var sFeatures = "width="+vWidth+",height="+vHeight+",help=no,resizable=no,menu=no,toolbar=no,status=no,left="+vLeftPos+",top="+vTopPos;
				 var win = window.open("${pageScope.cuiWebRoot}/excelImportServlet.topExcelImportServlet?actionType=excelImport&configName=excel.xml&callback=editCallBack&excelId=userImport&param="+selectNodeId, "ExcelImportWindow", sFeatures);
				 if(win) { win.focus();}
				} 
			 

	/********************人员列表   end **************************************************************/
	
	
   
	

	
	
	
 </script>
</body>
</html>