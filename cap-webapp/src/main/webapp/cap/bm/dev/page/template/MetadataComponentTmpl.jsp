<%
/**********************************************************************
* 控件属性模版
* 2015-5-13 诸焕辉
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
	<!-- 生成元数据器模版 -->
	<script id="metadataFormInterfaceTmpl" type="text/template">
		<!---
			var metaComponentDefineVOList = scope.metadataGenerateVO.metadataPageConfigVO.metaComponentDefineVOList;
			var index = 0;
			for(var i in metaComponentDefineVOList){
				if(metaComponentDefineVOList[i].uiType != null && metaComponentDefineVOList[i].uiType != ''){
					var uiType = metaComponentDefineVOList[i].uiType;
					var nextType = '';
					for(var j=parseInt(i+1); j<metaComponentDefineVOList.length; j++){
						if(metaComponentDefineVOList[j].uiType != null && metaComponentDefineVOList[j].uiType != ''){
							nextType = metaComponentDefineVOList[j].uiType;
							break;
						} 
					}
					if(uiType != ''){ 
						var domStr = '';
						if(uiType === 'listCodeArea'){
							domStr = '<span cui_list_code_area ng-object="root.'+metaComponentDefineVOList[i].id+'"></span>';
						} else if(uiType === 'queryCodeArea') {
							domStr = '<span cui_query_code_area ng-object="root.'+metaComponentDefineVOList[i].id+'"></span>';
						} else if(uiType === 'editCodeArea') {
							domStr = '<span cui_edit_code_area ng-object="root.'+metaComponentDefineVOList[i].id+'"></span>';
						} else {
							var jctComponent = new jCT($('#'+uiType).html());
							jctComponent.data = scope.root[metaComponentDefineVOList[i].id];
							domStr = jctComponent.Build().GetView();
						}
		-->	
				<!--- if(index == 0){ -->
					<tr>
				<!--- }	-->	
						<!--- 
							if(uiType === 'input' || uiType === 'menu'){
						-->
								<td class="cap-td" style="text-align: right; width:120px"><!--- if(metaComponentDefineVOList[i].uiConfig.validate != null){ --><font color="red">*</font><!--- } -->+-metaComponentDefineVOList[i].label-+：</td>  
						<!--- if(index == 0 && (nextType === '' || (nextType != '' && (nextType != 'input' && nextType != 'menu')))){ 
							  	index = 0;
						-->
								<td colspan="3" class="cap-td" style="text-align: left;">+-domStr-+</td>
						<!--- } else {	
									index = index == 0 ? 1 : 0;
						-->	
								<td class="cap-td" style="text-align: left;">+-domStr-+</td>	
						<!--- }	-->	
						<!--- 
							} else {
								index = 0;
						-->	
								<td class="cap-td" colspan="4">+-domStr-+</td>	
						<!--- 
							}
						 -->
				<!--- if(index == 0){ -->
					</tr>
				<!--- }	-->	
		<!---
					}
				}
			}
		-->
	</script>
	
	<!-- 查询区域控件 -->
	<script id="queryCodeArea" type="text/template">
		<div class="cap-group" id="+-this.ngObject.metaComponentDefine.id-+">
			<div class="area_title">
				<span>
					<blockquote class="cap-form-group">
						<span>查询区域</span>
					</blockquote>
				</span>
			</div>
			<div style="padding-left: 5px; text-align: left;">
			<!--- if(this.ngObject.metaComponentDefine.uiConfig.alias == null){ -->
				选择实体对象：<span cui_pulldown id="selectEntity_+-this.ngObject.metaComponentDefine.id-+" editable="false" mode="Single" ng-model="entityAlias" name="+-this.ngObject.metaComponentDefine.id-+" datasource="initEntityPullDown" style="size: 150;"></span>
			<!--- } else { -->	
				实体对象：<span cui_pulldown readonly="true" empty_text="" editable="false" id="selectEntity_+-this.ngObject.metaComponentDefine.id-+" editable="false" mode="Single" ng-model="entityAlias" name="+-this.ngObject.metaComponentDefine.id-+" datasource="initEntityPullDown" alias="+-this.ngObject.metaComponentDefine.uiConfig.alias-+" style="size: 150;"></span><font color="red">（注：只限于别名为+-this.ngObject.metaComponentDefine.uiConfig.alias-+的实体）</font>
			<!--- } -->	
			</div> 
			<div ng-repeat="componentVo in components" style="margin:5px;">
				<span cui_form_area ng-component-define-id="+-this.ngObject.metaComponentDefine.id-+" parent-object="componentVo"></span>
			</div>
		</div>
	</script>
	
	<!-- 菜单目录选择控件 -->
	<script id="menu" type="text/template">
		<!---
			var uiConfig = this.data.metaComponentDefine.uiConfig;
			var attr = '';
			_.forEach(uiConfig, function(value, key){
				attr += key + '="' + value + '" ';
			})
		-->
		<span cui_clickinput id="+-this.data.metaComponentDefine.id-+" ng-model="root.+-this.data.metaComponentDefine.id-+.+-this.data.metaComponentDefine.id-+" onclick="openCatalogSelect()" width="100%" +-attr-+></span>
	</script>
	
	<!-- 输入框控件 -->
	<script id="input" type="text/template">
		<!---
			var uiConfig = this.data.metaComponentDefine.uiConfig;
			var attr = '';
			_.forEach(uiConfig, function(value, key){
				attr += key + '="' + value + '" ';
			})
		-->
		<span cui_input id="+-this.data.metaComponentDefine.id-+" ng-model="root.+-this.data.metaComponentDefine.id-+.+-this.data.metaComponentDefine.id-+" width="100%" +-attr-+></span>
	</script>
	
	<!-- 实体选择控件模版 -->
	<script id="entitySelection" type="text/template">
		<div class="cap-group">		
			<div class="area_title">
				<span>
		        	<blockquote class="cap-form-group">
						<span>实体选择区域</span>
					</blockquote>
				</span>
			</div>
			<table class="custom-grid" style="width: 100%">
				<thead>
                    <tr>
                        <th width="10%">
                           	序号
                        </th>
                        <th width="70%">
                           	实体
                        </th>
                        <th width="20%">
                           	别名后缀
                        </th>
                    </tr>
                </thead>
		        <tbody>
				<!---
					var suffixList = this.data.metaComponentDefine.uiConfig.suffix;
					var rowsNum = suffixList != null ? suffixList.length : 0;
					for(var i=1; i<=rowsNum; i++){
						window["openEntitySelect_"+i] = _.bind(openEntitySelect, {id: this.data.metaComponentDefine.id, sequenceNumber: i});
						window["importEntityCallBack_"+i] = _.bind(importEntityCallBack, {id: this.data.metaComponentDefine.id, sequenceNumber: i, suffix:suffixList[i-1]});
				-->
                    <tr>
				    	<td class="cap-td" style="text-align: center;">
							+-i-+
				        </td>
				        <td class="cap-td" style="text-align: center;">
				        	<span cui_clickinput id="+-this.data.metaComponentDefine.id-+_+-i-+" ng-model="root.+-this.data.metaComponentDefine.id-+.entityList[+-i-1-+].engName" onclick="openEntitySelect_+-i-+()" width="100%" validate="[{type:'required',rule:{m:'不能为空'}}]"></span>
				        </td>
						<td class="cap-td" style="text-align: center;">
				        	<span cui_input readOnly="true" id="render" mode="Single" id="+-this.data.metaComponentDefine.id-+_suffix_+-i-+" ng-model="root.+-this.data.metaComponentDefine.id-+.entityList[+-i-1-+].suffix" width="100%"></span>
				        </td>
				    </tr>
				<!---
					}
				-->
		        </tbody>
			</table>
		</div>
	</script>
	
	<!-- 表单域中的属性编辑器 -->
	<script id="editPropertiesCodeArea" type="text/template">
		<!---
			this.scope = this.scope != null ? this.scope : scope;
			var properties = this.scope.component.commonProperties;
		-->
		<table class="commone_attr_table" id="properties_+-this.scope.ngComponentDefineId-+_+-this.scope.ngSubComponentDefineId-+_+-this.scope.ngRowId-+">
			<!---
				var property;
				var index = 0;
				for(var i=0, len=properties.length; i<len; i++){
					property = properties[i];
					if(property.ename == 'uitype' || property.hide === true){
						continue;
					}
					var nextType = '';
					var propertyEditorUI = property.propertyEditorUI;
			-->
			<!--- if(index == 0){ ++index;  -->
			<tr>
			<!--- }	else { --index; } -->	
				<td style="text-align: right;width: 20%"> 
                	<!---
						if (property.requried){
					-->
					<font color="red">*</font>
					<!---
						}  
					-->
					<!--- if (property.label != null){ -->+-property.label-+<!--- } else {-->+-property.ename-+<!--- } -->
                </td>
                <td style="text-align: center;width: 30%">
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
			<!--- if(index == 0){ -->
			</tr>
			<!--- }	-->	
			<!---
				}
			-->
		</table>
	</script>
	
	<!-- 列表区域控件 -->
	<script id="listCodeArea" type="text/template">
		<div class="cap-group" id="+-this.ngObject.metaComponentDefine.id-+">
			<div class="area_title">
				<span>
		        	<blockquote class="cap-form-group">
						<span>列表区域</span><!--- if(this.label != null){ -->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tips">（注：该区域的数据应用在+-this.label-+界面上）</span><!--- } -->
					</blockquote>
				</span>
			</div>
			<table class="cap-table-fullWidth">
				<tr>
			        <td class="cap-td" style="text-align: left;height: 35px;width:10%" nowrap="nowrap">
			        <!--- if(this.ngObject.metaComponentDefine.uiConfig.alias == null){ -->
						选择实体对象：<span cui_pulldown id="selectEntity_+-this.ngObject.metaComponentDefine.id-+" mode="Single" ng-model="entityAlias" name="+-this.ngObject.metaComponentDefine.id-+" datasource="initEntityPullDown" style="size: 150;"></span> 
			        <!--- } else { -->	
						实体对象：<span cui_pulldown readonly="true" empty_text="" editable="false" id="selectEntity_+-this.ngObject.metaComponentDefine.id-+" mode="Single" ng-model="entityAlias" name="+-this.ngObject.metaComponentDefine.id-+" datasource="initEntityPullDown" alias="+-this.ngObject.metaComponentDefine.uiConfig.alias-+" style="size: 150;"></span><font color="red">（注：只限于别名为+-this.ngObject.metaComponentDefine.uiConfig.alias-+的实体）</font>
					<!--- } -->	
					</td>
					<td class="cap-td" style="text-align: left;" nowrap="nowrap">
						选择模式：<span cui_pulldown id="render" mode="Single" ng-model="selectrows" datasource="[{id:'multi',text:'多选'},{id:'single',text:'单选'},{id:'no',text:'不可选'}]"></span>
			        </td>
			        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
			        	<span uitype="button" id="customColumn_+-this.ngObject.metaComponentDefine.id-+" label="添加" menu="customColumnButtonGroup2Grid_+-this.ngObject.metaComponentDefine.id-+"></span> 
					    <span cui_button id="deleteCustomHeader_+-this.ngObject.metaComponentDefine.id-+" label="删除" ng-click="deleteCustomHeader()"></span>
					    <span cui_button id="customHeaderUpButton_+-this.ngObject.metaComponentDefine.id-+" label="上移" ng-click="up()"></span> 
						<span cui_button id="customHeaderDownButton_+-this.ngObject.metaComponentDefine.id-+" label="下移" ng-click="down()"></span> 
						<a title="上一级" style="cursor:pointer;" ng-click="upGrade()">&nbsp;<span class="cui-icon" style="font-size:12pt; color:#333;">&#xf0d9;</span></a>
					    <span cui_pulldown id="level" ng-change="setLevel()" ng-model="level" value_field="id" label_field="text" empty_text="级别" width="45px">
							<a value="1">1</a>
							<a value="2">2</a>
							<a value="3">3</a>
							<a value="4">4</a>
							<a value="5">5</a>
						</span>
					    <a title="下一级" style="cursor:pointer;" ng-click="downGrade()"><span class="cui-icon" style="font-size:12pt; color:#333;">&#xf0da;</span></a>
			        </td>
			    </tr>
			</table>
			<table class="cap-table-fullWidth">
			    <tr style="border-top:1px solid #ddd;">
			        <td class="cap-td" style="text-align: center; padding: 2px; width: 30%;">
			        	<div class="custom_div">
				        	<table class="custom-grid" style="width: 100%;">
				                <thead>
				                    <tr>
				                    	<th style="width:30px">
				                    		<input type="checkbox" name="attributesCheckAll" ng-model="attributesCheckAll" ng-change="allCheckBoxCheckAttribute(attributes,attributesCheckAll)">
				                        </th>
				                        <th>
			                            	数据属性
				                        </th>
				                    </tr>
				                </thead>
		                        <tbody>
		                            <tr ng-repeat="attributeVo in attributes track by $index" ng-hide="attributeVo.isFilter">
		                            	<td style="text-align: center;">
		                                    <input type="checkbox" name="{{'attribute'+($index + 1)}}" ng-model="attributeVo.check" ng-change="checkBoxCheckAttribute(attributes,'attributesCheckAll')">
		                                </td>
		                                <td style="text-align:left;cursor:pointer" ng-click="gridAttributeTdClick(attributeVo)">
		                                    {{attributeVo.engName}}({{attributeVo.chName}})
		                                </td>
		                            </tr>
		                       </tbody>
				            </table>
			            </div>
			        </td>
			        <td style="text-align: left;border-right:1px solid #ddd;">
			        </td>
			        <td class="cap-td" style="text-align: center; padding: 2px; width: 30%">
			        	<div class="custom_div">
				        	<table class="custom-grid" style="width: 100%">
				                <thead>
				                    <tr>
				                    	<th style="width:30px">
				                    		<input type="checkbox" name="customHeadersCheckAll" ng-model="customHeadersCheckAll" ng-change="allCheckBoxCheckCustomHeader(customHeaders,customHeadersCheckAll)">
				                        </th>
				                        <th>
			                            	列名
				                        </th>
				                    </tr>
				                </thead>
		                        <tbody>
		                            <tr ng-repeat="customHeaderVo in customHeaders track by $index" style="background-color: {{customHeaderVo.check == true ? '#99ccff':'#ffffff'}}">
		                            	<td style="text-align: center;">
		                                    <input type="checkbox" name="{{'customHeader'+($index + 1)}}" ng-model="customHeaderVo.check" ng-change="checkBoxCheckCustomHeader(customHeaders,'customHeadersCheckAll')">
		                                </td>
		                                <td style="text-align:left;cursor:pointer" ng-click="customHeaderTdClick(customHeaderVo)">
		                                  {{customHeaderVo.indent}}&nbsp;{{customHeaderVo.bindName}}{{customHeaderVo.name != '' ? '('+customHeaderVo.name+')' : ''}}
		                                </td>
		                            </tr>
		                       </tbody>
				            </table>
			            </div>
			        </td>
			        <td style="text-align: left;border-right:1px solid #ddd;">
			        </td>
			        <td class="cap-td" style="text-align: left; padding: 2px; width: 40%;">
			       		<ul class="tab">
							<li class="active">表头属性</li>
						</ul>
						<div>
							<div id="tab_property_+-this.ngModel-+" class="properties-div" ng-show="customHeaders.length > 0">
								<table class="form_table">
									<tr>
										<td width="39%" align="right" class="autoNewline">name</tb>
										<td align="left"><span cui_input id="name" name="name" ng-model="data.name" width="100%" valuetype="String" validate="nameValRule" ></span></td>
									</tr>
									<tr>
										<td width="39%" align="right" class="autoNewline">renderStyle</tb>
										<td align="left"><span cui_pulldown id="renderStyle"
											mode="Single" value_field="id" label_field="text" name="renderStyle"
											ng-model="data.renderStyle"
											datasource="[{id:'text-align:left',text:'左'},{id:'text-align:center',text:'居中'},{id:'text-align:right',text:'右'}]"
											width="100%" valuetype="String"></span>
										</td>
									</tr>
									<tr>
										<td width="39%" align="right" class="autoNewline">bindName</tb>
										<td align="left"><span cui_input id="bindName" name="bindName"
											ng-model="data.bindName" width="100%" valuetype="String"  validate="bindNameValRule" ></span>
										</td>
									</tr>
									<tr>
										<td width="39%" align="right" class="autoNewline">render</tb>
										<td align="left"><span cui_pulldown id="render" mode="Single"
											ng-model="data.render" datasource="defaultRenderDatasource" width="100%"
											valuetype="String"></span>
										</td>
									</tr>
									<tr>
										<td width="39%" align="right" class="autoNewline">width</tb>
										<td align="left"><span cui_input id="width" name="width"
											ng-model="data.width" width="100%" valuetype="String"></span>
										</td>
									</tr>
									<tr>
										<td width="39%" align="right" class="autoNewline">format</tb>
										<td align="left"><span cui_input id="format" name="format"
											ng-model="data.format" width="100%" valuetype="String"></span>
										</td>
									</tr>
								</table>
							</div>
						</div>
			        </td>
			    </tr>
			</table>
		</div>
	</script>	
	
	<!-- 编辑列表区域控件 -->
	<script id="editableGridCodeArea" type="text/template">
		<div class="cap-group" id="+-this.scope.parentObject.id-+">		
			<div class="area_title">
				<span>
		        	<blockquote class="cap-form-group">
						<span>编辑列表区域</span><!--- if(this.scope.label != null){ -->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tips">（注：该区域的数据应用在+-this.scope.label-+界面上）</span><!--- } -->
					</blockquote>
				</span>
			</div>
			<table class="cap-table-fullWidth">
				<tr>
			        <td class="cap-td" style="text-align: left;height: 35px;width:10%" nowrap="nowrap">
			        	所关联的子实体集：<span cui_pulldown id="selectSubEntity_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+" mode="Single" ng-model="entityId" name="+-this.scope.ngComponentDefineId-+" datasource="[]" style="size: 150;"></span> <font color="red">（注：适用于“一对多”或 ”多对多”关系的场景）</font>
			        </td>
			        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
			        	<span uitype="button" id="customColumn_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+" label="添加" menu="customColumnButtonGroup2EditGrid_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+"></span> 
					    <span cui_button id="deleteCustomHeader_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+" label="删除" ng-click="deleteCustomHeader()"></span>
					    <span cui_button id="customHeaderUpButton_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+" label="上移" ng-click="up()"></span> 
						<span cui_button id="customHeaderDownButton_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+" label="下移" ng-click="down()"></span> 
						<a title="上一级" style="cursor:pointer;" ng-click="upGrade()">&nbsp;<span class="cui-icon" style="font-size:12pt; color:#333;">&#xf0d9;</span></a>
					    <span cui_pulldown id="level" ng-change="setLevel()" ng-model="level" value_field="id" label_field="text" empty_text="级别" width="45px">
							<a value="1">1</a>
							<a value="2">2</a>
							<a value="3">3</a>
							<a value="4">4</a>
							<a value="5">5</a>
						</span>
					    <a title="下一级" style="cursor:pointer;" ng-click="downGrade()"><span class="cui-icon" style="font-size:12pt; color:#333;">&#xf0da;</span></a>
			        </td>
			    </tr>
			</table>
			<table class="cap-table-fullWidth">
			    <tr style="border-top:1px solid #ddd;">
			        <td class="cap-td" style="text-align: center; padding: 2px; width: 30%;">
			        	<div class="custom_div">
				        	<table class="custom-grid" style="width: 100%;">
				                <thead>
				                    <tr>
				                    	<th style="width:30px">
				                    		<input type="checkbox" name="attributesCheckAll" ng-model="attributesCheckAll" ng-change="allCheckBoxCheckAttribute(attributes,attributesCheckAll)">
				                        </th>
				                        <th>
			                            	数据属性
				                        </th>
				                    </tr>
				                </thead>
		                        <tbody>
		                            <tr ng-repeat="attributeVo in attributes track by $index" ng-hide="attributeVo.isFilter">
		                            	<td style="text-align: center;">
		                                    <input type="checkbox" name="{{'attribute'+($index + 1)}}" ng-model="attributeVo.check" ng-change="checkBoxCheckAttribute(attributes,'attributesCheckAll')">
		                                </td>
		                                <td style="text-align:left;cursor:pointer" ng-click="gridAttributeTdClick(attributeVo)">
		                                    {{attributeVo.engName}}({{attributeVo.chName}})
		                                </td>
		                            </tr>
		                       </tbody>
				            </table>
			            </div>
			        </td>
			        <td style="text-align: left;border-right:1px solid #ddd;">
			        </td>
			        <td class="cap-td" style="text-align: center; padding: 2px; width: 30%">
			        	<div class="custom_div">
				        	<table class="custom-grid" style="width: 100%">
				                <thead>
				                    <tr>
				                    	<th style="width:30px">
				                    		<input type="checkbox" name="customHeadersCheckAll" ng-model="customHeadersCheckAll" ng-change="allCheckBoxCheckCustomHeader(customHeaders,customHeadersCheckAll)">
				                        </th>
				                        <th>
			                            	列名(columns)
				                        </th>
				                    </tr>
				                </thead>
		                        <tbody>
		                            <tr ng-repeat="customHeaderVo in customHeaders track by $index" style="background-color: {{customHeaderVo.check == true ? '#99ccff':'#ffffff'}}">
		                            	<td style="text-align: center;">
		                                    <input type="checkbox" name="{{'customHeader'+($index + 1)}}" ng-model="customHeaderVo.check" ng-change="checkBoxCheckCustomHeader(customHeaders,'customHeadersCheckAll')">
		                                </td>
		                                <td style="text-align:left;cursor:pointer" ng-click="customHeaderTdClick(customHeaderVo)">
		                                   {{customHeaderVo.indent}}&nbsp;{{customHeaderVo.bindName}}{{customHeaderVo.name != '' ? '('+customHeaderVo.name+')' : ''}}{{customHeaderVo.edittype.data.uitype != null ? '-['+customHeaderVo.edittype.data.uitype+']' : ''}}
		                                </td>
		                            </tr>
		                       </tbody>
				            </table>
			            </div>
			        </td>
			        <td style="text-align: left;border-right:1px solid #ddd;">
			        </td>
			        <td class="cap-td" style="text-align: left; padding: 2px; width: 40%;">
			       		<ul class="tab">
							<li ng-class="{'property':'active'}[active]" ng-click="showPanel('property')">表头属性</li>
							<li ng-class="{'componentType':'active'}[active]" ng-click="showPanel('componentType')">控件类型定义</li>
						</ul>
						<div>
							<div id="tab_property_+-this.ngModel-+" class="tab_panel custom_div" ng-show="active=='property' && data.check && batchEdittype.length == 0">
								<table class="form_table">
									<tr>
										<td width="39%" align="right" class="autoNewline">name</tb>
										<td align="left"><span cui_input id="name" name="name" ng-model="data.name" width="100%" valuetype="String" validate="nameValRule" ></span></td>
									</tr>
									<tr>
										<td width="39%" align="right" class="autoNewline">renderStyle</tb>
										<td align="left"><span cui_pulldown id="renderStyle"
											mode="Single" value_field="id" label_field="text" name="renderStyle"
											ng-model="data.renderStyle"
											datasource="[{id:'text-align:left',text:'左'},{id:'text-align:center',text:'居中'},{id:'text-align:right',text:'右'}]"
											width="100%" valuetype="String"></span>
										</td>
									</tr>
									<tr>
										<td width="39%" align="right" class="autoNewline">bindName</tb>
										<td align="left"><span cui_input id="bindName" name="bindName"
											ng-model="data.bindName" width="100%" valuetype="String" validate="bindNameValRule" ></span>
										</td>
									</tr>
									<tr>
										<td width="39%" align="right" class="autoNewline">render</tb>
										<td align="left"><span cui_pulldown id="render" mode="Single"
											ng-model="data.render" datasource="defaultRenderDatasource" width="100%"
											valuetype="String"></span>
										</td>
									</tr>
									<tr>
										<td width="39%" align="right" class="autoNewline">width</tb>
										<td align="left"><span cui_input id="width" name="width"
											ng-model="data.width" width="100%" valuetype="String"></span>
										</td>
									</tr>
									<tr>
										<td width="39%" align="right" class="autoNewline">format</tb>
										<td align="left"><span cui_input id="format" name="format"
											ng-model="data.format" width="100%" valuetype="String"></span>
										</td>
									</tr>
								</table>
							</div>
							<div id="tab_componentType_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+" class="tab_panel" ng-show="active=='componentType'">
								<table class="cap-table-fullWidth">
									<tr>
								        <td class="cap-td" style="text-align: left;height: 35px;border-bottom:1px solid #ddd;" nowrap="nowrap">
								        	控件类型：
								        	<span cui_pulldown id="uitype_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+" name="uitype" width="103" ng-model="uitype" datasource="initUItypeData" value_field="id" label_field="text"></span>
								        	<span cui_button id="batchUpdateBtn" ng-show="hasBatchEdittypeOperation && data.bindName != null" ng-click="batchUpdate()" label="批量修改"></span>
								        </td>
								    </tr>
								</table>
								<div id="properties-div-+-this.scope.ngComponentDefineId-+-+-this.scope.parentObject.id-+" class="properties-div"></div>
							</div>
						</div>
			        </td>
			    </tr>
			</table>
		</div>
	</script>	
	
	<!-- 编辑区控件 -->
	<script id="editCodeArea" type="text/template">
		<div class="cap-group" id="this.ngObject.metaComponentDefine.id" style="min-height:68px">
			<div class="area_title">
				<span>
		        	<blockquote class="cap-form-group">
						<span>编辑区域</span>
					</blockquote>
				</span>
			</div>
			<div>
				<div style="<!--- if(this.ngObject.metaComponentDefine.uiConfig.componentInfo == null){ -->float:left;<!--- } -->text-align:left;padding-left: 5px;">
					<!--- if(this.ngObject.metaComponentDefine.uiConfig.alias == null){ -->
					选择实体对象：<span cui_pulldown id="selectEntity_+-this.ngObject.metaComponentDefine.id-+" mode="Single" ng-model="entityAlias" name="+-this.ngObject.metaComponentDefine.id-+" datasource="initEntityPullDown" style="size: 150;"></span>
					<!--- } else { -->	
					实体对象：<span cui_pulldown readonly="true" empty_text="" editable="false" id="selectEntity_+-this.ngObject.metaComponentDefine.id-+" editable="false" mode="Single" ng-model="entityAlias" name="+-this.ngObject.metaComponentDefine.id-+" datasource="initEntityPullDown" alias="+-this.ngObject.metaComponentDefine.uiConfig.alias-+" style="size: 150;"></span><font color="red">（注：只限于别名为+-this.ngObject.metaComponentDefine.uiConfig.alias-+的实体）</font>
					<!--- } -->	
				</div>
				<!--- if(this.ngObject.metaComponentDefine.uiConfig.componentInfo == null){ --> 
				<div style="text-align:right; padding-right: 5px;" ng-show="entityAlias != null && entityAlias != ''">
					<span cui_button id="addFormCodeArea_+-this.ngObject.metaComponentDefine.id-+" label="添加表单" ng-click="addFormCodeArea()"></span> 
				    <span cui_button id="addFieldsetCodeArea_+-this.ngObject.metaComponentDefine.id-+" label="添加分组栏" ng-click="addFieldset()"></span> 
				    <span cui_button id="addEditableGridCodeArea_+-this.ngObject.metaComponentDefine.id-+" label="添加EditableGrid" ng-click="addEditableGrid()"></span> 
				</div>
				<!--- } -->	
			</div>
			<div ng-repeat="componentVo in components" ng-switch="componentVo.uitype" style="margin:5px;">
				<div style="float: right; margin-top: 0px; padding: 1px 10px;">
					<a class="row-of-icons" ng-click="upCodeArea()" title="上移"><span class="cui-icon" style="font-size:12pt;color:#545454;cursor: pointer">&nbsp;&#xf062;&nbsp;</span></a>
					&nbsp;&nbsp;
					<a class="row-of-icons" ng-click="downCodeArea()" title="下移"><span class="cui-icon" style="font-size:12pt;color:#545454;cursor: pointer">&nbsp;&#xf063;&nbsp;</span></a>
					<!--- if(this.ngObject.metaComponentDefine.uiConfig.componentInfo == null){ --> &nbsp;&nbsp;
					<a class="row-of-icons" ng-click="deleteCodeArea()" title="删除"><span class="cui-icon" style="font-size:14pt;color:#545454;cursor: pointer">&nbsp;&#xf00d;&nbsp;</span></a>
					<!--- } -->	
				</div>
	            <div ng-switch-when="editFormCodeArea">
					<span cui_form_area ng-component-define-id="+-this.ngObject.metaComponentDefine.id-+" parent-object="componentVo"></span>
				</div>
	            <div ng-switch-when="editGridCodeArea">
					<span cui_edit_grid_code_area ng-component-define-id="+-this.ngObject.metaComponentDefine.id-+" parent-object="componentVo" parent-entity-id="entityId" datasource_4_Sub_Entity='datasource4SubEntity'></span>
				</div>
	            <div ng-switch-default>
					<div class="cap-group">		
						<div class="area_title">
							<span>
		        				<blockquote class="cap-form-group">
									<span>分组栏</span>
								</blockquote>
							</span>
						</div>
						<div style="padding: 5px;text-align: left">标题名称：<span cui_input ng-model="componentVo.value"></span></div>
					</div>
				</div>
			</div>
		</div>
	</script>
	
	<!-- 表单域控件 -->
	<script id="formCodeArea" type="text/template">
		<div class="cap-group" id="+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+">
			<div class="area_title">
				<span>
			        <blockquote class="cap-form-group">
						<span><!--- if(this.scope.parentObject.uitype === 'queryFixedCodeArea' || this.scope.parentObject.uitype === 'queryMoreCodeArea'){if(this.scope.parentObject.uitype === 'queryFixedCodeArea'){ -->固定<!--- } else { -->更多<!--- } -->查询区域</span><!--- } else { -->表单区域</span><!--- } --></span><!--- if(this.scope.label != null){ -->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tips">（注：该区域的数据应用在+-this.scope.label-+界面上）</span><!--- } -->
					</blockquote>
				</span>
			</div>
			<table class="cap-table-fullWidth">
				<tr>
					<td class="cap-td" style="text-align: left; height: 35px;" nowrap="nowrap">
						布局：<span cui_pulldown id="render" mode="Single" ng-model="col" editable="false">
								<a value="1">1列</a>
								<a value="2">2列</a>
								<a value="3">3列</a> 
							</span>
			        </td>
			        <td class="cap-td" style="text-align: right;">
			        	<span uitype="button" id="customColumn_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+" label="添加" ng-click="addBtn()"></span> 
					    <span cui_button id="deleteComponet_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+" label="删除" ng-click="deleteComponet()"></span>
					    <span cui_button id="customHeaderUpButton_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+" label="上移" ng-click="up()"></span> 
						<span cui_button id="customHeaderDownButton_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+" label="下移" ng-click="down()"></span> 
						<span cui_button id="top_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+" label="置顶" ng-click="setTop()"></span> 
						<span cui_button id="buttom_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+" label="置底" ng-click="setBottom()"></span> 
			        </td>
			    </tr>
			</table>
			<table class="cap-table-fullWidth">
			    <tr style="border-top:1px solid #ddd;">
			        <td class="cap-td" style="text-align: center; padding: 2px; width: 20%;">
			        	<div class="custom_div">
				        	<table class="custom-grid" style="width: 100%;">
				                <thead>
				                    <tr>
				                    	<th style="width:30px">
				                    		<input type="checkbox" name="attributesCheckAll" ng-model="attributesCheckAll" ng-change="allCheckBoxCheckAttribute(attributes,attributesCheckAll)">
				                        </th>
				                        <th>
			                            	数据属性
				                        </th>
				                    </tr>
				                </thead>
		                        <tbody>
		                            <tr ng-repeat="attributeVo in attributes track by $index" ng-hide="attributeVo.isFilter">
		                            	<td style="text-align: center;">
		                                    <input type="checkbox" name="{{'attribute'+($index + 1)}}" ng-model="attributeVo.check" ng-change="checkBoxCheckAttribute(attributes,'attributesCheckAll')">
		                                </td>
		                                <td style="text-align:left;cursor:pointer" ng-click="gridAttributeTdClick(attributeVo)">
		                                    {{attributeVo.engName}}({{attributeVo.chName}})
		                                </td>
		                            </tr>
		                       </tbody>
				            </table>
			            </div>
			        </td>
			        <td style="text-align: left;border-right:1px solid #ddd;">
			        </td>
			        <td class="cap-td" style="text-align: center; padding: 2px; width: 80%">
			        	<div class="custom_div">
				        	<table class="custom-grid" style="width: 100%;">
				                <thead>
				                    <tr>
				                    	<th width="30px">
				                    		<input type="checkbox" name="componentsCheckAll" ng-model="componentsCheckAll" ng-change="allCheckBoxCheckComponent(components,componentsCheckAll)">
				                        </th>
				                        <th width="10%">
			                            	名称
				                        </th>
										<th width="70%">
			                            	控件属性
				                        </th>	
										<th width="110px">
			                            	控件类型
				                        </th>
										<th width="10%">
			                            	控件列宽
				                        </th>
				                    </tr>
				                </thead>
		                        <tbody>
		                        	<tr ng-repeat="componentVo in components">
		                            	<td style="text-align: center;">
		                                    <input type="checkbox" name="{{'componentCheck'+($index + 1)}}" ng-model="componentVo.check" ng-change="checkBoxCheckComponent(components,'componentsCheckAll')">
		                                </td>
		                                <td style="text-align:left;">
											<span cui_input id="cname" name="cname" ng-model="componentVo.cname" width="100%" valuetype="String" validate="nameValRule" ></span>
		                                </td>
		                                <td id="editPropertiesArea_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+_{{componentVo.id}}">
											<span cui_property ng-model="componentVo" ng-row-id="" ng-component-define-id='+-this.scope.ngComponentDefineId-+' ng-sub-component-define-id='+-this.scope.parentObject.id-+' ng-sub-component-define-type='+-this.scope.parentObject.uitype-+'></span>
		                                </td>
		                                <td style="text-align: center;">
		                                	<span cui_pulldown id="+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+_{{'componentModelId'+($index + 1)}}" name="{{'componentModelId'+($index + 1)}}" ng-model="componentVo.componentModelId" datasource="defaultCompTypeDatasource" value_field="componentModelId" label_field="modelName" width="105px" ng-change="loadComponent('editPropertiesArea_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+_{{componentVo.id}}', '{{componentVo.id}}')"></span>
		                                </td>
		                                <td style="text-align: center;">
		                                	<span cui_pulldown id="+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+_{{'colspan'+($index + 1)}}" name="{{'colspan'+($index + 1)}}" ng-model="componentVo.colspan" value_field="id" label_field="text" datasource="colPulldown_+-this.scope.ngComponentDefineId-+_+-this.scope.parentObject.id-+" width="100%"></span>
		                                </td>
		                            </tr>
		                       </tbody>
				            </table>
			            </div>
			        </td>
			        <td style="text-align: left;border-right:1px solid #ddd;">
			        </td>
			    </tr>
			</table>
		</div>
	</script>	