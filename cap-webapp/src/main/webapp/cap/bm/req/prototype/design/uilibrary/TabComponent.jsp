<%
/**********************************************************************
* tab组件
* 2015-7-13 章尊志 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>tab组件属性设置</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/jct/js/jct.js"></top:script>
	<top:script src="/cap/bm/req/prototype/js/common.js"></top:script>
	<script type="text/javascript">
    var namespaces = "<%=request.getParameter("namespaces")%>";
    var reqFunctionSubitemId = "<%=request.getParameter("reqFunctionSubitemId")%>";
    var packageId = namespaces, pageId = namespaces;
	var pageSession = new cap.PageStorage(namespaces);
	var pageActions = pageSession.get("action");
	var page = pageSession.get("page");
    var modelPackage = page.modelPackage;
	//设计器页面的tab组件选择框的名字
	var propertyName = "<c:out value='${param.propertyName}'/>";
	//设计器页面tab组件选择框的数据类型
	var valuetype = "<c:out value='${param.valuetype}'/>";
	var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
	//设计器页面tab组件选择框选择的数据
	var selectTabDatas = "";
	
	if(window.opener.currSelectDataModelVal!=""){
		var currSelectData  = window.opener.currSelectDataModelVal;
		//url转换，添加“”
		var arryCurrSelectData = currSelectData.split(",");
		for(i=0;i<arryCurrSelectData.length;i++){
			var objUrl = arryCurrSelectData[i];
			arryCurrSelectData[i] = objUrl;
		}
		currSelectData = arryCurrSelectData.toString();
		selectTabDatas = eval("("+currSelectData+")");
	}
	
	jQuery(document).ready(function() {
		comtop.UI.scan();
	});
	
	/**
	 * 编辑Grid数据加载
	 * @param obj {Object} Grid组件对象
	 * @param query {Object} 查询条件
	 */
	function initData(obj, query) {
		 var changeSelectTabDatas = [];
		 for(j=0;j<selectTabDatas.length;j++){
			 var changeTab = selectTabDatas[j];
			 var tabObj = {title:changeTab.title,linkType:"",linkUrlOrHtml:"",closeable:changeTab.closeable,tab_width:changeTab.tab_width,on_switch:changeTab.on_switch}; 
			 if(typeof(changeTab.html)==="undefined"){
				 tabObj.linkType = "url";
				 tabObj.linkUrlOrHtml = changeTab.url;
			 }else if(typeof(changeTab.url)==="undefined"){
				 tabObj.linkType = "html";
				 tabObj.linkUrlOrHtml = changeTab.html;
			 }
			 changeSelectTabDatas.push(tabObj);
		 }
		 obj.setDatasource(changeSelectTabDatas, changeSelectTabDatas.length);
	}
	 
	//单元格编辑类型
	var edittype = {
	    "title" : {
	        uitype: "Input"
	    },
	    "linkType": {
	        uitype: "RadioGroup",
	        radio_list:[
	        	{value:"url",text:"url"},
	        	{value:"html",text:"html"}
	        ]
	    },
	    "linkUrlOrHtml": {
	    	uitype: "Input"
	    },
	    "closeable" : {
	        uitype: "RadioGroup",
	        radio_list:[
			        	{value:"false",text:"false"},
			        	{value:"true",text:"true"}
			        ]
	    },
	    "tab_width" : {
	        uitype: "Input"
	    },
	    "on_switch" : {
	        uitype: "ClickInput",
	        editable: false,
	        on_iconclick: "selectPageAction"
	    }
	};
	
	//url联动选择
	function editbefore(rowData, bindName){
		if(bindName ==="linkUrlOrHtml"){
			if(rowData.linkType==="url"){
				return {
					uitype :"ClickInput",
					editable: false,
					on_iconclick :"selectUrl"
				}
			}
		}
	}
	
	
	function editafter(rowData, bindName){
		if(bindName === "linkType"&&rowData.linkType =="url"){
			rowData.linkUrlOrHtml ="";
		}
		return rowData;
	}
	
	//保存数据
	function saveTabData(){
		//校验数据
		if(!checkTabData()){
			return;
		}
		var tabResultData = "";
		var tabDatas = cui("#tabTable").getData();
		var tab;
		for(i=0;i<tabDatas.length;i++){
			if(i==0){
				tabResultData += "[";
			}
			tab = tabDatas[i];
			//返回的数据特殊处理，url后面不的属性值不用“”;
			if(tab.linkType==="html"){
				tabResultData += '{"title":"'+tab.title+ '","html":"' +tab.linkUrlOrHtml +transUndefined('","closeable":"',tab.closeable) +transUndefined('","tab_width":"',tab.tab_width) +transUndefined('","on_switch":"',tab.on_switch)+'"}';
			}else{
				tabResultData += '{"title":"'+tab.title+ '","url":"' +tab.linkUrlOrHtml +transUndefined('","closeable":"',tab.closeable)+transUndefined('","tab_width":"',tab.tab_width)+transUndefined('","on_switch":"' ,tab.on_switch)+'"}';
			}
			if(i!=tabDatas.length-1){
			 tabResultData += ",";
			}
			if(i==tabDatas.length-1){
				tabResultData += "]";
			}
		}
		try{
			if(tabDatas.length == 0||tabResultData==""){
				 window.opener[callbackMethod](propertyName, "");
			}else{
		        window.opener[callbackMethod](propertyName, tabResultData);
		    }
			 window.close();
		}catch(err){ 
			console.log(err);
		}
	}
	
	function transUndefinedUrl(str,obj){
		if(typeof(obj)=="undefined"||obj==""||obj==null){
			return "";
		}
		if(str.indexOf("url")==-1){
			return str + obj +'"';	
		}
		return str + obj;
	}
	
	//组装属性
	function transUndefined(str,obj){
		if(typeof(obj)=="undefined"||obj==""||obj==null){
			return "";
		}
		return str + obj;
	}
	
	//校验数据,title必须输入和tab_width为数字
	function checkTabData(){
		var tabDatas = cui("#tabTable").getData();
		if(tabDatas.length>0){
			 var str = "";
			 var strRow = "";
			 var rowNum ;
			 
			//验证，tab_width只能为整数
			 for(var i =0;i<tabDatas.length;i++){
				 strRow = "";
				 rowNum = i + 1;
				 if(tabDatas[i].tab_width != ""&&typeof(tabDatas[i].tab_width)!="undefined"){
						 var re=/^[1-9]*[1-9][0-9]*$/;
						 if(!tabDatas[i].tab_width.match(re)){
						 strRow = "第" +rowNum +"行，tab_width必须为整数。<br>" 
						 }
					 }
					 if(strRow!=""){
						 str += strRow;
						 }
			 }
			 if(str!=""){
				   cui.alert(str,null,{
					   title:'提示',
					   width: 250
				    });
				   return false;
				 }
		}
		return true;
	}
	
	//选中的链接地址单元格对象
	var selfUrl;
	//选择url界面
	function selectUrl(event, self){
		var url = 'SelectUrl.jsp?reqFunctionSubitemId=' + reqFunctionSubitemId + '&propertyName=' + self.options.name + '&callbackMethod=selectUrlCallback&value=' + self.$input[0].value;
		var top=(window.screen.availHeight-600)/2;
		var left=(window.screen.availWidth-800)/2;
		window.open (url,'openDataStoreSelect','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
		selfUrl =self;
	}
	
	//行为选择
	var selfPageAction;
    function selectPageAction(event,self){
	   var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageActionSelect.jsp?modelId='+pageId+'&packageId='+packageId+'&type=req';
	   var width=800; //窗口宽度
	   var height=550;//窗口高度
	   var top=(window.screen.height-30-height)/2;
	   var left=(window.screen.width-10-width)/2;
	   window.open(url, "pageActionEdit", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
	   selfPageAction = self;
	}
   
    //选中的回调函数数据回调
	function selectPageActionData(objAction,flag){
		//获取方法名称
		var actionEname = objAction.ename;
		selfPageAction.$input[0].value = actionEname;
	}
	
	//清空选中的回调函数数据回调
	function cleanSelectPageActionData(flag){
		selfPageAction.$input[0].value = "";
	}
	
	//取消，关闭窗口
	function cancel(){
		window.close();
	}
	
	//删除选择行
	function deleteSelectedRow() {
	    cui("#tabTable").deleteSelectRow();
	}
	
	 // 插入一行数据
	function insertRow(a, b, mark) {
		cui("#tabTable").insertRow({linkType: "html"}, mark ? mark - 0 : undefined);
	}
	
	function getBodyWidth() {
	    return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	function getBodyHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 60;
	}
	/**
	 * 选择界面回调函数
	 * @param propertyName 属性名称
	 * @param propertyValue 属性值
	 */
	function selectUrlCallback(propertyName, data){
		var url = '';
		if(data && data.url != ''){
			url = cap.getRelativeURL(data.url, modelPackage);
		}
		selfUrl.$input[0].value = url;		
	}
    </script>
</head>
<body style="background-color:#f5f5f5;">
	<div class="cap-page">
	    <div style="text-align: right; padding-bottom: 6px;">
	        <span uitype="button" on_click="insertRow" label="新增"></span>
	        <span uitype="button" on_click="deleteSelectedRow" label="删除"></span>
	        <span uitype="button" on_click="saveTabData" label="确定"></span>
	        <span uitype="button" on_click="cancel" label="关闭"></span>
	    </div>
   	 	<div style="padding:5px 0 0 0">
		    <table id="tabTable" uitype="EditableGrid" datasource="initData" edittype="edittype" editafter="editafter" editbefore="editbefore" resizeheight="getBodyHeight" resizewidth="getBodyWidth" primarykey="userId" pagination="false">
		       <thead>
		         <tr>
		            <th style="width:30px"></th>
		            <th style="width:5%" renderStyle="text-align: center" bindName="1">序号</th>
		            <th style="width:15%" renderStyle="text-align: center" bindName="title">title</th>
		            <th style="width:15%" renderStyle="text-align: center" bindName="linkType">链接类型</th>
		            <th style="width:20%" renderStyle="text-align: center" bindName="linkUrlOrHtml">链接地址</th>
		            <th style="width:15%" renderStyle="text-align: center" bindName="closeable">closeable</th>
		            <th style="width:15%" renderStyle="text-align: center" bindName="tab_width">tab_width</th>
		            <th style="width:20%" renderStyle="text-align: center" bindName="on_switch">on_switch</th>
		        </tr>
		      </thead>
		    </table>
     	</div>
	</div>
</body>
</html>