<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
    <title>岗位信息</title>
    <meta http-equiv="X-UA-Compatible" content="edge" />
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostAction.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostOtherAction.js"></script>
</head>
<body>

 <div uitype="borderlayout" id="body"  is_root="true" on_sizechange="resizeTab">
	 <div uitype="bpanel" id="topMain"  position="top" gap="0px 0px 0px 0px" height="260"  collapsable="true"  show_expand_icon="true" >
		<div class="top_header_wrap">
			<div class="thw_title">
				<div class="divTitleFont">岗位信息</div>
			</div>
			<div class="thw_operate" style="padding-right: 5px;">
			<% if(!isHideSystemBtn){ %>
				<top:verifyAccess pageCode="TopPostAdmin" operateCode="updatePost">
					<span uiType="Button" id='insertPostButton' label="新增岗位" on_click="insertShow" ></span>
				    <span uiType="Button" id="editPostButton" label="编辑" on_click="editShow" ></span>
				    <span uiType="Button" id="deletePostButton" label="删除" on_click="deletePost" ></span>
			    </top:verifyAccess>
			    <% } %>
			     <span uiType="Button" id="returnPostButton" label="返回" on_click="returnPost" ></span>
				<span uiType="Button" id="saveButton" label="保存" on_click="savePost" ></span>
                <span uiType="Button" id="saveAndGoButton" label="保存继续" on_click="savePostAndGo" ></span>
                <span uiType="Button" id="closeButton" label="取消" on_click="closeSelf" ></span>
			</div>
			
		</div>
		<div id="content" class="top_content_wrap cui_ext_textmode" >
			<table class="form_table" style="table-layout:fixed;">
				<colgroup>
					<col width="13%"/>
			     	<col width="37%"/>
			     	<col width="13%"/>
			     	<col width="37%"/>
				</colgroup>
					 
				 <tr>         
					<td class="td_label" ><span class="top_required">*</span>岗位名称：</td>
					<td ><span uiType="input"    id="postName" name="postName" databind="data.postName" maxlength="150" width="90%" 
					validate="[{'type':'required', 'rule':{'m': '岗位名称不能为空。'}},{'type':'custom','rule':{'against':'isNameContainSpecial','m':'岗位名称只能为中英文、数字或（）() 、 _ -。'}},{'type':'custom','rule':{'against':'isExsitPostName','m':'同一组织下该岗位名称已存在。'}}]"></span></td>
				</tr>	
				 <tr>         
			        <td class="td_label" >岗位编码：</td>
			        <td ><span uiType="input"    id="postCode" name="postCode" databind="data.postCode" maxlength="50" width="90%" validate="[{'type':'custom','rule':{'against':'isCodeContainSpecial','m':'岗位编码只能为英文、数字或（）()  _ -。'}},{'type':'custom','rule':{'against':'isExsitPostCode','m':'该岗位编码已存在。'}}]"></span></td>
		            <td class="td_label" >岗位归类：</td>
			        <td >
			          <span uitype="singlePullDown" id="postType" name="postType"   auto_complete="true"  databind="data.postType" datasource="initPostTypeData" empty_text="" width="90%"	editable="true"   label_field="postTypeName" value_field="postTypeId" ></span>
			        </td>        
		        </tr>	
		        <tr>         
					<td class="td_label" >岗位系数：</td>
					<td ><span uiType="input"    id="postParam" name="postParam" databind="data.postParam" maxlength="8" width="90%"   mask="Dec"></span></td>
					<td class="td_label" >岗位序列：</td>
					<td ><span uiType="input"    id="postSequence" name="postSequence" databind="data.postSequence" maxlength="80" width="90%" ></span></td>
				</tr>
				 <tr>         
		            <td class="td_label" >岗位类别：</td>
			        <td >
			           <span uitype="singlePullDown" id="postClassify" name="postClassify" databind="data.postClassify" datasource="initPostClassifyData" empty_text="" width="90%"	editable="false" label_field="postClassifyName" value_field="postClassifyId" ></span>
			        </td>        
		           <td class="td_label" >所属组织：</td>
		           <td ><span uiType="input"     id="orgName" name="orgName" databind="data.orgName" width="90%"  maxlength="100" width="90%"  readonly=true></span></td>      
		        </tr>
		        
		        <tr>
		           <td class="td_label" >所属标准岗位：</td>
			        <td >
			           <span uitype="singlePullDown" id="standardPostCode" name="standardPostCode"   auto_complete="true"   databind="data.standardPostCode"   datasource="initStandardPostCodeData"  empty_text=""  width="90%"	editable="true"   label_field="otherPostName"  value_field="otherPostId" ></span>
			        </td>  
				    <td class="td_label" valign="top">描述：</td>
					<td >
					<span uiType="Textarea"    id="note" name="note" width="96%" databind="data.note"  height="50px" maxlength="200"  ></span></td>
				</tr>
				       
			</table>
		</div>
	    <div id="divFontCenter"  class="divFontCenter">请点击左侧岗位树选择岗位</div>
	</div>
	<div uitype="bpanel"  id="centerMain" gap="0px 0px 0px 0px" position="center" height="100%">
	    	<div uitype="Tab" closeable="false" tabs="tabs" id="userAndRoleTab" fill_height="true" ></div>
	</div>
 </div>
      
        <script type="text/javascript">


        var postId = "<c:out value='${param.postId}'/>";//岗位ID
		var postName = decodeURIComponent(decodeURIComponent("<c:out value='${param.postName}'/>"));//岗位名称 
		var  orgId= "<c:out value='${param.orgId}'/>";//组织id
		var orgName = decodeURIComponent(decodeURIComponent("<c:out value='${param.orgName}'/>"));//组织名称 
		var rootOrgId = "<c:out value='${param.rootOrgId}'/>";//根组织id 
		var orgStructureId = "<c:out value='${param.orgStructureId}'/>"; //组织结构id
	    var pageNo="<c:out value='${param.pageNo}'/>"; 
	    var pageSize="<c:out value='${param.pageSize}'/>"; 
	    var operate="<c:out value='${param.operate}'/>"; 
	    
	    var postRelationType=1   //1为行政 2为非行政
	    var currentOrgId="<c:out value='${param.orgId}'/>";//当前所选择的组织id，返回按钮使用到
	    
		//设置tab的属性
        var tabs=[
                  {'title':'用户列表',url:"UserList.jsp"},
                  {'title':'角色列表',url:"RoleListForPost.jsp"},
                  {'title':'工作流节点信息',url:"WorkFlowListForPost.jsp",tab_width:"90px"}
                  ]; 
		var data = {};
		//组织下级新增=1  岗位同级新增岗位=2 
		var operationType = 0;
	
		
		window.onload = function(){
			      
			   if(postId){//编辑
			    	  readShow();
			    	  dwr.TOPEngine.setAsync(false);
			    		PostAction.readPost(postId,function(postData){
				    		//填充数据
			    			data = postData;
				    		//以数据库查询出来的为准,解决级联查询的问题
			    		   orgName=postData.orgName;
			    		   orgId=postData.orgId;
				    		
			    			if(postData.postParam==0){ // 为0时不显示值
			    				postData.postParam="";
			    			}
				          

			    		
						});
			    	 dwr.TOPEngine.setAsync(true);
			    	 comtop.UI.scan();
			    	//设置Tab页面链接
			    	 pageListUrl(postId);
			      }else{
			    	 if(orgId==""||orgId==null){//组织id为空的情况，新增按钮不显示
			    		 cui('#insertPostButton').hide();
			    	 }
			    	 initShow(); 
			    	 comtop.UI.scan();
			    	 //点击组织进来后现在新增页面 20150119 显示岗位列表修改 
			    	 insertShow();
			      }
			 
					
		}
		
		
		//初始化岗位归类下拉框
	 	function initPostTypeData(obj){
	 		dwr.TOPEngine.setAsync(false);
	 		PostAction.getPostTypeInfo(function(resultData){
					obj.setDatasource(jQuery.parseJSON(resultData));
				});
	 		dwr.TOPEngine.setAsync(true);
	 	}
	 	
	 	
		//初始化岗位类别下拉框
	 	function initPostClassifyData(obj){
			
	 		dwr.TOPEngine.setAsync(false);
	 		PostAction.getPostClassifyInfo(function(resultData){
					obj.setDatasource(jQuery.parseJSON(resultData));
				});
	 		dwr.TOPEngine.setAsync(true);
	 	}
		
	 	
	 	
		//初始化标准岗位下拉框-20150305
	 	function initStandardPostCodeData(obj){
			
	 		dwr.TOPEngine.setAsync(false);
	 		PostOtherAction.getStandardPostInfo(function(resultData){
					obj.setDatasource(jQuery.parseJSON(resultData));
				});
	 		dwr.TOPEngine.setAsync(true);
	 	}
	 	
             
	    //初始化处理
	   function initShow(){
		     $("#content").attr('style', 'display:none');
		     cui('#saveButton').hide();
		     cui('#saveAndGoButton').hide();
		     cui('#closeButton').hide();
		     cui('#editPostButton').hide();
		     cui('#deletePostButton').hide();
		     cui('#returnPostButton').hide();
		 	 cui('#centerMain').hide();
		     data.orgName=orgName;
	    }
	    
	   
	   //进入查看岗位界面
	   function readShow(){
		     $("#divFontCenter").attr('style', 'display:none');
		     //全局只读
		     comtop.UI.scan.readonly=true;
		     $("#content").attr('style', 'display:');
		     cui('#editPostButton').show();
		     cui('#deletePostButton').show();
		     cui('#saveButton').hide();
		     cui('#saveAndGoButton').hide();
		     cui('#closeButton').hide();
		     cui('#insertPostButton').show();
		     //必填项隐藏
	         $('.top_required').hide();
	     	if(operate==null||operate==""){ //operate为空，点击左边树岗位节点进入，返回按钮需隐藏
				  cui('#returnPostButton').hide();
			}else if(operate==1){//点击列表编辑进入
				  cui('#returnPostButton').show();
			}
		    
	    }
	   
	   //进入编辑岗位界面
	   function editShow(){
		 //移除只读样式并取消只读
			 $('.cui_ext_textmode').attr('cui_ext_textmode02');
			 comtop.UI.scan.setReadonly(false, $('#content'))
			 cui('#orgName').setReadonly(true);
			 cui('#saveButton').show();
		     cui('#closeButton').show();
		     cui('#saveAndGoButton').hide();
		     cui('#editPostButton').hide();
		     cui('#deletePostButton').hide();
		     cui('#returnPostButton').hide();
		     cui('#insertPostButton').hide();
		     //必填项显示
	         $('.top_required').show();
		    
	    }
	   
	    
	    
	   //进入新增岗位界面
	   var isInsertByPost=0; //1点击岗位时新增的 标记 
	   function insertShow(){
		   if(postId){//点击岗位时新增操作
			   editShow();
			   cui('#centerMain').hide();
			   cui('#saveAndGoButton').show();
			   //清空数据
			   cui(data).databind().setEmpty();  
			   isInsertByPost=1;
			   cui('#orgName').setValue(orgName);
			   
		   }else{
			 $("#content").attr('style', 'display:');
		     $("#divFontCenter").attr('style', 'display:none');
		     cui('#saveButton').show();
		     cui('#saveAndGoButton').show();
		     cui('#closeButton').show();
		     cui('#insertPostButton').hide();
			 cui('#orgName').setReadonly(true);

		   }
		    
		    
	    }
	   
	   
	   //取消按钮操作
	   function closeSelf(){
		   if(postId){//编辑和点击岗位新增时的取消
				 $('.cui_ext_textmode').attr('cui_ext_textmode');
				 comtop.UI.scan.setReadonly(true, $('#content'))
				 cui('#saveButton').hide();
			     cui('#saveAndGoButton').hide();
			     cui('#closeButton').hide();
			     cui('#insertPostButton').show();
			     cui('#editPostButton').show();
			     cui('#deletePostButton').show();
			
			     	if(operate==null||operate==""){ //operate为空，点击左边树岗位节点进入，返回按钮需隐藏
						  cui('#returnPostButton').hide();
					}else if(operate==1){//点击列表编辑进入
						  cui('#returnPostButton').show();
					}
			     
				 cui('#centerMain').show();
			     dwr.TOPEngine.setAsync(false);
		    		PostAction.readPost(postId,function(postData){
			    		//填充数据
		    	        cui(data).databind().setValue(postData);
					});
		    	 dwr.TOPEngine.setAsync(true);
		    	 isInsertByPost=0;
		    	//必填项隐藏
		        $('.top_required').hide();
		    
			     
		   }else{//点击组织下新增的取消
			    //跳转到岗位列表页面
			   window.parent.cui("#postBorderlayout").setContentURL("center","PostList.jsp?orgId="+orgId+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId+"&orgName="+ encodeURIComponent(encodeURIComponent(orgName))); 
		   }
		   cui('#orgName').setValue(orgName);
	    }
	   
		  /*
		* 判断名称是否包含特殊字符
		*/
		function isNameContainSpecial(data){
			  //可输入 （）() 、 中英文 数字 _-
			var reg = new RegExp("^[\uff08 \uff09 \u0028 \u0029 \u3001 \u4E00-\u9FA5A-Za-z0-9_-]+$");
			return (reg.test(data));
		}
		  
		/**
		* 同一组织下不能重名
		*/
		function isExsitPostName(data){ 
			
			var flag = true;
			if(data != ""){
				dwr.TOPEngine.setAsync(false);
				PostAction.isExsitPostName(data,postId,orgId,function(data){
					if(data){
						flag = false;
					}else{
						flag = true;
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
			return flag;
		} 
		
		  /*
		* 判断名称是否包含特殊字符
		*/
		function isCodeContainSpecial(data){
			if(data){  
				var reg = new RegExp("^[\uff08 \uff09 \u0028 \u0029  A-Za-z0-9_-]+$");
				return (reg.test(data));
			}
			return true;
		}
		  
		/**
		*编码不能重名
		*/
		function isExsitPostCode(data){ 
			var flag = true;
			if(data){
				dwr.TOPEngine.setAsync(false);
				PostAction.isExsitPostCode(data,postId,function(data){
					if(data){
						flag = false;
					}else{
						flag = true;
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
			return flag;
		} 
		
		// 检验岗位系数，不能为0.00
		function validateParam(param){
			if(param){	
				if(param=='0.00'){
					return false;
				}else{
					return true;
				}
			}
			return true;
		}
		
		// 检验岗位系数，只能输入数字
		function validateNum(data){
			if(data){	
				var reg = new RegExp("^[0-9\.]+$");
				return (reg.test(data));
			}
			return true;
		}
		
		
		//保存岗位信息
		function savePost(){
			
			//验证表单
	         var map = window.validater.validAllElement();
	         var inValid = map[0];//放置错误信息
	         var valid = map[1]; //放置成功信
	         if (inValid.length > 0) {
	             var str = "";
	             for (var i = 0; i < inValid.length; i++) {
	 					str +=  inValid[i].message + "<br />";
	 				}
	 			//错误信息多了，定位到第一个错误
	 			var top = $('#' + map[0][0].id).offset().top;
	 			$(document).scrollTop(top-10);
	         }else {
	        
					 //获取表单信息
		        	var vo = cui(data).databind().getValue();
		        	    vo.orgId = orgId;  
			            if(postId&&isInsertByPost==0){//编辑
					           dwr.TOPEngine.setAsync(false);
					           PostAction.updatePost(vo,function(flag){
						            //刷新树
						           window.parent.refreshEditTree(postId,orgId,orgName,2);
					        	   window.parent.cui.message('修改岗位成功。','success');
					        	   pageListUrl(postId);
					        	   closeSelf();
					        	   
						          
					    		});
					    	   dwr.TOPEngine.setAsync(true);
			                   
		                }else{
		                	
		                      //新增
				           dwr.TOPEngine.setAsync(false);
				           PostAction.insertPost(vo,function(postId){
					            //刷新树
					           window.parent.refreshEditTree(postId,orgId,orgName,1);
				        	   window.parent.cui.message('新增岗位成功。','success');
				        	   pageListUrl(postId);
					          
				    		});
				    	   dwr.TOPEngine.setAsync(true);
		                     }
	             }	    		
		}
		
		
		//保存岗位信并继续新增
		function savePostAndGo(){
			
			//验证表单
	         var map = window.validater.validAllElement();
	         var inValid = map[0];//放置错误信息
	         var valid = map[1]; //放置成功信
	         if (inValid.length > 0) {
	             var str = "";
	             for (var i = 0; i < inValid.length; i++) {
	 					str +=  inValid[i].message + "<br />";
	 				}
	 			//错误信息多了，定位到第一个错误
	 			var top = $('#' + map[0][0].id).offset().top;
	 			$(document).scrollTop(top-10);
	         }else {
	        
					 //获取表单信息
		        	var vo = cui(data).databind().getValue();
		        	    vo.orgId = orgId;  
			          
		                	
		                      //新增
				           dwr.TOPEngine.setAsync(false);
				           PostAction.insertPost(vo,function(postId){
					            //刷新树
					           window.parent.refreshEditTree(postId,orgId,orgName,4);
				        	   window.parent.cui.message('新增岗位成功。','success');
				        	   pageListUrl(postId);
				        	 //清空数据
							   cui(data).databind().setEmpty(); 
							   cui('#orgName').setValue(orgName);
					          
				    		});
				    	   dwr.TOPEngine.setAsync(true);
		                   
	             }	    		
		}
		
		
		
		//删除岗位操作
		function deletePost(){
			
			  dwr.TOPEngine.setAsync(false);
	    	   PostAction.getPostDeleteFlag(postId,postRelationType,1,function(result){
	    			
	    			if(!result){
	    				cui.confirm("【<font color='red'>"+postName+"</font>】包含人员或角色，确定删除吗?", {
	    			        onYes: function(){
	    			        dwr.TOPEngine.setAsync(false);
	  				           PostAction.deletePost(postId,function(flag){
	  					            //刷新树
	  					           window.parent.refreshEditTree(postId,orgId,orgName,3);
	  				        	   window.parent.cui.message('删除岗位成功。','success');
	  				        	     $("#content").attr('style', 'display:none');
	  					  		     cui('#saveButton').hide();
	  					  		     cui('#saveAndGoButton').hide();
	  					  		     cui('#closeButton').hide();
	  					  		     cui('#insertPostButton').show();
	  					  		     $("#divFontCenter").attr('style', 'display:');
	  					  		      cui('#centerMain').hide();
	  					  		      isInsertByPost=0;
	  					          
	  				    		});
	  				    	   dwr.TOPEngine.setAsync(true);
	    			        }
	    		    	});
	    				
	    			}else{
	    				cui.confirm("确定要删除该岗位吗？", {
	    			        onYes: function(){
	    			        dwr.TOPEngine.setAsync(false);
	  				           PostAction.deletePost(postId,function(flag){
	  					            //刷新树
	  					           window.parent.refreshEditTree(postId,orgId,orgName,3);
	  				        	   window.parent.cui.message('删除岗位成功。','success');
	  				        	     $("#content").attr('style', 'display:none');
	  					  		     cui('#saveButton').hide();
	  					  		     cui('#saveAndGoButton').hide();
	  					  		     cui('#closeButton').hide();
	  					  		     cui('#insertPostButton').show();
	  					  		     $("#divFontCenter").attr('style', 'display:');
	  					  		      cui('#centerMain').hide();
	  					  		      isInsertByPost=0;
	  					          
	  				    		});
	  				    	   dwr.TOPEngine.setAsync(true);
	    			        }
	    		    	});
	    			}
	    		});
	    	 dwr.TOPEngine.setAsync(true);
		}    
	    
		//设置跳转页面操作链接
		function pageListUrl(postId) {
			 cui("#userAndRoleTab").setTab(0,"url",'${pageScope.cuiWebRoot}/top/sys/post/UserList.jsp?postId='+postId+'&orgId='+orgId+"&rootOrgId="+rootOrgId+'&postRelationType='+postRelationType+'&orgStructureId='+orgStructureId);
    	     cui("#userAndRoleTab").setTab(1,"url",'${pageScope.cuiWebRoot}/top/sys/post/RoleListForPost.jsp?postId='+postId+'&orgId='+orgId+"&rootOrgId="+rootOrgId+'&postRelationType='+postRelationType);
    	     cui("#userAndRoleTab").setTab(2,"url",'${pageScope.cuiWebRoot}/top/sys/post/WorkFlowListForPost.jsp?postId='+postId+'&orgId='+orgId+"&postName="+encodeURIComponent(encodeURIComponent(postName))+"&orgName="+encodeURIComponent(encodeURIComponent(orgName)));
		}
         
		
		function resizeTab(){
			
			var h =$("#centerMain").height();		
			cui("#userAndRoleTab").resize(h);
			
		}
		
		//返回岗位列表
		function returnPost(){
			 window.parent.refreshEditTree(postId,currentOrgId,orgName,5);
			window.parent.cui("#postBorderlayout").setContentURL("center","PostList.jsp?orgId="+currentOrgId+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId+"&orgName="+ encodeURIComponent(encodeURIComponent(orgName))+'&pageNo='+pageNo+'&pageSize='+pageSize+'&operate='+operate); 
		}
		
		
        </script>
</body>
</html>