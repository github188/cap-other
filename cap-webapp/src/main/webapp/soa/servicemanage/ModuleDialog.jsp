<%
  /**********************************************************************
	* ϵͳ��ģ�����
	* 2014-2-19  Ԭ���� �½�
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!DOCTYPE html>
<html>
<head>
	<title>ҵ��ϵͳ��Ӧ�ù���</title>
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
	     * ����soa����ҳ
	     */
	    function returnIndex(){
	    	window.location.href="<cui:webRoot/>/soa/index.jsp";
	    }
	    //��ʼ������Ŀ¼�����ṹ
	    function initData(obj) {
	      var url = '<cui:webRoot/>/soa/SoaServlet/loadBussSystemAndDir?operType=loadBussSystemAndDir&timeStamp='+ new Date().getTime();
	      //����ajax�����ύ
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
	                   cui.message('����Ŀ¼ʧ�ܡ�', 'error');
	                }
	       });
	    }


	    //�������¼�
	    function treeClick(node){
	        var data = node.getData("data");
	        var sysCode = node.getData("key");

	        var moduleType = data.moduleType;    
	        var sysName = data.name;
	        
	        var parentNodeName="";
	        var parentNodeID = -1;
	        //���ڵ������,������ɾ���ӽڵ��չʾ���ڵ㣨չʾҵ��ϵͳ�ͷ���Ŀ¼��������
	        var parentModuleType="";
	        if (moduleType != 0){
	        	parentNodeName = node.parent().getData("data").name;
		        parentNodeID = node.parent().getData("key");
		        parentModuleType = node.parent().getData("data").moduleType;
	        }
	        
	        var url;
	        if(moduleType==1 || moduleType==0){
	            //ҵ��ϵͳ���ͣ��༭ҵ��ϵͳ
	            url = '<cui:webRoot/>/soa/servicemanage/ModuleDetail.jsp?parentNodeName='+parentNodeName+'&parentNodeID='+parentNodeID+'&sysCode='+sysCode+'&sysName='+sysName+'&moduleType='+moduleType;
	        } else {
	            //Ӧ��ģ�����ͣ��༭Ӧ��ģ��
	            url = '<cui:webRoot/>/soa/servicemanage/DirDetail.jsp?dirCode='+sysCode+'&dirName='+sysName+'&parentNodeName='+parentNodeName+'&parentNodeID='+parentNodeID+'&parentModuleType='+parentModuleType;
	        }
	        //�����Ӧ��ģ�飬��˴�������ת��Ӧ��ģ��༭ҳ��
	        cui('#body').setContentURL("center",url);
	    }

	    // �༭���ڵ���ˢ���¼� 
    	function editRefreshTree(dirCode){
        	    //����ˢ��tree
    		    initData(cui("#moduleTree"));
    		    var treeObject = cui("#moduleTree");
    			var selectNode = treeObject.getNode(dirCode);
    			if(selectNode && selectNode.dNode) {
        			//չ��ѡ�еĽڵ�
    				selectNode.activate();
    			}
    		}
		
		window.onload = function(){
		    //ɨ��
		    comtop.UI.scan();
		}
	</script>
</body>
</html>