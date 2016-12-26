﻿
<%
/**********************************************************************
* 元数据建模：实体方法列表
* 2015-10-13 凌晨 新建
* 2016-06-06 许畅 修改
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!doctype html>
<html ng-app='entityMethodList'>
<head>
	<meta charset="UTF-8"/>
    <title>实体方法</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>
  	<top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
  	<top:link href="/cap/bm/dev/entity/css/queryModel.css"></top:link>
    <style type="text/css">
    	.CodeMirror {
			height: 100px;
		}
		
		.right-area{
			border: 1px solid #ccc;
			height: 100px;
			width: 100%;
			overflow:auto;
		}
		
      .CodeMirror-fullscreen {
        display: block;
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        z-index: 9999;
      }
      #addMethodSQL .button-label{
      	 color:red;
      }
      #overrideParent{
      	color:red;
      	font-family:微软雅黑;
      	cursor: pointer;
      }
      #javaMethodName .cui_inputCMP_wrap{
      	background:#ffffff;
      }
    </style>
    
    <script type="text/javascript">
	//获得传递参数
	var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
	var checkUrl = "<%=request.getContextPath() %>/cap/bm/dev/consistency/ConsistencyCheckResult.jsp?checkType=main&init=true";
	var isSubQuery=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("isSubQuery"))%>;
	</script>
    
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/base/js/validate.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/easy.js"></top:script>
	
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/mode/sql/sql.js"></top:script>
	
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityOperateAction.js"></top:script>
	<top:script src="/cap/dwr/interface/QueryPreviewFacade.js"></top:script>
	
	<top:script src="/cap/bm/dev/entity/js/entityMethodList.js"></top:script>
	<top:script src="/cap/bm/dev/entity/js/queryModel.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="entityMethodController" data-ng-init="ready()">
<div class="cap-area" ng-style="selectEntityMethodVO.methodId ? {display:'table-cell'} : {display:'block'};">
	<table class="cap-table-fullWidth">
    	<tr>
        	<td class="cap-td" style="text-align: left;width:350px;min-width:350px;padding-right: 5px">
        		<div>
        			<ul class="tab"> 	
						<li ng-class="{'method':'active'}[active]" ng-click="showPanel('method')">实体方法</li>
						<li ng-class="{'parentMethod':'active'}[active]" ng-click="showPanel('parentMethod')">父实体方法</li>
					</ul>
        		</div>
        		<!-- 本实体方法列表 -->
        		<div ng-show="active=='method'">
        			<table>
	        			<tr>
					    	<td class="cap-form-td" style="text-align: right;" nowrap="nowrap">
					    		<span cui_input  id="filterChar" ng-model="filterChar" width="180px" emptytext="请输入方法英文/中文名称" style="float:left"></span>
					            <span cui_button id="add" ng-click="addEntityMethod()" label="新增"></span>
				        	    <span uitype="button" id="copy" label="复制" ng-click="copyEntityMethod()"></span>
					            <span cui_button id="delete" ng-click="deleteEntityMethod()" label="删除"></span>
					        </td>
					    </tr>
				    	<tr>
				    		<td class="cap-form-td">
				           		<table class="custom-grid" style="width: 100%">
				                	<thead>
				                    	<tr>
					                    	<th style="width:30px">
					                    		<input type="checkbox" name="objCheckAll.entityMethodsCheckAll" ng-model="objCheckAll.entityMethodsCheckAll" ng-change="allCheckBoxCheck(root.entityMethods,objCheckAll.entityMethodsCheckAll)" ng-hide="filterChar">
					                        </th>
					                        <th>
				                            	方法名称
					                        </th>
					                        <th>
				                            	中文名称
					                        </th>
				                    	</tr>
				                	</thead>
			                        <tbody>
			                            <tr ng-repeat="entityMethodVo in  root.entityMethods track by $index" ng-if="!entityMethodVo.isFilter && entityMethodVo.methodId.indexOf('count') == -1 && entityMethodVo.methodId.indexOf('pagination') == -1" style="background-color: {{selectEntityMethodVO.methodId == entityMethodVo.methodId ? '#99ccff' : '#ffffff'}}">
			                            	<td style="text-align: center;">
			                                    <input type="checkbox" name="{{'entityMethodVo'+($index + 1)}}" ng-model="entityMethodVo.check" ng-change="checkBoxCheck(root.entityMethods,'objCheckAll.entityMethodsCheckAll')">
			                                </td>
			                                <td style="text-align:left;cursor:pointer" ng-click="methodTdClick(entityMethodVo,false)">
			                                    {{entityMethodVo.engName}}
			                                </td>
			                                <td style="text-align: center;" ng-click="methodTdClick(entityMethodVo,false)">
			                                    {{entityMethodVo.chName}}
			                                </td>
			                            </tr>
			                            <tr ng-if="!hasMethod()">
			                            	<td colspan="3" class="grid-empty"> 本列表暂无记录</td>
			                            </tr>
			                       </tbody>
				            	</table>
				    		</td>
				    	</tr>
        			</table>
        		</div>
        		<!-- 父实体方法列表 -->
	        	<div ng-show="active=='parentMethod'">
	        		<table>
					    <tr>
					    	<td class="cap-form-td">
					            <table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                    	<th style="width:52px">
					                        </th>
					                        <th>
				                            	方法名称
					                        </th>
					                        <th>
				                            	中文名称
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="pEntityMethodVo in  parentEntityMethods" style="background-color: {{selectEntityMethodVO.methodId == pEntityMethodVo.methodId ? '#99ccff' : '#ffffff'}}">
			                                <td style="text-align:left;">
			                                  <input type="button" style="" id="overrideParent" ng-click="overrideParent(pEntityMethodVo)" ng-show="{{(pEntityMethodVo.assoMethodName==null || pEntityMethodVo.assoMethodName=='') 
			                                  && pEntityMethodVo.queryExtend!=null && pEntityMethodVo.queryExtend!='' }}" value="重写"/>
			                                </td>
			                                <td style="text-align:left;cursor:pointer" ng-click="methodTdClick(pEntityMethodVo,true)">
			                                    {{pEntityMethodVo.engName}}
			                                </td>
			                                <td style="text-align: center;" ng-click="methodTdClick(pEntityMethodVo,true)">
			                                    {{pEntityMethodVo.chName}}
			                                </td>
			                            </tr>
			                            <tr ng-if="!parentEntityMethods || parentEntityMethods.length == 0">
			                            	<td colspan="3" class="grid-empty"> 本列表暂无记录</td>
			                            </tr>
			                       </tbody>
					            </table>
					    	</td>
					    </tr>
	        		</table>
	        	</div>
        	</td>
	        <td style="text-align: center;border-left:1px solid #ddd;vertical-align:middle">
	        	<span style="opacity: 0.2;font-size:18px" ng-if="!selectEntityMethodVO.methodId">请新增方法</span>
	        </td>
	        
	        <!-- sql查询重写界面  -->
	        <td id="sqlRewrite" class="cap-td" style="text-align:left;" ng-if="selectEntityMethodVO.queryExtend!=null && !displayPMethod">
	        	 
       	       <table class="cap-table-fullWidth">
       	       	    <tr>
       	       	        <td class="cap-form-td" style="text-align: left;width:70px;">
       	       				<span class="cap-group">基本信息</span>
       	       	        </td>
       	       	        <td style="text-align: right;" ng-if="entitySource !='exist_entity_input'">
       	       	        	<span cui_button id="sqlPreview" ng-click="sqlPreview('isView')" label="SQL预览"></span>
       	       	        </td>
       	       	    </tr>

	        	    <tr ng-show="false">
				        <td class="cap-td" style="text-align:left;" >
				        	重写方法名:
				        </td>
				        <td class="cap-td" style="text-align:left;" >
					        <span cui_input id="methodName" name="methodName" ng-model="selectEntityMethodVO.queryExtend.methodName" readonly="true"></span>
				        </td>
				    </tr>

				    <tr>
		    	        <td class="cap-td" style="text-align:left;" >
		    	        	方法签名:
		    	        </td>
		    	        <td class="cap-td" style="text-align:left;" >
		    		        <span cui_input id="javaMethodName" name="javaMethodName" ng-model="javaMethodName" width="100%" readonly="true"></span>
		    	        </td>
				    </tr>

				    <tr ng-show="entitySource =='exist_entity_input'">
		    	        <td class="cap-td" style="text-align:left;" >
		    	        	selectId:
		    	        </td>
		    	        <td class="cap-td" style="text-align:left;" >
		    		        <span cui_input id="selectId" name="selectId" ng-model="selectEntityMethodVO.queryExtend.selectId" width="25%" ></span>
		    		        <a style="color:red;">注:selectId默认情况下不需要填,它影响生成的sql.xml的select id,如果是特殊命名才需要修改.</a>
		    	        </td>
				    </tr>
		    
				    <tr>
				        <td class="cap-td" colspan="2" style="text-align:left;" >
				        	SQL内容:
				        </td>
				    </tr>
				    <tr>
				        <td class="cap-td" colspan="2" style="text-align:left;" >
					        <div style="overflow: auto;width: 100%;border: 1px solid #ccc;">
					        	<span cui_code id="mybatisSQL" name="mybatisSQL" ng-model="selectEntityMethodVO.queryExtend.mybatisSQL"></span>
					        </div>
				        </td>
				    </tr>
			    </table>
	        </td>
	        
	        
	        <td class="cap-td" style="text-align: left;" ng-show="!displayPMethod && selectEntityMethodVO.methodId && selectEntityMethodVO.queryExtend ==null ">
	        
	        	<table class="cap-table-fullWidth" >
				    <!-- 方法基本信息表单 -->
				    <tr>
				        <td  class="cap-form-td" style="text-align: left;">
							<span class="cap-group">基本信息</span>
							<span cui_button id="addMethodSQL" ng-show="entitySource =='exist_entity_input'" ng-click="editSQL('parent',selectEntityMethodVO)" label="SQL录入"></span>
				        </td>
				    </tr>
				    
				    <tr>
				    	<td style="text-align: left;">
				    		<table class="cap-table-fullWidth">
							   <tr>
							        <td class="cap-td" style="text-align: right;width:15%" nowrap="nowrap">
							        	<font color="red">*</font>方法名称：
							        </td>
							        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
							        	<span cui_input id="engName" ng-model="selectEntityMethodVO.engName" validate="methodEngNameValRule" ng-change="changeAliasName(selectEntityMethodVO.engName)"  width="100%"/>
							        </td>
							        <td class="cap-td" style="text-align: right;width:15%" nowrap="nowrap">
							        	<font color="red">*</font>中文名称：
							        </td>
							         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
						   				<span cui_input id="chName" ng-model="selectEntityMethodVO.chName" validate="methodChNameValRule" width="100%"/>
							        </td>
							    </tr>
							    <tr>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	<font color="red">*</font>访问级别：
							        </td>
							        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
							        	<span cui_pulldown id="accessLevel" mode="Single" value_field="id" label_field="text" editable="false" ng-model="selectEntityMethodVO.accessLevel" width="100%">
											<a value="private">private</a>
											<a value="">default</a>
											<a value="protected">protected</a>
											<a value="public">public</a>
										</span>
							        </td>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	<font color="red">*</font>方法别名：
							        </td>
							         <td class="cap-td" style="text-align: left;" nowrap="nowrap">
						   				<span cui_input id="aliasName" ng-model="selectEntityMethodVO.aliasName" validate="methodAliasNameValRule"  width="100%"/>
							        </td>
							    </tr>
							    <tr>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	<font color="red">*</font>返回值类型：
							        </td>
							        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
							        	<span cui_pulldown id="returnType" mode="Single" value_field="id" label_field="text" editable="false" ng-model="selectEntityMethodVO.returnType.type" ng-change="changeReturnType(selectEntityMethodVO.returnType.type)" readonly="{{selectEntityMethodVO.methodType == 'cascade'}}" width="100%">
											<a value="void">void</a>
											<a value="int">int</a>
											<a value="float">float</a>
											<a value="double">double</a>
											<a value="boolean">boolean</a>
											<a value="String">String</a>
											<a value="java.lang.Object">Object</a>
											<a value="java.util.List">java.util.List</a>
											<a value="java.util.Map">java.util.Map</a>
											<a value="java.sql.Timestamp">java.sql.Timestamp</a>
											<a value="entity">Entity</a>
											<a value="thirdPartyType">第三方类型</a>
										</span>
							        </td>
							        
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap" ng-if="selectEntityMethodVO.returnType.type == 'java.util.List' || selectEntityMethodVO.returnType.type == 'java.util.Map'">
							        	返回值泛型：
							        </td>
							        <td class="cap-td" style="text-align: left;" nowrap="nowrap" ng-show="selectEntityMethodVO.returnType.type == 'java.util.List' || selectEntityMethodVO.returnType.type == 'java.util.Map'">
						   				<!-- <span cui_input id="type1" ng-model="selectEntityMethodVO.returnType.generic[0].value" validate="" width="100%" /> -->
						   				<span cui_clickinput id="type1" ng-model="selectEntityMethodVO.returnType.value" on_iconclick="setAttributeGeneric" width="100%" readonly=""></span>
							        </td>
							        <!-- 
							        <td class="cap-td" style="text-align: left;" nowrap="nowrap" ng-if="selectEntityMethodVO.returnType.type == 'java.util.Map'" colspan="2">
						   				<table style="width:100%">
						   					<tr>
						   						<td style="text-align:left;width:20%"><span cui_input id="keyId" ng-model="selectEntityMethodVO.returnType.generic[0].type" validate="" width="100%" readonly="true"/></td>
						   						<td style="text-align:center;width:8%">,</td>
						   						<td style="text-align:right;width:72%"><span cui_input id="valueId" ng-model="selectEntityMethodVO.returnType.generic[1].value" validate="" width="100%" /></td>
						   					</tr>
						   				</table>
							        </td>
							        -->
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap" ng-if="selectEntityMethodVO.returnType.type == 'entity' || selectEntityMethodVO.returnType.type == 'thirdPartyType'">
							        	<font color="red">*</font>返回值实体：
							        </td>
							        <td class="cap-td" style="text-align: left;" nowrap="nowrap" ng-if="selectEntityMethodVO.returnType.type == 'entity' || selectEntityMethodVO.returnType.type == 'thirdPartyType'">
						   				<span cui_input id="type2" ng-model="selectEntityMethodVO.returnType.value" validate="" width="100%" readonly="{{selectEntityMethodVO.methodType == 'cascade'}}" />
							        </td>
							    </tr>
							    <tr>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	服务增强：
							        </td>
							        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
							        	<div cui_radiogroup  id="serviceExRadioGroup" name="serviceEx" ng-model="selectEntityMethodVO.serviceEx" >
											<input type="radio" name="serviceEx" value="none" />无
											<input type="radio" name="serviceEx" value="before" />前
											<input type="radio" name="serviceEx" value="after" />后
											<input type="radio" name="serviceEx" value="before_after" />前后
										</div>
							        </td>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	标注只读事务：
							        </td>
							         <td class="cap-td" style="text-align: left;" nowrap="nowrap">
						   				<input id="transactionCheckBox" type="checkbox" name="transaction" ng-model="selectEntityMethodVO.transaction" ng-checked="selectEntityMethodVO.transaction" ng-disabled="selectEntityMethodVO.methodType != 'blank'">
							        </td>
							    </tr>
							    
							    <tr>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	描述：
							        </td>
							        <td class="cap-td" style="text-align: left;" colspan="3" nowrap="nowrap">
		      		                   <span cui_textarea id="description" ng-model="selectEntityMethodVO.description" width="100%" height="80px" ></span>
							        </td>
							    </tr>
							    
							    <tr>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	方法类型：
							        </td>
							        <td class="cap-td" style="text-align: left;" colspan="3" nowrap="nowrap">
							         	<div cui_radiogroup  id="methodTypeRadioGroup" name="methodType" ng-model="selectEntityMethodVO.methodType" ng-change="changeMethodType(selectEntityMethodVO.methodType)">
											<input type="radio" name="methodType" value="blank" />空方法
											<input type="radio" name="methodType" value="cascade" />级联操作
											<input type="radio" name="methodType" value="procedure"  />存储过程调用
											<input type="radio" name="methodType" value="function" />函数调用
											<input type="radio" name="methodType" value="userDefinedSQL" />自定义SQL调用
											<input type="radio" name="methodType" value="queryModeling" />查询建模
											<input type="radio" name="methodType" value="queryExtend" readonly="readonly"/>查询重写
										</div>
							        </td>
							    </tr>
							    
							    <tr ng-show="entitySource == 'exist_entity_input'">
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	关联方法：
							        </td>
							        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
							         	<span cui_input id="assoMethodName" width="60%" name="assoMethodName" ng-model="selectEntityMethodVO.assoMethodName"></span><a style="color:red;padding-left:5px;">注:填写关联方法时需要填写对应的方法别名,没有则不填.</a>
							        </td>
							    </tr>
							    
							    <tr>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap" ng-show="selectEntityMethodVO.methodType == 'cascade' || selectEntityMethodVO.methodType == 'userDefinedSQL'">
							        	操作类型：
							        </td>
							        <td class="cap-td" style="text-align: left;" nowrap="nowrap" ng-show="selectEntityMethodVO.methodType == 'cascade' || selectEntityMethodVO.methodType == 'userDefinedSQL'">
							         	<div cui_radiogroup  id="methodOperateTypeRadioGroup" name="methodOperateType" ng-model="selectEntityMethodVO.methodOperateType" ng-change="changeMethodOperateType(selectEntityMethodVO.methodOperateType)">
											<input type="radio" name="methodOperateType" value="insert" />新增
											<input type="radio" name="methodOperateType" value="query" />读取
											<input type="radio" name="methodOperateType" value="update" />更新
											<input type="radio" name="methodOperateType" value="delete" />删除
											<input type="radio" name="methodOperateType" value="save"/>保存
										</div>
							        </td>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap" ng-if="selectEntityMethodVO.methodOperateType == 'query' && selectEntityMethodVO.methodType == 'userDefinedSQL'" >
							        	生成相关方法：
							        </td>
							        <td class="cap-td" style="text-align: left;" nowrap="nowrap" ng-if="selectEntityMethodVO.methodOperateType == 'query' && selectEntityMethodVO.methodType == 'userDefinedSQL'">
						   				<input id="needCount" type="checkbox" name="needCount" ng-model="selectEntityMethodVO.needCount" ng-checked="selectEntityMethodVO.needCount" ng-disabled="selectEntityMethodVO.needPagination == true"/><label for="needCount">记录数方法</label>
						   				<input id="needPagination" type="checkbox" name="needPagination" ng-model="selectEntityMethodVO.needPagination" ng-checked="selectEntityMethodVO.needPagination" ng-change="changeNeedPagination(selectEntityMethodVO.needPagination)"/><label for="needPagination">分页方法</label>
							        </td>
							    </tr>
							    
							    <!-- 级联操作表单 -->
							    <tr ng-if="selectEntityMethodVO.methodType == 'cascade'">
							    	<td class="cap-td" style="text-align: right;" nowrap="nowrap" >
							        	级联属性选择：
							        </td>
							    	<td class="cap-form-td"  colspan="3" >
							            <table class="custom-grid" style="width: 100%">
							                <thead>
							                    <tr>
							                    	<th style="width:30px">
							                    		<input type="checkbox" name="objCheckAll.cascadAttributesCheckAll" ng-model="objCheckAll.cascadAttributesCheckAll" ng-change="allCheckBoxCheck(cascadingAttributes,objCheckAll.cascadAttributesCheckAll)">
							                        </th>
							                        <th style="width:45%">
						                            	级联属性名称
							                        </th>
							                        <th>
						                            	级联属性类型
							                        </th>
							                    </tr>
							                </thead>
					                        <tbody>
					                            <tr ng-repeat="cascadingAttributeVo in cascadingAttributes track by $index" style="background-color: {{cascadingAttributeVo.check == true ? '#99ccff' : '#ffffff'}}">
					                            	<td style="text-align: center;">
					                                    <input type="checkbox" name="{{'cascadingAttributeVo'+($index + 1)}}" ng-model="cascadingAttributeVo.check" ng-change="checkBoxCheck(cascadingAttributes,'objCheckAll.cascadAttributesCheckAll','cascade',cascadingAttributeVo)">
					                                </td>
					                                <td style="text-align:left;" ng-style="cascadAttiPadding(cascadingAttributeVo.indent)" ng-click="tdClick(cascadingAttributeVo,'cascadingAttributes','objCheckAll.cascadAttributesCheckAll','cascade')">
					                                    {{cascadingAttributeVo.name}}
					                                </td>
					                                <td style="text-align: center;" ng-click="tdClick(cascadingAttributeVo,'cascadingAttributes','objCheckAll.cascadAttributesCheckAll','cascade')">
					                                     {{cascadingAttributeVo.displayType}}
					                                </td>
					                            </tr>
					                            <tr ng-if="!cascadingAttributes || cascadingAttributes.length == 0 ">
					                            	<td colspan="3" class="grid-empty"> 本列表暂无记录</td>
					                            </tr>
					                       </tbody>
							            </table>
							            <div ng-if="cascadingAttributes && cascadingAttributes.length >= 0 "><span style="color:red">提示：</span><span>选中级联属性，会自动选中其父级级联属性；取消级联属性，会自动取消其子级级联属性。</span></div>
							    	</td>
							    </tr>
							    
							    <!-- 存储过程操作表单 -->
							    <tr ng-if="selectEntityMethodVO.methodType == 'procedure'">
							   		<td class="cap-td" style="text-align: right;" nowrap="nowrap" >
							        	存储过程选择：
							        </td>
							        <td class="cap-td" style="text-align: left;" colspan="3" nowrap="nowrap">
							        	<span cui_clickinput ng-model="selectEntityMethodVO.dbObjectCalled.objectName" ng-click="selectProduceFromDB()" width="100%" ></span>
							        </td>
							    </tr>
							    
							    <!-- 函数操作表单 -->
							    <tr ng-if="selectEntityMethodVO.methodType == 'function'">
							   		<td class="cap-td" style="text-align: right;" nowrap="nowrap" >
							        	函数选择：
							        </td>
							        <td class="cap-td" style="text-align: left;" colspan="3" nowrap="nowrap">
							        	<span cui_clickinput ng-model="selectEntityMethodVO.dbObjectCalled.objectName" ng-click="selectFunctionFromDB()" width="100%" ></span>
							        </td>
							    </tr>
							    
							    
							    <!-- 自定义SQL调用表单 -->
							    <tr ng-if="selectEntityMethodVO.methodType == 'userDefinedSQL' && false">
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	查询参数：
							        </td>
							        <td class="cap-td" style="text-align: left;" colspan="3" nowrap="nowrap">
		      		                   <span cui_clickinput id="queryParams" ng-model="queryParams"  ng-click="selectEntityAttrubute('queryParams')" width="100%"></span>
							        </td>
							    </tr>
							    <tr ng-if="selectEntityMethodVO.methodType == 'userDefinedSQL' && false">
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	 返回结果：
							        </td>
							        <td class="cap-td" style="text-align: left;" colspan="3" nowrap="nowrap">
		      		                   <span cui_clickinput id="returnResult" ng-model="returnResult" ng-click="selectEntityAttrubute('returnResult')" width="100%"></span>
							        </td>
							    </tr>
							    <tr ng-if="selectEntityMethodVO.methodType == 'userDefinedSQL' && !displayPMethod">
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	 SQL脚本：
							        </td>
							        <td class="cap-td" style="text-align: left;" colspan="3" nowrap="nowrap">
		      		                   <div class="right-area">
											<span cui_code id="querySQL" ng-model="selectEntityMethodVO.userDefinedSQL.querySQL"></span>
								        </div>
							        </td>
							    </tr>
							    <tr ng-if="selectEntityMethodVO.methodType == 'userDefinedSQL' && !displayPMethod">
							        <td class="cap-td" style="text-align: right;width:auto" nowrap="nowrap">
							        	 排序语句：
							        </td>
							        <td class="cap-td" style="text-align: left;width:auto"  colspan="3" nowrap="nowrap">
		      		                   <div class="right-area">
											<span cui_code id="sortSQL" ng-model="selectEntityMethodVO.userDefinedSQL.sortSQL"></span>
								        </div>
							        </td>
							    </tr>
							    <tr ng-if="selectEntityMethodVO.methodType == 'userDefinedSQL'">
							        <td class="cap-td" style="text-align: right;width:auto" nowrap="nowrap">
							        	
							        </td>
							        <td class="cap-td" style="text-align: left;width:auto"  colspan="3" nowrap="nowrap">
		      		                  <font color="red">提示：</font>代码编辑框按<b>F11</b>进入全屏编辑，按<b>ESC</b>退出全屏编辑
							        </td>
							    </tr>
							    <!-- //TODO procedure、function等的表格 -->
							</table>
				    	</td>
				    </tr>
				    
				    <!--  查询建模 -->
				    <tr ng-if="selectEntityMethodVO.methodType =='queryModeling'" >
				      <td>
				         <%@ include file="/cap/bm/dev/entity/QueryModel.jsp" %>
				      </td>
				    </tr>
				    
				     <!-- 服务设计(没啥鸟用) -->
				    <tr>
				        <td  class="cap-form-td" style="text-align: left;">
							<span class="cap-group">服务设计(用于生成设计文档)</span>
							<a style="cursor:pointer;" ng-click="showOrHidenService(displayFlag)">点击{{displayFlag?'隐藏':'展开'}}服务设计属性</a>
				        </td>
				    </tr>
				    <tr ng-hide="displayFlag==false" >
				    	<td style="text-align: left;">
				    		<table class="cap-table-fullWidth">
				    
				                 <tr>
							        <td class="cap-td" style="text-align: right;width:15%" nowrap="nowrap">
							        	服务特点：
							        </td>
							        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" colspan="3">
							        	<span cui_input id="features" ng-model="selectEntityMethodVO.features"  width="100%"/>
							        </td>
							    </tr>
							    <tr>
							    <td class="cap-td" style="text-align: right;width:15%" nowrap="nowrap">
							        	性能预期：
							        </td>
							         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" colspan="3">
						   				<span cui_input id="expPerformance" ng-model="selectEntityMethodVO.expPerformance" width="100%"/>
							        </td>
							    </tr>
							    <tr>
							    <td class="cap-td" style="text-align: right;width:15%" nowrap="nowrap">
							        	约束设计：
							        </td>
							        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" colspan="3">
							        	<span cui_input id="constraint" ng-model="selectEntityMethodVO.constraint" width="100%"/>
							        </td>
							    </tr>
							     <tr>
							        <td class="cap-td" style="text-align: right;width:15%" nowrap="nowrap">
							                    内部服务：
							        </td>
							         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
							         	<div cui_radiogroup  id="privateService" name="privateService" ng-model="selectEntityMethodVO.privateService" >
											<input type="radio" name="privateService" value="true" />是
											<input type="radio" name="privateService" value="false" />否
										</div>
							        </td>
							        <td class="cap-td" style="text-align: right;width:15%" nowrap="nowrap">
							        </td>
							         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
							         </td>
					          </tr>
					          </table>
					          </td>
					 </tr>
					   
				    <!-- 参数列表表单 -->
				    <tr>
				        <td class="cap-form-td" style="text-align: left;">
				        	<div>
				        		<div style="float:left;"><span class="cap-group" style="text-align:left;">参数列表</span></div>
								<div style="float:right;" ng-show="selectEntityMethodVO.methodType != 'cascade' && selectEntityMethodVO.methodType != 'queryExtend' && selectEntityMethodVO.methodType != 'procedure' && selectEntityMethodVO.methodType != 'function'">
									<span cui_button id="addParameter" ng-click="editMethodParameter()" label="新增"></span>
									<span cui_button id="moveUp" ng-click="paramMoveUp()" label="上移"></span>
									<span cui_button id="moveDown" ng-click="paramMoveDown()" label="下移"></span>
						            <span cui_button id="deleteParameter" ng-click="deleteMethodParameters()" label="删除"></span>
					            </div>
				            </div>
				        </td>
				    </tr>
				    <tr>
				    	<td class="cap-form-td">
				            <table class="custom-grid" style="width: 100%">
				                <thead>
				                    <tr>
				                    	<th style="width:30px">
				                    		<input type="checkbox" name="objCheckAll.methodParamsCheckAll" ng-show="selectEntityMethodVO.methodType!='cascade' && selectEntityMethodVO.methodType!='procedure' && selectEntityMethodVO.methodType!='function'" ng-model="objCheckAll.methodParamsCheckAll" ng-change="allCheckBoxCheck(selectEntityMethodVO.parameters,objCheckAll.methodParamsCheckAll)">
				                        </th>
				                        <th style="width:16%">
			                            	参数名称
				                        </th>
				                        <th style="width:16%">
			                            	中文名称
				                        </th>
				                        <th style="width:16%">
			                            	参数类型
				                        </th>
				                        <th>
			                            	描述
				                        </th>
				                    </tr>
				                </thead>
		                        <tbody>
		                            <tr ng-repeat="parameterVo in selectEntityMethodVO.parameters track by $index" style="background-color: {{parameterVo.check == true ? '#99ccff' : '#ffffff'}}">
		                            	<td style="text-align: center;">
		                                    <input type="checkbox" name="{{'parameterVo'+($index + 1)}}" ng-model="parameterVo.check" ng-change="checkBoxCheck(selectEntityMethodVO.parameters,'objCheckAll.methodParamsCheckAll')" ng-show="selectEntityMethodVO.methodType!='cascade' && selectEntityMethodVO.methodType!='procedure' && selectEntityMethodVO.methodType!='function'">
		                                </td>
		                                <td style="text-align:center;"  ng-click="tdClick(parameterVo,'selectEntityMethodVO.parameters','objCheckAll.methodParamsCheckAll')">
		                                    <a ng-click="editMethodParameter(parameterVo.parameterId)" style="cursor:pointer;color:#2b71d9;">{{parameterVo.engName}}</a>
		                                </td>
		                                <td style="text-align: center;" ng-click="tdClick(parameterVo,'selectEntityMethodVO.parameters','objCheckAll.methodParamsCheckAll')">
		                                     {{parameterVo.chName}}
		                                </td>
		                                <td style="text-align: center;" ng-click="tdClick(parameterVo,'selectEntityMethodVO.parameters','objCheckAll.methodParamsCheckAll')">
		                                    {{parameterVo.dataType.type}}
		                                </td>
		                                <td style="text-align: left;" ng-click="tdClick(parameterVo,'selectEntityMethodVO.parameters','objCheckAll.methodParamsCheckAll')">
		                                    {{parameterVo.description}}
		                                </td>
		                            </tr>
		                            <tr ng-if="!selectEntityMethodVO.parameters || selectEntityMethodVO.parameters.length == 0 ">
		                            	<td colspan="5" class="grid-empty"> 本列表暂无记录</td>
		                            </tr>
		                       </tbody>
				            </table>
				    	</td>
				    </tr>
				    <!-- 异常列表表单 -->
				    <tr>
				        <td  class="cap-form-td" style="text-align: left;">
				        	<div>
				        		<div style="float:left;"><span class="cap-group" style="text-align:left;">异常列表</span></div>
								<div style="float:right;">
									<span cui_button id="chooseExceptions" ng-click="chooseExceptions()" label="选择"></span>
						            <span cui_button id="deleteMethodExceptions" ng-click="deleteMethodExceptions()" label="删除"></span>
					            </div>
				            </div>
				        </td>
				    </tr>
				    <tr>
				    	<td class="cap-form-td">
				            <table class="custom-grid" style="width: 100%">
				                <thead>
				                    <tr>
				                    	<th style="width:30px">
				                    		<input type="checkbox" name="objCheckAll.methodExceptionsCheckAll" ng-model="objCheckAll.methodExceptionsCheckAll" ng-change="allCheckBoxCheck(selectEntityMethodVO.exceptions,objCheckAll.methodExceptionsCheckAll)">
				                        </th>
				                        <th style="width:16%">
			                            	异常名称
				                        </th>
				                        <th style="width:16%">
			                            	中文名称
				                        </th>
				                        <th style="width:25%">
			                            	包名
				                        </th>
				                        <th>
			                            	提示信息
				                        </th>
				                    </tr>
				                </thead>
		                        <tbody>
		                            <tr ng-repeat="exceptionVo in selectEntityMethodVO.exceptions track by $index" style="background-color: {{exceptionVo.check == true ? '#99ccff' : '#ffffff'}}">
		                            	<td style="text-align: center;">
		                                    <input type="checkbox" name="{{'exceptionVo'+($index + 1)}}" ng-model="exceptionVo.check" ng-change="checkBoxCheck(selectEntityMethodVO.exceptions,'objCheckAll.methodExceptionsCheckAll')">
		                                </td>
		                                <td style="text-align:center;"  ng-click="tdClick(exceptionVo,'selectEntityMethodVO.exceptions','objCheckAll.methodExceptionsCheckAll')">
		                                    {{exceptionVo.engName}}
		                                </td>
		                                <td style="text-align: center;" ng-click="tdClick(exceptionVo,'selectEntityMethodVO.exceptions','objCheckAll.methodExceptionsCheckAll')">
		                                     {{exceptionVo.chName}}
		                                </td>
		                                <td style="text-align: center;" ng-click="tdClick(exceptionVo,'selectEntityMethodVO.exceptions','objCheckAll.methodExceptionsCheckAll')">
		                                    {{exceptionVo.pkg.fullPath}}
		                                </td>
		                                <td style="text-align: left;" ng-click="tdClick(exceptionVo,'selectEntityMethodVO.exceptions','objCheckAll.methodExceptionsCheckAll')">
		                                    {{exceptionVo.message}}
		                                </td>
		                            </tr>
		                            <tr ng-if="!selectEntityMethodVO.exceptions || selectEntityMethodVO.exceptions.length == 0 ">
		                            	<td colspan="5" class="grid-empty"> 本列表暂无记录</td>
		                            </tr>
		                       </tbody>
				            </table>
				    	</td>
				    </tr>
				</table>
	        </td>
	        <!-- 父实体方法显示区-文本模式 -->
	        <td class="cap-td" style="text-align: left" ng-show="displayPMethod && selectEntityMethodVO.methodId">
	        	<table class="cap-table-fullWidth">
				    <!-- 方法基本信息表单 -->
				    <tr>
				        <td class="cap-form-td" style="text-align: left;">
				        	<div style="clear:both;">
				        		<div style="float:left;"><span class="cap-group">基本信息</span></div>
				        		<div ng-if="selectEntityMethodVO.queryExtend!=null" style="float:right;">
				        			<span cui_button id="sqlPreview" ng-click="sqlPreview('isView')" label="SQL预览"></span>
				        		</div>
				        	</div>
				        </td>
				    </tr>
				    <tr>
				    	<td style="text-align: left;">
				    		<table class="cap-table-fullWidth">
							   <tr>
							        <td class="cap-td" style="text-align: right;width:15%" nowrap="nowrap">
							        	方法名称：
							        </td>
							        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
							        	<span cui_input id="pengName" ng-model="selectEntityMethodVO.engName" width="100%" readonly="true"/>
							        </td>
							        <td class="cap-td" style="text-align: right;width:15%" nowrap="nowrap">
							        	中文名称：
							        </td>
							        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
						   				<span cui_input id="pchName" ng-model="selectEntityMethodVO.chName" width="100%" readonly="true"/>
							        </td>
							    </tr>
							    <tr>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	访问级别：
							        </td>
							        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
							        	<span cui_input id="paccessLevel" ng-model="selectEntityMethodVO.accessLevel" width="100%" readonly="true"/>
							        </td>
							         <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	方法别名:
							        </td>
							         <td class="cap-td" style="text-align: left;" nowrap="nowrap">
						   				<span cui_input id="paliasName" ng-model="selectEntityMethodVO.aliasName"  readonly="true" width="100%"/>
							        </td>
							    </tr>
							    <tr>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	返回值类型：
							        </td>
							        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
							        	<span cui_input id="preturnType" ng-model="selectEntityMethodVO.returnType.type" width="100%" readonly="true"/>
							        </td>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap" ng-if="selectEntityMethodVO.returnType.type == 'java.util.List' || selectEntityMethodVO.returnType.type == 'java.util.Map'">
							        	返回值泛型：
							        </td>
							        <td class="cap-td" style="text-align: left;" nowrap="nowrap" ng-if="selectEntityMethodVO.returnType.type == 'java.util.List'">
						   				<span cui_input id="ptype1" ng-model="selectEntityMethodVO.returnType.generic[0].value" validate="" width="100%" readonly="true"/>
							        </td>
							        <td class="cap-td" style="text-align: left;" nowrap="nowrap" ng-if="selectEntityMethodVO.returnType.type == 'java.util.Map'" colspan="2">
						   				<table style="width:100%">
						   					<tr>
						   						<td style="text-align:left;width:20%"><span cui_input id="pkeyId" ng-model="selectEntityMethodVO.returnType.generic[0].type" validate="" width="100%" readonly="true"/></td>
						   						<td style="text-align:center;width:8%">,</td>
						   						<td style="text-align:right;width:72%"><span cui_input id="pvalueId" ng-model="selectEntityMethodVO.returnType.generic[1].value" validate="" width="100%" readonly="true"/></td>
						   					</tr>
						   				</table>
							        </td>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap" ng-if="selectEntityMethodVO.returnType.type == 'entity' || selectEntityMethodVO.returnType.type == 'thirdPartyType'">
							        	返回值实体：
							        </td>
							        <td class="cap-td" style="text-align: left;" nowrap="nowrap" ng-if="selectEntityMethodVO.returnType.type == 'entity' || selectEntityMethodVO.returnType.type == 'thirdPartyType'">
						   				<span cui_input id="ptype2" ng-model="selectEntityMethodVO.returnType.value" validate="" width="100%" readonly="true"/>
							        </td>
							    </tr>
							    <tr>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	服务增强：
							        </td>
							        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
							        	<div cui_radiogroup  id="pserviceExRadioGroup" name="pserviceEx" ng-model="selectEntityMethodVO.serviceEx" readonly="true">
											<input type="radio" name="pserviceEx" value="none" />无
											<input type="radio" name="pserviceEx" value="before" />前
											<input type="radio" name="pserviceEx" value="after" />后
											<input type="radio" name="pserviceEx" value="before_after" />前后
										</div>
							        </td>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	标注只读事务：
							        </td>
							        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
						   				<input id="ptransactionCheckBox" type="checkbox" name="transaction" ng-model="selectEntityMethodVO.transaction" ng-checked="selectEntityMethodVO.transaction" ng-disabled="true">
							        </td>
							    </tr>
							    <tr>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	方法类型：
							        </td>
							        <td class="cap-td" style="text-align: left;" colspan="3" nowrap="nowrap">
							         	<div cui_radiogroup  id="pmethodTypeRadioGroup" name="pmethodType" ng-model="selectEntityMethodVO.methodType" readonly="true">
											<input type="radio" name="pmethodType" value="blank" />空方法
											<input type="radio" name="pmethodType" value="cascade" />级联操作
											<input type="radio" name="pmethodType" value="procedure" />存储过程调用
											<input type="radio" name="pmethodType" value="function"/>函数调用
											<input type="radio" name="pmethodType" value="userDefinedSQL" />自定义SQL调用
											<input type="radio" name="pmethodType" value="queryModeling"/>查询建模
											<input type="radio" name="pmethodType" value="queryExtend"/>查询重写
										</div>
							        </td>
							    </tr>
							    <tr>
							        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
							        	描述：
							        </td>
							        <td class="cap-td" style="text-align: left;" colspan="3" nowrap="nowrap">
		      		                   <span cui_textarea id="pdescription" ng-model="selectEntityMethodVO.description" width="100%" height="80px" readonly="true"></span>
							        </td>
							    </tr>
							</table>
				    	</td>
				    </tr>
				    <!-- 参数列表表单 -->
				    <tr>
				        <td  class="cap-form-td" style="text-align: left;">
			        		<div><span class="cap-group" style="text-align:left;">参数列表</span></div>
				        </td>
				    </tr>
				    <tr>
				    	<td class="cap-form-td">
				            <table class="custom-grid" style="width: 100%">
				                <thead>
				                    <tr>
				                    	<th style="width:30px">
				                    		<input type="checkbox" name="objCheckAll.methodParamsCheckAll" ng-model="objCheckAll.methodParamsCheckAll" ng-disabled="true">
				                        </th>
				                        <th style="width:16%">
			                            	参数名称
				                        </th>
				                        <th style="width:16%">
			                            	中文名称
				                        </th>
				                        <th style="width:16%">
			                            	参数类型
				                        </th>
				                        <th>
			                            	描述
				                        </th>
				                    </tr>
				                </thead>
		                        <tbody>
		                            <tr ng-repeat="parameterVo in selectEntityMethodVO.parameters track by $index">
		                            	<td style="text-align: center;">
		                                    <input type="checkbox" name="{{'parameterVo'+($index + 1)}}" ng-model="parameterVo.check" ng-disabled="true">
		                                </td>
		                                <td style="text-align:center;">
		                                    {{parameterVo.engName}}
		                                </td>
		                                <td style="text-align: center;">
		                                     {{parameterVo.chName}}
		                                </td>
		                                <td style="text-align: center;">
		                                    {{parameterVo.dataType.type}}
		                                </td>
		                                <td style="text-align: left;">
		                                    {{parameterVo.description}}
		                                </td>
		                            </tr>
		                            <tr ng-if="!selectEntityMethodVO.parameters || selectEntityMethodVO.parameters.length == 0 ">
		                            	<td colspan="5" class="grid-empty"> 本列表暂无记录</td>
		                            </tr>
		                       </tbody>
				            </table>
				    	</td>
				    </tr>
				    <!-- 异常列表表单 -->
				    <tr>
				        <td  class="cap-form-td" style="text-align: left;">
			        		<div><span class="cap-group" style="text-align:left;">异常列表</span></div>
				        </td>
				    </tr>
				    <tr>
				    	<td class="cap-form-td">
				            <table class="custom-grid" style="width: 100%">
				                <thead>
				                    <tr>
				                    	<th style="width:30px">
				                    		<input type="checkbox" name="objCheckAll.methodExceptionsCheckAll" ng-model="objCheckAll.methodExceptionsCheckAll" ng-disabled="true">
				                        </th>
				                        <th style="width:16%">
			                            	异常名称
				                        </th>
				                        <th style="width:16%">
			                            	中文名称
				                        </th>
				                        <th style="width:25%">
			                            	包名
				                        </th>
				                        <th>
			                            	提示信息
				                        </th>
				                    </tr>
				                </thead>
		                        <tbody>
		                            <tr ng-repeat="exceptionVo in selectEntityMethodVO.exceptions track by $index" >
		                            	<td style="text-align: center;">
		                                    <input type="checkbox" name="{{'exceptionVo'+($index + 1)}}" ng-model="exceptionVo.check" ng-disabled="true">
		                                </td>
		                                <td style="text-align:center;">
		                                    {{exceptionVo.engName}}
		                                </td>
		                                <td style="text-align: center;">
		                                     {{exceptionVo.chName}}
		                                </td>
		                                <td style="text-align: center;">
		                                    {{exceptionVo.pkg.fullPath}}
		                                </td>
		                                <td style="text-align: left;">
			                                    {{exceptionVo.message}}
			                                </td>
			                            </tr>
			                        <tr ng-if="!selectEntityMethodVO.exceptions || selectEntityMethodVO.exceptions.length == 0 ">
			                            	<td colspan="5" class="grid-empty"> 本列表暂无记录</td>
			                            </tr>
			                    </tbody>
					        </table>
					    </td>
					</tr>
				</table>
			</td>
	    </tr>
	</table>
</div>	
<script type="text/javascript">
	//js自定义文本域指令
	CUI2AngularJS.directive('cuiCode', ['$interpolate',function ($interpolate) {
	    return {
	        restrict: 'A',
	        replace: false,
	        require: 'ngModel',
	        scope: {
	            ngModel: '=',
	             id:'@'
	        },
	        template: '<textarea id="textarea_{{id}}" name="code"></textarea>',
	        link: function (scope, element, attrs, controller) {
	        	scope.safeApply = function (fn) {
	                var phase = this.$root.$$phase;
	                if (phase == '$apply' || phase == '$digest') {
	                    if (fn && (typeof(fn) === 'function')) {
	                        fn();
	                    }
	                } else {
	                    this.$apply(fn);
	                }
	            };
	            
	            var editor = null;
	            scope.$watch("ngModel",function(newValue, oldValue, scope){
	                if(editor==null){
	                    editor = CodeMirror.fromTextArea(document.getElementById("textarea_"+attrs.id), {
	                    	lineNumbers: true,
	    	                theme:'eclipse',
	    	                mode: 'text/x-sql',
	    	                lineWrapping: true,
	    	                extraKeys: {
	    	                	"F11": function(cm) {
	    	                        setFullScreen(cm, !isFullScreen(cm));
	    	                      },
	    	                      "Esc": function(cm) {
	    	                        if (isFullScreen(cm)) setFullScreen(cm, false);
	    	                      }
	    	                  }
	                    });
	                   
	                    //监听CodeMirror editor的变化
                       editor.on('change', function(instance, changeObj) {
	                      	scope.safeApply(function(){
	                      		//把editor的值设置到ngModel中。触发这里的$watch方法，把ng-model的值写到editor上。
	                      		scope.$parent.callbackUpdate(attrs.id, instance.getValue());
	                      	});
   	            	  });
	                }
	                //改变前获取光标位置
	               	var curPosition = editor.getCursor();
	               	editor.setValue(newValue);
	              	//改变后定位光标位置
	                editor.setCursor(curPosition);
	                //此处解决多个codeMirror互相影响BUG需要异步刷新 
					var tmp = function() {
						editor.refresh();
					}
					setTimeout(tmp, 50);
	            },true);
	        }
	    }
	}]);

</script>
</body>
</html>