
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>����༭����</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostOtherAction.js"></script>
	
</head>
<body>
<div class="top_header_wrap">
   <div class="thw_title" style="font-size:15px;">����༭</div>
   <div class="thw_operate">
	  <span uitype="button" label="����" on_click="savePostClassify"></span>
	  <span uitype="button" label="ȡ��" on_click="closeSelf"></span>
   </div>
</div>
    <table class="form_table">
       <tbody>
       <tr>         
		<td class="td_label" width="30%">
			<span  class="top_required">*</span>�������� ��
		</td>
		<td class="td_content">
			<span uitype="input" id="classifyName" name="classifyName" databind="data.classifyName" maxlength="80" width="300" validate="validatePostClassifyName"></span>
		</td>
	 </tr> 
	 <tr>  
	    <td class="td_label" width="30%">
	    	 <span  class="top_required">*</span>������� ��
	    </td>
		<td class="td_content">
			<span uitype="input" id="classifyCode" name="classifyCode" databind="data.classifyCode" maxlength="100" width="300" validate="validatePostClassifyCode"></span>
		</td>
	 </tr>
	
	<tr>
		<td class="td_label">����</td>
		<td>	
			<span uitype="textarea" name="description" databind="data.description" height="100px" maxlength="100"></span>
		</td>
	</tr>
	
	
	
	</tbody>
  </table>
<script language="javascript">
    var parentId = "<c:out value='${param.parentId}'/>";
    var classifyId = "<c:out value='${param.classifyId}'/>";
	
    var validatePostClassifyName = [
                             		{'type':'required','rule':{'m':'����д�������ơ�'}},
                             		{'type':'custom','rule':{'against':isClassifyNameContainSpecial, 'm':'����ֻ��Ϊ��Ӣ�ġ����ֻ��»��ߡ�'}},
                             		{'type':'custom','rule':{'against':checkNameUnique, 'm':'ͬһ�����������Ѵ��ڡ�'}}
                             	];
    var validatePostClassifyCode = [
                                  {'type':'required','rule':{'m':'����д������롣'}},
                                  {'type':'custom','rule':{'against':isClassifyCodeContainSpecial, 'm':'����ֻ��ΪӢ�ġ����ֻ��»��ߡ�'}},
                                  {'type':'custom','rule':{'against':checkUnique, 'm':'�����Ѵ��ڡ�'}}
                                ];                        
    
	var data = {};
	//ɨ�裬�൱����Ⱦ
	window.onload=function(){
		
		if(classifyId){//�༭
			 dwr.TOPEngine.setAsync(false);
			 PostOtherAction.readPostOtherClassify(classifyId,function(userData){
		    		//�������
	    			data = userData;
				});
	    	 dwr.TOPEngine.setAsync(true);	
		}
		comtop.UI.scan();
		
	}
	
	
	
	
	//����
	function savePostClassify(){
			 //������֤��ȡ��Ϣ
		     var map = window.validater.validAllElement();
		   	 var inValid = map[0];//���ô�����Ϣ
		   	 var valid = map[1]; //���óɹ���Ϣ
	         if (inValid.length > 0) {
	            var str = "";
	            for (var i = 0; i < inValid.length; i++) {
					str +=  inValid[i].message + "<br />";
				}
	         }else {
	        	 //��ȡ����Ϣ
	         	 var vo = cui(data).databind().getValue();
	        	     vo.parentClassifyId=parentId;
	         	if(classifyId){//�༭
	         		dwr.TOPEngine.setAsync(false);
	         		PostOtherAction.updatePostOtherClassify(vo,function(flag) {
	                	     window.parent.cui.message('�޸ķ���ɹ���','success');
	                		 window.parent.refrushNode("edit",classifyId,parentId,vo.classifyName);
	                		 window.parent.dialog.hide();
		 				});
	         		dwr.TOPEngine.setAsync(true);
	         	}else{  //����
	         		
	         		   var addtype="add";
	         		   if(parentId=="-1"){
	         			  addtype="addRoot";
	         		   }
			           dwr.TOPEngine.setAsync(false);
			           PostOtherAction.inserPostOtherClassify(vo,function(classifyId){
				            //ˢ����
				           window.parent.refrushNode(addtype,classifyId,parentId,vo.classifyName);
			        	   window.parent.cui.message('��������ɹ���','success');
			        	   window.parent.dialog.hide();
				          
			    		});
			    	   dwr.TOPEngine.setAsync(true);
	                
	            }
	         }
	        
   	}
	
	
	//�رմ���
	function closeSelf(){
		window.parent.dialog.hide();
	}

	
	//�ж������Ƿ���������ַ�
	function isClassifyNameContainSpecial(){
		var name = data.classifyName;
		if(name == "")return true;
		var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_ ]+$");
		return (reg.test(name));
	}

	//�жϱ����Ƿ���������ַ�
	function isClassifyCodeContainSpecial(){
		var name = data.classifyCode;
		if(name == "")return true;
		var reg = new RegExp("^[A-Za-z0-9_]+$");
		return (reg.test(name));
	}
	
	//���ͬһ���������Ƿ�����������
	function checkNameUnique(){
		var flag = true;
		var classifyName = data.classifyName;
		if(classifyName != ""){
			dwr.TOPEngine.setAsync(false);
			PostOtherAction.isPostClassifyNameUnique(classifyName,parentId,classifyId,function(result){
				if(!result){
					flag = false;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		return flag;
	}
	
	
	//���ͬһ�������±����Ƿ�Ψһ
	function checkUnique(){
		var flag = true;
		var codeVal = data.classifyCode;
		if(codeVal != ""){
			dwr.TOPEngine.setAsync(false);
			PostOtherAction.isPostClassifyCodeUnique(codeVal,parentId,classifyId,function(result){
				if(!result){
					flag = false;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		return flag;
	}


</script>
</body>
</html>