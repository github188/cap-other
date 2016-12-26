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
<title>自定义行为帮助</title>
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
							<span class="cap-label-title" size="12pt">自定义控件操作说明</span>
						</blockquote>
					</span>
		        </td>
		    </tr>
	</table>
	<table class="form_table" style="table-layout:fixed;">
		<tr>
			<td class="td_content" >
				<ul class="sceneSolution">
					<li class="indent liDes">自定义控件基础信息编辑后在设计器中可以看到对应控件信息。如图：</li>
					<li class="indent liImag"><img alt="" src="images/customComponentDocInfo1.png" width="1000" > </li>
					<li class="indent liDes">自定义控件属性说明
						<ul>
							<li style="list-style: disc;">控件默认有<font color="red" style="font-weight: bold;">labelType、width、height</font>三个属性。labelType赋值方式为Html标签名称。</li>
							<li style="list-style: disc;">属性名称规则：属性名称不可以使用<font color="red" style="font-weight: bold;">uitype</font>；</li>
							<li style="list-style: disc;">必填项选择是后会默认增加验证，如需要编辑验证规则，可以再UI控件中进行设置。</li>
							<li style="list-style: disc;">对应UI控件默认设置为输入框，可以设置为其他输入控件。</li>
							<li style="list-style: disc;">描述信息填写后在帮助中会生成对应的说明。</li>
						</ul>
						自定义控件属性信息编辑后在设计器中可以看到对应控件属性信息。如图：
					</li>
					<li class="indent liImag"><img alt="" src="images/customComponentDocInfo2.png"> </li>
					<li class="indent liDes">自定义控件行为默认值设置说明
						<ul>
							<li style="list-style: disc;">默认值填写时，在界面设计器中使用控件会自动生成的对应的行为。</li>
							<li style="list-style: disc;">默认值未填时，在界面设计器中使用控件不会自动生成对应的行为，在添加行为模板时会默认选择当前指定的行为模板</li>
						</ul>
						自定义控件行为信息编辑后在设计器中可以看到对应控件行为信息。如图：
					</li>
					<li class="indent liImag"><img alt="" src="images/customComponentDocInfo3.png"> </li>
					<li>
						<span>自定义控件信息编写完成后必须要给自定义控件增加渲染JS，来实现在页面中对控件进行渲染（<font color="red" style="font-weight: bold;">除默认属性labelType、weight、height三个属性外其他属性都需要在js中进行渲染</font>）。渲染函数命名规则：<font color="red" style="font-weight: bold;">cap.beforeLoad+自定义控件名称</font>，
						渲染函数示例如下：</span>
						<pre class="brush: javascript" >
						/**
						* 自定义控件初始化函数
						* id 当前控件ID
						* component 当前控件对象
						**/
						cap.beforeLoadCustomButton = function(id,component){
						    var btn = jQuery('#'+id);
						    btn.addClass('button '+component.class);
						    btn.click(component.onclick);
						}
						</pre> 
					</li>
				</ul>
			</td>
		</tr>
	</table>
</div>

</body>
</html>