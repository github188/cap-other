<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
    <title>��λ����</title>
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
	            &nbsp;&nbsp;<label style="font-size: 12px;">��֯�ṹ��</label>
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

         //���ڵ�ID
    	var rootOrgId = "";
    	  //���ڵ�ID
    	var parentId = "-1";
    	
    	  //�жϵ�ǰ�����Ƿ��ǽ���ҳ�����
    	var operateFlag = "0";
    	  
    	  //��֯�ṹ
    	var orgStructureId="";  

        var initBoxData=[];

        //��ǰѡ�е����ڵ�
    	var curNodeId = '';
    	
        //ɨ�裬�൱����Ⱦ
        window.onload=function(){
        	 if(globalUserId != 'SuperAdmin'){
				    dwr.TOPEngine.setAsync(false);
				    //��ѯ��Ͻ��Χ
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

      //�л���֯�ṹ�����¼�������ҳ��
    	function changeOrgStructure(){
    		initOrgTreeData(cui('#tree'));
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

    	
    	//����ʼ��
    	function initOrgTreeData(){
    		var vo = {orgStructureId:cui('#orgStructure').getValue(), parentId:parentId,orgId:rootOrgId};
    		dwr.TOPEngine.setAsync(false);
    		PostAction.queryRootOrg(vo,function(data){
    			var emptydata=[{title:"û������"}];
    			if(!data){
    				$('#div_none').show();
    				cui('#tree').setDatasource(emptydata);
    				//ˢ���Ҳ�ҳ��
    				cui("#postBorderlayout").setContentURL("center","PostEdit.jsp"); 
    			}else{
    				handleNodeData(data);
    				cui('#tree').setDatasource(data);
    				if(data.isLazy){
	    				curNodeId = data.key;
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
    	
    	var isOrg=true;
    	// �������¼�
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
			if(postId&&orgId){ //�����λ
				  cui("#postBorderlayout").setContentURL("center","PostEdit.jsp?postName="+encodeURIComponent(encodeURIComponent(postName))+"&postId="+ postId+"&orgId="+orgId+"&orgName="+ encodeURIComponent(encodeURIComponent(orgName))+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId); 
				}
			if(orgId&&!postId){ //�����֯
					cui("#postBorderlayout").setContentURL("center","PostList.jsp?orgId="+orgId+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId+"&orgName="+ encodeURIComponent(encodeURIComponent(orgName)) + "&operateFlag="+ operateFlag); 
			}
			operateFlag = '1';
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

    	//���ٲ�ѯ�б�����Դ
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
    		orgStructureId=cui('#orgStructure').getValue();
    		cui("#postBorderlayout").setContentURL("center","PostEdit.jsp?postName="+title+"&postId="+ key+"&orgId="+ orgId+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId);     		
        }

    	// �ص�,ˢ����   ����(�ڵ㣬���ڵ㣬���ڵ����ƣ��ص�����num��1��������2�Ǳ༭��3��ɾ����4���� ������,5����)
    	function refreshEditTree(postId,orgId,orgName,num){
    		 
    		    showTree();
    		  
    			//ˢ�������
    			//�Ƴ�orgId�µ������ӽڵ㣬���¼����ӽڵ�
    		    var node = cui('#tree').getNode(orgId);
    			if(node){ //�ڵ��Ѿ�����
	    			node.getData().isLazy=false;
	    			var children=node.children();
	    			if(children){
	    				for(var i=0; i < children.length; i++){
	    					children[i].remove();  
	    				}
	    			}
	    			lazyData(node);
    			}else{//�ڵ�δ����
    				var tmpPostId=postId;
    				if(num==3||num==4){
    					tmpPostId="";
   				     }
    				 //�õ������ͱ༭�ڵ��ID Path

					 var path;
					 dwr.TOPEngine.setAsync(false);
					 PostAction.queryIDFullPath(orgId,tmpPostId,function(data){
							path = data.split('/');
					 });
					 dwr.TOPEngine.setAsync(true);
					 //�Ӹ��ڵ㿪ʼ������ֱ��չ������ǰ�ڵ�Ϊֹ ����ѡ�е�ǰ�ڵ�
					$.each(path,function(i,iPostId){
						var iNode = cui("#tree").getNode(iPostId);
						if(i==path.length-1){
							iNode.activate(true);
						}else{
							iNode.expand(true);
						}
					});
    				
    			}
    			//����ڵ�
    			if(num==1){
		   			cui('#tree').getNode(postId).activate(true);
		   			cui('#tree').getNode(postId).focus(true);
		   			postName=cui('#tree').getNode(postId).getData().title;
					//��ʾ�ұ�ҳ��
		   			cui("#postBorderlayout").setContentURL("center","PostEdit.jsp?postId="+ postId+"&postName="+encodeURIComponent(encodeURIComponent(postName))+"&orgId="+orgId+"&orgName="+ encodeURIComponent(encodeURIComponent(orgName))+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId); 
					
    			}
    			if(num==2){
		   			cui('#tree').getNode(postId).activate(true);
		   			cui('#tree').getNode(postId).focus(true);
    			}
    			if(num==3){
		   			cui('#tree').getNode(orgId).activate(true);
		   			cui('#tree').getNode(orgId).focus(true);
		   		    //��ʾ�ұ�ҳ��
		   			cui("#postBorderlayout").setContentURL("center","PostList.jsp?orgId="+orgId+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId+"&orgName="+ encodeURIComponent(encodeURIComponent(orgName))); 
    			}
    			
    			if(num==4||num==5){
        			
		   			cui('#tree').getNode(orgId).activate(true);
		   			cui('#tree').getNode(orgId).focus(true);
    			}
    			
    			
    	}

    	function showTree(){
    		//��ղ�ѯ����
    		
    		 cui("#keyword").setValue("");
    		 keyword="";
    		 cui("#div_list").hide();
    		 cui("#div_tree").show();
    		 
    	}

            
        </script>
</body>
</html>