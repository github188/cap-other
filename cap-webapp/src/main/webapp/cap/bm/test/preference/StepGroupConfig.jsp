
<%
/**********************************************************************
 * 步骤分组配置界面
 * 2016-6-23 lizhongwen 新建
**********************************************************************/
%>
<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>步骤分组配置</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/common/base/css/base.css"></top:link>
<top:link href="/cap/bm/test/css/icons.css"></top:link>
<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"></top:link>

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/dwr/engine.js"></top:script>
<top:script src="/cap/dwr/util.js"></top:script>
<top:script src="/cap/dwr/interface/StepGroupsFacade.js"></top:script>
<style>
	.top_header_wrap {
		padding-right: 5px;
	}

    #icons-container {
        position: relative;
    }
    
    .icon {
        display: inline-block;
        *display: inline;
        *zoom: 1;
        vertical-align: top;
        text-align: center;
        cursor: pointer;
        width: 24px;
        position: relative;
    }
    
    .icon .icon-img {
        width: 24px;
        height: 24px;
        text-align: center;
        background-size: 100% 100% !important;
    }
</style>
</head>
<body>
	<div id="pageRoot" class="cap-page">
		<div class="cap-area" style="width: 100%;">
			<table class="cap-table-fullWidth">
				<tr>
					<td class="cap-td" style="text-align: left; padding: 5px">
						<span id="formTitle" uitype="Label" value="测试步骤分组列表" class="cap-label-title" size="12pt"></span>
					</td>
					<td class="cap-td" style="text-align: right; padding: 5px">
						<span uitype="button" label="新增" id="button_add" on_click="addStepGroup"></span>
						<span uitype="button" label="删除" id="button_del" on_click="delStepGroup"></span> 
					</td>
				</tr>
			</table>
			<table class="cap-table-fullWidth">
				<tr>
					<td class="cap-td">
						<table uitype="Grid" id="stepGroupGrid" primarykey="code" colhidden="false" datasource="initData" pagination="false"
							resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
							<thead>
								<tr>
									<th style="width: 30px" renderStyle="text-align: center;"><input type="checkbox"></th>
									<th style="width: 50px" renderStyle="text-align: center;" bindName="1">序号</th>
									<th style="width:25%;" renderStyle="text-align: left" render="codeRenderer" bindName="code">编码</th>
									<th style="width:25%;" renderStyle="text-align: left" bindName="name">名称</th>
									<th style="width:25%;" renderStyle="text-align: left" bindName="icon">图标名称</th>
									<th style="width:25%;" renderStyle="text-align: center" render="iconRenderer" bindName="icon">图标</th>
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
</body>

<script type="text/javascript">

window.onload = function(){
	comtop.UI.scan();
}


//grid 宽度
function resizeWidth(){
	return (document.documentElement.clientWidth || document.body.clientWidth) - 30;
}

//grid高度
function resizeHeight(){
	return (document.documentElement.clientHeight || document.body.clientHeight) - 75;
}	

//grid列渲染
function codeRenderer(rd, index, col) {
	return "<a href='javascript:;' onclick='editStepGroup(\"" +rd.code+"\");'>" +rd.code + "</a>";
}

function iconRenderer(rd,index,col){
	return "<div class='icon'><div class='icon-img "+rd.icon+"'></div></div>";
}

//grid数据源
function initData(tableObj,query){
	dwr.TOPEngine.setAsync(false);
	var result = [];
	StepGroupsFacade.loadStepGroups(function(data){
		if(data && data.groups){
			result = data.groups;
		}
		tableObj.setDatasource(result, result.length);
	});
	dwr.TOPEngine.setAsync(true);
}

var dialog;

//新增
function addStepGroup(){
	editStepGroup();
}
//编辑
function editStepGroup(code) {
	var height = 420;
	var width = 550;
	var dialogTitle = "测试步骤分组新增";
	var url ='StepGroupEditUI.jsp';
	if(code){
		dialogTitle = "测试步骤分组编辑";
		 url ='StepGroupEditUI.jsp?code='+code;
	}
	if(!dialog){
		dialog = cui.dialog({
		  	title : dialogTitle,
		  	src : url,
		    width : width,
		    height : height,
		    top: "15%"
		});
	}
	dialog.show(url);
}

//保存步骤分组
function saveStepGroup(vo,opt){
	dwr.TOPEngine.setAsync(false);
	StepGroupsFacade.saveStepGroup(vo,function(result){
		if(result){
			cui.message(opt+"成功。","success");
		}
		cui("#stepGroupGrid").loadData();
	});
	dwr.TOPEngine.setAsync(true);
	closeWindow();
}


//关闭实体名称编辑窗口
function closeWindow(){
	dialog.hide();
}

//删除步骤分组
function delStepGroup() {
	var selects = cui("#stepGroupGrid").getSelectedPrimaryKey();
	if(selects == null || selects.length == 0){
		cui.alert("请选择要删除的步骤分组。");
		return;
	}
	var valIsAbleDelete;
	cui.confirm("确定要删除这"+selects.length+"个步骤分组吗？",{
		onYes:function(){
			if(selects.indexOf("common")!=-1){
				var message = "分组编码为：【common】的默认步骤分组，不能进行删除操作。"
 				cui.alert(message);
				return;
			}
			dwr.TOPEngine.setAsync(false);
			//验证能否被删除
	 		StepGroupsFacade.deleteAble(selects,function(data){
	 			if(data && data.length>0) {
	 				valIsAbleDelete = false;
	 				var message = "分组编码为：【"+data.toString()+"】的步骤分组中含有测试步骤，请先将步骤移除这些分组，才能进行删除操作。"
	 				cui.alert(message);
	 			}else {
	 				valIsAbleDelete = true;
	 			}
	 		});
			//如果不允许删除则直接返回
			if(!valIsAbleDelete) {
				dwr.TOPEngine.setAsync(true);
 				return ;
			}
			StepGroupsFacade.deleteStepGroups(selects,function(data){
				if(data){
					cui.message("删除成功。","success");
				}
	 			cui("#stepGroupGrid").loadData();
	 		});
	 		dwr.TOPEngine.setAsync(true);
		}
	});
}
</script>
</html>