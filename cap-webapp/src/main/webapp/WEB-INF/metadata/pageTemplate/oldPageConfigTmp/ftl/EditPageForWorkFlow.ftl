{
	"charEncode":"<#if charEncode??>${charEncode}<#else>UTF-8</#if>",
	"cname":"${cname}编辑页面",
	"code":"${code}",
	"createTime":<#if createTime??>${createTime}<#else>0</#if>,
	"createrId":"<#if createrId??>${createrId}<#else></#if>",
	"createrName":"<#if createrName??>${createrName}<#else></#if>",
	"dataStoreVOList":[
		{
			"cname":"页面全局参数",
			"ename":"environmentVariable",
			"entityId":"",
			"modelType":"environmentVariable",
			"pageConstantList":[],
			"verifyIdList":[]
		},
		{
			"cname":"页面传入参数",
			"ename":"pageParam",
			"entityId":"",
			"modelType":"pageParam",
			"pageConstantList":[],
			"verifyIdList":[]
		},
		{
			"cname":"页面用户权限",
			"ename":"rightsVariable",
			"entityId":"",
			"modelType":"rightsVariable",
			"pageConstantList":[],
			"verifyIdList":[]
		},
		{
			"cname":"页面常量",
			"ename":"pageConstantList",
			"entityId":"",
			"modelType":"pageConstant",
			"pageConstantList":[
			<#if dataStoreList??>
				<#if dataStoreList.pageConstant??>
					{
						"constantDescription":"列表页面",
						"constantName":"${dataStoreList.pageConstant.constantName}ListPage",
						"constantOption":{
							"pageAttributeVOList":"[]",
							"pageModelId":"${dataStoreList.pageConstant.pageModelId}ListPageForWorkFlow",
							"url":"${dataStoreList.pageConstant.url}ListPageForWorkFlow${pageUrlSuffix}"
						},
						"constantType":"url",
						"constantValue":"'${dataStoreList.pageConstant.url}ListPageForWorkFlow${pageUrlSuffix}'"
					}
					<#-- 列表链接变量 -->
					<#assign listURLConstant= dataStoreList.pageConstant.constantName+"ListPage">
				<#else>
						<#-- 列表链接变量 -->
						<#assign listURLConstant= "">
				</#if>
			</#if>
			],
			"verifyIdList":[]
		}
		<#-- 用户自定义数据模型列表 -->
		<#if dataStoreList??>
			<#if dataStoreList.dataEntityList??>,
				<#list dataStoreList.dataEntityList as dataStore>
					<#if dataStore.suffix=="editEntity" ||dataStore.suffix=="editEntityItem">
					{
						"cname":"${dataStore.chName}",
						"ename":"${dataStore.engName}",	
						"entityId":"${dataStore.modelId}",
						"modelType":"object",
						"pageConstantList":[],
						"verifyIdList":[]
					}
					</#if>
					<#-- 判断数据模型是否为list中最后一个 -->
					<#if dataStore_has_next>
					,
					</#if>
				</#list>
		</#if>
	</#if>
	],
	"description":"<#if description??>${description}<#else></#if>",
	"hasMenu":<#if hasMenu??>${hasMenu}<#else>false</#if>,
	"hasPermission":<#if hasPermission??>${hasPermission}<#else>true</#if>,
	"includeFileList":[
		{
			"defaultReference":true,
			"fileName":"base",
			"filePath":"/cap/rt/common/base/css/base.css",
			"fileType":"css"
		},
		{
			"defaultReference":true,
			"fileName":"comtop.cap.rt",
			"filePath":"/cap/rt/common/base/css/comtop.cap.rt.css",
			"fileType":"css"
		},
		{
			"defaultReference":true,
			"fileName":"comtop.ui.min",
			"filePath":"/cap/rt/common/cui/themes/default/css/comtop.ui.min.css",
			"fileType":"css"
		},
		{
			"defaultReference":true,
			"fileName":"jquery",
			"filePath":"/cap/rt/common/base/js/jquery.js",
			"fileType":"js"
		},
		{
			"defaultReference":true,
			"fileName":"comtop.ui.min",
			"filePath":"/cap/rt/common/cui/js/comtop.ui.min.js",
			"fileType":"js"
		},
		{
			"defaultReference":true,
			"fileName":"comtop.cap.rt",
			"filePath":"/cap/rt/common/base/js/comtop.cap.rt.js",
			"fileType":"js"
		},
		{
			"defaultReference":true,
			"fileName":"globalVars",
			"filePath":"/cap/rt/common/globalVars.js",
			"fileType":"js"
		},
		{
			"defaultReference":true,
			"fileName":"Taglibs",
			"filePath":"/cap/rt/common/CapRtTaglibs.jsp",
			"fileType":"jsp"
		}
		<#-- 用户自定义引入jsp、js、css -->
		<#if includeFileList??>
			,
			<#list includeFileList as includeFile>
			<#-- 判断是否为引入文件集合中最后一个对象-->
				<#assign foo=includeFile.defaultReference/> 
				<#if !includeFile_has_next>
					{
						"defaultReference":<#if includeFile.defaultReference??>${foo?c}<#else>flase</#if>,
						"fileName":"${includeFile.fileName}",
						"filePath":"${includeFile.filePath}",
						"fileType":"${includeFile.fileType}"
					}
				<#else>
					{
						"defaultReference":<#if includeFile.defaultReference??>${foo?c}<#else>flase</#if>,
						"fileName":"${includeFile.fileName}",
						"filePath":"${includeFile.filePath}",
						"fileType":"${includeFile.fileType}"
					},
				</#if>
			</#list>
		</#if>
		
	],
	"layoutVO":{
		"children":[
		<#-- 页面布局开始 -->	
		<#-- 页面操作按钮 -->
		{
				"children":[{
					"children":[{
						"children":[
							{
								"children":[],
								"componentModelId":"uicomponent.bestPractice.editFunc.component.saveButton",
								"id":"uiid-53471470542717725",
								"options":{
									"id":"btnSave",
									"label":"保存",
									"name":"btnSave",
									"on_click":"saveForm",
									"on_click_id":"14464531293370",
									"uitype":"Button"
								},
								"type":"ui",
								"uiType":"Button"
							},
							{
								"children":[],
								"componentModelId":"uicomponent.bestPractice.component.backToButton",
								"id":"uiid-6582267429446802",
								"options":{
									"id":"btnBackTo",
									"label":"返回",
									"name":"btnBackTo",
									"on_click":"backTo",
									"on_click_id":"14464534943810",
									"uitype":"Button"
								},
								"type":"ui",
								"uiType":"Button"
							}
						],
						"componentModelId":"uicomponent.layout.component.tableLayout",
						"id":"tdid-5912058073095977",
						"options":{
							"label":"单元格",
							"text-align":"right",
							"uitype":"Td"
						},
						"type":"layout",
						"uiType":"td"
					}],
					"id":"trid-9196089173201472",
					"options":{
						"uitype":"tr"
					},
					"type":"layout",
					"uiType":"tr"
				}],
				"id":"tableid-34423556085675955",
				"options":{
					"label":"表格布局",
					"uitype":"table"
				},
				"type":"layout",
				"uiType":"table"
		},
		<#-- 编辑form -->
		<#if editArea??>
			<#list editArea as editData>
				<#-- 分组栏 -->
				<#if editData.uitype=="groutingCloumn">
					{
						"children":[{
							"children":[{
								"children":[{
									"children":[],
									"componentModelId":"uicomponent.common.component.label",
									"id":"uiid-${editData.labelId}",
									"options":{
										"isBold":true,
										"label":"文字",
										"uitype":"Label",
										"value":"${editData.labelName}"
									},
									"type":"ui",
									"uiType":"Label"
								}],
								"componentModelId":"uicomponent.layout.component.tableLayout",
								"id":"tdid-15838183125015348",
								"options":{
									"label":"单元格",
									"text-align":"left",
									"uitype":"Td"
								},
								"type":"layout",
								"uiType":"td"
							}],
							"id":"trid-3243382007582113",
							"options":{
								"uitype":"tr"
							},
							"type":"layout",
							"uiType":"tr"
						}],
						"id":"tableid-24900393723510206",
						"options":{
							"label":"表格布局",
							"uitype":"table"
						},
						"type":"layout",
						"uiType":"table"
					}
				</#if>
				<#-- Form表单 -->
				<#if editData.uitype=="editFormCodeArea">
					{
						"children":[
						<#-- tr 循环-->
						<#-- 定义控制行列循环次数变量 -->
						<#list editData.dataList as trCondition>
							{
							"children":[
								<#-- td 循环-->
								<#list trCondition.listQueryConditions as queryCondition>
									<#if queryCondition.tdDataBind??>
										{
											"children":[{
												"children":[],
												"componentModelId":"uicomponent.common.component.label",
												"id":"uiid-${queryCondition.labelId}",
												"options":{
													"isReddot":false,
													"label":"${queryCondition.tdLabel}",
													"name":"${queryCondition.tdLabelName}Label",
													"uitype":"Label",
													"value":"${queryCondition.tdLabelValue}:"
												},
												"type":"ui",
												"uiType":"Label"
											}],
											"componentModelId":"uicomponent.layout.component.tableLayout",
											"id":"tdid-${queryCondition.tdLabelId}",
											"options":{
												"text-align":"right",
												"width":"${queryCondition.tdLabelWidth}"
											},
											"type":"layout",
											"uiType":"td"
										},
										{
											"children":[{
												"children":[],
												"componentModelId":"${queryCondition.componentModelId}",
												"id":"uiid-${queryCondition.tdConditionId}",
												"options":{${queryCondition.options}},
												"type":"ui",
												"uiType":"${queryCondition.tdUiType}"
											}],
											"componentModelId":"uicomponent.layout.component.tableLayout",
											"id":"tdid-${queryCondition.tdDataBindId}",
											"options":{
												"colspan":${queryCondition.tdColspan},
												"text-align":"left",
												"width":"${queryCondition.tdWidth}"
											},
											"type":"layout",
											"uiType":"td"
										}
										<#else>
										<#-- 跨列时填充空白单元格 -->							
										{
											"children":[],
											"componentModelId":"uicomponent.layout.component.tableLayout",
											"id":"tdid-${queryCondition.tdDataBindId1}",
											"options":{
												"colspan":${queryCondition.colspan},
												"text-align":"left"
											},
											"type":"layout",
											"uiType":"td"
										},
										{
											"children":[],
											"componentModelId":"uicomponent.layout.component.tableLayout",
											"id":"tdid-${queryCondition.tdDataBindId2}",
											"options":{
												"colspan":${queryCondition.colspan},
												"text-align":"left"
											},
											"type":"layout",
											"uiType":"td"
										}
									</#if>
									<#if queryCondition_has_next>,</#if>
								</#list>
								<#-- td 循环结束-->
								],
								"id":"trid-${trCondition.trId}",
								"options":{
									"uitype":"tr"
								},
								"type":"layout",
								"uiType":"tr"
							}
							<#if trCondition_has_next>,</#if>
						</#list>
							<#-- tr循环结束-->
							],
						"id":"tableid-${editData.tableId}",
						"componentModelId":"uicomponent.layout.component.formLayout",
						"options":{
							"bindObject":"${editData.bindObject}",
							"children":"${editData.children}",
							"class":"form-table",
							"col":${editData.col},
							"label":"快速表单布局区域",
							"objectId":"${editData.objectId}",
							"uitype":"formLayout"
						},
						"type":"layout",
						"uiType":"table"
					}
				</#if>
				<#-- 编辑列表 -->
				<#if editData.uitype=="editGridCodeArea">
					{
						"children":[{
							"children":[{
								"children":[
									{
										"children":[],
										"componentModelId":"uicomponent.bestPractice.editGridFunc.component.addButtonOnEditGrid",
										"id":"${editData.editGridAddButtonUIID}",
										"options":{
											"id":"${editData.editGridAddButtonId}",
											"label":"新增",
											"name":"add${editData.editGridAddButtonId}",
											"on_click":"${editData.editGridAddActionName}",
											"on_click_id":"${editData.editGridAddActionId}",
											"uitype":"Button"
										},
										"type":"ui",
										"uiType":"Button"
									},
									{
										"children":[],
										"componentModelId":"uicomponent.bestPractice.editGridFunc.component.deleteButtonOnEditGrid",
										"id":"${editData.editGridDelButtonUIID}",
										"options":{
											"id":"${editData.editGridDelButtonId}",
											"label":"删除",
											"name":"delete${editData.editGridDelButtonId}",
											"on_click":"${editData.editGridDelActionName}",
											"on_click_id":"${editData.editGridDelActionId}",
											"uitype":"Button"
										},
										"type":"ui",
										"uiType":"Button"
									}
								],
								"componentModelId":"uicomponent.layout.component.tableLayout",
								"id":"tdid-${editData.editGridOperationTd}",
								"options":{
									"label":"单元格",
									"text-align":"left",
									"uitype":"Td"
								},
								"type":"layout",
								"uiType":"td"
							}],
							"id":"trid-${editData.editGridOperationTr}",
							"options":{
								"uitype":"tr"
							},
							"type":"layout",
							"uiType":"tr"
						}],
						"id":"tableid-${editData.editGridOperationTable}",
						"options":{
							"label":"表格布局",
							"uitype":"table"
						},
						"type":"layout",
						"uiType":"table"
					},
					{
						"children":[{
							"children":[{
								"children":[{
									"children":[],
									"componentModelId":"uicomponent.common.component.editableGrid",
									"id":"${editData.editGridId}",
									"options":{
										"columns":"${editData.columns}",
										"custom_pagesize":false,
										<#-- 实体之间关联关系 -->
										"databind":"${editData.databind}",
										"datasource":"cap.editGridDatasource",
										"datasource_id":"cap.editGridDatasource",
										"edittype":"${editData.edittype}",
										"extras":"${editData.extras}",
										"label":"根据关系生成明细集合",
										"lazy":true,
										"name":"ItemByRelations",
										"pagination":true,
										"primarykey":"<#if editData.primarykey??>${editData.primarykey}<#else></#if>",
										"resizeheight":"getBodyHeight",
										"resizeheight_id":"getBodyHeight",
										"resizewidth":"getBodyWidth",
										"resizewidth_id":"getBodyWidth",
										"selectrows":"<#if editData.selectrows??>${editData.selectrows}<#else>multi</#if>",
										"uitype":"EditableGrid",
										"validate":""
									},
									"type":"ui",
									"uiType":"EditableGrid"
								}],
								"componentModelId":"uicomponent.layout.component.tableLayout",
								"id":"tdid-${editData.editGridTd}",
								"options":{
									"label":"单元格",
									"uitype":"Td"
								},
								"type":"layout",
								"uiType":"td"
							}],
							"id":"trid-${editData.editGridTr}",
							"options":{
								"uitype":"tr"
							},
							"type":"layout",
							"uiType":"tr"
						}],
						"id":"tableid-${editData.tableId}",
						"options":{
							"label":"表格布局",
							"uitype":"table"
						},
						"type":"layout",
						"uiType":"table"
					}
				</#if>
				<#if editData_has_next>,</#if>
			</#list>
		</#if>
		<#-- 页面布局结束-->
		],
		"options":{}
	},
	"menuName":"${menuName}",
	"menuType":"<#if menuType??>${menuType}<#else>1</#if>",
	"minWidth":"<#if minWidth??>${minWidth}<#else>1024px</#if>",
	"modelId":"${modelId}",
	"modelName":"${modelName}",
	"modelPackage":"${modelPackage}",
	"modelPackageId":"${modelPackageId}",
	"modelType":"${modelType}",
	"pageActionVOList":[
		<#-- 页面行为集合 -->
		<#if dataStoreList??>
			<#if dataStoreList.dataEntityList??>,
				<#list dataStoreList.dataEntityList as dataStore>
					<#if dataStore.suffix=="editEntity">
						<#assign queryEntityId= dataStore.modelId>
						<#assign editEntity = dataStore.engName>
					</#if>
				</#list>
			</#if>
		</#if>	
		{
			"cname":"页面初始化数据加载行为",
			"description":"页面初始化数据加载行为",
			"ename":"pageInitLoadData",
			"methodBody":"",
			"methodBodyExtend":{
				"before":"",
				"changeDefaultValue":"",
				"changeExpression":"",
				"dataLoadAfter":"",
				"errorHandler":"",
				"setDataAfter":"",
				"setDataBefore":""
			},
			"methodOption":{
				"actionMethodName":<#if isCascadeOperation??>"cascadeQuery"<#else>"loadById"</#if>,
				<#if queryAliasEntityId??>"aliasEntityId":"${queryAliasEntityId}",</#if>
				"entityId":"${queryEntityId}",
				"isGenerateParameterForm":"true",
				"methodId":<#if isCascadeOperation??>"${queryEntityId}/cascadeQuery"<#else>"${queryEntityId}/loadById"</#if>,

				"methodParameter":"{{methodOption.methodParameter1}}",
				"methodParameter1":"primaryValue",
				"paramType":"[{\"chName\":\"主键\",\"dataType\":{\"generic\":null,\"source\":\"primitive\",\"type\":\"String\",\"value\":null},\"description\":\"\",\"engName\":\"id\",\"parameterId\":\"1446454801760\",\"sortNo\":0}]",
				"returnSource":"javaObject",
				"returnValueBind":"${editEntity}"
			},
			"methodTemplate":"actionlibrary.formAction.action.pageInitLoadData",
			"pageActionId":"1448353274443"
		},
		{
			"cname":"保存表单行为",
			"description":"保存表单行为",
			"ename":"saveForm",
			"methodBody":"",
			"methodBodyExtend":{
				"before":"",
				"end":"",
				"saveErrorHandler":"",
				"sendBefore":"",
				"setDataBefore":"",
				"setReturnVal":""
			},
			"methodOption":{
				"actionMethodName":<#if isCascadeOperation??>"cascadeSave"<#else>"save"</#if>,
				"actionType":"save",
				<#if queryAliasEntityId??>"aliasEntityId":"${queryAliasEntityId}",</#if>
				"entityId":"${queryEntityId}",
				"isGenerateParameterForm":"true",
				"methodId":<#if isCascadeOperation??>"${queryEntityId}/cascadeSave"<#else>"${queryEntityId}/save"</#if>,
				"methodParameter":"{{methodOption.methodParameter1}}",
				"methodParameter1":"${editEntity}",
				"paramType":"[{\"chName\":\"保存的对象\",\"dataType\":{\"generic\":null,\"source\":\"javaObject\",\"type\":\"java.lang.Object\",\"value\":\"\"},\"description\":\"保存的对象\",\"engName\":\"vo\",\"parameterId\":\"1446454497214\",\"sortNo\":0}]",
				"returnSource":"primitive",
				"returnValueBind":"<#if queryEntityPrimaryKey??>${editEntity}.${queryEntityPrimaryKey}<#else></#if>",
				"saveContinue":2,
				"successMessage":"保存成功！"
			},
			"methodTemplate":"actionlibrary.formAction.action.saveForm",
			"pageActionId":"14464531293370"
		},
		{
			"cname":"点击按钮跳转页面",
			"description":"点击按钮跳转页面",
			"ename":"backTo",
			"methodBody":"",
			"methodBodyExtend":{
				"before":""
			},
			"methodOption":{
				"container":"window",
				"pageURL":"${listURLConstant}",
				"saveQueryData":"yes",
				"target":"location"
			},
			"methodTemplate":"actionlibrary.bestPracticeAction.action.addBizObject",
			"pageActionId":"14464534943810"
		}
		<#-- 行操作行为 -->
		<#if editArea??>
			<#list editArea as editData>
				<#if editData.uitype=="editGridCodeArea">
					,
					{
						"cname":"editGrid新增事件",
						"description":"editGrid新增事件",
						"ename":"${editData.editGridAddActionName}",
						"methodBody":"",
						"methodBodyExtend":{
							"before":""
						},
						"methodOption":{
						    "actionType":"insertGrid",
							"relationGridId":"${editData.editGridId}"
						},
						"methodTemplate":"actionlibrary.bestPracticeAction.editGridAction.action.editGridAdd",
						"pageActionId":"${editData.editGridAddActionId}"
					},
					{
						"cname":"editGrid删除事件",
						"description":"editGrid删除事件",
						"ename":"${editData.editGridDelActionName}",
						"methodBody":"",
						"methodBodyExtend":{
							"before":""
						},
						"methodOption":{
						    "actionType":"deleteGrid",
							"relationGridId":"${editData.editGridId}"
						},
						"methodTemplate":"actionlibrary.bestPracticeAction.editGridAction.action.editGridDelete",
						"pageActionId":"${editData.editGridDelActionId}"
					}
				</#if>
			</#list>
		</#if>
		<#-- 循环判断是否增加列渲染方法 -->
		<#if editGridRender??>
			<#list editGridRender as render>
				<#if render.gridDicRender??>
					,{
						"cname":"grid字典渲染",
						"description":"grid字典数据列渲染",
						"ename":"${render.gridDicRender}",
						"methodBody":"",
						"methodBodyExtend":{
							"after":""
						},
						"methodOption":{},
						"methodTemplate":"actionlibrary.bestPracticeAction.gridAction.action.gridDicRender",
						"pageActionId":"${render.pageActionId}"
					}
				</#if>
				<#if render.gridEditLinkRender??>
					,{
						"cname":"grid编辑链接渲染",
						"description":"grid编辑链接渲染",
						"ename":"${render.gridEditLinkRender}",
						"methodBody":"",
						"methodBodyExtend":{
							"after":"",
							"before":""
						},
						"methodOption":{
							"container":"window",
							"pageURL":"",
							"target":"win"
						},
						"methodTemplate":"actionlibrary.bestPracticeAction.gridAction.action.gridEditLinkRender",
						"pageActionId":"${render.pageActionId}"
					}
				</#if>
				<#if render.gridViewLinkRender??>
					,{
						"cname":"grid查看链接渲染",
						"description":"grid查看链接渲染",
						"ename":"${render.gridViewLinkRender}",
						"methodBody":"",
						"methodBodyExtend":{
							"before":"",
							"setURL":""
						},
						"methodOption":{
							"container":"window",
							"pageURL":"",
							"target":"win"
						},
						"methodTemplate":"actionlibrary.bestPracticeAction.gridAction.action.gridViewLinkRender",
						"pageActionId":"${render.pageActionId}"
					}
				</#if>
				<#if render.gridWftLinkRender??>
					,{
						"cname":"grid流程链接渲染",
						"description":"grid流程链接渲染",
						"ename":"${render.gridWftLinkRender}",
						"methodBody":"",
						"methodBodyExtend":{
							"after":"",
							"before":""
						},
						"methodOption":{},
						"methodTemplate":"actionlibrary.bestPracticeAction.gridAction.action.gridWftLinkRender",
						"pageActionId":"${render.pageActionId}"
					}
				</#if>
				<#if render.gridImgRender??>
					,{
						"cname":"grid图片渲染",
						"description":"grid图标渲染",
						"ename":"${render.gridImgRender}",
						"methodBody":"",
						"methodBodyExtend":{
							"after":"",
							"before":""
						},
						"methodOption":{},
						"methodTemplate":"actionlibrary.bestPracticeAction.gridAction.action.gridImgRender",
						"pageActionId":"${render.pageActionId}"
					}
				</#if>
				<#if render.gridOnstatuschange??>
					,{
						"cname":"grid默认持久化-状态变化",
						"description":"grid默认持久化-状态变化",
						"ename":"${render.gridOnstatuschange}",
						"methodBody":"",
						"methodBodyExtend":{},
						"methodOption":{
							"container":"window",
							"pageURL":"",
							"target":"_self"
						},
						"methodTemplate":"actionlibrary.bestPracticeAction.gridAction.action.gridPersistentDefaultOnstatuschange",
						"pageActionId":"${render.pageActionId}"
					}
				</#if>
				<#if render.gridConfig??>
				,{
					"cname":"grid默认持久化-配置数据",
					"description":"grid默认持久化-配置数据",
					"ename":"${render.gridConfig}",
					"methodBody":"",
					"methodBodyExtend":{},
					"methodOption":{},
					"methodTemplate":"actionlibrary.bestPracticeAction.gridAction.action.gridPersistentDefaultConfig",
					"pageActionId":"${render.pageActionId}"
				}
				</#if>
				<#if render.gridWftCurNodeTrackRender??>
					,{
						"cname":"grid待办停留节点及跟踪列渲染",
						"description":"grid待办停留节点及跟踪列渲染",
						"ename":"${render.gridWftCurNodeTrackRender}",
						"methodBody":"",
						"methodBodyExtend":{
							"after":"",
							"before":""
						},
						"methodOption":{},
						"methodTemplate":"actionlibrary.bestPracticeAction.gridAction.action.gridWftCurNodeTrackRender",
						"pageActionId":"${render.pageActionId}"
					}
				</#if>
			</#list>
		</#if>
	],
	"pageAttributeVOList":[
		<#-- 页面参数集合 -->
		{
			"attributeDescription":"primaryValue",
			"attributeName":"primaryValue",
			"attributeType":"String",
			"attributeValue":"",
			"defaultReference":false,
			"userDefined":true
		},
		{
			"attributeDescription":"页面模式",
			"attributeName":"pageMode",
			"attributeSelectValues":"[{id:'readonly',text:'只读模式'},{id:'edit',text:'编辑模式'},{id:'textmode',text:'文本模式'}]",
			"attributeType":"String",
			"attributeValue":"edit",
			"defaultReference":false,
			"userDefined":false
		}
		
	],
	"pageComponentExpressionVOList":[
		<#-- 循环状态集合-->
		{
			"expression":"pageMode=='readonly'",
			"expressionId":"1453973800295",
			"expressionType":"js",
			"hasSetState":true,
			"pageComponentStateList":[
				<#if editArea??>
					<#list editArea as editData>
					<#if editData.uitype=="editGridCodeArea">
				{
					"componentId":"uiid-53471470542717725",
					"hasValidate":false,
					"state":"hide"
				}
					,
					{
						"componentId":"${editData.editGridAddButtonUIID}",
						"hasValidate":false,
						"state":"hide"
					},
					{
						"componentId":"${editData.editGridDelButtonUIID}",
						"hasValidate":false,
						"state":"hide"
					}
					</#if>
					</#list>
				</#if>
			]
		}
	],
	"pageId":"${pageId}",
	"pageType":<#if pageType??>${pageType}<#else>1</#if>,
	"parentId":"${parentId}",
	"parentName":"${parentName}",
	"pageUIType":"eidtPage",
	"url":"${url}"
}