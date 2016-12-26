﻿<%
    /**********************************************************************
	 * 界面原型主框架页面
	 * 2016-10-25 zhuhuanhui 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
	<head>
		<meta charset="UTF-8">
		<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/ptc/index/image/page.png">
		<title>界面原型主框架</title>
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
		<style type="text/css">
			body {
				background-color:#f5f5f5;
			}
			.cui-tab{
				border:solid 1px #e6e6e6;
				background:#f5f5f5;
			}
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
		<top:script src="/cap/bm/common/lodash/js/lodash.js"></top:script>
		<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>
		<top:script src='/cap/dwr/engine.js'></top:script>
		<top:script src='/cap/dwr/util.js'></top:script>
        <top:script src='/cap/dwr/interface/ReqTreeAction.js'></top:script>
        <top:script src='/cap/dwr/interface/ComponentTypeFacade.js'></top:script>
        <top:script src='/cap/dwr/interface/BizDomainAction.js'></top:script>
        <top:script src='/cap/dwr/interface/ReqFunctionItemAction.js'></top:script>
        <top:script src='/cap/dwr/interface/ReqFunctionSubitemAction.js'></top:script>
        <top:script src='/cap/dwr/interface/PrototypeVersionFacade.js'></top:script>
        <top:script src='/cap/dwr/interface/PrototypeFacade.js'></top:script>
        <top:script src='/cap/dwr/interface/PrototypeAction.js'></top:script>
		<script type="text/javascript">
			var modelId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
			var reqFunctionSubitemId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("reqFunctionSubitemId"))%>;
			var modelPackage = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelPackage"))%>;
			var pageSession = null;
			var namespaces = modelId ? modelId : getRandomId('namespaces');
			var handleMask = null;
			//控件工具箱
			var toolsdata = [];
			var page = {};
			var currVersion = {};
			$(document).ready(function(){
				setIframeParentNodeHeight();
			    initToolsdata();
			    initPageData();
			    buildPageStorage();
				initIframe();
				setDocumentTitle();
		       	comtop.UI.scan();
		       	getCurrVersion();
			});
			
			//设置当前页面标题名称
			function setDocumentTitle(){
				if(page != null && page.modelId != null){
			       document.title = page.modelName + document.title;
		        }
			}
			
			//设置Iframe框架所在的父节点元素高度
			function setIframeParentNodeHeight(){
				$("#tabBodyDiv").css("height",$(window).height()-61);
			    $(window).resize(function(){//开启监控，第一次初始化时，不会进入此方法
			       jQuery("#tabBodyDiv").css("height",$(window).height()-61);
			    });
			}
			
			//获取工具箱数据
		   	function initToolsdata(){
			   	dwr.TOPEngine.setAsync(false);
			   	ComponentTypeFacade.queryListByUseRange(['req'], true, function(data){
			   		toolsdata = data != null ? data :  {};
		       	});
			   	dwr.TOPEngine.setAsync(true);
		    }
			
		    //初始化页面数据
		    function initPageData(){
		    	page = getPrototypeByModelId(modelId);
		    	if(page.modelId == null){
					page.modelPackage = modelPackage;
					page.type = 0;
					page.createrId = globalCapEmployeeId;
				   	page.createrName = globalCapEmployeeName;
				   	page.functionSubitemId = reqFunctionSubitemId;
				}
		    	//初始化控件属性集对象，用于设计时使用
		    	initObjectOptions(page.layoutVO, page.layoutVO.jsonKeys)
		    }
			
		    //构建存储页面对象缓存对象，并设值
		    function buildPageStorage(){
		    	pageSession = new cap.PageStorage(namespaces);
	 	        pageSession.createPageAttribute("page", page);
			    pageSession.createPageAttribute("layout", page.layoutVO);
		        pageSession.createPageAttribute("action", page.pageActionVOList);
		        //初始化后的界面原型对象，用于判断再次保存页面时，数据是否有变动
		        pageSession.createPageAttribute("wrapperHistroyPage", jQuery.extend(true, {}, page));
		    }
		    
		  	//获取当前原型版本信息
			function getCurrVersion(){
				currVersion = page.modelId ? getVersion(page.modelId, '') : {};
			}
		    
		    //初始化iframe
		    function initIframe(){
			   	var attr = "namespaces=" + namespaces + "&reqFunctionSubitemId=" + reqFunctionSubitemId;
		       	$("#pageInfoFrame").attr("src", "./basicinfo/PrototypeInfoEdit.jsp?" + attr);
		       	$("#desingerFrame").attr("src", "./design/PrototypeDesigner.jsp?" + attr);
		       	$("#actionFrame").attr("src", "./action/PrototypeAction.jsp?" + attr);
		    }
		
		    //tab页点击事件
		    function tabClick(frameId){
		 	    var ar = ['pageInfo', 'desinger', 'action'];
		 	   	for(var i=0,len=ar.length; i<len; i++){
		 		   	if (frameId == ar[i]) {
		 			   	$("#"+ ar[i]+"Tab").css("background-color","");
		 			   	$("#"+ ar[i]+"Tab").addClass("cui-active");
		                $("#"+ ar[i]+"Frame").css("display", "block");
		            } else {
		         	   	$("#"+ ar[i]+"Tab").css("background-color","#f5f5f5");
		                $("#"+ ar[i]+"Tab").removeClass("cui-active");
		                $("#"+ ar[i]+"Frame").css("display", "none");
		            }
		 	   }

		 	   if (frameId == ar[1]) {
				   window.frames['desingerFrame'].contentWindow.postMessage({type:'refreshCover'}, '*');
		 	   } else if (frameId == ar[2]) {
		 		   window.frames['actionFrame'].contentWindow.postMessage({type:'codeEditorRefresh'}, '*');
		 	   } 
		    }
		    
		    /**
		     * 保存
		     * @param components 控件数据集
		     */
			function save() {
		    	if(!hasChange()){
					cui.message('页面保存成功。', 'success');
		    		return;
		    	}
				var result = validataAll();
				if (!result.validFlag) {
					cui.alert(result.message);
					return;
				}
				saveModel();
				//保存之后改变URL，并不会刷新页面
				if(window.history.pushState && !(/^.*modelId=[^&\s].*$/.test(window.location.href))){
					window.history.pushState({}, "", (window.location.href+"&modelId="+page.modelId));
					setDocumentTitle();
				}
				refleshParentGrid();
			}
		  	
			//预览html页面(预览前先保存页面，再生产页面，最后执行预览)
		 	function previewHtml(){
				var url = getCurrPageRelativeURL(page.modelPackage);
		 		openPreview('${pageScope.cuiWebRoot}/prototype/' + url, function(){
			 			var promise = generateCode();
			 			promise.done(function(_result) {
				    		saveSucceedAfter();
				    	});
				    	return promise;
			    	}, "，无法进行页面预览操作。", "code", "/prototype/" + url);
		    }
			
		 	//预览页面图片，如果未执行更改，则直接预览，否则：预览前先保存页面，再生产页面，最后执行预览
			function previewImage(){
				var url = getImageVisitPrefix() + 'REQ_PROTOTYPE_IMAGE/' + getCurrPageRelativeURL(page.modelPackage).replace('.html', '.png');
		 		openPreview(url, function(){
		 			var promise = generateCode().then(function (_result) {
			    		saveSucceedAfter();
						return generateImage();
					});
		 			return promise;
		 		}, "，无法进行页面图片预览操作！", "image", url);
		    }
		    
			//预览
			function openPreview(url, func, errorMsg, type, filePath){
				var toEnforce = true, versionChange = true;
				if(page.modelId){
					var newVersion = getVersion(page.modelId, filePath);
					if(currVersion.metaDataVersion != newVersion.metaDataVersion){
						//由于confirm异步执行的，没回调值，所以而外添加了toEnforce变量
						cui.confirm("检测到当前元数据非最新版本，是否以当前版本为准，进行预览操作？",{
							onYes:function(){
								execPreview(versionChange, url, func, errorMsg);
							},
							onNo:function(){
								window.open(url);
							}
						});
						toEnforce = false;
					} else {
						versionChange = newVersion.metaDataVersion != newVersion[type + 'Version'];
					}
				}
				if(toEnforce){
					execPreview(versionChange, url, func, errorMsg);
				}
		    }
		 	
			//执行预览
			function execPreview(versionChange, url, func, errorMsg){
				if(hasChange() || versionChange){
					var result = validataAll();
					if(!result.validFlag){
						cui.alert(result.message);
						return;
					} 
					showHandleMask();
			    	if(func){
				    	func().always(function(_result) {
				    		if(!_result.flag){
				    			cui.alert(_result.message + errorMsg);
				    		} else {
					    		window.open(url);
				    		}
					    	handleMask.hide();
				    	});
			    	} else {
			    		handleMask.hide();
			    	}
		 		} else {
		 			window.open(url);
		 		}
			}
			
			//请求保存后台接口
			function saveModel() {
				saveInit();
				dwr.TOPEngine.setAsync(false);
				PrototypeFacade.saveModel(page, 
						{
							callback: function(result) {
								if (result) {
									saveSucceedAfter();
									cui.message('页面保存成功。', 'success');
								} else{
									cui.error("页面保存失败。");
								}
							},
							errorHandler: function(){
								cui.error("页面保存失败。");
							}
						}
				);
				dwr.TOPEngine.setAsync(true);
			}
		  	
			//保存前初始化
			function saveInit() {
				if(page.modelId == null){
					page.url = getCurrPageRelativeURL(page.modelPackage);
					page.imageURL = 'REQ_PROTOTYPE_IMAGE/' + page.url.replace('.html', '.png');
					page.modelId = modelPackage + "." + page.modelType + '.' + page.modelName;
					page.sortNo = getLastSortNo(page.modelPackage);
				}
				page.layoutVO = pageSession.get("layout");
				page.pageActionVOList = pageSession.get("action");
			}
			
			/**
		     * 生成当前页面代码
		     * @param callback 回调函数
		     */
		   	function generateCode(){
				var def = $.Deferred();		   		
				saveInit();
				PrototypeAction.generateById(page, 
						{
							callback: function (_result){
								def.resolve({flag: true});	
							},
							errorHandler: function(){
								def.reject({flag: false, message: '生成界面原型页面失败'});
							}
						}
				);
				return def.promise();
		   	}
			
			/**
		     * 保存成功之后处理
		     */
			function saveSucceedAfter(){
				var pageInfoScope = $("#pageInfoFrame")[0].contentWindow.scope;
				if(page.modelId && pageInfoScope.isCreateNewPage) {
					pageInfoScope.isCreateNewPage = false;
					cap.digestValue(pageInfoScope);
				}
				getCurrVersion();
				refleshParentGrid();
				pageSession.createPageAttribute("wrapperHistroyPage", jQuery.extend(true, {}, page));
			}
			
		    /**
			 * 导出界面原型图片，并把生成的界面原型图片上传到服务器
			 * 默认路径保存在：webapp/prototype/REQ_PROTOTYPE_IMAGE/目录下。可在首选项中进行配置。
			 * @param callback 回调函数
			 */
			function generateImage(){
				var def = $.Deferred();
				PrototypeAction.htmlToImage(modelPackage, [page.modelId], "${pageScope.cuiWebRoot}/prototype/" + page.url, page.modelName + ".png", reqFunctionSubitemId,
					{
						callback: function(_result){
							def.resolve({flag: true});
						}, 
						errorHandler: function(){
							def.reject({flag: false, message: "生成界面原型页面图片失败"});
						}
					}
				);
				return def.promise();
			}
		    
		    /**
		     * 初始化LayoutVO中的objectOptions属性值（只针对type=ui的LayoutVO）
		     *
		     * @param layoutVO 布局对象
		     * @param jsonKeys json类型属性
		     */
		    function initObjectOptions(layoutVO, jsonKeys){
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
			
			/**
		     * 获取最新的sortNo值，先获取包路径下的界面原型中最大的sortNo,在此sortNo的基础上+1进行返回。
		     * @param modelPackage 包
		     * @return 最新的sortNo
		     */
			function getLastSortNo(modelPackage){
				var ret = -1;
				dwr.TOPEngine.setAsync(false);
				PrototypeFacade.getLastSortNo(modelPackage, function(result) {
					ret = result;
				});
				dwr.TOPEngine.setAsync(true);
				return ret;
			}
			
			//显示进度条
			function showHandleMask(){
				if(!handleMask){
					handleMask = cui.handleMask({
			        	html:'<div style="padding:10px;border:1px solid #666;background: #fff;border-radius:6px;">正在生成...请耐心等待...</div>'
			        });
				}
				handleMask.show();
			}
			
			/**
		     * 获取界面原型对象
		     * @param modelId 界面原型Id
		     */
		    function getPrototypeByModelId(modelId){
		    	var ret = {};
		    	dwr.TOPEngine.setAsync(false);
				PrototypeFacade.loadModel(modelId, null, function(_result) {
					ret = _result;
				});
				dwr.TOPEngine.setAsync(true);
				return ret;
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
			
			//关闭窗口
			function closeWindow(){
				window.close();
			}
			
		    /**
		   	 * 获取界面原型图片在服务器上的访问地址的前缀，用于图片预览
		   	 */
		   	function getImageVisitPrefix(){
		    	if(!window.imageVisitPrefix){
			   		dwr.TOPEngine.setAsync(false);
			   		PrototypeAction.getImageVisitPrefix(function(data){
			   			window.imageVisitPrefix = data;
					});
					dwr.TOPEngine.setAsync(true);
		    	}
		    	return window.imageVisitPrefix;
		   	}
		    
			//获取当前页面被访问的url相对路径
			function getCurrPageRelativeURL(modelPackage){
				return page.modelPackage.substr('com.comtop.prototype.'.length).replace(/\./g, '/') + '/' + page.modelName + '.html';
			}
			
			//跨页面发送消息
			function sendMessage(frameId, data) {
				jQuery("#" + frameId)[0].contentWindow.postMessage(data, '*');
			}

			//是否对界面原型page对象有操作更改
			function hasChange(){
				return page.modelId == null || JSON.stringify(pageSession.get("wrapperHistroyPage")) != JSON.stringify(page);
			}
			
			//获取版本
			function getVersion(modelId, url){
				var ret = {};
				dwr.TOPEngine.setAsync(false);
				PrototypeVersionFacade.loadVersion(modelId, url, function(_result){
					ret = _result;
				});
				dwr.TOPEngine.setAsync(true);
				return ret;
			}
			
			//刷新打开当前页面的页面grid数据源
			function refleshParentGrid(){
				if(window.opener){
					window.opener.postMessage({type: "refleshGrid"}, "*");
				}
			}
			
			//校验
			function validataAll(){
				//页面基本
				var result = $("#pageInfoFrame")[0].contentWindow.validateAll();
				if (!result.validFlag) {
					result.message = "<strong>【页面信息】</strong><br/>" + result.message + "<br/>";
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
		</script>
	</head>
	<body>
	 	<div class="cui-tab">
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
				                <li id="actionTab" title="行为" class="" style="width:65px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('action')">
				                	<span class="cui-tab-title">行为</span>
				                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
				                </li>
				            </ul>
	        			</td>
	        			<td style="text-align:right;padding-right:0px">
	        				<span id="save" uitype="Button" label="保存" icon="file-text-o" onclick="save()"></span>
<!-- 	        				<span id="gen-page" uitype="button" label="生成页面" onclick="generateCode()"></span> -->
<!-- 	        				<span id="gen-image" uitype="button" icon="picture-o" label="导出图片" onclick="generateImage()"></span> -->
	        				<span id="viewHtml" uitype="Button" label="预览HTML" title="预览生成HTML页面" onclick="previewHtml()"></span>
	        				<span id="viewImage" uitype="Button" label="预览图片" title="预览生成页面图片" onclick="previewImage()"></span>
				        	<span id="close" uitype="Button" label="关闭" onclick="closeWindow()"></span>
	        			</td>
	        		</tr>
	        	</table>
	        </div>
	        <div class="cui-tab-content" id="tabBodyDiv" style="border-top:3px solid #4585e5">
	        	<iframe id="pageInfoFrame" frameborder="0" style="height: 100%; width: 100%; position: static; left: 0px; top: 0px; display:block"></iframe>
	        	<iframe id="desingerFrame" frameborder="0" style="height: 100%; width: 100%; position: static; left: 0px; top: 0px; display:none"></iframe>
	        	<iframe id="actionFrame" frameborder="0" style="height: 100%; width: 100%; position: static; left: 0px; top: 0px; display:none"></iframe>
	        </div>
	   	</div>
	</body>
</html>
