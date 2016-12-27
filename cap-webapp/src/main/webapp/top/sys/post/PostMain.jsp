<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
    <title>岗位管理</title>
    <meta http-equiv="X-UA-Compatible" content="edge" />
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
             <div    position="left" style="overflow:hidden" id="leftMain" width="270" max_size="550" min_size="50" collapsable="true"  >
	            <div style="padding-top:80px;width:100%;position:relative;">
                  <div style="position:absolute;top:0;left:0;height:80px;width:100%;">
	            &nbsp;&nbsp;<label style="font-size: 12px;">组织结构：</label>
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
					<div id="div_tree" >
						<div uitype="tree"  id="tree" children="[]" on_click="treeClick"  on_lazy_read="lazyData" click_folder_mode="1" on_expand="onExpand"  ></div>
					</div>
					<div id="div_none" style="display: none; font-size: 12px;margin-left: 5px;"></div>
            </div>
            </div>
          </div>
             <div  position="center" id="centerMain" ></div>
             
       </div>
        
        <script type="text/javascript">

         //根节点ID
    	var rootOrgId = "";
    	  //根节点ID
    	var parentId = "-1";
    	
    	  //判断当前操作是否是进入页面加载
    	var operateFlag = "0";
    	  
    	  //组织结构
    	var orgStructureId="";  

        var initBoxData=[];

        //当前选中的树节点
    	var curNodeId = '';
    	
        //扫描，相当于渲染
        window.onload=function(){
        	 if(globalUserId != 'SuperAdmin'){
				    dwr.TOPEngine.setAsync(false);
				    //查询管辖范围
				    GradeAdminAction.getGradeAdminOrgByUserId(globalUserId, function(orgId){
				    	if(orgId){
							rootOrgId = orgId;
							parentId="";
						}else{
							rootOrgId = null;
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

      //切换组织结构，重新加载整个页面
    	function changeOrgStructure(){
    		initOrgTreeData(cui('#tree'));
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

    	
    	//树初始化
    	function initOrgTreeData(){
    		var vo = {orgStructureId:cui('#orgStructure').getValue(), parentId:parentId,orgId:rootOrgId};
    		dwr.TOPEngine.setAsync(false);
    		PostAction.queryRootOrg(vo,function(data){
    			var emptydata=[{title:"没有数据"}];
    			if(!data){
    				$('#div_none').show();
    				cui('#tree').setDatasource(emptydata);
    				//刷新右侧页面
    				cui("#postBorderlayout").setContentURL("center","PostEdit.jsp"); 
    			}else{
    				handleNodeData(data);
    				cui('#tree').setDatasource(data);
    				if(data.isLazy){
	    				curNodeId = data.key;
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
    	
    	var isOrg=true;
    	// 树单击事件
		function treeClick(node){
			var data = node.getData();
			curNodeId = data.key;
			var postId="";
			var postName="";
			var orgId=data.orgId;
			var orgName;
			
			if(orgId==""||orgId==null){
				isOrg=true;
				orgId=data.key;
				orgName = data.title;
			}else{
				isOrg=false;
				postId =data.key;
				postName =data.title;
				orgId=data.orgId;
				orgName=data.orgName;
			}
			orgStructureId=cui('#orgStructure').getValue();
			if(postId&&orgId){ //点击岗位
				  cui("#postBorderlayout").setContentURL("center","PostEdit.jsp?postName="+encodeURIComponent(encodeURIComponent(postName))+"&postId="+ postId+"&orgId="+orgId+"&orgName="+ encodeURIComponent(encodeURIComponent(orgName))+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId); 
				}
			if(orgId&&!postId){ //点击组织
					cui("#postBorderlayout").setContentURL("center","PostList.jsp?orgId="+orgId+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId+"&orgName="+ encodeURIComponent(encodeURIComponent(orgName)) + "&operateFlag="+ operateFlag); 
			}
			operateFlag = '1';
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
    			var node = cui('#tree').getNode(curNodeId);
    		
    			if(node){
	    			treeClick(node);
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
    		vo.userId = globalUserId;
        		
    		vo.orgStructureId = cui('#orgStructure').getValue();

    		if(globalUserId!='SuperAdmin'){
    			vo.orgId = rootOrgId;
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
    		orgStructureId=cui('#orgStructure').getValue();
    		cui("#postBorderlayout").setContentURL("center","PostEdit.jsp?postName="+title+"&postId="+ key+"&orgId="+ orgId+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId);     		
        }

    	// 回调,刷新树   参数(节点，父节点，父节点名称，回调类型num：1是新增，2是编辑，3是删除，4保存 并继续,5返回)
    	function refreshEditTree(postId,orgId,orgName,num){
    		 
    		    showTree();
    		  
    			//刷新左边树
    			//移除orgId下的所有子节点，重新加载子节点
    		    var node = cui('#tree').getNode(orgId);
    			if(node){ //节点已经加载
	    			node.getData().isLazy=false;
	    			var children=node.children();
	    			if(children){
	    				for(var i=0; i < children.length; i++){
	    					children[i].remove();  
	    				}
	    			}
	    			lazyData(node);
    			}else{//节点未加载
    				var tmpPostId=postId;
    				if(num==3||num==4){
    					tmpPostId="";
   				     }
    				 //得到新增和编辑节点的ID Path

					 var path;
					 dwr.TOPEngine.setAsync(false);
					 PostAction.queryIDFullPath(orgId,tmpPostId,function(data){
							path = data.split('/');
					 });
					 dwr.TOPEngine.setAsync(true);
					 //从根节点开始遍历，直到展开到当前节点为止 ，并选中当前节点
					$.each(path,function(i,iPostId){
						var iNode = cui("#tree").getNode(iPostId);
						if(i==path.length-1){
							iNode.activate(true);
						}else{
							iNode.expand(true);
						}
					});
    				
    			}
    			//激活节点
    			if(num==1){
		   			cui('#tree').getNode(postId).activate(true);
		   			cui('#tree').getNode(postId).focus(true);
		   			postName=cui('#tree').getNode(postId).getData().title;
					//显示右边页面
		   			cui("#postBorderlayout").setContentURL("center","PostEdit.jsp?postId="+ postId+"&postName="+encodeURIComponent(encodeURIComponent(postName))+"&orgId="+orgId+"&orgName="+ encodeURIComponent(encodeURIComponent(orgName))+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId); 
					
    			}
    			if(num==2){
		   			cui('#tree').getNode(postId).activate(true);
		   			cui('#tree').getNode(postId).focus(true);
    			}
    			if(num==3){
		   			cui('#tree').getNode(orgId).activate(true);
		   			cui('#tree').getNode(orgId).focus(true);
		   		    //显示右边页面
		   			cui("#postBorderlayout").setContentURL("center","PostList.jsp?orgId="+orgId+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId+"&orgName="+ encodeURIComponent(encodeURIComponent(orgName))); 
    			}
    			
    			if(num==4||num==5){
        			
		   			cui('#tree').getNode(orgId).activate(true);
		   			cui('#tree').getNode(orgId).focus(true);
    			}
    			
    			
    	}

    	function showTree(){
    		//清空查询条件
    		
    		 cui("#keyword").setValue("");
    		 keyword="";
    		 cui("#div_list").hide();
    		 cui("#div_tree").show();
    		 
    	}

            
        </script>
</body>
</html>