<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>首选项配置</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>
<top:script src="/cap/dwr/engine.js"></top:script>
<top:script src="/cap/dwr/util.js"></top:script>
<script>
		//动态计算iframe高度
		var reinitIframeNum = 0;
		
		function reinitIframe() {
		    var bHeight,
		        $iframe = $("#configContent");
		
		    try {
		        // bHeight = $iframe.contents().find("body").height();
		        bHeight = document.documentElement.clientHeight || document.body.clientHeight;
		        if(bHeight<300){
		        	$iframe.height(580);
				}else{
					$iframe.height(bHeight);
				}
		    } catch (ex) {
		        if (reinitIframeNum < 5) {
		            setTimeout(reinitIframe, 75);
		            reinitIframeNum += 1;
		        } else {
		            reinitIframeNum = 0;
		        }
		    }
		}

		$(window).resize(function() {
			reinitIframe();
		});
</script>

</head>
<body  class="body_layout">
	<table class="cap-table-fullWidth">
		<tr style="margin: 0px;width: 100%;height: 100%">
			<td style="text-align: left;height: 700px;vertical-align: top;">
				<div id="tree" class="left-area" uitype="Tree" children="treeData" on_click="show" style="height: 600px; width:220px"></div>
			</td>
			<td style="text-align: center;border-left:1px solid #ddd;vertical-align:middle">
			</td>
			<td style="text-align: left;width:100%;height: 100%;vertical-align: top;">
				<div  class="left-area" style="width: 100%;height: 100%;border-style: 0px;margin: 0px;">
					<iframe id="configContent" width="100%" frameborder="0" border="0" marginwidth="0" marginheight="0"  onload="reinitIframe()"></iframe>
				</div>
			</td>
		</tr>
	</table>
	<script type="text/javascript">
	var treeData = [{
        title: "首选项配置",
        key: "root",
        expand: true,
        isFolder: true,
        children: [
				   {title: "常规配置",
						    key: "generalConfig",
						    expand: false,
						    isFolder: false},
                   {
            		 title: "页面配置",
            	        key: "pageConfig",
            	        expand: true,
            	        isFolder: true,
            	        children:[
            	            {
            	            	title:"默认引入文件",
	            	        	key:"includeFile",
	            	        	expand:false,
	            	        	isFolder:false,
	            	        	select:true,
	            	        	children:[]}
            	            ,{
            	            	title:"控件引用文件变更配置",
	            	        	key:"componentDependFilesConfig",
	            	        	expand:false,
	            	        	isFolder:false,
	            	        	select:true,
	            	        	children:[]}
            	            ,{
            	        		title:"全局参数",
                	        	key:"environmentVariable",
                	        	expand:false,
                	        	isFolder:false,
                	        	children:[]
            	        }]},
            	/**        
            	{title: "父实体配置",
           	        key: "entityConfig",
           	        expand: false,
           	        isFolder: false,
           	        children:[]
           		},{title: "生成代码路径",
              	        key: "codePath",
              	        expand: false,
              	        isFolder: false,
              	        children:[]
              	},
              	**/
              	{title: "代码模板配置",
              	        key: "codeTemplateConfig",
              	        expand: false,
              	        isFolder: true,
              	        children:[
									{title: "元数据模板分类",
									      key: "templateClass",
									      expand: false,
									      isFolder: false,
									      children:[]
									},{title: "页面模板渲染行为",
									      key: "templateAction",
									      expand: false,
									      isFolder: false,
									      children:[]
									}
              	                  ]
              	},
      	        /**
      	        {title: "CRP系统配置",
          	        key: "crpSystemConfig",
          	        expand: false,
          	        isFolder: false},
          	    {title: "soa注册服务配置",
              	    key: "soaServiceRegister",
              	    expand: false,
              	    isFolder: false},
              	  **/ 
                {title: "自定义行为模板",
					    key: "customAction",
					    expand: false,
					    isFolder: false},
              	{title: "自定义控件",
  				    key: "customComponent",
  				    expand: false,
  				    isFolder: false},  					    
              	{title: "文档模板配置",
          	        key: "docTemplateConfig",
          	        expand: false,
          	        isFolder: false},
          	    {title: "测试建模配置",
              	        key: "testModelConfig",
              	        expand: true,
              	        isFolder: true,
              	        children:[
									{title: "测试服务器配置",
									      key: "testServiceConfig",
									      expand: false,
									      isFolder: false,
									      children:[]
									},{title: "测试步骤分组配置",
									      key: "StepGroupConfig",
									      expand: false,
									      isFolder: false,
									      children:[]
									},{title: "基本测试步骤管理",
									      key: "baseTestStep",
									      expand: false,
									      isFolder: false,
									      children:[]
									},{title: "测试字典管理",
									      key: "testDictionary",
									      expand: false,
									      isFolder: false,
									      children:[]
									}
              	                  ]
              	},
              	{title: "Ftp服务器配置",
          	        key: "ftpInfoConfig",
          	        expand: false,
          	        isFolder: false
          	    }
 	      ]
    }];
	
	/**
	 * 点击树节点触发事件
	 * @param node 节点
	 * @param event 事件对象
	 */
 	function show(node, event){
		var configValue = node.getData("key");
		if("includeFile"==configValue){
			jQuery("#configContent").attr("src","IncludeFileList.jsp");
		}
		if("ftpInfoConfig" == configValue){
			jQuery("#configContent").attr("src","FtpInfoConfig.jsp");
		}
		if("componentDependFilesConfig"==configValue){
			jQuery("#configContent").attr("src","EditComponentDependFilesConfig.jsp");
		}
		if("environmentVariable"==configValue){
			jQuery("#configContent").attr("src","EnvironmentVariableList.jsp");
		}
		if("entityConfig"==configValue){
			jQuery("#configContent").attr("src","ParentEntityEdit.jsp");
		}
		if("codePath"==configValue){
			jQuery("#configContent").attr("src","GenerateCode.jsp");
		}
		if("templateClass"==configValue){
			jQuery("#configContent").attr("src","${pageScope.cuiWebRoot}/cap/bm/dev/page/template/MetadataTmpTypeMain.jsp");
		}
		if("templateAction"==configValue){
			jQuery("#configContent").attr("src","PageTemplateActionList.jsp");
		}
		
		if("docTemplateConfig"==configValue){
			jQuery("#configContent").attr("src","${pageScope.cuiWebRoot}/cap/bm/doc/tmpl/DocTemplateList.jsp");
		}
		if("crpSystemConfig"==configValue){
			jQuery("#configContent").attr("src","crpSystemConfig.jsp");
		}
		if("soaServiceRegister"==configValue){
			jQuery("#configContent").attr("src","${pageScope.cuiWebRoot}/cap/ptc/preferencesconfig/SoaServiceConfig.jsp");
		}
		if("generalConfig"==configValue){
			jQuery("#configContent").attr("src","GeneralConfig.jsp");
		}
		if("testServiceConfig"==configValue){//测试服务器配置
			jQuery("#configContent").attr("src","${pageScope.cuiWebRoot}/cap/bm/test/preference/TestServiceConfig.jsp");
		}
		if("StepGroupConfig"==configValue){//测试步骤分组配置
			jQuery("#configContent").attr("src","${pageScope.cuiWebRoot}/cap/bm/test/preference/StepGroupConfig.jsp");
		}
		if("baseTestStep"==configValue){//基本测试步骤管理
			jQuery("#configContent").attr("src","${pageScope.cuiWebRoot}/cap/bm/test/preference/BaseTestStepManager.jsp");
		}
		if("testDictionary"==configValue){//测试字典管理
			jQuery("#configContent").attr("src","${pageScope.cuiWebRoot}/cap/bm/test/preference/TestDictionary.jsp");
		}
		if("customAction"==configValue){//自定义行为模板
			jQuery("#configContent").attr("src","action/CustomActionList.jsp");
		}
		if("customComponent"==configValue){//自定义控件
			jQuery("#configContent").attr("src","component/CustomComponentList.jsp");
		}
		
 	}
	
	//页面装载方法
	jQuery(document).ready(function(){
		comtop.UI.scan();
		cui("#tree").selectNode("generalConfig",true);
		var sourceNode = cui("#tree").getNode("generalConfig");
    	if(sourceNode) {
    		sourceNode.activate();
    	}
		jQuery("#configContent").attr("src","GeneralConfig.jsp");
	});
	
</script>
</body>
</html>