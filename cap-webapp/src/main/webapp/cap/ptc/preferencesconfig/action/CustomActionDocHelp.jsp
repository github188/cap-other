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
							<span class="cap-label-title" size="12pt">自定义行为操作说明</span>
						</blockquote>
					</span>
		        </td>
		    </tr>
	</table>
	<table class="form_table" style="table-layout:fixed;">
		<tr>
			<td class="td_content" >
				<ul class="sceneSolution">
					<li class="indent liDes">自定行为基础信息分包名称填写后，在界面设计器中行为编辑时选择行为页面可以看到自定义行为的分组信息。如图：</li>
					<li class="indent liImag"><img alt="" src="images/actionStep1.png"> </li>
					<li class="indent liDes">自定行为基础信息中英文名称、中文名称、描述及脚本信息，在界面设计器行为页面中选择行为后默认设置为当前行为的英文名称、中文名称、描述，脚本则生成在脚本编辑栏中。如图：</li>
					<li class="indent liImag"><img alt="" src="images/actionStep2.png"> </li>
					<li class="indent liDes">自定义行为中属性信息将会在界面设计器中行为页面显示，同时提供编辑。如图：</li>
					<li class="indent liImag"><img alt="" src="images/actionStep3.png"> </li>
					<li class="indent liDes">行为中引入指定的JS文件或CSS文件，在生成页面时会自动引入。自定义行为中js、css列表编辑方式，如图：</li>
					<li class="indent liImag"><img alt="" src="images/actionStep4.png"> </li>
					<li class="indent liImag"><img alt="" src="images/actionStep41.png"> </li>
				</ul>
			</td>
		</tr>
	</table>
</div>

</body>
</html>