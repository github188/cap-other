﻿<%
    /**********************************************************************
	 * 实体主页面
	 * 2015-8-31  章尊志 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
<head>
<meta charset="UTF-8">
<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/ptc/index/image/biz_entity.png">
<title>实体主页面</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<style type="text/css">
.cui-tab ul.cui-tab-nav li{
padding:0 5px;
margin-right:5px

</style>

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/dev/consistency/js/consistency.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>
<top:script src="/cap/dwr/engine.js"></top:script>
<top:script src="/cap/dwr/util.js"></top:script>
<top:script src='/cap/dwr/interface/EntityOperateAction.js'></top:script>
<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
<script type="text/javascript">

   var openType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("openType"))%>;//listToMain
   var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
   var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
   var globalReadState=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("globalReadState"))%>;
   globalReadState = globalReadState == null || globalReadState == 'null' ? false : true;
   //新增的实体类型
   var entityType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("entityType"))%>;
   //实体来源
   var entitySource = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("entitySource"))%>;
   //系统目录树的，应用模块编码
   var moduleCode = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("moduleCode"))%>;
   var checkUrl = "<%=request.getContextPath() %>/cap/bm/dev/consistency/ConsistencyCheckResult.jsp?init=true";
   var operateType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("operateType"))%>;
   var modelPackage="";
   var entityVO;
   var pageStorage = null;
   jQuery(document).ready(function(){
	   jQuery("#tabBodyDiv").css("height",$(window).height()-61);
	   
       comtop.UI.scan();
       initLinkHref();
       initEntityData();
       showReturnOrClose();
       if(entityVO != null){
	       document.title = entityVO.engName + document.title;
       }
       if(operateType!=null){
    	   jumpToTab(operateType);
       }
       //设置为控件为自读状态（针对于CAP测试建模）
       if(globalReadState){
    	   cui("#insert").hide();
    	   cui("#save").hide();
    	   cui("#check").hide();
       }
   });
   
	var currentDependOnData = [];
	var dependOnCurrentData = [];

	function consistencyCheck(isSave) {
		var isPass = true;
		cui("#check").disable(true); //效验按钮禁用
		//调用元数据检查方法
		currentDependOnData = [];
		dependOnCurrentData = [];
		var entity = beforProcess(); //取得页面实体VO

		dwr.TOPEngine.setAsync(false);
		if (!isSave) {
			EntityFacade.checkEntityConsistency(entity, function(result) {
				isPass = parsingResult(result);
			});
		} else {
			EntityFacade.checkEntityConsistencyBySwitch(entity, function(result) {
				isPass = parsingResult(result);
			});
		}
		dwr.TOPEngine.setAsync(true);
		if (isPass) {
			if (isSave) {
				return isPass;
			} else {
				cui.message('元数据一致性效验通过！','success');
			}
		} else {
			cui.message("存在一致性校验问题,请检查元数据一致性.");
		}
		return isPass;
	}

	function parsingResult(result) {
		var isPass = true;
		if (result) { //currentDependOn dependOnCurrent validateResult
			if (!result.validateResult) { //有错误
				currentDependOnData = result.currentDependOn == null ? [] : result.currentDependOn;
				dependOnCurrentData = result.dependOnCurrent == null ? [] : result.dependOnCurrent;
				initOpenConsistencyImage(checkUrl);
				isPass = false;
			} else {
				initOpenConsistencyImage(checkUrl); //通过则关闭div和dialog
			}
		} else {
			cui.error("元数据一致性效验异常，请联系管理员！");
		}

		setTimeout(function() {
			cui("#check").disable(false);
		}, 800);
		return isPass;
	}
   
	function initLinkHref() {
		var strHref = "${pageScope.cuiWebRoot}/cap/ptc/index/image/";
		if (entityType == "query_entity") {
			if('exist_entity_input' == entitySource){
				strHref += "exist_entity.png";
			}else{
				strHref += "query_entity.png";
			}
		} else if (entityType == "data_entity") {
			if('exist_entity_input' == entitySource){
				strHref += "exist_entity.png";
			}else{
				strHref += "data_entity.png";
			}
		} else if (entityType == "biz_entity") {
			strHref += "biz_entity.png";
		} else {
			return false;
		}
		jQuery("link[rel='shortcut icon']").attr('href', strHref);
	}

	function initEntityData() {
		dwr.TOPEngine.setAsync(false);
		EntityFacade.loadEntity(modelId, packageId, function(entity) {
			entityVO = entity;
			modelPackage = entity.modelPackage;
			pageStorage = new cap.PageStorage(modelId);
			pageStorage.createPageAttribute("entity", entityVO);
			initIframe(entityVO.entityType,entityVO.entitySource);
		});
		dwr.TOPEngine.setAsync(true);
	}
   

	//初始化iframe
	function initIframe(entityType,entitySource) {
		var attr = "modelId=" + modelId + "&packageId=" + packageId + "&modelPackage=" + modelPackage + "&moduleCode=" + moduleCode + "&globalReadState="+globalReadState;;
		if (entityType == "biz_entity") {
			jQuery("#entityFrame").attr("src", "EntityEdit.jsp?" + attr);
			jQuery("#entityAttributeFrame").attr("src", "EntityAttributeList.jsp?" + attr);
			jQuery("#entityMethodFrame").attr("src", "NewEntityMethodList.jsp?" + attr);
			jQuery("#relationshipFrame").attr("src", "RelationshipList.jsp?" + attr);
		} else if (entityType == "query_entity") {
			if('exist_entity_input' == entitySource){
				jQuery("#entityFrame").attr("src", "EntityEdit.jsp?" + attr);
				jQuery("#entityAttributeFrame").attr("src", "EntityAttributeList.jsp?" + attr);
				jQuery("#entityMethodFrame").attr("src", "NewEntityMethodList.jsp?" + attr);
				jQuery("#relationshipTab").remove();
				cui("#insert").hide();
			}else{
				jQuery("#entityFrame").attr("src", "EntityEdit.jsp?" + attr);
				jQuery("#entityAttributeFrame").attr("src", "EntityAttributeList.jsp?" + attr);
				jQuery("#entityMethodFrame").attr("src", "NewEntityMethodList.jsp?" + attr);
				jQuery("#relationshipTab").remove();
			}
		} else if (entityType == "data_entity") {
			if('exist_entity_input' == entitySource){
				jQuery("#entityFrame").attr("src", "EntityEdit.jsp?" + attr);
				jQuery("#entityAttributeFrame").attr("src", "EntityAttributeList.jsp?" + attr);		
				jQuery("#entityMethodTab").remove();
				jQuery("#relationshipTab").remove();
				cui("#insert").hide();
			}else{
				jQuery("#entityFrame").attr("src", "EntityEdit.jsp?" + attr);
				jQuery("#entityAttributeFrame").attr("src", "EntityAttributeList.jsp?" + attr);
				jQuery("#entityMethodTab").remove();
				jQuery("#relationshipTab").remove();
			}
		}
	}

	//显示关闭或者是返回按钮
	function showReturnOrClose() {
		if (openType == "listToMain") {
			cui("#close").hide();
		} else {
			cui("#return").hide();
		}
	}

	//tab页点击事件
	function tabClick(frameId) {
		var ar = ['entity', 'entityAttribute', 'entityMethod', 'relationship', 'entityQueryMethod'];
		for (var i = 0; i < ar.length; i++) {
			if (frameId == ar[i]) {
				jQuery("#" + ar[i] + "Tab").css("background-color", "");
				jQuery("#" + ar[i] + "Tab").addClass("cui-active");
				jQuery("#" + ar[i] + "Frame").css("display", "block");

			} else {
				jQuery("#" + ar[i] + "Tab").css("background-color", "#f5f5f5");
				jQuery("#" + ar[i] + "Tab").removeClass("cui-active");
				jQuery("#" + ar[i] + "Frame").css("display", "none");
			}
		}

		//当切换到方法tab页时，去查询级联属性。（为了级联属性实时更新）
		if (frameId == 'entityMethod') {
			if (jQuery("#entityMethodFrame")[0].contentWindow.scope) {
				jQuery("#entityMethodFrame")[0].contentWindow.scope.initCascadingMethod();
			}
		}

	}
   
   //生成代码的菜单
   var menu_gen_data = {
			 datasource:
				[
				 {id:'gen_all',label:'生成所有代码',title:'生成所有后台Java代码与SQL配置文件'},
           	     {id:'gen_vo',label:'生成VO代码',title:'生成VO类及SQL配置文件'},
           	     {id:'gen_sql',label:'生成SQL脚本',title:'生成并执行SOA服务相关脚本'},
           	     {id:'gen_biz',label:'生成业务代码',title:'生成除SQL配置文件生成所有后台代码'}
           	],
			 on_click: function(obj){
				 var type = obj.id;
				 var genType = 0;
				 if("gen_all" === type){
					 genType = 0;
				 }else if("gen_vo" === type){
					 genType = 1;
				 }else if("gen_biz" === type){
					 genType = 2;
				 }else if("gen_sql" === type){
					 genType = 3;
				 }
				 generateCode(genType);
			 }
			};
   
   var handleMask=null;
   // 生成实体代码
   function generateCode(type) {
	   var result = validataEntityInfoRequired();
	   if(!result.validFlag){
		  cui.alert(result.message);
		  return;
	    }
	   
	  var result = validateAll();
	  if(!result.validFlag){
	   	 cui.alert(result.message);
	     return;
      }
	  
	  var isProcessId = jQuery("#entityFrame")[0].contentWindow.checkProcessId();
	  if(isProcessId){
		  cui.alert("关联流程不能为空!");
		  return;
	  }
	  
	  //saveInit();
	  if(handleMask==null){
		  handleMask=cui.handleMask({
	          html:'<div style="padding:10px;border:1px solid #666;background: #fff;">代码生成中请耐心等待</div>'
	      }).show();
	  }else{
		  handleMask.show();
	  }
	  
	  var entity = beforProcess();
	  entity.state = true;//所有效验通过之后即可认为state=true
	  EntityOperateAction.saveAndGenerateCode(entity, type, function(result){
		  handleMask.hide();
		  if(result){
			   sendMessage('entityFrame',{type:'modelIdChange',data:entity.modelId});
			   cui.message('实体保存并生成代码成功！', 'success');
		  }else{
			   cui.error("实体保存并生成代码失败！"); 
		  }
	  });
   }
   
	function save() {
		var result = validataEntityInfoRequired();
		if (!result.validFlag) {
			cui.alert(result.message);
			return;
		}
		var entity = beforProcess();//取得页面实体VO
		var isProcessId = jQuery("#entityFrame")[0].contentWindow.checkProcessId();
		if (isProcessId) {
			cui.confirm("关联流程不能为空。是否继续保存？<br/>", {
				onYes: function() {
					entity.state = false;
					result = validateAll();
					if (!result.validFlag) {
						cui.alert(result.message);
					} else {
						saveEntity();
					}
				}
			});
		} else {
			result = validateAll();
			if (!result.validFlag) {
				cui.alert(result.message);
			} else {
				entity.state = true;
				saveEntity();
			}
		}
	}
   
   //实体保存
   function saveEntity(){
   	   
	   	var entity = beforProcess();
	   	if(!consistencyCheck(true)) {
	   		return;
	   	}
		
		dwr.TOPEngine.setAsync(false);
	    EntityFacade.saveEntity(entity, function(result){
			  if(result){
				  sendMessage('entityFrame',{type:'modelIdChange',data:entity.modelId});
				  cui.message('实体保存成功！', 'success');
			  }else{
				  cui.error("实体保存失败！"); 
			  }
	    });
		dwr.TOPEngine.setAsync(true);
   }
   
   /**
    * 保存前或生成代码前的处理。
    *
    */
   var beforProcess = function(){
	   var entity = pageStorage.get("entity");
	   entity.modelType = "entity";
	   entity.modelName = entity.engName;
	   entity.modelId = entity.modelPackage + "." + entity.modelType + "." + entity.modelName;
	   entity.packageId = packageId;
	   if(entityType != "data_entity"){
	    	//提交时，根据方法类型，重置与方法类型无关的部分属性。
	    	jQuery("#entityMethodFrame")[0].contentWindow.processMethod4Save();
	   }

	   return entity;
   };
   
   //跨页面发送消息
   function sendMessage(frameId,data){
	   jQuery("#"+frameId)[0].contentWindow.postMessage(data, '*');
   }
   
   //返回
   function back(){
	   var attr="entityId="+modelId+ "&packageId="+packageId;
		window.location="EntityList.jsp?"+attr;	   
   }
   
   //检测
   function validateAll(){
	   if(entityType=="data_entity"){
		   var resultEntityFrame = jQuery("#entityFrame")[0].contentWindow.validateAll();
		   var resultEntityAttributeFrame = jQuery("#entityAttributeFrame")[0].contentWindow.validateAll();
		  return  cap.finalValiResComposite([resultEntityFrame,resultEntityAttributeFrame]);
	   }else if(entityType=="query_entity"){
		   var resultEntityFrame = jQuery("#entityFrame")[0].contentWindow.validateAll();
		   var resultEntityAttributeFrame = jQuery("#entityAttributeFrame")[0].contentWindow.validateAll();
		   var resultEntityMethodFrame = jQuery("#entityMethodFrame")[0].contentWindow.validateAll();
		  return  cap.finalValiResComposite([resultEntityFrame,resultEntityMethodFrame,resultEntityAttributeFrame]); 
	   }else{
		   var resultEntityFrame = jQuery("#entityFrame")[0].contentWindow.validateAll();
		   var resultEntityAttributeFrame = jQuery("#entityAttributeFrame")[0].contentWindow.validateAll();
		   var resultEntityMethodFrame = jQuery("#entityMethodFrame")[0].contentWindow.validateAll();
		   var resultRelationshipFrame = jQuery("#relationshipFrame")[0].contentWindow.validateAll();
		  return  cap.finalValiResComposite([resultEntityFrame,resultEntityAttributeFrame,resultEntityMethodFrame,resultRelationshipFrame]);
	   }
   }

   //更新默认查询条件
   function updateQueryCondition(model){
   	  jQuery("#entityAttributeFrame")[0].contentWindow.scope.saveSqlCondition(model);
   }
   
   //保存按钮调用
   function validataEntityInfoRequired(){
	  return jQuery("#entityFrame")[0].contentWindow.validateAll();
   }
   
   function closeWindow(){
	   if(window.parent){
		   window.parent.close();
	   }else{
		   window.close();
	   }
   }
</script>
</head>
<body style="background-color:#f5f5f5">
 	<div class="cui-tab" style="border:solid 1px #e6e6e6;background:#f5f5f5">
 		<span class="tabs-scroller-left cui-icon" style="display: none;"></span>
 		<span class="tabs-scroller-right cui-icon" style="display: none; right: 22px;"></span>
        <div class="cui-tab-head" style="margin: 0px;font-size:11pt">
        	<table style="width:100%;border-spacing: 0px">
        		<tr>
        			<td style="text-align:left;padding:0px">
        				<ul id="entityUl" class="cui-tab-nav" style="height:40px;width:100%;padding:0px 0 0 0px;background-color:#f5f5f5">
			                <li id="entityTab" title="实体" class="cui-active" style="width:65px;height:40px;line-height:40px;margin-left:8px" onclick="tabClick('entity')">
			                	<span class="cui-tab-title">实体</span>
			                    <a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			                <li id="entityAttributeTab" title="属性" class="" style="width:65px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('entityAttribute')">
			                	<span class="cui-tab-title">属性</span>
			                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			                <li id="entityMethodTab" title="方法" class="" style="width:65px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('entityMethod')">
			                	<span class="cui-tab-title">方法</span>
			                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			                <li id="relationshipTab" title="关系" class="" style="width:65px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('relationship')">
			                	<span class="cui-tab-title">关系</span>
			                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			            </ul>
        			</td>
        			<td style="text-align:right;padding-right:0px;">
        				<span id="check" uitype="Button" label="校验元数据"  onclick="consistencyCheck()"></span>
        				<span id="save" uitype="Button" label="保存" icon="file-text-o" onclick="save()"></span>
        				<span id="insert" uitype="button" label="生成代码" menu="menu_gen_data"></span>
			        	<span id="return" uitype="Button" label="返回" onclick="back()"></span>
			        	<span id="close" uitype="Button" label="关闭" onclick="closeWindow()"></span>
        			</td>
        		</tr>
        	</table>
        </div>
        <div class="cui-tab-content"  id="tabBodyDiv" style="border-top:3px solid #4585e5">
        	<iframe id="entityFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:block"></iframe>
        	<iframe id="entityAttributeFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>
        	<iframe id="entityMethodFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>
        	<iframe id="relationshipFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>
        </div>
   	</div>
</body>
</html>
