<%
/**********************************************************************
* 定时器信息编辑页面
* 2013-03-14 陈萌 新建
**********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<html>
<head>
<title>定时器定制</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/QuartzAction.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/js/jquery.js'></script>

</head>
<body>
<div class="top_header_wrap">
	<div class="thw_title">
		编辑定时器信息
	</div>
	<div class="thw_operate">
		<span uitype="Button" label="&nbsp;保&nbsp;存&nbsp;" on_click="doSave"></span>
		<span uitype="Button" label="&nbsp;返&nbsp;回&nbsp;" on_click="doBack"></span>
	</div>
</div>
<!-- 第二行是表單 -->
<div class="top_content_wrap">
	<table width="100%" class="form_table">
	    <tr>
			<td class="td_label" width="15%"><span class="top_required">*</span>定时器名称 </td>
			<td>
				<span uitype="Input" id="jobName" databind="data.jobName"  name="jobName" validate="必须填写定时器名称" on_change="setTriggerName" ></span>
				<font color="red">该定时器名称需和配置文件中实现类id一致</font>
			</td>
		</tr>
		<tr>
			<td class="td_label" width="15%">触发器名称 </td>
			<td>
				<span uitype="Input" id="triggerName" databind="data.triggerName" name="triggerName" readonly="true" ></span>
			</td>
		</tr>
		<tr>
			<td class="td_label" width="15%">描述 </td>
			<td>
				<span uitype="Input" databind="data.describe" name="describe"  id="describe" width="200" ></span>
			</td>
		</tr>
		<tr>
			<td class="td_label" width="15%"><span class="top_required">*</span>表达式 </td>
			<td>
				<span uitype="Input" id="cronEL" databind="data.cronEL" name="cronEL" width="200"  validate="[{'type':'custom','rule':{'against':'cronElVal','m':'必须按规则填写时间执行表达式'}}]" ></span>
			</td>
		</tr>
		<tr>
			<td class="td_label" width="15%"><span class="top_required">*</span>状态 </td>
			<td>
				<cui:radioGroup name="jobState" id="jobStateId"  databind="data.jobState">
					<cui:radio value="1" color="blue" text="启用"></cui:radio>
					<cui:radio value="2" color="red" text="停用"></cui:radio>
				</cui:radioGroup>
				<div uitype="RadioGroup" name="jobState" id="jobStateId"  databind="data.jobState">
				    <input type="radio" name="jobState" value="1" color="blue" />启用
				    <input type="radio" name="jobState" value="2" color="red" />停用
				</div>
			</td>
		</tr>
		<tr>
			<td class="td_label" width="15%">
			数据(必需为json格式字符)<br/>
			<font id="applyRemarkLengthFont" >尚能输入
				<label id="remarkLength" style="color:red;"></label>&nbsp; 字符<br/></font>
			</td>
			<td  width="85%" >
				<span uitype="Textarea" name="jobData" databind="data.jobData" relation="remarkLength" maxlength="2000" width="50%"></span>
				<br/><span style="color:red">json格式化的数据中的键不能命名为"beanName"和"systemName"</span>
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript">
var jobId = "${param.jobId}";
var data = {};
$(document).ready(function(){
	if(jobId != null && jobId != ""){//编辑页面需要从后台获取数据
		dwr.TOPEngine.setAsync(false);
		QuartzAction.getJob(jobId,function(result){
				data = result;
		});
		dwr.TOPEngine.setAsync(true);
        //设置定时器名称只读
	}
	
	if(data.jobState == null || data.jobState == 0 || (typeof(data.jobState) == "undefined")){
	   data.jobState = 1;
	}
	comtop.UI.scan(); 
	if(jobId != null && jobId != ""){
		cui("#jobName").setReadOnly(true);
	}
});

/**
 * 校验时间执行表达式
 */
function cronValidate(event,self){
	//var cronVal = self.getValue();
	//var reg = /^[^\u4e00-\u9fa5] *$/;
	
	//if(!reg.test(cronVal)){
	//   cronVal = cronVal.replace(/\D/g,'');
	 //  self.setValue(cronVal);
	//}
}

function doSave(){
	var value = cui(data).databind().getValue();
	if(docheck()){
		if(jobId != null && jobId != ""){//编辑
			QuartzAction.updateJob(value,function(){
					cui.message('修改成功。');
					setTimeout(doBack,1500);
		     });
		}else{
			QuartzAction.insertJob(value,function(strTaskConfigId){
				if(strTaskConfigId){
					cui.message('新增成功。');
					setTimeout(doBack,1500);
				}else{
					cui.message('新增失败。');
				}
			});
	    }
	}
}

/**保存时校验数据*/
function docheck(){
	var flag;
	var map = window.validater.validAllElement();//执行校验
    var inValid = map[0];
    var valid = map[1];
    if (inValid.length > 0) {
        var str = "";
        for (var i = 0; i < inValid.length; i++) {
			str += inValid[i].message;
			str += "<br>";
		}
		flag = false;
		cui.error(str);
    } else {
    	flag = true;
	}
	return flag;
}

function doBack(){
	var url="QuartzList.jsp";
	window.open(url,"_self");
}

function setTriggerName(){
	var jobName = cui("#jobName").getValue();
	cui("#triggerName").setValue(jobName + "Trigger");
}


function cronElVal(Eldata){
	var bResult = true;
	if(Eldata == null || Eldata == ''){
		bResult = false;
	}
	//汉字正则，若存在汉字则为true,否则为false
	var re=/[\u4e00-\u9fa5]/; 
	bResult = !re.test(Eldata);
	return bResult;
}
</script>	
</body>
</html>