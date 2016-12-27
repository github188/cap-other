<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<top:verifyRight resourceString="[{menuCode:'SYS_FOURA_LOG'}]"/>
<head>
<title>4A�����б�</title>
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
 		 <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="�����뱨�Ĳ������ݽ���ƥ��" editable="true" width="300" on_iconclick="iconclick" 
 			        		icon="search" iconwidth="18px"></span> 
 		 &nbsp;&nbsp;&nbsp;&nbsp;���ͣ�
		 <span uiType="PullDown" mode="Single" id="entityTypeQueryType" datasource="entityTypeDataSource" select="all"  label_field="text" value_field="id"  width="100"  on_change="changeConfigItemType"></span>
		 <div style="display: inline;padding-left: 30px;">
			 <span id="startTime" uitype="Calender" maxdate="#endTime" bindName="startTime" ></span>
			 <font>&nbsp;��&nbsp;</font>
	         <span id="endTime" uitype="Calender" mindate="#startTime" bindName="endTime" ></span>
	         <span id="okButton" uitype="Button" on_click="iconclick" label="��ѯ"></span>
         </div>
	</div>
</div>
	<table uitype="grid" id="tableList" primarykey="contentId" datasource="initData" pagesize_list="[10,20,30]"   resizewidth="resizeWidth" resizeheight="resizeHeight"  selectrows="single" colrender="columnRender">
			<thead>
				<tr>
					<th width="5%">&nbsp;</th>
					<th bindName="messageContent" renderStyle="text-align: left;" >��������</th>
					<th width="5%" bindName="entityType" renderStyle="text-align: center;" >ʵ������</th>
					<th width="10%" bindName="operateTime" renderStyle="text-align: center;"  format="yyyy-MM-dd hh:mm:ss">ͬ��ʱ��</th>
				</tr>
			</thead>
	</table> 
<script type="text/javascript">
var keyword="";//��ѯ�ؼ���
//������������
var entityTypeDataSource = [
                 {id:'all',text:'ȫ��'},
                 {id:'U',text:'�û�'},
                 {id:'O',text:'��֯'},
                 {id:'R',text:'��ɫ'},
                 {id:'B',text:'��λ'},
                 {id:'F',text:'����'},
                 {id:'W',text:'����'},
                 {id:'U-B',text:'�û�-��λ'},
                 {id:'U-R',text:'�û�-��ɫ'},
                 {id:'R-F',text:'��ɫ-����'},
                 {id:'R-W',text:'��ɫ-����'},
                 {id:'B-R',text:'��λ-��ɫ'},
           ];
window.onload = function(){
	comtop.UI.scan();
}

function initData(tableObj, sQuery) {
	var entityTypeQueryType = cui('#entityTypeQueryType').getValue();
	var startTime = cui('#startTime').getValue();
	var endTime = cui('#endTime').getValue();
	
	dwr.TOPEngine.setAsync(false);
	//�˴�ָ���Ƿ���ϵͳģ����Ϊ�˿ӵ�����ƣ���������Ϣ�������ű����棬�޷��жϹ����ı���Ϣ
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
//�л�����������
function changeConfigItemType(){
	cui('#tableList').loadData();
}
//������ͼƬ����¼�
function iconclick() {
	keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
	keyword = keyword.replace(new RegExp("%", "gm"), "/%");
	keyword = keyword.replace(new RegExp("_","gm"), "/_");
	keyword = keyword.replace(new RegExp("'","gm"), "''");
   cui("#tableList").setQuery({pageNo:1});
   //ˢ���б�
	cui("#tableList").loadData();
}

//����Ⱦ
function columnRender(data, field) {
	if (field == 'messageContent') {
	    return "<a onclick='javascript:viewMessageContent(\"" + data["contentId"] + "\",\"" + data["messageContent"]+"\");'><font style='color:#096DD1;'>" + data["messageContent"] + "</font></a>";
	}
	if(field == 'entityType'){
		if(data["entityType"] == "U"){
			return "�û�";
		}else if(data["entityType"] == "O"){
			return "��֯";
		}else if(data["entityType"] == "R"){
			return "��ɫ";
		}else if(data["entityType"] == "B"){
			return "��λ";
		}else if(data["entityType"] == "F"){
			return "����";
		}else if(data["entityType"] == "W"){
			return "����";
		}else if(data["entityType"] == "U-B"){
			return "�û�-��λ";
		}else if(data["entityType"] == "U-R"){
			return "�û�-��ɫ";
		}else if(data["entityType"] == "R-F"){
			return "��ɫ-����";
		}else if(data["entityType"] == "R-W"){
			return "��ɫ-����";
		}else if(data["entityType"] == "B-R"){
			return "��λ-��ɫ";
		}
	}
}

//�༭������
function viewMessageContent(contentId,messageContent) {
	var url = "";
	if (typeof contentId == "string") {
	    url = "FouraMessageContentView.jsp?contentId=" + contentId+"&messageContent="+messageContent;
	} 
	cui.extend.emDialog({
		id: 'MessageContentListDialog',
		title : '������Ϣ�鿴',
		src : webPath + "/top/sys/log/"+url,
		width : 750,
		height : 420
    }).show(webPath + "/top/sys/log/"+url);
}
</script>
</body>
</html>
