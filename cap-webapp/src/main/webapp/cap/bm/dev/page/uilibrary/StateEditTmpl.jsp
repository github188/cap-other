<%
/**********************************************************************
* 控件状态模板
* 2015-08-20 凌晨  新建 
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!-- 控件状态模板-->
<script id="stateEditTmpl" type="text/template">
	<table class="form_table" style="width:100%;" >
		<tr ng-repeat="_state in stateArray track by $index" style="border-bottom:#DBDBDB solid 1px;" >
			<td id="overWidth" name ="overWidth" title="{{_state.expression.expression}}" style="text-overflow:ellipsis; /* for IE */-moz-text-overflow: ellipsis; /* for Firefox,mozilla */overflow:hidden; white-space: nowrap;border:0px;text-align:left;width:45%">
				{{_state.expression.expression}}
			</tb>
			<td style="text-align: center;width:20%"><a class="cui-icon" ng-style="_state.expression.hasSetState?{cursor:'pointer'}:{color:'#666'}" ng-click="changeState(_state)">{{(_state.expression.hasSetState==false?'加载':(_state.component.state=='edit'?'编辑':(_state.component.state=='hide'?'隐藏':'只读')))}}</a></td>
			<td style="text-align: center;width:25%"><a class="cui-icon" style="cursor:pointer;" ng-click="changeValidate(_state)">{{(_state.expression.hasSetState==false?'':(_state.component.hasValidate==true?'校验':'不校验'))}}</a></td>
			<td style="text-align: center;width:10%"><a class="cui-icon" style="cursor:pointer;" ng-click="delState4UI(_state)">&#xf00d;</a></td>
		</tr>
	</table>
</script>