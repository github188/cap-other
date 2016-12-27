<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page contentType="text/html; charset=GBK" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>��֯ȫ�����ҳ��</title>
<link rel='stylesheet' type='text/css' href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"/>
<link rel='stylesheet' type='text/css' href="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/css/choose.css"/>
</head>
<script type='text/javascript' src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type='text/javascript' src="${pageScope.cuiWebRoot}/top/sys/js/commonUtil.js"></script>
<script type='text/javascript' src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type='text/javascript' src="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/js/choose.js" cuiTemplate="choose.html"></script>
<script type="text/javascript" src="js/cookie.js"></script>
<script type='text/javascript' src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type='text/javascript' src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ChooseAction.js"></script>
<style>
	.testStyle{
		color:red;
		cursor: pointer;
	}
</style>
<script type="text/javascript">
	var allOrgProperties = "width;height;readonly;isAllowOther;orgStructureId;rootId;isSearch;showLevel;showOrder;defaultOrgId;formName;idName;valueName;levelFilter;unselectableCode;opts";
	var unTestPropertiesArr =[];
	var passPropertiesArr=["id","callback","delCallback"];
	var failPropertiesArr=[];
	var testingPropertiesArr=["chooseMode"];

	//�Ӳ������Ƴ�����
	function removeDataFromArr(arr,name){
		for(var i=0;i<arr.length;++i){
			if(arr[i]==name){
				arr.splice(i,1);
			}
		}
	}

	//��������ӵ�������
	function putDataToArr(arr,name){
		for(var i=0;i<arr.length;++i){
			if(arr[i]==name){
				return;
			}
		}
		arr.push(name);
	}

	//�Ƿ�ͨ��
	function passOrFailOption(value,flag){
	  var message ="ȷ��ͨ����";
	  if(!flag){
	  	message ="ȷ��ʧ�ܣ�";
	  }
	   if(!confirm(message))
	   {
	       return ;
	   }
	   removeDataFromArr(testingPropertiesArr,value);
		if(flag){
			putDataToArr(passPropertiesArr,value);
		}else{
			putDataToArr(failPropertiesArr,value);
		}
		renderTable();
		rennderPassDiv();
		setDataIntoCookie();
	}
	
	//δ��������
	function unTestOption(value){
		if(!confirm("����δ����������"))
	   {
	       return ;
	   }
	   removeDataFromArr(testingPropertiesArr,value);
	   putDataToArr(unTestPropertiesArr,value);
	   setDataIntoCookie();
	   renderTable();
	   renderSelect();
	}
	
	
	var options ={};
	//չ����֯��ǩ
    function displayOrgTag(){
		
		options.id="tagOrgTest";
		options.callback=chooseCallback;
		$("#propertiesTable").find("input[type='text']").each(function(){
			var name = $(this).attr("name");
			var value = $(this).val();
			
	       value=value.split("\"").join("'");
	      
			if(value=="true"||value=="false"){
				eval("options."+name+"="+value);
			}else{
			    eval("options."+name+"=\""+value+"\"");
			}
		    console.log("options."+name+"=\""+value+"\"");
		});
		
		cui("#myOrgChoose").chooseOrg(
			options
		);
		//���У��
		window.validater = cui().validate();
		window.validater.add('tagOrgTest', 'required', { 
			m:'����Ϊ��'
			});
		
		cui.tip(
		        '#tagOrgTest', //Ҫ��ʾTip��λ�ã�����ָ�������ĳ��HTML��ǩ����ʽ��һ��jqueryѡ�������ʽ
		        {
		            tipEl: $('#tagOrgTest')  
		        }
		    );

		
		setCookie("options",JSON.stringify(options),date);
		if(getCookie("needDisplayTag")==true || getCookie("needDisplayTag")=="true"){
		}else{
			setCookie("needDisplayTag",true,date);
			location.reload();
		}
		//��ʾ��ť
		$("#setOrgTagReadonly").css("display","");
		$("#cancelOrgTagReadonly").css("display","");
		
	}
	
	//��Ⱦdiv����
	function rennderPassDiv(){
		$("#passDiv").html(passPropertiesArr.join(";"));
		$("#failDiv").html(failPropertiesArr.join(";"));
	}
	
	//��Ⱦ�������
	function renderTable(){
		var html = "<tr>		<th>��������</th>		<th>����ֵ</th>		<th>��������</th>		<th>����ֵ</th>		<th>��������</th>		<th>����ֵ</th>	</tr>";
		var flag = true;
		var i=0;
		for(;i<testingPropertiesArr.length;i++){
			if(i%3==0 && !flag){
				html += "</tr>";
				flag = true;
			}
			if(i%3==0 && flag){
				html += "<tr>";
				flag = false;
			}
			var value = eval("options."+testingPropertiesArr[i]);
			if(value+""=="undefined"){
				value="";
			}
			html += "<td>"+testingPropertiesArr[i]+"</td> <td> <input name='"+testingPropertiesArr[i]+"' value='"+value+"' type='text' size =20 /> <input value='ͨ��' type='button' onclick=\"passOrFailOption('"+testingPropertiesArr[i]+"',true)\" /><input value='ʧ��' type='button' onclick=\"passOrFailOption('"+testingPropertiesArr[i]+"',false)\" /><input value='��ʱ����' type='button' onclick=\"unTestOption('"+testingPropertiesArr[i]+"')\" />";
		}
		if(i>3 && !flag){
			html += "</tr>";
		}
		$("#propertiesTable").html(html);
	}

	//��Ⱦ����������
	function renderSelect(){
		var html ="";
		for(var i =0 ;i<unTestPropertiesArr.length;i++){
			html += "<option value='"+unTestPropertiesArr[i]+"'>"+unTestPropertiesArr[i]+"</option>";
		}
		$("#untest").html(html);
	}

	//�������
	function addToTest(){
		var currentP = $("#inputProperties").val();
		if(currentP =="" || allOrgProperties.indexOf(currentP)==-1){
			currentP = $("#untest").val();
		}
		$("#untest").find("option[value='"+currentP+"']").remove();
		putDataToArr(testingPropertiesArr,currentP);
		renderTable();
		removeDataFromArr(unTestPropertiesArr,currentP);
		removeDataFromArr(failPropertiesArr,currentP);
		removeDataFromArr(passPropertiesArr,currentP);
		 rennderPassDiv();
		setDataIntoCookie();
	}
	
	//ҳ�����
	var date = new Date();
	$(document).ready(function(){
		comtop.UI.scan();
		
		date = new Date();
		date.setTime(date.getTime() + (120 * 24 * 60 * 60 * 1000));
		date = date.toGMTString();
		jQuery.ajaxSetup({cache:false});
		getDataFromCookie();
		renderSelect();
		renderTable();
		rennderPassDiv();
		if(getCookie("needDisplayTag")==true || getCookie("needDisplayTag")=="true"){
			displayOrgTag();
		}
		setCookie("needDisplayTag",false,date);
	});

	
	
	/**�˴�Ϊ�ص���ҵ����*/
	function chooseCallback(selected){
		console.log(selected);
	}

	//��ֵ���浽cookie��
	function setDataIntoCookie(){
		setCookie("unTestPropertiesArr",unTestPropertiesArr.join(";"),date);
		setCookie("passPropertiesArr",passPropertiesArr.join(";"),date);
		setCookie("failPropertiesArr",failPropertiesArr.join(";"),date);
		setCookie("testingPropertiesArr",testingPropertiesArr.join(";"),date);
	}
	
	//��cookie�ж�ȡ����
	function getDataFromCookie(){
		if(getCookie("unTestPropertiesArr") !=""){
			unTestPropertiesArr = getCookie("unTestPropertiesArr").split(";");
		}else{
			unTestPropertiesArr = allOrgProperties.split(";");
		}
		if(getCookie("passPropertiesArr") !=""){
			passPropertiesArr = getCookie("passPropertiesArr").split(";");
		}
		if(getCookie("failPropertiesArr") !=""){
			failPropertiesArr = getCookie("failPropertiesArr").split(";");
		}
		if(getCookie("testingPropertiesArr") !=""){
			testingPropertiesArr = getCookie("testingPropertiesArr").split(";");
		}
		if(getCookie("options") !=""){
			options = eval('(' + getCookie("options") + ')') ;
		}
	}

	//ˢ������
	function refreshData(){
		if(!confirm("ˢ�����ݽ����cookie��ֵ���������Խ�Ϊδ����"))
	   {
	       return ;
	   }
	   deleteCookie("unTestPropertiesArr");
	   deleteCookie("passPropertiesArr");
	   deleteCookie("failPropertiesArr");
	   deleteCookie("testingPropertiesArr");
	   deleteCookie("options");
	   location.reload();
	}
	
	//���ñ�ǩֻ��
	function setOrgTagReadonly(){
		  cui('#tagOrgTest').setReadonly(true); 
	}
	
	//ȡ����ǩֻ��
	function cancelOrgTagReadonly(){
		  cui('#tagOrgTest').setReadonly(false);  
	}
	
	//���У��
	function addValidate(){
		window.validater.add('tagOrgTest', 'required', { 
			m:'����Ϊ��'
			}); 
	}

	
	//У��
	function validateExec(){
		window.validater.validAllElement(); 
	}


</script>
<body>
	δ���Ե����ԣ�
	<input type="text" id="inputProperties" size="20"  >
	<select id = "untest" name="untest">
	</select>
	<input type="button" value="�������" onclick="addToTest();" />
	<input type="button" value="ˢ������" title="��ղ��Թ������ݣ����½��в���" onclick="refreshData();" />   ���Իص����� chooseCallback(obj)
	<table class="table_list" border="1" id="propertiesTable">
	</table>
	<input value="������֯��ǩ" type ="button" onclick="displayOrgTag();" />
	<input id="setOrgTagReadonly"  style="display: none;"  value="���ñ�ǩֻ��" type ="button" onclick="setOrgTagReadonly();" />
	<input id="cancelOrgTagReadonly" style="display: none;"  value="ȡ����ǩֻ��" type ="button" onclick="cancelOrgTagReadonly();" />
	
	
	<div style="border:1px solid #5fa4de;width:90%;height: 100px;overflow: auto;word-break:break-all ">
		����ͨ�������ԣ�<div id="passDiv" ></div>
		<br>
		����ʧ�ܵ����ԣ�<div id="failDiv"></div>
	</div>
	<div id="console" style="border:1px solid #5fa4de;width:90%;height: 50px;word-break:break-all ">
	</div>
	

	<span id="myOrgChoose"></span>
	
	
</body>
</html>
