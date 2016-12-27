<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
    <title>���������λ��Ϣ</title>
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
				<div class="divTitleFont">���������λ��Ϣ</div>
			</div>
			<div class="thw_operate" style="padding-right: 5px;">
				<% if(!isHideSystemBtn){ %>
				<top:verifyAccess pageCode="TopOtherPostAdmin" operateCode="updateOtherPost">
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
					<td ><span uiType="input"    id="otherPostName" name="otherPostName" databind="data.otherPostName" maxlength="50" width="90%" 
					validate="[{'type':'required', 'rule':{'m': '��λ���Ʋ���Ϊ�ա�'}},{'type':'custom','rule':{'against':'isNameContainSpecial','m':'��λ����ֻ��Ϊ��Ӣ�ġ����ֻ򣨣�() �� _ -��'}},{'type':'custom','rule':{'against':'isExsitPostName','m':'ͬһ�����¸ø�λ�����Ѵ��ڡ�'}}]"]"></span></td>
				</tr>	
				 <tr>         
			        <td class="td_label" >��λ���룺</td>
			        <td ><span uiType="input"    id="otherPostCode" name="otherPostCode" databind="data.otherPostCode" maxlength="50" width="90%" validate="[{'type':'custom','rule':{'against':'isCodeContainSpecial','m':'��λ����ֻ��ΪӢ�ġ����ֻ��»��ߡ�'}},{'type':'custom','rule':{'against':'isExsitPostCode','m':'�ø�λ�����Ѵ��ڡ�'}}]"></span></td>
				 </tr>
				 
				 <tr>
				    <td class="td_label"> <span class="top_required">*</span>�Ƿ��Ǳ�׼��λ��  </td>
						<td>
							<span uitype="RadioGroup" name="standardPostFlag" id="standardPostFlagId" value="1"  databind="data.otherPostFlag" validate="��ѡ���λ���͡�" on_change="setDisplay"> 
								<input type="radio" name="otherPostFlag" value="2"/>��
                				<input type="radio" name="otherPostFlag" value="1"/>��
							</span> 
			         </td>
				 </tr>
				 
				 <tr>         
		           <td class="td_label" >�������ࣺ</td>
		           <td ><span uiType="input"     id="parentName" name="parentName" databind="data.parentName" width="90%"  maxlength="100" width="90%"  readonly=true></span></td>      
		        </tr>
		        

		        
		         <tr id="otherPostTypePullDown" style="display:none;">         
		            <td class="td_label" >��λ���ࣺ</td>
			        <td >
			          <span uitype="singlePullDown" id="otherPostType" name="otherPostType" auto_complete="true"  databind="data.otherPostType" datasource="initPostTypeData" empty_text="" width="90%"	editable="true" label_field="postTypeName" value_field="postTypeId" ></span>
			        </td>        
		        </tr>
		        
		        <tr>
				    <td class="td_label" valign="top">������</td>
					<td  colspan="3">
					<span uiType="Textarea"    id="note" name="note" width="96%" databind="data.note"  height="50px" maxlength="200"  ></span></td>
				</tr>
				       
			</table>
		</div>
	    <div id="divFontCenter"  class="divFontCenter">��������������Ӹ�λ</div>
	</div>
	<div uitype="bpanel"  id="centerMain" gap="0px 0px 0px 0px" position="center" height="100%">
	    	<div uitype="Tab" closeable="false" tabs="tabs" id="userAndRoleTab" fill_height="true" ></div>
	</div>
 </div>
      
        <script type="text/javascript">


        var classifyId = "<c:out value='${param.classifyId}'/>";//�ڵ�ID
       
		var classifyName = decodeURIComponent(decodeURIComponent( "<c:out value='${param.classifyName}'/>"));//�ڵ�����
		var parentName = decodeURIComponent(decodeURIComponent( "<c:out value='${param.parentName}'/>"));//���ڵ����� 
		var parentId = "<c:out value='${param.parentId}'/>";//���ڵ�id
		var postFlag = "<c:out value='${param.postFlag}'/>";//��λ�ڵ���  1Ϊ���� 2Ϊ������λ�ڵ�,3Ϊ��׼��λ��ʶ
        var postId=postFlag!=1?classifyId:"";  //��λid ���postFlag=2  ��classifyIdΪ��λid		
        var postName=postFlag!=1?classifyName:"";  //��λ����
        var classifyCurrName=postFlag==1?classifyName:parentName;  //��������
         
        var otherPostFlag=1; //��λ�ڵ���  1Ϊ������2Ϊ��׼��λ
        var currentClassifyId="<c:out value='${param.parentId}'/>";//��ǰ��ѡ��ķ���id�����ذ�ťʹ�õ�
          
       
   
		
		var data = {};
		//�����¼�����=1  ��λͬ��������λ=2 
		var  operationType = 0;
	    var postRelationType=2   //1Ϊ���� 2Ϊ������
	    var pageNo="<c:out value='${param.pageNo}'/>"; 
		var pageSize="<c:out value='${param.pageSize}'/>"; 
		var operate="<c:out value='${param.operate}'/>"; 
		  
		  
		  
		  var rootOrgId = "<c:out value='${param.rootOrgId}'/>";//����֯id 
		  
		  var tabs=[];
		  
		  function initSetDisplay(otherPostFlag){
			
			 if(otherPostFlag==2){ //����Ǳ�׼��λ��ʶ��otherPostFlag����Ϊ2
				 cui('#otherPostTypePullDown').show();
				//����tab������
			       tabs=[{'title':'������λ�б�',url:"PostReList.jsp",'tab_width':'80px;'},{'title':'��ɫ�б�',url:"RoleListForPost.jsp"}]; 
        	 } else{
        		 cui('#otherPostTypePullDown').hide();
        		//����tab������
        	       tabs=[{'title':'�û��б�',url:"UserList.jsp"},{'title':'��ɫ�б�',url:"RoleListForPost.jsp"}]; 
        	 }
		  }
		  
		  
	 
		window.onload = function(){
			   
	 
			   if(postId){//�༭��λ
			    	  readShow();
			    	  dwr.TOPEngine.setAsync(false);
			    	  PostOtherAction.readPostOther(postId,function(postData){
				    		//�������
			    			data = postData;
			    			//�����ݿ��ѯ������Ϊ׼,���������ѯ������
				    		 parentName=postData.classifyName;
				    		 parentId=postData.classifyId;
				    		 data.parentName=postData.classifyName;
				    		 otherPostFlag=postData.otherPostFlag;
				    		 initSetDisplay(otherPostFlag);
						});
			    	 dwr.TOPEngine.setAsync(true);
			    	 comtop.UI.scan();
			    	//����Tabҳ������
			    	 pageListUrl(postId);
			      }else{//�������ʱ������λ�Ĵ���
			    	 initShow(); 
			    	 comtop.UI.scan();
			    	 //��������������������ҳ�� 20150119 ��ʾ��λ�б��޸� 
			    	 insertShow();
			      }
			     
					
		}
		
		
		function setDisplay(value){
			 if(value==2){
				 cui('#otherPostTypePullDown').show();
				 cui("#userAndRoleTab").setTab(0,{'title':'������λ�б�','tab_width':'80px',url:'${pageScope.cuiWebRoot}/top/sys/post/PostReList.jsp?postId='+postId+"&rootOrgId="+rootOrgId});
			 }else{
				 cui('#otherPostTypePullDown').hide();
				 cui("#userAndRoleTab").setTab(0,{'title':'�û��б�',url:'${pageScope.cuiWebRoot}/top/sys/post/UserList.jsp?postId='+postId+'&classifyId='+classifyId+'&postRelationType='+postRelationType+"&rootOrgId="+rootOrgId});
			 }
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
		     cui('#insertPostButton').show();
		   
		     if(postId==""){//�����������ʱ,������id�͸���������
		    	 data.parentName=classifyCurrName;
		    	 data.parentId=classifyId;
		     }else{
		         data.parentName=parentName;
		     }
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
			 cui('#saveButton').show();
		     cui('#closeButton').show();
		     cui('#saveAndGoButton').hide();
		     cui('#editPostButton').hide();
		     cui('#deletePostButton').hide();
		     cui('#returnPostButton').hide();
		     cui('#insertPostButton').hide();
		     cui('#parentName').setReadonly(true);
		    //�Ƿ��Ǳ�׼��λ���ɱ༭
			 cui('#standardPostFlagId').setReadonly(true,[1,2]);
		     //��������ʾ
	         $('.top_required').show();
	        
	    }
	   
	    
	    
	   //����������λ����
	   var isInsertByPost=1; //2�����λʱ������ ��� 
	   function insertShow(){
		   if(postId){//�����λʱ����ͬ����λ����
			   editShow();
			   cui('#centerMain').hide();
			   cui('#saveAndGoButton').show();
			   //�������
			   cui(data).databind().setEmpty();  
			   isInsertByPost=2;
			   cui('#parentName').setValue(parentName);
			   
			   cui('#otherPostTypePullDown').hide();
		 	    //�Ƿ��Ǳ�׼��λ���ɱ༭
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
		    		PostOtherAction.readPostOther(postId,function(postData){
			    		//�������
		    	        cui(data).databind().setValue(postData);
					});
		    	 dwr.TOPEngine.setAsync(true);
		    	 isInsertByPost=1;
		    	 //����������
		         $('.top_required').hide();
			     
		   }else{//���������������ȡ��
			   window.parent.cui('#border').setContentURL("center","PostOtherList.jsp?classifyId=" + classifyId + "&classifyName=" + encodeURIComponent(encodeURIComponent(classifyName))+ "&parentName=" + encodeURIComponent(encodeURIComponent(parentName))+ "&parentId=" + parentId);
		   }
		    
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
		* ͬһ�����²�������
		*/
		function isExsitPostName(data){ 
			
			var flag = true;
			var clssifyID='';
			 if(isInsertByPost==2){//���ͬ����λ
				 clssifyID=parentId;
        	 }else{ //��������Ӹ�λ
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
		* �ж������Ƿ���������ַ�
		*/
		function isCodeContainSpecial(data){
			if(data){  
				var reg = new RegExp("^[A-Za-z0-9_]+$");
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
				var reg = new RegExp("^[0-9_]+$");
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
       	
			            if(postId&&isInsertByPost==1){//�༭
			            	   vo.classifyId = parentId;  
					           dwr.TOPEngine.setAsync(false);
					           PostOtherAction.updatePostOther(vo,function(flag){
						            //ˢ����
						           window.parent.refrushNodeByPost(classifyCurrName,postId,parentId,2);
					        	   window.parent.cui.message('���¸�λ�ɹ���','success');
					        	   closeSelf();
						          
					    		});
					    	   dwr.TOPEngine.setAsync(true);
			                   
		                }else{
		                	 if(isInsertByPost==2){//���ͬ����λ
		                		 vo.classifyId=parentId;
		                	 }else{ //��������Ӹ�λ
		                		 vo.classifyId=classifyId;
		                	 }
		                    //����
				           dwr.TOPEngine.setAsync(false);
				           PostOtherAction.inserPostOther(vo,function(postId){
					            //ˢ����
					           window.parent.refrushNodeByPost(classifyCurrName,postId,vo.classifyId,1);
				        	   window.parent.cui.message('������λ�ɹ���','success');
					          
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

		        	  
				    	   if(isInsertByPost==2){//���ͬ����λ
		                		 vo.classifyId=parentId;
		                	 }else{ //��������Ӹ�λ
		                		 vo.classifyId=classifyId;
		                	 }
		                    //����
				           dwr.TOPEngine.setAsync(false);
				           PostOtherAction.inserPostOther(vo,function(postId){
					            //ˢ����
					           window.parent.refrushNodeByPost(classifyCurrName,postId,vo.classifyId,4);
				        	   window.parent.cui.message('������λ�ɹ���','success');
				        	  //�������
							   cui(data).databind().setEmpty(); 
							   cui('#parentName').setValue(classifyCurrName);
					          
				    		});
				    	   dwr.TOPEngine.setAsync(true);
				    	   
	             }	    		
		}
		
		
		
		//ɾ����λ����
		function deletePost(){
	    	  
			
			if(otherPostFlag!=2){ //��������λ��ɾ���ж�
		    	   dwr.TOPEngine.setAsync(false);
		    	   PostAction.getPostDeleteFlag(postId,postRelationType,1,function(result){
		    			if(!result){
		    				cui.confirm("��<font color='red'>"+postName+"</font>��������Ա���ɫ��ȷ��ɾ����?", {
		    			        onYes: function(){
		    			        	//ִ��ɾ��
		    			        	deletePostOperate();
		    			        }
		    		    	});
		    			}else{
		    				cui.confirm("ȷ��Ҫɾ���ø�λ��", {
		    			        onYes: function(){
		    			        	//ִ��ɾ��
		    			        	deletePostOperate();
		    			        }
		    		    	});
		    			}
		    		});
		    	 dwr.TOPEngine.setAsync(true);
			}else if(otherPostFlag==2){ //��׼��λ��ɾ���ж�
				   dwr.TOPEngine.setAsync(false);
		    	   PostAction.getPostDeleteFlag(postId,postRelationType,2,function(result){
		    			if(!result){
		    				cui.confirm("��<font color='red'>"+postName+"</font>������������λ���ɫ��ȷ��ɾ����?", {
		    			        onYes: function(){
		    			        	//ִ��ɾ��
		    			        	deletePostOperate(otherPostFlag);
		    			        }
		    		    	});
		    			}else{
		    				cui.confirm("ȷ��Ҫɾ���ø�λ��", {
		    			        onYes: function(){
		    			        	//ִ��ɾ��
		    			        	deletePostOperate(otherPostFlag);
		    			        }
		    		    	});
		    			}
		    		});
		    	 dwr.TOPEngine.setAsync(true);
			}
		}    
		
		//ɾ����λ����
		function deletePostOperate(otherPostFlag){
			dwr.TOPEngine.setAsync(false);
	           PostOtherAction.deletePostOther(postId,function(flag){
		            //ˢ����
		           window.parent.refrushNodeByPost(classifyCurrName,postId,parentId,3);
	        	   window.parent.cui.message('ɾ����λ�ɹ���','success');
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
	    
		//������תҳ���������
		function pageListUrl(postId) {
			
    		 if(otherPostFlag==2){ //����Ǳ�׼��λ��ʶ��otherPostFlag����Ϊ2
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
       
		
		//���ظ�λ�б�
		function returnPost(){
			//����idʹ��currentClassifyId
		    window.parent.refrushNodeByPost(classifyCurrName,postId,currentClassifyId,5);
			window.parent.cui('#border').setContentURL("center","PostOtherList.jsp?classifyId=" + currentClassifyId +"&postFlag=" + 1+ "&classifyName=" + encodeURIComponent(encodeURIComponent(parentName))+ "&parentName=" + encodeURIComponent(encodeURIComponent(parentName))+ "&parentId=" + parentId+'&pageNo='+pageNo+'&pageSize='+pageSize+'&operate='+operate);
		}
		
		//��ʼ����λ����������
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