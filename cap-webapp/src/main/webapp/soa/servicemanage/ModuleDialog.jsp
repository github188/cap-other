<%
  /**********************************************************************
	* 系统及模块管理
	* 2014-2-19  袁巧林 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!DOCTYPE html>
<html>
<head>
	<title>业务系统及应用管理</title>
	<cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
    <style type="text/css">
		img{
		  margin-left:5px;
		}
	</style>
</head>
<body>
<div uitype="Borderlayout"  id="body"  is_root="true"> 
		<div id="leftMain" position="left" width="200" show_expand_icon="true">       
         <table width="95%" style="margin-left: 10px">
				<tr id="tr_moduleTree">
					<td>
                     <div id="moduleTree" uitype="Tree" children="initData" on_lazy_read="loadNode"  on_click="treeClick" click_folder_mode="1"></div>
                    </td>
				</tr>
			</table>
         </div>
		<cui:bpanel  position="center" id="centerMain" height="500" collapsable="false"></cui:bpanel>
</div>
<script type="text/javascript">
	    var dirCode = "${param.dirCode}";
	    var dirName = "${param.dirName}";
	    /**
	     * 返回soa导航页
	     */
	    function returnIndex(){
	    	window.location.href="<cui:webRoot/>/soa/index.jsp";
	    }
	    //初始化服务目录的树结构
	    function initData(obj) {
	      var url = '<cui:webRoot/>/soa/SoaServlet/loadBussSystemAndDir?operType=loadBussSystemAndDir&timeStamp='+ new Date().getTime();
	      //采用ajax请求提交
	      $.ajax({
	           type: "GET",
	           url: url,
	           async: false,
	           success: function(data,status){
	               treeData = jQuery.parseJSON(data);
	               if(!checkStrEmty(treeData)){
	                      treeData.expand = true;
	                      obj.setDatasource(treeData);
	                  }else{
	                      obj.setDatasource([]);
	                      cui("#body").setContentURL("center",""); 
	                  }
	            },
	           error: function (msg) {
	                   cui.message('加载目录失败。', 'error');
	                }
	       });
	    }


	    //树单击事件
	    function treeClick(node){
	        var data = node.getData("data");
	        var sysCode = node.getData("key");

	        var moduleType = data.moduleType;    
	        var sysName = data.name;
	        
	        var parentNodeName="";
	        var parentNodeID = -1;
	        //父节点的类型,作用是删除子节点后展示父节点（展示业务系统和服务目录的条件）
	        var parentModuleType="";
	        if (moduleType != 0){
	        	parentNodeName = node.parent().getData("data").name;
		        parentNodeID = node.parent().getData("key");
		        parentModuleType = node.parent().getData("data").moduleType;
	        }
	        
	        var url;
	        if(moduleType==1 || moduleType==0){
	            //业务系统类型，编辑业务系统
	            url = '<cui:webRoot/>/soa/servicemanage/ModuleDetail.jsp?parentNodeName='+parentNodeName+'&parentNodeID='+parentNodeID+'&sysCode='+sysCode+'&sysName='+sysName+'&moduleType='+moduleType;
	        } else {
	            //应用模块类型，编辑应用模块
	            url = '<cui:webRoot/>/soa/servicemanage/DirDetail.jsp?dirCode='+sysCode+'&dirName='+sysName+'&parentNodeName='+parentNodeName+'&parentNodeID='+parentNodeID+'&parentModuleType='+parentModuleType;
	        }
	        //如果是应用模块，则此处快速跳转到应用模块编辑页面
	        cui('#body').setContentURL("center",url);
	    }

	    // 编辑树节点后的刷新事件 
    	function editRefreshTree(dirCode){
        	    //重新刷新tree
    		    initData(cui("#moduleTree"));
    		    var treeObject = cui("#moduleTree");
    			var selectNode = treeObject.getNode(dirCode);
    			if(selectNode && selectNode.dNode) {
        			//展开选中的节点
    				selectNode.activate();
    			}
    		}
		
		window.onload = function(){
		    //扫描
		    comtop.UI.scan();
		}
	</script>
</body>
</html>