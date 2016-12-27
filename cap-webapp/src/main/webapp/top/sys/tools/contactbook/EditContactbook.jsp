<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>通讯录管理</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ContactbookAction.js"></script>

<style type="text/css">
.table {
	border: 1px solid #ccc;
	border-width: 1px 0 0 1px;
	width: 30%;
}

.table td {
	padding: 2px;
	border: 1px solid #ccc;
	border-width: 0 1px 1px 0;
	background: #fff;
}

.table .label {
	text-align: right;
	background: #1d67a6;
	color: #fff;
	width: 42px;
}

html,body {
	
}

.button_box {
	*margin-right: 6px;
}
</style>
</head>
<body>
	<div class="top_header_wrap">
		<div class="thw_title">编辑通讯录信息</div>
		<div id="top_float_right" class="thw_operate" style="margin-right: 12px"   >
				<span uitype="button" label="添加"  id="upload" on_click="save"></span>
		</div>
	</div>
	<div class="top_content_wrap">
		<table class="form_table">
			<tr>    
			<td class="td_label" width="12%">
			<span class="top_required">*</span>联系人</td>     	
			  <td> 
			  <span id="contacter" width="70%" uitype="Input" name="contacter" databind="data.contacter"  width="40%" maxlength="20"
			  	validate="[{'type':'required', 'rule':{'m': '联系人 不能为空。'}}]" readonly=false ></span></td>         
              </tr>          
              	<tr>    
			<td class="td_label" width="15%">
			<span class="top_required">*</span>联系电话</td>     
			  <td> <span id="tel" width="70%" uitype="Input" name="tel" databind="data.tel"  maxlength="40"
			  validate="[{'type':'required', 'rule':{'m': '联系电话不能为空。'}},{'type':'custom', 'rule':{'against':'isContainSpecialChar','m': '联系电话格式错误  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 座机正确格式:010-88888888，手机正确格式：13888888888'}}]" readonly=false></span></td>
              </tr>
                           	<tr>    
			<td class="td_label" width="15%">备注  &nbsp; &nbsp;</td>     
			  <td> <span id="remark" width="70%" height="100" uitype="Textarea" name="remark" databind="data.remark"  maxlength="50" byte =true maxlength="50" readonly=false ></span></td>           
              </tr>
		</table>
	</div>
	

<script type='text/javascript'>
var contactId = "<c:out value='${param.contactId}'/>";
var menuData={};
var data = {};
window.onload = function(){
	//初始化页面
    if (contactId) {//编辑页面
    	$("#upload").attr("label","保存");
        dwr.TOPEngine.setAsync(false);
        ContactbookAction.readContactBook(contactId,function(contactpersonData){
                  data = contactpersonData;         
        });
        dwr.TOPEngine.setAsync(true);
        $(".thw_title").html("编辑通讯录信息");
    	comtop.UI.scan();
    }else {//新增页面
        saveType = "add";
        $(".thw_title").html("新增通讯录信息");
    } 
    comtop.UI.scan();
}

/**
* 判断是否符合手机联系方式格式
*/
function isContainSpecialChar(){
	var attriName = arguments[0];
	var phone =/^1[0|1|2|3|4|5|6|7|8|9][0-9]\d{4,8}$/;
	var  mobile =/^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$/;
	return (phone.test(attriName)||mobile.test(attriName));
}

//保存方法
function save(){	
	  //验证消息
    var map = window.validater.validAllElement();
    var inValid = map[0];
    if (inValid.length ==0){    
 	var vo = cui(data).databind().getValue();
 	ContactbookAction.saveContactBook(vo,function(iContactId){
    	if(contactId){
    		window.parent.cui.message('修改联系人成功。', 'success');
    		window.parent.addCallBack(iContactId);
    		window.parent.dialog.hide();   
    	}else{
    		window.parent.cui.message('添加联系人成功。', 'success');
			window.parent.addCallBack(iContactId);
			window.parent.dialog.hide();
    	}
    });
   	}
}


//返回

</script>
</body>
</html>
