<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<top:verifyRight resourceString="[{menuCode:'SYS_FOURA_LOG'}]"/>
<head>
<title>4A报文列表</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/comtop.ui.emDialog.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/engine.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/MessageContentAction.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<style type="text/css">
	th{
		font-weight:bold;
		font-size: :14px;
	}
</style>
</head>
<body>
<div class="list_header_wrap">
	<div class="top_float_left" >
 		 <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="请输入报文部分内容进行匹配" editable="true" width="300" on_iconclick="iconclick" 
 			        		icon="search" iconwidth="18px"></span> 
 		 &nbsp;&nbsp;&nbsp;&nbsp;类型：
		 <span uiType="PullDown" mode="Single" id="entityTypeQueryType" datasource="entityTypeDataSource" select="all"  label_field="text" value_field="id"  width="100"  on_change="changeConfigItemType"></span>
		 <div style="display: inline;padding-left: 30px;">
			 <span id="startTime" uitype="Calender" maxdate="#endTime" bindName="startTime" ></span>
			 <font>&nbsp;至&nbsp;</font>
	         <span id="endTime" uitype="Calender" mindate="#startTime" bindName="endTime" ></span>
	         <span id="okButton" uitype="Button" on_click="iconclick" label="查询"></span>
         </div>
	</div>
</div>
	<table uitype="grid" id="tableList" primarykey="contentId" datasource="initData" pagesize_list="[10,20,30]"   resizewidth="resizeWidth" resizeheight="resizeHeight"  selectrows="single" colrender="columnRender">
			<thead>
				<tr>
					<th width="5%">&nbsp;</th>
					<th bindName="messageContent" renderStyle="text-align: left;" >报文内容</th>
					<th width="5%" bindName="entityType" renderStyle="text-align: center;" >实体类型</th>
					<th width="10%" bindName="operateTime" renderStyle="text-align: center;"  format="yyyy-MM-dd hh:mm:ss">同步时间</th>
				</tr>
			</thead>
	</table> 
<script type="text/javascript">
var keyword="";//查询关键字
//类题类型类型
var entityTypeDataSource = [
                 {id:'all',text:'全部'},
                 {id:'U',text:'用户'},
                 {id:'O',text:'组织'},
                 {id:'R',text:'角色'},
                 {id:'B',text:'岗位'},
                 {id:'F',text:'功能'},
                 {id:'W',text:'对象'},
                 {id:'U-B',text:'用户-岗位'},
                 {id:'U-R',text:'用户-角色'},
                 {id:'R-F',text:'角色-功能'},
                 {id:'R-W',text:'角色-对象'},
                 {id:'B-R',text:'岗位-角色'},
           ];
window.onload = function(){
	comtop.UI.scan();
}

function initData(tableObj, sQuery) {
	var entityTypeQueryType = cui('#entityTypeQueryType').getValue();
	var startTime = cui('#startTime').getValue();
	var endTime = cui('#endTime').getValue();
	
	dwr.TOPEngine.setAsync(false);
	//此处指定是否是系统模块是为了坑爹的设计，分类树信息存在两张表里面，无法判断关联的表信息
    var query = {pageNo:sQuery.pageNo,pageSize:sQuery.pageSize,
			keyword:$.trim(keyword),entityType:entityTypeQueryType,startTime:startTime,endTime:endTime};
    MessageContentAction.queryMessageContentList(query, function(data) {
	    tableObj.setDatasource(data.list, data.count);
	});
	dwr.TOPEngine.setAsync(true);
}

function resizeWidth() {
	return (document.documentElement.clientWidth || document.body.clientWidth) - 25;
}

function resizeHeight() {
	return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
}
//切换配置项类型
function changeConfigItemType(){
	cui('#tableList').loadData();
}
//搜索框图片点击事件
function iconclick() {
	keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
	keyword = keyword.replace(new RegExp("%", "gm"), "/%");
	keyword = keyword.replace(new RegExp("_","gm"), "/_");
	keyword = keyword.replace(new RegExp("'","gm"), "''");
   cui("#tableList").setQuery({pageNo:1});
   //刷新列表
	cui("#tableList").loadData();
}

//列渲染
function columnRender(data, field) {
	if (field == 'messageContent') {
	    return "<a onclick='javascript:viewMessageContent(\"" + data["contentId"] + "\",\"" + data["messageContent"]+"\");'><font style='color:#096DD1;'>" + data["messageContent"] + "</font></a>";
	}
	if(field == 'entityType'){
		if(data["entityType"] == "U"){
			return "用户";
		}else if(data["entityType"] == "O"){
			return "组织";
		}else if(data["entityType"] == "R"){
			return "角色";
		}else if(data["entityType"] == "B"){
			return "岗位";
		}else if(data["entityType"] == "F"){
			return "功能";
		}else if(data["entityType"] == "W"){
			return "对象";
		}else if(data["entityType"] == "U-B"){
			return "用户-岗位";
		}else if(data["entityType"] == "U-R"){
			return "用户-角色";
		}else if(data["entityType"] == "R-F"){
			return "角色-功能";
		}else if(data["entityType"] == "R-W"){
			return "角色-对象";
		}else if(data["entityType"] == "B-R"){
			return "岗位-角色";
		}
	}
}

//编辑配置项
function viewMessageContent(contentId,messageContent) {
	var url = "";
	if (typeof contentId == "string") {
	    url = "FouraMessageContentView.jsp?contentId=" + contentId+"&messageContent="+messageContent;
	} 
	cui.extend.emDialog({
		id: 'MessageContentListDialog',
		title : '报文消息查看',
		src : webPath + "/top/sys/log/"+url,
		width : 750,
		height : 420
    }).show(webPath + "/top/sys/log/"+url);
}
</script>
</body>
</html>
