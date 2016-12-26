{
	"charEncode":"<#if charEncode??>${charEncode}<#else>UTF-8</#if>",
	"cname":"${cname}待办页面",
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
				<#-- 隐藏查询条件常量 -->
				{
					"constantDescription":"隐藏查询条件",
					"constantName":"hideQueryCondition",
					"constantOption":{},
					"constantType":"String",
					"constantValue":"hide"
				}
				<#if dataStoreList.pageConstant??>
					<#assign constantName=dataStoreList.pageConstant.constantName>
					<#assign constantPageModelId=dataStoreList.pageConstant.pageModelId>
					<#assign constantUrl=dataStoreList.pageConstant.url>
						,{
							"constantDescription":"编辑页面",
							"constantName":"${constantName}EditPage",
							"constantOption":{
								"pageAttributeVOList":"[{\"attributeName\":\"primaryValue\",\"attributeDescription\":\"primaryValue\",\"attributeValue\":\"\"},{\"attributeName\":\"pageMode\",\"attributeDescription\":\"页面模式\",\"attributeValue\":\"\"}]",
								"pageModelId":"${constantPageModelId}EditPageForWorkFlow",
								"url":"${constantUrl}EditPageForWorkFlow${pageUrlSuffix}"
							},
							"constantType":"url",
							"constantValue":"'${constantUrl}EditPageForWorkFlow${pageUrlSuffix}'"
						},
						{
							"constantDescription":"查看页面",
							"constantName":"${constantName}ViewPage",
							"constantOption":{
								"pageAttributeVOList":"[{\"attributeName\":\"primaryValue\",\"attributeDescription\":\"primaryValue\",\"attributeValue\":\"\"},{\"attributeName\":\"pageMode\",\"attributeDescription\":\"页面模式\",\"attributeValue\":\"\"}]",
								"pageModelId":"${constantPageModelId}EditPageForWorkFlow",
								"url":"${constantUrl}EditPageForWorkFlow${pageUrlSuffix}"
							},
							"constantType":"url",
							"constantValue":"'${constantUrl}EditPageForWorkFlow${pageUrlSuffix}'"
						}
						<#-- 编辑链接变量 -->
						<#assign editURLConstant= constantName+"EditPage">
						<#-- 查看链接变量 -->
						<#assign viewURLConstant= constantName+"ViewPage">
					<#else>
						<#-- 编辑链接变量 -->
						<#assign editURLConstant= "">
						<#-- 查看链接变量 -->
						<#assign viewURLConstant= "">
				</#if>
			</#if>
			],
			"verifyIdList":[]
		}
		<#-- 用户自定义数据模型列表 -->
		<#if dataStoreList??>
			<#if dataStoreList.dataEntityList??>,
				<#list dataStoreList.dataEntityList as dataStore>
					<#if dataStore.suffix=="editEntity">
						{
							"cname":"${dataStore.chName}",
							"ename":"${dataStore.engName}",
							"entityId":"${dataStore.modelId}",
							"modelType":"object",
							"pageConstantList":[],
							"verifyIdList":[]
						},
						{
							"cname":"${dataStore.chName}集合",
							"ename":"${dataStore.engName}List",
							"entityId":"${dataStore.modelId}",
							"modelType":"list",
							"pageConstantList":[],
							"verifyIdList":[]
						}
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
	],
	"layoutVO":{
		"children":[
		<#-- 页面布局开始 -->	
		<#-- 查询区域开始 -->	
		<#if queryArea??>
		<#-- 固定查询区域table -->
			<#if queryArea.fixed??>
				{
					"children":[
					<#-- tr 循环-->
					<#-- 定义控制行列循环次数变量 -->
					<#list queryArea.fixed.dataList as trCondition>
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
					"id":"tableid-4294206428807229",
					"componentModelId":"uicomponent.layout.component.formLayout",
					"options":{
						"bindObject":"${queryArea.fixed.bindObject}",
						"children":"${queryArea.fixed.children}",
						"class":"form-table",
						"col":${queryArea.fixed.col},
						"label":"快速表单布局区域",
						"objectId":"${queryArea.fixed.objectId}",
						"uitype":"formLayout"
					},
					"type":"layout",
					"uiType":"table"
				}
			</#if>		
			<#-- 更多查询区域table -->
			<#if queryArea.detail??>
				<#if queryArea.fixed??>
					,
				</#if>
				{
					"children":[
					<#-- tr 循环-->
					<#-- 定义控制行列循环次数变量 -->
					<#list queryArea.detail.dataList as trCondition>
					{
						"children":[
							<#-- td 循环-->
							<#list trCondition.listQueryConditions as queryCondition>
								<#if queryCondition.tdDataBind??>
								{
									"children":[
										{
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
										}
									],
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
					"id":"tableid-4294206428807329",
					"componentModelId":"uicomponent.layout.component.formLayout",
					"options":{
						"bindObject":"${queryArea.detail.bindObject}",
						"children":"${queryArea.detail.children}",
						"class":"form-table",
						"col":${queryArea.detail.col},
						"label":"快速表单布局区域",
						"objectId":"${queryArea.detail.objectId}",
						"uitype":"formLayout"
					},
					"type":"layout",
					"uiType":"table"
				}
			</#if>		
			<#-- 查询操作按钮 -->
			<#-- 固定查询区域table -->
			<#if queryArea.fixed??>
				,{
						"children":[{
							"children":[{
								"children":[
									{
										"children":[],
										"componentModelId":"uicomponent.common.component.button",
										"id":"uiid-6003615445457399",
										"options":{
											"id":"btnQuery",
											"label":"查询",
											"name":"btnQuery",
											"on_click":"queryData",
											"on_click_id":"14460895830610",
											"uitype":"Button"
										},
										"type":"ui",
										"uiType":"Button"
									},
									{
										"children":[],
										"componentModelId":"uicomponent.common.component.button",
										"id":"uiid-7104350049514323",
										"options":{
											"id":"btnClearQuery",
											"label":"清空条件",
											"name":"btnClearQuery",
											"on_click":"clearQueryCondition",
											"on_click_id":"14460895850190",
											"uitype":"Button"
										},
										"type":"ui",
										"uiType":"Button"
									}
									<#if queryArea.detail??>,
									{
										"children":[],
										"componentModelId":"uicomponent.common.component.button",
										"id":"uiid-42971183124464005",
										"options":{
											"id":"moreCondition",
											"label":"更多▼",
											"name":"moreCondition",
											"on_click":"moreCondition",
											"on_click_id":"14460895870410",
											"uitype":"Button"
										},
										"type":"ui",
										"uiType":"Button"
									}
									</#if>
								],
								"componentModelId":"uicomponent.layout.component.tableLayout",
								"id":"tdid-9530447873519734",
								"options":{
									"label":"单元格",
									"text-align":"right",
									"uitype":"Td"
								},
								"type":"layout",
								"uiType":"td"
							}],
							"id":"trid-36580671849660575",
							"options":{
								"uitype":"tr"
							},
							"type":"layout",
							"uiType":"tr"
						}],
						"id":"tableid-3560829809634015",
						"options":{
							"label":"表格布局",
							"uitype":"table"
						},
						"type":"layout",
						"uiType":"table"
				 }			
			</#if>
		</#if>
		<#-- 页面操作按钮 -->
		<#if gridColumns??>,
		{
				"children":[{
					"children":[{
						"children":[
							{
								"children":[],
								"componentModelId":"uicomponent.bestPractice.listFunc.component.sendListButton",
								"id":"uiid-4819941021036357",
								"options":{
									"id":"btnSendOnList",
									"label":"发送",
									"name":"btnSendOnList",
									"on_click":"sendListData",
									"on_click_id":"14464552121320",
									"uitype":"Button"
								},
								"type":"ui",
								"uiType":"Button"
							},
							{
								"children":[],
								"componentModelId":"uicomponent.bestPractice.listFunc.component.reassignListButton",
								"id":"uiid-1922948023537174",
								"options":{
									"id":"btnReassignOnList",
									"label":"转发",
									"name":"btnReassignOnList",
									"on_click":"reassignListData",
									"on_click_id":"14464552185300",
									"uitype":"Button"
								},
								"type":"ui",
								"uiType":"Button"
							},
							{
								"children":[],
								"componentModelId":"uicomponent.bestPractice.listFunc.component.backListButton",
								"id":"uiid-4897895335685462",
								"options":{
									"id":"btnBackOnList",
									"label":"回退",
									"name":"btnBackOnList",
									"on_click":"backListData",
									"on_click_id":"14464552158190",
									"uitype":"Button"
								},
								"type":"ui",
								"uiType":"Button"
							}
						],
						"componentModelId":"uicomponent.layout.component.tableLayout",
						"id":"tdid-9503868613392115",
						"options":{
							"label":"单元格",
							"text-align":"left",
							"uitype":"Td"
						},
						"type":"layout",
						"uiType":"td"
					}],
					"id":"trid-3620610850630328",
					"options":{
						"uitype":"tr"
					},
					"type":"layout",
					"uiType":"tr"
				}],
				"id":"tableid-6953745172126219",
				"options":{
					"label":"表格布局",
					"uitype":"table"
				},
				"type":"layout",
				"uiType":"table"
		},
		<#-- 列表grid -->
		{
			"children":[{
				"children":[{
					"children":[{
						"children":[],
						"componentModelId":"uicomponent.common.component.grid",
						"id":"uiid-2007403086638078",
						"options":{
							"columns":"${gridColumns}",
							"custom_pagesize":false,
							"datasource":"gridDatasource",
							"datasource_id":"1445823846608",
							"extras":"${gridExtras}",
							"gridheight":"auto",
							"label":"网格",
							"lazy":true,
							"pagination":true,
							"primarykey":"<#if primarykey??>${primarykey}<#else></#if>",
							"resizeheight":"getBodyHeight",
							"resizeheight_id":"getBodyHeight",
							"resizewidth":"getBodyWidth",
							"resizewidth_id":"getBodyWidth",
							"selectrows":"<#if gridSelectrows??>${gridSelectrows}<#else>multi</#if>",
							"uitype":"Grid"
						},
						"type":"ui",
						"uiType":"Grid"
					}],
					"componentModelId":"uicomponent.layout.component.tableLayout",
					"id":"tdid-656892663310282",
					"options":{
						"label":"单元格",
						"uitype":"Td"
					},
					"type":"layout",
					"uiType":"td"
				}],
				"id":"trid-21558110357727855",
				"options":{
					"uitype":"tr"
				},
				"type":"layout",
				"uiType":"tr"
			}],
			"id":"tableid-8942423102911562",
			"options":{
				"label":"表格布局",
				"uitype":"table"
			},
			"type":"layout",
			"uiType":"table"
		}
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
						<#assign queryEntity= dataStore.engName>
					</#if>
				</#list>
			</#if>
		</#if>	
		<#-- grid初始化查询行为 -->
		{
			"cname":"grid初始化查询行为",
			"description":"列表查询行为方法",
			"ename":"gridDatasource",
			"methodBody":"",
			"methodBodyExtend":{
				"before":"",
				"initParam":"",
				"saveErrorHandler":"",
				"setDataAfter":"",
				"setDataBefore":""
			},
			"methodOption":{
				"actionMethodName":"queryTodoVOListByPage",
				<#if queryAliasEntityId??>"aliasEntityId":"${queryAliasEntityId}",</#if>
				"entityId":"${queryEntityId}",
				"isGenerateParameterForm":"true",
				"methodId":"${queryEntityId}/queryTodoVOListByPage",
				"methodParameter":"{{methodOption.methodParameter1}}",
				"methodParameter1":"${queryEntity}",
				"paramType":"[{\"chName\":\"查询条件\",\"dataType\":{\"generic\":null,\"source\":\"javaObject\",\"type\":\"java.lang.Object\",\"value\":\"\"},\"description\":\"\",\"engName\":\"condition\",\"parameterId\":\"1446454546153\",\"sortNo\":0}]",
				"requestMode":"true",
				"returnSource":"collection",
				"returnType":6,
				"returnValueBind":"${queryEntity}List",
				"saveQueryData":"yes"
			},
			"methodTemplate":"actionlibrary.bestPracticeAction.gridAction.action.gridDatasource",
			"pageActionId":"1445823846608"
		},
		{
			"cname":"条件查询事件-查询数据",
			"description":"条件查询事件-查询数据",
			"ename":"queryData",
			"methodBody":"",
			"methodBodyExtend":{
				"step1":""
			},
			"methodOption":{
				"relationGridId":"uiid-2007403086638078"
			},
			"methodTemplate":"actionlibrary.bestPracticeAction.action.queryData",
			"pageActionId":"14460895830610"
		},
		{
			"cname":"条件查询事件-清空条件",
			"description":"条件查询事件-清空条件",
			"ename":"clearQueryCondition",
			"methodBody":"",
			"methodBodyExtend":{
				"step1":"",
				"step2":"",
				"step3":""
			},
			"methodOption":{
				"queryCondition":"${queryEntity}",
				"relationGridId":"uiid-2007403086638078"
			},
			"methodTemplate":"actionlibrary.bestPracticeAction.action.clearQueryCondition",
			"pageActionId":"14460895850190"
		},
		{
			"cname":"更多查询",
			"description":"更多查询",
			"ename":"moreCondition",
			"methodBody":"",
			"methodBodyExtend":{},
			"methodOption":{
				"relationGridId":"tableid-4294206428807329"
			},
			"methodTemplate":"actionlibrary.bestPracticeAction.action.moreCondition",
			"pageActionId":"14460895870410"
		},
		{
			"cname":"列表页面流程发送行为",
			"description":"列表页面流程发送行为，一般在列表页面使用",
			"ename":"sendListData",
			"methodBody":"",
			"methodBodyExtend":{
				"callBack":"",
				"check":"",
				"successAfter":"",
				"successBefore":""
			},
			"methodOption":{
				"relationGridId":"uiid-2007403086638078",
				"actionType":"send",
				"workflowMethod":"send"
			},
			"methodTemplate":"actionlibrary.workflow.action.auditList",
			"pageActionId":"14464552121320"
		},
		{
			"cname":"列表页面流程回退行为",
			"description":"列表页面流程回退行为，一般在列表页面使用",
			"ename":"backListData",
			"methodBody":"",
			"methodBodyExtend":{
				"callBack":"",
				"check":""
			},
			"methodOption":{
				"relationGridId":"uiid-2007403086638078",
				"actionType":"back",
				"workflowMethod":"back"
			},
			"methodTemplate":"actionlibrary.workflow.action.auditList",
			"pageActionId":"14464552158190"
		},
		{
			"cname":"列表页面流程转发行为",
			"description":"列表页面流程转发行为，一般在列表页面使用",
			"ename":"reassignListData",
			"methodBody":"",
			"methodBodyExtend":{
				"callBack":"",
				"check":""
			},
			"methodOption":{
				"relationGridId":"uiid-2007403086638078",
				"workflowMethod":"reassign"
			},
			"methodTemplate":"actionlibrary.workflow.action.auditList",
			"pageActionId":"14464552185300"
		}
		<#-- 循环判断是否增加列渲染方法 -->
		<#if gridRender??>
			<#list gridRender as render>
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
						    "actionType":"editLink",
							"container":"window",
							"pageURL":"${editURLConstant}",
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
							"pageURL":"${viewURLConstant}",
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
	],
	"pageComponentExpressionVOList":[
		<#-- 固定隐藏查询条件 -->
		{	
			"expression":"hideQueryCondition=='hide'",
			"expressionId":"1446087535170",
			"expressionType":"js",
			"hasSetState":true,
			"pageComponentStateList":[{
				"componentId":"tableid-4294206428807329",
				"hasValidate":false,
				"state":"hide"
			}]
		}
		<#-- 循环状态集合-->
		
	],
	"pageId":"${pageId}",
	"pageType":<#if pageType??>${pageType}<#else>1</#if>,
	"parentId":"${parentId}",
	"parentName":"${parentName}",
	"pageUIType":"todoListPage",
	"url":"${url}"
}