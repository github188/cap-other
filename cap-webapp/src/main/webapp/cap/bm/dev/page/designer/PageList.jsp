<%
/**********************************************************************
* 页面建模列表
* 2015-5-13 肖威 新建
* 2015-6-10 郑重 修改
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>页面建模列表</title>
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
		<top:link href="/cap/bm/common/base/css/base.css"></top:link>
		<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css" />
		
		<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
		<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
		<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
		<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
		<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
		<top:script src="/cap/bm/dev/page/designer/js/pageList.js"></top:script>
		<top:script src='/cap/dwr/engine.js'></top:script>
		<top:script src='/cap/dwr/util.js'></top:script>
		<top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
		<top:script src='/cap/dwr/interface/NewPageAction.js'></top:script>
		<top:script src='/cap/dwr/interface/MetadataTmpTypeFacade.js'></top:script>
		<top:script src="/cap/dwr/interface/MetadataPageConfigFacade.js"></top:script>
		<top:script src='/cap/bm/dev/consistency/js/consistency.js'></top:script>
	</head>
	<body>
		<div id="pageRoot" class="cap-page">
			<div class="cap-area" style="width: 100%;">
				<table class="cap-table-fullWidth">
					<tr>
						<td class="cap-td" style="text-align: left; padding: 5px">
							<span id="formTitle" uitype="Label" value="界面列表" class="cap-label-title" size="12pt"></span>
						</td>
						<td class="cap-td" style="text-align: right; padding: 5px">
							<span id="createPage" uitype="Button" onclick="createPage()" label="新建页面"></span> <span id="generateCode" uitype="Button" onclick="generateCode()" label="生成代码"></span> 
							<span id="metaDateBuilder" uitype="Button" onclick="addTemplate()" label="生成典型模块模板"></span>
							<span id="fromTemplateCreatePage" uitype="Button" onclick="fromTemplateCreatePage()" label="从模板创建页面"></span> 
							<span id="copyPage" uitype="Button" onclick="copyPage()" label="复制其它页面"></span>
							<span id="entrySelfPage" uitype="Button" onclick="entrySelfPage()" label="录入自定义页面"></span> <span id="deletePage" uitype="Button" onclick="deletePage()" label="删除"></span>
						</td>
					</tr>
				</table>
				<table class="cap-table-fullWidth">
					<tr>
						<td class="cap-td">
							<table uitype="Grid" id="lstPage" primarykey="modelId" colhidden="false" datasource="initData" pagination="false"
								resizewidth="getBodyWidth" resizeheight="getBodyHeight"
								colrender="columnRenderer">
								
								<thead>
									<tr>
										<th style="width: 30px" renderStyle="text-align: center;"><input
											type="checkbox"></th>
										<th style="width: 50px" renderStyle="text-align: center;"
											bindName="1">序号</th>
										<th renderStyle="text-align: left" render="editPage"
											bindName="cname">页面中文名/页面标题</th>
										<th renderStyle="text-align: left" bindName="modelName">页面文件名</th>
										<th renderStyle="text-align: left" bindName="modelPackage">页面包路径</th>
										<th style="width: 100px" renderStyle="text-align: center;" bindName="state" render="renderState">状态</th>
										<th style="width: 100px" renderStyle="text-align: center;" render="pageType" bindName="pageType">是否自定义页面</th>
										<th style="width: 70px" renderStyle="text-align: center;" render="renderPreviewLink" bindName="url">预览</th>
									</tr>
								</thead>
							</table>
						</td>
					</tr>
					<tr>
						<td class="cap-td"></td>
					</tr>
				</table>
			</div>
		</div>
		<script type="text/javascript">
			var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
			var page = [];
			function initData(gridObj, query) {
				PageFacade.queryPageList(packageId,function(data) {
					page = templatePageList(data);
					gridObj.setDatasource(data, data.length);
				})
			}
			
			/**
			 * 把列表上的页面集合进行过滤，过去掉pageType=2的自定义录入界面
			 *
			 * @param pages 列表页面集合
			 * @return 过滤后的页面集合
			 */
			var templatePageList = function(pages){
				if(pages && Array.isArray(pages) && pages.length > 0){
					var pageList = [];
					pages.forEach(function(item,index,arr){
						if(item.pageType == 1){
							pageList.push(item);
						}
					});
					return pageList;
				}
				return [];
			};
			
			
			jQuery(document).ready(function() {
				comtop.UI.scan();
			});
				
		    //see /cap/bm/dev/page/designer/js/pageList.js
		    var addTemplateURL = '../template/EditMetadataTmpType.jsp?operationType=add&parentemplateTypeCode=pageMetadataTmp';
				
			/**
			 * 表格自适应宽度
			 */
			function getBodyWidth () {
			    return parseInt(jQuery("#pageRoot").css("width"))- 10;
			}
		
			/**
			 * 表格自适应高度
			 */
			function getBodyHeight () {
			    return (document.documentElement.clientHeight || document.body.clientHeight) - 73;
			}
			
			var param="";
			
			//新建页面
			function createPage(){
				param="?modelId="+"&packageId="+packageId+"&openType=listToMain";
				window.parent.location="${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageMain.jsp"+param;
			}
				
			//跳转编辑页面列渲染
			function editPage(rd, index, col){
				var pageType = rd['pageType'];
				param="?modelId="+rd.modelId+"&packageId="+packageId+"&openType=listToMain";
				if(pageType == 1){
				   return "<a href='${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageMain.jsp"+param+"' target='_parent'>" + rd['cname'] + "<a>";
				}else if(pageType == 2){
				   return "<a href='${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/EntrySelfPage.jsp"+param+"' target='_parent'>" + rd['cname'] + "<a>";	
				}
			}
			
			function pageType(rd, index, col){
				var pageType = rd['pageType'];
				if(pageType == 1){
					return "否";
				}else{
					return "是";
				}
			}
			
			//删除页面
			function deletePage(){
				var selectIds = cui("#lstPage").getSelectedPrimaryKey();
				if(selectIds == null || selectIds.length == 0){
					cui.alert("请选择要删除的界面。");
					return;
				}
				
				cui.confirm("确定要删除这"+selectIds.length+"个界面吗？",{
					onYes:function(){
						dwr.TOPEngine.setAsync(false);
						//页面一致性校验
			            if(!checkConsistency(cui("#lstPage").getSelectedRowData(),"page")){
			            	dwr.TOPEngine.setAsync(true);
			            	return ;
			            }
						PageFacade.deleteModels(selectIds,function(data) {
							if(data){
								
							}
							cui("#lstPage").loadData();
							cui.message("删除成功。","success");
						})
						
						dwr.TOPEngine.setAsync(true);
					}
				});
			}
			
			//从模板创建页面
			function fromTemplateCreatePage(){
		   		var param = "?packageId="+packageId+"&openType=listToMain";
				var width=260; //窗口宽度
			    var height=350; //窗口高度
			    var top=(window.screen.availHeight-height)/2;
			    var left=(window.screen.availWidth-width)/2;
			    var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/template/MetadataTmpSelect.jsp'+param;
			    window.open(url, "entityAttribute", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
			}

			//复制其它页面
			function copyPage(){
					var top=(window.screen.availHeight-600)/2;
		    		var left=(window.screen.availWidth-800)/2;
		    		window.open('CopyPageListMain.jsp?systemModuleId='+packageId+"&openType=copyPageList",'copyPageWin','height=650,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
			}
			
			//复制页面选中的页面，回调
			function selectPageData(selectPageDate,openType){
				var inserPageModelPackage = "";
				dwr.TOPEngine.setAsync(false);
				PageFacade.loadModel("",packageId,function(result){
					inserPageModelPackage = result.modelPackage;
				});
				dwr.TOPEngine.setAsync(true);
		    	var modelId = selectPageDate.modelId;
		    	param="?modelId="+modelId+"&packageId="+packageId+"&saveType=pageTemplate&modelPackage="+inserPageModelPackage+"&openType="+openType;
		    	if(selectPageDate.pageType == 1){
		    		window.parent.location="${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageMain.jsp"+param;
		    	}else{
		    		window.parent.location="${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/EntrySelfPage.jsp"+param;
		    	}
			}
			
			//录入自定义页面
			function entrySelfPage(){
				window.parent.location = 'EntrySelfPage.jsp?packageId='+packageId +"&openType=listToMain";
			}
			
			function getModelPackage(){
				dwr.TOPEngine.setAsync(false);
				var modelPackage="";
				PageFacade.loadModel("",packageId,function(result){
					modelPackage = result.modelPackage;
				});
				dwr.TOPEngine.setAsync(true);
				return modelPackage;
			}
				
			var handleMask=null;
			
			//生成代码
			function generateCode(){
				var selectIds = cui("#lstPage").getSelectedPrimaryKey();
				if(selectIds == null || selectIds.length == 0){
					cui.alert("请选择要生成代码的界面。");
					return;
				}else{
					var validateMessage = "";
					var selectedData = cui("#lstPage").getSelectedRowData();
					for(var i=0, len=selectedData.length; i<len; i++){
						var selectedRowData = selectedData[i];
						if(selectedRowData.pageType==2){
							validateMessage += "页面："+selectedRowData.cname+"是自定义界面不能生成代码！</br>"
						}
						if(!selectedRowData.state){
							validateMessage += "页面："+selectedRowData.cname+"是暂存状态不能生成代码！</br>"
						}
					}
					if(validateMessage != ""){
						cui.alert(validateMessage, null, {width: 400});
						return;
					}
					cui.confirm("是否要生成这"+selectIds.length+"个界面吗？",{
						onYes:function(){
							cui.handleMask({
					        	html:'<div style="padding:10px;border:1px solid #666;background: #fff;">代码生成中请耐心等待</div>'
					        }).show();
							NewPageAction.generateByIdList(selectIds,getModelPackage(),function(result){
								cui.handleMask.hide();
							});
						}
					});
				}
			}
				
			function renderPreviewLink(rd, index, col) {
				if(rd.pageType == 1){
					return "<span class='cui-icon' style='font-size:12pt;color:#545454;cursor:pointer' onclick=\"window.open('${pageScope.cuiWebRoot}"+rd.url+"')\">&#xf002;</span>";
				}
				return "";
			}
			
			//状态列渲染数据函数
			function renderState(rd, index, col) {
				return rd['state'] ? "可用" : "暂存";
			}
			
			var dependOnCurrentData =[];
			var currentDependOnData =[];
			var checkUrl = "<%=request.getContextPath() %>/cap/bm/dev/consistency/ConsistencyCheckResult.jsp?checkType=main&init=true";
			/**
			*检查元数据一致性 是否通过
			*@selectDatas 当前所选对象数组 
			*@type 数据类型
			*/
			function checkConsistency(selectDatas,type){
				var checkflag = true;
				dwr.TOPEngine.setAsync(false);
				//删除之前先检查元素一致性依赖
				dependOnCurrentData = [];
				if(type=="page"){
					PageFacade.pageConsistency4BeingDependOn(selectDatas,function(redata){
						if(redata){
							  if (!redata.validateResult) {//有错误
								  dependOnCurrentData = redata.dependOnCurrent==null?[]:redata.dependOnCurrent;
								  initOpenConsistencyImage(checkUrl);
								  cui.alert('当前选择页面不能被删除，请检查元数据一致性');
								  checkflag = false;
							  }else{
								  //cui.message('元数据一致性效验通过！', 'success');
								  initOpenConsistencyImage(checkUrl);//通过则关闭div和dialog
								  //cui.alert('当前选择页面不能被删除，请检查元数据一致性');
								  //checkflag = false;//直接返回 需要放上一层
							  }
						  }else{
							  cui.error("元数据一致性效验异常，请联系管理员！"); 
						  }
					});
				}
				dwr.TOPEngine.setAsync(true);
				return checkflag;
			}
		</script>
	</body>
</html>
