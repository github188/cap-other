<%
/**********************************************************************
* 日志平台:功能使用情况（个人）
* 2012-10-31 汪超   新建
**********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<html>
<head>
<title>日志管理</title>
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
	<div class="top_float_left" style="width:90%;">
	      <div style="float:left;width:65%;">
			<span style="line-height:28px;">选择人员(最多5人)：</span>
			<top:chooseUser id="userList" width="60%"  height="28px" chooseMode="5"></top:chooseUser>
		  </div>
		  <div style="float:left;width:35%;">
			<span style="float: left"><span uitype="Calender" id="statisticsTimeMin" width="125px" maxdate="#statisticsTimeMax"></span>&nbsp;至&nbsp;</span>
			<span style="float: left"><span uitype="Calender" id="statisticsTimeMax" maxdate="+0d" width="125px" mindate="#statisticsTimeMin"></span></span>
		 </div>
	</div>
	<div class="top_float_right">
		<span uitype="button" label="统&nbsp;计" on_click="statistics"></span>
	</div>
</div>
<div id="operateStatisticsDIV1"></div>
<div id="operateStatisticsDIV2"></div>
<div id="operateStatisticsDIV3"></div>
<div id="operateStatisticsDIV4"></div>
<div id="operateStatisticsDIV5"></div>

<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script  type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/usermanagement/orgusertag/js/choose.js' cuiTemplate="choose.html"></script>
<script  type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/js/jquery.js'></script>
<script  type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/log/js/FusionCharts.js'></script>
<script  type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/js/commonUtil.js'></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/engine.js'></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/util.js"></script>
<script  type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/ChooseAction.js' ></script> 
<script  type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/FunctionUseAction.js'></script> 

<script language="javascript">
	$(function(){
		comtop.UI.scan();
		initTime();
	});
	
	//初始化时间
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
		var firstDay = nowDate.getFullYear() + "-" + month + "-01";
	    var today = nowDate.getFullYear() + "-" + month + "-" + day;

	    cui('#statisticsTimeMin').setValue(firstDay);
	    cui('#statisticsTimeMax').setValue(today);
	}
	
	function packageXML(result){
		var title = "'"+result.userName+"'"+"菜单点击情况";
		    _xml = '<chart caption="'+title+'" xAxisName="菜单名称" yAxisName="点击次数" yAxisMaxValue="10"	showValues="1" decimals="0" baseFontSize ="12" formatNumberScale="0" >'
			//_xml = '<chart caption="'+title+'" xAxisName="菜单名称" yAxisMaxValue="10"  plotSpacePercent="80" rotateLabels="1" yAxisName="点击次数" showValues="1" useRoundEdges="1" baseFontSize="12" baseFontColor="FF0000" numberSuffix="(次)">';
		    if(result.functionUseVOList.length>0){

			    for(var i=0;i<result.functionUseVOList.length;i++){
				    _xml=_xml  +'<set label="'+result.functionUseVOList[i].menuName+'" value="'+result.functionUseVOList[i].clickCount+'" /> '
				    //_xml=_xml  +'<categories><category label="'+result.functionUseVOList[i].menuName+'" /></categories>';
				 }
			}else{
					_xml=_xml  +'<set value="无菜单点击数据" value="0" /> '
			}
		      _xml=_xml +'</chart>';
	}
	//拼装XML数据
	function packageXML1(result){
		var title = "'"+result.userName+"'"+"菜单点击情况";
		    //_xml = '<chart caption="'+title+'" xAxisName="菜单名称" yAxisName="点击次数" yAxisMaxValue="10"	showValues="1" decimals="0" baseFontSize ="12" formatNumberScale="0" numberSuffix="(次)" >'
			_xml = '<chart caption="'+title+'" xAxisName="菜单名称" yAxisMaxValue="10"  plotSpacePercent="80" rotateLabels="1" yAxisName="点击次数" showValues="1" useRoundEdges="1" baseFontSize="12" baseFontColor="FF0000" numberSuffix="(次)">';
		    if(result.functionUseVOList.length>0){

			    for(var i=0;i<result.functionUseVOList.length;i++){
				    //_xml=_xml  +'<set label="'+result.functionUseVOList[i].menuName+'" value="'+result.functionUseVOList[i].clickCount+'" /> '
				    _xml=_xml  +'<categories><category label="'+result.functionUseVOList[i].menuName+'" /></categories>';
				 }
			    for(var i=0;i<result.functionUseVOList.length;i++){
				    //_xml=_xml  +'<set label="'+result.functionUseVOList[i].menuName+'" value="'+result.functionUseVOList[i].clickCount+'" /> '
			    	 _xml=_xml  +'<dataset ><set value="'+result.functionUseVOList[i].clickCount+'"/></dataset>';
				 }
			}else{
					_xml=_xml  +'<set value="无菜单点击数据" value="0" /> '
			}
		      _xml=_xml +'</chart>';
	}
	function packageXML2(){
		var title = "菜单点击情况";
		    _xml = '<chart caption="2014年和2013年年收入" xAxisName="月份" yAxisName="收入" showValues="0" useRoundEdges="1" baseFontSize="14" baseFontColor="FF0000">';


		    
		    _xml=_xml  +'<categories><category label="Jan" /><category label="Feb" /><category label="Feb" /><category label="Feb" /><category label="Feb" /><category label="Feb" /><category label="Feb" /><category label="Feb" /></categories>';


		    _xml=_xml  +'<dataset seriesName="2006"><set value="27400"/><set value="29800"/><set value="29800"/><set value="29800"/><set value="29800"/><set value="29800"/><set value="29800"/><set value="29800"/><set value="29800"/></dataset>';
		    
		    
		    _xml=_xml +'</chart>';
	}
	//统计
	var _xml = '';
	function statistics(){

		$("#operateStatisticsDIV1").html('');
		$("#operateStatisticsDIV2").html('');
		$("#operateStatisticsDIV3").html('');
		$("#operateStatisticsDIV4").html('');
		$("#operateStatisticsDIV5").html('');
		
		//判断时间范围是否为空
		var startDate = cui('#statisticsTimeMin').getValue();
		var endDate = cui('#statisticsTimeMax').getValue();
		if(!startDate || !endDate){
			cui.alert('请先选择时间范围。');
			return;
		}
		var users = cui("#userList").getValue();
		if(users.length == 0){
			cui.alert("请输入要查看的人员名称。");
			return;
		}
		var userIds = '',
		    userNames = '';
		for(var i = 0;i < users.length; i++){
			userIds = userIds + users[i].id + ';';
			userNames = userNames + users[i].name + ';';
		};
		var obj={userNames:userNames,userIds:userIds,statisticsTimeMin:startDate,statisticsTimeMax:endDate};
		FunctionUseAction.queryMenuClickCountByUsers(obj,function(data){
			resultList = data;
			for(var i=0;i<resultList.length;i++){
				packageXML(resultList[i]);
				//packageXMLtest();
				var canvasWidth;
				if(resultList[i].functionUseVOList.length*30>screen.width*0.82){
					canvasWidth=resultList[i].functionUseVOList.length*30;
					if(canvasWidth>8000) canvasWidth=8000;
				}else{
					canvasWidth=screen.width*0.82;
				}
				
				var chart = new FusionCharts("<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Column3D.swf", "Column3DId", canvasWidth, screen.height*0.4, "0", "1");
				//var chart = new FusionCharts("<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/ScrollColumn2D.swf", "Column3DId", screen.width*1, screen.height*0.4, "0", "1");
				chart.setDataXML(_xml);
				chart.addParam("wmode","Opaque");
				chart.render('operateStatisticsDIV'+(i+1)+'');
			}
		});
	}

</script>
</body>
</html>