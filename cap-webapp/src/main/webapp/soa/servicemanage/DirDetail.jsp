<%
  /**********************************************************************
	* 子应用详情
	* 2014-2-19  袁巧林 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!DOCTYPE html>
<html>
<head>
	<title>子应用详情页面</title>
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
		<span uitype="button" id="new_sub" label="新增下级应用"  on_click="insertSubAppliation"></span>
		<span uitype="button" id="save" label="保存"  on_click="save" ></span>
		<span uitype="button" id="delete" label="删除"  on_click="deleteDir" ></span>
		</div>
	</div>
	<div class="cui_ext_textmode" style="padding-top: 15px;width: 100%">
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="15%" />
				<col width="85%" />
			</colgroup>
			<tr>
				<td class="td_label">上级名称：</td>
				<td>
				<span uitype="input" name="parentName" id="parentName" databind="data.parentNodeName" width="290px" readonly="true"></span>
				</td>
			</tr>
	        <tr>
	            <td class="td_label"> 应用名称：</td>
	            <td>
	               <span uitype="input" id="dirName" name="dirName" databind="data.dirName" maxlength="40" width="290px"
	                validate="validateModuleName">
	                </span>
	            </td>
	        	
	        </tr>
	        <tr>
	        	<td class="td_label">应用编码：</td>
				<td>
					<span uitype="input" id="dirCode" name="dirCode" databind="data.dirCode" maxlength="40" width="290px"
	               validate="validateModuleCode" readonly="true"></span>
				</td>
	        </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
		var dirCode = "${param.dirCode}";
		var dirName = "${param.dirName}";
		var parentNodeName = "${param.parentNodeName}";
		var parentNodeID = "${param.parentNodeID}";
		var parentModuleType = "${param.parentModuleType}";
		
        var data = {dirCode:dirCode, dirName:dirName, parentNodeName:parentNodeName};

        /**
         * 保存服务目录
         */
        function save(){
            var editDirName = cui('#dirName').getValue();
        	var url = '<cui:webRoot/>/soa/SoaServlet/editDir?operType=editDir&dirCode='+dirCode+'&dirName='+editDirName+'&timeStamp='+ new Date().getTime();
            //采用ajax请求提交
            $.ajax({
                 type: "GET",
                 url: url,
                 success: function(data,status){
            		 //window.parent.initData(window.parent.cui('#moduleTree'));
            		 window.parent.editRefreshTree(dirCode);
            		 cui.message('保存成功。', 'success');
                  },
                 error: function (msg) {
        		         cui.message('保存失败。', 'error');
                      }
             });
        };

        /**
         * 查询父节点的信息
         */
        function queryDir(parentNodeID){
        	var url;
            if (parentModuleType == 1){
            	url = '<cui:webRoot/>/soa/SoaServlet/queryBussSystem?operType=queryBussSystem&bussSystemCode='+parentNodeID+'&timeStamp='+ new Date().getTime();
            }else{
            	url = '<cui:webRoot/>/soa/SoaServlet/queryDirVO?operType=queryDirVO&dirCode='+parentNodeID+'&timeStamp='+ new Date().getTime();
            }

            //采用ajax请求提交
            $.ajax({
                 type: "GET",
                 url: url,
                 success: function(data,status){
            	    var objData = jQuery.parseJSON(data);
            	    if (parentModuleType == 1){
            	    	cui('#dirCode').setValue(objData.code,true);
            	    	cui('#dirName').setValue(objData.name,true);
            	    	cui('#parentNodeName').setValue('基础系统',true);
            	    }else{
            	    	cui('#dirCode').setValue(objData.dirCode,true);
            	    	cui('#dirName').setValue(objData.dirName,true);
            	    	cui('#parentNodeName').setValue('',true);
            	    } 
                  },
                 error: function (msg) {
        		         cui.message('保存失败。', 'error');
                      }
             });
        };

        /**
         * 删除服务目录
         */
        function deleteDir(){
        	var url = '<cui:webRoot/>/soa/SoaServlet/deleteDir?operType=deleteDir&dirCode='+dirCode+'&timeStamp='+ new Date().getTime();
            //采用ajax请求提交
            $.ajax({
                 type: "GET",
                 url: url,
                 success: function(data,status){
            			//刷新Tree并展示父节点
    	        		window.parent.editRefreshTree(parentNodeID);
    	        		queryDir(parentNodeID);
            			cui.message('删除成功。', 'success');
                  },
                 error: function (msg) {
                	  cui.message('删除失败。', 'error');
                      }
             });
        }

        //新增下级应用
    	function insertSubAppliation(){
    		window.parent.cui('#body').setContentURL("center","<cui:webRoot/>/soa/servicemanage/DirEdit.jsp?parentNodeID="+dirCode+"&parentNodeName="+dirName); 
    	};

		window.onload = function(){
		    //扫描
		    comtop.UI.scan();
		}
	</script>
</body>
</html>