<%
    /**********************************************************************
	 * 页面建模主框架页面
	 * 2015-6-4  郑重 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
<head>
<meta charset="UTF-8">
<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/ptc/index/image/page.png">
<title>页面建模主框架</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<style type="text/css">
.cui-tab ul.cui-tab-nav li{
	padding:0 5px;
	margin-right:5px
}
</style>

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/dev/consistency/js/consistency.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>
<top:script src='/cap/dwr/engine.js'></top:script>
<top:script src='/cap/dwr/util.js'></top:script>
<top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
<top:script src='/cap/dwr/interface/NewPageAction.js'></top:script>
<top:script src='/cap/dwr/interface/ComponentFacade.js'></top:script>
<top:script src='/cap/dwr/interface/ComponentTypeFacade.js'></top:script>
<script type="text/javascript">

   var openType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("openType"))%>;//listToMain
   //pageId只是作名称空间用，跟page.pageId不同一个概念，pageId也不会赋值给page.pageId，之前设计导致的混淆（切记）
   var pageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
   var prototypeId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("prototypeId"))%>;
   var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
   var globalReadState=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("globalReadState"))%>;
   globalReadState = globalReadState == null ? false : globalReadState;
   var saveType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("saveType"))%>;
   //从模板创建页面时,传递的modelPackage,在选择模板之后,还原为
   var templateToModelPackage = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelPackage"))%>;
   var checkUrl = "<%=request.getContextPath() %>/cap/bm/dev/consistency/ConsistencyCheckResult.jsp?init=true";
   var operateType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("operateType"))%>;
   var modelPackage="";
   var pageSession = null;
   var pageUrlPrefix = getPageUrlPrefix();
   var pageUrlSuffix = getPageUrlSuffix();
   
   //控件工具箱
   var toolsdata = [];
   jQuery(document).ready(function(){
	   jQuery("#tabBodyDiv").css("height",$(window).height()-61);
	   $(window).resize(function(){//开启监控，第一次初始化时，不会进入此方法
	      jQuery("#tabBodyDiv").css("height",$(window).height()-61);
	   });
       comtop.UI.scan();
       initToolsdata();
       initPageData();
       showReturnOrClose();
       setDocumentTitle();
       if(operateType!=null){
    	   jumpToTab(operateType);
       }
       
       //设置为控件为自读状态（针对于CAP测试建模）
       if(globalReadState){
    	   cui("#insert").hide();
    	   cui("#check").hide();
    	   cui("#preview").hide();
       }
   });
   
   function setDocumentTitle(){
	   var page = pageSession.get("page");
	   if(page.pageId != null){
	       document.title = (page.modelName ? page.modelName : "") + document.title;
       }
   }
   
   function getPageUrlPrefix(){
	   var prefix;
	   dwr.TOPEngine.setAsync(false);
	   PageFacade.getPageUrlPrefix(function(result){
		   prefix = result;
	   });
	   dwr.TOPEngine.setAsync(true);
	   return prefix;
   }
   
   function getPageUrlSuffix(){
	   var suffix;
	   dwr.TOPEngine.setAsync(false);
	   PageFacade.getPageUrlSuffix(function(result){
		   suffix = result;
	   });
	   dwr.TOPEngine.setAsync(true);
	   return suffix;
   }
   
   function fullscreen(){
	   if(cui("#fullscreen").getLabel()==="全屏"){
		   window.parent.cui("#body").setCollapse("left",true);
		   cui("#fullscreen").setLabel("退出全屏");
		   cui("#fullscreen")._setIcon("compress");
		   $(window.frameElement).css({"position":"fixed","top":0,"left":0});
		   $(window.parent.frameElement).css({"position":"fixed","top":0,"left":0});
		   window.parent.$(".bl_main .bl_border").css({"display":"none"});
	   } else{
	       window.parent.cui("#body").setCollapse("left",false);
		   cui("#fullscreen").setLabel("全屏");
	   	   cui("#fullscreen")._setIcon("expand");
		   $(window.frameElement).css({"position":"","top":"","left":""});
		   $(window.parent.frameElement).css({"position":"","top":"","left":""});
		   window.parent.$(".bl_main .bl_border").css({"display":"block"});
		}
   }
   
   //显示关闭或者是返回按钮
   function showReturnOrClose(){
	     if(openType=="listToMain" || openType=="copyPageList"){
	    	 cui("#close").hide();
	     }else{
	    	 cui("#return").hide();
	    	 cui("#fullscreen").hide();
	     }
   }

   //获取工具箱数据
   function initToolsdata(){
	   dwr.TOPEngine.setAsync(false);
	   ComponentTypeFacade.queryListByUseRange(['dev'], false, function(data){
          if(data){
        	  toolsdata = _.uniq(_.union(data, defaultToolsData()), 'componentType');
          }
       });
	   dwr.TOPEngine.setAsync(true);
   }
   
   //默认工具箱数据
   function defaultToolsData(){
	   return [{
				title: '组合控件', 
				isFolder: true, 
		   		componentType: 'combined', 
		   		children: [
		   		           	{
		   		           		text: '日期范围', 
		   		           		componentModelId: 'uicomponent.common.component.calender,uicomponent.common.component.label,uicomponent.common.component.calender', 
		   		           		uiType: '', 
		   		           		options:[{},{value:'至 '},{}]}, 
							{
		   		           			text: '金钱额度范围', 
		   		           			componentModelId: 'uicomponent.common.component.input,uicomponent.common.component.label,uicomponent.common.component.input,uicomponent.common.component.label',
		   		           			uiType: '', 
		   		           			options:[{width:'80', mask:'Money', maskoptions:'{"prefix":"","separator":",","precision":2}'},{value:'- '},{width:'80', mask:'Money', maskoptions:'{"prefix":"","separator":",","precision":2}'},{value:'￥ '}]}
							]
			}];
   }
    
   /**
    * 根据控件控件modelId，获取控件对象
    *
    * @param componentModelId 控件modelId
    */
   function getComponentVo(componentModelId){
	   var components = getAllComponent(toolsdata);
	   return _.cloneDeep(_.find(components, {"componentModelId":componentModelId})).componentVo;
   }
   
   /**
    * 获取所以控件
    *
    * @param toolsdata 控件数据箱
    * @param components 控件数据集
    */
   function getAllComponent(toolsdata){
	   var components = []; 
	   _.forEach(toolsdata, function (node){
		   if(node.componentModelId != null){
			   components.push(node);
		   } else if(node.children.length > 0) {
			   components = _.union(components, getAllComponent(node.children));
		   }
	   });
	   return components;
   }
   
   //生成代码的菜单
   var menu_gen_data = {
			 datasource:
				[
				 {id:'gen_all',label:'生成所有代码',title:'生成后台action代码与前端页面jsp代码'},
           	     {id:'gen_page',label:'仅生成前端代码',title:'生成前端页面jsp代码'}
           	],
			 on_click: function(obj){
				 var type = obj.id;
				 var genType = 0;
				 if("gen_page" === type){
					 genType = 1;
				 }
				 generateCode(genType);
			 }
			};
   
   //将数据集中定义的常量初始化到此页面中
   function initPageConstant(pageDataStores){
		_.forEach(_.result( _.find(pageDataStores,{modelType:'pageConstant'}), "pageConstantList" ),function (n) {
			window[n.constantName] = '';
		});
   }
   
   //初始化页面数据
   function initPageData(data){
	    dwr.TOPEngine.setAsync(false);
	    if(prototypeId == null || prototypeId == '') {
	    	PageFacade.loadModel(pageId,packageId,function(result){
			   initPageVO(result);
			});
	    }else {
	    	PageFacade.createPageVO(packageId, prototypeId, function(result){
			   initPageVO(result);
			});
	    }
		
		dwr.TOPEngine.setAsync(true);
   }

   function initPageVO(page) {
   		//如果是新增页面则自动生产一个随机id
	   if(pageId==null || pageId==""||saveType=="pageTemplate"){
		   pageId="page"+(new Date()).valueOf();
		   page.createrId = globalCapEmployeeId;
		   page.createrName = globalCapEmployeeName;
	   }
	   
	   if(saveType=="pageTemplate"){
    	   modelPackage = templateToModelPackage;
    	   page.modelPackage = templateToModelPackage;
    	   page.parentName = "";
    	   page.parentId = "";
    	   page.pageId="";//TOP平台（表top_per_func）中的ID
    	   page.modelType = "page";
       }else{
	      modelPackage=page.modelPackage;
	   }
	   var jsonKeys=page.layoutVO.jsonKeys;
	   pageSession=new cap.PageStorage(pageId);
	   
	   initPageConstant(page.dataStoreVOList);
	   
	   pageSession.createPageAttribute("page",page);
	   pageSession.createPageAttribute("layout",initObjectOptions(page.layoutVO,jsonKeys));
       pageSession.createPageAttribute("expression",page.pageComponentExpressionVOList);
       pageSession.createPageAttribute("dataStore",page.dataStoreVOList);
       pageSession.createPageAttribute("action",page.pageActionVOList);
       pageSession.createPageAttribute("pageUrlPrefix",pageUrlPrefix);
       pageSession.createPageAttribute("pageUrlSuffix",pageUrlSuffix);
       
       //从后台获取数据后初始化页面
       initIframe();
   }

   /**
    * 初始化LayoutVO中的objectOptions属性值（只针对type=ui的LayoutVO）
    *
    * @param layoutVO 布局对象
    * @param jsonKeys json类型属性
    */
   function initObjectOptions(layoutVO,jsonKeys){
 	  if(layoutVO.type === 'ui'){
 		  var options = layoutVO.options;
 		  var objectOptions = jQuery.extend(true,{}, options);
 		  stringToObjectByObjectOptions(objectOptions, _.keys(jsonKeys[layoutVO.componentModelId]));
 		  //过滤数据
 		  filterObjectOptionsByRule(objectOptions, getComponentVo(layoutVO.componentModelId));
 		  layoutVO.objectOptions = objectOptions;
 	  }
 	  var children = layoutVO.children;
 	  for(var i in children){
 		  initObjectOptions(children[i],jsonKeys);
 	  }
 	  return layoutVO;
   }
   
   //初始化iframe
   function initIframe(){
	   var attr="modelId="+pageId+"&packageId="+packageId+"&modelPackage="+modelPackage+"&globalReadState="+globalReadState;
       jQuery("#pageInfoFrame").attr("src","PageInfoEdit.jsp?"+attr);
       jQuery("#desingerFrame").attr("src","PageDesigner.jsp?"+attr);
       jQuery("#pageStateFrame").attr("src","PageState.jsp?"+attr);
       jQuery("#dataModelFrame").attr("src","PageDataStore.jsp?"+attr);
       jQuery("#actionFrame").attr("src","PageAction.jsp?"+attr);
   }
	
   //tab页点击事件
   function tabClick(frameId){
	   var ar = ['pageInfo', 'desinger', 'pageState','dataModel','action'];
	   for(var i=0;i<ar.length;i++){
		   if (frameId == ar[i]) {
			   jQuery("#"+ ar[i]+"Tab").css("background-color","");
			   jQuery("#"+ ar[i]+"Tab").addClass("cui-active");
               jQuery("#"+ ar[i]+"Frame").css("display", "block");

           } else {
        	   jQuery("#"+ ar[i]+"Tab").css("background-color","#f5f5f5");
               jQuery("#"+ ar[i]+"Tab").removeClass("cui-active");
               jQuery("#"+ ar[i]+"Frame").css("display", "none");
           }
	   }

	   if (frameId == ar[1]) {
		   window.frames['desingerFrame'].contentWindow.postMessage({type:'refreshCover'}, '*');
 	   } else if(frameId == ar[4]){
 		   window.frames['actionFrame'].contentWindow.postMessage({type:'codeEditorRefresh'}, '*');
 	   }
   }
   
   //预览
   function preview(){
	   window.open('${pageScope.cuiWebRoot}' + pageSession.get("page").url);
   }
   
   var handleMask=null;
   
   //生成当前页面代码
   function generateCode(genType){
	  var result = validateAll();
	  if(!result.validFlag){
	   	 cui.alert(result.message, null, {width: 480});
	     return;
      }
	  var page = pageSession.get("page");
	  saveInit(page);
	  if(handleMask==null){
		  handleMask=cui.handleMask({
	          html:'<div style="padding:10px;border:1px solid #666;background: #fff;">代码生成中请耐心等待</div>'
	      }).show();
	  }else{
		  handleMask.show();
	  }
	  
	  NewPageAction.generateById(page, genType, function(result){
		  if(result){
			   if(!page.pageId){
				   page.pageId = result.pageId;
			   }
			   handleMask.hide();
		  }else{
			   cui.error("页面生成失败！"); 
		  }
	  });
	  //生成数据脚本sql文件
	  saveTopPageSQL(page);
   }
   
    //生成数据脚本sql文件
    function saveTopPageSQL(page) {
		PageFacade.saveTopPageSQL(page, function(result) {});
	}

	//保存前初始化
	function saveInit(page) {
		if (page.modelId == null || saveType == "pageTemplate") {
			page.modelId = page.modelPackage + "." + page.modelType + "."
					+ page.modelName;
		}
		page.modelPackageId = packageId;
		page.layoutVO = pageSession.get("layout");
		page.pageComponentExpressionVOList = pageSession.get("expression");
		page.dataStoreVOList = pageSession.get("dataStore");
		page.pageActionVOList = pageSession.get("action");
	}

	//保存
	function save() {
		var result = validataPageInfoRequired();
		if (!result.validFlag) {
			cui.alert(result.message);
			return;
		}
		result = validateAll();
		var page = pageSession.get("page");
		if (!result.validFlag) {
			cui.confirm("<strong>数据校验失败，是否继续保存？</strong><br/><font color='red'>（注：继续保存只是暂存，不能用于生成代码.）<br/><strong>校验失败的数据如下：</strong><br/>" + result.message + "</font>", {
				onYes : function() {
					page.state = false;
					saveModel(page);
				},
				width: 480
			});
		} else {
			page.state = true;
			saveModel(page);
		}
	}

	//请求保存后台接口
	function saveModel(page) {
		saveInit(page);
		dwr.TOPEngine.setAsync(false);
		PageFacade.saveModel(page, function(result) {
			if (result) {
				if (!page.pageId) {
					page.pageId = result.pageId;
					var pageInfoScope = $("#pageInfoFrame")[0].contentWindow.scope;
					pageInfoScope.isCreateNewPage = false;
					cap.digestValue(pageInfoScope);
				}
				if (openType != "listToMain") {
					if (window.opener && window.opener.refresh) {
						window.opener.refresh();
					}
					window.focus();
				}
				cui.message('页面保存成功！', 'success');
			} else {
				cui.error("页面保存失败！");
			}
		});
		dwr.TOPEngine.setAsync(true);
		//保存之后改变URL，并不会刷新页面
		if(window.history.pushState && !(/^.*modelId=[^&\s].*$/.test(window.location.href))){
			window.history.pushState({}, "", (window.location.href+"&modelId="+page.modelId));
			setDocumentTitle();
		}
		//生成数据脚本sql文件
		saveTopPageSQL(page);
	}

	//返回
	function back() {
		//返回的时候退出全屏
		if (cui("#fullscreen").getLabel() == "退出全屏") {
			fullscreen();
		}
		var attr = "packageId=" + packageId + "&modelPackage=" + modelPackage;
		window.location = "../PageHome.jsp?" + attr;
	}

	//跨页面发送消息
	function sendMessage(frameId, data) {
		jQuery("#" + frameId)[0].contentWindow.postMessage(data, '*');
	}

	//统一校验
	function validateAll() {
		//页面信息
		var result = jQuery("#pageInfoFrame")[0].contentWindow.validateAll();
		if (!result.validFlag) {
			result.message = "<strong>【页面信息】</strong><br/>" + result.message + "<br/>";
		}
		//控件状态
		var validateResult = jQuery("#pageStateFrame")[0].contentWindow
				.validateAll();
		result.validFlag = result.validFlag && validateResult.validFlag;
		if (!validateResult.validFlag) {
			result.message += "<strong>【控件状态】</strong><br/>" + validateResult.message + "<br/>";
		}
		//数据模型
		validateResult = jQuery("#dataModelFrame")[0].contentWindow
				.validateAll();
		result.validFlag = result.validFlag && validateResult.validFlag;
		if (!validateResult.validFlag) {
			result.message += "<strong>【数据模型】</strong><br/>" + validateResult.message + "<br/>";
		}
		//行为
		validateResult = jQuery("#actionFrame")[0].contentWindow.validateAll();
		result.validFlag = result.validFlag && validateResult.validFlag;
		if (!validateResult.validFlag) {
			result.message += "<strong>【行为】</strong><br/>" + validateResult.message + "<br/>";
		}
		//设计器
		validateResult = jQuery("#desingerFrame")[0].contentWindow.validateAll();
		result.validFlag = result.validFlag && validateResult.validFlag;
		if (!validateResult.validFlag) {
			result.message += "<strong>【设计器】</strong><br/>" + validateResult.message + "<br/>";
		}
		result.message = result.message.replace(/(<br\/>\s*){2,}/gi, "<br/>");
		return result;
	}

	//保存按钮调用
	function validataPageInfoRequired() {
		return jQuery("#pageInfoFrame")[0].contentWindow
				.validataPageInfoRequired();
	}

	function closeWindow() {
		if (window.parent) {
			window.parent.close();
		} else {
			window.close();
		}
	}
	
	var currentDependOnData=[];
    var dependOnCurrentData=[];
    function consistencyCheck(){
	   cui("#check").disable(true);//效验按钮禁用
	   //调用元数据检查方法，清空
	   currentDependOnData=[];
   	   dependOnCurrentData=[];
   	   var page = pageSession.get("page");
	   saveInit(page);
	   //var page = window.parent.pageSession.get("page");//取得页面实体VO pageVO是全局变量
	   PageFacade.pageConsistencyCheck(page, function(result){
		  if(result){//currentDependOn dependOnCurrent validateResult
			  if (!result.validateResult) {//有错误
				  currentDependOnData = result.currentDependOn==null?[]:result.currentDependOn;
				  dependOnCurrentData = result.dependOnCurrent==null?[]:result.dependOnCurrent;
				  initOpenConsistencyImage(checkUrl);
			  }else{
				  cui.message('元数据一致性效验通过！', 'success');
				  initOpenConsistencyImage(checkUrl);//通过则关闭div和dialog
			  }
		  }else{
			  cui.error("元数据一致性效验异常，请联系管理员！"); 
		  }
		  cui("#check").disable(false);
	   });
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
        				<ul class="cui-tab-nav" style="height:40px;width:100%;padding:0px 0 0 0px;background-color:#f5f5f5">
			                <li id="pageInfoTab" title="页面信息" class="cui-active" style="width:65px;height:40px;line-height:40px;margin-left:8px" onclick="tabClick('pageInfo')">
			                	<span class="cui-tab-title">页面信息</span>
			                    <a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			                <li id="desingerTab" title="设计器" class="" style="width:65px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('desinger')">
			                	<span class="cui-tab-title">设计器</span>
			                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			                <li id="pageStateTab" title="控件状态" class="" style="width:65px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('pageState')">
			                	<span class="cui-tab-title">控件状态</span>
			                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			                <li id="dataModelTab" title="数据模型" class="" style="width:65px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('dataModel')">
			                	<span class="cui-tab-title">数据模型</span>
			                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			                <li id="actionTab" title="行为" class="" style="width:65px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('action')">
			                	<span class="cui-tab-title">行为</span>
			                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			            </ul>
        			</td>
        			<td style="text-align:right;padding-right:0px">
        				<span uitype="Button" id="fullscreen" label="全屏" icon="expand" on_click="fullscreen"></span>
        				<span id="check" uitype="Button" label="校验元数据"  onclick="consistencyCheck()"></span>
        				<span id="save" uitype="Button" label="保存" icon="file-text-o" onclick="save()"></span>
        				<!-- <span id="insert" uitype="Button" label="代码生成"onclick="generateById()"></span> -->
        				
        				<span id="insert" uitype="button" label="生成代码" menu="menu_gen_data"></span>
        				
        				<span id="view" uitype="Button" label="预览" icon="desktop" onclick="preview()"></span>
			        	<span id="return" uitype="Button" label="返回" onclick="back()"></span>
			        	<span id="close" uitype="Button" label="关闭" onclick="closeWindow()"></span>
        			</td>
        		</tr>
        	</table>
        </div>
        <div class="cui-tab-content"  id="tabBodyDiv" style="border-top:3px solid #4585e5">
        	<iframe id="pageInfoFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:block"></iframe>
        	<iframe id="desingerFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>
        	<iframe id="pageStateFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>
        	<iframe id="dataModelFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>
        	<iframe id="actionFrame"  frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>
        </div>
   	</div>
</body>
</html>
