<!doctype html>
<%
  /**********************************************************************
	* 界面原型编辑
	* 2015-12-2 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
<title>界面原型</title>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.all.js" />
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
</head>
<style>
.buttonDiv{
	margin-right:4px;
	margin-bottom:4px;
}
</style>
<body class="top_body">
	<div id="editDiv">
		<div class="buttonDiv" style="float:right">
			<span uitype="button" label="新增" id="newPrototype"  menu="newPrototypeMenu" button_type="blue-button"></span>
			<span id="generateCode" uitype="Button" onclick="generateCode()" button_type="blue-button" label="生成原型页面"></span> 
			<span id="toImage" uitype="Button" onclick="generateImage()" button_type="blue-button" label="导出原型图片"></span> 
			<span uitype="Button" id="ReqPageGridUpButton" label="上移"  on_click="upPage" mark="ReqPageGrid" button_type="blue-button"></span>
			<span uitype="Button" id="ReqPageGridDownButton" label="下移"  on_click="downPage" mark="ReqPageGrid" button_type="blue-button"></span>
			<span uitype="button" on_click="deletePage" id="btnDelete" label="删除" button_type="blue-button"></span> 
		</div>
		<div >
		<table uitype="Grid" id="ReqPageGrid"  gridheight="auto"  ellipsis="true"  colhidden="false" 
				pagination="false" selectrows="multi"  datasource="initGridData"  rowclick_callback="pageGridOneClick" selectall_callback="pageGridAllClick"
				resizeheight="resizeHeight"  resizewidth="resizeWidth">
			<tr>
				<th width="5%"><input type="checkbox" /></th>
				<th bindName="cname" width="12%" render="editPrototype">界面标题</th>
				<th bindName="modelName" width="12%">界面文件名</th>
				<th width="56%" bindName="description">界面说明</th>
				<th width="10%" renderStyle="text-align: center;" render="pageView">预览</th>
				<th width="5%" renderStyle="text-align: center;" render="imageDownLoad">下载图片</th>
			</tr>
		</table>	
		</div>
	</div>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.editor.min.js" />
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js" /> 
	<top:script src="/cap/dwr/interface/PrototypeFacade.js" />
	<top:script src="/cap/dwr/interface/PrototypeAction.js" />
	<top:script src="/cap/dwr/interface/FileLoaderAction.js" />
<script language="javascript">
	var modelPackage = "com.comtop.prototype."+"<c:out value='${param.modelPackage}'/>";
	var reqFunctionSubitemId = "<c:out value='${param.ReqFunctionSubitemId}'/>";
	//var modelPackage = "com.comtop.prototype.DM-0000000007.E-IM01-004.E-IM01-004-001";
	//原型图片预览地址的前缀
	var imageVisitPrefix;
   	window.onload = function(){
   		getImageVisitPrefix();
   		comtop.UI.scan();
   		setButtonIsDisable("ReqPageGrid",true,true);
   	}
   	
   	/**
   	 * 获取界面原型图片在服务器上的访问地址的前缀，用于图片预览
   	 */
   	function getImageVisitPrefix(){
   		dwr.TOPEngine.setAsync(false);
   		PrototypeAction.getImageVisitPrefix(function(data){
   			imageVisitPrefix = data;
		});
		dwr.TOPEngine.setAsync(true);
   	}
   	
   	/**
     * 新增界面原型菜单按钮数据源
     */
    var newPrototypeMenu = function (){
    	var menuArray = [
    	                   {id : "addNew", label : "新增界面原型", click : "addNew"},
    	                   {id : "addOld", label : "录入自定义界面原型", click : "addOld"}
    	                ];
    	return {
			datasource : menuArray,
			on_click : function(obj){
				eval(obj.click)();
			 }
		};
    };
    
  	//进入界面原型设计器新增界面原型
	function addNew(){
		var url = "${pageScope.cuiWebRoot}/cap/bm/req/prototype/PrototypeMain.jsp?modelPackage=" + modelPackage + "&reqFunctionSubitemId=" + reqFunctionSubitemId;
		window.open(url, "_blank");
	}
  	
  	var dialog;
  	//打开录入自定义界面原型窗口
  	function addOld(pId){
  		var url = "${pageScope.cuiWebRoot}/cap/bm/req/subfunc/ReqUserDedinePrototype.jsp?modelPackage=" + modelPackage;
  		if(pId){
  			url += "&modelId=" + pId;
  		}
		var title="录入自定义界面原型";
		var height = 300; 
		var width =  750; 
		if(!dialog){
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			});	
		}
		dialog.show(url);
  	}
  	
  	//关闭dialog
  	function dialogClose(){
  		dialog.hide();
  	}
   	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) -60;
	}
	
	//界面原型列表初始化
	function initGridData(tableObj,query){
		dwr.TOPEngine.setAsync(typeof async === 'undefined' ? false : async);
		PrototypeFacade.queryPrototypesByModelPackage(modelPackage,function(data){
			 tableObj.setDatasource(data, data.length);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//界面原型中文名称渲染
	function editPrototype(rd, index, col){
		if(rd.type == 0){
			//打开设计器
			return "<a href='${pageScope.cuiWebRoot}/cap/bm/req/prototype/PrototypeMain.jsp?modelId=" + rd['modelId'] + "&modelPackage=" + rd['modelPackage'] + "&reqFunctionSubitemId=" + reqFunctionSubitemId +"' target='_blank'>" + rd['cname'] + "<a>";
		}else if(rd.type == 1){
			//打开录入已有界面原型
			return "<a onclick=\"addOld('"+rd.modelId+"')\">" + processSpecialChars(rd['cname']) + "<a>";
		}
	}
	
	
	/**
	 * 处理<>在html里面的显示问题。对<>进行转义
	 * @param 需要转义的文本。
	 */
	function processSpecialChars(param){
		if(!param){
			return param;
		}
		return param.replace(/[<]/g,"&lt;").replace(/[>]/g,"&gt;");
	}
	
	var handleMask;
	//生成界面原型页面
	function generateCode(){
		var selectDatas = cui("#ReqPageGrid").getSelectedRowData();
		if(selectDatas == null || selectDatas.length == 0){
			cui.alert("请选择要生成页面的界面原型(不包含自定义界面原型)。");
			return;
		}else{
			if(!hasCanGenPrototypes(selectDatas)){
				cui.alert("请选择要生成页面的界面原型(不包含自定义界面原型)。");
				return;
			}
			var selectIds = getCanGenPrototypeIds(selectDatas);
			cui.confirm("是否要生成这些界面原型页面(不包含自定义界面原型)吗？",{
				onYes:function(){
					if(!handleMask){
						handleMask = cui.handleMask({
				        	html:'<div style="padding:10px;border:1px solid #666;background: #fff; border-radius:6px;">正在生成...请耐心等待...</div>'
				        });
					}
					handleMask.show();
					PrototypeAction.generateByIdList(selectIds,modelPackage,{callback:function(data){
						handleMask.hide();
						cui.message("生成界面原型页面成功", "success");
					},errorHandler:function(){
						handleMask.hide();
						cui.message("生成界面原型页面失败", "error");
					}});
				}
			});
		}
	}
	
	/**
	 * 导出界面原型图片，并把生成的界面原型图片上传到服务器
	 * 默认路径保存在：webapp/prototype/REQ_PROTOTYPE_IMAGE/目录下。可在首选项中进行配置。
	 */
	function generateImage(){
		var selectDatas = cui("#ReqPageGrid").getSelectedRowData();
		if(selectDatas == null || selectDatas.length == 0){
			cui.alert("请选择要导出图片的界面原型(不包含自定义界面原型)。");
			return;
		}else{
			if(!hasCanGenPrototypes(selectDatas)){
				cui.alert("请选择要导出图片的界面原型(不包含自定义界面原型)。");
				return;
			}
		}
		cui.confirm("是否要导出这些界面原型图片吗？",{
			onYes:function(){
				if(!handleMask){
					handleMask = cui.handleMask({
			        	html:'<div style="padding:10px;border:1px solid #666;background: #fff;border-radius:6px;">正在生成...请耐心等待...</div>'
			        });
				}
				handleMask.show();
				//生成图片先生成代码
				var selectIds = getCanGenPrototypeIds(selectDatas);
				dwr.TOPEngine.setAsync(false);
				PrototypeAction.generateByIdList(selectIds,modelPackage,{callback:function(data){
					//do nothing
				},errorHandler:function(){
					handleMask.hide();
					cui.message("生成界面原型页面失败", "error");
				}});
				dwr.TOPEngine.setAsync(true);
				
				//循环生成图片
				var isOver = 0;
				for(var i = 0, len = selectDatas.length; i < len; i++){
					if(selectDatas[i].type != 0){
						isOver++;
						continue;
					}
					var htmlURL = "${pageScope.cuiWebRoot}/prototype/" + selectDatas[i].url;
					var imageName =  selectDatas[i].modelName + ".png";
					PrototypeAction.htmlToImage(modelPackage, selectIds, htmlURL, imageName, reqFunctionSubitemId, {callback : function(){
						isOver++;
						if(isOver == selectDatas.length){
							handleMask.hide();
							cui.message("导出图片成功","success");
						}
					},errorHandler : function(){
						handleMask.hide();
						cui.message("导出图片失败（可能部分成功）", "error");
					}});
				}
			}
		});
	}
	
	
	/**
	 * 是否存在允许生成页面或图片的界面原型，自定义的界面原型是不允许生成
	 *
	 * @param selectDatas 界面原型集合
	 * @return 判断的结果 true表示存在，false表示不存在
	 */
	function hasCanGenPrototypes(selectDatas){
		var hasCanGenPrototype = false;
		for(var k = 0; k < selectDatas.length; k++){
			if(selectDatas[k].type == 0){
				hasCanGenPrototype = true;
				break;
			}
		}
		return hasCanGenPrototype;
	}
	
	
	/**
	 * 获取选择的界面原型集合中能生成代码或生成图片的界面原型id集合
	 *
	 * @param 选择的界面原型集合
	 * @return 能生成代码的界面原型的id集合
	 */
	function getCanGenPrototypeIds(datas){
		var selectIds = [];
		if(!datas || datas.length == 0){
			return selectIds;
		}
		for(var i = 0, len = datas.length; i < len; i++){
			if(datas[i].type == 0){
				selectIds.push(datas[i].modelId);
			}
		}
		return selectIds;
	}
	
	
	//删除界面原型，暂不删除界面原型已生成的页面和图片
	function deletePage(){
		var selectDatas = cui("#ReqPageGrid").getSelectedRowData();
		if(!selectDatas || selectDatas.length == 0){
			cui.alert("请选择要删除的界面原型。");
			return;
		}
		var selects=[];
		for(var i = 0, len = selectDatas.length; i < len; i++){
			selects.push(selectDatas[i].modelId);
		}
		cui.confirm("确定要删除这"+selects.length+"个界面原型吗?",{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				PrototypeFacade.deleteModel(selects,function(data){
					if(data.flag){
						cui.message('删除成功。','success');
					}else if(!data.flag && data.failReuslt.length > 0 ){
						cui.message('部分删除失败。','warn');
					}
				});
				dwr.TOPEngine.setAsync(true);
				refleshGrid();
				setButtonIsDisable("ReqPageGrid",true,true);
			}
		});
	}
	
	//预览渲染，包括页面预览与图片预览
	function pageView(rd, index, col){
		var operate = "";
		//录入已有界面原型，没有预览HTML的功能
		if(rd.type == 0){
			operate += "<span class='cui-icon' title='预览HTML' style='font-size:11pt;color:#545454;cursor:pointer' onclick=\"window.open('${pageScope.cuiWebRoot}/prototype/"+rd.url+"')\">&#xf002;</span>";
		}
		//如果无法获取预览图片地址路径的前缀，则不渲染预览按钮
		if(imageVisitPrefix){
			if(rd.type == 0){
				operate += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
			}
			operate += "<span class='cui-icon' title='预览图片' style='font-size:11pt;color:#545454;cursor:pointer' onclick=\"window.open('"+imageVisitPrefix+rd.imageURL+"')\">&#xf03e;</span>"
		}
		return operate;
		
	}
	
	//界面原型图片下载渲染
	function imageDownLoad(rd, index, col){
		if(imageVisitPrefix){
			//REQ_PROTOTYPE_IMAGE/DM-0000000007/E-IM01-004/E-IM01-004-001/ReceiptEditPage2.png
			var regexp = /^(REQ_PROTOTYPE_IMAGE)\b.{1}(.+[/\\])(.+[.][a-zA-Z]+)$/;
			var result = regexp.exec(rd.imageURL);
			if(!result){
				return "";
			}
			return "<a class='cui-icon' title='下载图片' style='font-size:11pt;color:#545454;cursor:pointer' onclick=\"imageDownLoadProcess('"+result[1]+"','"+result[2]+"','"+result[3]+"')\" >&#xf019;</a>";
		}
		return "";
	}
	
	//界面原型图片下载
	function imageDownLoadProcess(uploadKey, uploadId, fileName){
		dwr.TOPEngine.setAsync(false);
		FileLoaderAction.downloadFile(uploadKey, uploadId, fileName,{callback :function(data){
			dwr.TOPEngine.openInDownload(data);
		},errorHandler:function(){
			cui.warn('下载失败！');
		}});
		dwr.TOPEngine.setAsync(true);
	}
	
	//gird刷新
	function refleshGrid(){
		cui("#ReqPageGrid").loadData();
	}
	
	function pageGridOneClick(){
		oneClick('ReqPageGrid');
	}
	function pageGridAllClick(){
		allClick('ReqPageGrid');
	}
	
	//按钮单选
	function oneClick(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var gridData = cui("#" + gridId).getData();
		if(indexs.length == 0){ //全不选-不能上移下移置顶置底
			setButtonIsDisable(gridId,true,true,true,true);
		}else{
			if(isContinue(indexs)){ // 是连续的-可上移下移
				if(indexs[0] == 0 && indexs[indexs.length-1] != gridData.length-1){ //包含了第一条记录只能下移、置底
					setButtonIsDisable(gridId,true,false,true,false);
				}else if(indexs[indexs.length-1] == gridData.length-1 && indexs[0] != 0 ){ //包含了最后一条记录只能上移、置顶
					setButtonIsDisable(gridId,false,true,false,true);
				}else if(indexs[0] == 0  && indexs[indexs.length-1] == gridData.length-1 ){//不能上移下移置顶置底
					setButtonIsDisable(gridId,true,true,true,true);
				}else{ //可上移下移置顶置底
				   setButtonIsDisable(gridId,false,false,false,false);
				}
			}else{ // 不是连续的
				setButtonIsDisable(gridId,true,true,true,true);
			}
		}
	}
	
	//按钮全选
	function allClick(gridId){
		setButtonIsDisable(gridId,true,true,true,true);
	}
	
	//设置grid的置灰显示
	function setButtonIsDisable(gridId,up,down){
		cui("#" + gridId + "UpButton").disable(up);
		cui("#" + gridId + "DownButton").disable(down);
	}
	
	//grid上移下移，置顶，置底js
	//按钮区域
	function upPage(event, self, mark){
		up(mark);
	}
	
	function downPage(event, self, mark){
		down(mark);
	}
	
	//上移
	function up(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var index = indexs[0];
		if(index == 0){
			return;
		}
		for(var i=0;i<indexs.length;i++){
			var datas = cui("#" + gridId).getData();
			var currentData = datas[indexs[i]];
			var frontData = datas[indexs[i]-1];
			
			var temp = currentData.sortNo;
			currentData.sortNo = frontData.sortNo;
			frontData.sortNo = temp;
			
			cui("#" + gridId).changeData(currentData, indexs[i] - 1);
			cui("#" + gridId).changeData(frontData,indexs[i]);
			cui("#" + gridId).selectRowsByIndex(indexs[i] -1, true);
			cui("#" + gridId).selectRowsByIndex(indexs[i], false);
		}
		
		var selectRows = cui("#" + gridId).getSelectedRowData();
		indexs =  cui("#" + gridId).getSelectedIndex();
		var allData = cui("#" + gridId).getData();
		var otherData = allData[indexs[indexs.length-1]+1];
		if(otherData){
			selectRows.push(otherData);
		}
		
		dwr.TOPEngine.setAsync(false);
		PrototypeFacade.saveModel(selectRows);
		dwr.TOPEngine.setAsync(true);
		//判断按钮是否置灰
		oneClick(gridId);
	}
	
	//下移
	function down(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var index = indexs[indexs.length-1];
		var datas = cui("#" + gridId).getData();
		if(index === datas.length - 1){
			return;
		}
		for(var i=indexs.length-1;i>=0;i--){
			var datas = cui("#" + gridId).getData();
			var currentData = datas[indexs[i]];
			var nextData = datas[indexs[i] + 1];
			
			var temp = currentData.sortNo;
			currentData.sortNo = nextData.sortNo;
			nextData.sortNo = temp;
			
			cui("#" + gridId).changeData(currentData, indexs[i] + 1);
			cui("#" + gridId).changeData(nextData, indexs[i]);
			cui("#" + gridId).selectRowsByIndex(indexs[i], false);
			cui("#" + gridId).selectRowsByIndex(indexs[i] + 1, true);
		}
		
		var selectRows = cui("#" + gridId).getSelectedRowData();
		indexs =  cui("#" + gridId).getSelectedIndex();
		var allData = cui("#" + gridId).getData();
		var otherData = allData[indexs[0] - 1];
		if(otherData){
			selectRows.push(otherData);
		}
		dwr.TOPEngine.setAsync(false);
		PrototypeFacade.saveModel(selectRows);
		dwr.TOPEngine.setAsync(true);
		//判断按钮是否置灰
		oneClick(gridId);
	}
	
	//判断数组是否是连续数组
	function isContinue(array){
		var len=array.length;
		var n0=array[0];
		var sortDirection=1;//默认升序
		if(array[0]>array[len-1]){
		        //降序
				sortDirection=-1;
		}
		if((n0*1+(len-1)*sortDirection) !== array[len-1]){
		        return false;
		}
		var isContinuation=true;
			for(var i=0;i<len;i++){
		        if(array[i] !== (i+n0*sortDirection)){
		            isContinuation=false;
		            break;
				}
			 }
		return isContinuation;
	}
	
	function messageHandle(e) {
		if(e.data.type=="refleshGrid"){
			async = true;
			refleshGrid();
			async = false;
		}
	}
	window.addEventListener("message", messageHandle, false);
</script>
</body>
</html>