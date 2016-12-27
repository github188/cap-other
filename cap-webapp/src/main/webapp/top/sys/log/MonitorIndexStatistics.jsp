<%
/**********************************************************************
* 日志平台:功能使用情况（部门）
* 2012-10-31 汪超   新建
**********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<html>
<head>
<title>IT监控指标查询</title>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"></meta>
	<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/usermanagement/orgusertag/css/choose.css" type="text/css">
	<style>
		dl,dt,dd{
			display:inline;
		}
		dd{
			margin-left:3px;
		}
	</style>
</head>
<body>
<div class="list_header_wrap">
	<div class="top_float_left">
		<dl>
			<dd><span>请选择IT监控指标：</span>
				<span uitype="PullDown" mode="Single" id="pleaseChooseDimensionality" value_field="id" datasource="pleaseChooseDimensionalityData" label_field="label" 
				 width="150" on_select_data="selectDimensionality" name="pleaseChooseDimensionality" editable="false" value='1'></span>
			</dd>
			<!-- 
			<dd>
			    <top:chooseOrg id="orgSelect" width="300px" height="30px" chooseMode="1"  ></top:chooseOrg>
				<input type="hidden" id="menuId" value="" />
				<span uitype="ClickInput" id="menuName" width="120px" emptytext="请选择菜单" iconwidth="18px" icon="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/images/openPage.gif" on_iconclick="selectMenu"></span>
				
			</dd>
			 -->
		</dl>
		<dl id="timeSpan">
			<dd><span uitype="Calender" id="statisticsTimeMin" width="120px" maxdate="#statisticsTimeMax"></span></dd>
			<dt>-</dt>
			<dd><span uitype="Calender" id="statisticsTimeMax" maxdate="+0d" width="120px" mindate="#statisticsTimeMin"></span></dd>
		</dl>
	</div>
	<div class="top_float_right">
		<span uitype="button" label="查&nbsp;询" on_click="statistics"></span>
	</div>
</div>
<div id="operateStatisticsDIV"></div>	
<div id="loginUserListTodayDIV" style="display: none; width:960px;margin:0 auto;">

 	<table  uitype="grid" id="loginUserListTodayGrid" primarykey="strGridId" datasource="initData" selectrows="no"
		adaptive="true" gridwidth="960" height="auto" colrender="columnRenderer" >
		<tr>
			<th style="width:200px" bindName="userName">用户名</th>
			<th style="width:200px" bindName="userAccount">帐号</th>
			<th style="width:200px" bindName="orgName">部门名称</th>
			<th style="width:250px" format="yyyy-MM-dd hh:mm:ss" bindName="operateTime">登录时间</th>
			<th style="width:250px" bindName="remoteAddr">IP</th>
			<th style="width:150px" bindName="envBrowser">浏览器</th>
		</tr>
	</table>
</div>


<div id="showDialogDiv">
</div>

<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"  src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/js/commonUtil.js"></script>  
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/usermanagement/orgusertag/js/choose.js" cuiTemplate="choose.html"></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/usermanagement/orgusertag/js/userOrgUtil.js"></script>

<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/engine.js'></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/util.js"></script>

<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/ChooseAction.js'></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/MonitorIndexAction.js'></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/log/js/FusionCharts.js'></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/log/js/help.js'></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/js/jquery.js" ></script>


<script language="javascript">
    var queryCondition={};
	var showTypeData = [
		{id:'1',label:'横向'},
		{id:'2',label:'纵向'}
	],
		pleaseChooseDimensionalityData = [
		{id:'01',label:'注册用户数'},
		{id:'02',label:'在线用户数'},
		{id:'03',label:'会话连接数'},
		{id:'04',label:'累计访问人次'},
		{id:'05',label:'累计登录用户人数'},
		{id:'06',label:'日登录用户数'},
		{id:'07',label:'日登录人次'},
		{id:'08',label:'日登录人员名单'},
		{id:'09',label:'系统登录响应时长'},
		{id:'10',label:'系统健康运行时长'},
		{id:'11',label:'业务数据占用空间大小'},
		{id:'12',label:'未结束流程数量'},
		{id:'13',label:'待办数量'},
		{id:'14',label:'待办超时量'}
	],
		showType = '1',
		menuId;
	
	$(function(){
		comtop.UI.scan();
		dwr.TOPEngine.setAsync(false);
/* 		FunctionUseAction.getRootMenuId(function(data){
			menuId = data;
		}); */
		dwr.TOPEngine.setAsync(true);
		initTime();
	});

	//自定义时间初始化
	function initTime(){
		var nowDate = new Date();
		var month = nowDate.getMonth() + 1;
		var day = nowDate.getDate();
		if (month<10){
		     month = "0"+month;
		}
		if(day<10){
			day = "0"+day;
		}
		var nowYear = '' + nowDate.getFullYear();
		var nowMonth = nowYear + "-" + month;
	    var firstDay = nowMonth + "-01";
	    var today = nowMonth + "-" + day;
	    cui('#statisticsTimeMin').setValue(firstDay);
	    cui('#statisticsTimeMax').setValue(today);
	}	
	
	//渲染列表数据
	function initData(grid, query){
		if(queryCondition.statStartTime&&queryCondition.statEndTime){
			queryCondition.pageNo = query.pageNo;
			queryCondition.pageSize = query.pageSize;
			MonitorIndexAction.getLoginUserListToday(queryCondition, function(data){
		        var totalSize = data.count;
		        var dataList = data.list;        
		        grid.setDatasource(dataList, totalSize);
		    });
		}else{
			grid.setDatasource([],0);
		}

	}
	//查询模块下拉框数据源
/* 	function queryModuleList(obj){
		FunctionUseAction.queryModuleList(function(data){
			obj.setDatasource(data);
		});
	} */
	
	//查询地市局下拉框数据源
/* 	function queryBureauList(obj){
		FunctionUseAction.queryBureauList(function(data){
			obj.setDatasource(data);
		});
	}
 */
	//选择维度
	function selectDimensionality(data){
		dimensionality = data.id
	}
	var _startDate,_endDate, _orgId,_menuId;
	//统计
	function statistics(){
		/*if(menuId!='8a8a9f29387935080138794b2bd5000a'){
			$("#operateDiv").show();
		}else{
			$("#operateDiv").hide();
		}*/
		//判断时间范围是否为空
		var startDate = cui('#statisticsTimeMin').getValue();
		_startDate=startDate;
		var endDate = cui('#statisticsTimeMax').getValue();
		_endDate=endDate;
		var msg = '';
		var	monitorIndexCode = cui("#pleaseChooseDimensionality").getValue();
		if(!monitorIndexCode){
			msg = '请先选择IT监控指标。';
		}
		if(!startDate || !endDate){
			msg = '请先选择时间范围。';
		}
        /* 		
		var orgValue = cui("#orgSelect").getValue(); 
		if(!orgValue || !orgValue[0] || !orgValue[0]['id']){
			msg = msg + '请先选择部门。';
		} */
		if(msg){
			cui.alert(msg);
			return;
		}
/* 		var orgId = orgValue[0]['id'];
		_orgId=orgId; */
		
			showType = '1';//cui("#showType").getValue(),
		//	menuId = $('#menuId').val();
/* 		if(!menuId){
			cui.alert('请先选择菜单。');
			return;
		}
		_menuId=menuId; */
		//根据选择的维度显示不同的图表
		if(dimensionality === '08'){
			$("#operateStatisticsDIV").css("display","none");
			$("#loginUserListTodayDIV").css("display","");
			queryCondition = {};
			queryCondition.statStartTime = startDate+" 00:00:00";
			queryCondition.statEndTime = endDate+" 23:59:59";
			queryCondition.fastQuery = 'no';
			cui("#loginUserListTodayGrid").setQuery(queryCondition);
			cui("#loginUserListTodayGrid").loadData();
		}else{
			$("#operateStatisticsDIV").css("display","");
			$("#loginUserListTodayDIV").css("display","none");
			var obj={statStartTime:startDate+" 00:00:00",statEndTime:endDate+" 23:59:59",code:monitorIndexCode};
			MonitorIndexAction.getMonitorIndexInfo(obj,function(data){
				packageXML(data,showType,dimensionality);
			});
		}
	}

	//拼装模块视角的xml数据
	function packageXML(resultList,showType,dimensionality){
		var caption;
		var labelstep;
		if(resultList){
			labelstep = Math.ceil(resultList.length/20);
		}
	    if (dimensionality === "01") {
			caption = "系统注册用户统计(人)";
		} else if (dimensionality === "02") {
			caption = "在线用户数统计(人)";
		} else if (dimensionality === "03") {
			caption = "会话连接数统计(个)";
		} else if (dimensionality === "04") {
			caption = "累计访问人次统计(人次)";
		} else if (dimensionality === "05") {
			caption = "累计登录用户人数统计(人)";
		} else if (dimensionality === "06") {
			caption = "日登录用户数统计(人)";
		} else if (dimensionality === "07") {
			caption = "日登录人次统计(人次)";
		} else if (dimensionality === "09") {
			caption = "系统登录响应时长统计(毫秒)";
		} else if (dimensionality === "10") {
			caption = "系统健康运行时长统计(MTBF)(分钟)";
		} else if (dimensionality === "11") {
			caption = "业务数据占用空间大小统计(MB)";
		} else if (dimensionality === "12") {
			caption = "未结束流程数量统计(个)";
		} else if (dimensionality === "13") {
			caption = "待办数量统计(个)";
		} else if (dimensionality === "14") {
			caption = "待办超时量统计(个)";
		}
		/**（点击柱状图可以查看其子模块的使用情况）*/
		//var _xml = '<chart labelDisplay="ROTATE" slantLabels="1" yAxisMaxValue = "10" yAxisMinValue = "0" unescapeLinks="0" caption="'+caption+'" xAxisName="统计时间" yAxisName="统计数值"  showValues="0" showLabels="0" decimals="0" baseFontSize ="12" formatNumberScale="0"  >'
		
		//var _xml = '<chart labelDisplay="ROTATE" slantLabels="1" yAxisMaxValue = "10" yAxisMinValue = "0" unescapeLinks="0" caption="'+caption+'" xAxisName="统计时间" yAxisName="统计数值" showLabels="0" decimals="0" bgcolor="FFFFFF"  baseFontSize ="12" formatNumberScale="0" showalternatehgridcolor="0" plotbordercolor="008ee4" plotborderthickness="3" showvalues="0" divlinecolor="CCCCCC" showcanvasborder="0"  tooltipcolor="FFFFFF" tooltipbordercolor="00396d" anchorbgcolor="008ee4" anchorborderthickness="0" showshadow="1" chartrightmargin="25" canvasborderalpha="0" showborder="1">';
		
		
		var _xml = '<chart labelDisplay="ROTATE" slantLabels="1" yAxisMaxValue = "10" yAxisMinValue = "0" xAxisMaxValue="10" xAxisMinValue = "0" unescapeLinks="0" caption="'+caption+'" xAxisName="统计时间" yAxisName="统计数值" showValues="0" showLabels="1" decimals="0" bgcolor="FFFFFF"  baseFontSize ="12" formatNumberScale="0"  linethickness="1" anchorradius="2" anchorBgAlpha="100" divlinecolor="666666" divlinealpha="30" divlineisdashed="1" labelstep="'+labelstep+'" bgcolor="FFFFFF" showalternatehgridcolor="0" labelpadding="10" canvasborderthickness="1" legendiconscale="1.5" legendshadow="0" legendborderalpha="0" legendposition="right" canvasborderalpha="50" numvdivlines="5" vdivlinealpha="20" showborder="0">';
		
		//var _xml ='<chart caption="'+caption+'" subcaption="(from 8/6/2013 to 8/12/2013)" linethickness="1" showvalues="0" formatnumberscale="0" anchorradius="2" divlinecolor="666666" divlinealpha="30" divlineisdashed="1" labelstep="10" bgcolor="FFFFFF" showalternatehgridcolor="0" labelpadding="10" canvasborderthickness="1" legendiconscale="1.5" legendshadow="0" legendborderalpha="0" legendposition="right" canvasborderalpha="50" numvdivlines="5" vdivlinealpha="5" showborder="0">';
		
		if (!resultList) {
			_xml = _xml + '<set label="无数据" value="0" /> ';
		} else {
			for (var i = 0; i < resultList.length; i++) {
				_xml = _xml + '<set  color="008ee4"  label="'
						+ formatDate(resultList[i].gatherTime, "yyyy-MM-dd HH:mm")
						+ '" value="' + resultList[i].value
						+ '" link="javascript:on_clickChairMenu(\''
						+ resultList[i].menuId + '\',\''
						+ resultList[i].menuName + '\')" /> ';
			}
		}
		_xml = _xml + '</chart>';
		//alert(_xml);
		var chart;
		//图表横向显示或者竖向显示
		if (showType == '2') {
			chart = new FusionCharts(
					"<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Bar2D.swf",
					"Bar2DId", screen.width * 0.82, screen.height * 0.6, "0",
					"10");
		} else {
			chart = new FusionCharts(
					"<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Line.swf",
					"Column3DId", screen.width * 0.82, screen.height * 0.6,
					"0", "10");
		}
		chart.setDataXML(_xml);
		chart.addParam("wmode", "Opaque");
		chart.render('operateStatisticsDIV');
	}

	//点击柱状图弹出一个新的图表
	/* 	function showSubModuleDetail(id){
	 var tempId = id;
	 var obj={moduleId:tempId};
	 FunctionUseAction.hasSubMenu(obj,function(data){
	 if(data.result==1){
	 menuId = id;
	 statistics();
	 }else{
	 cui.alert("该模块已经是最底层，没有子菜单。");
	 }
	 });
	 } */

	//打开选择菜单页面
	function selectMenu() {
		var iWidth = 250;
		var iHeight = 350;
		var url = "<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/log/SelectApp.jsp";
		var title = "选择菜单";
		dialog = cui.dialog({
			title : title,
			src : url,
			width : iWidth,
			height : iHeight
		})
		//} 
		dialog.show(url);
		/* var iTop = (window.screen.availHeight-30-iHeight)/2;
		var iLeft = (window.screen.availWidth-10-iWidth)/2;
		window.open("<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/log/SelectApp.jsp",
			"chooseMenu","left=" + iLeft + ",top=" + iTop + ",width=" + iWidth + ",height=" + iHeight
			+ ",menu=no,toolbar=no,resizable=no,scrollbars=no"); */
	}

	//选择菜单页面的回调方法
	var dialog;
	function selectMenuCallback(chooseData) {
		if (chooseData.key) {
			cui('#menuName').setValue(chooseData.title);
			$('#menuId').val(chooseData.key);
		} else {
			cui('#menuName').setValue('');
			$('#menuId').val('');
		}
	}

	//重置宽高度
	function resetFlashWidth() {
		showColumnFlash();
	}

	//统计类型为菜单时点击某菜单统计情况触发事件
	/* 	function on_clickChairMenu(objId,name){
	
	 var startDate = _startDate;
	 var endDate = _endDate;
	
	 showType = '1';
	 var orgId = _orgId;
	 var menuId=objId;
	 var obj={statisticsTimeMin:startDate,statisticsTimeMax:endDate,orgId:orgId,menuId:menuId};
	 FunctionUseAction.queryFunctionUseVOOrgListByMenu(obj,function(data){
	 on_packageXMLByMenu(data,showType,name)
	 });
	
	 } */
	//统计类型为组织时点击某菜单统计情况触发事件
	/*     function on_clickChairOrg(objId,name){
	 var startDate = _startDate;
	 var endDate = _endDate;
	 showType = '1';
	 var menuId = _menuId;
	 var orgId=objId;
	 var obj={statisticsTimeMin:startDate,statisticsTimeMax:endDate,orgId:orgId,menuId:menuId};
	 FunctionUseAction.queryFunctionUseVOMenuListByorg(obj,function(data){
	 on_packageXMLByOrg(data,showType,name);
	 });
	
	 } */
	//统计类型为组织时点击某菜单统计情况展示菜单被访问情况
	function on_packageXMLByOrg(resultList, showType, name) {
		var _xml = '<chart  yAxisMaxValue = "5" yAxisMinValue = "0" caption="组织('
				+ name
				+ ')访问菜单情况统计(次)" xAxisName="菜单名称" yAxisName="点击次数"  showValues="1" decimals="0" baseFontSize ="12" formatNumberScale="0"  >'
		if (resultList.length == 0) {
			_xml = _xml + '<set label="无数据" value="0" /> ';
		} else {
			for (var i = 0; i < resultList.length; i++) {
				_xml = _xml
						+ '<set label="'+resultList[i].menuName+'" value="'+resultList[i].clickCount+'" /> ';
			}
		}
		_xml = _xml + '</chart>';
		var chart;
		//图表横向显示或者竖向显示
		if (showType == '2') {
			chart = new FusionCharts(
					"<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Bar2D.swf",
					"Bar2DId", screen.width * 0.72, screen.height * 0.5, "0",
					"10");
		} else {
			chart = new FusionCharts(
					"<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Column3D.swf",
					"Column3DId", screen.width * 0.72, screen.height * 0.5,
					"0", "10");
		}
		chart.setDataXML(_xml);
		chart.addParam("wmode", "Opaque");
		chart.render('showDialogDiv');
		showDialog(showType, resultList.length);
	}
	//统计类型为菜单时点击某菜单统计情况展示各组织对该菜单访问情况
	function on_packageXMLByMenu(resultList, showType, name) {
		var _xml = '<chart caption="各组织访问菜单('
				+ name
				+ ')情况统计(次)" xAxisName="组织名称" yAxisName="点击次数" yAxisMaxValue = "5" yAxisMinValue = "0" showValues="1" decimals="0" baseFontSize ="12" formatNumberScale="0" >'
		if (resultList.length == 0) {
			_xml = _xml + '<set label="无数据" value="0" /> ';
		} else {
			for (var i = 0, j = resultList.length; i < j; i++) {
				_xml = _xml
						+ '<set label="'+resultList[i].orgName+'" value="'+resultList[i].clickCount+'"/> ';
			}
		}
		_xml = _xml + '</chart>';
		var chart;
		if (showType == '2') {
			if (resultList.length < 10) {
				chart = new FusionCharts(
						"<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Bar2D.swf",
						"Bar2DId", screen.width * 0.72, screen.height * 0.5,
						"0", "10");
			} else {
				chart = new FusionCharts(
						"<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Bar2D.swf",
						"Bar2DId", screen.width * 0.72, screen.height * 0.02
								* resultList.length, "0", "10");
			}
		} else {
			chart = new FusionCharts(
					"<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Column3D.swf",
					"Column3DId", screen.width * 0.72, screen.height * 0.5,
					"0", "10");
		}
		chart.setDataXML(_xml);
		chart.addParam("wmode", "Opaque");
		chart.render('showDialogDiv');
		showDialog(showType, resultList.length);
	}

	//显示查询的二级functionchair
	function showDialog(showType, len) {
		var fWidth;
		var fHeight;
		if (showType == '2') {
			if (len < 10) {
				fWidth = screen.width * 0.72;
				fHeight = screen.height * 0.5;
			} else {
				fWidthscreen.width * 0.72;
				fHeight = screen.height * 0.02 * len;
			}
		} else {
			fWidth = screen.width * 0.72 + 10;
			fHeight = screen.height * 0.5;
		}
		cui('#showDialogDiv').dialog({
			width : fWidth,
			height : fHeight
		}).show();
	}

	function formatDate(date, format) {
		if (!date)
			return;
		if (!format)
			format = "yyyy-MM-dd";
		switch (typeof date) {
		case "string":
			date = new Date(date.replace(/-/, "/"));
			break;
		case "number":
			date = new Date(date);
			break;
		}
		if (!date instanceof Date)
			return;
		var dict = {
			"yyyy" : date.getFullYear(),
			"M" : date.getMonth() + 1,
			"d" : date.getDate(),
			"H" : date.getHours(),
			"m" : date.getMinutes(),
			"s" : date.getSeconds(),
			"MM" : ("" + (date.getMonth() + 101)).substr(1),
			"dd" : ("" + (date.getDate() + 100)).substr(1),
			"HH" : ("" + (date.getHours() + 100)).substr(1),
			"mm" : ("" + (date.getMinutes() + 100)).substr(1),
			"ss" : ("" + (date.getSeconds() + 100)).substr(1)
		};
		return format.replace(/(yyyy|MM?|dd?|HH?|ss?|mm?)/g, function() {
			return dict[arguments[0]];
		});
	}
</script>
</body>
</html>
