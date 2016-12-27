<%
/**********************************************************************
* ��ʱ����Ϣ�༭ҳ��
* 2013-03-14 ���� �½�
**********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<html>
<head>
<title>��ʱ������</title>
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
		�༭��ʱ����Ϣ
	</div>
	<div class="thw_operate">
		<span uitype="Button" label="&nbsp;��&nbsp;��&nbsp;" on_click="doSave"></span>
		<span uitype="Button" label="&nbsp;��&nbsp;��&nbsp;" on_click="doBack"></span>
	</div>
</div>
<!-- �ڶ����Ǳ�� -->
<div class="top_content_wrap">
	<table width="100%" class="form_table">
	    <tr>
			<td class="td_label" width="15%"><span class="top_required">*</span>��ʱ������ </td>
			<td>
				<span uitype="Input" id="jobName" databind="data.jobName"  name="jobName" validate="������д��ʱ������" on_change="setTriggerName" ></span>
				<font color="red">�ö�ʱ��������������ļ���ʵ����idһ��</font>
			</td>
		</tr>
		<tr>
			<td class="td_label" width="15%">���������� </td>
			<td>
				<span uitype="Input" id="triggerName" databind="data.triggerName" name="triggerName" readonly="true" ></span>
			</td>
		</tr>
		<tr>
			<td class="td_label" width="15%">���� </td>
			<td>
				<span uitype="Input" databind="data.describe" name="describe"  id="describe" width="200" ></span>
			</td>
		</tr>
		<tr>
			<td class="td_label" width="15%"><span class="top_required">*</span>���ʽ </td>
			<td>
				<span uitype="Input" id="cronEL" databind="data.cronEL" name="cronEL" width="200"  validate="[{'type':'custom','rule':{'against':'cronElVal','m':'���밴������дʱ��ִ�б��ʽ'}}]" ></span>
			</td>
		</tr>
		<tr>
			<td class="td_label" width="15%"><span class="top_required">*</span>״̬ </td>
			<td>
				<cui:radioGroup name="jobState" id="jobStateId"  databind="data.jobState">
					<cui:radio value="1" color="blue" text="����"></cui:radio>
					<cui:radio value="2" color="red" text="ͣ��"></cui:radio>
				</cui:radioGroup>
				<div uitype="RadioGroup" name="jobState" id="jobStateId"  databind="data.jobState">
				    <input type="radio" name="jobState" value="1" color="blue" />����
				    <input type="radio" name="jobState" value="2" color="red" />ͣ��
				</div>
			</td>
		</tr>
		<tr>
			<td class="td_label" width="15%">
			����(����Ϊjson��ʽ�ַ�)<br/>
			<font id="applyRemarkLengthFont" >��������
				<label id="remarkLength" style="color:red;"></label>&nbsp; �ַ�<br/></font>
			</td>
			<td  width="85%" >
				<span uitype="Textarea" name="jobData" databind="data.jobData" relation="remarkLength" maxlength="2000" width="50%"></span>
				<br/><span style="color:red">json��ʽ���������еļ���������Ϊ"beanName"��"systemName"</span>
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript">
var jobId = "${param.jobId}";
var data = {};
$(document).ready(function(){
	if(jobId != null && jobId != ""){//�༭ҳ����Ҫ�Ӻ�̨��ȡ����
		dwr.TOPEngine.setAsync(false);
		QuartzAction.getJob(jobId,function(result){
				data = result;
		});
		dwr.TOPEngine.setAsync(true);
        //���ö�ʱ������ֻ��
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
 * У��ʱ��ִ�б��ʽ
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
		if(jobId != null && jobId != ""){//�༭
			QuartzAction.updateJob(value,function(){
					cui.message('�޸ĳɹ���');
					setTimeout(doBack,1500);
		     });
		}else{
			QuartzAction.insertJob(value,function(strTaskConfigId){
				if(strTaskConfigId){
					cui.message('�����ɹ���');
					setTimeout(doBack,1500);
				}else{
					cui.message('����ʧ�ܡ�');
				}
			});
	    }
	}
}

/**����ʱУ������*/
function docheck(){
	var flag;
	var map = window.validater.validAllElement();//ִ��У��
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
	//�������������ں�����Ϊtrue,����Ϊfalse
	var re=/[\u4e00-\u9fa5]/; 
	bResult = !re.test(Eldata);
	return bResult;
}
</script>	
</body>
</html>