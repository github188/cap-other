<%
/**********************************************************************
* ��־ƽ̨:����ʹ����������ţ�
* 2012-10-31 ����   �½�
**********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<html>
<head>
<title>IT���ָ���ѯ</title>
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
			<dd><span>��ѡ��IT���ָ�꣺</span>
				<span uitype="PullDown" mode="Single" id="pleaseChooseDimensionality" value_field="id" datasource="pleaseChooseDimensionalityData" label_field="label" 
				 width="150" on_select_data="selectDimensionality" name="pleaseChooseDimensionality" editable="false" value='1'></span>
			</dd>
			<!-- 
			<dd>
			    <top:chooseOrg id="orgSelect" width="300px" height="30px" chooseMode="1"  ></top:chooseOrg>
				<input type="hidden" id="menuId" value="" />
				<span uitype="ClickInput" id="menuName" width="120px" emptytext="��ѡ��˵�" iconwidth="18px" icon="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/images/openPage.gif" on_iconclick="selectMenu"></span>
				
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
		<span uitype="button" label="��&nbsp;ѯ" on_click="statistics"></span>
	</div>
</div>
<div id="operateStatisticsDIV"></div>	
<div id="loginUserListTodayDIV" style="display: none; width:960px;margin:0 auto;">

 	<table  uitype="grid" id="loginUserListTodayGrid" primarykey="strGridId" datasource="initData" selectrows="no"
		adaptive="true" gridwidth="960" height="auto" colrender="columnRenderer" >
		<tr>
			<th style="width:200px" bindName="userName">�û���</th>
			<th style="width:200px" bindName="userAccount">�ʺ�</th>
			<th style="width:200px" bindName="orgName">��������</th>
			<th style="width:250px" format="yyyy-MM-dd hh:mm:ss" bindName="operateTime">��¼ʱ��</th>
			<th style="width:250px" bindName="remoteAddr">IP</th>
			<th style="width:150px" bindName="envBrowser">�����</th>
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
		{id:'1',label:'����'},
		{id:'2',label:'����'}
	],
		pleaseChooseDimensionalityData = [
		{id:'01',label:'ע���û���'},
		{id:'02',label:'�����û���'},
		{id:'03',label:'�Ự������'},
		{id:'04',label:'�ۼƷ����˴�'},
		{id:'05',label:'�ۼƵ�¼�û�����'},
		{id:'06',label:'�յ�¼�û���'},
		{id:'07',label:'�յ�¼�˴�'},
		{id:'08',label:'�յ�¼��Ա����'},
		{id:'09',label:'ϵͳ��¼��Ӧʱ��'},
		{id:'10',label:'ϵͳ��������ʱ��'},
		{id:'11',label:'ҵ������ռ�ÿռ��С'},
		{id:'12',label:'δ������������'},
		{id:'13',label:'��������'},
		{id:'14',label:'���쳬ʱ��'}
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

	//�Զ���ʱ���ʼ��
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
	
	//��Ⱦ�б�����
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
	//��ѯģ������������Դ
/* 	function queryModuleList(obj){
		FunctionUseAction.queryModuleList(function(data){
			obj.setDatasource(data);
		});
	} */
	
	//��ѯ���о�����������Դ
/* 	function queryBureauList(obj){
		FunctionUseAction.queryBureauList(function(data){
			obj.setDatasource(data);
		});
	}
 */
	//ѡ��ά��
	function selectDimensionality(data){
		dimensionality = data.id
	}
	var _startDate,_endDate, _orgId,_menuId;
	//ͳ��
	function statistics(){
		/*if(menuId!='8a8a9f29387935080138794b2bd5000a'){
			$("#operateDiv").show();
		}else{
			$("#operateDiv").hide();
		}*/
		//�ж�ʱ�䷶Χ�Ƿ�Ϊ��
		var startDate = cui('#statisticsTimeMin').getValue();
		_startDate=startDate;
		var endDate = cui('#statisticsTimeMax').getValue();
		_endDate=endDate;
		var msg = '';
		var	monitorIndexCode = cui("#pleaseChooseDimensionality").getValue();
		if(!monitorIndexCode){
			msg = '����ѡ��IT���ָ�ꡣ';
		}
		if(!startDate || !endDate){
			msg = '����ѡ��ʱ�䷶Χ��';
		}
        /* 		
		var orgValue = cui("#orgSelect").getValue(); 
		if(!orgValue || !orgValue[0] || !orgValue[0]['id']){
			msg = msg + '����ѡ���š�';
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
			cui.alert('����ѡ��˵���');
			return;
		}
		_menuId=menuId; */
		//����ѡ���ά����ʾ��ͬ��ͼ��
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

	//ƴװģ���ӽǵ�xml����
	function packageXML(resultList,showType,dimensionality){
		var caption;
		var labelstep;
		if(resultList){
			labelstep = Math.ceil(resultList.length/20);
		}
	    if (dimensionality === "01") {
			caption = "ϵͳע���û�ͳ��(��)";
		} else if (dimensionality === "02") {
			caption = "�����û���ͳ��(��)";
		} else if (dimensionality === "03") {
			caption = "�Ự������ͳ��(��)";
		} else if (dimensionality === "04") {
			caption = "�ۼƷ����˴�ͳ��(�˴�)";
		} else if (dimensionality === "05") {
			caption = "�ۼƵ�¼�û�����ͳ��(��)";
		} else if (dimensionality === "06") {
			caption = "�յ�¼�û���ͳ��(��)";
		} else if (dimensionality === "07") {
			caption = "�յ�¼�˴�ͳ��(�˴�)";
		} else if (dimensionality === "09") {
			caption = "ϵͳ��¼��Ӧʱ��ͳ��(����)";
		} else if (dimensionality === "10") {
			caption = "ϵͳ��������ʱ��ͳ��(MTBF)(����)";
		} else if (dimensionality === "11") {
			caption = "ҵ������ռ�ÿռ��Сͳ��(MB)";
		} else if (dimensionality === "12") {
			caption = "δ������������ͳ��(��)";
		} else if (dimensionality === "13") {
			caption = "��������ͳ��(��)";
		} else if (dimensionality === "14") {
			caption = "���쳬ʱ��ͳ��(��)";
		}
		/**�������״ͼ���Բ鿴����ģ���ʹ�������*/
		//var _xml = '<chart labelDisplay="ROTATE" slantLabels="1" yAxisMaxValue = "10" yAxisMinValue = "0" unescapeLinks="0" caption="'+caption+'" xAxisName="ͳ��ʱ��" yAxisName="ͳ����ֵ"  showValues="0" showLabels="0" decimals="0" baseFontSize ="12" formatNumberScale="0"  >'
		
		//var _xml = '<chart labelDisplay="ROTATE" slantLabels="1" yAxisMaxValue = "10" yAxisMinValue = "0" unescapeLinks="0" caption="'+caption+'" xAxisName="ͳ��ʱ��" yAxisName="ͳ����ֵ" showLabels="0" decimals="0" bgcolor="FFFFFF"  baseFontSize ="12" formatNumberScale="0" showalternatehgridcolor="0" plotbordercolor="008ee4" plotborderthickness="3" showvalues="0" divlinecolor="CCCCCC" showcanvasborder="0"  tooltipcolor="FFFFFF" tooltipbordercolor="00396d" anchorbgcolor="008ee4" anchorborderthickness="0" showshadow="1" chartrightmargin="25" canvasborderalpha="0" showborder="1">';
		
		
		var _xml = '<chart labelDisplay="ROTATE" slantLabels="1" yAxisMaxValue = "10" yAxisMinValue = "0" xAxisMaxValue="10" xAxisMinValue = "0" unescapeLinks="0" caption="'+caption+'" xAxisName="ͳ��ʱ��" yAxisName="ͳ����ֵ" showValues="0" showLabels="1" decimals="0" bgcolor="FFFFFF"  baseFontSize ="12" formatNumberScale="0"  linethickness="1" anchorradius="2" anchorBgAlpha="100" divlinecolor="666666" divlinealpha="30" divlineisdashed="1" labelstep="'+labelstep+'" bgcolor="FFFFFF" showalternatehgridcolor="0" labelpadding="10" canvasborderthickness="1" legendiconscale="1.5" legendshadow="0" legendborderalpha="0" legendposition="right" canvasborderalpha="50" numvdivlines="5" vdivlinealpha="20" showborder="0">';
		
		//var _xml ='<chart caption="'+caption+'" subcaption="(from 8/6/2013 to 8/12/2013)" linethickness="1" showvalues="0" formatnumberscale="0" anchorradius="2" divlinecolor="666666" divlinealpha="30" divlineisdashed="1" labelstep="10" bgcolor="FFFFFF" showalternatehgridcolor="0" labelpadding="10" canvasborderthickness="1" legendiconscale="1.5" legendshadow="0" legendborderalpha="0" legendposition="right" canvasborderalpha="50" numvdivlines="5" vdivlinealpha="5" showborder="0">';
		
		if (!resultList) {
			_xml = _xml + '<set label="������" value="0" /> ';
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
		//ͼ�������ʾ����������ʾ
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

	//�����״ͼ����һ���µ�ͼ��
	/* 	function showSubModuleDetail(id){
	 var tempId = id;
	 var obj={moduleId:tempId};
	 FunctionUseAction.hasSubMenu(obj,function(data){
	 if(data.result==1){
	 menuId = id;
	 statistics();
	 }else{
	 cui.alert("��ģ���Ѿ�����ײ㣬û���Ӳ˵���");
	 }
	 });
	 } */

	//��ѡ��˵�ҳ��
	function selectMenu() {
		var iWidth = 250;
		var iHeight = 350;
		var url = "<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/log/SelectApp.jsp";
		var title = "ѡ��˵�";
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

	//ѡ��˵�ҳ��Ļص�����
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

	//���ÿ�߶�
	function resetFlashWidth() {
		showColumnFlash();
	}

	//ͳ������Ϊ�˵�ʱ���ĳ�˵�ͳ����������¼�
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
	//ͳ������Ϊ��֯ʱ���ĳ�˵�ͳ����������¼�
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
	//ͳ������Ϊ��֯ʱ���ĳ�˵�ͳ�����չʾ�˵����������
	function on_packageXMLByOrg(resultList, showType, name) {
		var _xml = '<chart  yAxisMaxValue = "5" yAxisMinValue = "0" caption="��֯('
				+ name
				+ ')���ʲ˵����ͳ��(��)" xAxisName="�˵�����" yAxisName="�������"  showValues="1" decimals="0" baseFontSize ="12" formatNumberScale="0"  >'
		if (resultList.length == 0) {
			_xml = _xml + '<set label="������" value="0" /> ';
		} else {
			for (var i = 0; i < resultList.length; i++) {
				_xml = _xml
						+ '<set label="'+resultList[i].menuName+'" value="'+resultList[i].clickCount+'" /> ';
			}
		}
		_xml = _xml + '</chart>';
		var chart;
		//ͼ�������ʾ����������ʾ
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
	//ͳ������Ϊ�˵�ʱ���ĳ�˵�ͳ�����չʾ����֯�Ըò˵��������
	function on_packageXMLByMenu(resultList, showType, name) {
		var _xml = '<chart caption="����֯���ʲ˵�('
				+ name
				+ ')���ͳ��(��)" xAxisName="��֯����" yAxisName="�������" yAxisMaxValue = "5" yAxisMinValue = "0" showValues="1" decimals="0" baseFontSize ="12" formatNumberScale="0" >'
		if (resultList.length == 0) {
			_xml = _xml + '<set label="������" value="0" /> ';
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

	//��ʾ��ѯ�Ķ���functionchair
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
