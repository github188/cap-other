<%
/**********************************************************************
* 用户操作登录情况导出页面 
* 2012-10-31 汪超   新建
**********************************************************************/
%>

<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"></meta>
	<title>日志管理</title>
	<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
		<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/usermanagement/orgusertag/css/choose.css" type="text/css">
	<style>
		html, body{
			overflow:hidden;
			margin: 0;
			height: 100%;
		}
		.center{
			margin-left: 300px;
			margin-top: 30px;
		}
		
	</style>
</head>
<body class="body_layout" > 
<div class="center">
	<span >选择组织：</span>
	<span>
		<top:chooseOrg id="orgId" width="310px" orgStructureId="A" height="28px" chooseMode="20"  ></top:chooseOrg>
	</span>
</div>

<div class="center">
	<span >选择时间范围：</span>
	<span>
		<span uitype="Calender" id="startTimeId"  maxdate="#finishTimeId" on_change="startTimeChange"></span>
		至
		<span uitype="Calender" id="finishTimeId" maxdate="+0d" mindate="#startTimeId" on_change="finishTimeChange"></span>
	</span>
</div>

<div class="center">
	<span uitype="button" label="导出汇总数据" on_click="exportTotal"></span>
	<span uitype="button" label="导出详情(新增)" mark="1" on_click="exportDetail"></span>
	<span uitype="button" label="导出详情(累计)" mark="2" on_click="exportDetail"></span>
</div>	

<div class="center">
	<font color="red">说明：</font>
	<dl>
		<dt>导出汇总数据</dt>
		<dd><font color="red">必须选择时间范围，可选择部门，不选择部门时默认导出各地市局(组织类型属性值为地市局)登录情况汇总数据。</font></dd>
		<dt>导出详情（新增）</dt>
		<dd><font color="red">必须选择时间范围，可选择部门，不选择部门时默认导出各地市局(组织类型属性值为地市局)用户登录情况数据。</font></dd>
		<dt>导出详情（累计）</dt>
		<dd><font color="red">不需要选择时间范围，可选择部门，不选择部门时默认导出各地市局(组织类型属性值为地市局)用户登录情况数据。</font></dd>
	</dl>
	<p>注意：为避免导出操作数据量过大影响系统性能，导出操作建议在下班后进行。</p>
</div>

<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/js/comtop.ui.min.js'></script>
<script  type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/usermanagement/orgusertag/js/choose.js'></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/js/commonUtil.js'></script> 
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/js/jquery.js' ></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/engine.js'></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/util.js"></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/ChooseAction.js' ></script> 

<script type="text/javascript">
	
	$(function(){
		comtop.UI.scan();
		initTime();
	});

	//自定义时间初始化
	function initTime(){
		var nowDate = new Date();
		var aWeekAgo  = new Date(nowDate);
		aWeekAgo.setDate(aWeekAgo.getDate()-7);
		cui('#finishTimeId').setValue(nowDate);
	    cui('#startTimeId').setValue(aWeekAgo);
	}
	
	function getSelectOrg(){
		var orgs = cui("#orgId").getValue();
		var orgIds = "";
		if(orgs&&orgs.length){
			var orgId = [];
			for(var i=0;i<orgs.length;i++){
				orgId.push(orgs[i].id);
			}
			orgIds = orgId.join(";");
		}
		return orgIds;		
	}
	
	function exportTotal(){
		var startTime = cui('#startTimeId').getValue("string");
	    var endTime = cui('#finishTimeId').getValue("string");
	    if(!startTime||!endTime){
	    	cui.alert("起始时间不能为空。","error");
	    	return;
	    }
	    
	    var orgIds=getSelectOrg();
		var url = "${pageScope.cuiWebRoot}/top/sys/log/loginLogTotalExport.ac?startTime="+startTime+"&endTime="+endTime+"&orgIds="+orgIds;
		window.open(url,"_self");
	}
	
	function exportDetail(event,self,mark){
		var startTime ="",endTime="";
		if(mark=="1"){
			startTime = cui('#startTimeId').getValue("string");
	    	endTime = cui('#finishTimeId').getValue("string");
	    	 if(!startTime||!endTime){
	 	    	cui.alert("起始时间不能为空。","error");
	 	    	return;
	 	    }
		}
		var orgIds=getSelectOrg();
		var url = "${pageScope.cuiWebRoot}/top/sys/log/loginLogExport.ac?startTime="+startTime+"&endTime="+endTime+"&orgIds="+orgIds;
		window.open(url,"_self");
	}
	
	function startTimeChange(){
		var startTime = cui('#startTimeId').getValue('date');
		var finishTime = cui('#finishTimeId').getValue('date');
		var now = new Date();
		if(startTime){
			var date = new Date(startTime);
			if(startTime.getMonth()+3 > 12){
				date.setMonth((startTime.getMonth()+3)%12);
				date.setFullYear(startTime.getFullYear()+1);
				if(date > now){
					cui('#finishTimeId').setMinDate(startTime);
					cui('#finishTimeId').setMaxDate(now);
				}
				else{
					cui('#finishTimeId').setMinDate(startTime);
					cui('#finishTimeId').setMaxDate(date);
				}				
			}
			else{
				date.setMonth((startTime.getMonth()+3));
				if(date > now){
					cui('#finishTimeId').setMinDate(startTime);
					cui('#finishTimeId').setMaxDate(now);
				}
				else{
					cui('#finishTimeId').setMinDate(startTime);
					cui('#finishTimeId').setMaxDate(date);
				}
			}
			if(parseInt(Math.abs(finishTime  -  startTime)  /  1000  /  60  /  60  /24) > 90){
				var date = new Date(startTime);
				if(startTime.getMonth()+3 > 12){
					date.setMonth((startTime.getMonth()+3)%12);
					date.setFullYear(startTime.getFullYear()+1);
					if(date > now){
						cui('#finishTimeId').setValue(now);
					}
					else{
						cui('#finishTimeId').setValue(date);
					}				
				}
				else{
					date.setMonth((startTime.getMonth()+3));
					if(date > now){
						cui('#finishTimeId').setValue(now);
					}
					else{
						cui('#finishTimeId').setValue(date);
					}
				}
			}
		}
	}
	
	function finishTimeChange(){
		var finishTime = cui('#finishTimeId').getValue('date');
		if(finishTime){
			var date = new Date(finishTime);
			if(finishTime.getMonth()-3 < 0){
				date.setMonth(finishTime.getMonth()+9);
				date.setFullYear(finishTime.getFullYear()-1);	
				cui('#startTimeId').setMaxDate(finishTime);
			}
			else{
				date.setMonth((finishTime.getMonth()-3));
				cui('#startTimeId').setMaxDate(finishTime);
			}
		}
		else{
			var now = new Date();
			cui('#startTimeId').setMaxDate(now);
		}
	}
</script>
</body>
</html>