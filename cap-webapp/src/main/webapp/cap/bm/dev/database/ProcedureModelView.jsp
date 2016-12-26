<%
  /**********************************************************************
	* CIP元数据建模----实体信息编辑
	* 2015-12-17 zhangzunzhi 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!doctype html>
<html>
<head>
<title>存储过程信息页面</title>
	<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/ptc/index/image/produce.png">
	<top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src='/cap/dwr/interface/ProcedureFacade.js'></top:script>
</head>
<style type="text/css">

</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_title">数据库存储过程信息</div>
		<div class="thw_operate">
			<span id="return" uitype="button" label="返 回" on_click="back"></span> 
			<span id="return" uitype="button" label="保 存" on_click="save"></span> 
			<span id="close" uitype="Button" label="关 闭" on_click="closeWindow"></span>
		</div>
	</div>
	<div id="editDiv"  class="top_content_wrap cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="10%" />
				<col width="40%" />
				<col width="10%" />
				<col width="40%" />
			</colgroup>
			<tr ><td class="divTitle">基本信息</td></tr>
			<tr>
				<td class="td_label">存储过程名：</td>
				<td >
					<span uitype="input" id="engName" name="engName" databind="procedureData.engName" width="100%"  readonly="true">
				</td>
				<td class="td_label">中文名：</td>
				<td >
					<span uitype="input" id="chName" name="chName" databind="procedureData.chName" width="100%" >
				</td>
			</tr>
			<tr>	
				<td class="td_label" valign="top" style="padding-top: 5px;">描述：</td>
				<td >
					<span uitype="textarea" id="description" maxlength="-1" databind="procedureData.description" 
			      		width="100%" " name="description" ></span>
				</td>
			</tr>
			<tr ><td class="divTitle">参数信息</td></tr>
		</table>
		<table uitype="Grid" id="TableColumnGrid" primarykey="parameterName" selectrows="no" sorttype="DESC" datasource="initData" pagination="false"  pagesize_list="[10,20,30]"  
				 	resizewidth="resizeWidth" gridheight="auto">
		 	<thead>
		 	<tr>
				<th renderStyle="text-align: center" bindName="1" style="width:3%;">序号</th>
				<th bindName="parameterName" style="width:10%;" renderStyle="text-align: left;" render="parameterNameEditLink" >参数名</th>
				<th bindName="parameterChName" style="width:10%;" renderStyle="text-align: left;" >中文名</th>
				<th bindName="parameterType" style="width:10%;" renderStyle="text-align: left;" render="renderFieldType">参数种类</th>
				<th bindName="dataType" style="width:10%;" renderStyle="text-align: center" >数据类型</th>
				<th bindName="length" style="width:10%;" renderStyle="text-align: center" >长度</th>
				<th bindName="precision" style="width:10%;" renderStyle="text-align: center" >精度</th>
				<th bindName="description" style="width:10%;" renderStyle="text-align: center" >描述</th>
			</tr>
			</thead>
		</table>
	</div>


	<script type="text/javascript">
	var openType = "${param.openType}";//listToMain
	var packageId = "${param.packageId}";//包ID
	var modelId = "${param.modelId}";//视图ID
	var packagePath = "${param.packagePath}";//包路径
	var inited = false;
	
    var procedureData = {};
    
   	window.onload = function(){
   		init();
   		showReturnOrClose();
   	}
   	
	function init() {
		dwr.TOPEngine.setAsync(false);
		ProcedureFacade.queryProcedureById(modelId,function(data){
			procedureData = data;
		});
		dwr.TOPEngine.setAsync(true);
		inited = true;
		comtop.UI.scan();
		
	}
	//grid数据源
	function initData(tableObj,query){
		if(inited) {
			tableObj.setDatasource(procedureData.procedureColumns,procedureData.procedureColumns.length);
		}
	}
	
	   //显示关闭或者是返回按钮
	   function showReturnOrClose(){
		     if(openType=="listToMain"){
		    	 cui("#close").hide();
		     }else{
		    	 cui("#return").hide();
		     }
	   }
	   
		function closeWindow(){
			window.close();
		}
	
	// 字段类型
// 	var fieldTypeData = ["procedureColumnUnknown","procedureColumnIn","procedureColumnInOut","procedureColumnOut","procedureColumnReturn","procedureColumnResult"];
	var fieldTypeData = ["未知参数","输入参数","输入输出参数","输出参数","返回参数","返回结果"];
	//grid列渲染
	function renderFieldType(data,field){
		if(data.parameterType < fieldTypeData.length) {
			return fieldTypeData[data.parameterType];
		}
		return "";
	}
	
	function back() {
		window.location.href = "ProcedureModelList.jsp?packageId=${param.packageId}"+"&packagePath="+packagePath;
	}
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	//保存存储过程
	function save(){
		dwr.TOPEngine.setAsync(false);
		ProcedureFacade.saveProcedure(procedureData,function(data){
			  if(data){
				  cui.message('保存成功！', 'success');
				  //如果是从AppDeail.jsp入口，保存成功后需要刷新父窗口
				  if(window.parent){
					if(window.parent.opener){
						window.parent.opener.refresh();
					}
				  }
			  }else{
				  cui.error("保存失败！"); 
			  }
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//方法名渲染
	function parameterNameEditLink(rd, index, col) {
		var parameterName = rd.parameterName;
// 		cui("#TableColumnGrid").selectRowsByPK(rd.parameterName,true);
 		return "<a href='javascript:;' onclick='updateParameterChName(\"" +rd.parameterName+ "\",\""+rd.parameterName+"\");'>" +parameterName + "</a>";
	}
	var dialog;
	var objectVO;
	// 编辑服务方法
	function updateParameterChName(parameterName,id) {
		for(var i= 0 ; i <  procedureData.procedureColumns.length; i++) {
			if((id && id ==  procedureData.procedureColumns[i].id) || parameterName ==  procedureData.procedureColumns[i].parameterName) {
				objectVO = procedureData.procedureColumns[i];
				break;
			}
		}
		var url = "DatabaseParameterEdit.jsp"; 
		var title="属性编辑";
		var height = 250; //600
		var width =  320; // 680;
		if(!dialog){
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				page_scroll : true,
				height : height
			});
		}
		dialog.show(url);
	}
	
	//编辑参数回调
 	function editParameterBack(pVo) {
 		if(procedureData.procedureColumns && procedureData.procedureColumns.length) {
	 		for(var i= 0 ; i <  procedureData.procedureColumns.length; i++) {
	 			var o1 = procedureData.procedureColumns[i];
	 			if((o1.id != null && o1.id == pVo.id)|| o1.parameterName == pVo.parameterName) {
	 				procedureData.procedureColumns[i] = pVo;
	 				break;
	 			}
			}
	 		//刷新页面
	 		cui("#TableColumnGrid").loadData();
 		}
	}
	
</script>
</body>
</html>