<%
  /**********************************************************************
	* CAP功能模块----需求模板明细编辑
	* 2015-9-24 姜子豪  新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
	<head>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
		<top:script src="/cap/bm/common/cui/js/comtop.ui.editor.min.js"/>
		<top:script src="/cap/dwr/interface/TemplateInfoAction.js" />
	</head>
	
	<style>
	.top{ 
			width:100%; 
			height:100px; 
			
		}
	</style>
	<body>
		<div align="right">
			<span id="saveBtn" uitype="button" label="保存" on_click="save"></span> 
			<span id="closeBtn" uitype="button" label="关闭" on_click=closeBtn ></span>
		</div>
		<div class="top">
			<font size="5">需求模板明细：</font>
		</div>
		<table class="form_table" style="table-layout:fixed;">
			<tr>
				<td class="td_label" width="15%"><span style="padding-left: 10px;">名称<span class="top_required">*</span>：</span></td>
        		<td><span uitype="Input" id="templateName" maxlength="100" align="left" validate="validateForTemplateName" width="85%" databind="TemplateInfo.templateName"></span></td>
    		</tr>
    		<tr>
    			<td class="td_label" width="15%"><span style="padding-left: 10px;">描述：</span></td>
        		<td><span uitype="Textarea" relation="relation5" id="descInfo" maxlength="500" align="left" databind="TemplateInfo.descInfo" width="85%" height="150px"></span></td>
    		</tr>
    		<tr>
    		<td></td>
    		<td><span>您还能输入<label id="relation5" style="color: red;"></label>个字符</span></td>
    		</tr>
    		<tr>
    			<td class="td_label" width="15%"><span style="padding-left: 10px;">内容：</span></td>
    			<td><div id="templateContent" uitype="Editor" word_count="false" toolbars="toolbars" width="905"></div></td>
    		</tr>
		</table>
		<script type="text/javascript">
		var templateTypeId="${param.templateTypeId}";
		var TemplateInfoId="${param.TemplateInfoId}";
		var TemplateInfo={};
		var validateForTemplateName=[{
		        type: 'required',
		        rule: {
		            m: '名称不能为空'
		        }
		
		    },{'type':'custom','rule':{'against':isBlank, 'm':'名称不能为空'}}];
		//edit组件工具栏
		toolbars=[[
		           'undo', //撤销
		           'redo', //重做
		           'bold', //加粗
		           'indent', //首行缩进
		           'italic', //斜体
		           'underline', //下划线
		           'strikethrough', //删除线
		           'time', //时间
		           'date', //日期
		           'inserttable', //插入表格
		           'insertrow', //前插入行
		           'insertcol', //前插入列
		           'mergeright', //右合并单元格
		           'mergedown', //下合并单元格
		           'deleterow', //删除行
		           'deletecol', //删除列
		           'splittorows', //拆分成行
		           'splittocols', //拆分成列
		           'splittocells', //完全拆分单元格
		           'deletecaption', //删除表格标题
		           'inserttitle', //插入标题
		           'mergecells', //合并多个单元格
		           'deletetable', //删除表格
		           'insertparagraphbeforetable', //"表格前插入行"
		           'fontfamily', //字体
		           'fontsize', //字号
		           'paragraph', //段落格式
		           'edittable', //表格属性
		           'edittd', //单元格属性
		           'link', //超链接
		           'spechars', //特殊字符
		           'justifyleft', //居左对齐
		           'justifyright', //居右对齐
		           'justifycenter', //居中对齐
		           'justifyjustify', //两端对齐
		           'forecolor', //字体颜色
		           'rowspacingtop', //段前距
		           'rowspacingbottom', //段后距
		           'pagebreak', //分页
		           'imagecenter', //居中
		           ]]
		
		//初始化 
		window.onload = function(){
			comtop.UI.scan();
			beforeInt();
	   	}
		
		//保存事件
		function save(){
			var str = "";
    		if(window.validater){
    			window.validater.notValidReadOnly = true;
    			var map = window.validater.validAllElement();
    			var inValid = map[0];
    			var valid = map[1];
    			//验证消息
    			if(inValid.length > 0) { 
    				//验证失败
    				for(var i=0; i<inValid.length; i++) {
    					str += inValid[i].message + "<br/>";
    				}
    			}
    			if(str != ""){
    				return false;
    			}
    		}
			TemplateInfo.templateName= cui("#templateName").getValue();
			TemplateInfo.descInfo= cui("#descInfo").getValue();
			TemplateInfo.templateContent=cui("#templateContent").getHtml();
			TemplateInfo.templateTypeId=templateTypeId;
			dwr.TOPEngine.setAsync(false);
			TemplateInfoAction.saveTemplateInfo(TemplateInfo,function(data){
				if(data){
					if(TemplateInfo.id && TemplateInfo.id != "") {
						window.opener.cui('#templateInfo').loadData();
						closeBtn();
						window.opener.cui.message('修改成功','success');
		 			} else {
		 				window.opener.cui('#templateInfo').loadData();
		 				TemplateInfo.id = data;
		 				closeBtn();
		 	 			window.opener.cui.message('新增成功','success');
		 			}
					window.opener.fresh(TemplateInfo.id);
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		//关闭窗口 
		function closeBtn(){
			window.close();
		}
		
		//界面加载前回显操作 
		function beforeInt(){
			if(TemplateInfoId!= ""){
				dwr.TOPEngine.setAsync(false);
		    	TemplateInfoAction.queryTemplateInfoById(TemplateInfoId,function(data){
		    		TemplateInfo=data;
		    		TemplateInfo.id=data.id;
				});
				dwr.TOPEngine.setAsync(true);
				cui("#templateName").setValue(TemplateInfo.templateName);
				cui("#descInfo").setValue(TemplateInfo.descInfo);
				if(TemplateInfo.templateContent){
					cui("#templateContent").setHtml(TemplateInfo.templateContent);
				}
			}
			
		}
		
		//空格过滤
		function isBlank(data){
			if(data.replace("&nbsp", " ")==" "){
				return false;
			}
			return true;
		}
		</script>
	</body>
</html>