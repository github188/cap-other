<!doctype html>
<%
  /**********************************************************************
	* 功能项编辑
	* 2015-12-2 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
<title>界面原型编辑</title>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
		<top:script src="/cap/bm/common/base/js/cap_ui_attachment.js" />
		<top:script src="/cap/bm/common/cui/js/comtop.ui.editor.min.js"/>
		<top:script src="/cap/bm/common/cui/js/uedit/dialogs/capattachment/capattachment.js"/>
		<top:script src="/cap/bm/common/cui/js/uedit/dialogs/image/image.js"/>
		<style>
		.top_header_wrap{
			margin-right:5px;
			margin-top: 4px;
			margin-bottom:4px;
		}
		</style>
</head>
<body>
	<div class="top_header_wrap">
		<div class="thw_operate">
			<span uitype="button" id="btnSave" label="保 存" on_click="save"></span> 
			<span uitype="button" id="btnReturn" label="关 闭" on_click="close"></span>
		</div>
	</div>
	<div class="top_content_wrap">
		<table class="form_table" style="table-layout: fixed;">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<td class="td_label"><span class="top_required">*</span>界面文件名：</td>
				<td><span uitype="input" id="modelName" databind="prototypeVO.modelName" maxlength="80" width="100%" validate="pageModelNameValRule"></span></td>
				<td class="td_label"><span class="top_required">*</span>界面标题：</td>
				<td><span uitype="input" id="cname" databind="prototypeVO.cname" maxlength="80" width="100%" validate="vNull"></span></td>
			</tr>
			<tr>
				<td class="td_label"><span class="top_required">*</span>原型图片上传：</td>
				<td colspan="3"><span uitype="Capattachment" id="imgId" uploadKey="REQ_PROTOTYPE_IMAGE" fileName="imageName" accept="image/png,image/gif,image/jpg,image/jpeg,image/ico,image/bmp" databind="prototypeVO.imgId"></span>
					<!-- <span uitype="Button" label="预览" on_click="previewImg"></span>
					<span id="cancelImgBtn" uitype="Button" label="取消预览" on_click="cancelImg" hide="true"></span> -->
				</td>
			</tr>
			<tr>
				<td class="td_label">界面说明：</td>
				<td colspan="3"><span uitype="Textarea" id="remark" databind="prototypeVO.description" maxlength="500" width="100%"></span></td>
			</tr>
			<tr style="color:#39c;">
				<td class="td_label" >温馨提示：</td>
				<td colspan="3">上传的图片，只允许为jpg、png、jpeg、gif、ico、bmp格式。</td>
			</tr>
		</table>
	</div>
	<top:script src="/cap/dwr/interface/PrototypeFacade.js" />
<script language="javascript"> 	
	var modelPackage = "<c:out value='${param.modelPackage}'/>";
	var modelId = "<c:out value='${param.modelId}'/>";
	//com.comtop.prototype.DM-0000000007.E-IM01-004.E-IM01-004-001
	var uploadId = /^(com[.]comtop[.]prototype[.])(.+)$/.exec(modelPackage)[2].replace(/\./g,"/");
	var prototypeVO={imgId:uploadId};
	var vNull = [{'type':'custom','rule':{'against':'isBlank', 'm':'界面标题不能为空'}}];
	var pageModelNameValRule = [{type:'required',rule:{m:'界面文件名不能为空'}},{type:'format', rule:{pattern:'\^[A-Z]\\w+\$', m:'界面文件名只能输入由字母、数字或者下划线组成的字符串,且首字符必须为大写字母'}}];
	//界面初始化动态读取,一定要是array
	var imageName = [];
	window.onload = function(){
		if(modelId){
			init();
			//初始化imageName数组
			if(prototypeVO.imageURL && (regResult = /^(REQ_PROTOTYPE_IMAGE)\b.{1}(.+[/\\])(.+[.][a-zA-Z]+)$/.exec(prototypeVO.imageURL)) !=null ){
				//REQ_PROTOTYPE_IMAGE/DM-0000000007/E-IM01-004/E-IM01-004-001/ReceiptEditPage2.png
				imageName.push(regResult[3]);
			}
		}
		comtop.UI.scan();
	}
	
	//关闭窗口
	function close(){
		parent.dialogClose();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
	}
	
	//
	function init(){
		//根据modelId初始化界面原型模型对象
		dwr.TOPEngine.setAsync(false);
		PrototypeFacade.loadModel(modelId, null, function(data){
			prototypeVO = data;
			prototypeVO.imgId = uploadId;
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//保存界面原型
	function save() {
		var map = window.validater.validAllElement();
		var inValid = map[0];
		var valid = map[1];
		//验证消息
		if(inValid.length > 0) { //验证失败
			var str = "";
			for(var i=0; i<inValid.length; i++) {
				str += inValid[i].message + "<br/>";
			}
			return;
		}
		if(imageName.length <= 0){
			cui.alert('请上传界面原型图片。');
			return;
		}
		
		var checkPicTypeResult = checkPicType();
		if(!checkPicTypeResult){
			cui.alert('上传的文件格式错误');
			return;
		}
		
		var result = beforPrototypeSave(prototypeVO);
		if(!result){
			cui.error("保存失败。");
			return;
		}
		
		dwr.TOPEngine.setAsync(false);
		PrototypeFacade.saveModel(prototypeVO,{callback:function(data){
			parent.cui.message("保存成功", "success");
			parent.refleshGrid();
			close();
		},errorHandler:function(){
			cui.error("保存失败。");
		}});
		dwr.TOPEngine.setAsync(true);
	}
	 
     /**
      * 校验图片类型是否通过
      * @return true，通过；false，不通过
      */
     function checkPicType(){
    	 var typeObj = {
    			 jpg:"jpg",
    			 png:"png",
    			 jpeg:"jpeg",
    			 gif:"gif",
    			 ico:"ico",
    			 bmp:"bmp"
    	 }
    	 var regExp = /.+[.](\w+)/;
    	 for(var i = 0, len = imageName.length; i < len; i++){
    		 var matcher = regExp.exec(imageName[i]);
    		 if(null == matcher){
    			 return false;
    		 }
    		 if(typeObj[matcher[1].toLowerCase()] == undefined){
    			 return false; 
    		 }
    	 }
    	 return true;
     }
     
	/**
	 * 在界面原型保存之前，对界面原型对象部分属性进行必要的设置
	 *
	 * @param vo界面原型vo
	 */
	function beforPrototypeSave(vo){
		var flag = true;
		vo.cname = $.trim(vo.cname);
		vo.modelName = $.trim(vo.modelName);
		vo.modelPackage = modelPackage;
		vo.modelType = "prototype";
		if(!vo.modelId){
			vo.modelId = modelPackage + "." + vo.modelType + "." + vo.modelName;
		}
		vo.type = 1;
		vo.imageURL = "REQ_PROTOTYPE_IMAGE/" + /^(com\.comtop\.prototype\.)(.+)/.exec(modelPackage)[2].replace(/\./g, "/") + "/" + imageName[0]; //com.comtop.prototype.DM-0000000007.E-IM01-004.E-IM01-004-001
		if(vo.sortNo == undefined){
			dwr.TOPEngine.setAsync(false);
			PrototypeFacade.getLastSortNo(modelPackage,{callback:function(data){
				vo.sortNo = data;
			},errorHandler:function(){
				flag = false;
			}});
			dwr.TOPEngine.setAsync(true);
		}
		return flag;
	}
	
	//是否为空
	function isBlank(data){
		if(data.replace(/\s/g, "")==""){
			return false;
		}
		return true;
	}
</script>
</body>
</html>