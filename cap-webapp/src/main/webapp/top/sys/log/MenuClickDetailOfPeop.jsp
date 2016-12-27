<%
/**********************************************************************
* ��־ƽ̨:����ʹ����������ˣ�
* 2012-10-31 ����   �½�
**********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<html>
<head>
<title>��־����</title>
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
			<span style="line-height:28px;">ѡ����Ա(���5��)��</span>
			<top:chooseUser id="userList" width="60%"  height="28px" chooseMode="5"></top:chooseUser>
		  </div>
		  <div style="float:left;width:35%;">
			<span style="float: left"><span uitype="Calender" id="statisticsTimeMin" width="125px" maxdate="#statisticsTimeMax"></span>&nbsp;��&nbsp;</span>
			<span style="float: left"><span uitype="Calender" id="statisticsTimeMax" maxdate="+0d" width="125px" mindate="#statisticsTimeMin"></span></span>
		 </div>
	</div>
	<div class="top_float_right">
		<span uitype="button" label="ͳ&nbsp;��" on_click="statistics"></span>
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
	
	//��ʼ��ʱ��
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
		var title = "'"+result.userName+"'"+"�˵�������";
		    _xml = '<chart caption="'+title+'" xAxisName="�˵�����" yAxisName="�������" yAxisMaxValue="10"	showValues="1" decimals="0" baseFontSize ="12" formatNumberScale="0" >'
			//_xml = '<chart caption="'+title+'" xAxisName="�˵�����" yAxisMaxValue="10"  plotSpacePercent="80" rotateLabels="1" yAxisName="�������" showValues="1" useRoundEdges="1" baseFontSize="12" baseFontColor="FF0000" numberSuffix="(��)">';
		    if(result.functionUseVOList.length>0){

			    for(var i=0;i<result.functionUseVOList.length;i++){
				    _xml=_xml  +'<set label="'+result.functionUseVOList[i].menuName+'" value="'+result.functionUseVOList[i].clickCount+'" /> '
				    //_xml=_xml  +'<categories><category label="'+result.functionUseVOList[i].menuName+'" /></categories>';
				 }
			}else{
					_xml=_xml  +'<set value="�޲˵��������" value="0" /> '
			}
		      _xml=_xml +'</chart>';
	}
	//ƴװXML����
	function packageXML1(result){
		var title = "'"+result.userName+"'"+"�˵�������";
		    //_xml = '<chart caption="'+title+'" xAxisName="�˵�����" yAxisName="�������" yAxisMaxValue="10"	showValues="1" decimals="0" baseFontSize ="12" formatNumberScale="0" numberSuffix="(��)" >'
			_xml = '<chart caption="'+title+'" xAxisName="�˵�����" yAxisMaxValue="10"  plotSpacePercent="80" rotateLabels="1" yAxisName="�������" showValues="1" useRoundEdges="1" baseFontSize="12" baseFontColor="FF0000" numberSuffix="(��)">';
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
					_xml=_xml  +'<set value="�޲˵��������" value="0" /> '
			}
		      _xml=_xml +'</chart>';
	}
	function packageXML2(){
		var title = "�˵�������";
		    _xml = '<chart caption="2014���2013��������" xAxisName="�·�" yAxisName="����" showValues="0" useRoundEdges="1" baseFontSize="14" baseFontColor="FF0000">';


		    
		    _xml=_xml  +'<categories><category label="Jan" /><category label="Feb" /><category label="Feb" /><category label="Feb" /><category label="Feb" /><category label="Feb" /><category label="Feb" /><category label="Feb" /></categories>';


		    _xml=_xml  +'<dataset seriesName="2006"><set value="27400"/><set value="29800"/><set value="29800"/><set value="29800"/><set value="29800"/><set value="29800"/><set value="29800"/><set value="29800"/><set value="29800"/></dataset>';
		    
		    
		    _xml=_xml +'</chart>';
	}
	//ͳ��
	var _xml = '';
	function statistics(){

		$("#operateStatisticsDIV1").html('');
		$("#operateStatisticsDIV2").html('');
		$("#operateStatisticsDIV3").html('');
		$("#operateStatisticsDIV4").html('');
		$("#operateStatisticsDIV5").html('');
		
		//�ж�ʱ�䷶Χ�Ƿ�Ϊ��
		var startDate = cui('#statisticsTimeMin').getValue();
		var endDate = cui('#statisticsTimeMax').getValue();
		if(!startDate || !endDate){
			cui.alert('����ѡ��ʱ�䷶Χ��');
			return;
		}
		var users = cui("#userList").getValue();
		if(users.length == 0){
			cui.alert("������Ҫ�鿴����Ա���ơ�");
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