<%
  /**********************************************************************
   * CAP自定义行为帮助-文档
   *
   * 2016-10-31 肖威 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<html >
<head>
<title>自定义行为脚本帮助</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/dev/consistency/js/consistency.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>

<top:link href="/cap/bm/common/shBrush/css/shCore.css"></top:link>
<top:link href="/cap/bm/common/shBrush/css/shThemeDefault.css"></top:link>

<top:script src='/cap/bm/common/shBrush/shCore.js'></top:script>
<top:script src='/cap/bm/common/shBrush/shBrushJScript.js'></top:script>
<script type="text/javascript">SyntaxHighlighter.all();</script>
<style type="text/css">
li{
	list-style-type: none;
}
img{

}
.scene{
 
}
.sceneSummary{
}
.sceneTitle{
}
.sceneDesc{
}
.sceneSolution{
}
.liDes{
}
.liImag{
	text-align: left;
	border: 1px;
}
.indent{
	
}
</style>

<script type="text/javascript">
	
	//展开下级节点
	function expanProperties(beginId){
		var tableTrNum = jQuery("#contentTable tr").length;
		for(var i=0; i<tableTrNum; i++){
			var objectTr = jQuery("#contentTable tr").eq(i);
			var trId = objectTr.attr("id");
			if(trId.length>beginId.length && trId.indexOf(beginId)==0){
				//objectTr.css("display","none");
				console.log("trId :" + trId);
				console.log("trId :" + beginId);
				console.log(trId.indexOf(beginId==0));
				objectTr.hide();
			}
		}
		//控制图标显示隐藏
		jQuery("#coll"+beginId).css("display","block");
		jQuery("#expan"+beginId).css("display","none");
	}
	
	//折叠下级节点
	function collapProperties(beginId){
		var tableTrNum = jQuery("#contentTable tr").length;
		for(var i=0; i<tableTrNum; i++){
			var objectTr = jQuery("#contentTable tr").eq(i);
			var trId = objectTr.attr("id");
			if(trId.length>beginId.length && trId.indexOf(beginId)==0  ){
				//objectTr.css("display","block");
				console.log("trId :" + trId);
				console.log("trId :" + beginId);
				console.log(trId.indexOf(beginId==0));
				objectTr.show();
			}
		}
		//控制图标显示隐藏
		jQuery("#coll"+beginId).css("display","none");
		jQuery("#expan"+beginId).css("display","block");
	}
</script>
</head>
<body>
<div>
	<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span>
			        	<blockquote class="cap-form-group">
							<span class="cap-label-title" size="12pt">自定义行为脚本编写编写说明</span>
						</blockquote>
					</span>
		        </td>
		    </tr>
	</table>
	<table class="form_table" style="table-layout:fixed;">
		<tr>
			<td class="td_content" >
				<ul class="sceneSolution">
					<li class="indent liDes">步骤1：编写自定行为注释信息，描述js函数的用途及参数等信息。引用自定义行为中已有属性时，需要用双大括号引入。
					<br/>&nbsp;&nbsp;&nbsp; 例如：“{{cname}}”表示当前行为中文名称。
					</li>
					<li class="indent liImag"><img alt="" src="images/scriptInfo1.png"> </li>
					<li class="indent liDes">步骤2：编写方法名称及固有方法体内容（固有方法内容，在使用时无法修改）。{{ename}}会引入当前自定义行为英文名称，函数体中js方法
					体（红色边框内容编写后），用户使用时无法修改。</li>
					<li class="indent liImag"><img alt="" src="images/scriptInfo2.png"> </li>
					<li class="indent liDes">步骤3：添加用户自定义js录入方法。需要用户自定义录入js时，可以在方法中输入&lt;script name="唯一标识"&gt;，表示此处可以输入js。</li>
					<li class="indent liImag"><img alt="" src="images/scriptInfo3.png"> </li>
					<li class="indent liDes">步骤4：引入自定义行为中属性。引入方式统一用{{methodOption.属性英文名称}}方式调用。</li>
					<li class="indent liImag"><img alt="" src="images/scriptInfo4.png"> </li>
				</ul>
			</td>
		</tr>
		<tr>
			<td class="td_content" >
				<span class="cap-label-title" size="12pt">行为已有参数列表</span>
				<div id="tableContent" class="grid-container" style="width:100%;">
					<table class="grid-head-table" width="100%">
						<tr>
								<th width="20%">属性名称</td>
								<th width="20%">属性注释</td>
								<th width="60%">示例</td>
						</tr>
					</table>
					<table id="contentTable" class="grid-body-table" width="100%" >
						<tr>
							<td width="20%">
								cname
							</td>
							<td width="20%">行为中文名称</td>
							<td width="60%">获取当前行为的中文名称，默认显示为当前行为中文名称，在设计器中如修改后会自动获取设计器中定义的中文名称。示例代码如下：
								<pre class="brush: javascript">
								/*
								 * {{cname}} {{description}}
								 */
								function {{ename}}() { </pre>
							</td>		
						</tr>
						<tr>
							<td>
								ename
							</td>
							<td>行为英文名称</td>
							<td>获取当前行为的英文名称，默认显示为当前行为英文名称，在设计器中如修改后会自动获取设计器中定义的英文名称。示例代码如下：
								<pre class="brush: javascript">
								/*
								 * {{cname}} {{description}}
								 */
								function {{ename}}() {</pre>
							</td>		
						</tr>
						<tr>
							<td>
								description
							</td>
							<td>行为描述</td>
							<td>获取当前行为的行为描述，默认显示为当前行为行为描述，在设计器中如修改后会自动获取设计器中定义的行为描述。示例代码如下：
								<pre class="brush: javascript">
								/*
								 * {{cname}} {{description}}
								 */
								function {{ename}}() { </pre>
							</td>		
						</tr>
						<tr>
							<td>
								\${methodParameter}
							</td>
							<td>获取当前行为中设置调用后台方法的参数集合</td>
							<td>
								可以参考组件最佳实践行为中grid初始化查询行为，示例代码如下：
								<pre class="brush: javascript">
									var queryVarName = '\${methodParameter}';
									var query = {};
									if(queryVarName !== ''){
										query=cap.getQueryObject(window[queryVarName],pageQuery);
									}</pre>
							</td>		
						</tr>
						<tr >
							<td>
								aliasEntityId
							</td> 
							<td>获取当前页面中实体id</td>
							<td>
								可以参考组件最佳实践行为中grid初始化查询行为，示例代码如下：
								<pre class="brush: jscript">
								//获取查询条件
							 	var paramArray = [];
							 	paramArray[0] = query;
							 	var aliasEntityId = '{{methodOption.aliasEntityId}}';
								aliasEntityId = aliasEntityId != '' ? aliasEntityId :  '{{methodOption.entityId}}';
							 	var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'{{methodOption.actionMethodName}}',paramArray);</pre>
							</td>		
						</tr>
						<tr>
							<td>
								returnValueBind
							</td> 
							<td>获取当前行为中设置的返回值</td>
							<td>
									可以参考组件最佳实践行为中grid初始化查询行为，示例代码如下：
									<pre class="brush: jscript">
									//调用后台查询
									dwr.TOPEngine.setAsync(false);
									${modelName}Action.dwrInvoke(dwrInvokeParam,{callback:function(result){
										var returnValueVarName= '{{methodOption.returnValueBind}}';
										if(returnValueVarName === ''){
											returnValueVarName = 'returnValueVarName';
										}
									  },
								  	errorHandler:function(message, exception){
									   //TODO 后台异常信息回调
									}
								  	});
								  	dwr.TOPEngine.setAsync(true);</pre>
							</td>		
						</tr>
						<tr>
							<td>
								entityId
							</td> 
							<td>当前页面设置实体ID</td>
							<td>
									可以参考组件最佳实践行为中grid初始化查询行为，示例代码如下：
									<pre class="brush: jscript">
									//获取查询条件
								 	var paramArray = [];
								 	paramArray[0] = query;
								 	var aliasEntityId = '{{methodOption.aliasEntityId}}';
									aliasEntityId = aliasEntityId != '' ? aliasEntityId :  '{{methodOption.entityId}}';
								 	var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'{{methodOption.actionMethodName}}',paramArray);</pre>
							</td>		
						</tr>
						
						<!--  
						<tr>
							<td>
								modelId
							</td>
							<td>级别1</td>
							<td>行为唯一ID。组成方式为modelPackage+“.”+modelName</td>		
						</tr>
						<tr>
							<td>
								modelName
							</td>
							<td>级别1</td>
							<td>行为英文名称</td>		
						</tr>
						<tr>
							<td>
								modelPackage
							</td>
							<td>级别1</td>
							<td>行为存放包路径</td>		
						</tr>
						<tr>
							<td>
								modelType
							</td>
							<td>级别1</td>
							<td>行为类型</td>		
						</tr>
						<tr>
							<td>
								cname
							</td>
							<td>级别1</td>
							<td>行为中文名称</td>		
						</tr>
						<tr>
							<td>
								type
							</td>
							<td>级别1</td>
							<td>说明</td>		
						</tr>
						<tr>
							<td>
								description
							</td>
							<td>级别1</td>
							<td>行为描述</td>		
						</tr>
						<tr>
							<td>
								propertyEditor
							</td>
							<td>级别1</td>
							<td>属性编辑；默认值为auto</td>		
						</tr>
						<tr>
							<td>
								propertyEditorPage
							</td>
							<td>级别1</td>
							<td>属性编辑页面</td>		
						</tr>
						<tr>
							<td>
								js
							</td>
							<td>级别1</td>
							<td>行为依赖js文件集合</td>		
						</tr>
						<tr>
							<td>
								list
							</td>
							<td>级别2</td>
							<td>行为依赖js文件</td>		
						</tr>
						<tr>
							<td>
								css
							</td>
							<td>级别1</td>
							<td>行为依赖CSS文件集合</td>		
						</tr>
						<tr>
							<td>
								list
							</td>
							<td>级别2</td>
							<td>行为依赖CSS文件</td>		
						</tr>
						<tr>
							<td>
								script
							</td>
							<td>级别1</td>
							<td>行为JavaScript脚本</td>		
						</tr>
						
						<tr>
							<td>
							properties
							</td>
							<td>级别1</td>
							<td>行为属性集合</td>		
						</tr>
						<tr>
							<td>
								property
							</td>
							<td>级别2</td>
							<td>行为属性</td>		
						</tr>
						<tr>
							<td>
								cname
							</td>
							<td>级别3</td>
							<td>行为属性中文名称</td>		
						</tr>
						<tr>
							<td>
								ename
							</td>
							<td>级别3</td>
							<td>行为属性英文名称</td>		
						</tr>
						<tr>
							<td>
								type
							</td>
							<td>级别3</td>
							<td>行为属性数据类型</td>		
						</tr>
						<tr>
							<td>
								required
							</td>
							<td>级别3</td>
							<td>行为属性是否必填</td>		
						</tr>
						<tr>
							<td>
								default
							</td>
							<td>级别3</td>
							<td>行为属性默认值</td>		
						</tr>
						<tr>
							<td>
								description
							</td>
							<td>级别3</td>
							<td>行为属性描述</td>		
						</tr>
						<tr>
							<td>
							propertyEdittorUI
							</td>
							<td>级别3</td>
							<td>行为属性编辑控件</td>		
						</tr>
						<tr>
							<td>
								componentName
							</td>
							<td>级别4</td>
							<td>行为属性编辑控件名称</td>		
						</tr>
						<tr>
							<td>
								script
							</td>
							<td>级别4</td>
							<td>行为属性对应JSON结构</td>		
						</tr>
						<tr>
							<td>
							consistencyConfig
							</td>
							<td>级别3</td>
							<td>行为对应校验配置</td>		
						</tr>
						<tr>
							<td>
								checkConsistency
							</td>
							<td>级别4</td>
							<td>校验是否执行</td>		
						</tr>
						<tr>
							<td>
								checkClass
							</td>
							<td>级别4</td>
							<td>校验功能对应java类</td>		
						</tr>
						<tr>
							<td>
							consistencyConfig
							</td>
							<td>级别1</td>
							<td>行为对应校验配置</td>		
						</tr>
						<tr>
							<td>
								checkConsistency
							</td>
							<td>级别2</td>
							<td>校验是否执行</td>		
						</tr>
						<tr>
							<td>
								checkClass
							</td>
							<td>级别2</td>
							<td>校验功能对应java类</td>		
						</tr>
						-->
					</table>
				</div>
			</td>
		</tr>
	</table>
</div>

</body>
</html>