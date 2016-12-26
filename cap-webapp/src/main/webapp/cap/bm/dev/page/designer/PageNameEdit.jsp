<%
/**********************************************************************
* 页面选择界面
* 2015-6-23 章尊志 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>页面名称编辑</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/SystemModelAction.js'></top:script>
    <top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<style type="text/css">
		img{
		  margin-left:5px;
		}
	</style>
</head>
<body>
		<table class="cap-table-fullWidth" width="100%">
		    <tr>
		        <td class="cap-td" style="text-align: left;padding:5px">
		        	<span id="formTitle" uitype="Label" value="界面列表" class="cap-label-title" size="12pt"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;padding:5px">
		        	 <span id="saveToPage" uitype="Button" onclick="savePageInfo()" label="保存"></span> 
			         <span id="closeTemplate" uitype="Button" onclick="pageClose()" label="关闭"></span> 
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth" width="100%">
		    <tr>
		        <td class="cap-td" width="100%">
		        	<table uitype="EditableGrid" id="copyPage" primarykey="modelId" edittype="pageNameEdit" colhidden="false" datasource="initCopyPageData"
		        		 pagination="false" resizewidth="getBodyWidth" resizeheight="getBodyHeight" editafter="editPageInfo" submitdata="submitdata"> 
						<thead>
							<tr>
							    <th style="width:5%"></th>
								<th  style="width:5%" renderStyle="text-align: center;" bindName="1">序号</th>
								<th  style="width:20%" renderStyle="text-align: left;" bindName="cname">页面中文名/页面标题</th>
								<th  style="width:20%" renderStyle="text-align: left" bindName="modelName">页面英文名</th>
								<th  style="width:25%" renderStyle="text-align: left" bindName="newModelName">新页面英文名</th>
								<th  style="width:25%" renderStyle="text-align: left" bindName="newCname">新页面中文名/新页面标题</th>
							</tr>
						</thead>
					</table>
		        </td>
		    </tr>
		</table>
	<script type="text/javascript">
	var systemModuleId =<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("systemModuleId"))%>;
	var openType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("openType"))%>;//
	var selectType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("selectType"))%>;//选择类型，分为选择jsp或者是全部页面
	var flag =  <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("flag"))%>;//界面设计器选择页面用，绑定的属性标志
	var pageinfoValidateFlag = true;
	var updatePage =[];
	//var pageModelNameValRule = [{type:'required',rule:{m:'页面信息->页面文件名：不能为空'}},{type:'format', rule:{pattern:'\^[A-Z]\\w+\$', m:'页面信息->页面文件名：只能输入由字母、数字或者下划线组成的字符串,且首字符必须为大写字母'}},{type:'custom',rule:{against:'isExistNewModelName', m:'页面信息->页面属性：页面文件名称已存在'}}];
	
	var pageNameEdit = {
			    "newModelName" : {
			        uitype: "Input",
			        validate:[{type:'required',rule:{m:'页面信息->页面文件名：不能为空'}},{type:'format', rule:{pattern:'\^[A-Z]\\w+\$', m:'页面信息->页面文件名：只能输入由字母、数字或者下划线组成的字符串,且首字符必须为大写字母'}},{type:'custom',rule:{against:'isExistNewModelName', m:'页面信息->页面属性：页面文件名称已存在'}}]
			    },
			    "newCname" : {
			        uitype: "Input",
			        validate:[{type:'required',rule:{m:'页面信息->页面文件名：不能为空'}}],
				    maxlength: 100
			    },
	};
	
	$(document).ready(function(){
		comtop.UI.scan();   //扫描
	});
	
	//初始化数据 
	function initCopyPageData(obj) {
		var pagesInfo = window.opener.returnSelectPage();
		if(pagesInfo==null||pagesInfo==undefined||pagesInfo.length==0){
			obj.setDatasource([],0);
		}else{
			for(var i=0; i<pagesInfo.length; i++){
					if(updatePage.length!=0){
						for(var j=0; j<updatePage.length; j++){
							if(updatePage[j].model==pagesInfo[i]){
								pagesInfo[i].newModelName=updatePage[j].newModelName;
								pagesInfo[i].newCname=updatePage[j].newCname;
							}
						}
					}else{
						pagesInfo[i].newModelName="";
						pagesInfo[i].newCname="";
					}
			}
			obj.setDatasource(pagesInfo,pagesInfo.length);
			for(var i=0; i<pagesInfo.length; i++){
				if(updatePage.length==0){
					pagesInfo[i].newModelName="Copyof"+pagesInfo[i].modelName;
					pagesInfo[i].newCname="复制"+pagesInfo[i].cname;
				}
				obj.changeData(pagesInfo[i] ,i);
			}
		}
	}
	
	//新增或修改的页面文件名是否已存在
    function isExistNewModelName(modelName){
    	var result = true;
    	dwr.TOPEngine.setAsync(false);
    	PageFacade.isExistNewModelName(modelName,function(data){
    		result = !data;
		});	
		dwr.TOPEngine.setAsync(true);
		return result;
    }
	
    function submitdata(grid,changeData){
//		grid.submitComplete();
    }

	//确认复制页面信息
	function savePageInfo(){
		//已经填写后的页面信息集合
		updatePage = cui("#copyPage").getChangeData().updateData;
		//需要复制页面数量
		var iDataSize = cui("#copyPage").getData().length;
		//判断复制页面信息是否填写
		if(updatePage==null || updatePage==undefined || updatePage.length==0 || updatePage.length !=iDataSize){
			cui.alert("请填写复制后页面信息!");
			return;
		}
		//判断复制页面中页面名称填写是否重复
		for(var i = 0; i<updatePage.length; i++){
			var pageName = updatePage[i].newModelName;
			for(var j = i+1; j<updatePage.length; j++){
				var nextPageName = updatePage[j].newModelName;
				if(pageName==nextPageName){
					cui.alert("复制后页面信息中页面名称不能重复!");
					return ;
				}
			}
			var isNew = isExistNewModelName(pageName);
			if(!isNew){
				cui.alert("页面名称已存在，请修改页面名称!");
				return ;
			}
		}
		//调用验证规则
		var result = cui("#copyPage").submit();
		if(result=="noChange"){
			cui.alert("请填写复制后页面信息!");
			return;
		}
		if(result == 'fail'){
			return;
		}
		for(var i=0; i<iDataSize; i++){
			if(updatePage[i].newModelName=="" || updatePage[i].newCname==""){
				cui.alert("请填写复制后页面信息!");
				return;
			}
		}
		for(var i=0; i<iDataSize; i++){
			updatePage[i].modelName=updatePage[i].newModelName;
			updatePage[i].cname=updatePage[i].newCname;
		}
		//生成数据脚本sql文件
		var codePath = cui.utils.getCookie("GEN_CODE_PATH_CNAME");
		var rsNum = 0;
		dwr.TOPEngine.setAsync(false);
		PageFacade.saveModelList(updatePage, codePath, function(result) {
			rsNum = result;
		});
		dwr.TOPEngine.setAsync(true);
		if (rsNum==iDataSize) {
			window.opener.copyPageResult(true);
		} else if(rsNum==0){
			window.opener.copyPageResult(false);
		} else{
			window.opener.copyPageResult(rsNum);		
		}
		window.close();
		
	}
	
    //页面关闭
	function pageClose(){
		window.close();
	}
	
	/**
	 * 表格自适应宽度
	 */
	function getBodyWidth () {
	    return  ($("body").innerWidth()) - 10;
	}

	/**
	 * 表格自适应高度
	 */
	function getBodyHeight () {
	    return (document.documentElement.clientHeight || document.body.clientHeight) - 71;
	}
	
	</script>
</body>
</html>