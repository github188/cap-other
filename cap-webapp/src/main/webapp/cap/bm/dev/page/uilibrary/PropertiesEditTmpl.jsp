<%
/**********************************************************************
* 控件属性模版
* 2015-5-13 诸焕辉
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!-- 控件属性模版 -->
<script id="propertiesEditTmpl" type="text/template">
<!---
	this.scope = this.scope != null ? this.scope : scope;
	var commonProperties = this.scope.component.commonProperties;
	var notCommonProperties = this.scope.component.notCommonProperties;
	for(var k=1; k<=2; k++){
		properties = k == 1 ? commonProperties : notCommonProperties;
		if(properties.length > 0){
-->
			<table class="form_table" <!--- if(commonProperties.length > 0 && k == 2) { -->ng-hide="hasHideNotCommonProperties"<!--- } -->>
			<!---
				var property;
				for(var i=0, len=properties.length; i<len; i++){
					property = properties[i];
					if(property.ename == 'uitype'){
						continue;
					}
					var propertyEditorUI = property.propertyEditorUI;
			-->
				<tr <!--- if (property.hide === true){ --> style="display:none" <!--- } --> >
					<td width="39%" align="right" class="autoNewline">
						<!---
							if (property.requried){
						-->
						<font color="red">*</font>
						<!---
							}  
						-->
						<!--- if (property.label != null){ -->+-property.label-+<!--- } else {-->+-property.ename-+<!--- } -->
					</tb>
					<td align="left">
				<!---
					var attr = '';
					var propertyVo = propertyEditorUI.script;
					propertyVo = typeof(propertyVo) == 'object' ? propertyVo : eval("("+propertyVo+")");
					for(var key in propertyVo){
						if(key !='radio_list'){
							var value = propertyVo[key];
							if(key === 'ng-model' && this.scope.component.prefix != null){
								value = this.scope.component.prefix + '.' + propertyVo[key];
							}
							attr += ' '+ key + '="' + value + '"';
						}
					}
				-->
						<span +-propertyEditorUI.componentName-+ +-attr-+ width="100%" valuetype="+-property.type-+">
							<!---
								if(propertyVo.radio_list != null){
                                    propertyVo.radio_list = eval(propertyVo.radio_list);
									for(var j=0;j<propertyVo.radio_list.length;j++){
										propertyRadio = propertyVo.radio_list[j];
							-->
								<!---
									if (propertyRadio.readonly == 'undefinded'){
								-->
									<input type="radio" value="+-propertyRadio.value-+" text="+-propertyRadio.text-+"/>
								<!---
									}else{
								-->
									<input type="radio" value="+-propertyRadio.value-+" text="+-propertyRadio.text-+" />
							<!---
										} 
									}
								}
							-->
						</span>
					</td>
				</tr>
			<!---
				}
			-->
			</table>
		<!---
			if(k == 1 && notCommonProperties.length > 0){
		-->
			<table><tr><td width="auto" nowrap="nowrap">&nbsp;&nbsp;<a class="notUnbind show-more row-of-icons" ng-click="switchHideArea('hasHideNotCommonProperties')"><span class="cui-icon">{{!hasHideNotCommonProperties?'&#xf0d7;&nbsp;收起':'&#xf0da;&nbsp;更多'}}&nbsp;</span></a></td><td width="100%"><hr></td></tr></table>
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