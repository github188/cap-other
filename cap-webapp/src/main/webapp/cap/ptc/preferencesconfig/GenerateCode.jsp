	
<%
  /**********************************************************************
	* CIP生成代码
	* 2014-8-6 沈康 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!doctype html>
<html>
<head>
<title>代码生成页面</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<!-- <link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css"> -->
	<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/GenerateCodeAction.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/cui.utils.js"></script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/PreferencesFacade.js'></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_title">代码生成路径</div>
	</div>
	<div id="editDiv"  class="top_content_wrap cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="30%" />
				<col width="70%" />
			</colgroup>
			<tr>
				<td class="td_label"><span class="top_required">*</span>代码路径：</td>
				<td style="white-space:nowrap;">
					<span uitype="ClickInput" id="filePath" name="filePath" width="300px" on_iconclick="selectPath" editable="true"></span>
					<span uitype="button" label="保存路径" on_click="savePath"></span>
					<!-- <span uitype="button" label="取消" ></span> -->
				</td>
			</tr>
			<tr>
				<td class="td_label"><span class="top_required">*</span>页面路径生成规则：</td>
				<td style="white-space:nowrap;">
					<span uitype="Input" id="pageCutPrefix" width="300px" editable="true" value="com.comtop."></span>
					<span uitype="button" label="保存" on_click="savePageCutPrefixConfig"></span>
					<!-- <span uitype="button" label="取消" ></span> -->
				</td>
			</tr>
		</table>
	</div>

<script type="text/javascript">
var GEN_CODE_PATH_CNAME = "GEN_CODE_PATH_CNAME";
var _=cui.utils;
var reg = new RegExp(/^[a-zA-Z]:\\[a-zA-Z_0-9\\]*/);

var pagePrefixConfig={};

function selectPath(){
	if(+[1,]) { 
		cui.alert("目前选择路径只能在IE浏览器下使用,其它浏览器请输入项目路径(例如：D:\\EAR)。");   
		return;
	}
	try {
		var strPath = new ActiveXObject("Shell.Application").BrowseForFolder(0, "请选择路径", 0, "").Items().Item().Path;
		cui("#filePath").setValue(strPath);
	}catch(e) {
		//cui.alert("选择路径需要将当前站点设置为信任站点。");
	}	
}
window.onload = function(){
	comtop.UI.scan();
	pagePrefixConfig = readPagePrefixConfig();
	cui("#filePath").setValue(_.getCookie(GEN_CODE_PATH_CNAME));
	cui("#pageCutPrefix").setValue(pagePrefixConfig.configValue);
}

function readPagePrefixConfig(){
	var result={};
	dwr.TOPEngine.setAsync(false);
	PreferencesFacade.getConfig('comtop.cap.bm.pagePrefixConfig',function(data) {
		if(data!=null){
			result=data;
		}
	});
	dwr.TOPEngine.setAsync(true);
	return result;
}

function savePageCutPrefixConfig(){
	var prefix = cui("#pageCutPrefix").getValue().trim();
	if(prefix ==''){
		cui.alert("页面路径生成规则,截取的前缀不能为空。");
		cui("#pageCutPrefix").setValue('com.comtop.')
		return;
	}
	if(!prefix.endsWith('.')){
		prefix = prefix+'.';
	}
	pagePrefixConfig.configValue=prefix;
	dwr.TOPEngine.setAsync(false);
	PreferencesFacade.saveConfig(pagePrefixConfig,function(data) {
	console.log(2);
		rs = data;
		if(rs){
			cui.message('页面保存成功！', 'success');
		}else{
			cui.error("页面保存失败！"); 
		}
	});
	dwr.TOPEngine.setAsync(true);
}

/**
 * 去掉路径中的文件夹或者文件名中前后空格
 * @param  path 
 * @return 去掉后的路径串
 */
function trimPath (path) {
	if(path) {
		var pathArray = path.split('\\');
		for (var i = 0; i < pathArray.length; i++) {
			pathArray[i] = Trim(pathArray[i]);
		};
		return pathArray.join('\\');
	}
}

/**
 * 去掉字符串前后空格
 * @param 字符串
 * @return 去掉前后空格后的字符串
 */
function Trim(str){ 
	return str.replace(/(^\s*)|(\s*$)/g, ""); 
}

function savePath(){
	var strPath = cui("#filePath").getValue();
	if(strPath == "") {
		cui.alert("请选择生成代码的路径。");
		return;
	}
	if(!reg.test(strPath)) {
		cui.alert("请输入合法的文件路径(例如：D:\\EAR)。");
		return;
	}
	strPath = trimPath(strPath);
	_.setCookie(GEN_CODE_PATH_CNAME,strPath, new Date(2100,10,10).toGMTString(), '/');
	cui("#filePath").setValue(strPath);
	cui.message('保存成功！', 'success');
}

function enSure() {
	var strPath = cui("#filePath").getValue();
	if(strPath == "") {
		cui.alert("请选择生成代码的路径。");
		return;
	}
	if(!reg.test(strPath)) {
		cui.alert("请输入合法的文件路径(例如：D:\\EAR)。");
		return;
	}
	
	createCustomHM();
	_.setCookie(GEN_CODE_PATH_CNAME,strPath, new Date(2100,10,10).toGMTString(), '/');
	//dwr.TOPEngine.setAsync(false);
	GenerateCodeAction.executeGenerateCode(strPath,"${param.packageId}",function(data){
		removeCustomHM();
		cui.alert("生成项目代码完成，点击<a href='javascript:;' onclick='openFileIIs();'>查看</a>");
     });
	//dwr.TOPEngine.setAsync(true);
}

function openFileIIs(filename){     
	filename = _.getCookie(GEN_CODE_PATH_CNAME);
    try{   
        var obj=new ActiveXObject("wscript.shell");   
        if(obj){   
            obj.Run("\""+filename+"\"", 1, false );  
            //obj.run("osk");/*打开屏幕键盘*/  
            //obj.Run('"'+filename+'"');   
            obj=null;   
        }   
    }catch(e){   
        alert("请确定是否存在该盘符或文件");   
    }   
      
}  
var objHandleMask;
//生成遮罩层
function createCustomHM(){
	objHandleMask = cui.handleMask({
        html:'<div style="padding:10px;border:1px solid #666;background: #fff;"><div class="handlemask_image_1"/><br/>正在生成实体，预计需要2~3分钟，请耐心等待。</div>'
    });
	objHandleMask.show()
}

//生成遮罩层
function removeCustomHM(){
	objHandleMask.hide()
}

</script>
</body>
</html>