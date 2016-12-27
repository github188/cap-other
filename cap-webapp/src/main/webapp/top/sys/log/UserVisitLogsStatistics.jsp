<%
/**********************************************************************
* �û�������־ͳ��
* 2012-10-31 ����   �½�
**********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"></meta>
  	<title>��־����</title>
 	<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<cui:link href="/top/sys/usermanagement/orgusertag/css/choose.css"/>
	<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/js/comtop.ui.min.js'/>
	<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/js/commonUtil.js'/>
	<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/dwr/engine.js'/>
    <script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/UserVisitAction.js'/>
    <script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/ChooseAction.js'/>
    <script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/usermanagement/orgusertag/js/choose.js' cuiTemplate="choose.html"/>
    
    <script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/logs/js/FusionCharts.js'/>
    <script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/js/jquery.js' />
    
	<style>
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
		.list_header_wrap{
		   width:98%;
		}
	</style>
</head>

<body class="body_layout"  > 
<div class="list_header_wrap" >
	<div class="top_float_left">
		<dl class="pullDown_gap">
			<top:chooseOrg id="orgId" width="310px" height="20px" chooseMode="1"  ></top:chooseOrg>
		</dl>
		<dl id="timeSpan">
			<dd><span uitype="Calender" id="startTimeId" width="120px" maxdate="#finishTimeId"></span></dd>
			<dt>��</dt>
			<dd><span uitype="Calender" id="finishTimeId" maxdate="+0d" width="120px" mindate="#startTimeId"></span></dd>
		</dl>
	</div>
	<div class="top_float_right">
	    <span uitype="button"  label="ͳ&nbsp;��" on_click="statistics"></span>
	</div>
</div>
<div id="operateStatisticsDIV"></div>	




<script language="javascript">
    var isShow = false;
	window.onload = function(){
		comtop.UI.scan();
		initRoot();
	};


	function resetFlashWidth(){
		if(isShow){
			showColumnFlash();
		}
	}

    //��ȡ���ڵ�
	function initRoot(){
		var queryData = {'orgId':'-1','orgStructureId':'A'};
		UserVisitAction.obtainOrganizationInfoVO(queryData,function(data){
			var rootData = [{'id':data['orgId'],'name':data['name']}];
			cui('#orgId').setValue(rootData);
			showColumnFlash();
			isShow = true;
		});
	}
	//flash��ʼ��
	function showColumnFlash(){
		var nowDate = new Date();
		var month = nowDate.getMonth() + 1;
		var day = nowDate.getDate()
		if (month<10){
		    month = "0"+month;
		}
		if(day<10){
			day = "0"+day;
		}
	    var firstDay = nowDate.getFullYear() + "-" + month + "-01",
	        today = nowDate.getFullYear() + "-" + month + "-" + day;

	    cui('#startTimeId').setValue(firstDay);
	    cui('#finishTimeId').setValue(today);
	    var orgData = cui('#orgId').getValue();
		var obj = {orgId:orgData[0]['id'],startTime:firstDay,finishTime:today};//Ĭ�ϵ��µ�һ�쵽����
		showStatisticsFlash(obj);
	}


	//ͳ��
	function statistics(){
		var startTime = cui('#startTimeId').getValue(),
			finishTime = cui('#finishTimeId').getValue(),
			orgData = cui('#orgId').getValue(),
			msg = '';
		if(!startTime){
			msg = '����ѡ��ͳ�ƿ�ʼʱ�䡣' + '<br \>';
		}
		if(!finishTime){
			msg = msg + '����ѡ��ͳ�ƽ���ʱ�䡣';
		}
		if(!orgData || !orgData[0] || !orgData[0]['id']){
			msg = msg + '����ѡ���š�';
		}
		if(msg){
			cui.alert(msg);
			return;
		}
		var obj = {orgId:orgData[0]['id'],startTime:startTime,finishTime:finishTime};
		showStatisticsFlash(obj);
	}

	function showStatisticsFlash(obj){
		UserVisitAction.statisticsUserVisit(obj,function(data){
			resultList = data;
        		var _xml='<chart palette="1" caption="�û�����ͳ��" PYAxisMaxValue = "5" PYAxisMinValue = "0" shownames="1" showvalues="0" baseFontSize ="12"   sYAxisValuesDecimals="2"   Scrollbars="1" connectNullData="0" PYAxisName="�û���¼����" SYAxisName="�ۼ�ʱ��" numDivLines="4" formatNumberScale="0"  sNumberSuffix="(Сʱ)"  numberSuffix="(��)">'
			 		+'<categories>';
			 		if(resultList.length>0){
			 			for(var i = 0; i < resultList.length; i++){
							_xml+='<category label="'+resultList[i].orgName+'"/>';
						}
						_xml+='</categories>'+'<dataset seriesName="��¼����" color="F6BD0F" showValues="1">';
						for(var i = 0; i < resultList.length; i++){
							_xml+='<set value="'+resultList[i].loginCount+'"/>'
						}
						_xml+='</dataset>'+'<dataset seriesName="�ۼ�ʱ��" color="8BBA00" showValues="0" parentYAxis="S">'
						for(var i = 0; i < resultList.length; i++){
							_xml+='<set value="'+resultList[i].totalTime+'" />'
						}
				 	}else{
				 	//��������ڲ��ţ�����ʾ���о�
				 		_xml+='<category label=""/>';
				 		_xml+='</categories>'+'<dataset seriesName="��¼����" color="F6BD0F" showValues="0">';
				 		_xml+='<set value="0"/>'
				 		_xml+='</dataset>'+'<dataset seriesName="�ۼ�ʱ��" color="8BBA00" showValues="0" parentYAxis="S">'
				 		_xml+='<set value="0" />'
					 	}

			_xml+='</dataset>'+'</chart>';
			var chartHeight = screen.height*0.5;
	    	var chartWidth = $('body').width()*0.98;
			var chart = new FusionCharts("<cui:webRoot/>/top/sys/tools/fusioncharts/ScrollCombiDY2D.swf", "ScrollCombiDY2DIdss", chartWidth, chartHeight, "0", "10");
			chart.setDataXML(_xml);
			chart.addParam("wmode","Opaque");
			chart.render('operateStatisticsDIV');
		});
	}

	
</script>
</body>
</html>