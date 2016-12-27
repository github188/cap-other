<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
    <title>��λ��Ϣ</title>
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
				<div class="divTitleFont">��λ��Ϣ</div>
			</div>
			<div class="thw_operate" style="padding-right: 5px;">
			<% if(!isHideSystemBtn){ %>
				<top:verifyAccess pageCode="TopPostAdmin" operateCode="updatePost">
					<span uiType="Button" id='insertPostButton' label="������λ" on_click="insertShow" ></span>
				    <span uiType="Button" id="editPostButton" label="�༭" on_click="editShow" ></span>
				    <span uiType="Button" id="deletePostButton" label="ɾ��" on_click="deletePost" ></span>
			    </top:verifyAccess>
			    <% } %>
			     <span uiType="Button" id="returnPostButton" label="����" on_click="returnPost" ></span>
				<span uiType="Button" id="saveButton" label="����" on_click="savePost" ></span>
                <span uiType="Button" id="saveAndGoButton" label="�������" on_click="savePostAndGo" ></span>
                <span uiType="Button" id="closeButton" label="ȡ��" on_click="closeSelf" ></span>
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
					<td class="td_label" ><span class="top_required">*</span>��λ���ƣ�</td>
					<td ><span uiType="input"    id="postName" name="postName" databind="data.postName" maxlength="150" width="90%" 
					validate="[{'type':'required', 'rule':{'m': '��λ���Ʋ���Ϊ�ա�'}},{'type':'custom','rule':{'against':'isNameContainSpecial','m':'��λ����ֻ��Ϊ��Ӣ�ġ����ֻ򣨣�() �� _ -��'}},{'type':'custom','rule':{'against':'isExsitPostName','m':'ͬһ��֯�¸ø�λ�����Ѵ��ڡ�'}}]"></span></td>
				</tr>	
				 <tr>         
			        <td class="td_label" >��λ���룺</td>
			        <td ><span uiType="input"    id="postCode" name="postCode" databind="data.postCode" maxlength="50" width="90%" validate="[{'type':'custom','rule':{'against':'isCodeContainSpecial','m':'��λ����ֻ��ΪӢ�ġ����ֻ򣨣�()  _ -��'}},{'type':'custom','rule':{'against':'isExsitPostCode','m':'�ø�λ�����Ѵ��ڡ�'}}]"></span></td>
		            <td class="td_label" >��λ���ࣺ</td>
			        <td >
			          <span uitype="singlePullDown" id="postType" name="postType"   auto_complete="true"  databind="data.postType" datasource="initPostTypeData" empty_text="" width="90%"	editable="true"   label_field="postTypeName" value_field="postTypeId" ></span>
			        </td>        
		        </tr>	
		        <tr>         
					<td class="td_label" >��λϵ����</td>
					<td ><span uiType="input"    id="postParam" name="postParam" databind="data.postParam" maxlength="8" width="90%"   mask="Dec"></span></td>
					<td class="td_label" >��λ���У�</td>
					<td ><span uiType="input"    id="postSequence" name="postSequence" databind="data.postSequence" maxlength="80" width="90%" ></span></td>
				</tr>
				 <tr>         
		            <td class="td_label" >��λ���</td>
			        <td >
			           <span uitype="singlePullDown" id="postClassify" name="postClassify" databind="data.postClassify" datasource="initPostClassifyData" empty_text="" width="90%"	editable="false" label_field="postClassifyName" value_field="postClassifyId" ></span>
			        </td>        
		           <td class="td_label" >������֯��</td>
		           <td ><span uiType="input"     id="orgName" name="orgName" databind="data.orgName" width="90%"  maxlength="100" width="90%"  readonly=true></span></td>      
		        </tr>
		        
		        <tr>
		           <td class="td_label" >������׼��λ��</td>
			        <td >
			           <span uitype="singlePullDown" id="standardPostCode" name="standardPostCode"   auto_complete="true"   databind="data.standardPostCode"   datasource="initStandardPostCodeData"  empty_text=""  width="90%"	editable="true"   label_field="otherPostName"  value_field="otherPostId" ></span>
			        </td>  
				    <td class="td_label" valign="top">������</td>
					<td >
					<span uiType="Textarea"    id="note" name="note" width="96%" databind="data.note"  height="50px" maxlength="200"  ></span></td>
				</tr>
				       
			</table>
		</div>
	    <div id="divFontCenter"  class="divFontCenter">��������λ��ѡ���λ</div>
	</div>
	<div uitype="bpanel"  id="centerMain" gap="0px 0px 0px 0px" position="center" height="100%">
	    	<div uitype="Tab" closeable="false" tabs="tabs" id="userAndRoleTab" fill_height="true" ></div>
	</div>
 </div>
      
        <script type="text/javascript">


        var postId = "<c:out value='${param.postId}'/>";//��λID
		var postName = decodeURIComponent(decodeURIComponent("<c:out value='${param.postName}'/>"));//��λ���� 
		var  orgId= "<c:out value='${param.orgId}'/>";//��֯id
		var orgName = decodeURIComponent(decodeURIComponent("<c:out value='${param.orgName}'/>"));//��֯���� 
		var rootOrgId = "<c:out value='${param.rootOrgId}'/>";//����֯id 
		var orgStructureId = "<c:out value='${param.orgStructureId}'/>"; //��֯�ṹid
	    var pageNo="<c:out value='${param.pageNo}'/>"; 
	    var pageSize="<c:out value='${param.pageSize}'/>"; 
	    var operate="<c:out value='${param.operate}'/>"; 
	    
	    var postRelationType=1   //1Ϊ���� 2Ϊ������
	    var currentOrgId="<c:out value='${param.orgId}'/>";//��ǰ��ѡ�����֯id�����ذ�ťʹ�õ�
	    
		//����tab������
        var tabs=[
                  {'title':'�û��б�',url:"UserList.jsp"},
                  {'title':'��ɫ�б�',url:"RoleListForPost.jsp"},
                  {'title':'�������ڵ���Ϣ',url:"WorkFlowListForPost.jsp",tab_width:"90px"}
                  ]; 
		var data = {};
		//��֯�¼�����=1  ��λͬ��������λ=2 
		var operationType = 0;
	
		
		window.onload = function(){
			      
			   if(postId){//�༭
			    	  readShow();
			    	  dwr.TOPEngine.setAsync(false);
			    		PostAction.readPost(postId,function(postData){
				    		//�������
			    			data = postData;
				    		//�����ݿ��ѯ������Ϊ׼,���������ѯ������
			    		   orgName=postData.orgName;
			    		   orgId=postData.orgId;
				    		
			    			if(postData.postParam==0){ // Ϊ0ʱ����ʾֵ
			    				postData.postParam="";
			    			}
				          

			    		
						});
			    	 dwr.TOPEngine.setAsync(true);
			    	 comtop.UI.scan();
			    	//����Tabҳ������
			    	 pageListUrl(postId);
			      }else{
			    	 if(orgId==""||orgId==null){//��֯idΪ�յ������������ť����ʾ
			    		 cui('#insertPostButton').hide();
			    	 }
			    	 initShow(); 
			    	 comtop.UI.scan();
			    	 //�����֯��������������ҳ�� 20150119 ��ʾ��λ�б��޸� 
			    	 insertShow();
			      }
			 
					
		}
		
		
		//��ʼ����λ����������
	 	function initPostTypeData(obj){
	 		dwr.TOPEngine.setAsync(false);
	 		PostAction.getPostTypeInfo(function(resultData){
					obj.setDatasource(jQuery.parseJSON(resultData));
				});
	 		dwr.TOPEngine.setAsync(true);
	 	}
	 	
	 	
		//��ʼ����λ���������
	 	function initPostClassifyData(obj){
			
	 		dwr.TOPEngine.setAsync(false);
	 		PostAction.getPostClassifyInfo(function(resultData){
					obj.setDatasource(jQuery.parseJSON(resultData));
				});
	 		dwr.TOPEngine.setAsync(true);
	 	}
		
	 	
	 	
		//��ʼ����׼��λ������-20150305
	 	function initStandardPostCodeData(obj){
			
	 		dwr.TOPEngine.setAsync(false);
	 		PostOtherAction.getStandardPostInfo(function(resultData){
					obj.setDatasource(jQuery.parseJSON(resultData));
				});
	 		dwr.TOPEngine.setAsync(true);
	 	}
	 	
             
	    //��ʼ������
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
	    
	   
	   //����鿴��λ����
	   function readShow(){
		     $("#divFontCenter").attr('style', 'display:none');
		     //ȫ��ֻ��
		     comtop.UI.scan.readonly=true;
		     $("#content").attr('style', 'display:');
		     cui('#editPostButton').show();
		     cui('#deletePostButton').show();
		     cui('#saveButton').hide();
		     cui('#saveAndGoButton').hide();
		     cui('#closeButton').hide();
		     cui('#insertPostButton').show();
		     //����������
	         $('.top_required').hide();
	     	if(operate==null||operate==""){ //operateΪ�գ�����������λ�ڵ���룬���ذ�ť������
				  cui('#returnPostButton').hide();
			}else if(operate==1){//����б�༭����
				  cui('#returnPostButton').show();
			}
		    
	    }
	   
	   //����༭��λ����
	   function editShow(){
		 //�Ƴ�ֻ����ʽ��ȡ��ֻ��
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
		     //��������ʾ
	         $('.top_required').show();
		    
	    }
	   
	    
	    
	   //����������λ����
	   var isInsertByPost=0; //1�����λʱ������ ��� 
	   function insertShow(){
		   if(postId){//�����λʱ��������
			   editShow();
			   cui('#centerMain').hide();
			   cui('#saveAndGoButton').show();
			   //�������
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
	   
	   
	   //ȡ����ť����
	   function closeSelf(){
		   if(postId){//�༭�͵����λ����ʱ��ȡ��
				 $('.cui_ext_textmode').attr('cui_ext_textmode');
				 comtop.UI.scan.setReadonly(true, $('#content'))
				 cui('#saveButton').hide();
			     cui('#saveAndGoButton').hide();
			     cui('#closeButton').hide();
			     cui('#insertPostButton').show();
			     cui('#editPostButton').show();
			     cui('#deletePostButton').show();
			
			     	if(operate==null||operate==""){ //operateΪ�գ�����������λ�ڵ���룬���ذ�ť������
						  cui('#returnPostButton').hide();
					}else if(operate==1){//����б�༭����
						  cui('#returnPostButton').show();
					}
			     
				 cui('#centerMain').show();
			     dwr.TOPEngine.setAsync(false);
		    		PostAction.readPost(postId,function(postData){
			    		//�������
		    	        cui(data).databind().setValue(postData);
					});
		    	 dwr.TOPEngine.setAsync(true);
		    	 isInsertByPost=0;
		    	//����������
		        $('.top_required').hide();
		    
			     
		   }else{//�����֯��������ȡ��
			    //��ת����λ�б�ҳ��
			   window.parent.cui("#postBorderlayout").setContentURL("center","PostList.jsp?orgId="+orgId+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId+"&orgName="+ encodeURIComponent(encodeURIComponent(orgName))); 
		   }
		   cui('#orgName').setValue(orgName);
	    }
	   
		  /*
		* �ж������Ƿ���������ַ�
		*/
		function isNameContainSpecial(data){
			  //������ ����() �� ��Ӣ�� ���� _-
			var reg = new RegExp("^[\uff08 \uff09 \u0028 \u0029 \u3001 \u4E00-\u9FA5A-Za-z0-9_-]+$");
			return (reg.test(data));
		}
		  
		/**
		* ͬһ��֯�²�������
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
		* �ж������Ƿ���������ַ�
		*/
		function isCodeContainSpecial(data){
			if(data){  
				var reg = new RegExp("^[\uff08 \uff09 \u0028 \u0029  A-Za-z0-9_-]+$");
				return (reg.test(data));
			}
			return true;
		}
		  
		/**
		*���벻������
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
		
		// �����λϵ��������Ϊ0.00
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
		
		// �����λϵ����ֻ����������
		function validateNum(data){
			if(data){	
				var reg = new RegExp("^[0-9\.]+$");
				return (reg.test(data));
			}
			return true;
		}
		
		
		//�����λ��Ϣ
		function savePost(){
			
			//��֤��
	         var map = window.validater.validAllElement();
	         var inValid = map[0];//���ô�����Ϣ
	         var valid = map[1]; //���óɹ���
	         if (inValid.length > 0) {
	             var str = "";
	             for (var i = 0; i < inValid.length; i++) {
	 					str +=  inValid[i].message + "<br />";
	 				}
	 			//������Ϣ���ˣ���λ����һ������
	 			var top = $('#' + map[0][0].id).offset().top;
	 			$(document).scrollTop(top-10);
	         }else {
	        
					 //��ȡ����Ϣ
		        	var vo = cui(data).databind().getValue();
		        	    vo.orgId = orgId;  
			            if(postId&&isInsertByPost==0){//�༭
					           dwr.TOPEngine.setAsync(false);
					           PostAction.updatePost(vo,function(flag){
						            //ˢ����
						           window.parent.refreshEditTree(postId,orgId,orgName,2);
					        	   window.parent.cui.message('�޸ĸ�λ�ɹ���','success');
					        	   pageListUrl(postId);
					        	   closeSelf();
					        	   
						          
					    		});
					    	   dwr.TOPEngine.setAsync(true);
			                   
		                }else{
		                	
		                      //����
				           dwr.TOPEngine.setAsync(false);
				           PostAction.insertPost(vo,function(postId){
					            //ˢ����
					           window.parent.refreshEditTree(postId,orgId,orgName,1);
				        	   window.parent.cui.message('������λ�ɹ���','success');
				        	   pageListUrl(postId);
					          
				    		});
				    	   dwr.TOPEngine.setAsync(true);
		                     }
	             }	    		
		}
		
		
		//�����λ�Ų���������
		function savePostAndGo(){
			
			//��֤��
	         var map = window.validater.validAllElement();
	         var inValid = map[0];//���ô�����Ϣ
	         var valid = map[1]; //���óɹ���
	         if (inValid.length > 0) {
	             var str = "";
	             for (var i = 0; i < inValid.length; i++) {
	 					str +=  inValid[i].message + "<br />";
	 				}
	 			//������Ϣ���ˣ���λ����һ������
	 			var top = $('#' + map[0][0].id).offset().top;
	 			$(document).scrollTop(top-10);
	         }else {
	        
					 //��ȡ����Ϣ
		        	var vo = cui(data).databind().getValue();
		        	    vo.orgId = orgId;  
			          
		                	
		                      //����
				           dwr.TOPEngine.setAsync(false);
				           PostAction.insertPost(vo,function(postId){
					            //ˢ����
					           window.parent.refreshEditTree(postId,orgId,orgName,4);
				        	   window.parent.cui.message('������λ�ɹ���','success');
				        	   pageListUrl(postId);
				        	 //�������
							   cui(data).databind().setEmpty(); 
							   cui('#orgName').setValue(orgName);
					          
				    		});
				    	   dwr.TOPEngine.setAsync(true);
		                   
	             }	    		
		}
		
		
		
		//ɾ����λ����
		function deletePost(){
			
			  dwr.TOPEngine.setAsync(false);
	    	   PostAction.getPostDeleteFlag(postId,postRelationType,1,function(result){
	    			
	    			if(!result){
	    				cui.confirm("��<font color='red'>"+postName+"</font>��������Ա���ɫ��ȷ��ɾ����?", {
	    			        onYes: function(){
	    			        dwr.TOPEngine.setAsync(false);
	  				           PostAction.deletePost(postId,function(flag){
	  					            //ˢ����
	  					           window.parent.refreshEditTree(postId,orgId,orgName,3);
	  				        	   window.parent.cui.message('ɾ����λ�ɹ���','success');
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
	    				cui.confirm("ȷ��Ҫɾ���ø�λ��", {
	    			        onYes: function(){
	    			        dwr.TOPEngine.setAsync(false);
	  				           PostAction.deletePost(postId,function(flag){
	  					            //ˢ����
	  					           window.parent.refreshEditTree(postId,orgId,orgName,3);
	  				        	   window.parent.cui.message('ɾ����λ�ɹ���','success');
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
	    
		//������תҳ���������
		function pageListUrl(postId) {
			 cui("#userAndRoleTab").setTab(0,"url",'${pageScope.cuiWebRoot}/top/sys/post/UserList.jsp?postId='+postId+'&orgId='+orgId+"&rootOrgId="+rootOrgId+'&postRelationType='+postRelationType+'&orgStructureId='+orgStructureId);
    	     cui("#userAndRoleTab").setTab(1,"url",'${pageScope.cuiWebRoot}/top/sys/post/RoleListForPost.jsp?postId='+postId+'&orgId='+orgId+"&rootOrgId="+rootOrgId+'&postRelationType='+postRelationType);
    	     cui("#userAndRoleTab").setTab(2,"url",'${pageScope.cuiWebRoot}/top/sys/post/WorkFlowListForPost.jsp?postId='+postId+'&orgId='+orgId+"&postName="+encodeURIComponent(encodeURIComponent(postName))+"&orgName="+encodeURIComponent(encodeURIComponent(orgName)));
		}
         
		
		function resizeTab(){
			
			var h =$("#centerMain").height();		
			cui("#userAndRoleTab").resize(h);
			
		}
		
		//���ظ�λ�б�
		function returnPost(){
			 window.parent.refreshEditTree(postId,currentOrgId,orgName,5);
			window.parent.cui("#postBorderlayout").setContentURL("center","PostList.jsp?orgId="+currentOrgId+"&rootOrgId="+rootOrgId+'&orgStructureId='+orgStructureId+"&orgName="+ encodeURIComponent(encodeURIComponent(orgName))+'&pageNo='+pageNo+'&pageSize='+pageSize+'&operate='+operate); 
		}
		
		
        </script>
</body>
</html>