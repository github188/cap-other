<%
/**********************************************************************
* 测试步骤分组编辑
* 2016-06-28 李忠文 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='pageInfoEdit'>
<head>
<title>测试步骤分组编辑</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/test/css/icons.css"></top:link>
<top:link href="/cap/bm/common/base/css/base.css"></top:link>
<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css" />

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/dwr/engine.js"></top:script>
<top:script src="/cap/dwr/util.js"></top:script>
<top:script src="/cap/dwr/interface/StepGroupsFacade.js"></top:script>
</head>
<style>
	.top_header_wrap {
		padding-right: 5px;
	}

    #icons-container {
        position: relative;
    }
    
    .icon {
        display: inline-block;
        *display: inline;
        *zoom: 1;
        vertical-align: top;
        text-align: center;
        margin: 10px;
        cursor: pointer;
        width: 48px;
        position: relative;
    }
    
    .icon .icon-img {
        padding-left: 6px !important;
        width: 36px;
        height: 36px;
        color: blue;
        text-align: center;
        background-size: 100% 100% !important;
    }
    .cap-td {
    	padding: 5px;
    }
</style>
<body>
	<div uitype="Borderlayout" id="body" is_root="true">
		<div class="top_header_wrap" style="padding: 10px 10px 5px 25px">
			<div class="thw_operate" style="float: right; height: 28px;">
				<span uitype="button" id="save" label="确定" on_click="save"></span>
				<span uitype="button" id="close" label="关闭" on_click="close"></span>
			</div>
		</div>
		<div class="cap-area" style="width: 100%; padding: 25px 10px 20px 0px">
			<table class="cap-table-fullWidth">
				<colgroup>
					<col width="15%" />
					<col width="85%" />
				</colgroup>
				<tr>
					<td class="cap-td" style="text-align: right;">
						<font color="red">*</font>编码：
					</td>
					<td class="cap-td" style="text-align: left;">
						<span uitype="input" id="code" name="code" databind="data.code" validate="validateCode" maxlength="28" width="99%" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="cap-td" style="text-align: right;">
						<font color="red">*</font>名称：
					</td>
					<td class="cap-td" style="text-align: left;">
						<span uitype="input" id="name" name="name" databind="data.name" validate="validateName" maxlength="28" width="99%" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="cap-td" style="text-align: right;">
						<font color="red">*</font>图标：
					</td>
					<td class="cap-td" style="text-align: left;">
						<span uitype="ClickInput" id="icon" name="icon" databind="data.icon" validate="[{'type':'required', 'rule':{'m': '图标不能为空'}}]" maxlength="28" width="99%" on_change="iconChanged" enterable="false" readonly="false" icon="picture-o" on_iconclick="showIconSelector"></span>
					</td>
				</tr>
				<tr>
					<td class="cap-td" colspan="2">
						<section id="icons-container">
					        <div class="icon">
					            <div class="icon-img"></div>
					        </div>
				        </section>
					</td>
				</tr>
			</table>
		</div>
	</div>
</body>
<script type="text/javascript">

	var code =  <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("code"))%>;
	var data={};

	$(function(){
		if(!code){
			comtop.UI.scan();
			return;
		}
		dwr.TOPEngine.setAsync(false);
  		StepGroupsFacade.loadStepGroupByCode(code,function(result){
  			if(result){
  				data = result;
  				$(".icon-img").attr("class","icon-img "+ data.icon);
  			}
		});
		dwr.TOPEngine.setAsync(true);
		comtop.UI.scan();
		if(data.code){
			cui("#code").setReadonly(true);
		}
	});
	
	//关闭窗口
	function close() {
		window.parent.closeWindow();
	}

	//校验实体名称字符
	function checkCode(code) {
		var regEx = "^([a-zA-Z])[a-zA-Z0-9_]*$";
		if (code) {
			var reg = new RegExp(regEx);
			return (reg.test(code));
		}
		return true;
	}
	
	function codeChanged(event,self){
		window.validater.validAllElement();
	}

	var validateCode = [ {
		'type' : 'required',
		'rule' : {
			'm' : '编码不能为空。'
		}
	}, {
		'type' : 'custom',
		'rule' : {
			'against' : checkCode,
			'm' : '编码必须为英文字符、数字或者下划线，且必须以英文字符开头。'
		}
	}, {
		'type' : 'custom',
		'rule' : {
			'against' : codeUniqueValidate,
			'm' : '编码已经存在。'
		}
	} ];
	
	//实体名称检测
	var validateName = [
	      {'type':'required','rule':{'m':'名称不能为空。'}},
	      {'type':'custom','rule':{'against':nameUniqueValidate, 'm':'名称已经存在。'}}
	    ];
	
	//检验名称是否存在
  	function codeUniqueValidate(value) {
  		var flag = true;
  		if(!code && value){
  			dwr.TOPEngine.setAsync(false);
	  		StepGroupsFacade.loadStepGroupByCode(value,function(result){
				if(result){
					flag = false;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		return flag;
  	}
	
	//检验名称是否存在
  	function nameUniqueValidate(name) {
  		var flag = true;
  		var newCode = cui("#code").getValue();
  		if(newCode){
  			dwr.TOPEngine.setAsync(false);
	  		StepGroupsFacade.nameUniqueValidate(code,name,function(result){
				flag = result;
			});
			dwr.TOPEngine.setAsync(true);
		}
		return flag;
  	}

	//保存
	function save() {
		var map = window.validater.validAllElement();
		var inValid = map[0];
		var valid = map[1];
		var opt = "新增";
		if(code){
			opt="编辑";
		}
		//验证消息
		if (inValid.length > 0) {//验证失败
			var str = "";
			for (var i = 0; i < inValid.length; i++) {
				str += inValid[i].message + "<br />";
			}
		} else {
			data.code = cui("#code").getValue();
			data.name = cui("#name").getValue();
			data.icon = cui("#icon").getValue();
			window.parent.saveStepGroup(data,opt);
		}
	}
	var dialog;
	// 新增实体
	function showIconSelector() {
		var height = 360;
		var width = 530;
		var url ='IconsSelector.jsp';
		if(!dialog){
			dialog = cui.dialog({
			  	title : "图标选择",
			  	src : url,
			    width : width,
			    height : height,
			    top: 5
			});
		}
	 	dialog.show(url);
	}

	//关闭实体名称编辑窗口
	function closeWindow(){
		dialog.hide();
	}
	
	function updateIcon(icon){
		cui("#icon").setValue(icon);
		$(".icon-img").attr("class","icon-img "+icon);
	}
</script>
</html>