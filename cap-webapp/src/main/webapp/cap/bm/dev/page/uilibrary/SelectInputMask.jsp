<%
    /**********************************************************************
			 * input组件mask属性选择组件
			 * 2015-07-10 龚斌  
			 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>MASK属性</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/common/base/css/base.css"></top:link>
<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css" />
<top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>
<top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
<top:link href="/cap/bm/common/codemirror/addon/hint/show-hint.css"></top:link>
<top:link href="/cap/bm/common/codemirror/addon/display/fullscreen.css"></top:link>
<style type="text/css"></style>
<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>
<top:script src="/cap/bm/common/codemirror/mode/javascript/javascript.js"></top:script>
<top:script src="/cap/bm/common/codemirror/addon/hint/show-hint.js"></top:script>
<top:script src="/cap/bm/common/codemirror/addon/hint/javascript-hint.js"></top:script>
<top:script src="/cap/bm/common/codemirror/addon/display/fullscreen.js"></top:script>
<top:script src="/cap/bm/common/base/js/jsformat.js"></top:script>
<top:script src='/cap/dwr/engine.js'></top:script>
<top:script src='/cap/dwr/util.js'></top:script>
<top:script src="/cap/dwr/interface/ComponentFacade.js"></top:script>
</head>
<body class="body_layout">
	<div class="cap-page">
		<div class="cap-area">
			<table class="cap-table-fullWidth">
				<tr>
					<td class="cap-td" style="text-align: left;">
					</td>
					<td class="cap-td" style="text-align: right;">
						<span uitype="button" on_click="saveData" label=" 确 定 "></span> 
						<span uitype="button" on_click="cleanData" label=" 清 空 "></span> 
						<span uitype="button" on_click="closeWin" label=" 关 闭  "></span>
					</td>
				</tr>
				<tr height="20px">
				</tr>
				<tr>
					<td class="cap-td" style="text-align: right;;width: 40%">
						<span id="maskTitle" uitype="Label" class="cap-label-title" value="Mask属性："></span>
					</td>
					<td class="cap-td" style="text-align: left;">
						<span id="maskType" uitype="PullDown" mode="Single" value_field="id" label_field="text"
							datasource="maskDS" on_change ="selectMask_callBack"></span>
					</td>
				</tr>
				<tr height="10px">
				</tr>
			</table>
		</div>
		<div class="cap-area">
			<table class="cap-table-fullWidth">
				<tr>
					<td class="cap-td" style="text-align: right;width: 40%">
						<span id="maskOptionTitle" uitype="Label" class="cap-label-title"
						value="MaskOption属性："></span>
					</td>
					<td class="cap-td" style="text-align: left;">
					</td>
				</tr>
			</table>
		</div>
		<div id="customDiv" class="cap-area">
			<table class="cap-table-fullWidth">
				<tr height="10px">
				<tr>
					<td class="cap-td" style="text-align: right;width: 40%">
						<span id="maskTitle" uitype="Label" value="model属性："></span> 
					</td>
					<td class="cap-td" style="text-align: left;">
						<span id="model" uitype="input"></span>
					</td>
				</tr>
				<tr>
					<td class="cap-td" style="text-align: right;width: 40%"">
						<span id="placeholderTitle" uitype="Label" value="placeholder属性："></span>
					</td>
					<td class="cap-td" style="text-align: left;">
						<span id="placeholder" uitype="input"></span>
					</td>
				</tr>
				<tr height="20px">
			</table>
		</div>
		<div id="numDiv" class="cap-area">
			<table class="cap-table-fullWidth">
				<tr height="10px">
				<tr>
					<td class="cap-td" style="text-align: right;width: 40%"">
						<span id="precisionTitle" uitype="Label" value="precision属性："></span> 
						
					</td>
					<td class="cap-td" style="text-align: left;">
						<span id="precision" uitype="input"></span>
					</td>
				</tr>
				<tr>
					<td class="cap-td" style="text-align: right;width: 40%"">
						<span id="prefixTitle" uitype="Label" value="prefix属性："></span>
						
					</td>
					<td class="cap-td" style="text-align: left;">
						<span id="prefix" uitype="input"></span>
					</td>
				</tr>
				<tr>
					<td class="cap-td" style="text-align: right;width: 40%"">
						<span id="separatorTitle" uitype="Label" value="separator属性："></span>
						
					</td>
					<td class="cap-td" style="text-align: left;">
						<span id="separator" uitype="input"></span>
					</td>
				</tr>
				<tr height="20px">
			</table>
		</div>
	</div>

	<script type="text/javascript">
		//var propertyName = "<c:out value='${param.propertyName}'/>";
		var maskValue = "<c:out value='${param.mask}'/>";
		var maskOptValue = unescape('<%=request.getParameter("maskoptions")%>');
		//var maskOptValue = window.opener.getValue("maskoptions");
		var callbackMethod = "<c:out value='${param.callbackMethod}'/>";

		var maskDS = [{
			id : 'custom',
			text : '自定义'
		}, {
			id : 'Datetimes',
			text : '日期时间（包括秒）'
		}, {
			id : 'Times',
			text : '时间（包括秒）'
		}, {
			id : 'Time',
			text : '时间（不包括秒）'
		}, {
			id : 'Datetime',
			text : '日期时间（不包括秒）'
		}, {
			id : 'Date',
			text : '日期'
		}, {
			id : 'Int',
			text : '整数'
		}, {
			id : 'Dec',
			text : '小数'
		}, {
			id : 'Num',
			text : '数字'
		}, {
			id : 'Money',
			text : '货币格式'
		}];

		//
		function selectMask_callBack(reCord){
		    refreshMaskOptionPanel();
		    setDefaultValue(cui("#maskType").getValue(),true);
		}
		 
		//保存
		function saveData() {
			var maskValue = cui("#maskType").getValue();
			var maskOpt = "";
			if(maskValue=="Int"||maskValue=="Dec"||maskValue=="Num"||maskValue=="Money"){
				var prefixValue = cui("#prefix").getValue();
				var separatorValue = cui("#separator").getValue();
				maskOpt = {'prefix': prefixValue, 'separator': separatorValue};
				if(maskValue=="Dec"||maskValue=="Money"){
					var precisionValue = cui("#precision").getValue();
					maskOpt.precision = $.isNumeric(precisionValue) ? parseInt(precisionValue) : (precisionValue === 'null' || maskValue=="Dec" ? null : 2);
				}
			}else{
				if(maskValue=="custom"){
					var modelValue = cui("#model").getValue();
					var placeholderValue = cui("#placeholder").getValue();
					maskOpt = {'model': modelValue, 'placeholder': placeholderValue}
					var validData = cui().validate().validOneElement("model");
					if(!validData.valid){
						cui.alert(validData.message);
						return;
					}
				}
			}
			if(maskOpt != ""){
				maskOpt =  JSON.stringify(maskOpt);
			}
			//设置值
			window.opener[callbackMethod]('mask', maskValue);
			window.opener[callbackMethod]('maskoptions', maskOpt);
		    window.close();
		}
		
		//关闭
		function cleanData() {
			window.opener[callbackMethod]('mask', '');
			window.opener[callbackMethod]('maskoptions', '');
			window.close();
		}
		
		//关闭
		function closeWin() {
			window.close();
		}

		jQuery(document).ready(
				function() {
					comtop.UI.scan();
					
					for(var i=0;i<maskDS.length;i++){
						var mask = maskDS[i];
						if(mask.id==maskValue){
							//设置mask下拉框
							cui("#maskType").setValue(maskValue);
							setDefaultValue(maskValue,false);
							//var maskOpt = JSON.parse(maskOptValue);
							//设置maskoption属性
							//if(maskValue=="Int"||maskValue=="Dec"||maskValue=="Num"||maskValue=="Money"){
							//	cui("#precision").setValue(maskOpt.precision);
							//	cui("#prefix").setValue(maskOpt.prefix);
							//	cui("#separator").setValue(maskOpt.separator);
							//}else if(maskValue=="custom"){
							//	cui("#model").setValue(maskOpt.model);
							//	cui("#placeholder").setValue(maskOpt.placeholder);
							//}
							break;
						}
					}
					
					refreshMaskOptionPanel();
				});
		
		//刷新MaskOption属性设置,控制面板的显示与隐藏
		function refreshMaskOptionPanel() {
			var maskValue = cui("#maskType").getValue();
			if(maskValue=="Int"||maskValue=="Dec"||maskValue=="Num"||maskValue=="Money"){
				if(maskValue=="Dec" || maskValue=="Money"){
					$("#precision").parent().parent().css({display: ''});
					cui("#precision").setReadonly(false);
				} else {
					$("#precision").parent().parent().css({display: 'none'});
					cui("#precision").setReadonly(true);
				}
				document.getElementById("customDiv").style.display = "none";//隐藏
				document.getElementById("numDiv").style.display = "";//显示
			}else{
				document.getElementById("numDiv").style.display = "none";//隐藏
				document.getElementById("customDiv").style.display = "";//显示
				if(maskValue=="custom"){
					cui("#model").setReadonly(false);
					cui("#placeholder").setReadonly(false);
					cui().validate().disValid("model", false);
					cui().validate().add('model', 'required', {m:'model属性不能为空.'});
				}else{
					cui("#model").setReadonly(true);
					cui("#placeholder").setReadonly(true);
					cui().validate().disValid("model", true);
				}
			}
		}
		
		//根据mask属性值，设置maskoption属性
		function setDefaultValue(value,defaultFlag) {
			var maskValue = value;
			if(defaultFlag){ //设置maskoption默认值
				//设置maskoption属性
				if(maskValue=="Int"){
					cui("#prefix").setValue('');
					cui("#separator").setValue(',');
				}else if(maskValue=="Num"){
					cui("#prefix").setValue('');
					cui("#separator").setValue('');
				}else if(maskValue=="Dec"){
					cui("#precision").setValue('null');
					cui("#prefix").setValue('');
					cui("#separator").setValue(',');
				}else if(maskValue=="Money"){
					cui("#precision").setValue('2');
					cui("#prefix").setValue('');
					cui("#separator").setValue(',');
				}else{ 
					cui("#model").setValue('');
					cui("#placeholder").setValue('');
				}
			}else{ //根据传入的maskoption值，设置maskoption属性
				//设置maskoption属性
				var maskOpt = JSON.parse(maskOptValue);
				if(maskValue=="Int"||maskValue=="Dec"||maskValue=="Num"||maskValue=="Money"){
					if(maskValue=="Dec" || maskValue=="Money"){
						cui("#precision").setValue($.isNumeric(maskOpt.precision) ? parseInt(maskOpt.precision) : (maskOpt.precision === null || maskValue=="Dec" ? 'null' : '2'));
					}
					cui("#prefix").setValue(maskOpt.prefix);
					cui("#separator").setValue(maskOpt.separator);
				}else if(maskValue=="custom"){
					cui("#model").setValue(maskOpt.model);
					cui("#placeholder").setValue(maskOpt.placeholder);
				}
			}
		}
	</script>
</body>
</html>

