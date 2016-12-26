<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<div>
	<table style="width:100%;height:100%">
		<tr>
			<td style="vertical-align:middle;text-align:center">
				<img alt="" src="./image/empty.gif"  ng-show="selectedEntity == null || selectedEntity == undefined" >
				<div style="margin:50px 0px;font-size:24px;opacity:0.6;font-family: 华文行楷;" ng-show="selectedEntity == null || selectedEntity == undefined">还没导入任何实体，赶快导入吧！</div>
			</td>
		</tr>
	</table>
</div>