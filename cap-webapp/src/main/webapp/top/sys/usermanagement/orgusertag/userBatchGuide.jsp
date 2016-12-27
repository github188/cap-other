<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ page isELIgnored="false" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>批量导入</title>
    <top:link href="/top/component/topui/cui/themes/default/css/comtop.ui.min.css"/>
    <top:link href="/top/sys/usermanagement/orgusertag/css/userBatchGuide.css"/>
    <top:script src="/top/component/topui/cui/js/comtop.ui.min.js"/>
    <top:script src="/top/js/jquery.js"/>
</head>
<body>
    <div class="box" >
        <div class="main_top">
            <div><img src="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/images/download.gif" class="left_img" />  </div>
            <div class="center_word">下载模板</div>
            <div class="right_div" >
               <span class="download_span" >若您尚未下载模板，请点击下载模板。</span>
               <div class="download_button"><span uitype="Button" label="下载模板" mark="1" on_click="downloadTemplate"></span></div>
            </div>
        </div>
        <div  class="main_top">
            <div><img src="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/images/import.gif" class="left_img" />  </div>
            <div class="center_word">导入用户</div>
            <div class="import" >
                <div  class="description">您已在模板中编辑好数据，请导入数据。</div>
                <div>
                	<form id="userImportForm" target="uploadIframe" action="${pageScope.cuiWebRoot}/top/sys/batchImportUser/getImportUsersValid.ac" enctype="multipart/form-data" method="post">
	                	<input type="hidden" name="rootDepartmentId" value="<c:out value='${param.rootDepartmentId}'/>"/>
	                	<input type="hidden" name="userType" value="<c:out value='${param.userType}'/>"/>
	                	<input type="hidden" name="orgStructureId" value="<c:out value='${param.orgStructureId}'/>"/>
     					<input type="file" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" name="file" id="file" class="upload-input" hidefocus="true" contenteditable="false" />
	                	<span uitype="Input" id="fileText" name="" validate="[{'type':'required', 'rule':{'m': '请先选择文件'}}]" width="215px" readonly="true" emptytext="请点击浏览按钮选择导入文件"></span>
	                	<span id="browseButton" uitype="button" label="浏览" mark="2" on_click="selectFile"></span>
	                	<span id="importButton" uitype="button" label="导入" mark="3" on_click="importUser"></span>
                	</form>
                </div>
            </div>
        </div>
    </div>
    <iframe id="uploadIframe" name="uploadIframe" frameborder="0"></iframe>

<script type="text/javascript">
	/**
	 * 正在处理DIV
	 */
	var processingDiv = null;

	//CUI组件扫描
	comtop.UI.scan();

	$(function () {
		revertWindow();//还原窗口

		//当文件框值发生改变时 重新设置文件文本框内容
		$("#file").change(function () {
			var fileName = $("#file").val();
	        cui("#fileText").setValue(fileName.substring(fileName.lastIndexOf('\\') + 1));
	    });
    });

	/**
	 * 还原窗口 刷新或重新加载页面
	 */
	function revertWindow(){
		var height = getImportWindowHeight();
		parent.bacthImportDialog.setSize({height:height});
		var ifra = document.getElementById('uploadIframe');
    	ifra.style.display = 'none';
	}

	/**
	 * 点击浏览按钮 触发文件选择框点击事件 开始选择文件
	 */
	function selectFile(){
        if(!$.browser.msie){
        	$("#file").click();
        }else{
			var $BrowserVersion = $.browser.version;
        	if($BrowserVersion == "10.0" || $BrowserVersion == "9.0"){
        		$("#file").click();
        	}
        }
	}

	/**
	 * 点击导入按钮触发导入事件
	 */
	function importUser(){
		var map = window.validater.validOneElement(cui("#fileText"));
		if(!map.valid){
			return;
		}
		processingDiv = cui.handleMask({
            html:'<div style="padding:10px;border:1px solid #666;background: #fff;">正在处理中,请稍候...</div>'
        });
        processingDiv.show();

    	userImportForm.submit();
	}

	/**
	 * 下载导入模板
	 */
	function downloadTemplate(){
		var url = "${pageScope.cuiWebRoot}/top/sys/batchImportUser/downloadUserImportTemplate.ac";
	    window.open(url,'_self');
	}

	/**
	 * 显示导入结果（待结果子页面加载完成后，由子页面调用）
	 */
	this.showResult = function(failCount, isError){
		if(processingDiv != null){
			processingDiv.hide();
		}

		var height;
		if(isError){
		    height = getImportWindowHeight(1);
		}else if(failCount <= 0){
		    height = getImportWindowHeight(2);
		}else{
			height = getImportWindowHeight(3);
		}
		parent.bacthImportDialog.setSize({height:height});
		var ifra = document.getElementById('uploadIframe');
    	ifra.style.display = 'block';
	}

	/**
	 * 获取导入窗口的高度
	 */
	function getImportWindowHeight(type){
		var height = 194;
		if($.browser.msie){
			var $BrowserVersion = $.browser.version;
        	if($BrowserVersion === "10.0" || $BrowserVersion === "9.0"){
        		height += 8;
        	}
		}else{
			height += 8;
		}
		if(type == 1){
		    return height + 37;
		}else if(type == 2){
			return height + 67;
		}else if(type == 3){
			return height + 197;
		}else {
			return height;
		}
	}

</script>
</body>
</html>