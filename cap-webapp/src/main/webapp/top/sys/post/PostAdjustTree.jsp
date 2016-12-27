<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>岗位调动</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostAction.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/GradeAdminAction.js"></script>
     <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/OrganizationAction.js"></script>
	
</head>
<body>
        <div uitype="borderlayout"   id="postBorderlayout" is_root="true" gap="0px 0px 0px 0px">           
             <div uitype="bpanel" style="overflow:hidden"  position="left" id="leftMain" width="270" max_size="550" min_size="50" collapsable="true" >
	            <div style="padding-top:80px;width:100%;position:relative;">
          <div style="position:absolute;top:0;left:0;height:80px;width:100%;">
	             &nbsp;<label style="font-size: 12px;">组织结构：</label>
				        <div uitype="radioGroup" name="orgStructureId" id="orgStructure" on_change="changeOrgStructure" radio_list="initOrgStructure"> 
		                </div>
			  <div style="margin-left: 5px;margin-top:5px;"> 
				    <span uitype="clickInput"  editable="true" id="keyword" name="keyword" on_iconclick="fastQuery" 
							emptytext="输入岗位名称、全拼、简拼查询" icon="search" 
							width="240px" enterable="true"></span>
			  </div> 
			   </div>     
              <div  id="treeDivHight" style="overflow:auto;height:100%;">
					<div id="div_list" style="display: none;margin-left: 5px;">
						<div uitype="multiNav"  id="fastQueryList" datasource="initBoxData" ></div>
					</div>
					<div id="div_tree">
						<div uitype="tree"  id="tree" children="[]" on_click="treeClick"  on_lazy_read="lazyData" click_folder_mode="1" on_expand="onExpand"  ></div>
					</div>
					<div id="div_none" style="display: none; font-size: 12px;margin-left: 5px;"></div>
            </div>
            </div>
            </div>
          
             <div uitype="bpanel"  position="center" id="centerMain" >
               <div class="list_header_wrap">
				    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="请输入姓名、全拼、简拼" editable="true" width="190" on_iconclick="iconclick"
			        		icon="search" iconwidth="18px"></span>
			        <span id="tipSpan"><font color="red">&nbsp;&nbsp;&nbsp;注：</font>以下显示未任岗的人员</span>
			  </div>
                 <c:if test="${param.pageType=='1'}">
                    <table uitype="Grid" id="userGrid" primarykey="userRePostId"  pagination_model="pagination_min_3"   gap="0px 0px 0px 5px" selectrows="multi" sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
						<th style="width:12px"><input type="checkbox"/></th>
						<th bindName="employeeName" sort="true" style="width:15%">姓名</th>
						<th bindName="account" sort="true"  style="width:15%">账号</th>
					</table>
				 </c:if>  
				   <c:if test="${param.pageType=='2'}">
                    <table uitype="Grid" id="userGrid" primarykey="userRePostId"   pagination_model="pagination_min_3"  gap="0px 0px 0px 5px" selectrows="no"  sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
						<th bindName="employeeName" sort="true" style="width:15%">姓名</th>
						<th bindName="account" sort="true"  style="width:15%">账号</th>
					</table>
				 </c:if>          
             </div>
             
       </div>
        
        <script type="text/javascript">
        
        var pageType="<c:out value='${param.pageType}'/>";
         //根节点ID
    	var rootId = "";
    	 //根节点ID
    	var parentId = "-1";
        var initBoxData=[];

        //当前选中的树节点
    	var curNodeId = '';
        
    	 //当前选中的树节点所属组织
    	var curNodeOrgId = '';
    	 //快速查询的标记
    	 var fastQueryFlag=0;  //为通过快速查询调岗，0为默认
    	
        //扫描，相当于渲染
        window.onload=function(){
        	
        	 if(globalUserId != 'SuperAdmin'){
				    dwr.TOPEngine.setAsync(false);
				    //查询管辖范围
				    GradeAdminAction.getGradeAdminOrgByUserId(globalUserId, function(orgId){
				    	if(orgId){
							rootId = orgId;
							parentId="";
						}else{
							rootId = null;
						}
					});
					dwr.TOPEngine.setAsync(true);
				
				}
        	
		    comtop.UI.scan();
		    $("#treeDivHight").height($("#leftMain").height()-80);
		    initOrgTreeData();
		 
	     }
    	 
        window.onresize= function(){
    		setTimeout(function(){
    			$("#treeDivHight").height($("#leftMain").height()-80);
    		},300);
		}
        
      //初始化组织结构信息
    	function initOrgStructure(obj){
    		dwr.TOPEngine.setAsync(false);
    		OrganizationAction.getOrgStructureInfo(function(data){
    			if(data){
    				var arrData = jQuery.parseJSON(data)
    				//移除外协单位的数据，外协单位不提供岗位管理20141209
    				arrData.splice(1,1);
    				obj.setDatasource(arrData);
    				obj.setValue(arrData[0].value,true);
    			}
    		});
    		dwr.TOPEngine.setAsync(true);
    	}
        

        //切换组织结构，重新加载整个页面
    	function changeOrgStructure(){
    		 initOrgTreeData();
    	}

    	
    	//树初始化
    	//树根节点ID
    	var curTreeNodeId = '';
    	function initOrgTreeData(){
    		curOrgStrucId = cui('#orgStructure').getValue();
			curOrgStrucName =cui('#orgStructure').getText();
			window.parent.orgStrucChainChange(curOrgStrucId,curOrgStrucName);
    		var vo = {orgStructureId:cui('#orgStructure').getValue(), parentId:parentId,orgId:rootId};
    		dwr.TOPEngine.setAsync(false);
    		PostAction.queryRootOrg(vo,function(data){
    			var emptydata=[{title:"没有数据"}];
    			if(!data){
    				$('#div_none').show();
    				cui('#tree').setDatasource(emptydata);
    			}else{
    				handleNodeData(data);
    				cui('#tree').setDatasource(data);
    				if(data.isLazy){
	    				curNodeId = data.key;
	    				curTreeNodeId = data.key;
	    				curNodeOrgId= data.orgId;
	    				var node = cui('#tree').getNode(curNodeId);
	    				node.expand();
	    				
	        			treeClick(node);
	        			
	        			//激活根节点
	    	   			cui('#tree').getNode(data.key).activate(true);
	    	   			cui('#tree').getNode(data.key).expand(true);
    				}
    				$('#div_none').hide();
    				$('#div_tree').show();
    			}

    			//切换组织结果的时候，listbox需要隐藏，查询条件清空
    			$('#div_none').hide();
    			$('#div_list').hide()
    			cui('#keyword').setValue('');
    			
    		});
    		dwr.TOPEngine.setAsync(true);
    	}


    	//转换节点
    	function handleNodeData(data){
    		data.isLazy = data.isLazy=='true'?true:false;
    		if(data.isFolder=='true'){//组织节点
    		    data.isFolder=true;
    			data.icon='${pageScope.cuiWebRoot}/top/sys/images/closeicon.gif';
    		}else{//岗位节点
    			data.isFolder=false;
    		    data.icon='${pageScope.cuiWebRoot}/top/sys/images/post.png';
    		}
    	}


    	//加载下级节点
    	function lazyData(node){
    		node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/openicon.gif');
    		curNodeId = node.getData().key;
    		curNodeOrgId=  node.getData().orgId;
    		var vo = {orgStructureId:cui('#orgStructure').getValue(), parentId:node.getData().key,userId:globalUserId};
    		dwr.TOPEngine.setAsync(false);
    		PostAction.queryChildOrgAndPost(vo,function(data){
				handleNodeList(data);
				node.addChild(data);
			});
    		dwr.TOPEngine.setAsync(true);
    		
    	}

    	//转换节点集合
    	function handleNodeList(lst){
    		for(var i=0;i<lst.length;++i){
    			var vo = lst[i];
    			vo.isLazy = vo.isLazy=='true'?true:false;
    			if(vo.isFolder=='true'){//组织节点
    				if(vo.isLazy){
    				   vo.isFolder=true;//目录加粗
    				}else{
    				   vo.isFolder=false;
    				}
    				vo.icon='${pageScope.cuiWebRoot}/top/sys/images/closeicon.gif';
    			}else{//岗位节点
    				vo.isFolder=false;
    				vo.icon='${pageScope.cuiWebRoot}/top/sys/images/post.png';
    				
    			}
    		}
    	}
    	
    	//树节点展开合起触发
    	function onExpand(flag,node){
    		if(flag){
    			node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/openicon.gif');
    		}else{
    			node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/closeicon.gif');
    		}
    	}
    	
    	var postId="";
		var postName="";
		var orgId="";
		var orgName="";
    	var isOrg=true;
    	// 树单击事件
		function treeClick(node){
			var data = node.getData();
			curNodeId=data.key;
			if(data.orgId==null||data.orgId=="")
				{
				   curNodeOrgId=data.key;
				}else{
		           curNodeOrgId=data.orgId;
				}
		           orgId=data.orgId;
			
			
			if(orgId==""||orgId==null){
				isOrg=true;
				orgId=data.key;
				orgName = data.title;
				//点组织查询不到人
				queryUserList(orgId);
			}else{
				isOrg=false;
				postId =data.key;
				postName =data.title;
				orgId=data.orgId;
				orgName=data.orgName;
				queryUserList(postId);
			}
			
		}
    	
		//快速查询
		var keyword="";
    	function fastQuery(){
    		keyword = cui("#keyword").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_", "gm"), "/_");
    		if(keyword==''){
    			$('#div_list').hide();
    			$('#div_none').hide();
    			$('#div_tree').show();
    			var node = cui('#tree').getNode(curTreeNodeId);
    			//激活根节点
	   			cui('#tree').getNode(node.getData().key).activate(true);
	   			cui('#tree').getNode(node.getData().key).expand(true);
    			if(node){
	    			treeClick(node);
	    			fastQueryFlag=0;
	    			queryUserList(node.getData().key);
       			}
    		}else{
    			$('#div_list').show();
    			$('#div_tree').hide();
    			listBoxData();
    		}
    	}

    	//快速查询列表数据源
    	function listBoxData(){
    		var vo = {};
    		var keyword = cui("#keyword").getValue().replace(new RegExp("/", "gm"), "//");
    			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
    		    keyword = keyword.replace(new RegExp("_", "gm"), "/_");
    		vo.keyword = keyword;
    		
        		
    		vo.orgStructureId = cui('#orgStructure').getValue();
            vo.userId=globalUserId;
    		if(globalUserId!='SuperAdmin'){
    			vo.orgId = rootId;
    			vo.associateType=1;//级联
    		}
    		
    			PostAction.fastQueryPost(vo,function(data){
    				if(data.length==0){
    					initBoxData = [{name:'没有数据',title:'没有数据'}];
    				}else{
    					 var path="";
    					initBoxData = [];
    					$('#div_none').hide();
    					 $.each(data,function(i,cData){
    						 
    						 if(cData.fullName.length>25){
    							 path=cData.fullName.substring(0,25)+"..";
    							 }else{
    								 path=cData.fullName;
    							 }
    						 initBoxData.push({href:"#",name:path,title:cData.fullName,onclick:"selectMultiNavClick('"+cData.key+"','"+cData.title+"','"+cData.orgId+"')"});
    						
    				 });
    				}
    					 cui("#fastQueryList").setDatasource(initBoxData);
    			});
    		
    	}
    	

		//点击快速查询结果
    	function selectMultiNavClick(key,title,orgId){
    		fastQueryFlag=1;
    		curNodeId=key;
    		//左边快速查询岗位后，右边快速查询人员使用
    		postId=key;
    		curNodeOrgId=orgId;
    		isOrg=false;
    		queryUserList(key);
    		
        }

    	

    	function showTree(){
    		//清空查询条件
    		 cui("#keyword").setValue("");
    		 keyword="";
    		 $('#div_none').show();
 			 $('#div_list').hide()
 			 $('#div_tree').show();
    	}
    	
    	
    	/*=======================================================*/
		//渲染列表数据
		function initData(grid,query){
			
				//获取排序字段信息
			    var sortFieldName = query.sortName[0];
			    var sortType = query.sortType[0];
			    if(isOrg){//true 点击的是源组织，根据组织id查询所属人员列表(只查询没有挂在岗位下的人)
			    	 //设置查询条件
				    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:userKeyword,sortFieldName:sortFieldName,sortType:sortType,orgId:orgId};
				    dwr.TOPEngine.setAsync(false);
				    PostAction.queryUserListByOrgIdNoPost(queryObj,function(data){
				    	var totalSize = data.count;
						var dataList = data.list;
						//加载数据源
						grid.setDatasource(dataList,totalSize);
						
		        	});
				    dwr.TOPEngine.setAsync(true);
				    //显示提醒tip
				   $("#tipSpan").css("display",""); 
				    //控制父页面的图片显示
				   window.parent.hidePicByOrgId(pageType);
			    	
			    }else{
					    //设置查询条件
					    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:userKeyword,sortFieldName:sortFieldName,sortType:sortType,postId:postId};
					    dwr.TOPEngine.setAsync(false);
					    PostAction.queryUserListByPostId(queryObj,function(data){
					    	var totalSize = data.count;
							var dataList = data.list;
							//加载数据源
							grid.setDatasource(dataList,totalSize);
							
			        	});
					    dwr.TOPEngine.setAsync(true);
					    //隐藏提醒tip
					    $("#tipSpan").css("display","none");
					    //控制父页面的图片显示
						 window.parent.hidePicByPostId(pageType);
			    }
			
	  	}
    		
    	
		 //渲染岗位下的人员列表数据
		function queryUserList(postId){
		    
			
		    var grid=cui("#userGrid");
			var query =grid.getQuery();
			//获取排序字段信息
		    var sortFieldName = query.sortName[0];
		    var sortType = query.sortType[0];
		   
		    //重新获取查询条件
		     userKeyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			 userKeyword = userKeyword.replace(new RegExp("%", "gm"), "/%");
			 userKeyword = userKeyword.replace(new RegExp("_","gm"), "/_");
			 userKeyword = userKeyword.replace(new RegExp("'","gm"), "''");
		    
		    if(isOrg){//true 点击的是组织，根据组织id查询所属人员列表(只查询没有挂在岗位下的人)
		    	 //设置查询条件
			    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:userKeyword,sortFieldName:sortFieldName,sortType:sortType,orgId:orgId};
			    dwr.TOPEngine.setAsync(false);
			    PostAction.queryUserListByOrgIdNoPost(queryObj,function(data){
			    	var totalSize = data.count;
					var dataList = data.list;
					//加载数据源
					grid.setDatasource(dataList,totalSize);
					
	        	});
			    dwr.TOPEngine.setAsync(true);
			    //显示提醒tip
			    $("#tipSpan").css("display","");
			    //控制父页面的图片显示
				 window.parent.hidePicByOrgId(pageType);
		    	
		    }else{
				    //设置查询条件
				    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:userKeyword,sortFieldName:sortFieldName,sortType:sortType,postId:postId};
				    dwr.TOPEngine.setAsync(false);
				    PostAction.queryUserListByPostId(queryObj,function(data){
				    	var totalSize = data.count;
						var dataList = data.list;
						//加载数据源
						grid.setDatasource(dataList,totalSize);
						
		        	});
				    dwr.TOPEngine.setAsync(true);
				    //隐藏提醒tip
				    $("#tipSpan").css("display","none");
				    //控制父页面的图片显示
					 window.parent.hidePicByPostId(pageType);
		    }
		    
	  	}
		//Grid组件自适应宽度回调函数，返回高度计算结果即可
		function resizeWidth(){
			return $('#centerMain').width()-2;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight(){
			//ie6下返回固定值，避免ie6下卡死
			if(comtop.Browser.isIE6){
				return 315;
			}
			return $('#centerMain').height()-40;
		}
    		

		 //搜索框图片点击事件
		 var userKeyword="";
		 function iconclick() {
			 userKeyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			 userKeyword = userKeyword.replace(new RegExp("%", "gm"), "/%");
			 userKeyword = userKeyword.replace(new RegExp("_","gm"), "/_");
			 userKeyword = userKeyword.replace(new RegExp("'","gm"), "''");
	        cui("#userGrid").setQuery({pageNo:1});
	        //刷新列表
			cui("#userGrid").loadData();
	     }
            
		 
        </script>
</body>
</html>