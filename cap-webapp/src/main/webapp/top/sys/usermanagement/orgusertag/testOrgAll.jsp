<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page contentType="text/html; charset=GBK" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>组织全面测试页面</title>
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

	//从参数中移除数据
	function removeDataFromArr(arr,name){
		for(var i=0;i<arr.length;++i){
			if(arr[i]==name){
				arr.splice(i,1);
			}
		}
	}

	//将数据添加到参数中
	function putDataToArr(arr,name){
		for(var i=0;i<arr.length;++i){
			if(arr[i]==name){
				return;
			}
		}
		arr.push(name);
	}

	//是否通过
	function passOrFailOption(value,flag){
	  var message ="确认通过？";
	  if(!flag){
	  	message ="确认失败？";
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
	
	//未测试属性
	function unTestOption(value){
		if(!confirm("加入未测试属性中"))
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
	//展现组织标签
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
		//添加校验
		window.validater = cui().validate();
		window.validater.add('tagOrgTest', 'required', { 
			m:'不能为空'
			});
		
		cui.tip(
		        '#tagOrgTest', //要显示Tip的位置，这里指定组件的某个HTML标签，格式是一个jquery选择器表达式
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
		//显示按钮
		$("#setOrgTagReadonly").css("display","");
		$("#cancelOrgTagReadonly").css("display","");
		
	}
	
	//渲染div数据
	function rennderPassDiv(){
		$("#passDiv").html(passPropertiesArr.join(";"));
		$("#failDiv").html(failPropertiesArr.join(";"));
	}
	
	//渲染表格数据
	function renderTable(){
		var html = "<tr>		<th>属性名称</th>		<th>属性值</th>		<th>属性名称</th>		<th>属性值</th>		<th>属性名称</th>		<th>属性值</th>	</tr>";
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
			html += "<td>"+testingPropertiesArr[i]+"</td> <td> <input name='"+testingPropertiesArr[i]+"' value='"+value+"' type='text' size =20 /> <input value='通过' type='button' onclick=\"passOrFailOption('"+testingPropertiesArr[i]+"',true)\" /><input value='失败' type='button' onclick=\"passOrFailOption('"+testingPropertiesArr[i]+"',false)\" /><input value='暂时不测' type='button' onclick=\"unTestOption('"+testingPropertiesArr[i]+"')\" />";
		}
		if(i>3 && !flag){
			html += "</tr>";
		}
		$("#propertiesTable").html(html);
	}

	//渲染下拉框数据
	function renderSelect(){
		var html ="";
		for(var i =0 ;i<unTestPropertiesArr.length;i++){
			html += "<option value='"+unTestPropertiesArr[i]+"'>"+unTestPropertiesArr[i]+"</option>";
		}
		$("#untest").html(html);
	}

	//加入测试
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
	
	//页面入口
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

	
	
	/**此处为回调的业务处理*/
	function chooseCallback(selected){
		console.log(selected);
	}

	//将值保存到cookie中
	function setDataIntoCookie(){
		setCookie("unTestPropertiesArr",unTestPropertiesArr.join(";"),date);
		setCookie("passPropertiesArr",passPropertiesArr.join(";"),date);
		setCookie("failPropertiesArr",failPropertiesArr.join(";"),date);
		setCookie("testingPropertiesArr",testingPropertiesArr.join(";"),date);
	}
	
	//从cookie中读取数据
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

	//刷新数据
	function refreshData(){
		if(!confirm("刷新数据将清除cookie的值，所有属性将为未测试"))
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
	
	//设置标签只读
	function setOrgTagReadonly(){
		  cui('#tagOrgTest').setReadonly(true); 
	}
	
	//取消标签只读
	function cancelOrgTagReadonly(){
		  cui('#tagOrgTest').setReadonly(false);  
	}
	
	//添加校验
	function addValidate(){
		window.validater.add('tagOrgTest', 'required', { 
			m:'不能为空'
			}); 
	}

	
	//校验
	function validateExec(){
		window.validater.validAllElement(); 
	}


</script>
<body>
	未测试的属性：
	<input type="text" id="inputProperties" size="20"  >
	<select id = "untest" name="untest">
	</select>
	<input type="button" value="加入测试" onclick="addToTest();" />
	<input type="button" value="刷新数据" title="清空测试过的数据，重新进行测试" onclick="refreshData();" />   测试回调函数 chooseCallback(obj)
	<table class="table_list" border="1" id="propertiesTable">
	</table>
	<input value="生成组织标签" type ="button" onclick="displayOrgTag();" />
	<input id="setOrgTagReadonly"  style="display: none;"  value="设置标签只读" type ="button" onclick="setOrgTagReadonly();" />
	<input id="cancelOrgTagReadonly" style="display: none;"  value="取消标签只读" type ="button" onclick="cancelOrgTagReadonly();" />
	
	
	<div style="border:1px solid #5fa4de;width:90%;height: 100px;overflow: auto;word-break:break-all ">
		测试通过的属性：<div id="passDiv" ></div>
		<br>
		测试失败的属性：<div id="failDiv"></div>
	</div>
	<div id="console" style="border:1px solid #5fa4de;width:90%;height: 50px;word-break:break-all ">
	</div>
	

	<span id="myOrgChoose"></span>
	
	
</body>
</html>
