<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
    <title>非行政类岗位信息</title>
    <meta http-equiv="X-UA-Compatible" content="edge" />
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostOtherAction.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostAction.js"></script>
</head>
<body>

 <div uitype="borderlayout" id="body"  is_root="true" on_sizechange="resizeTab">
	 <div uitype="bpanel" id="topMain"  position="top" gap="0px 0px 0px 0px" height=300 collapsable="true"  show_expand_icon="true">
		<div class="top_header_wrap">
			<div class="thw_title">
				<div class="divTitleFont">非行政类岗位信息</div>
			</div>
			<div class="thw_operate" style="padding-right: 5px;">
				<% if(!isHideSystemBtn){ %>
				<top:verifyAccess pageCode="TopOtherPostAdmin" operateCode="updateOtherPost">
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
					<td ><span uiType="input"    id="otherPostName" name="otherPostName" databind="data.otherPostName" maxlength="50" width="90%" 
					validate="[{'type':'required', 'rule':{'m': '岗位名称不能为空。'}},{'type':'custom','rule':{'against':'isNameContainSpecial','m':'岗位名称只能为中英文、数字或（）() 、 _ -。'}},{'type':'custom','rule':{'against':'isExsitPostName','m':'同一分类下该岗位名称已存在。'}}]"]"></span></td>
				</tr>	
				 <tr>         
			        <td class="td_label" >岗位编码：</td>
			        <td ><span uiType="input"    id="otherPostCode" name="otherPostCode" databind="data.otherPostCode" maxlength="50" width="90%" validate="[{'type':'custom','rule':{'against':'isCodeContainSpecial','m':'岗位编码只能为英文、数字或下划线。'}},{'type':'custom','rule':{'against':'isExsitPostCode','m':'该岗位编码已存在。'}}]"></span></td>
				 </tr>
				 
				 <tr>
				    <td class="td_label"> <span class="top_required">*</span>是否是标准岗位：  </td>
						<td>
							<span uitype="RadioGroup" name="standardPostFlag" id="standardPostFlagId" value="1"  databind="data.otherPostFlag" validate="请选择岗位类型。" on_change="setDisplay"> 
								<input type="radio" name="otherPostFlag" value="2"/>是
                				<input type="radio" name="otherPostFlag" value="1"/>否
							</span> 
			         </td>
				 </tr>
				 
				 <tr>         
		           <td class="td_label" >所属分类：</td>
		           <td ><span uiType="input"     id="parentName" name="parentName" databind="data.parentName" width="90%"  maxlength="100" width="90%"  readonly=true></span></td>      
		        </tr>
		        

		        
		         <tr id="otherPostTypePullDown" style="display:none;">         
		            <td class="td_label" >岗位归类：</td>
			        <td >
			          <span uitype="singlePullDown" id="otherPostType" name="otherPostType" auto_complete="true"  databind="data.otherPostType" datasource="initPostTypeData" empty_text="" width="90%"	editable="true" label_field="postTypeName" value_field="postTypeId" ></span>
			        </td>        
		        </tr>
		        
		        <tr>
				    <td class="td_label" valign="top">描述：</td>
					<td  colspan="3">
					<span uiType="Textarea"    id="note" name="note" width="96%" databind="data.note"  height="50px" maxlength="200"  ></span></td>
				</tr>
				       
			</table>
		</div>
	    <div id="divFontCenter"  class="divFontCenter">请点击左侧分类树添加岗位</div>
	</div>
	<div uitype="bpanel"  id="centerMain" gap="0px 0px 0px 0px" position="center" height="100%">
	    	<div uitype="Tab" closeable="false" tabs="tabs" id="userAndRoleTab" fill_height="true" ></div>
	</div>
 </div>
      
        <script type="text/javascript">


        var classifyId = "<c:out value='${param.classifyId}'/>";//节点ID
       
		var classifyName = decodeURIComponent(decodeURIComponent( "<c:out value='${param.classifyName}'/>"));//节点名称
		var parentName = decodeURIComponent(decodeURIComponent( "<c:out value='${param.parentName}'/>"));//父节点名称 
		var parentId = "<c:out value='${param.parentId}'/>";//父节点id
		var postFlag = "<c:out value='${param.postFlag}'/>";//岗位节点标记  1为分类 2为其他岗位节点,3为标准岗位标识
        var postId=postFlag!=1?classifyId:"";  //岗位id 如果postFlag=2  则classifyId为岗位id		
        var postName=postFlag!=1?classifyName:"";  //岗位名称
        var classifyCurrName=postFlag==1?classifyName:parentName;  //分类名称
         
        var otherPostFlag=1; //岗位节点标记  1为其他，2为标准岗位
        var currentClassifyId="<c:out value='${param.parentId}'/>";//当前所选择的分类id，返回按钮使用到
          
       
   
		
		var data = {};
		//分类下级新增=1  岗位同级新增岗位=2 
		var  operationType = 0;
	    var postRelationType=2   //1为行政 2为非行政
	    var pageNo="<c:out value='${param.pageNo}'/>"; 
		var pageSize="<c:out value='${param.pageSize}'/>"; 
		var operate="<c:out value='${param.operate}'/>"; 
		  
		  
		  
		  var rootOrgId = "<c:out value='${param.rootOrgId}'/>";//根组织id 
		  
		  var tabs=[];
		  
		  function initSetDisplay(otherPostFlag){
			
			 if(otherPostFlag==2){ //如果是标准岗位标识，otherPostFlag设置为2
				 cui('#otherPostTypePullDown').show();
				//设置tab的属性
			       tabs=[{'title':'行政岗位列表',url:"PostReList.jsp",'tab_width':'80px;'},{'title':'角色列表',url:"RoleListForPost.jsp"}]; 
        	 } else{
        		 cui('#otherPostTypePullDown').hide();
        		//设置tab的属性
        	       tabs=[{'title':'用户列表',url:"UserList.jsp"},{'title':'角色列表',url:"RoleListForPost.jsp"}]; 
        	 }
		  }
		  
		  
	 
		window.onload = function(){
			   
	 
			   if(postId){//编辑岗位
			    	  readShow();
			    	  dwr.TOPEngine.setAsync(false);
			    	  PostOtherAction.readPostOther(postId,function(postData){
				    		//填充数据
			    			data = postData;
			    			//以数据库查询出来的为准,解决级联查询的问题
				    		 parentName=postData.classifyName;
				    		 parentId=postData.classifyId;
				    		 data.parentName=postData.classifyName;
				    		 otherPostFlag=postData.otherPostFlag;
				    		 initSetDisplay(otherPostFlag);
						});
			    	 dwr.TOPEngine.setAsync(true);
			    	 comtop.UI.scan();
			    	//设置Tab页面链接
			    	 pageListUrl(postId);
			      }else{//点击分类时新增岗位的处理
			    	 initShow(); 
			    	 comtop.UI.scan();
			    	 //点击分类进来后现在新增页面 20150119 显示岗位列表修改 
			    	 insertShow();
			      }
			     
					
		}
		
		
		function setDisplay(value){
			 if(value==2){
				 cui('#otherPostTypePullDown').show();
				 cui("#userAndRoleTab").setTab(0,{'title':'行政岗位列表','tab_width':'80px',url:'${pageScope.cuiWebRoot}/top/sys/post/PostReList.jsp?postId='+postId+"&rootOrgId="+rootOrgId});
			 }else{
				 cui('#otherPostTypePullDown').hide();
				 cui("#userAndRoleTab").setTab(0,{'title':'用户列表',url:'${pageScope.cuiWebRoot}/top/sys/post/UserList.jsp?postId='+postId+'&classifyId='+classifyId+'&postRelationType='+postRelationType+"&rootOrgId="+rootOrgId});
			 }
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
		     cui('#insertPostButton').show();
		   
		     if(postId==""){//点击分类新增时,父分类id和父分类名称
		    	 data.parentName=classifyCurrName;
		    	 data.parentId=classifyId;
		     }else{
		         data.parentName=parentName;
		     }
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
			 cui('#saveButton').show();
		     cui('#closeButton').show();
		     cui('#saveAndGoButton').hide();
		     cui('#editPostButton').hide();
		     cui('#deletePostButton').hide();
		     cui('#returnPostButton').hide();
		     cui('#insertPostButton').hide();
		     cui('#parentName').setReadonly(true);
		    //是否是标准岗位不可编辑
			 cui('#standardPostFlagId').setReadonly(true,[1,2]);
		     //必填项显示
	         $('.top_required').show();
	        
	    }
	   
	    
	    
	   //进入新增岗位界面
	   var isInsertByPost=1; //2点击岗位时新增的 标记 
	   function insertShow(){
		   if(postId){//点击岗位时新增同级岗位操作
			   editShow();
			   cui('#centerMain').hide();
			   cui('#saveAndGoButton').show();
			   //清空数据
			   cui(data).databind().setEmpty();  
			   isInsertByPost=2;
			   cui('#parentName').setValue(parentName);
			   
			   cui('#otherPostTypePullDown').hide();
		 	    //是否是标准岗位不可编辑
				cui('#standardPostFlagId').setReadonly(false,[1,2]);
				cui('#standardPostFlagId').setValue("1");

		   }else{
		     $("#divFontCenter").attr('style', 'display:none');
		     $("#content").attr('style', 'display:');
		     cui('#saveButton').show();
		     cui('#saveAndGoButton').show();
		     cui('#closeButton').show();
		     cui('#insertPostButton').hide();
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
		    		PostOtherAction.readPostOther(postId,function(postData){
			    		//填充数据
		    	        cui(data).databind().setValue(postData);
					});
		    	 dwr.TOPEngine.setAsync(true);
		    	 isInsertByPost=1;
		    	 //必填项隐藏
		         $('.top_required').hide();
			     
		   }else{//点击分类下新增的取消
			   window.parent.cui('#border').setContentURL("center","PostOtherList.jsp?classifyId=" + classifyId + "&classifyName=" + encodeURIComponent(encodeURIComponent(classifyName))+ "&parentName=" + encodeURIComponent(encodeURIComponent(parentName))+ "&parentId=" + parentId);
		   }
		    
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
		* 同一分类下不能重名
		*/
		function isExsitPostName(data){ 
			
			var flag = true;
			var clssifyID='';
			 if(isInsertByPost==2){//添加同级岗位
				 clssifyID=parentId;
        	 }else{ //分类下添加岗位
        		 clssifyID=classifyId;
        	 }
			if(data != ""){
				dwr.TOPEngine.setAsync(false);
				PostOtherAction.isExsitPostName(data,postId,clssifyID,function(data){
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
				var reg = new RegExp("^[A-Za-z0-9_]+$");
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
				PostOtherAction.isExsitPostCode(data,postId,function(data){
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
				var reg = new RegExp("^[0-9_]+$");
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
       	
			            if(postId&&isInsertByPost==1){//编辑
			            	   vo.classifyId = parentId;  
					           dwr.TOPEngine.setAsync(false);
					           PostOtherAction.updatePostOther(vo,function(flag){
						            //刷新树
						           window.parent.refrushNodeByPost(classifyCurrName,postId,parentId,2);
					        	   window.parent.cui.message('更新岗位成功。','success');
					        	   closeSelf();
						          
					    		});
					    	   dwr.TOPEngine.setAsync(true);
			                   
		                }else{
		                	 if(isInsertByPost==2){//添加同级岗位
		                		 vo.classifyId=parentId;
		                	 }else{ //分类下添加岗位
		                		 vo.classifyId=classifyId;
		                	 }
		                    //新增
				           dwr.TOPEngine.setAsync(false);
				           PostOtherAction.inserPostOther(vo,function(postId){
					            //刷新树
					           window.parent.refrushNodeByPost(classifyCurrName,postId,vo.classifyId,1);
				        	   window.parent.cui.message('新增岗位成功。','success');
					          
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

		        	  
				    	   if(isInsertByPost==2){//添加同级岗位
		                		 vo.classifyId=parentId;
		                	 }else{ //分类下添加岗位
		                		 vo.classifyId=classifyId;
		                	 }
		                    //新增
				           dwr.TOPEngine.setAsync(false);
				           PostOtherAction.inserPostOther(vo,function(postId){
					            //刷新树
					           window.parent.refrushNodeByPost(classifyCurrName,postId,vo.classifyId,4);
				        	   window.parent.cui.message('新增岗位成功。','success');
				        	  //清空数据
							   cui(data).databind().setEmpty(); 
							   cui('#parentName').setValue(classifyCurrName);
					          
				    		});
				    	   dwr.TOPEngine.setAsync(true);
				    	   
	             }	    		
		}
		
		
		
		//删除岗位操作
		function deletePost(){
	    	  
			
			if(otherPostFlag!=2){ //非行政岗位的删除判断
		    	   dwr.TOPEngine.setAsync(false);
		    	   PostAction.getPostDeleteFlag(postId,postRelationType,1,function(result){
		    			if(!result){
		    				cui.confirm("【<font color='red'>"+postName+"</font>】包含人员或角色，确定删除吗?", {
		    			        onYes: function(){
		    			        	//执行删除
		    			        	deletePostOperate();
		    			        }
		    		    	});
		    			}else{
		    				cui.confirm("确定要删除该岗位吗？", {
		    			        onYes: function(){
		    			        	//执行删除
		    			        	deletePostOperate();
		    			        }
		    		    	});
		    			}
		    		});
		    	 dwr.TOPEngine.setAsync(true);
			}else if(otherPostFlag==2){ //标准岗位的删除判断
				   dwr.TOPEngine.setAsync(false);
		    	   PostAction.getPostDeleteFlag(postId,postRelationType,2,function(result){
		    			if(!result){
		    				cui.confirm("【<font color='red'>"+postName+"</font>】包含行政岗位或角色，确定删除吗?", {
		    			        onYes: function(){
		    			        	//执行删除
		    			        	deletePostOperate(otherPostFlag);
		    			        }
		    		    	});
		    			}else{
		    				cui.confirm("确定要删除该岗位吗？", {
		    			        onYes: function(){
		    			        	//执行删除
		    			        	deletePostOperate(otherPostFlag);
		    			        }
		    		    	});
		    			}
		    		});
		    	 dwr.TOPEngine.setAsync(true);
			}
		}    
		
		//删除岗位操作
		function deletePostOperate(otherPostFlag){
			dwr.TOPEngine.setAsync(false);
	           PostOtherAction.deletePostOther(postId,function(flag){
		            //刷新树
		           window.parent.refrushNodeByPost(classifyCurrName,postId,parentId,3);
	        	   window.parent.cui.message('删除岗位成功。','success');
	        	     $("#content").attr('style', 'display:none');
		  		     cui('#saveButton').hide();
		  		     cui('#saveAndGoButton').hide();
		  		     cui('#closeButton').hide();
		  		     cui('#insertPostButton').show();
		  		     $("#divFontCenter").attr('style', 'display:');
		  		      cui('#centerMain').hide();
	    		});
	    	   dwr.TOPEngine.setAsync(true);
		}
	    
		//设置跳转页面操作链接
		function pageListUrl(postId) {
			
    		 if(otherPostFlag==2){ //如果是标准岗位标识，otherPostFlag设置为2
    			 cui("#userAndRoleTab").setTab(0,"url",'${pageScope.cuiWebRoot}/top/sys/post/PostReList.jsp?postId='+postId+"&rootOrgId="+rootOrgId);
        	 } else{
        		 cui("#userAndRoleTab").setTab(0,"url",'${pageScope.cuiWebRoot}/top/sys/post/UserList.jsp?postId='+postId+'&classifyId='+classifyId+'&postRelationType='+postRelationType+"&rootOrgId="+rootOrgId);
        	 }
    		 cui("#userAndRoleTab").setTab(1,"url",'${pageScope.cuiWebRoot}/top/sys/post/RoleListForPost.jsp?postId='+postId+'&classifyId='+classifyId+'&postRelationType='+postRelationType);
		}
            
		
       function resizeTab(){
			
			var h =$("#centerMain").height();		
			cui("#userAndRoleTab").resize(h);
			
		}
       
		
		//返回岗位列表
		function returnPost(){
			//分类id使用currentClassifyId
		    window.parent.refrushNodeByPost(classifyCurrName,postId,currentClassifyId,5);
			window.parent.cui('#border').setContentURL("center","PostOtherList.jsp?classifyId=" + currentClassifyId +"&postFlag=" + 1+ "&classifyName=" + encodeURIComponent(encodeURIComponent(parentName))+ "&parentName=" + encodeURIComponent(encodeURIComponent(parentName))+ "&parentId=" + parentId+'&pageNo='+pageNo+'&pageSize='+pageSize+'&operate='+operate);
		}
		
		//初始化岗位归类下拉框
	 	function initPostTypeData(obj){
	 		dwr.TOPEngine.setAsync(false);
	 		PostAction.getPostTypeInfo(function(resultData){
					obj.setDatasource(jQuery.parseJSON(resultData));
				});
	 		dwr.TOPEngine.setAsync(true);
	 	}
	 	
		
       
        </script>
</body>
</html>