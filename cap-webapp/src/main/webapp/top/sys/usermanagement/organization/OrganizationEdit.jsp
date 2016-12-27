<%
/**********************************************************************
* ��֯������Ϣά��
* 2014-07-02 ����  �½�
**********************************************************************/
%>

<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="com.comtop.top.sys.usermanagement.user.util.UomCommonUtil" %>
<%		
	//�Ƿ�����ϵͳ��Ա��֯���ܰ�ť true ���� false ������
    boolean isHideSystemBtnInUserOrg = UomCommonUtil.getHideSystemBtnInUserOrgCfg();
%>
<html>
<head>
<title>��֯��Ϣά��</title>
<meta http-equiv="X-UA-Compatible" content="edge" />
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/OrganizationAction.js"></script>
<style type="text/css">
	#extendField .td_label{width:15%;}
	#extendField .customform{table-layout:fixed;}
	.top_header_wrap{
		padding-right:5px;
	}
	 html{
            padding-top:35px;  /*�ϲ�����Ϊ50px*/
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
            overflow:hidden;
        }
        html,body{
            margin:0;
            height: 100%;
            width:100%;
        }
	.top{
            width:100%;
            height:38px;  /*�߶Ⱥ�padding����һ��*/
            margin-top: -35px; /*ֵ��padding����һ��*/                     
            overflow: auto;
            position:relative;
      }
     .main{
          height: 100%;
            width:100%;
            overflow: auto;
     }
</style>
<script type="text/javascript">
	var curOrgStructureId = "<c:out value='${param.orgStructureId}'/>";
	var curOrgId = "<c:out value='${param.orgId}'/>";
	var curName = decodeURIComponent(decodeURIComponent("<c:out value='${param.name}'/>"));
	var parentNodeId = "<c:out value='${param.parentNodeId}'/>";
 	var isRootNode = "<c:out value='${param.isRootNode}'/>";
	var curCode = "";
	var parentNodeName = "";
	var parentNodeCode = ""
	//������=1  ����ͬ��=2  �����¼�=3 �༭��֯=4
	var operationType = 0;
	var editable = 0;
	var orgTypeQueryId = parentNodeId;
	//���󶨵Ķ���
	var orgJsonData={};
	//��֤����
    var  validateSub="";
    var  validateRoot="";
    
    //�Ƿ�����ϵͳ���ܰ�ť true ���� false ������
	var isHideSystemBtn = '<%=isHideSystemBtn %>';
	 //�Ƿ�����ϵͳ��Ա��֯���ܰ�ť true ���� false ������
	var isHideSystemBtnInUserOrg = '<%=isHideSystemBtnInUserOrg %>';
 	
 	var buttondata = {
 	    	datasource: [
 	            {id:'exportDeptBtn',label:'������֯��Ϣ'},
 	            {id:'downDeptModelBtn',label:'����ģ��'},
 	            {id:'im',label:'������֯��Ϣ'}
 	        ],
 	        on_click:function(obj){
 	        	if(obj.id=='exportDeptBtn'){
 	        		exportDept();
 	        	}else if(obj.id=='downDeptModelBtn'){
 	        		downDeptModel();
 	        	}else if(obj.id=='im'){
 	        		ExcelImport();
 	        	}
 	        }
 	    };
 	//��ʼ����֯����������
 	function initOrgTypeData(obj){
 		dwr.TOPEngine.setAsync(false);
	 		OrganizationAction.getOrgTypeInfo(function(resultData){
				obj.setDatasource(jQuery.parseJSON(resultData));
			});
 		dwr.TOPEngine.setAsync(true);
 	}
 	var initOrgPropertyData = [
 	       {orgProperty:'1',orgPropertyName:'������֯'},                    
 	       {orgProperty:'2',orgPropertyName:'������֯'}                    
 	    ];
	window.onload = function(){
		initData();
		comtop.UI.scan();
		//��ʼ����չ���ԵĶ�̬��
		initExtendAttrData();
		comtop.UI.scan.setReadonly(true);
		//����������
        $('.top_required').hide();
        $('.td_required').hide();
		if(parentNodeId == ''){//�޸��ڵ�
			cui('#buttonGroup').hide();
			cui('#addSiblingBtn').hide();
			cui('#button_save').show();
			cui('#cancel').hide();
			cui('#addChildBtn').hide();
			cui('#editBtn').hide();
			cui('#disableBtn').hide();
			addRoot();
		}
	};
	/**
	*  ҳ�����ʱ��ʼ����ť������
	*/
	function initData(){
		//ҳ�����ʱ�����ı���
		cui('#sortNo').hide();
		cui('#parentNodeId').hide();
		cui('#orgId').hide();
		cui('#parentCode').hide();
		cui('#subCode').hide();
		cui('#subCodeRoot').hide();
		cui('#code').show();
		if(parentNodeId == ''){//�޸��ڵ�
			return;
		}else if(parentNodeId == '-1' || isRootNode == 'true'){//ѡ�е�Ϊ���ڵ�
			cui('#addSiblingBtn').hide();
			cui('#button_save').hide();
			cui('#cancel').hide();
			cui('#buttonGroup').show();
			cui('#addChildBtn').show();
			cui('#editBtn').show();
			cui('#disableBtn').hide();
			var obj = {orgId:curOrgId,orgStructureId:curOrgStructureId};
			dwr.TOPEngine.setAsync(false);
			OrganizationAction.readOrganizationVO(obj,function(resultData){
				cui(orgJsonData).databind().setValue(resultData);
				curCode=resultData.orgCode;
				if(resultData.areaId==0){ // Ϊ0ʱ����ʾֵ
					orgJsonData.areaId="";
    			}
				
			});
			parentNodeName = " ";
			cui(orgJsonData).databind().set('parentOrgName'," ");
			//��չ���Գ�ʼֵ������
    		OrganizationAction.queryOrgExtendValue(obj,function(data){
    			if(data){
	    			setAttribute(data);
    			}
    		});
			dwr.TOPEngine.setAsync(true);
		}else{//ѡ�������ͨ�ڵ�
			cui('#button_save').hide();
			cui('#cancel').hide();
			cui('#buttonGroup').show();
			cui('#addSiblingBtn').show();
			cui('#addChildBtn').show();
			cui('#editBtn').show();
			cui('#disableBtn').show();
			dwr.TOPEngine.setAsync(false);
			var orgObj = {orgId:curOrgId,orgStructureId:curOrgStructureId};
			OrganizationAction.readOrganizationVO(orgObj,function(data){//��֯��Ϣ
				cui(orgJsonData).databind().setValue(data);
				curCode=data.orgCode;
				if(data.areaId==0){ // Ϊ0ʱ����ʾֵ
					orgJsonData.areaId="";
    			}
			});
			
			var parentObj = {orgId:parentNodeId,orgStructureId:curOrgStructureId};
			OrganizationAction.readOrganizationVO(parentObj,function(data){//���ڵ���Ϣ
				parentNodeName = data.orgName;
				parentNodeCode = data.orgCode;
				cui(orgJsonData).databind().set('parentOrgName',parentNodeName);
				cui(orgJsonData).databind().set('parentNodeCode',parentNodeCode);
			});
			//��չ���Գ�ʼֵ������
			OrganizationAction.queryOrgExtendValue(orgObj,function(data){
				if(data){
    				setAttribute(data);
				}
    		});
			dwr.TOPEngine.setAsync(true);
		}
		
		//�޸���֤����̬�޸�
		 if(curOrgStructureId=='A'){ 
			  validateSub=[{'type':'custom','rule':{'against':'isNullCode','m':'��֯�����׺����Ϊ�ա�'}},{'type':'custom','rule':{'against':'codeLength','m':'��֯�����׺����Ϊ2λ��'}},{'type':'custom','rule':{'against':'isExsitCode','m':'����֯�����Ѵ��ڡ�'}},{'type':'custom','rule':{'against':'isCodeForA','m':'��֯�����׺ֻ��Ϊ���֡�'}}];
			  validateRoot=[{'type':'custom','rule':{'against':'isNullCodeRoot','m':'��֯���벻��Ϊ�ա�'}},{'type':'custom','rule':{'against':'codeLengthRoot','m':'��֯�������Ϊ2λ��'}},{'type':'custom','rule':{'against':'isExsitCodeRoot','m':'����֯�����Ѵ��ڡ�'}},{'type':'custom','rule':{'against':'isCodeForA','m':'��֯����ֻ��Ϊ���֡�'}}];
		  }else if(curOrgStructureId=='B'){ 
			  validateSub=[{'type':'custom','rule':{'against':'isNullCode','m':'��֯�����׺����Ϊ�ա�'}},{'type':'custom','rule':{'against':'codeLength','m':'��֯�����׺����Ϊ2λ��'}},{'type':'custom','rule':{'against':'isExsitCode','m':'����֯�����Ѵ��ڡ�'}},{'type':'custom','rule':{'against':'isCodeForB','m':'��֯�����׺ֻ��ΪӢ�Ļ����֡�'}}];
			  validateRoot=[{'type':'custom','rule':{'against':'isNullCodeRoot','m':'��֯���벻��Ϊ�ա�'}},{'type':'custom','rule':{'against':'codeLengthRoot','m':'��֯�������Ϊ2λ��'}},{'type':'custom','rule':{'against':'isExsitCodeRoot','m':'����֯�����Ѵ��ڡ�'}},{'type':'custom','rule':{'against':'isCodeForB','m':'��֯����ֻ��ΪӢ�Ļ����֡�'}}];
		  }
	}

	/**
	 data ��������չ����
	*/
	function setAttribute(dataResult){
		cui(orgJsonData).databind().set('attribute_1',dataResult.attribute_1);
		cui(orgJsonData).databind().set('attribute_2',dataResult.attribute_2);
		cui(orgJsonData).databind().set('attribute_3',dataResult.attribute_3);
		cui(orgJsonData).databind().set('attribute_4',dataResult.attribute_4);
		cui(orgJsonData).databind().set('attribute_5',dataResult.attribute_5);
		cui(orgJsonData).databind().set('attribute_6',dataResult.attribute_6);
		cui(orgJsonData).databind().set('attribute_7',dataResult.attribute_7);
		cui(orgJsonData).databind().set('attribute_8',dataResult.attribute_8);
		cui(orgJsonData).databind().set('attribute_9',dataResult.attribute_9);
		cui(orgJsonData).databind().set('attribute_10',dataResult.attribute_10);
		cui(orgJsonData).databind().set('attribute_11',dataResult.attribute_11);
		cui(orgJsonData).databind().set('attribute_12',dataResult.attribute_12);
		cui(orgJsonData).databind().set('attribute_13',dataResult.attribute_13);
		cui(orgJsonData).databind().set('attribute_14',dataResult.attribute_14);
		cui(orgJsonData).databind().set('attribute_15',dataResult.attribute_15);
		cui(orgJsonData).databind().set('attribute_16',dataResult.attribute_16);
		cui(orgJsonData).databind().set('attribute_17',dataResult.attribute_17);
		cui(orgJsonData).databind().set('attribute_18',dataResult.attribute_18);
		cui(orgJsonData).databind().set('attribute_19',dataResult.attribute_19);
		cui(orgJsonData).databind().set('attribute_20',dataResult.attribute_20);
	}
	
	//��ʼ����չ���ԵĶ�̬���ṹ
	function initExtendAttrData(){
		dwr.TOPEngine.setAsync(false);
		var obj = {orgStructureId:curOrgStructureId,orgId:curOrgId};
		OrganizationAction.producePageCUI(obj,function(data){
			if(data.length == 0){
				$('#extendFieldForEdit').hide();
				$('#divTitleForExtend').hide();
			}else{
				for(var i=0;i<data.length;i++){
					var obj=data[i];
					if(obj.datasource!=null&&obj.datasource!=''){
						 //���ַ���תjson��ʽ
						obj.datasource = jQuery.parseJSON(obj.datasource); 
					}
				}
                 //��̬������
				cui('#extendFieldForEdit').customform({
					datasource:data
				});
				//������չ���Էǿ���֤
				var validate = window.validater;//comtop.UI.scan()��ǰʹ�����ַ���
				for(var i=0;i<data.length;i++){
					var obj=data[i];
					if(obj.required == true){
						validate.add(obj.id,'required',{m:obj.label+'����Ϊ�ա�'});
				 	}
				}
			}
	 	});
		dwr.TOPEngine.setAsync(true);
	}
	function checkLength(text){
		var len = text.length;
		if(len > 50){
			return false;
		}else{
			return true;
		}
	}
	
	/**
	* �༭ 
	*/
	function showEdit(){
		comtop.UI.scan.setReadonly(false);
		//���ò���ģʽ
		operationType = 4;//�༭��֯
		editInit();
		var orgCode = orgJsonData.orgCode;
		//�����֯����Ϊ�յ����
		if(!orgCode){
			orgCode = "";
		}
		if(parentNodeId == '-1'){
			cui("#parentCode").setValue("");
			cui("#subCodeRoot").setValue(orgCode.substr(orgCode.length-2,orgCode.length));
			cui("#subCode").setValue("");
			cui("#code").setValue("");
			
			cui('#parentCode').hide();
			cui('#subCodeRoot').show();
			cui('#subCode').hide();
		}else{
			cui("#parentCode").setValue(orgCode.substr(0,orgCode.length-2));
			cui("#subCodeRoot").setValue("");
			cui("#subCode").setValue(orgCode.substr(orgCode.length-2,orgCode.length));
			cui(orgJsonData).databind().set('subCode',orgCode.substr(orgCode.length-2,orgCode.length));
			cui("#code").setValue("");
			cui('#parentCode').show();
			cui('#subCodeRoot').hide();
			cui('#subCode').show();
		}
		cui('#code').hide();
		orgTypeQueryId = parentNodeId;
		editable = 1;
		//��������ʾ
        $('.top_required').show();
        $('.td_required').show();
        
   	 //ȫ�ֻ�����Ϣֻ��20150330��ӻ�����Ϣ���εĹ���
   	  if(isHideSystemBtn== 'true'){  //true ������Ϣ���ɱ༭,��׺����ɱ༭����չ���Կɱ༭
   	     comtop.UI.scan.setReadonly(true, $('#editTable'));
 		 cui('#subCode').setReadOnly(false);
		 cui('#subCodeRoot').setReadOnly(false);
	      }else{  //�ܿ��عرպ���isHideSystemBtnInUserOrgΪ׼   20150429���
	    	  if(isHideSystemBtnInUserOrg== 'true'){ //true ������Ϣ���ɱ༭����չ���Կɱ༭
	    		     comtop.UI.scan.setReadonly(true, $('#editTable'));
	    	 		 cui('#subCode').setReadOnly(false);
	    			 cui('#subCodeRoot').setReadOnly(false);
			      }
	      }
	}
	function editInit(){
		//����Ϊ�ɱ༭ 
		//���ÿ���ʾ�İ�ť��
		cui('#button_save').show();
		cui('#cancel').show();
		cui('#buttonGroup').hide();
		cui('#addSiblingBtn').hide();
		cui('#addChildBtn').hide();
		cui('#editBtn').hide();
		cui('#disableBtn').hide();
		//���ø���֯�����Ա༭
		cui('#parentOrgName').setReadOnly(true);
		cui('#parentCode').setReadOnly(true);
	}
	/**
 	*  ȡ���༭������
	*/
	function cancel(){
		window.parent.cancelLoad(parentNodeId,curOrgId,curName);	
	}

	/**
	* ������
	*/
	function addRoot(){
		comtop.UI.scan.setReadonly(false);
		operationType = 1;//������
		//���ҳ������
		$(":input").val("");
		editInit();
		//����������Ҫȡ����ť
		cui('#cancel').hide();
		cui("#parentNodeId").setValue("-1");
		cui("#parentOrgName").setValue(parentNodeName);
		cui("#sortNo").setValue(0);
		cui('#parentCode').hide();
		cui('#subCode').hide();
		cui('#subCodeRoot').show();
		cui('#code').hide();
		//��������ʾ
        $('.top_required').show();
        $('.td_required').show();
        //�жϸ��ڵ��Ƿ���ڣ�Ϊ�˽���ӵ��ĳ�ʱ֮�󷵻ص�ҳ���Ͻ��еĲ���
        dwr.TOPEngine.setAsync(false);
    	OrganizationAction.queryRootIdByOrgStructureId(curOrgStructureId,function(rootId){
			if(rootId){
				window.parent.cui.alert("�Ѿ����ڸ���֯��");
				comtop.UI.scan.setReadonly(true);
				cui('#button_save').hide();
				cui('#cancel').hide();
				//����������
		        $('.top_required').hide();
		        $('.td_required').hide();
			}else{
				window.validater.disValid('subCode',true);
			}			    		
    	});
		dwr.TOPEngine.setAsync(true);
	}

	/**
	* �����¼�
	*/
	function showAddChildEdit(){
		comtop.UI.scan.setReadonly(false);
		//���ò���ģʽ
		operationType = 3;//�����¼�
		//���ҳ������
		cui(orgJsonData).databind().setEmpty();
		//���ð�ť��ʾ���
		editInit();
		cui("#parentNodeId").setValue(curOrgId);
		cui("#parentCode").setValue(curCode);
		cui("#parentOrgName").setValue(curName);
		cui('#parentCode').show();
		cui('#subCode').show();
		cui('#subCodeRoot').hide();
		cui('#code').hide();
		//��������ʾ
        $('.top_required').show();
        $('.td_required').show();
        
        //���������λ����
        cui("#subCode").setValue(creatRandomCode(curOrgId));
        
	}
	
	// ���������λ���ֲ����ڵ�ǰ���ڵ���Ψһ
	function creatRandomCode(pOrgId){
		var randomCode;
		var subCodes=[];
        var randomCode= generateMixed(2);
		   //��ȡ��ǰ�������µ������ӱ���ĺ���λ
			dwr.TOPEngine.setAsync(false);		
			OrganizationAction.getSubOrgCodeByParentOrgId(pOrgId,function(data){
				   subCodes=data;
			});
			dwr.TOPEngine.setAsync(true);
			
	   if(subCodes.length!=0){
		   var bFlag = true;
		    var iNum =0;
			while(bFlag){
		        randomCode = generateMixed(2);
		        if($.inArray(randomCode, subCodes)=='-1' ){
		        	//û���ҵ����˳�
		        	bFlag =false;
		        }
		        iNum++;
		       if(curOrgStructureId=='A'&&iNum>100){
		    	       //1-99����ռ�ã�Ĭ�ϸ�00
		        		randomCode='00';
		        		break;
		        	}
		      if(curOrgStructureId=='B'&&iNum>1000){
		        		randomCode='00';
		        		break;
		        	}
				}
	     }else{
	    	 randomCode= generateMixed(2);
	     }
		return randomCode;
	}
	
	
	//�����������λ���֣�������ĸ��������ϣ����ִ�Сд��
	var charsA = ['0','1','2','3','4','5','6','7','8','9'];
	var charsB = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','l','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];
   function generateMixed(n) {
        var res = "";
        for(var i = 0; i < n ; i ++) {
            if(curOrgStructureId=='A'){ 
            	 var id = Math.ceil(Math.random()*9);
            	 res += charsA[id];
			  }else if(curOrgStructureId=='B'){ 
				  var id = Math.ceil(Math.random()*61);
				  res += charsB[id];
			  }
        }
        return res;
   }
	
	/**
	* ����ͬ��
	*/
	function showAddSiblingEdit(){
		comtop.UI.scan.setReadonly(false);
		//���ò���ģʽ
		operationType = 2;//����ͬ�� 
		//���ҳ������
		cui(orgJsonData).databind().setEmpty();
		//���ð�ť��ʾ���
		editInit();
		cui("#parentNodeId").setValue(parentNodeId);
		cui("#parentCode").setValue(parentNodeCode);
		cui("#parentOrgName").setValue(parentNodeName);
		cui('#parentCode').show();
		cui('#subCode').show();
		cui('#subCodeRoot').hide();
		cui('#code').hide();
		//��������ʾ
        $('.top_required').show();
        $('.td_required').show();
        //���������λ����
        cui("#subCode").setValue(creatRandomCode(parentNodeId));
	}
	
	/**
	* ���� 
	*/
	function save(){
		 var map = window.validater.validAllElement();//����ȫ����֤
         var inValid = map[0];
         var valid = map[1];
 		//��֤��Ϣ
 		if(inValid.length > 0){//��֤ʧ��
 			var str = "";
             for (var i = 0; i < inValid.length; i++) {
 				str += inValid[i].message + "<br />";
 			}
 		}else{
 			cui(orgJsonData).databind().set('orgStructureId', curOrgStructureId);
			var code;
			if(orgJsonData.subCode&&orgJsonData.subCode!= ""){
				code = cui("#parentCode").getValue()+orgJsonData.subCode;
			}else if(orgJsonData.subCodeRoot!= ""){
				code = orgJsonData.subCodeRoot;
			}
			cui(orgJsonData).databind().set('orgCode',code);
			if(operationType == 4){//�༭ 
				dwr.TOPEngine.setAsync(false);	
				OrganizationAction.updateOrganization(orgJsonData,function(data){
					if(data && data.orgId){
						curName = data.orgName;
						//�����֯����
						cui("#code").setValue(data.orgCode);
						initData();
						window.parent.sychronizeUpdateTree(data.orgId,data.orgName);
						window.parent.cui.message("��֯�޸ĳɹ���","success");
					}else{
						window.parent.cui.alert("��֯�޸�ʧ�ܡ�");
					}
				});
				dwr.TOPEngine.setAsync(true);
				$('.cui_ext_textmode').attr('cui_ext_textmode');
				comtop.UI.scan.setReadonly(true, $('#editDiv'));
			}else{//����
				dwr.TOPEngine.setAsync(false);		
				OrganizationAction.addOrganization(orgJsonData,function(data){
					if(data && data.orgId){
						curOrgId  = data.orgId;
						curName = data.orgName;
						parentNodeId  = data.parentOrgId;
						initData();
						window.parent.sychronizeAddTree(data.parentOrgId,data.orgName,data.orgId,operationType,data.sortNo);	//��ֱ�Ӵ���data���飬������ҳ��ָ�����
						window.parent.cui.message("��֯�����ɹ���","success");
					}else{
						window.parent.cui.alert("��֯����ʧ�ܡ�");
					}
				});
				dwr.TOPEngine.setAsync(true);
				comtop.UI.scan.setReadonly(true);
			}
 		}
	}
	/**
	* ע����֯
	*/
	function batchDisable(){
		//��ѯ�Ƿ����ע�����޸��ڵ�͸��ڵ�ʱ��ע����ť����ʾ��
		// ��ʾ�Ƿ�ע��
		var obj = {orgId:curOrgId,orgStructureId:curOrgStructureId};
		dwr.TOPEngine.setAsync(false);
		OrganizationAction.canBeDelete(obj,function(data){
			if(!data){
				cui.alert("��֯�´�����Ա������֯����λʱ����ע��");
				return;
			}else{
				cui.confirm("ȷ��Ҫע����֯<font color='red'>"+curName+"</font>��",{
					onYes:function(){
					OrganizationAction.deleteOrganization(obj,function(){
						//ˢ���������
						window.parent.sychronizeDeleteTree(orgJsonData.orgId,orgJsonData.parentOrgId);	
					});
				  	}
				});
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	//���ز��ŵ���ģ��
	function downDeptModel(){
		var url = "${pageScope.cuiWebRoot}/top/sys/organization/downloadOrgImportTemplate.ac";
	    window.open(url,'_self');
	}

	//����������Ϣ
	function exportDept(){
		var url = "${pageScope.cuiWebRoot}/top/sys/organization/organizationExport.ac?orgId="+curOrgId+"&orgStructureId="+curOrgStructureId+"&parentOrgId="+parentNodeId;
		location.href = url;
	}

	//��֯����
	function ExcelImport(){
		 var vWidth =450;
		 var vHeight =180;
		 var vTopPos =(window.screen.height-180)/2;
		 var vLeftPos =(window.screen.width-450)/2;
		 var vHeight =180;
		 var params = curOrgId+":"+curOrgStructureId+":"+curCode;
		 var sFeatures = "width="+vWidth+",height="+vHeight+",help=no,resizable=no,menu=no,toolbar=no,status=no,left="+vLeftPos+",top="+vTopPos;
		 var win = window.open("${pageScope.cuiWebRoot}/excelImportServlet.topExcelImportServlet?actionType=excelImport&configName=excel.xml&callback=excelImportCallBack&excelId=organizationImport&param="+params, "ExcelImportWindow", sFeatures);
		 if(win) { win.focus();}
	}

	//��֯����ص�����
	function excelImportCallBack() {
		window.parent.importCallBack();
	}
	 
    //��ְ֯��
    var initOrgDuty=[{id:"ְ����֯",text:"ְ����֯"},
                    {id:"������֯",text:"������֯"},
                    {id:"������֯",text:"������֯"}];
	/**
	* �����׺����Ϊ��
	*/
	function isNullCode(val){
		if(operationType == 1 || orgJsonData.parentOrgId== '-1'){//���ڵ�
			return true;
		}else{
			if(val){
				return true;
			}
			return false;
		}
	}

	/**
	* ���벻��Ϊ��
	*/
	function isNullCodeRoot(){
		if(operationType == 1 || orgJsonData.parentOrgId == '-1'){//���ڵ�
			if(orgJsonData.subCodeRoot&&orgJsonData.subCodeRoot!= ""){
				return true;
			}
			return false;
		}else{
			return true;
		}
	}

	/**
	* �����׺Ϊ2λ
	*/
	function codeLength(val){
		if(operationType == 1 || orgJsonData.parentOrgId == '-1'){
			return true;
		}else{
			if(val != "" && val.length != 2){
				return false;
			}if(val== ""){
				return false;
			}
			return true;
		}
	}

	/**
	* �����׺Ϊ2λ
	*/
	function codeLengthRoot(){
		if(operationType == 1 || orgJsonData.parentOrgId == '-1'){
			if(orgJsonData.subCodeRoot!= "" &&orgJsonData.subCodeRoot.length != 2){
				return false;
			}if(orgJsonData.subCodeRoot== ""){
				return false;
			}
			return true;
		}else{
			return true;
		}
	}

	
	
	
	/**
	* ���ڵ����ΪӢ�Ļ�����
	*/
	function isCodeForA(){
		var code;
		var reg;
		if(operationType == 1 || orgJsonData.parentOrgId == '-1'){
			code = orgJsonData.subCodeRoot;
			reg = new RegExp("^[0-9]+$");
		}else{
			code = cui("#subCode").getValue();
			reg = new RegExp("^[0-9]+$");
		}
		return (reg.test(code));
	}
	
	/**
	* ���ڵ����ΪӢ�Ļ�����
	*/
	function isCodeForB(){
		var code;
		var reg;
		if(operationType == 1 || orgJsonData.parentOrgId == '-1'){
			code = orgJsonData.subCodeRoot;
			reg = new RegExp("^[A-Za-z0-9]+$");
		}else{
			code = cui("#subCode").getValue();
			reg = new RegExp("^[A-Za-z0-9]+$");
		}
		return (reg.test(code));
	}

	/**
	* ���벻���ظ�
	*/
	function isExsitCode(){
		if(operationType == 1 ||orgJsonData.parentOrgId== '-1'){
			return true;
		}else{
			var code =orgJsonData.parentCode+orgJsonData.subCode;
			var flag = true;
			if(orgJsonData.subCode!= ""){
				dwr.TOPEngine.setAsync(false);
				var obj = {orgCode:code,orgId:orgJsonData.orgId,orgStructureId:curOrgStructureId};
				OrganizationAction.isExsitCode(obj,function(data){
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
	}

	/**
	* ���벻���ظ�
	*/
	function isExsitCodeRoot(){
		if(operationType == 1 || orgJsonData.parentOrgId == '-1'){
			var code = orgJsonData.parentCode+orgJsonData.subCodeRoot;
			var flag = true;
			if(orgJsonData.subCodeRoot!= ""){
				dwr.TOPEngine.setAsync(false);
				var obj = {orgCode:code,orgId:orgJsonData.orgId,orgStructureId:curOrgStructureId};
				OrganizationAction.isExsitCode(obj,function(data){
					if(data){
							flag = false;
					}else{
							flag = true;
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
			return flag;
			
		}else{
			return true;
		}
	}

	/**
	* ͬһ��֯�²�������
	*/
	function isExsitOrgName(){ 
		var name =orgJsonData.orgName;
		var flag = true;
		if(name != ""){
			dwr.TOPEngine.setAsync(false);
			var obj = {orgName:name,parentOrgId:orgJsonData.parentOrgId,orgId:orgJsonData.orgId,orgStructureId:curOrgStructureId};
			OrganizationAction.isExsitOrgName(obj,function(data){
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
	function isNameContainSpecial(){
		var name = orgJsonData.orgName;
		//������ ����() �� ��Ӣ�� ���� _-
		var reg = new RegExp("^[\uff08 \uff09 \u0028 \u0029 \u3001 \u4E00-\u9FA5A-Za-z0-9_-]+$");
		return (reg.test(name));
		 
	}

	/*
	* �ж����������Ƿ�Ϊ����
	*/
	function isAreaIdInteger(){
		var areaId = orgJsonData.areaId;
		var reg = new RegExp("^[0-9]+$");
		if(areaId)
			return (reg.test(areaId));
		else
			return true;
	}

	/*
	* �ж�����������������ַ�
	*/
	function isAreaNull(){
		var areaId = $g("databind").get("areaId");
		var stop = false;
		if(areaId != ""){
			for( i = 0; i < areaId.length; i ++ ){
				if(areaId.charAt(i) != 0 && !stop){
					areaId = areaId.substr(i);
					stop = true;
				}
			}
		}
		if(areaId != "" && (!parseInt(areaId) || parseInt(areaId) ==0 )){
			$g("databind").set("areaId","");
			return false;
		}
		cui("#areaId").setValue(areaId);
		return true;
	}
	

	
   </script>
</head>
<body>
<div class = "top">
<div class="top_header_wrap">
	 <div class="divTitle">
	 	������Ϣ
	 </div>
	 <div class="thw_operate">
	 	<top:verifyAccess pageCode="TopOrgAdmin" operateCode="updateOrg">
	 	<% if(!isHideSystemBtn){ %>
	 	      <% if(!isHideSystemBtnInUserOrg){ %>
			<span uitype="button" id="addChildBtn" label="�����¼���֯" on_click="showAddChildEdit"></span>
			<span uitype="button" id="addSiblingBtn" label="����ͬ����֯" on_click="showAddSiblingEdit"></span>
			  <% } %>
	     <% } %>
			<span uitype="button" id="editBtn" label="�༭" on_click="showEdit"></span>
	     <% if(!isHideSystemBtn){ %>
	          <% if(!isHideSystemBtnInUserOrg){ %>
			<span uitype="button" id="disableBtn" label="ע��" on_click="batchDisable"></span>
		        <% } %>
		 <% } %>	
		</top:verifyAccess>
		<% if(!isHideSystemBtn){ %>
		     <% if(!isHideSystemBtnInUserOrg){ %>
		<span uitype="button" id="buttonGroup" label="���뵼��" menu="buttondata"></span>
		      <% } %>
		 <% } %>	
		 <% if(isHideSystemBtn){ %>
		      <% if(!isHideSystemBtnInUserOrg){ %>
		<span uitype="button" id="buttonGroup" label="������֯��Ϣ" on_click="exportDept"></span>
		     <% } %>
		 <% } %>	
		<span uitype="button" id="button_save" label="����" on_click="save"></span>
		<span uitype="button" id="cancel" label="ȡ��" on_click="cancel"></span>
	 </div>
</div>
</div>
<div class="main">
 <div class="top_content_wrap cui_ext_textmode" id="editDiv">
     <table id="editTable"  class="form_table" style="table-layout:fixed;">
     <colgroup>
     	<col width="15%"/>
     	<col width="35%"/>
     	<col width="15%"/>
     	<col width="35%"/>
     </colgroup>
        <tr>         
			<td class="td_label" width="15%"><span class="top_required">*</span>��֯���ƣ�</td>
			<td>
				<span uitype="input" id="name" name="orgName" databind="orgJsonData.orgName" maxlength="100" width="90%" validate="[{'type':'required', 'rule':{'m': '��֯���Ʋ���Ϊ�ա�'}},{'type':'custom','rule':{'against':'isNameContainSpecial','m':'��֯����ֻ��Ϊ��Ӣ�ģ����ֻ򣨣�() �� _ -��'}},{'type':'custom','rule':{'against':'isExsitOrgName','m':'ͬһ��֯�¸������Ѵ��ڡ�'}}]"></span>
			</td>
			<span uitype="input" id="sortNo" name="sortNo" databind="orgJsonData.sortNo"></span>
			<span uitype="input" id="parentNodeId" name="parentOrgId"  databind="orgJsonData.parentOrgId"></span>
			<span uitype="input" id="orgId" name="orgId" databind="orgJsonData.orgId"></span>
		    
		    <td class="td_label" width="15%"><span class="top_required">*</span>��֯���룺</td>
			<td>
			 <span uitype="input" name="orgCode" id="code" databind="orgJsonData.orgCode" width="90%" ></span>
			 <span uitype="input" name="parentCode" readonly="true" id="parentCode" databind="orgJsonData.parentCode" width="44%" ></span>
			 <span uitype="input" name="subCode" id="subCode" databind="orgJsonData.subCode"  maxlength="2" width="45%"  validate="validateSub"></span>
			 <span uitype="input" name="subCodeRoot" id="subCodeRoot" databind="orgJsonData.subCodeRoot" width="90%"  maxlength="2" validate="validateRoot"></span>
			</td>
		</tr>
		
		 <tr>         
		    <td class="td_label" ><span class="top_required">*</span>��֯���ͣ�</td>
			<td >
			  <span uitype="singlePullDown" id="orgType" name="orgType" databind="orgJsonData.orgType" datasource="initOrgTypeData" empty_text="" width="90%"
			  	editable="false" label_field="orgTypeName" value_field="orgType" validate="[{'type':'required', 'rule':{'m': '��֯���Ͳ���Ϊ�ա�'}}]"></span>
			</td>
			<td class="td_label"><span class="top_required">*</span>��֯���ʣ�</td>
			<td >
				<span uitype="singlePullDown" id="orgProperty" name="orgProperty" databind="orgJsonData.orgProperty" datasource="initOrgPropertyData" empty_text="" width="90%"
			  	  editable="false" label_field="orgPropertyName" value_field="orgProperty" validate="[{'type':'required', 'rule':{'m': '��֯���ʲ���Ϊ�ա�'}}]"></span>
            </td>
			
		</tr>
		
		 <tr>   
		    <td class="td_label" >�ϼ���֯��</td>
			<td >
				<span uitype="input" id="parentOrgName" name="parentOrgName" databind="orgJsonData.parentOrgName" maxlength="50" width="90%"></span>
			</td>      
		    <td class="td_label" >ҵ����������</td>
			<td >
				<span uitype="input" id="flowArea" name="flowArea" databind="orgJsonData.flowArea" maxlength="20" width="90%"></span>
			</td>
		</tr>
		
		 <tr>         
		    <td class="td_label" >��������</td>
			<td >
				<span uitype="input" id="areaId" name="areaId" databind="orgJsonData.areaId" maxlength="9" width="90%" validate="[{'type':'custom', 'rule':{'against':'isAreaIdInteger','m':'�����������Ϊ������'}}]"></span>
			</td>
			<td class="td_label" >��֯���䣺</td>
			<td >
			   <span uitype="input" id="emailAddress" name="emailAddress" databind="orgJsonData.emailAddress" maxlength="25" width="90%" validate="[{'type':'email', 'rule':{'m': '��֯�����ʽ����ȷ��'}}]"></span>
			</td>
		</tr>
		 <tr>         
			<td class="td_label" >�ӿ�������</td>
			<td >
			   <span uitype="input" id="childControlArea" name="childControlArea" databind="orgJsonData.childControlArea" maxlength="15" width="90%"></span>
			</td>
		    <td class="td_label">��ְ֯��</td>
			<td >
			  <span uitype="singlePullDown" id="orgDuty" name="orgDuty" databind="orgJsonData.orgDuty"  datasource="initOrgDuty" width="90%"
			  	editable="false" label_field="text" value_field="id" empty_text=""></span>
			</td>
		</tr>
		<tr>
			<td class="td_label" >��׼��֯���룺</td>
			<td >
			   <span uitype="input" id="baseOrgCode" name="baseOrgCode" databind="orgJsonData.baseOrgCode" maxlength="40" width="90%"></span>
			</td>
			<td class="td_label" ></td>
			<td >
			</td>
		</tr>
		<tr>
		    <td class="td_label" valign="top">������</td>
			<td colspan="3">
				<div>
					<span uitype="textarea" id="note" name="note" width="95%" databind="orgJsonData.note"  height="80px" maxlength="100" ></span>
				</div>
			</td>
		</tr>
	 </table>
<div class="divTitleForExtend" id="divTitleForExtend">��չ����</div>
<div id="extendFieldForEdit"></div>	
</div>
</div>
</div>
</body>
</html>
