<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
    <title>��λ������ҳ��</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostAction.js"></script>
	<style type="text/css">
		.a{border:2px solid #9ACDE8}
		.b{border:2px solid #EEEEEE}
	</style>
	<script language="javascript">
		$(function(){
		   comtop.UI.scan();
		   initEvent();
		    
		});
		
		//��ʼ������
		function initEvent(){
			cui("#borderlayout").setContentURL("right","${pageScope.cuiWebRoot}/top/sys/post/PostAdjustTree.jsp?pageType=2"); 
		    setTimeout(function(){cui("#borderlayout").setContentURL("left","${pageScope.cuiWebRoot}/top/sys/post/PostAdjustTree.jsp?pageType=1")},300);
		}
		
		//�������Ԫ��ʱ������ʽ
		function setMouseOverClass(obj){
			obj.className='a';	
		}

		//����ƿ�Ԫ��ʱ������ʽ
		function setMouseOutClass(obj){
			obj.className='b';	
		}
		
		//���ڲ���
		var sourcePostId ="";
		var targetPostId ="";
		//ת����֯id
		var sourceOrgId = "";
		//ת����֯id
		var targetOrgId = "";
		function transfer(){
			
			
			var sourceTreePage = cui("#leftPanel .bl_iframe_page")[0].contentWindow;
			var targetTreePage = cui("#rightPanel .bl_iframe_page")[0].contentWindow;
			
			
			//ѡ�����Ա��λ������ϵ����
			var userRePostIds = sourceTreePage.cui("#userGrid").getSelectedPrimaryKey();
			//ѡ���������
			var userRePostRowDatas = sourceTreePage.cui("#userGrid").getSelectedRowData();
			//ѡ���userIds
			var userIds="";
			for(var i=0;i<userRePostRowDatas.length;i++){
				   //��ȡ�û���id
				   userIds+=userRePostRowDatas[i].userId+";";
			   }
			//ת�����飬ȥ�����һ��";"��
		    userIds=userIds.substring(0,userIds.length-1);	
		    userIds=userIds.split(";");
		  
			
			if(userRePostRowDatas==null || userRePostRowDatas.length==0){
				cui.alert("��ѡ��Ҫ���ڵ���Ա��");
				return;
			}
			//��ȡ��ǰѡ�и�λid
			var sourceTreeNode = sourceTreePage.cui("#tree").getActiveNode();
			var targetTreeNode = targetTreePage.cui("#tree").getActiveNode();
			if(targetTreePage.fastQueryFlag==0&&(targetTreeNode==null||targetTreeNode.dNode.data.orgId==null)){//ѡ���λ�ڵ��ʱ��orgId�������ݵģ�ѡ���Žڵ���ֶ�û������
				cui.alert("��ѡ��ת���λ��");
				return;
			}
			if(targetTreePage.fastQueryFlag==1&&targetPostId==null){
				cui.alert("��ѡ��ת���λ��");
				return;
				
			}
			//ת����λid
			 sourcePostId = sourceTreePage.curNodeId;
			//ת���λid
			 targetPostId = targetTreePage.curNodeId;
			if(sourcePostId==targetPostId){
				cui.alert("ת����λ��ת���λ������ͬ��");
				return;
			}
			
			 //ת����֯id
			 sourceOrgId = sourceTreePage.curNodeOrgId;
			//ת����֯id
			 targetOrgId = targetTreePage.curNodeOrgId;
			
			
			
			  dwr.TOPEngine.setAsync(false);
			   PostAction.queryRepeatUserName(userIds,targetPostId,1,function(data){
				   if(data.flag){//true ������������Ա
				      cui.alert("��<font color='red'>"+data.usrNames+"</font>��ת���λ�Ѵ��ڡ�");
		    		  return;
				   }else{
						//���ת����֯id��ת����֯id ��һ��  ��Ҫ�����û���������֯������ϵ(������֯id)
						if(sourceOrgId!=targetOrgId){
							//�����ж�ͬһ��֯���Ƿ����� 20151217
							PostAction.queryRepeatUserName(userIds,targetOrgId,2,function(data){
								   if(data.flag){//true ������������Ա
								      cui.alert("��<font color='red'>"+data.usrNames+"</font>������ת���λ������֯�£����ܵ��ڡ�");
						    		  return;
								   }else{
										  cui.confirm("ת���λ������֯��ת����λ��������֯��һ�£���ѡ��Ա������֯������Ϊת���λ����֯���Ƿ������",{
												onYes:function(){//��ͬ��֯�µĵ�ְ��Ҫ�ߵ�������
													//�ж��û��Ƿ��й�������������
													 dwr.TOPEngine.setAsync(false);
													    PostAction.queryUserTaskInALlProcess(userIds,function(data){
													    	 if(data.flag){//true ��û�����Ѵ������ݣ����Ե���
													    		 
													    		//���ڲ���(ɾ��ԭ�еĸ�λ��Ա������ϵ�������µĸ�λ��Ա������ϵ)
																 dwr.TOPEngine.setAsync(false);
															     var vo = {userRePostIds:userRePostIds, userIdList:userIds,sourcePostId:sourcePostId,targetPostId:targetPostId,postRelationType:1,sourceOrgId:sourceOrgId,targetOrgId:targetOrgId};
																    PostAction.updateTransferPost(vo,function(flag){
																		 targetTreePage.cui('#myClickInput').setValue('');
																		 targetTreePage.keyword = '';
																		 targetTreePage.userKeyword = '';
																		
																		 if(sourceTreePage.fastQueryFlag==1){//���ٲ�ѯˢ���б�
																			 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
																		 }else{
																			 sourceTreePage.cui("#userGrid").loadData();
																		 }
																		 if(targetTreePage.fastQueryFlag==1){ //���ٲ�ѯˢ���б�
																			 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
																		 }else{
																		     targetTreePage.cui("#userGrid").loadData();
																		 }
																		 cui.message("���ڳɹ���","success");
														        	});
																  dwr.TOPEngine.setAsync(true);
													    		 
													    	 }else{
													    		   //���ڴ������ݣ�����
													    		  cui.confirm("��<font color='red'>"+data.usrNames+"</font>������δ����������ݣ��Ƿ������",{
																		onYes:function(){
																			//��������� ���ڲ���
																			//���ڲ���(ɾ��ԭ�еĸ�λ��Ա������ϵ�������µĸ�λ��Ա������ϵ)
																			 dwr.TOPEngine.setAsync(false);
																		     var vo = {userRePostIds:userRePostIds, userIdList:userIds,sourcePostId:sourcePostId,targetPostId:targetPostId,postRelationType:1,sourceOrgId:sourceOrgId,targetOrgId:targetOrgId};
																			    PostAction.updateTransferPost(vo,function(flag){
																					 targetTreePage.cui('#myClickInput').setValue('');
																					 targetTreePage.keyword = '';
																					 targetTreePage.userKeyword = '';
																					
																					 if(sourceTreePage.fastQueryFlag==1){//���ٲ�ѯˢ���б�
																						 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
																					 }else{
																						 sourceTreePage.cui("#userGrid").loadData();
																					 }
																					 
																					
																					 if(targetTreePage.fastQueryFlag==1){ //���ٲ�ѯˢ���б�
																						 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
																					 }else{
																					     targetTreePage.cui("#userGrid").loadData();
																					 }
																					
																					 cui.message("���ڳɹ���","success");
																			    	
																	        	});
																			  dwr.TOPEngine.setAsync(true);
																		  }
																	   }
																   );
													    		 
													    	 }
													    	
											        	});
													  dwr.TOPEngine.setAsync(true);
												  }
											}
										   );	
					           }
							});		   
						  
						}else{
							
							//���ڲ���(ɾ��ԭ�еĸ�λ��Ա������ϵ�������µĸ�λ��Ա������ϵ)
							 dwr.TOPEngine.setAsync(false);
						     var vo = {userRePostIds:userRePostIds, userIdList:userIds,sourcePostId:sourcePostId,targetPostId:targetPostId,postRelationType:1,sourceOrgId:sourceOrgId,targetOrgId:targetOrgId};
							    PostAction.updateTransferPost(vo,function(flag){
									 targetTreePage.cui('#myClickInput').setValue('');
									 targetTreePage.keyword = '';
									 targetTreePage.userKeyword = '';
									 
									 if(sourceTreePage.fastQueryFlag==1){//���ٲ�ѯˢ���б�
										 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
									 }else{
										 sourceTreePage.cui("#userGrid").loadData();
									 }
									 
									 if(targetTreePage.fastQueryFlag==1){ //���ٲ�ѯˢ���б�
										 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
									 }else{
									     targetTreePage.cui("#userGrid").loadData();
									 }
									 cui.message("���ڳɹ���","success");
							    	
					        	});
							  dwr.TOPEngine.setAsync(true);
						}
					   
				   }
			   });
			  dwr.TOPEngine.setAsync(true);
			
			
		}
		
		
		
		//��ְ����
		function partTime(){
			
			var sourceTreePage = cui("#leftPanel .bl_iframe_page")[0].contentWindow;
			var targetTreePage = cui("#rightPanel .bl_iframe_page")[0].contentWindow;
			
			//ѡ�����Ա��λ������ϵ����
			var userRePostIds = sourceTreePage.cui("#userGrid").getSelectedPrimaryKey();
			//ѡ���������
			var userRePostRowDatas = sourceTreePage.cui("#userGrid").getSelectedRowData();
			//ѡ���userIds
			var userIds="";
			for(var i=0;i<userRePostRowDatas.length;i++){
				   //��ȡ�û���id
				   userIds+=userRePostRowDatas[i].userId+";";
			   }
			//ת�����飬ȥ�����һ��";"��
		    userIds=userIds.substring(0,userIds.length-1);	
		    userIds=userIds.split(";");
		  
			
			if(userRePostRowDatas==null || userRePostRowDatas.length==0){
				cui.alert("��ѡ��Ҫ��ڵ���Ա��");
				return;
			}
			//��ȡ��ǰѡ�и�λid
			var sourceTreeNode = sourceTreePage.cui("#tree").getActiveNode();
			var targetTreeNode = targetTreePage.cui("#tree").getActiveNode();
			if(targetTreePage.fastQueryFlag==0&&(targetTreeNode==null||targetTreeNode.dNode.data.orgId==null)){//ѡ���λ�ڵ��ʱ��orgId�������ݵģ�ѡ���Žڵ���ֶ�û������
				cui.alert("��ѡ��ת���λ��");
				return;
			}
			if(targetTreePage.fastQueryFlag==1&&targetPostId==null){
				cui.alert("��ѡ��ת���λ��");
				return;
				
			}
			//ת����λid
			 sourcePostId = sourceTreePage.curNodeId;
			//ת���λid
			 targetPostId = targetTreePage.curNodeId;
			if(sourcePostId==targetPostId){
				cui.alert("ת����λ��ת���λ������ͬ��");
				return;
			}
			//ת����֯id
			 sourceOrgId = sourceTreePage.curNodeOrgId;
			//ת����֯id
			 targetOrgId = targetTreePage.curNodeOrgId;
			//���ת����֯id��ת����֯id ��һ�� ,����������Ա����֯�Ĺ�����ϵ
			  
			if(sourceOrgId!=targetOrgId){
			  cui.confirm("ת���λ������֯��ת����λ��������֯��һ�£���ѡ��Ա��ͬʱ��ְ����֯���Ƿ������",{
					onYes:function(){
						//��ְ����(��ɾ��ԭ�еĸ�λ��Ա������ϵ�������µĸ�λ��Ա������ϵ)
						 dwr.TOPEngine.setAsync(false);
					     var vo = {userRePostIds:userRePostIds, userIdList:userIds,sourcePostId:sourcePostId,targetPostId:targetPostId,postRelationType:1,sourceOrgId:sourceOrgId,targetOrgId:targetOrgId};
						    PostAction.insertPartTimePost(vo,function(flag){
								 targetTreePage.cui('#myClickInput').setValue('');
								 targetTreePage.keyword = '';
								 targetTreePage.userKeyword = '';
								 
								 if(sourceTreePage.fastQueryFlag==1){//���ٲ�ѯˢ���б�
									 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
								 }else{
									 sourceTreePage.cui("#userGrid").loadData();
								 }
								 
								
								 if(targetTreePage.fastQueryFlag==1){ //���ٲ�ѯˢ���б�
									 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
								 }else{
								     targetTreePage.cui("#userGrid").loadData();
								 }
								 cui.message("��ڳɹ���","success");
						    	 
				        	});
						  dwr.TOPEngine.setAsync(true);
					  }
				}
			   );	
			}else{
				
				//���ڲ���(ɾ��ԭ�еĸ�λ��Ա������ϵ�������µĸ�λ��Ա������ϵ)
				 dwr.TOPEngine.setAsync(false);
			     var vo = {userRePostIds:userRePostIds, userIdList:userIds,sourcePostId:sourcePostId,targetPostId:targetPostId,postRelationType:1,sourceOrgId:sourceOrgId,targetOrgId:targetOrgId};
				    PostAction.insertPartTimePost(vo,function(flag){
						 targetTreePage.cui('#myClickInput').setValue('');
						 targetTreePage.keyword = '';
						 targetTreePage.userKeyword = '';
						 
						 if(sourceTreePage.fastQueryFlag==1){//���ٲ�ѯˢ���б�
							 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
						 }else{
							 sourceTreePage.cui("#userGrid").loadData();
						 }
						 
						
						 if(targetTreePage.fastQueryFlag==1){ //���ٲ�ѯˢ���б�
							 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
						 }else{
						     targetTreePage.cui("#userGrid").loadData();
						 }
						 cui.message("��ڳɹ���","success");
				    	
		        	});
				  dwr.TOPEngine.setAsync(true);
				
				
			}
		}
		
		
		//��ְ����
		function removal(){
			
			var sourceTreePage = cui("#leftPanel .bl_iframe_page")[0].contentWindow;
			
			//ѡ�����Ա��λ������ϵ����
			var userRePostIds = sourceTreePage.cui("#userGrid").getSelectedPrimaryKey();
			//ѡ���������
			var userRePostRowDatas = sourceTreePage.cui("#userGrid").getSelectedRowData();
			//ѡ���userIds
			var userIds="";
			for(var i=0;i<userRePostRowDatas.length;i++){
				   //��ȡ�û���id
				   userIds+=userRePostRowDatas[i].userId+";";
			   }
			//ת�����飬ȥ�����һ��";"��
		    userIds=userIds.substring(0,userIds.length-1);	
		    userIds=userIds.split(";");
		  
			
			if(userRePostRowDatas==null || userRePostRowDatas.length==0){
				cui.alert("��ѡ��Ҫ���ڵ���Ա��");
				return;
			}
			
			//ѡ�еĸ�λid
			 sourcePostId = sourceTreePage.curNodeId;
			
			//��λ������֯id
			 sourceOrgId = sourceTreePage.curNodeOrgId;
			
			//����ʾ���ϳ�ְ��������Ա
			 dwr.TOPEngine.setAsync(false);
			    PostAction.partTimeFilter(userIds,function(data){
			    	  if(data.flag){//true ����û�м�ְ����Ա
					      cui.alert("��<font color='red'>"+data.usrNames+"</font>���޼����������ܳ��ڡ�");
			    		  return;
					   }else{
					        //ѡ�����Ա�����ڼ�ְ������ж��Ƿ���ڹ��������죬����
						   dwr.TOPEngine.setAsync(false);
						   PostAction.queryUserTaskInALlProcess(userIds,function(data){
							   if(!data.flag){//false �������Ѵ������ݣ�����
								   cui.confirm("��<font color='red'>"+data.usrNames+"</font>������δ����������ݣ��Ƿ������",{
										onYes:function(){
											//��������ɳ�ְ����
											 dwr.TOPEngine.setAsync(false);
											 var vo = {userRePostIds:userRePostIds, userIdList:userIds,sourcePostId:sourcePostId,postRelationType:1,sourceOrgId:sourceOrgId};
											 PostAction.updateRemovePost(vo,function(flag){
											    
												 
												 if(sourceTreePage.fastQueryFlag==1){//���ٲ�ѯˢ���б�
													 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
												 }else{
													 sourceTreePage.cui("#userGrid").loadData();
												 }
												 cui.message("���ڳɹ���","success");
											    	
									        	});
											  dwr.TOPEngine.setAsync(true);
										  }
									}
								   );	
							   }else{
								   //��ɳ�ְ����
								     dwr.TOPEngine.setAsync(false);
								     var vo = {userRePostIds:userRePostIds, userIdList:userIds,sourcePostId:sourcePostId,postRelationType:1,sourceOrgId:sourceOrgId};
									 PostAction.updateRemovePost(vo,function(flag){
									    
										 
										 if(sourceTreePage.fastQueryFlag==1){//���ٲ�ѯˢ���б�
											 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
										 }else{
											 sourceTreePage.cui("#userGrid").loadData();
										 }
										 cui.message("���ڳɹ���","success");
									    	
							        	});
									 dwr.TOPEngine.setAsync(true);
							   }
						    });
						   dwr.TOPEngine.setAsync(true)
					   }
			    	
	        	});
			 dwr.TOPEngine.setAsync(true);
		}
		
		
		//ͬ���ı�Ŀ����֯�ṹ
		function orgStrucChainChange(value,text){
			var orgStruc = [{name:text,orgStructureId:value}];
			var postAdjustTreePage = $("#rightPanel .bl_iframe_page")[0].contentWindow;
			    postAdjustTreePage.cui("#orgStructure").setValue(value);
			    postAdjustTreePage.cui("#orgStructure").setReadonly(true);
		}
		
		
		 //�����֯��ͼƬ��ʾ
	     function hidePicByOrgId(pageType){
	    	 if(pageType==1){
		    	 $("#boardingPost").css("display","inline");
		    	 $("#adjustOrg").css("display","inline");
		    	 $("#transfer").css("display","none");
		    	 $("#partTime").css("display","none");
		    	 $("#removal").css("display","none");
	    	 }
		}
		 
	     //�����λ��ͼƬ��ʾ
	     function hidePicByPostId(pageType){
	    	
	    	 if(pageType==1){
		    	 $("#boardingPost").css("display","none");
		    	 $("#adjustOrg").css("display","none");
		    	 $("#transfer").css("display","inline");
		    	 $("#partTime").css("display","inline");
		    	 $("#removal").css("display","inline");
	    	 }
		}
		 
		 
		 //�θڲ���20141218
		 function boardingPost(){
			 var sourceTreePage = cui("#leftPanel .bl_iframe_page")[0].contentWindow;
			 var targetTreePage = cui("#rightPanel .bl_iframe_page")[0].contentWindow;
			 
			//ѡ�����Ա��λ������ϵ����
		     var userRePostIds = sourceTreePage.cui("#userGrid").getSelectedPrimaryKey();
		   //ѡ���������
		     var userRePostRowDatas = sourceTreePage.cui("#userGrid").getSelectedRowData();
		   //ѡ���userIds
				var userIds="";
				for(var i=0;i<userRePostRowDatas.length;i++){
					   //��ȡ�û���id
					   userIds+=userRePostRowDatas[i].userId+";";
				   }
				//ת�����飬ȥ�����һ��";"��
			    userIds=userIds.substring(0,userIds.length-1);	
			    userIds=userIds.split(";");
			  
				
				if(userRePostRowDatas==null || userRePostRowDatas.length==0){
					cui.alert("��ѡ��Ҫ�θڵ���Ա��");
					return;
				}
				
				//ѡ���λ�ڵ��ʱ�򣬻�ȡת���λid
				if(targetTreePage.isOrg==false){
					targetPostId = targetTreePage.curNodeId
				}
				//ѡ����֯��ʱ��targetPostId�ÿ�
				if(targetTreePage.isOrg==true){
					targetPostId ="";
				}
				
				if((targetTreePage.isOrg)&&(targetPostId==null || targetPostId.length==0)){
					cui.alert("��ѡ���θڵĸ�λ��");
					return;
				}
				
				 //Դ��֯id
				 sourceOrgId = sourceTreePage.curNodeOrgId;
				//ת����֯id
				 targetOrgId = targetTreePage.curNodeOrgId;
				
				  dwr.TOPEngine.setAsync(false);
				   PostAction.queryRepeatUserName(userIds,targetPostId,1,function(data){
					   if(data.flag){//true ������������Ա
					      cui.alert("��<font color='red'>"+data.usrNames+"</font>��ת���λ�Ѵ��ڡ�");
			    		  return;
					   }else{
						   
						    
							//���ת����֯id��ת����֯id ��һ��  ��Ҫ�����û���������֯������ϵ(������֯id)
							if(sourceOrgId!=targetOrgId){
								//�����ж�ͬһ��֯���Ƿ����� 20151217
								PostAction.queryRepeatUserName(userIds,targetOrgId,2,function(data){
									   if(data.flag){//true ������������Ա
									      cui.alert("��<font color='red'>"+data.usrNames+"</font>������ת���λ������֯�£������θڡ�");
							    		  return;
									   }else{	
								
											  cui.confirm("��Ա������֯���θڵ�������֯��һ�£���ѡ��Ա������֯������Ϊ�θڸ�λ����֯���Ƿ������",{ 
													onYes:function(){
														    		 
														    		//�θڲ���(�����µĸ�λ��Ա������ϵ)
																	 dwr.TOPEngine.setAsync(false);
																     var vo = {userRePostIds:userRePostIds, userIdList:userIds,targetPostId:targetPostId,postRelationType:1,sourceOrgId:sourceOrgId,targetOrgId:targetOrgId};
																	    PostAction.updateBoardingPost(vo,function(flag){
																			 targetTreePage.cui('#myClickInput').setValue('');
																			 targetTreePage.keyword = '';
																			 targetTreePage.userKeyword = '';
																			
																			 if(sourceTreePage.fastQueryFlag==1){//���ٲ�ѯˢ���б�
																				 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
																			 }else{
																				 sourceTreePage.cui("#userGrid").loadData();
																			 }
																			 
																			
																			 if(targetTreePage.fastQueryFlag==1){ //���ٲ�ѯˢ���б�
																				 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
																			 }else{
																			     targetTreePage.cui("#userGrid").loadData();
																			 }
																			 cui.message("�θڳɹ���","success");
																	    	
															        	});
																	  dwr.TOPEngine.setAsync(true);
													  }
												  }
											   );	
									      }
								});		
							  
							}else{
								
								//�θڲ���(�����µĸ�λ��Ա������ϵ)
								 dwr.TOPEngine.setAsync(false);
							     var vo = {userRePostIds:userRePostIds, userIdList:userIds,targetPostId:targetPostId,postRelationType:1,sourceOrgId:sourceOrgId,targetOrgId:targetOrgId};
								    PostAction.updateBoardingPost(vo,function(flag){
										 targetTreePage.cui('#myClickInput').setValue('');
										 targetTreePage.keyword = '';
										 targetTreePage.userKeyword = '';
										 
										 if(sourceTreePage.fastQueryFlag==1){//���ٲ�ѯˢ���б�
											 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
										 }else{
											 sourceTreePage.cui("#userGrid").loadData();
										 }
										 
										 if(targetTreePage.fastQueryFlag==1){ //���ٲ�ѯˢ���б�
											 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
										 }else{
										     targetTreePage.cui("#userGrid").loadData();
										 }
										 cui.message("�θڳɹ���","success");
								    	
						        	});
								  dwr.TOPEngine.setAsync(true);

							  }
						   
					   }
				   });
				  dwr.TOPEngine.setAsync(true);
	       }		 
		 
		 
		 //����֯����
		 function adjustOrg(){
				var sourceTreePage = cui("#leftPanel .bl_iframe_page")[0].contentWindow;
				var targetTreePage = cui("#rightPanel .bl_iframe_page")[0].contentWindow;
				//ѡ�����Ա��λ������ϵ����
				var userRePostIds = sourceTreePage.cui("#userGrid").getSelectedPrimaryKey();
				//ѡ���������
				var userRePostRowDatas = sourceTreePage.cui("#userGrid").getSelectedRowData();
				if(userRePostRowDatas==null || userRePostRowDatas.length==0){
					cui.alert("��ѡ��Ҫ����֯����Ա��");
					return;
				}
				//Ŀ�꼤��ڵ�
				var targetTreeNode = targetTreePage.cui("#tree").getActiveNode();
				if(targetTreePage.fastQueryFlag==0&&(targetTreeNode==null||targetTreeNode.dNode.data.orgId!=null)){//ѡ���λ�ڵ��ʱ��orgId�������ݵģ�ѡ���Žڵ���ֶ�û������
					cui.alert("��ѡ��Ŀ����֯��");
					return;
				}
				//ת����֯id
				 sourceOrgId = sourceTreePage.curNodeOrgId;
				//ת����֯id
				 targetOrgId = targetTreePage.curNodeOrgId;
				//���ת����֯id��ת����֯id һ�� ,���ܵ���
				if(sourceOrgId==targetOrgId){
					cui.alert("ת����֯��ת����֯������ͬ��");
					return;
				}
				
				//ѡ���userIds
				var userIds="";
				for(var i=0;i<userRePostRowDatas.length;i++){
					   //��ȡ�û���id
					   userIds+=userRePostRowDatas[i].userId+";";
				   }
				//ת�����飬ȥ�����һ��";"��
			    userIds=userIds.substring(0,userIds.length-1);	
			    userIds=userIds.split(";");
			    //��Ҫ�ж�Ŀ����֯�Ƿ����ظ���employeeId����Ա
			       	  dwr.TOPEngine.setAsync(false);
					   PostAction.queryRepeatUserName(userIds,targetOrgId,2,function(data){
						   if(data.flag){//true ������������Ա
						      cui.alert("��<font color='red'>"+data.usrNames+"</font>��Ŀ����֯�Ѵ��ڡ�");
				    		  return;
						   }else{   //��ɵ����Ų���,���²���Id��Ϣ���ɣ�δ�θ��޸�λȨ����Ϣ
							   PostAction.updateOrgIdInUserIds(targetOrgId,userIds,function(data){
									 targetTreePage.cui('#myClickInput').setValue('');
									 targetTreePage.keyword = '';
									 targetTreePage.userKeyword = '';
									 
									 if(sourceTreePage.fastQueryFlag==1){//���ٲ�ѯˢ���б�
										 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
									 }else{
										 sourceTreePage.cui("#userGrid").loadData();
									 }
									 
									 if(targetTreePage.fastQueryFlag==1){ //���ٲ�ѯˢ���б�
										 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
									 }else{
									     targetTreePage.cui("#userGrid").loadData();
									 }
									 
								   cui.message("����֯�ɹ���","success");
							   });
							   
						   }
					   });
					  dwr.TOPEngine.setAsync(true);
		 }
		
	</script>
</head>
<body>
        
 <div uitype="Borderlayout" id="borderlayout" is_root="true" gap="0px 0px 0px 0px" fixed="{'bottom':true,'left':false,'center':true,'right':false}">
	<div id="leftPanel" position="left" gap="0px 0px 0px 0px" is_header="true" header_content="<div align='center'><b style='color: #326EE9;font-size:15px'>ת����λ</b></div>" min_size="50" collapsable="false"></div>
	<div id="centerPanel" position="center" gap="0px 0px 0px 0px" collapsable="false" width="70">
		<div align="center" style="position:relative;top:50%;">
			<img src="${pageScope.cuiWebRoot}/top/sys/images/arrow.png" Style="width: 64px;height: 64px;" />
		</div>
	</div>
	<div  id="rightPanel"  position="right" gap="0px 0px 0px 0px" is_header="true" header_content="<div align='center'><b style='color: #326EE9;font-size:15px'>ת���λ</b></div>" collapsable="false"></div>
	<div id="bottomPanel"  position="bottom" height="65" gap="0px 0px 0px 0px" collapsable="false">
		<div align="center">
			<div  id="boardingPost" style="display:none"><img class="b" title="�θ�" src="${pageScope.cuiWebRoot}/top/sys/images/boardingPost.png" style="cursor: pointer" onclick="boardingPost()" onmouseover="setMouseOverClass(this)" onmouseout="setMouseOutClass(this)" /></div>
			<div  id="adjustOrg" style="display:none"><img class="b" title="����֯" src="${pageScope.cuiWebRoot}/top/sys/images/adjustOrg.png" style="cursor: pointer" onclick="adjustOrg()" onmouseover="setMouseOverClass(this)" onmouseout="setMouseOutClass(this)" /></div>
			<div  id="transfer" style="display:none"><img class="b" title="����" src="${pageScope.cuiWebRoot}/top/sys/images/transfer.png" style="cursor: pointer" onclick="transfer()" onmouseover="setMouseOverClass(this)" onmouseout="setMouseOutClass(this)" /></div>
			<div  id="partTime" style="display:none"><img class="b" title="���" src="${pageScope.cuiWebRoot}/top/sys/images/partTime.png" style="cursor: pointer" onclick="partTime()" onmouseover="setMouseOverClass(this)" onmouseout="setMouseOutClass(this)" /></div>
		    <div  id="removal" style="display:none"><img class="b" title="����" src="${pageScope.cuiWebRoot}/top/sys/images/removal.png" style="cursor: pointer" onclick="removal()" onmouseover="setMouseOverClass(this)" onmouseout="setMouseOutClass(this)" /></div>
		 </div>
	</div>
</div>
</body>
</html>