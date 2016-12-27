<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
    <title>岗位调动主页面</title>
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
		
		//初始化数据
		function initEvent(){
			cui("#borderlayout").setContentURL("right","${pageScope.cuiWebRoot}/top/sys/post/PostAdjustTree.jsp?pageType=2"); 
		    setTimeout(function(){cui("#borderlayout").setContentURL("left","${pageScope.cuiWebRoot}/top/sys/post/PostAdjustTree.jsp?pageType=1")},300);
		}
		
		//鼠标移上元素时设置样式
		function setMouseOverClass(obj){
			obj.className='a';	
		}

		//鼠标移开元素时设置样式
		function setMouseOutClass(obj){
			obj.className='b';	
		}
		
		//调岗操作
		var sourcePostId ="";
		var targetPostId ="";
		//转出组织id
		var sourceOrgId = "";
		//转入组织id
		var targetOrgId = "";
		function transfer(){
			
			
			var sourceTreePage = cui("#leftPanel .bl_iframe_page")[0].contentWindow;
			var targetTreePage = cui("#rightPanel .bl_iframe_page")[0].contentWindow;
			
			
			//选择的人员岗位关联关系主键
			var userRePostIds = sourceTreePage.cui("#userGrid").getSelectedPrimaryKey();
			//选择的数据行
			var userRePostRowDatas = sourceTreePage.cui("#userGrid").getSelectedRowData();
			//选择的userIds
			var userIds="";
			for(var i=0;i<userRePostRowDatas.length;i++){
				   //获取用户的id
				   userIds+=userRePostRowDatas[i].userId+";";
			   }
			//转成数组，去除最后一个";"号
		    userIds=userIds.substring(0,userIds.length-1);	
		    userIds=userIds.split(";");
		  
			
			if(userRePostRowDatas==null || userRePostRowDatas.length==0){
				cui.alert("请选择要调岗的人员。");
				return;
			}
			//获取当前选中岗位id
			var sourceTreeNode = sourceTreePage.cui("#tree").getActiveNode();
			var targetTreeNode = targetTreePage.cui("#tree").getActiveNode();
			if(targetTreePage.fastQueryFlag==0&&(targetTreeNode==null||targetTreeNode.dNode.data.orgId==null)){//选择岗位节点的时候，orgId是有数据的，选择部门节点该字段没有数据
				cui.alert("请选择转入岗位。");
				return;
			}
			if(targetTreePage.fastQueryFlag==1&&targetPostId==null){
				cui.alert("请选择转入岗位。");
				return;
				
			}
			//转出岗位id
			 sourcePostId = sourceTreePage.curNodeId;
			//转入岗位id
			 targetPostId = targetTreePage.curNodeId;
			if(sourcePostId==targetPostId){
				cui.alert("转出岗位与转入岗位不能相同。");
				return;
			}
			
			 //转出组织id
			 sourceOrgId = sourceTreePage.curNodeOrgId;
			//转入组织id
			 targetOrgId = targetTreePage.curNodeOrgId;
			
			
			
			  dwr.TOPEngine.setAsync(false);
			   PostAction.queryRepeatUserName(userIds,targetPostId,1,function(data){
				   if(data.flag){//true 存在重名的人员
				      cui.alert("【<font color='red'>"+data.usrNames+"</font>】转入岗位已存在。");
		    		  return;
				   }else{
						//如果转入组织id和转出组织id 不一样  需要更改用户的所属组织关联关系(更新组织id)
						if(sourceOrgId!=targetOrgId){
							//增加判断同一组织下是否重名 20151217
							PostAction.queryRepeatUserName(userIds,targetOrgId,2,function(data){
								   if(data.flag){//true 存在重名的人员
								      cui.alert("【<font color='red'>"+data.usrNames+"</font>】已在转入岗位所属组织下，不能调岗。");
						    		  return;
								   }else{
										  cui.confirm("转入岗位所属组织与转出岗位的所属组织不一致，所选人员所属组织将更改为转入岗位的组织，是否继续？",{
												onYes:function(){//不同组织下的调职需要走调岗流程
													//判断用户是否有工作流提醒数据
													 dwr.TOPEngine.setAsync(false);
													    PostAction.queryUserTaskInALlProcess(userIds,function(data){
													    	 if(data.flag){//true 都没有提醒待办数据，可以调动
													    		 
													    		//调岗操作(删除原有的岗位人员关联关系，增加新的岗位人员关联关系)
																 dwr.TOPEngine.setAsync(false);
															     var vo = {userRePostIds:userRePostIds, userIdList:userIds,sourcePostId:sourcePostId,targetPostId:targetPostId,postRelationType:1,sourceOrgId:sourceOrgId,targetOrgId:targetOrgId};
																    PostAction.updateTransferPost(vo,function(flag){
																		 targetTreePage.cui('#myClickInput').setValue('');
																		 targetTreePage.keyword = '';
																		 targetTreePage.userKeyword = '';
																		
																		 if(sourceTreePage.fastQueryFlag==1){//快速查询刷新列表
																			 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
																		 }else{
																			 sourceTreePage.cui("#userGrid").loadData();
																		 }
																		 if(targetTreePage.fastQueryFlag==1){ //快速查询刷新列表
																			 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
																		 }else{
																		     targetTreePage.cui("#userGrid").loadData();
																		 }
																		 cui.message("调岗成功。","success");
														        	});
																  dwr.TOPEngine.setAsync(true);
													    		 
													    	 }else{
													    		   //存在待办数据，提醒
													    		  cui.confirm("【<font color='red'>"+data.usrNames+"</font>】存在未处理待办数据，是否继续？",{
																		onYes:function(){
																			//继续，完成 调岗操作
																			//调岗操作(删除原有的岗位人员关联关系，增加新的岗位人员关联关系)
																			 dwr.TOPEngine.setAsync(false);
																		     var vo = {userRePostIds:userRePostIds, userIdList:userIds,sourcePostId:sourcePostId,targetPostId:targetPostId,postRelationType:1,sourceOrgId:sourceOrgId,targetOrgId:targetOrgId};
																			    PostAction.updateTransferPost(vo,function(flag){
																					 targetTreePage.cui('#myClickInput').setValue('');
																					 targetTreePage.keyword = '';
																					 targetTreePage.userKeyword = '';
																					
																					 if(sourceTreePage.fastQueryFlag==1){//快速查询刷新列表
																						 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
																					 }else{
																						 sourceTreePage.cui("#userGrid").loadData();
																					 }
																					 
																					
																					 if(targetTreePage.fastQueryFlag==1){ //快速查询刷新列表
																						 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
																					 }else{
																					     targetTreePage.cui("#userGrid").loadData();
																					 }
																					
																					 cui.message("调岗成功。","success");
																			    	
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
							
							//调岗操作(删除原有的岗位人员关联关系，增加新的岗位人员关联关系)
							 dwr.TOPEngine.setAsync(false);
						     var vo = {userRePostIds:userRePostIds, userIdList:userIds,sourcePostId:sourcePostId,targetPostId:targetPostId,postRelationType:1,sourceOrgId:sourceOrgId,targetOrgId:targetOrgId};
							    PostAction.updateTransferPost(vo,function(flag){
									 targetTreePage.cui('#myClickInput').setValue('');
									 targetTreePage.keyword = '';
									 targetTreePage.userKeyword = '';
									 
									 if(sourceTreePage.fastQueryFlag==1){//快速查询刷新列表
										 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
									 }else{
										 sourceTreePage.cui("#userGrid").loadData();
									 }
									 
									 if(targetTreePage.fastQueryFlag==1){ //快速查询刷新列表
										 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
									 }else{
									     targetTreePage.cui("#userGrid").loadData();
									 }
									 cui.message("调岗成功。","success");
							    	
					        	});
							  dwr.TOPEngine.setAsync(true);
						}
					   
				   }
			   });
			  dwr.TOPEngine.setAsync(true);
			
			
		}
		
		
		
		//兼职操作
		function partTime(){
			
			var sourceTreePage = cui("#leftPanel .bl_iframe_page")[0].contentWindow;
			var targetTreePage = cui("#rightPanel .bl_iframe_page")[0].contentWindow;
			
			//选择的人员岗位关联关系主键
			var userRePostIds = sourceTreePage.cui("#userGrid").getSelectedPrimaryKey();
			//选择的数据行
			var userRePostRowDatas = sourceTreePage.cui("#userGrid").getSelectedRowData();
			//选择的userIds
			var userIds="";
			for(var i=0;i<userRePostRowDatas.length;i++){
				   //获取用户的id
				   userIds+=userRePostRowDatas[i].userId+";";
			   }
			//转成数组，去除最后一个";"号
		    userIds=userIds.substring(0,userIds.length-1);	
		    userIds=userIds.split(";");
		  
			
			if(userRePostRowDatas==null || userRePostRowDatas.length==0){
				cui.alert("请选择要兼岗的人员。");
				return;
			}
			//获取当前选中岗位id
			var sourceTreeNode = sourceTreePage.cui("#tree").getActiveNode();
			var targetTreeNode = targetTreePage.cui("#tree").getActiveNode();
			if(targetTreePage.fastQueryFlag==0&&(targetTreeNode==null||targetTreeNode.dNode.data.orgId==null)){//选择岗位节点的时候，orgId是有数据的，选择部门节点该字段没有数据
				cui.alert("请选择转入岗位。");
				return;
			}
			if(targetTreePage.fastQueryFlag==1&&targetPostId==null){
				cui.alert("请选择转入岗位。");
				return;
				
			}
			//转出岗位id
			 sourcePostId = sourceTreePage.curNodeId;
			//转入岗位id
			 targetPostId = targetTreePage.curNodeId;
			if(sourcePostId==targetPostId){
				cui.alert("转出岗位与转入岗位不能相同。");
				return;
			}
			//转出组织id
			 sourceOrgId = sourceTreePage.curNodeOrgId;
			//转入组织id
			 targetOrgId = targetTreePage.curNodeOrgId;
			//如果转入组织id和转出组织id 不一样 ,将会新增人员和组织的关联关系
			  
			if(sourceOrgId!=targetOrgId){
			  cui.confirm("转入岗位所属组织与转出岗位的所属组织不一致，所选人员将同时兼职新组织，是否继续？",{
					onYes:function(){
						//兼职操作(不删除原有的岗位人员关联关系，增加新的岗位人员关联关系)
						 dwr.TOPEngine.setAsync(false);
					     var vo = {userRePostIds:userRePostIds, userIdList:userIds,sourcePostId:sourcePostId,targetPostId:targetPostId,postRelationType:1,sourceOrgId:sourceOrgId,targetOrgId:targetOrgId};
						    PostAction.insertPartTimePost(vo,function(flag){
								 targetTreePage.cui('#myClickInput').setValue('');
								 targetTreePage.keyword = '';
								 targetTreePage.userKeyword = '';
								 
								 if(sourceTreePage.fastQueryFlag==1){//快速查询刷新列表
									 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
								 }else{
									 sourceTreePage.cui("#userGrid").loadData();
								 }
								 
								
								 if(targetTreePage.fastQueryFlag==1){ //快速查询刷新列表
									 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
								 }else{
								     targetTreePage.cui("#userGrid").loadData();
								 }
								 cui.message("兼岗成功。","success");
						    	 
				        	});
						  dwr.TOPEngine.setAsync(true);
					  }
				}
			   );	
			}else{
				
				//调岗操作(删除原有的岗位人员关联关系，增加新的岗位人员关联关系)
				 dwr.TOPEngine.setAsync(false);
			     var vo = {userRePostIds:userRePostIds, userIdList:userIds,sourcePostId:sourcePostId,targetPostId:targetPostId,postRelationType:1,sourceOrgId:sourceOrgId,targetOrgId:targetOrgId};
				    PostAction.insertPartTimePost(vo,function(flag){
						 targetTreePage.cui('#myClickInput').setValue('');
						 targetTreePage.keyword = '';
						 targetTreePage.userKeyword = '';
						 
						 if(sourceTreePage.fastQueryFlag==1){//快速查询刷新列表
							 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
						 }else{
							 sourceTreePage.cui("#userGrid").loadData();
						 }
						 
						
						 if(targetTreePage.fastQueryFlag==1){ //快速查询刷新列表
							 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
						 }else{
						     targetTreePage.cui("#userGrid").loadData();
						 }
						 cui.message("兼岗成功。","success");
				    	
		        	});
				  dwr.TOPEngine.setAsync(true);
				
				
			}
		}
		
		
		//撤职操作
		function removal(){
			
			var sourceTreePage = cui("#leftPanel .bl_iframe_page")[0].contentWindow;
			
			//选择的人员岗位关联关系主键
			var userRePostIds = sourceTreePage.cui("#userGrid").getSelectedPrimaryKey();
			//选择的数据行
			var userRePostRowDatas = sourceTreePage.cui("#userGrid").getSelectedRowData();
			//选择的userIds
			var userIds="";
			for(var i=0;i<userRePostRowDatas.length;i++){
				   //获取用户的id
				   userIds+=userRePostRowDatas[i].userId+";";
			   }
			//转成数组，去除最后一个";"号
		    userIds=userIds.substring(0,userIds.length-1);	
		    userIds=userIds.split(";");
		  
			
			if(userRePostRowDatas==null || userRePostRowDatas.length==0){
				cui.alert("请选择要撤岗的人员。");
				return;
			}
			
			//选中的岗位id
			 sourcePostId = sourceTreePage.curNodeId;
			
			//岗位所属组织id
			 sourceOrgId = sourceTreePage.curNodeOrgId;
			
			//先提示符合撤职条件的人员
			 dwr.TOPEngine.setAsync(false);
			    PostAction.partTimeFilter(userIds,function(data){
			    	  if(data.flag){//true 存在没有兼职的人员
					      cui.alert("【<font color='red'>"+data.usrNames+"</font>】无兼岗情况，不能撤岗。");
			    		  return;
					   }else{
					        //选择的人员都存在兼职情况，判断是否存在工作流待办，提醒
						   dwr.TOPEngine.setAsync(false);
						   PostAction.queryUserTaskInALlProcess(userIds,function(data){
							   if(!data.flag){//false 存在提醒待办数据，提醒
								   cui.confirm("【<font color='red'>"+data.usrNames+"</font>】存在未处理待办数据，是否继续？",{
										onYes:function(){
											//继续，完成撤职操作
											 dwr.TOPEngine.setAsync(false);
											 var vo = {userRePostIds:userRePostIds, userIdList:userIds,sourcePostId:sourcePostId,postRelationType:1,sourceOrgId:sourceOrgId};
											 PostAction.updateRemovePost(vo,function(flag){
											    
												 
												 if(sourceTreePage.fastQueryFlag==1){//快速查询刷新列表
													 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
												 }else{
													 sourceTreePage.cui("#userGrid").loadData();
												 }
												 cui.message("撤岗成功。","success");
											    	
									        	});
											  dwr.TOPEngine.setAsync(true);
										  }
									}
								   );	
							   }else{
								   //完成撤职操作
								     dwr.TOPEngine.setAsync(false);
								     var vo = {userRePostIds:userRePostIds, userIdList:userIds,sourcePostId:sourcePostId,postRelationType:1,sourceOrgId:sourceOrgId};
									 PostAction.updateRemovePost(vo,function(flag){
									    
										 
										 if(sourceTreePage.fastQueryFlag==1){//快速查询刷新列表
											 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
										 }else{
											 sourceTreePage.cui("#userGrid").loadData();
										 }
										 cui.message("撤岗成功。","success");
									    	
							        	});
									 dwr.TOPEngine.setAsync(true);
							   }
						    });
						   dwr.TOPEngine.setAsync(true)
					   }
			    	
	        	});
			 dwr.TOPEngine.setAsync(true);
		}
		
		
		//同步改变目标组织结构
		function orgStrucChainChange(value,text){
			var orgStruc = [{name:text,orgStructureId:value}];
			var postAdjustTreePage = $("#rightPanel .bl_iframe_page")[0].contentWindow;
			    postAdjustTreePage.cui("#orgStructure").setValue(value);
			    postAdjustTreePage.cui("#orgStructure").setReadonly(true);
		}
		
		
		 //点击组织的图片显示
	     function hidePicByOrgId(pageType){
	    	 if(pageType==1){
		    	 $("#boardingPost").css("display","inline");
		    	 $("#adjustOrg").css("display","inline");
		    	 $("#transfer").css("display","none");
		    	 $("#partTime").css("display","none");
		    	 $("#removal").css("display","none");
	    	 }
		}
		 
	     //点击岗位的图片显示
	     function hidePicByPostId(pageType){
	    	
	    	 if(pageType==1){
		    	 $("#boardingPost").css("display","none");
		    	 $("#adjustOrg").css("display","none");
		    	 $("#transfer").css("display","inline");
		    	 $("#partTime").css("display","inline");
		    	 $("#removal").css("display","inline");
	    	 }
		}
		 
		 
		 //任岗操作20141218
		 function boardingPost(){
			 var sourceTreePage = cui("#leftPanel .bl_iframe_page")[0].contentWindow;
			 var targetTreePage = cui("#rightPanel .bl_iframe_page")[0].contentWindow;
			 
			//选择的人员岗位关联关系主键
		     var userRePostIds = sourceTreePage.cui("#userGrid").getSelectedPrimaryKey();
		   //选择的数据行
		     var userRePostRowDatas = sourceTreePage.cui("#userGrid").getSelectedRowData();
		   //选择的userIds
				var userIds="";
				for(var i=0;i<userRePostRowDatas.length;i++){
					   //获取用户的id
					   userIds+=userRePostRowDatas[i].userId+";";
				   }
				//转成数组，去除最后一个";"号
			    userIds=userIds.substring(0,userIds.length-1);	
			    userIds=userIds.split(";");
			  
				
				if(userRePostRowDatas==null || userRePostRowDatas.length==0){
					cui.alert("请选择要任岗的人员。");
					return;
				}
				
				//选择岗位节点的时候，获取转入岗位id
				if(targetTreePage.isOrg==false){
					targetPostId = targetTreePage.curNodeId
				}
				//选择组织的时候，targetPostId置空
				if(targetTreePage.isOrg==true){
					targetPostId ="";
				}
				
				if((targetTreePage.isOrg)&&(targetPostId==null || targetPostId.length==0)){
					cui.alert("请选择任岗的岗位。");
					return;
				}
				
				 //源组织id
				 sourceOrgId = sourceTreePage.curNodeOrgId;
				//转入组织id
				 targetOrgId = targetTreePage.curNodeOrgId;
				
				  dwr.TOPEngine.setAsync(false);
				   PostAction.queryRepeatUserName(userIds,targetPostId,1,function(data){
					   if(data.flag){//true 存在重名的人员
					      cui.alert("【<font color='red'>"+data.usrNames+"</font>】转入岗位已存在。");
			    		  return;
					   }else{
						   
						    
							//如果转入组织id和转出组织id 不一样  需要更改用户的所属组织关联关系(更新组织id)
							if(sourceOrgId!=targetOrgId){
								//增加判断同一组织下是否重名 20151217
								PostAction.queryRepeatUserName(userIds,targetOrgId,2,function(data){
									   if(data.flag){//true 存在重名的人员
									      cui.alert("【<font color='red'>"+data.usrNames+"</font>】已在转入岗位所属组织下，不能任岗。");
							    		  return;
									   }else{	
								
											  cui.confirm("人员所属组织与任岗的所属组织不一致，所选人员所属组织将更改为任岗岗位的组织，是否继续？",{ 
													onYes:function(){
														    		 
														    		//任岗操作(增加新的岗位人员关联关系)
																	 dwr.TOPEngine.setAsync(false);
																     var vo = {userRePostIds:userRePostIds, userIdList:userIds,targetPostId:targetPostId,postRelationType:1,sourceOrgId:sourceOrgId,targetOrgId:targetOrgId};
																	    PostAction.updateBoardingPost(vo,function(flag){
																			 targetTreePage.cui('#myClickInput').setValue('');
																			 targetTreePage.keyword = '';
																			 targetTreePage.userKeyword = '';
																			
																			 if(sourceTreePage.fastQueryFlag==1){//快速查询刷新列表
																				 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
																			 }else{
																				 sourceTreePage.cui("#userGrid").loadData();
																			 }
																			 
																			
																			 if(targetTreePage.fastQueryFlag==1){ //快速查询刷新列表
																				 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
																			 }else{
																			     targetTreePage.cui("#userGrid").loadData();
																			 }
																			 cui.message("任岗成功。","success");
																	    	
															        	});
																	  dwr.TOPEngine.setAsync(true);
													  }
												  }
											   );	
									      }
								});		
							  
							}else{
								
								//任岗操作(增加新的岗位人员关联关系)
								 dwr.TOPEngine.setAsync(false);
							     var vo = {userRePostIds:userRePostIds, userIdList:userIds,targetPostId:targetPostId,postRelationType:1,sourceOrgId:sourceOrgId,targetOrgId:targetOrgId};
								    PostAction.updateBoardingPost(vo,function(flag){
										 targetTreePage.cui('#myClickInput').setValue('');
										 targetTreePage.keyword = '';
										 targetTreePage.userKeyword = '';
										 
										 if(sourceTreePage.fastQueryFlag==1){//快速查询刷新列表
											 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
										 }else{
											 sourceTreePage.cui("#userGrid").loadData();
										 }
										 
										 if(targetTreePage.fastQueryFlag==1){ //快速查询刷新列表
											 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
										 }else{
										     targetTreePage.cui("#userGrid").loadData();
										 }
										 cui.message("任岗成功。","success");
								    	
						        	});
								  dwr.TOPEngine.setAsync(true);

							  }
						   
					   }
				   });
				  dwr.TOPEngine.setAsync(true);
	       }		 
		 
		 
		 //调组织操作
		 function adjustOrg(){
				var sourceTreePage = cui("#leftPanel .bl_iframe_page")[0].contentWindow;
				var targetTreePage = cui("#rightPanel .bl_iframe_page")[0].contentWindow;
				//选择的人员岗位关联关系主键
				var userRePostIds = sourceTreePage.cui("#userGrid").getSelectedPrimaryKey();
				//选择的数据行
				var userRePostRowDatas = sourceTreePage.cui("#userGrid").getSelectedRowData();
				if(userRePostRowDatas==null || userRePostRowDatas.length==0){
					cui.alert("请选择要调组织的人员。");
					return;
				}
				//目标激活节点
				var targetTreeNode = targetTreePage.cui("#tree").getActiveNode();
				if(targetTreePage.fastQueryFlag==0&&(targetTreeNode==null||targetTreeNode.dNode.data.orgId!=null)){//选择岗位节点的时候，orgId是有数据的，选择部门节点该字段没有数据
					cui.alert("请选择目标组织。");
					return;
				}
				//转出组织id
				 sourceOrgId = sourceTreePage.curNodeOrgId;
				//转入组织id
				 targetOrgId = targetTreePage.curNodeOrgId;
				//如果转入组织id和转出组织id 一样 ,不能调动
				if(sourceOrgId==targetOrgId){
					cui.alert("转出组织与转入组织不能相同。");
					return;
				}
				
				//选择的userIds
				var userIds="";
				for(var i=0;i<userRePostRowDatas.length;i++){
					   //获取用户的id
					   userIds+=userRePostRowDatas[i].userId+";";
				   }
				//转成数组，去除最后一个";"号
			    userIds=userIds.substring(0,userIds.length-1);	
			    userIds=userIds.split(";");
			    //需要判断目标组织是否有重复的employeeId的人员
			       	  dwr.TOPEngine.setAsync(false);
					   PostAction.queryRepeatUserName(userIds,targetOrgId,2,function(data){
						   if(data.flag){//true 存在重名的人员
						      cui.alert("【<font color='red'>"+data.usrNames+"</font>】目标组织已存在。");
				    		  return;
						   }else{   //完成调部门操作,更新部门Id信息即可，未任岗无岗位权限信息
							   PostAction.updateOrgIdInUserIds(targetOrgId,userIds,function(data){
									 targetTreePage.cui('#myClickInput').setValue('');
									 targetTreePage.keyword = '';
									 targetTreePage.userKeyword = '';
									 
									 if(sourceTreePage.fastQueryFlag==1){//快速查询刷新列表
										 sourceTreePage.selectMultiNavClick(sourcePostId,'',sourceOrgId);
									 }else{
										 sourceTreePage.cui("#userGrid").loadData();
									 }
									 
									 if(targetTreePage.fastQueryFlag==1){ //快速查询刷新列表
										 targetTreePage.selectMultiNavClick(targetPostId,'',targetOrgId);
									 }else{
									     targetTreePage.cui("#userGrid").loadData();
									 }
									 
								   cui.message("调组织成功。","success");
							   });
							   
						   }
					   });
					  dwr.TOPEngine.setAsync(true);
		 }
		
	</script>
</head>
<body>
        
 <div uitype="Borderlayout" id="borderlayout" is_root="true" gap="0px 0px 0px 0px" fixed="{'bottom':true,'left':false,'center':true,'right':false}">
	<div id="leftPanel" position="left" gap="0px 0px 0px 0px" is_header="true" header_content="<div align='center'><b style='color: #326EE9;font-size:15px'>转出岗位</b></div>" min_size="50" collapsable="false"></div>
	<div id="centerPanel" position="center" gap="0px 0px 0px 0px" collapsable="false" width="70">
		<div align="center" style="position:relative;top:50%;">
			<img src="${pageScope.cuiWebRoot}/top/sys/images/arrow.png" Style="width: 64px;height: 64px;" />
		</div>
	</div>
	<div  id="rightPanel"  position="right" gap="0px 0px 0px 0px" is_header="true" header_content="<div align='center'><b style='color: #326EE9;font-size:15px'>转入岗位</b></div>" collapsable="false"></div>
	<div id="bottomPanel"  position="bottom" height="65" gap="0px 0px 0px 0px" collapsable="false">
		<div align="center">
			<div  id="boardingPost" style="display:none"><img class="b" title="任岗" src="${pageScope.cuiWebRoot}/top/sys/images/boardingPost.png" style="cursor: pointer" onclick="boardingPost()" onmouseover="setMouseOverClass(this)" onmouseout="setMouseOutClass(this)" /></div>
			<div  id="adjustOrg" style="display:none"><img class="b" title="调组织" src="${pageScope.cuiWebRoot}/top/sys/images/adjustOrg.png" style="cursor: pointer" onclick="adjustOrg()" onmouseover="setMouseOverClass(this)" onmouseout="setMouseOutClass(this)" /></div>
			<div  id="transfer" style="display:none"><img class="b" title="调岗" src="${pageScope.cuiWebRoot}/top/sys/images/transfer.png" style="cursor: pointer" onclick="transfer()" onmouseover="setMouseOverClass(this)" onmouseout="setMouseOutClass(this)" /></div>
			<div  id="partTime" style="display:none"><img class="b" title="兼岗" src="${pageScope.cuiWebRoot}/top/sys/images/partTime.png" style="cursor: pointer" onclick="partTime()" onmouseover="setMouseOverClass(this)" onmouseout="setMouseOutClass(this)" /></div>
		    <div  id="removal" style="display:none"><img class="b" title="撤岗" src="${pageScope.cuiWebRoot}/top/sys/images/removal.png" style="cursor: pointer" onclick="removal()" onmouseover="setMouseOverClass(this)" onmouseout="setMouseOutClass(this)" /></div>
		 </div>
	</div>
</div>
</body>
</html>