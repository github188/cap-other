<%
/**********************************************************************
* ��ɫ��λ�б�ҳ��:��ɫ��λ�б�ҳ
* 2016-7-27 ���
**********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<html>
<head>
<title>��ɫ��λ�б�ҳ</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/FuncAction.js"></script>
</head>
<style type="text/css">
.post_label {
		float:left;
		width:auto;
        display: block;
        padding: 2px 4px;
        font-size: 12px;
        font-weight: bold;
        line-height: 14px;
        color: #fff; 
        vertical-align: baseline;
        white-space: nowrap;
        text-shadow: 0 -1px 0 rgba(0,0,0,0.25);
        border-radius: 3px;
        cursor: pointer;
        margin:2px 5px;
    }
    .post_name_color{
        background-color: #22A7B8; 
    }
    .post_other_name_color{
    	background-color: #38B3E8; 
    }
    .bg-red{
    background-color: red;
    }
</style>
<body>
<div id="searchArea">
	<span uitype="ClickInput" style="float:right;margin-bottom:10px;" id="postSearch" name="ClickInput" icon="search" enterable="true" on_iconclick="postSearch"
		  editable="true" emptytext="�������λ�ؼ���"></span>

</div>
<div id="roleDiv">
	<table id="roleGrid" uitype="grid" datasource="initData" pagination="false" resizeheight="resizeHeight"  resizewidth="resizeWidth"
		   titlerender="titleRender" ellipsis="false">
	<tr>
			<th style="width:5%;display:none"></th>
	        <th renderStyle="text-align:left;" style= "width:20%" bindName="roleName" >��ɫ</th>
	        <th renderStyle="text-align:left;" style= "width:35%" bindName="postName" render="postRender">������λ</th>
			<th renderStyle="text-align:left;" style= "width:35%" bindName="otherPostName" render="postOtherRender">��������λ</th>
	        
	</tr>
	
	</table>

</div>


</body>
<!-- js�ű� -->
<script type="text/javascript">
//��ǰ�ڵ�ID
var funcId = "<c:out value='${param.funcId}'/>";
//��ǰ�ڵ����� 2 �˵� 4 ҳ�� 5 ����
var funcName = "<c:out value='${param.funcName}'/>";

var data = [];

window.onload=function(){
	comtop.UI.scan();  
}  

function initData(grid,query){
	dwr.TOPEngine.setAsync(false);
	FuncAction.queryPostListByUserId(funcId,function(data){
		
		for(var i=0;i<data.length;i++){
			if(data[i].postName){
				var strs= new Array(); //����һ���� 
				strs=data[i].postName.split(","); //�ַ��ָ� 
				data[i].postName = strs;
			}
			if(data[i].otherPostName){
				var strs= new Array(); //����һ���� 
				strs=data[i].otherPostName.split(","); //�ַ��ָ� 
				data[i].otherPostName = strs;
			}
		}
		this.data = data;
	});
	dwr.TOPEngine.setAsync(true);
	grid.setDatasource(this.data);
}

//Grid�������Ӧ��Ȼص����������ؿ�ȼ���������
function resizeWidth(){
	return 730;
}

//Grid�������Ӧ�߶Ȼص����������ظ߶ȼ���������
function resizeHeight(){
	return (document.documentElement.clientHeight || document.body.clientHeight) - 70 ;
}

//��Ⱦ������λ��ʽ
function postRender(rd, index, col){
	var postName = '';
	if(rd.postName){
		for(var i =0;i<rd.postName.length;i++){
			var post = '<label label class="post_label post_name_color" title="'+rd.postName[i]+'">'+rd.postName[i]+'</label>';
				postName = postName+ post ;
		}
	}
		return (postName);
}

//��Ⱦ��������λ��ʽ
function postOtherRender(rd, index, col){
	var postName = '';
	if(rd.otherPostName){
		for(var i =0;i<rd.otherPostName.length;i++){
			var post = '<label class="post_label post_other_name_color" title="'+rd.otherPostName[i]+'">'+rd.otherPostName[i]+'</label>';
				postName = postName+ post ;
		}
	}
		return (postName);
	
}

function titleRender(rowData, bindName){
    if (bindName == "postName" || bindName == "otherPostName") {
        return rowData[bindName];
    }
}


function postSearch(){
	var searchValue = cui("#postSearch").getValue();
	var count = $('td > label').length;
		for(var i=0;i<count;i++){
			var text = $('td > label')[i].innerText;
			var index = text.indexOf(searchValue);//ƥ���ַ���
			//�ı���Ӧ�ĸ�λ������ɫ
			if(index >= 0 && searchValue){
				$($('td > label')[i]).addClass("bg-red");
			}else if($($('td > label')[i]).hasClass("bg-red")){
				$($('td > label')[i]).removeClass("bg-red");
			}
		}
}
</script>
</html>