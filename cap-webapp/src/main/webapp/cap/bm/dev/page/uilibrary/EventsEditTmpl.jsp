<%
/**********************************************************************
* 控件事件模版
* 2015-5-13 诸焕辉
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!-- 控件事件模版 -->
<script id="eventEditTmpl" type="text/template">
<!---
	var commonEvents = scope.component.commonEvents;
	var notCommonEvents = scope.component.notCommonEvents;
	for(var k=1; k<=2; k++){
		var events = k == 1 ? commonEvents : notCommonEvents;
		if(events.length > 0){
-->
			<table style="margin-left:5px;" <!--- if(commonEvents.length > 0 && k == 2) { -->ng-hide="hasHideNotCommonEvents"<!--- } -->>
		    <!---
				var event;
				for(var i=0, len=events.length; i<len; i++){
					event = events[i];
					var ngModel = scope.component.prefix != null ? scope.component.prefix+ '.' + 'data.'+event.ename : 'data.'+event.ename;
			-->
			    <tr <!--- if (event.hide === true){ --> style="display:none" <!--- } --> >
					<td>
						<table class="form_table">
							<tr>
								<td align="left" width="82%">+-event.ename-+</tb>
								<td align="right" class="autoNewline" nowrap="nowrap">
                                    <a title="新增并绑定" style="cursor:pointer;" onclick="openAddAction('+-event.ename-+')"><span class="cui-icon" style="font-size:12pt;color:#545454;">&#xf067;</span></a>&nbsp;&nbsp;
									<a title="编辑行为" style="cursor:pointer;" onclick="openEditAction('+-event.ename-+')"><span class="cui-icon" style="font-size:12pt;color:#545454;">&#xf022;</span></a>&nbsp;
								</td>
							</tr>
							<tr>
								<td align="left" width="90%">
									<span cui_clickinput width="100%" id="+-event.ename-+" ng-model="+-ngModel-+" ng-click="openSelectAction('+-event.ename-+')" methodTemplate="+-event.methodTemplate-+" methodOption="+-event.methodOption-+" actionType="+-event.type-+"></span>
								</td>
								<td align="right" class="autoNewline">
                                    <a title="删除绑定的行为" style="cursor:pointer;" onclick="clearEvent('+-event.ename-+')"><span class="cui-icon" style="font-size:14pt;color:rgb(255, 68, 0);">&#xf00d;</span></a>&nbsp;
								</td>
							</tr>
						</table>
					</td>
				</tr>
			<!---
				}
			-->
			</table>
		<!---
			if(k == 1 && notCommonEvents.length > 0){
		-->
			<table><tr><td width="auto" nowrap="nowrap">&nbsp;&nbsp;<a class="notUnbind show-more row-of-icons" ng-click="switchHideArea('hasHideNotCommonEvents')"><span class="cui-icon">{{!hasHideNotCommonEvents?'&#xf0d7;&nbsp;收起':'&#xf0da;&nbsp;更多'}}&nbsp;</span></a></td><td width='100%'><hr></td></tr></table>
		<!---
			} else {
				break;
			}
		-->
<!---
		}
	}
-->
</script>
	
