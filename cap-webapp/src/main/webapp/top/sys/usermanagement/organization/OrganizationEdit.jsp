<%
/**********************************************************************
* 组织基本信息维护
* 2014-07-02 汪超  新建
**********************************************************************/
%>

<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="com.comtop.top.sys.usermanagement.user.util.UomCommonUtil" %>
<%		
	//是否隐藏系统人员组织功能按钮 true 隐藏 false 不隐藏
    boolean isHideSystemBtnInUserOrg = UomCommonUtil.getHideSystemBtnInUserOrgCfg();
%>
<html>
<head>
<title>组织信息维护</title>
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
            padding-top:35px;  /*上部设置为50px*/
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
            height:38px;  /*高度和padding设置一样*/
            margin-top: -35px; /*值和padding设置一样*/                     
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
	//新增根=1  新增同级=2  新增下级=3 编辑组织=4
	var operationType = 0;
	var editable = 0;
	var orgTypeQueryId = parentNodeId;
	//表单绑定的对象
	var orgJsonData={};
	//验证规则
    var  validateSub="";
    var  validateRoot="";
    
    //是否隐藏系统功能按钮 true 隐藏 false 不隐藏
	var isHideSystemBtn = '<%=isHideSystemBtn %>';
	 //是否隐藏系统人员组织功能按钮 true 隐藏 false 不隐藏
	var isHideSystemBtnInUserOrg = '<%=isHideSystemBtnInUserOrg %>';
 	
 	var buttondata = {
 	    	datasource: [
 	            {id:'exportDeptBtn',label:'导出组织信息'},
 	            {id:'downDeptModelBtn',label:'下载模板'},
 	            {id:'im',label:'导入组织信息'}
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
 	//初始化组织类型下拉框
 	function initOrgTypeData(obj){
 		dwr.TOPEngine.setAsync(false);
	 		OrganizationAction.getOrgTypeInfo(function(resultData){
				obj.setDatasource(jQuery.parseJSON(resultData));
			});
 		dwr.TOPEngine.setAsync(true);
 	}
 	var initOrgPropertyData = [
 	       {orgProperty:'1',orgPropertyName:'行政组织'},                    
 	       {orgProperty:'2',orgPropertyName:'虚拟组织'}                    
 	    ];
	window.onload = function(){
		initData();
		comtop.UI.scan();
		//初始化扩展属性的动态表单
		initExtendAttrData();
		comtop.UI.scan.setReadonly(true);
		//必填项隐藏
        $('.top_required').hide();
        $('.td_required').hide();
		if(parentNodeId == ''){//无根节点
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
	*  页面加载时初始化按钮和数据
	*/
	function initData(){
		//页面加载时隐藏文本框
		cui('#sortNo').hide();
		cui('#parentNodeId').hide();
		cui('#orgId').hide();
		cui('#parentCode').hide();
		cui('#subCode').hide();
		cui('#subCodeRoot').hide();
		cui('#code').show();
		if(parentNodeId == ''){//无根节点
			return;
		}else if(parentNodeId == '-1' || isRootNode == 'true'){//选中的为根节点
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
				if(resultData.areaId==0){ // 为0时不显示值
					orgJsonData.areaId="";
    			}
				
			});
			parentNodeName = " ";
			cui(orgJsonData).databind().set('parentOrgName'," ");
			//扩展属性初始值的设置
    		OrganizationAction.queryOrgExtendValue(obj,function(data){
    			if(data){
	    			setAttribute(data);
    			}
    		});
			dwr.TOPEngine.setAsync(true);
		}else{//选择的是普通节点
			cui('#button_save').hide();
			cui('#cancel').hide();
			cui('#buttonGroup').show();
			cui('#addSiblingBtn').show();
			cui('#addChildBtn').show();
			cui('#editBtn').show();
			cui('#disableBtn').show();
			dwr.TOPEngine.setAsync(false);
			var orgObj = {orgId:curOrgId,orgStructureId:curOrgStructureId};
			OrganizationAction.readOrganizationVO(orgObj,function(data){//组织信息
				cui(orgJsonData).databind().setValue(data);
				curCode=data.orgCode;
				if(data.areaId==0){ // 为0时不显示值
					orgJsonData.areaId="";
    			}
			});
			
			var parentObj = {orgId:parentNodeId,orgStructureId:curOrgStructureId};
			OrganizationAction.readOrganizationVO(parentObj,function(data){//父节点信息
				parentNodeName = data.orgName;
				parentNodeCode = data.orgCode;
				cui(orgJsonData).databind().set('parentOrgName',parentNodeName);
				cui(orgJsonData).databind().set('parentNodeCode',parentNodeCode);
			});
			//扩展属性初始值的设置
			OrganizationAction.queryOrgExtendValue(orgObj,function(data){
				if(data){
    				setAttribute(data);
				}
    		});
			dwr.TOPEngine.setAsync(true);
		}
		
		//修改验证规则动态修改
		 if(curOrgStructureId=='A'){ 
			  validateSub=[{'type':'custom','rule':{'against':'isNullCode','m':'组织编码后缀不能为空。'}},{'type':'custom','rule':{'against':'codeLength','m':'组织编码后缀必须为2位。'}},{'type':'custom','rule':{'against':'isExsitCode','m':'该组织编码已存在。'}},{'type':'custom','rule':{'against':'isCodeForA','m':'组织编码后缀只能为数字。'}}];
			  validateRoot=[{'type':'custom','rule':{'against':'isNullCodeRoot','m':'组织编码不能为空。'}},{'type':'custom','rule':{'against':'codeLengthRoot','m':'组织编码必须为2位。'}},{'type':'custom','rule':{'against':'isExsitCodeRoot','m':'该组织编码已存在。'}},{'type':'custom','rule':{'against':'isCodeForA','m':'组织编码只能为数字。'}}];
		  }else if(curOrgStructureId=='B'){ 
			  validateSub=[{'type':'custom','rule':{'against':'isNullCode','m':'组织编码后缀不能为空。'}},{'type':'custom','rule':{'against':'codeLength','m':'组织编码后缀必须为2位。'}},{'type':'custom','rule':{'against':'isExsitCode','m':'该组织编码已存在。'}},{'type':'custom','rule':{'against':'isCodeForB','m':'组织编码后缀只能为英文或数字。'}}];
			  validateRoot=[{'type':'custom','rule':{'against':'isNullCodeRoot','m':'组织编码不能为空。'}},{'type':'custom','rule':{'against':'codeLengthRoot','m':'组织编码必须为2位。'}},{'type':'custom','rule':{'against':'isExsitCodeRoot','m':'该组织编码已存在。'}},{'type':'custom','rule':{'against':'isCodeForB','m':'组织编码只能为英文或数字。'}}];
		  }
	}

	/**
	 data 中设置扩展属性
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
	
	//初始化扩展属性的动态表单结构
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
						 //将字符串转json格式
						obj.datasource = jQuery.parseJSON(obj.datasource); 
					}
				}
                 //动态创建表单
				cui('#extendFieldForEdit').customform({
					datasource:data
				});
				//设置扩展属性非空验证
				var validate = window.validater;//comtop.UI.scan()在前使用这种方法
				for(var i=0;i<data.length;i++){
					var obj=data[i];
					if(obj.required == true){
						validate.add(obj.id,'required',{m:obj.label+'不能为空。'});
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
	* 编辑 
	*/
	function showEdit(){
		comtop.UI.scan.setReadonly(false);
		//设置操作模式
		operationType = 4;//编辑组织
		editInit();
		var orgCode = orgJsonData.orgCode;
		//解决组织编码为空的情况
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
		//必填项显示
        $('.top_required').show();
        $('.td_required').show();
        
   	 //全局基本信息只读20150330添加基本信息屏蔽的功能
   	  if(isHideSystemBtn== 'true'){  //true 基本信息不可编辑,后缀编码可编辑，扩展属性可编辑
   	     comtop.UI.scan.setReadonly(true, $('#editTable'));
 		 cui('#subCode').setReadOnly(false);
		 cui('#subCodeRoot').setReadOnly(false);
	      }else{  //总开关关闭后，以isHideSystemBtnInUserOrg为准   20150429添加
	    	  if(isHideSystemBtnInUserOrg== 'true'){ //true 基本信息不可编辑，扩展属性可编辑
	    		     comtop.UI.scan.setReadonly(true, $('#editTable'));
	    	 		 cui('#subCode').setReadOnly(false);
	    			 cui('#subCodeRoot').setReadOnly(false);
			      }
	      }
	}
	function editInit(){
		//设置为可编辑 
		//设置可显示的按钮组
		cui('#button_save').show();
		cui('#cancel').show();
		cui('#buttonGroup').hide();
		cui('#addSiblingBtn').hide();
		cui('#addChildBtn').hide();
		cui('#editBtn').hide();
		cui('#disableBtn').hide();
		//设置父组织不可以编辑
		cui('#parentOrgName').setReadOnly(true);
		cui('#parentCode').setReadOnly(true);
	}
	/**
 	*  取消编辑或新增
	*/
	function cancel(){
		window.parent.cancelLoad(parentNodeId,curOrgId,curName);	
	}

	/**
	* 新增根
	*/
	function addRoot(){
		comtop.UI.scan.setReadonly(false);
		operationType = 1;//新增根
		//清空页面数据
		$(":input").val("");
		editInit();
		//新增根不需要取消按钮
		cui('#cancel').hide();
		cui("#parentNodeId").setValue("-1");
		cui("#parentOrgName").setValue(parentNodeName);
		cui("#sortNo").setValue(0);
		cui('#parentCode').hide();
		cui('#subCode').hide();
		cui('#subCodeRoot').show();
		cui('#code').hide();
		//必填项显示
        $('.top_required').show();
        $('.td_required').show();
        //判断根节点是否存在，为了解决坑爹的超时之后返回到页面上进行的操作
        dwr.TOPEngine.setAsync(false);
    	OrganizationAction.queryRootIdByOrgStructureId(curOrgStructureId,function(rootId){
			if(rootId){
				window.parent.cui.alert("已经存在根组织。");
				comtop.UI.scan.setReadonly(true);
				cui('#button_save').hide();
				cui('#cancel').hide();
				//必填项隐藏
		        $('.top_required').hide();
		        $('.td_required').hide();
			}else{
				window.validater.disValid('subCode',true);
			}			    		
    	});
		dwr.TOPEngine.setAsync(true);
	}

	/**
	* 新增下级
	*/
	function showAddChildEdit(){
		comtop.UI.scan.setReadonly(false);
		//设置操作模式
		operationType = 3;//新增下级
		//清空页面数据
		cui(orgJsonData).databind().setEmpty();
		//设置按钮显示情况
		editInit();
		cui("#parentNodeId").setValue(curOrgId);
		cui("#parentCode").setValue(curCode);
		cui("#parentOrgName").setValue(curName);
		cui('#parentCode').show();
		cui('#subCode').show();
		cui('#subCodeRoot').hide();
		cui('#code').hide();
		//必填项显示
        $('.top_required').show();
        $('.td_required').show();
        
        //生成随机两位数字
        cui("#subCode").setValue(creatRandomCode(curOrgId));
        
	}
	
	// 生成随机两位数字并且在当前父节点下唯一
	function creatRandomCode(pOrgId){
		var randomCode;
		var subCodes=[];
        var randomCode= generateMixed(2);
		   //获取当前父编码下的所有子编码的后两位
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
		        	//没有找到，退出
		        	bFlag =false;
		        }
		        iNum++;
		       if(curOrgStructureId=='A'&&iNum>100){
		    	       //1-99都已占用，默认给00
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
	
	
	//生成随机的两位数字（可以字母和数字组合，区分大小写）
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
	* 新增同级
	*/
	function showAddSiblingEdit(){
		comtop.UI.scan.setReadonly(false);
		//设置操作模式
		operationType = 2;//新增同级 
		//清空页面数据
		cui(orgJsonData).databind().setEmpty();
		//设置按钮显示情况
		editInit();
		cui("#parentNodeId").setValue(parentNodeId);
		cui("#parentCode").setValue(parentNodeCode);
		cui("#parentOrgName").setValue(parentNodeName);
		cui('#parentCode').show();
		cui('#subCode').show();
		cui('#subCodeRoot').hide();
		cui('#code').hide();
		//必填项显示
        $('.top_required').show();
        $('.td_required').show();
        //生成随机两位数字
        cui("#subCode").setValue(creatRandomCode(parentNodeId));
	}
	
	/**
	* 保存 
	*/
	function save(){
		 var map = window.validater.validAllElement();//进行全局验证
         var inValid = map[0];
         var valid = map[1];
 		//验证消息
 		if(inValid.length > 0){//验证失败
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
			if(operationType == 4){//编辑 
				dwr.TOPEngine.setAsync(false);	
				OrganizationAction.updateOrganization(orgJsonData,function(data){
					if(data && data.orgId){
						curName = data.orgName;
						//填充组织编码
						cui("#code").setValue(data.orgCode);
						initData();
						window.parent.sychronizeUpdateTree(data.orgId,data.orgName);
						window.parent.cui.message("组织修改成功。","success");
					}else{
						window.parent.cui.alert("组织修改失败。");
					}
				});
				dwr.TOPEngine.setAsync(true);
				$('.cui_ext_textmode').attr('cui_ext_textmode');
				comtop.UI.scan.setReadonly(true, $('#editDiv'));
			}else{//新增
				dwr.TOPEngine.setAsync(false);		
				OrganizationAction.addOrganization(orgJsonData,function(data){
					if(data && data.orgId){
						curOrgId  = data.orgId;
						curName = data.orgName;
						parentNodeId  = data.parentOrgId;
						initData();
						window.parent.sychronizeAddTree(data.parentOrgId,data.orgName,data.orgId,operationType,data.sortNo);	//不直接传递data数组，会引起页面指针混乱
						window.parent.cui.message("组织新增成功。","success");
					}else{
						window.parent.cui.alert("组织新增失败。");
					}
				});
				dwr.TOPEngine.setAsync(true);
				comtop.UI.scan.setReadonly(true);
			}
 		}
	}
	/**
	* 注销组织
	*/
	function batchDisable(){
		//查询是否可以注销（无根节点和根节点时，注销按钮不显示）
		// 提示是否注销
		var obj = {orgId:curOrgId,orgStructureId:curOrgStructureId};
		dwr.TOPEngine.setAsync(false);
		OrganizationAction.canBeDelete(obj,function(data){
			if(!data){
				cui.alert("组织下存在人员、子组织、岗位时不能注销");
				return;
			}else{
				cui.confirm("确定要注销组织<font color='red'>"+curName+"</font>吗？",{
					onYes:function(){
					OrganizationAction.deleteOrganization(obj,function(){
						//刷新左侧树形
						window.parent.sychronizeDeleteTree(orgJsonData.orgId,orgJsonData.parentOrgId);	
					});
				  	}
				});
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	//下载部门导入模板
	function downDeptModel(){
		var url = "${pageScope.cuiWebRoot}/top/sys/organization/downloadOrgImportTemplate.ac";
	    window.open(url,'_self');
	}

	//导出部门信息
	function exportDept(){
		var url = "${pageScope.cuiWebRoot}/top/sys/organization/organizationExport.ac?orgId="+curOrgId+"&orgStructureId="+curOrgStructureId+"&parentOrgId="+parentNodeId;
		location.href = url;
	}

	//组织导入
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

	//组织导入回调函数
	function excelImportCallBack() {
		window.parent.importCallBack();
	}
	 
    //组织职责
    var initOrgDuty=[{id:"职能组织",text:"职能组织"},
                    {id:"生产组织",text:"生产组织"},
                    {id:"运行组织",text:"运行组织"}];
	/**
	* 编码后缀不能为空
	*/
	function isNullCode(val){
		if(operationType == 1 || orgJsonData.parentOrgId== '-1'){//根节点
			return true;
		}else{
			if(val){
				return true;
			}
			return false;
		}
	}

	/**
	* 编码不能为空
	*/
	function isNullCodeRoot(){
		if(operationType == 1 || orgJsonData.parentOrgId == '-1'){//根节点
			if(orgJsonData.subCodeRoot&&orgJsonData.subCodeRoot!= ""){
				return true;
			}
			return false;
		}else{
			return true;
		}
	}

	/**
	* 编码后缀为2位
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
	* 编码后缀为2位
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
	* 根节点编码为英文或数字
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
	* 根节点编码为英文或数字
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
	* 编码不能重复
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
	* 编码不能重复
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
	* 同一组织下不能重名
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
	* 判断名称是否包含特殊字符
	*/
	function isNameContainSpecial(){
		var name = orgJsonData.orgName;
		//可输入 （）() 、 中英文 数字 _-
		var reg = new RegExp("^[\uff08 \uff09 \u0028 \u0029 \u3001 \u4E00-\u9FA5A-Za-z0-9_-]+$");
		return (reg.test(name));
		 
	}

	/*
	* 判断行政区域是否为整数
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
	* 判断行政区域包含特殊字符
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
	 	基本信息
	 </div>
	 <div class="thw_operate">
	 	<top:verifyAccess pageCode="TopOrgAdmin" operateCode="updateOrg">
	 	<% if(!isHideSystemBtn){ %>
	 	      <% if(!isHideSystemBtnInUserOrg){ %>
			<span uitype="button" id="addChildBtn" label="新增下级组织" on_click="showAddChildEdit"></span>
			<span uitype="button" id="addSiblingBtn" label="新增同级组织" on_click="showAddSiblingEdit"></span>
			  <% } %>
	     <% } %>
			<span uitype="button" id="editBtn" label="编辑" on_click="showEdit"></span>
	     <% if(!isHideSystemBtn){ %>
	          <% if(!isHideSystemBtnInUserOrg){ %>
			<span uitype="button" id="disableBtn" label="注销" on_click="batchDisable"></span>
		        <% } %>
		 <% } %>	
		</top:verifyAccess>
		<% if(!isHideSystemBtn){ %>
		     <% if(!isHideSystemBtnInUserOrg){ %>
		<span uitype="button" id="buttonGroup" label="导入导出" menu="buttondata"></span>
		      <% } %>
		 <% } %>	
		 <% if(isHideSystemBtn){ %>
		      <% if(!isHideSystemBtnInUserOrg){ %>
		<span uitype="button" id="buttonGroup" label="导出组织信息" on_click="exportDept"></span>
		     <% } %>
		 <% } %>	
		<span uitype="button" id="button_save" label="保存" on_click="save"></span>
		<span uitype="button" id="cancel" label="取消" on_click="cancel"></span>
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
			<td class="td_label" width="15%"><span class="top_required">*</span>组织名称：</td>
			<td>
				<span uitype="input" id="name" name="orgName" databind="orgJsonData.orgName" maxlength="100" width="90%" validate="[{'type':'required', 'rule':{'m': '组织名称不能为空。'}},{'type':'custom','rule':{'against':'isNameContainSpecial','m':'组织名称只能为中英文，数字或（）() 、 _ -。'}},{'type':'custom','rule':{'against':'isExsitOrgName','m':'同一组织下该名称已存在。'}}]"></span>
			</td>
			<span uitype="input" id="sortNo" name="sortNo" databind="orgJsonData.sortNo"></span>
			<span uitype="input" id="parentNodeId" name="parentOrgId"  databind="orgJsonData.parentOrgId"></span>
			<span uitype="input" id="orgId" name="orgId" databind="orgJsonData.orgId"></span>
		    
		    <td class="td_label" width="15%"><span class="top_required">*</span>组织编码：</td>
			<td>
			 <span uitype="input" name="orgCode" id="code" databind="orgJsonData.orgCode" width="90%" ></span>
			 <span uitype="input" name="parentCode" readonly="true" id="parentCode" databind="orgJsonData.parentCode" width="44%" ></span>
			 <span uitype="input" name="subCode" id="subCode" databind="orgJsonData.subCode"  maxlength="2" width="45%"  validate="validateSub"></span>
			 <span uitype="input" name="subCodeRoot" id="subCodeRoot" databind="orgJsonData.subCodeRoot" width="90%"  maxlength="2" validate="validateRoot"></span>
			</td>
		</tr>
		
		 <tr>         
		    <td class="td_label" ><span class="top_required">*</span>组织类型：</td>
			<td >
			  <span uitype="singlePullDown" id="orgType" name="orgType" databind="orgJsonData.orgType" datasource="initOrgTypeData" empty_text="" width="90%"
			  	editable="false" label_field="orgTypeName" value_field="orgType" validate="[{'type':'required', 'rule':{'m': '组织类型不能为空。'}}]"></span>
			</td>
			<td class="td_label"><span class="top_required">*</span>组织性质：</td>
			<td >
				<span uitype="singlePullDown" id="orgProperty" name="orgProperty" databind="orgJsonData.orgProperty" datasource="initOrgPropertyData" empty_text="" width="90%"
			  	  editable="false" label_field="orgPropertyName" value_field="orgProperty" validate="[{'type':'required', 'rule':{'m': '组织性质不能为空。'}}]"></span>
            </td>
			
		</tr>
		
		 <tr>   
		    <td class="td_label" >上级组织：</td>
			<td >
				<span uitype="input" id="parentOrgName" name="parentOrgName" databind="orgJsonData.parentOrgName" maxlength="50" width="90%"></span>
			</td>      
		    <td class="td_label" >业务流程区域：</td>
			<td >
				<span uitype="input" id="flowArea" name="flowArea" databind="orgJsonData.flowArea" maxlength="20" width="90%"></span>
			</td>
		</tr>
		
		 <tr>         
		    <td class="td_label" >行政区域：</td>
			<td >
				<span uitype="input" id="areaId" name="areaId" databind="orgJsonData.areaId" maxlength="9" width="90%" validate="[{'type':'custom', 'rule':{'against':'isAreaIdInteger','m':'行政区域必须为整数。'}}]"></span>
			</td>
			<td class="td_label" >组织邮箱：</td>
			<td >
			   <span uitype="input" id="emailAddress" name="emailAddress" databind="orgJsonData.emailAddress" maxlength="25" width="90%" validate="[{'type':'email', 'rule':{'m': '组织邮箱格式不正确。'}}]"></span>
			</td>
		</tr>
		 <tr>         
			<td class="td_label" >子控制区：</td>
			<td >
			   <span uitype="input" id="childControlArea" name="childControlArea" databind="orgJsonData.childControlArea" maxlength="15" width="90%"></span>
			</td>
		    <td class="td_label">组织职责：</td>
			<td >
			  <span uitype="singlePullDown" id="orgDuty" name="orgDuty" databind="orgJsonData.orgDuty"  datasource="initOrgDuty" width="90%"
			  	editable="false" label_field="text" value_field="id" empty_text=""></span>
			</td>
		</tr>
		<tr>
			<td class="td_label" >基准组织编码：</td>
			<td >
			   <span uitype="input" id="baseOrgCode" name="baseOrgCode" databind="orgJsonData.baseOrgCode" maxlength="40" width="90%"></span>
			</td>
			<td class="td_label" ></td>
			<td >
			</td>
		</tr>
		<tr>
		    <td class="td_label" valign="top">描述：</td>
			<td colspan="3">
				<div>
					<span uitype="textarea" id="note" name="note" width="95%" databind="orgJsonData.note"  height="80px" maxlength="100" ></span>
				</div>
			</td>
		</tr>
	 </table>
<div class="divTitleForExtend" id="divTitleForExtend">扩展属性</div>
<div id="extendFieldForEdit"></div>	
</div>
</div>
</div>
</body>
</html>
