<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>��λ����</title>
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
	             &nbsp;<label style="font-size: 12px;">��֯�ṹ��</label>
				        <div uitype="radioGroup" name="orgStructureId" id="orgStructure" on_change="changeOrgStructure" radio_list="initOrgStructure"> 
		                </div>
			  <div style="margin-left: 5px;margin-top:5px;"> 
				    <span uitype="clickInput"  editable="true" id="keyword" name="keyword" on_iconclick="fastQuery" 
							emptytext="�����λ���ơ�ȫƴ����ƴ��ѯ" icon="search" 
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
				    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="������������ȫƴ����ƴ" editable="true" width="190" on_iconclick="iconclick"
			        		icon="search" iconwidth="18px"></span>
			        <span id="tipSpan"><font color="red">&nbsp;&nbsp;&nbsp;ע��</font>������ʾδ�θڵ���Ա</span>
			  </div>
                 <c:if test="${param.pageType=='1'}">
                    <table uitype="Grid" id="userGrid" primarykey="userRePostId"  pagination_model="pagination_min_3"   gap="0px 0px 0px 5px" selectrows="multi" sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
						<th style="width:12px"><input type="checkbox"/></th>
						<th bindName="employeeName" sort="true" style="width:15%">����</th>
						<th bindName="account" sort="true"  style="width:15%">�˺�</th>
					</table>
				 </c:if>  
				   <c:if test="${param.pageType=='2'}">
                    <table uitype="Grid" id="userGrid" primarykey="userRePostId"   pagination_model="pagination_min_3"  gap="0px 0px 0px 5px" selectrows="no"  sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
						<th bindName="employeeName" sort="true" style="width:15%">����</th>
						<th bindName="account" sort="true"  style="width:15%">�˺�</th>
					</table>
				 </c:if>          
             </div>
             
       </div>
        
        <script type="text/javascript">
        
        var pageType="<c:out value='${param.pageType}'/>";
         //���ڵ�ID
    	var rootId = "";
    	 //���ڵ�ID
    	var parentId = "-1";
        var initBoxData=[];

        //��ǰѡ�е����ڵ�
    	var curNodeId = '';
        
    	 //��ǰѡ�е����ڵ�������֯
    	var curNodeOrgId = '';
    	 //���ٲ�ѯ�ı��
    	 var fastQueryFlag=0;  //Ϊͨ�����ٲ�ѯ���ڣ�0ΪĬ��
    	
        //ɨ�裬�൱����Ⱦ
        window.onload=function(){
        	
        	 if(globalUserId != 'SuperAdmin'){
				    dwr.TOPEngine.setAsync(false);
				    //��ѯ��Ͻ��Χ
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
        
      //��ʼ����֯�ṹ��Ϣ
    	function initOrgStructure(obj){
    		dwr.TOPEngine.setAsync(false);
    		OrganizationAction.getOrgStructureInfo(function(data){
    			if(data){
    				var arrData = jQuery.parseJSON(data)
    				//�Ƴ���Э��λ�����ݣ���Э��λ���ṩ��λ����20141209
    				arrData.splice(1,1);
    				obj.setDatasource(arrData);
    				obj.setValue(arrData[0].value,true);
    			}
    		});
    		dwr.TOPEngine.setAsync(true);
    	}
        

        //�л���֯�ṹ�����¼�������ҳ��
    	function changeOrgStructure(){
    		 initOrgTreeData();
    	}

    	
    	//����ʼ��
    	//�����ڵ�ID
    	var curTreeNodeId = '';
    	function initOrgTreeData(){
    		curOrgStrucId = cui('#orgStructure').getValue();
			curOrgStrucName =cui('#orgStructure').getText();
			window.parent.orgStrucChainChange(curOrgStrucId,curOrgStrucName);
    		var vo = {orgStructureId:cui('#orgStructure').getValue(), parentId:parentId,orgId:rootId};
    		dwr.TOPEngine.setAsync(false);
    		PostAction.queryRootOrg(vo,function(data){
    			var emptydata=[{title:"û������"}];
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
	        			
	        			//������ڵ�
	    	   			cui('#tree').getNode(data.key).activate(true);
	    	   			cui('#tree').getNode(data.key).expand(true);
    				}
    				$('#div_none').hide();
    				$('#div_tree').show();
    			}

    			//�л���֯�����ʱ��listbox��Ҫ���أ���ѯ�������
    			$('#div_none').hide();
    			$('#div_list').hide()
    			cui('#keyword').setValue('');
    			
    		});
    		dwr.TOPEngine.setAsync(true);
    	}


    	//ת���ڵ�
    	function handleNodeData(data){
    		data.isLazy = data.isLazy=='true'?true:false;
    		if(data.isFolder=='true'){//��֯�ڵ�
    		    data.isFolder=true;
    			data.icon='${pageScope.cuiWebRoot}/top/sys/images/closeicon.gif';
    		}else{//��λ�ڵ�
    			data.isFolder=false;
    		    data.icon='${pageScope.cuiWebRoot}/top/sys/images/post.png';
    		}
    	}


    	//�����¼��ڵ�
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

    	//ת���ڵ㼯��
    	function handleNodeList(lst){
    		for(var i=0;i<lst.length;++i){
    			var vo = lst[i];
    			vo.isLazy = vo.isLazy=='true'?true:false;
    			if(vo.isFolder=='true'){//��֯�ڵ�
    				if(vo.isLazy){
    				   vo.isFolder=true;//Ŀ¼�Ӵ�
    				}else{
    				   vo.isFolder=false;
    				}
    				vo.icon='${pageScope.cuiWebRoot}/top/sys/images/closeicon.gif';
    			}else{//��λ�ڵ�
    				vo.isFolder=false;
    				vo.icon='${pageScope.cuiWebRoot}/top/sys/images/post.png';
    				
    			}
    		}
    	}
    	
    	//���ڵ�չ�����𴥷�
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
    	// �������¼�
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
				//����֯��ѯ������
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
    	
		//���ٲ�ѯ
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
    			//������ڵ�
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

    	//���ٲ�ѯ�б�����Դ
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
    			vo.associateType=1;//����
    		}
    		
    			PostAction.fastQueryPost(vo,function(data){
    				if(data.length==0){
    					initBoxData = [{name:'û������',title:'û������'}];
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
    	

		//������ٲ�ѯ���
    	function selectMultiNavClick(key,title,orgId){
    		fastQueryFlag=1;
    		curNodeId=key;
    		//��߿��ٲ�ѯ��λ���ұ߿��ٲ�ѯ��Աʹ��
    		postId=key;
    		curNodeOrgId=orgId;
    		isOrg=false;
    		queryUserList(key);
    		
        }

    	

    	function showTree(){
    		//��ղ�ѯ����
    		 cui("#keyword").setValue("");
    		 keyword="";
    		 $('#div_none').show();
 			 $('#div_list').hide()
 			 $('#div_tree').show();
    	}
    	
    	
    	/*=======================================================*/
		//��Ⱦ�б�����
		function initData(grid,query){
			
				//��ȡ�����ֶ���Ϣ
			    var sortFieldName = query.sortName[0];
			    var sortType = query.sortType[0];
			    if(isOrg){//true �������Դ��֯��������֯id��ѯ������Ա�б�(ֻ��ѯû�й��ڸ�λ�µ���)
			    	 //���ò�ѯ����
				    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:userKeyword,sortFieldName:sortFieldName,sortType:sortType,orgId:orgId};
				    dwr.TOPEngine.setAsync(false);
				    PostAction.queryUserListByOrgIdNoPost(queryObj,function(data){
				    	var totalSize = data.count;
						var dataList = data.list;
						//��������Դ
						grid.setDatasource(dataList,totalSize);
						
		        	});
				    dwr.TOPEngine.setAsync(true);
				    //��ʾ����tip
				   $("#tipSpan").css("display",""); 
				    //���Ƹ�ҳ���ͼƬ��ʾ
				   window.parent.hidePicByOrgId(pageType);
			    	
			    }else{
					    //���ò�ѯ����
					    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:userKeyword,sortFieldName:sortFieldName,sortType:sortType,postId:postId};
					    dwr.TOPEngine.setAsync(false);
					    PostAction.queryUserListByPostId(queryObj,function(data){
					    	var totalSize = data.count;
							var dataList = data.list;
							//��������Դ
							grid.setDatasource(dataList,totalSize);
							
			        	});
					    dwr.TOPEngine.setAsync(true);
					    //��������tip
					    $("#tipSpan").css("display","none");
					    //���Ƹ�ҳ���ͼƬ��ʾ
						 window.parent.hidePicByPostId(pageType);
			    }
			
	  	}
    		
    	
		 //��Ⱦ��λ�µ���Ա�б�����
		function queryUserList(postId){
		    
			
		    var grid=cui("#userGrid");
			var query =grid.getQuery();
			//��ȡ�����ֶ���Ϣ
		    var sortFieldName = query.sortName[0];
		    var sortType = query.sortType[0];
		   
		    //���»�ȡ��ѯ����
		     userKeyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			 userKeyword = userKeyword.replace(new RegExp("%", "gm"), "/%");
			 userKeyword = userKeyword.replace(new RegExp("_","gm"), "/_");
			 userKeyword = userKeyword.replace(new RegExp("'","gm"), "''");
		    
		    if(isOrg){//true ���������֯��������֯id��ѯ������Ա�б�(ֻ��ѯû�й��ڸ�λ�µ���)
		    	 //���ò�ѯ����
			    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:userKeyword,sortFieldName:sortFieldName,sortType:sortType,orgId:orgId};
			    dwr.TOPEngine.setAsync(false);
			    PostAction.queryUserListByOrgIdNoPost(queryObj,function(data){
			    	var totalSize = data.count;
					var dataList = data.list;
					//��������Դ
					grid.setDatasource(dataList,totalSize);
					
	        	});
			    dwr.TOPEngine.setAsync(true);
			    //��ʾ����tip
			    $("#tipSpan").css("display","");
			    //���Ƹ�ҳ���ͼƬ��ʾ
				 window.parent.hidePicByOrgId(pageType);
		    	
		    }else{
				    //���ò�ѯ����
				    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:userKeyword,sortFieldName:sortFieldName,sortType:sortType,postId:postId};
				    dwr.TOPEngine.setAsync(false);
				    PostAction.queryUserListByPostId(queryObj,function(data){
				    	var totalSize = data.count;
						var dataList = data.list;
						//��������Դ
						grid.setDatasource(dataList,totalSize);
						
		        	});
				    dwr.TOPEngine.setAsync(true);
				    //��������tip
				    $("#tipSpan").css("display","none");
				    //���Ƹ�ҳ���ͼƬ��ʾ
					 window.parent.hidePicByPostId(pageType);
		    }
		    
	  	}
		//Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
		function resizeWidth(){
			return $('#centerMain').width()-2;
		}

		//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
		function resizeHeight(){
			//ie6�·��ع̶�ֵ������ie6�¿���
			if(comtop.Browser.isIE6){
				return 315;
			}
			return $('#centerMain').height()-40;
		}
    		

		 //������ͼƬ����¼�
		 var userKeyword="";
		 function iconclick() {
			 userKeyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			 userKeyword = userKeyword.replace(new RegExp("%", "gm"), "/%");
			 userKeyword = userKeyword.replace(new RegExp("_","gm"), "/_");
			 userKeyword = userKeyword.replace(new RegExp("'","gm"), "''");
	        cui("#userGrid").setQuery({pageNo:1});
	        //ˢ���б�
			cui("#userGrid").loadData();
	     }
            
		 
        </script>
</body>
</html>