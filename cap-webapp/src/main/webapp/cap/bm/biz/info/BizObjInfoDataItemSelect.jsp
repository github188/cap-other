<%
  /**********************************************************************
	* CIP元数据建模----服务新增
	* 2015-6-30 李小芬 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
<title>业务对象数据项选择页面</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/BizObjInfoAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/BizDomainAction.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/cui.utils.js"></script>

</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
.editGrid{
  margin-left: 100px;
}
</style>
<body>
<div uitype="Borderlayout" id="objectMain" is_root="true" >
	<div position="left" width="300" collapsable="true">
		<div class="top_header_wrap">
			<div class="thw_operate" id="BizObjDiv" align="left">
				<table class="form_table" style="table-layout:fixed;">
					<tr align="left">
						<td class="td_label"><span style="padding-left: 10px;">编码：</span>
							<span uitype="Input" id="code" maxlength="100" byte="true" textmode="false" align="left" width="75%" databind="BizObjInfo.code" type="text" readonly="false"></span>
						</td>
					</tr>
					<tr align="left">
						<td class="td_label"><span style="padding-left: 10px;">名称：</span>
							<span uitype="Input" id="name" maxlength="100" byte="true" textmode="false" align="left" width="75%" databind="BizObjInfo.name" type="text" readonly="false"></span>
						</td>	
					</tr>
					<tr align="left">
						<td class="td_label"><span style="padding-left: 10px;">业务域：</span>
							<span uitype="Input" id="domainName" maxlength="-1" byte="true" textmode="false" align="left" width="60%"  type="text" readonly="true" on_focus="chooseDomain" onclick="chooseDomain"></span>
							<a href="javascript:chooseDomain()">选择</a>
						</td>
					</tr>
					<tr align="left">
						<td class="td_label">
							<span uitype="button" id="clear_btn" label="清空条件" on_click="clearSearch" button_type="orange-button" icon="<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/cui/themes/smartGrid/images/button/clear.gif"></span>
							<span uitype="button" id="search_btn" label="查询" on_click="search" button_type="green-button" icon="<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/cui/themes/smartGrid/images/button/search.gif"></span>
						</td>
					</tr>
				</table>				
			</div>
		</div>
		<table uitype="EditableGrid" id="BizObjGrid" primarykey="id" selectrows="single" datasource="initBizObjDataItemsource" 	gridwidth="270"  pagination="false"  gridheight="auto"
			rowclick_callback="selectOneObject">
			<thead>
				<tr>
					<th style="width:15px" ></th>
					<th render="BizObjRender" renderStyle="text-align: left;" >业务对象名称</th>
				</tr>
			</thead>
		</table>
    </div>
    <div position="center" url="">
	</div>
</div>
<script type="text/javascript">
	var domainId = "${param.domainId}";//业务域ID 
	var selectedObjectId = "";//列表选中的行ID 
	var BizObjInfo = {};
	//初始化 
	window.onload = function(){
		comtop.UI.scan();
		if (domainId && domainId!=null && domainId!=""){			 
			initDomainData(domainId);
		}
   	}
	
	//业务对象数据源
	function initBizObjDataItemsource(tableObj,query) {
		dwr.TOPEngine.setAsync(false);
		BizObjInfoAction.queryBizObjInfoList(BizObjInfo,function(data){
		    tableObj.setDatasource(data.list, data.count);
			setCenterEditUrl(data.list[0].id);
		    if(data.count>0 && !selectedObjectId){//列表存在记录
		    	selectedObjectId = data.list[0].id;
		    }
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	/**
     * 清空查询表单
     */
    function clearSearch(){
       cui(BizObjInfo).databind().setEmpty();
       cui('#domainName').setValue("");	
       search();
    }

    /**
     * 按钮查询事件
     */
    function search(){
        //获取查询条件表单所有数据
        var data = cui(BizObjInfo).databind().getValue();
        //设置Grid的查询条件
        cui('#BizObjGrid').setQuery(data);
        //重新加载数据，loadData时，会重新调用initData
        cui('#BizObjGrid').loadData();
        var objectList=cui("#BizObjGrid").getData();
        cui("#BizObjGrid").selectRowsByIndex(0);
        if(objectList.length>0){
        	var objectId=objectList[0].id;
        	setCenterEditUrl(objectId);
        }
        else{
        	setCenterEditUrl("");
        }
        
    }
	//设置右侧编辑页面 
	function setCenterEditUrl(objectId){ 
		var url = "BizObjInfoView.jsp?readOnly=true&BizObjInfoId=" + objectId + "&domainId="+domainId;	
		cui("#objectMain").setContentURL("center",url); 
	}
	
	//业务对象
	function BizObjRender(rd, index, col) {
		return rd.name + "【" +rd.code + "】";
	}
	
	//单击行事件 
	function selectOneObject(rowData,isChecked,index){
		setCenterEditUrl(rowData.id);
		cui("#BizObjGrid").selectRowsByPK(rowData.id);
	}

	//编辑保存后刷新grid
	function loadGrid(objectId){
		selectedObjectId = objectId;
		cui("#BizObjGrid").loadData();
		cui("#BizObjGrid").selectRowsByPK(selectedObjectId);
	}	
	
</script>
	<top:script src="/cap/bm/biz/info/js/BizObjInfo.js"/>
</body>
</html>