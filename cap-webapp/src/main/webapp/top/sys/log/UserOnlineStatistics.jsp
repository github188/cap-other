<%
/**********************************************************************
* 用户操作日志统计
* 2012-10-31 汪超   新建
**********************************************************************/
%>

<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"></meta>
	<title>日志管理</title>
	<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
		<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/usermanagement/orgusertag/css/choose.css" type="text/css">
	<style>
		html, body{
			overflow:hidden;
			margin: 0;
			height: 100%;
		}
		dl,dt,dd{
			display:inline;
		}
		dd{
			margin-left:3px;
		}
		
		.hide_element{
			display:none;
		}
		.pullDown_gap{
			_margin-right:6px;
		}
	</style>
</head>
<body class="body_layout" > 
<div class="list_header_wrap" style="height: 25px;overflow:hidden;">
	<div class="top_float_left">
		<dl class="pullDown_gap">
			<top:chooseOrg id="orgId" width="310px" height="28px" chooseMode="1"  ></top:chooseOrg>
		</dl>
		<dl class="pullDown_gap">
			<span uitype="PullDown" mode="Single" id="timeValue" value_field="id" datasource="timeSelectData" label_field="label" empty_text="统计类型"
				width="120" on_select_data="changeTime" name="timeSelect" value="6" editable="false"></span>
		</dl>
		<dl id="yearSpan" class="hide_element">
			<dt>请选择日期</dt>
			<dd><span uitype="Calender" id="startTimeId1" maxdate="-0d" width="125px"></span></dd>
		</dl>
		<dl id="yearSingleSpan" class="hide_element">
			<dt>请选择年份</dt>
			<dd><span uitype="Calender" id="statisticsYear" model="year" width="120px"></span></dd>
		</dl>
		<dl id="monthSpan" class="hide_element">
			<dt>请选择月份</dt>
			<dd><span uitype="Calender" id="statisticsMonth" model="month" width="125px"></span></dd>
		</dl>
		<dl id="seasonsSpan" class="hide_element">
			<dt>请选择季度</dt>
			<dd><span uitype="Calender" id="seasonsSelect" model="quarter" width="150px" format="yyyy-q" value=""></span></dd>
		</dl>
		<dl id="timeSpan">
			<dd><span uitype="Calender" id="startTimeId" width="125px" maxdate="#finishTimeId"></span></dd>
			<dt>至</dt>
			<dd><span uitype="Calender" id="finishTimeId" maxdate="+0d" width="125px" mindate="#startTimeId"></span></dd>
		</dl>
	</div>
	<div class="top_float_right">
		<span uitype="button" label="统&nbsp;计" on_click="statistics"></span>
		&nbsp;
	</div>
</div>
<div id="operateStatisticsDIV" style="_overflow:hidden; text-align: center;"></div>	
	
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/js/comtop.ui.min.js'></script>
<script  type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/usermanagement/orgusertag/js/choose.js' cuiTemplate="choose.html"></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/js/commonUtil.js'></script> 
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/log/js/FusionCharts.js'></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/log/js/help.js'></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/js/jquery.js' ></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/engine.js'></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/util.js"></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/UserOnlineAction.js' ></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/ChooseAction.js' ></script> 

<script type="text/javascript">
     var _xml = '',
         chart = null,
         chartHeight = "100%",//screen.height*0.5;
	     chartWidth = "100%",//screen.width*1;
	     chartType = "",
	     chartShowType = "";
	     
		     
	var timeSelectData = [
		{id:1,label:'按天'},
		{id:2,label:'按星期'},
		{id:3,label:'按月'},
		{id:4,label:'按季度'},
		{id:5,label:'按年'},
		{id:6,label:'自定义时间段'}
	];
	
	$(function(){
		comtop.UI.scan();
		initTime();
	});
	
	
	
    function dateDiff(sDate1, sDate2)//日期相减获得天数
    {
        var aDate, oDate1, oDate2, iDays ;
        aDate = sDate1.split("-") ;
        oDate1 = new Date(aDate[0], aDate[1]-1,aDate[2]); //转换为12-18-2002格式
        aDate = sDate2.split("-") ;
        oDate2 = new Date(aDate[0] ,aDate[1]-1,aDate[2]) ;
        iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 /24) ;//把相差的毫秒数转换为天数
        return iDays ;
    }


  //获取与某时间nowDate相差AddDayCount天的日期
	function GetDateStr(nowDate,AddDayCount){
		var temp = nowDate.split('-');
		var dd = new Date(temp[0],temp[1]-1,temp[2]);
		dd.setDate(dd.getDate()+AddDayCount);//获取AddDayCount天后的日期
		var y = dd.getFullYear();
		var m = dd.getMonth()+1;//获取当前月份的日期
		var d = dd.getDate();
		return y+"-"+m+"-"+d;
	}

	//算出指定时间所属周的开始日期和结束日期。
	function getStatisticsDate(tempDate){
		var temp = tempDate.split('-');
		var nowDate = new Date(temp[0],temp[1]-1,temp[2]);
		var tempDayOfWeek = nowDate.getDay();         //今天本周的第几天
		var tempDay = nowDate.getDate();  //当前日
		var weekStartDate = new Date(temp[0], temp[1]-1, tempDay - tempDayOfWeek);
    	weekStartDate =  comtop.Date.format(weekStartDate,'yyyy-MM-dd');
		return weekStartDate;
	}

	function changeTime(data){
		var timeValue = data.id;
		if(timeValue=='1'){
			document.getElementById('yearSpan').style.display='inline';
			document.getElementById('seasonsSpan').style.display='none';
			document.getElementById('timeSpan').style.display='none';
			document.getElementById('yearSingleSpan').style.display='none';
			document.getElementById('monthSpan').style.display='none';
		}else if(timeValue=='2'){
			document.getElementById('yearSpan').style.display='inline';
			document.getElementById('seasonsSpan').style.display='none';
			document.getElementById('timeSpan').style.display='none';
			document.getElementById('yearSingleSpan').style.display='none';
			document.getElementById('monthSpan').style.display='none';
		}else if(timeValue=='3'){
			document.getElementById('yearSpan').style.display='none';
			document.getElementById('seasonsSpan').style.display='none';
			document.getElementById('timeSpan').style.display='none';
			document.getElementById('yearSingleSpan').style.display='none';
			document.getElementById('monthSpan').style.display='inline';
		}else if(timeValue=='4'){
			document.getElementById('yearSpan').style.display='none';
			document.getElementById('seasonsSpan').style.display='inline';
			document.getElementById('timeSpan').style.display='none';
			document.getElementById('yearSingleSpan').style.display='none';
			document.getElementById('monthSpan').style.display='none';
			//给季度赋初始值
			var nowDate = new Date();
			var nowYear = nowDate.getFullYear();
			var month = nowDate.getMonth() + 1;
			var season = '1';
			if(month>=4 && month<=6){
				season = '2';
			}else if(month>=7 && month<=9){
				season = '3';
			}else if(month>=10 && month<=12){
				season = '4';
			}
			cui('#seasonsSelect').setValue(nowYear + '-' + season);
		}else if(timeValue=='5'){
			document.getElementById('yearSpan').style.display='none';
			document.getElementById('seasonsSpan').style.display='none';
			document.getElementById('timeSpan').style.display='none';
			document.getElementById('yearSingleSpan').style.display='inline';
			document.getElementById('monthSpan').style.display='none';
		}else if (timeValue=='6'){
			document.getElementById('yearSpan').style.display='none';
			document.getElementById('seasonsSpan').style.display='none';
			document.getElementById('timeSpan').style.display='inline';
			document.getElementById('yearSingleSpan').style.display='none';
			document.getElementById('monthSpan').style.display='none';
		}
 	}

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
	    cui('#startTimeId1').setValue(firstDay);
	    cui('#statisticsMonth').setValue(nowMonth);
	    cui('#statisticsYear').setValue(nowYear);
	    cui('#startTimeId').setValue(firstDay);
	    cui('#finishTimeId').setValue(today);
	}	

	//执行统计
	function statistics(){
		var alertMsg = '',
			timeValue = cui('#timeValue').getValue(),
     		orgData = cui('#orgId').getValue(),
     		timeSelect = cui('#timeValue').getValue();

		if((!orgData || !orgData[0] || !orgData[0]['id']) && !timeSelect){
			cui.alert("请选择部门和统计类型");
			return;
		}
 		
		if(!orgData || !orgData[0] || !orgData[0]['id']){
			alertMsg = alertMsg + '请选择部门。';
		}
		if(!timeSelect){
			alertMsg = alertMsg + '请选择统计类型。';
		}
		if(alertMsg !=''){
			cui.alert(alertMsg);
			return;
		}
		var orgId = orgData[0]['id'],
		    orgName = orgData[0]['name'];
		
		var startTime = cui('#startTimeId').getValue();
		var finishTime = cui('#finishTimeId').getValue();
		if(timeValue =='1'){
			startTime = cui('#startTimeId1').getValue();
			if(startTime ==''){
				cui.alert('请先选择统计的日期。');
				return;
			}
			var obj = {orgId:orgId,statisticsType:1,startTime:startTime,finishTime:finishTime};
			UserOnlineAction.userOnlineStatistics(obj,function(data){
				var result = data.list;
				var maxValue=5;
				var numLines=maxValue>=5?maxValue+4:5;
				if(numLines>5){
					numLines=5
				}
				if(maxValue==0){
					maxValue=5;
				}
				if(result.length != 0){
					_xml = '<chart caption="最大在线人数统计" xAxisName="时间区间" yAxisName="在线人数" rotateNames="1" slantLabels="1"  yAxisMaxValue="'+maxValue+'" yAxisMinValue="0" baseFontSize ="12" showValues="1" alternateHGridColor="FCB541" alternateHGridAlpha="20" numberSuffix="(人)" divLineColor="FCB541" divLineAlpha="50" canvasBorderColor="666666" baseFontColor="666666" lineColor="FCB541" >'
					      +'<set label="0:00-1:00" value="'+result[0].count0to1+'"/> '
						  +'<set label="1:00-2:00" value="'+result[0].count1to2+'"/> '
						  +'<set label="2:00-3:00" value="'+result[0].count2to3+'"/> '
						  +'<set label="3:00-4:00" value="'+result[0].count3to4+'"/> '
						  +'<set label="4:00-5:00" value="'+result[0].count4to5+'"/> '
						  +'<set label="5:00-6:00" value="'+result[0].count5to6+'"/> '
						  +'<set label="6:00-7:00" value="'+result[0].count6to7+'"/> '
						  +'<set label="7:00-8:00" value="'+result[0].count7to8+'"/> '
						  +'<set label="8:00-9:00" value="'+result[0].count8to9+'"/> '
						  +'<set label="9:00-10:00" value="'+result[0].count9to10+'"/> '
						  +'<set label="10:00-11:00" value="'+result[0].count10to11+'"/> '
						  +'<set label="11:00-12:00" value="'+result[0].count11to12+'"/> '
						  +'<set label="12:00-13:00" value="'+result[0].count12to13+'"/> '
						  +'<set label="13:00-14:00" value="'+result[0].count13to14+'"/> '
						  +'<set label="14:00-15:00" value="'+result[0].count14to15+'"/> '
						  +'<set label="15:00-16:00" value="'+result[0].count15to16+'"/> '
						  +'<set label="16:00-17:00" value="'+result[0].count16to17+'"/> '
						  +'<set label="17:00-18:00" value="'+result[0].count17to18+'"/> '
						  +'<set label="18:00-19:00" value="'+result[0].count18to19+'"/> '
						  +'<set label="19:00-20:00" value="'+result[0].count19to20+'"/> '
						  +'<set label="20:00-21:00" value="'+result[0].count20to21+'"/> '
						  +'<set label="21:00-22:00" value="'+result[0].count21to22+'"/> '
						  +'<set label="22:00-23:00" value="'+result[0].count22to23+'"/> '
						  +'<set label="23:00-24:00" value="'+result[0].count23to24+'"/> '
						  +'</chart>';
				}else{
					_xml = '<chart caption="最大在线人数统计"  xAxisName="时间区间" yAxisName="在线人数" rotateNames="1" slantLabels="1"  yAxisMaxValue="'+maxValue+'" yAxisMinValue="0" baseFontSize ="12" showValues="1" alternateHGridColor="FCB541" alternateHGridAlpha="20" numberSuffix="(人)" divLineColor="FCB541" divLineAlpha="50" canvasBorderColor="666666" baseFontColor="666666" lineColor="FCB541">'
					      +'<set label="0:00-1:00" value="0"/> '
						  +'<set label="1:00-2:00" value="0"/> '
						  +'<set label="2:00-3:00" value="0"/> '
						  +'<set label="3:00-4:00" value="0"/> '
						  +'<set label="4:00-5:00" value="0"/> '
						  +'<set label="5:00-6:00" value="0"/> '
						  +'<set label="6:00-7:00" value="0"/> '
						  +'<set label="7:00-8:00" value="0"/> '
						  +'<set label="8:00-9:00" value="0"/> '
						  +'<set label="9:00-10:00" value="0"/> '
						  +'<set label="10:00-11:00" value="0"/> '
						  +'<set label="11:00-12:00" value="0"/> '
						  +'<set label="12:00-13:00" value="0"/> '
						  +'<set label="13:00-14:00" value="0"/> '
						  +'<set label="14:00-15:00" value="0"/> '
						  +'<set label="15:00-16:00" value="0"/> '
						  +'<set label="16:00-17:00" value="0"/> '
						  +'<set label="17:00-18:00" value="0"/> '
						  +'<set label="18:00-19:00" value="0"/> '
						  +'<set label="19:00-20:00" value="0"/> '
						  +'<set label="20:00-21:00" value="0"/> '
						  +'<set label="21:00-22:00" value="0"/> '
						  +'<set label="22:00-23:00" value="0"/> '
						  +'<set label="23:00-24:00" value="0"/> '
						  +'</chart>';
				}
				chartType = "<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Line.swf";
			    chartShowType = "lineId1";
				renderingFlash();
			});

		}else if(timeValue =='2'){
			startTime = cui('#startTimeId1').getValue();
			if(startTime ==''){
				cui.alert('请先选择统计的日期。');
				return;
			}
			var obj = {orgId:orgId,statisticsType:2,startTime:startTime,finishTime:finishTime};
			var monDay = getStatisticsDate(startTime);
			UserOnlineAction.userOnlineStatistics(obj,function(data){
				var result = data.statistics;
				var labels="";
				var maxValue=5;
				var numLines=maxValue>=5?maxValue+4:5;
				if(numLines>5){
					numLines=5
				}
				if(maxValue==0){
					maxValue=5;
				}
				labels = '<set label="'+monDay+' 周日" value="'+result.sun+'"/> '
				  +'<set label="'+GetDateStr(monDay,1)+' 周一" value="'+result.mon+'"/> '
				  +'<set label="'+GetDateStr(monDay,2)+' 周二" value="'+result.tue+'"/> '
				  +'<set label="'+GetDateStr(monDay,3)+' 周三" value="'+result.wed+'"/> '
				  +'<set label="'+GetDateStr(monDay,4)+' 周四" value="'+result.thu+'"/> '
				  +'<set label="'+GetDateStr(monDay,5)+' 周五" value="'+result.fri+'"/> '
				  +'<set label="'+GetDateStr(monDay,6)+' 周六" value="'+result.sat+'"/> '

				_xml = '<chart caption="最大在线人数统计"  xAxisName="时间区间"  yAxisName="在线人数"  yAxisMaxValue="'+maxValue+'" yAxisMinValue="0" rotateNames="1" slantLabels="1"  baseFontSize ="12" showValues="1" numberSuffix="(人)" lineColor="FCB541">'
			    _xml += labels+'</chart>';

			    chartType = "<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Line.swf";
			    chartShowType = "lineId2";
				renderingFlash();
			});
		}else if(timeValue =='3'){
			var statisticsMonth = cui('#statisticsMonth').getValue();
			if(statisticsMonth ==''){
				cui.alert('请选择统计的月份。');
				return;
			}
			var value = statisticsMonth.split('-');
			var yearValue = value[0];
			var monthValue = value[1];
			var obj = {orgId:orgId,statisticsType:3,yearValue:yearValue,monthValue:monthValue};
			UserOnlineAction.userOnlineStatistics(obj,function(data){
				var resultList = data.list;
				var maxValue=5;
				var labels="";
				for( i = 0; i < resultList.length; i++){
					if(resultList[i].todaymaxcount>maxValue){
						maxValue=resultList[i].todaymaxcount;
					}
					labels+='<set label="'+ comtop.Date.format(resultList[i].statisticsTime,'yyyy-MM-dd') + '" value="'+resultList[i].todaymaxcount+'" /> '
				}
				var numLines=maxValue>=5?maxValue+4:5;
				if(numLines>5){
					numLines=5
				}
				if(maxValue==0){
					maxValue=5;
				}
				_xml = '<chart caption="最大在线人数统计"  numDivLines="'+numLines+'"  xAxisName="时间区间" rotateNames="1" slantLabels="1"  yAxisName="在线人数" yAxisMaxValue="'+maxValue+'" yAxisMinValue="0" baseFontSize ="12" showValues="1" alternateHGridColor="FCB541" alternateHGridAlpha="20" numberSuffix="(人)" divLineColor="FCB541" canvasBorderColor="666666" baseFontColor="666666" lineColor="FCB541">'
				_xml+=labels+'</chart>';

				chartType = "<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Line.swf";
			    chartShowType = "lineId3";
				renderingFlash();
			});
		}else if(timeValue =='4'){
			var seasonsSelect = cui('#seasonsSelect').getValue();
			if(seasonsSelect == ''){
				cui.alert('请选择统计的季度。');
				return;
			}
			var sessionValue = seasonsSelect.split('-');
			var yearValue = sessionValue[0];
			var season = sessionValue[1];
			
			var obj = {orgId:orgId,statisticsType:4,yearValue:yearValue,season:season};
			UserOnlineAction.userOnlineStatistics(obj,function(data){
				var resultList = data.list;
				var maxValue=5;
				var labels="";
				for( i = 0; i < resultList.length; i++){
					if(resultList[i].todaymaxcount>maxValue){
						maxValue=resultList[i].todaymaxcount;
					}
					labels+='<set label="'+resultList[i].yearAndMonth+'" value="'+resultList[i].todaymaxcount+'" /> '
				}
				var numLines=maxValue>=5?maxValue+4:5;
				if(numLines>5){
					numLines=5
				}
				if(maxValue==0){
					maxValue=5;
				}
				_xml = '<chart caption="最大在线人数统计"  xAxisName="时间区间"  rotateNames="1" slantLabels="1"  yAxisName="在线人数" yAxisMaxValue="'+maxValue+'" yAxisMinValue="0" baseFontSize ="12" showValues="1" alternateHGridColor="FCB541" alternateHGridAlpha="20" numberSuffix="(人)" divLineColor="FCB541" divLineAlpha="50" canvasBorderColor="666666" baseFontColor="666666" lineColor="FCB541">'
				_xml+=labels+'</chart>';
				chartType = "<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Line.swf";
			    chartShowType = "lineId4";
				renderingFlash();
			});
		}else if(timeValue =='5'){
			var yearValue = cui('#statisticsYear').getValue();
			if(yearValue==''){
				cui.alert('请先选择统计的年份。');
				return;
			}
			var obj = {orgId:orgId,statisticsType:5,yearValue:yearValue};
			UserOnlineAction.userOnlineStatistics(obj,function(data){
				var result = data.statistics;
				var labels="";
				var maxValue=5;
				var numLines=maxValue>=5?maxValue+4:5;
				if(numLines>5){
					numLines=5
				}
				if(maxValue==0){
					maxValue=5;
				}
				labels+='<set label="一月" value="'+result.jan+'"/> '
					+ '<set label="二月" value="'+result.feb+'"/> '
					+ '<set label="三月" value="'+result.mar+'"/> '
					+ '<set label="四月" value="'+result.apr+'"/> '
					+ '<set label="五月" value="'+result.may+'"/> '
					+ '<set label="六月" value="'+result.jun+'"/> '
					+ '<set label="七月" value="'+result.jul+'"/> '
					+ '<set label="八月" value="'+result.aug+'"/> '
					+ '<set label="九月" value="'+result.sep+'"/> '
					+ '<set label="十月" value="'+result.oct+'"/> '
					+ '<set label="十一月" value="'+result.nov+'"/> '
					+ '<set label="十二月" value="'+result.dec+'"/> ';
				_xml = '<chart caption="最大在线人数统计"  rotateNames="1" slantLabels="1" xAxisName="时间区间" yAxisName="在线人数" yAxisMaxValue="'+maxValue+'" yAxisMinValue="0" baseFontSize ="12" showValues="1" alternateHGridColor="FCB541" alternateHGridAlpha="30" divLineColor="FCB541" numberSuffix="(人)" divLineAlpha="50" canvasBorderColor="666666" baseFontColor="666666" lineColor="FCB541">'
				_xml += labels + '</chart>';
				chartType = "<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Line.swf";
			    chartShowType = "lineId5";
				renderingFlash();
			});
		}else if(timeValue =='6'){
			var obj = {statisticsType:6,startTime:startTime,finishTime:finishTime,orgId:orgId};
			if(!finishTime || !startTime){
				cui.alert('请先选择时间范围。');
				return;
			}
			if(dateDiff(startTime,finishTime) > 90){
				UserOnlineAction.userOnlineStatistics(obj,function(data){
					
					
					var resultList = data.list;
					var maxValue=5;
					var numLines=maxValue>=5?maxValue+4:5;
					if(numLines>5){
						numLines=5
					}
					if(maxValue==0){
						maxValue=5;
					}
					_xml = '<chart caption="最大在线人数统计"  xAxisName="时间区间" yAxisName="在线人数" rotateNames="1" slantLabels="1"  yAxisMaxValue="'+maxValue+'" yAxisMinValue="0" baseFontSize ="12" showValues="1" alternateHGridColor="FCB541" alternateHGridAlpha="20" divLineColor="FCB541" divLineAlpha="50" canvasBorderColor="666666" numberSuffix="(人)"  baseFontColor="666666" lineColor="FCB541">'
						_xml += '<categories>'
							for( i = 0; i < resultList.length; i++){
								_xml+='<category label="'+resultList[i].yearAndMonth+'"  /> '
						}
						_xml += '</categories>'
						_xml +='<dataset  color="FF8040" anchorBorderColor="FF8040">'
						for( i = 0; i < resultList.length; i++){
							_xml+='<set  value="'+resultList[i].todaymaxcount+'" /> '
						}
						_xml +='</dataset>'
						_xml += '</chart>';
					chartType = "<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/ScrollLine2D.swf";
					chartShowType = "ScrollLine2DssId";
					renderingFlash();
				});
			}else{
				UserOnlineAction.userOnlineStatistics(obj,function(data){
					var resultList = data.list;
					var maxValue=5;
					var numLines=maxValue>=5?maxValue+4:5;
					if(numLines>5){
						numLines=5
					}
					if(maxValue==0){
						maxValue=5;
					}
					var days = dateDiff(finishTime,startTime);
					_xml = '<chart caption="最大在线人数统计" rotateNames="1" slantLabels="1" xAxisName="时间区间" yAxisName="在线人数" yAxisMaxValue="'+maxValue+'" yAxisMinValue="0" baseFontSize ="12" showValues="1" alternateHGridColor="FCB541" alternateHGridAlpha="20" divLineColor="FCB541" divLineAlpha="50" canvasBorderColor="666666" numberSuffix="(人)"  baseFontColor="666666" lineColor="FCB541">'
						_xml += '<categories>'
							for( i = 0; i < resultList.length; i++){
								_xml+='<category label="'+comtop.Date.format(resultList[i].statisticsTime,'yyyy-MM-dd')+'"  /> '
						}
						_xml += '</categories>'
						_xml +='<dataset  color="FF8040" anchorBorderColor="FF8040">'
						for( i = 0; i < resultList.length; i++){
							_xml+='<set  value="'+resultList[i].todaymaxcount+'" /> '
						}
						_xml +='</dataset>'
					_xml+='</chart>';
					chartType = "<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/ScrollLine2D.swf";
					chartShowType = "ScrollLine2DssId";
					renderingFlash();
				});
			}
		}
	}


	function resetFlashWidth(){
		if(chart != null){
			renderingFlash();
		}
	}


	/**
	* 渲染显示内容
	*
	*/
	function renderingFlash(){
		 chartHeight = $("body").height() - 40;
	     chartWidth = $("body").width() - 5;
		 chart = new FusionCharts(chartType, chartShowType, chartWidth, chartHeight, "0", "10");
		 chart.setDataXML(_xml);
		 chart.addParam("wmode","Opaque");
		 chart.render('operateStatisticsDIV');
	}

</script>
</body>
</html>