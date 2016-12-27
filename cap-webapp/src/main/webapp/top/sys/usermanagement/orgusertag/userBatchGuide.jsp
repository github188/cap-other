<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ page isELIgnored="false" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>��������</title>
    <top:link href="/top/component/topui/cui/themes/default/css/comtop.ui.min.css"/>
    <top:link href="/top/sys/usermanagement/orgusertag/css/userBatchGuide.css"/>
    <top:script src="/top/component/topui/cui/js/comtop.ui.min.js"/>
    <top:script src="/top/js/jquery.js"/>
</head>
<body>
    <div class="box" >
        <div class="main_top">
            <div><img src="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/images/download.gif" class="left_img" />  </div>
            <div class="center_word">����ģ��</div>
            <div class="right_div" >
               <span class="download_span" >������δ����ģ�壬��������ģ�塣</span>
               <div class="download_button"><span uitype="Button" label="����ģ��" mark="1" on_click="downloadTemplate"></span></div>
            </div>
        </div>
        <div  class="main_top">
            <div><img src="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/images/import.gif" class="left_img" />  </div>
            <div class="center_word">�����û�</div>
            <div class="import" >
                <div  class="description">������ģ���б༭�����ݣ��뵼�����ݡ�</div>
                <div>
                	<form id="userImportForm" target="uploadIframe" action="${pageScope.cuiWebRoot}/top/sys/batchImportUser/getImportUsersValid.ac" enctype="multipart/form-data" method="post">
	                	<input type="hidden" name="rootDepartmentId" value="<c:out value='${param.rootDepartmentId}'/>"/>
	                	<input type="hidden" name="userType" value="<c:out value='${param.userType}'/>"/>
	                	<input type="hidden" name="orgStructureId" value="<c:out value='${param.orgStructureId}'/>"/>
     					<input type="file" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" name="file" id="file" class="upload-input" hidefocus="true" contenteditable="false" />
	                	<span uitype="Input" id="fileText" name="" validate="[{'type':'required', 'rule':{'m': '����ѡ���ļ�'}}]" width="215px" readonly="true" emptytext="���������ťѡ�����ļ�"></span>
	                	<span id="browseButton" uitype="button" label="���" mark="2" on_click="selectFile"></span>
	                	<span id="importButton" uitype="button" label="����" mark="3" on_click="importUser"></span>
                	</form>
                </div>
            </div>
        </div>
    </div>
    <iframe id="uploadIframe" name="uploadIframe" frameborder="0"></iframe>

<script type="text/javascript">
	/**
	 * ���ڴ���DIV
	 */
	var processingDiv = null;

	//CUI���ɨ��
	comtop.UI.scan();

	$(function () {
		revertWindow();//��ԭ����

		//���ļ���ֵ�����ı�ʱ ���������ļ��ı�������
		$("#file").change(function () {
			var fileName = $("#file").val();
	        cui("#fileText").setValue(fileName.substring(fileName.lastIndexOf('\\') + 1));
	    });
    });

	/**
	 * ��ԭ���� ˢ�»����¼���ҳ��
	 */
	function revertWindow(){
		var height = getImportWindowHeight();
		parent.bacthImportDialog.setSize({height:height});
		var ifra = document.getElementById('uploadIframe');
    	ifra.style.display = 'none';
	}

	/**
	 * ��������ť �����ļ�ѡ������¼� ��ʼѡ���ļ�
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
	 * ������밴ť���������¼�
	 */
	function importUser(){
		var map = window.validater.validOneElement(cui("#fileText"));
		if(!map.valid){
			return;
		}
		processingDiv = cui.handleMask({
            html:'<div style="padding:10px;border:1px solid #666;background: #fff;">���ڴ�����,���Ժ�...</div>'
        });
        processingDiv.show();

    	userImportForm.submit();
	}

	/**
	 * ���ص���ģ��
	 */
	function downloadTemplate(){
		var url = "${pageScope.cuiWebRoot}/top/sys/batchImportUser/downloadUserImportTemplate.ac";
	    window.open(url,'_self');
	}

	/**
	 * ��ʾ���������������ҳ�������ɺ�����ҳ����ã�
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
	 * ��ȡ���봰�ڵĸ߶�
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