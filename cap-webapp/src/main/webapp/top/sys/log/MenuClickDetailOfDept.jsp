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
	<div class="top_float_left">
		<dl>
			<dd>
				<span uitype="PullDown" mode="Single" id="pleaseChooseDimensionality" value_field="id" datasource="pleaseChooseDimensionalityData" label_field="label" 
				 width="60" on_select_data="selectDimensionality" name="pleaseChooseDimensionality" editable="false" value='1'></span>
			</dd>
			<dd>
			    <top:chooseOrg id="orgSelect" width="300px" height="30px" chooseMode="1"  ></top:chooseOrg>
				<input type="hidden" id="menuId" value="" />
				<span uitype="ClickInput" id="menuName" width="120px" emptytext="��ѡ��˵�" iconwidth="18px" icon="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/images/openPage.gif" on_iconclick="selectMenu"></span>
				
			</dd>
		</dl>
		<dl id="timeSpan">
			<dd><span uitype="Calender" id="statisticsTimeMin" width="125px" maxdate="#statisticsTimeMax"></span></dd>
			<dt>-</dt>
			<dd><span uitype="Calender" id="statisticsTimeMax" maxdate="+0d" width="125px" mindate="#statisticsTimeMin"></span></dd>
		</dl>
	</div>
	<div class="top_float_right">
		<span uitype="button" label="ͳ&nbsp;��" on_click="statistics"></span>
	</div>
</div>
<div id="operateStatisticsDIV"></div>	
<div id="showDialogDiv">
</div>

<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"  src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/js/commonUtil.js"></script>  
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/usermanagement/orgusertag/js/choose.js" cuiTemplate="choose.html"></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/usermanagement/orgusertag/js/userOrgUtil.js"></script>

<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/engine.js'></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/util.js"></script>

<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/ChooseAction.js'></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/FunctionUseAction.js'></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/log/js/FusionCharts.js'></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/log/js/help.js'></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/js/jquery.js" ></script>


<script language="javascript">

	var showTypeData = [
		{id:'1',label:'����'},
		{id:'2',label:'����'}
	],
		pleaseChooseDimensionalityData = [
		{id:'1',label:'�˵�'},
		{id:'2',label:'��֯'}
	],
		showType = '1',
		menuId;
	
	$(function(){
		comtop.UI.scan();
		dwr.TOPEngine.setAsync(false);
		FunctionUseAction.getRootMenuId(function(data){
			menuId = data;
		});
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

	//��ѯģ������������Դ
	function queryModuleList(obj){
		FunctionUseAction.queryModuleList(function(data){
			obj.setDatasource(data);
		});
	}
	
	//��ѯ���о�����������Դ
	function queryBureauList(obj){
		FunctionUseAction.queryBureauList(function(data){
			obj.setDatasource(data);
		});
	}

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
		if(!startDate || !endDate){
			msg = '����ѡ��ʱ�䷶Χ��';
		}
		var orgValue = cui("#orgSelect").getValue(); 
		if(!orgValue || !orgValue[0] || !orgValue[0]['id']){
			msg = msg + '����ѡ���š�';
		}
		if(msg){
			cui.alert(msg);
			return;
		}
		var orgId = orgValue[0]['id'];
		_orgId=orgId;
		var	dimensionality = cui("#pleaseChooseDimensionality").getValue(),
			showType = '1';//cui("#showType").getValue(),
			menuId = $('#menuId').val();
		if(!menuId){
			cui.alert('����ѡ��˵���');
			return;
		}
		_menuId=menuId;
		//����ѡ���ά����ʾ��ͬ��ͼ��
		if(dimensionality == '1'){
			var obj={statisticsTimeMin:startDate,statisticsTimeMax:endDate,orgId:orgId,menuId:menuId};
			FunctionUseAction.queryFunctionUseVOListByMenu(obj,function(data){
				 packageXMLByMenu(data,showType);
			});
		}else if(dimensionality == '2'){
			//$("#operateDiv").hide();
			var obj={statisticsTimeMin:startDate,statisticsTimeMax:endDate,orgId:orgId,menuId:menuId};
			FunctionUseAction.queryFunctionUseVOListByOrg(obj,function(data){
				 packageXMLByOrg(data,showType);
			});
		}
	}

	//ƴװģ���ӽǵ�xml����
	function packageXMLByMenu(resultList,showType){
		/**�������״ͼ���Բ鿴����ģ���ʹ�������*/
		var _xml = '<chart  yAxisMaxValue = "5" yAxisMinValue = "0" unescapeLinks="0" caption="���˵�ʹ�����ͳ�ƣ��Σ�" xAxisName="�˵�����" yAxisName="�������"  showValues="1" decimals="0" baseFontSize ="12" formatNumberScale="0"  >'
		if(resultList.length==0){
			_xml = _xml+'<set label="������" value="0" /> ';
		}else{
		    for(var i=0;i<resultList.length;i++){
		    	_xml = _xml+'<set label="'+resultList[i].menuName+'" value="'+resultList[i].clickCount+'" link="javascript:on_clickChairMenu(\''+resultList[i].menuId+'\',\''+resultList[i].menuName+'\')" /> ';
		    }
		}
		_xml = _xml +'</chart>';
		var chart;
		//ͼ�������ʾ����������ʾ
		if(showType == '2'){
	  		chart = new FusionCharts("<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Bar2D.swf", "Bar2DId", screen.width*0.82, screen.height*0.6, "0", "10");
	 	}else{
			chart = new FusionCharts("<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Column3D.swf", "Column3DId", screen.width*0.82, screen.height*0.6, "0", "10");
		}
		chart.setDataXML(_xml);
		chart.addParam("wmode","Opaque");
		chart.render('operateStatisticsDIV');
	}

	//ƴװ���о��ӽǵ�xml����
	function packageXMLByOrg(resultList,showType){
		var _xml = '<chart caption="����֯ʹ�����ͳ�ƣ��Σ�" xAxisName="��֯����" yAxisName="�������" yAxisMaxValue = "5" yAxisMinValue = "0" showValues="1" decimals="0" baseFontSize ="12" unescapeLinks="0" formatNumberScale="0" >'
		if(resultList.length==0){
			_xml = _xml+'<set label="������" value="0" /> ';
		}else{
			for(var i = 0,j = resultList.length;i < j; i++){
				_xml = _xml+'<set label="'+resultList[i].orgName+'" value="'+resultList[i].clickCount+'" link="javascript:on_clickChairOrg(\''+resultList[i].orgId+'\',\''+resultList[i].orgName+'\')" /> ';
			}
		}
		_xml = _xml +'</chart>';
		var chart;
		if(showType == '2'){
			if(resultList.length<10){
		 		chart = new FusionCharts("<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Bar2D.swf", "Bar2DId", screen.width*0.82, screen.height*0.6, "0", "10");
			}else{
				chart = new FusionCharts("<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Bar2D.swf", "Bar2DId", screen.width*0.82, screen.height*0.03*resultList.length, "0", "10");
			}
		}else{
			chart = new FusionCharts("<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Column3D.swf", "Column3DId", screen.width*0.82, screen.height*0.6, "0", "10");
		}
		chart.setDataXML(_xml);
		chart.addParam("wmode","Opaque");
		chart.render('operateStatisticsDIV');
	}

	//�����״ͼ����һ���µ�ͼ��
	function showSubModuleDetail(id){
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
	}

    //��ѡ��˵�ҳ��
	function selectMenu(){
		var iWidth = 250;
    	var iHeight = 350;
    	var url="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/log/SelectApp.jsp";
    	var title="ѡ��˵�";
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
	function selectMenuCallback(chooseData){
		if(chooseData.key){
			cui('#menuName').setValue(chooseData.title);
			$('#menuId').val(chooseData.key);
		}else{
			cui('#menuName').setValue('');
			$('#menuId').val('');
		}
	}

	//���ÿ�߶�
	function resetFlashWidth(){
		showColumnFlash();
	}
	
	//ͳ������Ϊ�˵�ʱ���ĳ�˵�ͳ����������¼�
	function on_clickChairMenu(objId,name){
		
		var startDate = _startDate;
		var endDate = _endDate;
		
		showType = '1';
		var orgId = _orgId;
		var menuId=objId;
		var obj={statisticsTimeMin:startDate,statisticsTimeMax:endDate,orgId:orgId,menuId:menuId};
//		FunctionUseAction.queryFunctionUseVOOrgListByMenu(obj,function(data){
//		      on_packageXMLByMenu(data,showType,name)
//		});
		
	}
	//ͳ������Ϊ��֯ʱ���ĳ�˵�ͳ����������¼�
    function on_clickChairOrg(objId,name){
		var startDate = _startDate;
		var endDate = _endDate;
		showType = '1';
		var menuId = _menuId;
		var orgId=objId;
		var obj={statisticsTimeMin:startDate,statisticsTimeMax:endDate,orgId:orgId,menuId:menuId};
//		FunctionUseAction.queryFunctionUseVOMenuListByorg(obj,function(data){
//				on_packageXMLByOrg(data,showType,name);
//		});
		
	}
	//ͳ������Ϊ��֯ʱ���ĳ�˵�ͳ�����չʾ�˵����������
	function on_packageXMLByOrg(resultList,showType,name){
		var _xml = '<chart  yAxisMaxValue = "5" yAxisMinValue = "0" caption="��֯('+name+')���ʲ˵����ͳ��(��)" xAxisName="�˵�����" yAxisName="�������"  showValues="1" decimals="0" baseFontSize ="12" formatNumberScale="0"  >'
		 if(resultList.length==0){
				_xml = _xml+'<set label="������" value="0" /> ';
			}else{
			    for(var i=0;i<resultList.length;i++){
			    	_xml = _xml+'<set label="'+resultList[i].menuName+'" value="'+resultList[i].clickCount+'" /> ';
			    }
			}
			_xml = _xml +'</chart>';
			var chart;
			//ͼ�������ʾ����������ʾ
			if(showType == '2'){
		  		chart = new FusionCharts("<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Bar2D.swf", "Bar2DId", screen.width*0.72, screen.height*0.5, "0", "10");
		 	}else{
				chart = new FusionCharts("<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Column3D.swf", "Column3DId", screen.width*0.72, screen.height*0.5, "0", "10");
			}
			chart.setDataXML(_xml);
			chart.addParam("wmode","Opaque");
			chart.render('showDialogDiv');
			showDialog(showType,resultList.length);
	}
	//ͳ������Ϊ�˵�ʱ���ĳ�˵�ͳ�����չʾ����֯�Ըò˵��������
	function on_packageXMLByMenu(resultList,showType,name){
		var _xml = '<chart caption="����֯���ʲ˵�('+name+')���ͳ��(��)" xAxisName="��֯����" yAxisName="�������" yAxisMaxValue = "5" yAxisMinValue = "0" showValues="1" decimals="0" baseFontSize ="12" formatNumberScale="0" >'
		if(resultList.length==0){
				_xml = _xml+'<set label="������" value="0" /> ';
		}else{
				for(var i = 0,j = resultList.length;i < j; i++){
					_xml = _xml+'<set label="'+resultList[i].orgName+'" value="'+resultList[i].clickCount+'"/> ';
				}
			}
			_xml = _xml +'</chart>';
			var chart;
			if(showType == '2'){
				if(resultList.length<10){
			 		chart = new FusionCharts("<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Bar2D.swf", "Bar2DId", screen.width*0.72, screen.height*0.5, "0", "10");
				}else{
					chart = new FusionCharts("<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Bar2D.swf", "Bar2DId", screen.width*0.72, screen.height*0.02*resultList.length, "0", "10");
				}
			}else{
				chart = new FusionCharts("<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/tools/fusioncharts/Column3D.swf", "Column3DId", screen.width*0.72, screen.height*0.5, "0", "10");
			}
			chart.setDataXML(_xml);
			chart.addParam("wmode","Opaque");
			chart.render('showDialogDiv');
			showDialog(showType,resultList.length);
	}
	
	//��ʾ��ѯ�Ķ���functionchair
	function showDialog(showType,len){
		var  fWidth;
		var fHeight;
		if(showType == '2'){
			if(len<10){
				fWidth=screen.width*0.72;
				fHeight=screen.height*0.5;
			}else{
				fWidthscreen.width*0.72;
				fHeight=screen.height*0.02*len;
			}
		}else{
			fWidth=screen.width*0.72+10;
			fHeight=screen.height*0.5;
		}
		cui('#showDialogDiv').dialog({
            width:fWidth,
            height:fHeight
        }).show();
    }

	
</script>
</body>
</html>
