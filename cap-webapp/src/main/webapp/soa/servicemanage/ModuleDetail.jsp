<%
  /**********************************************************************
	* 编辑业务系统
	* 2014-2-19  袁巧林 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!DOCTYPE html>
<html>
<head>
	<title>业务系统详情页面</title>
	<cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
<style>
	.top_header_wrap{
		padding-right:8px;
	}
</style>
<body>
<div uitype="Borderlayout"  id="body" is_root="true" style="width: 50%">	
	<div class="top_header_wrap" style="padding-top:5px;width: 56%">
		<div class="thw_title">
			<font id = "pageTittle" class="fontTitle"></font> 
		</div>
		<div class="thw_operate">
		<span uitype="button" id="new_sub" label="" on_click="insertSubSys"></span>
		<span uitype="button" id="save" label="保存"  on_click="save" ></span>
		<span uitype="button" id="delete" label="删除"  on_click="deleteBussSystem" ></span>
		</div>
	</div>
	<div class="cui_ext_textmode" style="padding-top:15px;width: 100%">
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="15%" />
				<col width="85%" />
			</colgroup>
			<tr style = "display:none">
				<td>
					<span id="moduleTypeGroup" uitype="RadioGroup" name="moduleType" databind="data.moduleType"
			      readonly="true"></span>
				</td>
			</tr>
			<tr>
				<td class="td_label">上级名称：</td>
				<td>
				<span uitype="input" name="parentNodeName" id="parentNodeName" databind="data.parentNodeName" width="290px" readonly="true"></span>
				</td>
			</tr>
	        <tr>
	            <td class="td_label"> 系统名称：</td>
	            <td>
	               <span uitype="input" id="sysName" name="sysName" databind="data.sysName" maxlength="36" width="290px"
	                validate="validateModuleName">
	                </span>
	            </td>
	        	
	        </tr>
	        <tr>
	        	<td class="td_label"> 系统编码：</td>
				<td>
					<span uitype="input" id="sysCode" name="sysCode" databind="data.sysCode" maxlength="28" width="290px"
	               validate="validateModuleCode" readonly="true"></span>
				</td>
	        </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
        var sysCode = "${param.sysCode}";
		var sysName = "${param.sysName}";
		var parentNodeName = "${param.parentNodeName}";
		var type = "${param.moduleType}";

		var data = {sysCode:sysCode, sysName:sysName, parentNodeName:parentNodeName};

        /**
         * 保存业务系统名称
         */
        function save(){
            var editSysName = cui('#sysName').getValue();
        	var url = '<cui:webRoot/>/soa/SoaServlet/editSysName?operType=editSysName&sysName='+editSysName+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
            //采用ajax请求提交
            $.ajax({
                 type: "GET",
                 url: url,
                 success: function(data,status){
            			window.parent.initData(window.parent.cui('#moduleTree'));
            			cui.message('保存成功。', 'success');
                  },
                 error: function (msg) {
        		         cui.message('保存失败。', 'error');
                      }
             });
        }

        /**
         * 删除业务系统
         */
        function deleteBussSystem(){
        	var url = '<cui:webRoot/>/soa/SoaServlet/deleteBussSystem?operType=deleteBussSystem&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
            //采用ajax请求提交
            $.ajax({
                 type: "GET",
                 url: url,
                 success: function(data,status){
            			//刷新Tree并展示父节点
            	        window.parent.editRefreshTree('root');
            	        //展示节点信息
            	        window.location.href='<cui:webRoot/>/soa/servicemanage/ModuleDetail.jsp?&sysCode=root&sysName=基础系统&moduleType=0';
            			cui.message('删除成功。', 'success');
                  },
                 error: function (msg) {
                	  cui.message('删除失败。', 'error');
                      }
             });
        }

        /**
         * 切换展示button名称（新增下级系统和新增下级应用）
         */
    	function insertSubSys(){
    		if (type == 0){
    			//新增下级系统
    			window.parent.cui('#body').setContentURL("center","<cui:webRoot/>/soa/servicemanage/ModuleEdit.jsp?parentNodeName="+sysName);
		    }else{
		    	//新增下级应用
		    	window.parent.cui('#body').setContentURL("center","<cui:webRoot/>/soa/servicemanage/DirEdit.jsp?parentNodeID="+sysCode+"&parentNodeName="+sysName+"&moduleType=1");
		    }
    		 
    	}

		window.onload = function(){
		    //扫描
		    comtop.UI.scan();
		    if (type == 0){
		    	cui('#new_sub').setLabel("新增下级系统");
		    }else{
		    	cui('#new_sub').setLabel("新增下级应用");
		    }

		    //根节点不允许删除和修改
		    if (sysCode=='root'){
		    	cui('#save').disable(true);
		    	cui('#delete').disable(true);
		    	cui('#sysName').setReadonly(true);
		    }
			    
		}
	</script>
</body>
</html>