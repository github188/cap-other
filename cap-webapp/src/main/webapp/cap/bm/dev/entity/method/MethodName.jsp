<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<div>
	<span id="mehtod_sign_name" class="notUnbind cap-group">方法签名</span>
	<span cui_button id="addMethodSQL" ng-show="entitySource =='exist_entity_input'" ng-click="editSQL('parent',selectEntityMethodVO)" label="SQL录入"></span>
	<span cui_button id="sqlPreview2"  ng-if="selectEntityMethodVO.methodType=='userDefinedSQL' || selectEntityMethodVO.methodType=='queryModeling' " ng-click="sqlPreview('isView')" label="SQL预览"></span>
</div>
<div id="mehtod_sign_name_div" class="method-div-group">
	<div class="method-name" ng-show="selectEntityMethodVO.queryExtend != null">
		<span>{{javaMethodName}}</span>
	</div>
	<div class="method-name" ng-show="selectEntityMethodVO.queryExtend == null">
		<span width="80px" cui_pulldown id="accessLevel" mode="Single" value_field="id" label_field="text" editable="false" ng-model="selectEntityMethodVO.accessLevel">
			<a value="private">private</a>
			<a value="">default</a>
			<a value="protected">protected</a>
			<a value="public">public</a>
		</span>
		<span width="150px" cui_pulldown id="returnType" mode="Single" value_field="id" label_field="text" editable="false" ng-model="selectEntityMethodVO.returnType.type" ng-change="changeReturnType(selectEntityMethodVO.returnType.type)" readonly="{{selectEntityMethodVO.methodType == 'cascade'}}">
			<a value="void">void</a>
			<a value="int">int</a>
			<a value="float">float</a>
			<a value="double">double</a>
			<a value="boolean">boolean</a>
			<a value="String">String</a>
			<a value="java.lang.Object">Object</a>
			<a value="java.sql.Date">java.sql.Date</a>
			<a value="java.util.List">java.util.List</a>
			<a value="java.util.Map">java.util.Map</a>
			<a value="java.sql.Timestamp">java.sql.Timestamp</a>
			<a value="entity">Entity</a>
			<a value="thirdPartyType">第三方类型</a>
		</span>
		<span ng-if="selectEntityMethodVO.returnType.type == 'entity' || selectEntityMethodVO.returnType.type == 'thirdPartyType'">
			<span cui_input id="type2" emptytext="返回值实际类型" ng-model="selectEntityMethodVO.returnType.value" validate="" readonly="{{selectEntityMethodVO.methodType == 'cascade'}}"></span>
		</span>
		<span ng-if="selectEntityMethodVO.returnType.type == 'java.util.List' || selectEntityMethodVO.returnType.type == 'java.util.Map'">
			<span cui_clickinput id="type1" emptytext="返回值泛型" ng-model="selectEntityMethodVO.returnType.value" on_iconclick="setAttributeGeneric" readonly=""></span>
		</span>
		<span cui_input id="engName" emptytext="方法名称" ng-model="selectEntityMethodVO.engName" validate="methodEngNameValRule" ng-change="changeAliasName(selectEntityMethodVO.engName)"></span>
		<span class="bm-code">(</span>
		<span ng-repeat="parameterVo in selectEntityMethodVO.parameters track by $index" class="bm-code">
			<span ng-if="isParameterEdit()== false">
				{{parameterVo.dataType.type}} {{parameterVo.engName}}
			</span>
			<span ng-if="isParameterEdit() == true">
				<span ng-mouseover="showMoveBtn(parameterVo,true)" ng-mouseout="showMoveBtn(parameterVo,false)" class="paramter">
					<label class="paramter" ng-click="editMethodParameter(parameterVo.parameterId)">{{parameterVo.dataType.type}} {{parameterVo.engName}}</label>
					<span class="floatUp" ng-show="parameterVo.showMovBtn" >
						<span class="paramter-move-left" ng-show="$index > 0" ng-click="paramMoveUpNew(parameterVo)" title="左移"></span>
						<span class="paramter-move-right" ng-show="$index < selectEntityMethodVO.parameters.length - 1" ng-click="paramMoveDownNew(parameterVo)" title="右移"></span>
					</span>
				</span>
				<img ng-show="!parameterVo.showMovBtn || selectEntityMethodVO.parameters.length==1" src="./images/cancel.gif" style="cursor:pointer" ng-click="deleteMethodParameterById(parameterVo.parameterId)"/>
			</span>
			<span ng-show="selectEntityMethodVO.parameters.length -1 > $index ">,</span>
		</span>
		<span ng-if="isParameterEdit() == true" cui_button id="addParameter" ng-click="editMethodParameter()" icon="plus" label="参数"></span>
		<span class="bm-code">)</span>
		<span class="java-key-word" ng-show = "selectEntityMethodVO.exceptions.length > 0"> throws</span>
		<span ng-repeat="exceptionVo in selectEntityMethodVO.exceptions track by $index" class="bm-code">
			{{exceptionVo.engName}}
			<img src="./images/cancel.gif" ng-click="deleteMethodExceptionById(exceptionVo.modelId)"/>
			<span ng-show="selectEntityMethodVO.exceptions.length-1 > $index">,</span>
		</span>
		<span cui_button id="chooseExceptions" ng-click="chooseExceptions()" icon="plus" label="异常"></span>
	</div>
</div>
<div>
	<span id="method_comment" class="notUnbind cap-group" ng-show="selectEntityMethodVO.queryExtend ==null">方法注释</span>
</div>
<div id="method_comment_div" class="method-div-group" ng-show="selectEntityMethodVO.queryExtend == null">
	<div>
		<span class="span-label span-label-method">方法中文名：</span>
		<span cui_input emptytext="方法中文名" id="chName" ng-model="selectEntityMethodVO.chName" validate="methodChNameValRule"></span>
		<span class="span-label span-label-method span-label-method-alias">方法别名：</span>
		<span cui_input id="aliasName" emptytext="方法别名，方法的唯一标示" ng-model="selectEntityMethodVO.aliasName" validate="methodAliasNameValRule"></span>
	</div>
	<div id="relationMethod" ng-show="entitySource =='exist_entity_input'">
		<span class="span-label span-label-method">关联方法：</span>
		<span cui_input id="assoMethodName" name="assoMethodName" ng-model="selectEntityMethodVO.assoMethodName"></span><a style="color:red;padding-left:5px;">注:填写关联方法时需要填写对应的方法别名,没有则不填.</a>
	</div>
	<div>
		<span class="span-label">方法描述：</span>
		<div class="method-desc-mar">
		<span cui_textarea emptytext="方法描述,生成代码时为方法的详细注释" id="description" ng-model="selectEntityMethodVO.description" width="100%" height="80px" ></span>
		</div>
	</div>
</div>
<div>
	<span id="method_body_logic" class="notUnbind cap-group">方法逻辑</span>
</div>
<div id="method_body_logic_div" class="method-div-group">
	<div ng-if="selectEntityMethodVO.queryExtend ==null">
		<span class="span-label">服务增强：</span>
		<div cui_radiogroup  id="serviceExRadioGroup" name="serviceEx" ng-model="selectEntityMethodVO.serviceEx" >
			<input type="radio" name="serviceEx" value="none" />无
			<input type="radio" name="serviceEx" value="before" />前
			<input type="radio" name="serviceEx" value="after" />后
			<input type="radio" name="serviceEx" value="before_after" />前后
		</div>
		<span class="span-label">标注只读事务：</span>
		<span><input id="transactionCheckBox" type="checkbox" name="transaction" ng-model="selectEntityMethodVO.transaction" ng-checked="selectEntityMethodVO.transaction" ng-disabled="selectEntityMethodVO.methodType != 'blank'"></span>
	</div>
	<div ng-show="selectEntityMethodVO.queryExtend ==null">
		<span class="span-label">方法类型</span>
		<div cui_radiogroup  id="methodTypeRadioGroup" name="methodType" ng-model="selectEntityMethodVO.methodType" ng-change="changeMethodType(selectEntityMethodVO.methodType)">
			<input type="radio" name="methodType" value="blank" />空方法
			<input type="radio" name="methodType" value="cascade" />级联操作
			<input type="radio" name="methodType" value="procedure"  />存储过程调用
			<input type="radio" name="methodType" value="function" />函数调用
			<input type="radio" name="methodType" value="userDefinedSQL" />自定义SQL调用
			<input type="radio" name="methodType" value="queryModeling" />查询建模
			<input type="radio" name="methodType" value="queryExtend" readonly="readonly"/>查询重写
		</div>
	</div>
	<div ng-show="selectEntityMethodVO.methodType == 'cascade' || selectEntityMethodVO.methodType == 'userDefinedSQL' || selectEntityMethodVO.methodType == 'queryModeling'">
		<span class="span-label" ng-if="selectEntityMethodVO.methodType != 'queryModeling'">操作类型</span>
		<div cui_radiogroup  id="methodOperateTypeRadioGroup" name="methodOperateType" ng-model="selectEntityMethodVO.methodOperateType" ng-change="changeMethodOperateType(selectEntityMethodVO.methodOperateType)" ng-if="selectEntityMethodVO.methodType != 'queryModeling'">
			<input type="radio" name="methodOperateType" value="insert" />新增
			<input type="radio" name="methodOperateType" value="query" />读取
			<input type="radio" name="methodOperateType" value="update" />更新
			<input type="radio" name="methodOperateType" value="delete" />删除
			<input type="radio" name="methodOperateType" value="save"/>保存
		</div>
		<span ng-if="(selectEntityMethodVO.methodOperateType == 'query' && selectEntityMethodVO.methodType == 'userDefinedSQL') || selectEntityMethodVO.methodType == 'queryModeling'">
			<span class="span-label">生成相关方法：</span>
			<span>
				<input id="needCount" type="checkbox" name="needCount" ng-model="selectEntityMethodVO.needCount" ng-checked="selectEntityMethodVO.needCount" ng-disabled="selectEntityMethodVO.needPagination == true"/><label for="needCount">记录数方法</label>
				<input id="needPagination" type="checkbox" name="needPagination" ng-model="selectEntityMethodVO.needPagination" ng-checked="selectEntityMethodVO.needPagination" ng-change="changeNeedPagination(selectEntityMethodVO.needPagination)"/><label for="needPagination">分页方法</label>
			</span>
		</span>
	</div>
	<!-- 级联操作表单 -->
	<div ng-if="selectEntityMethodVO.methodType == 'cascade'">
		<span class="span-label">级联属性选择：</span>
		<div>
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
		</div>
		<div ng-if="cascadingAttributes && cascadingAttributes.length >= 0 "><span style="color:red">提示：</span><span>选中级联属性，会自动选中其父级级联属性；取消级联属性，会自动取消其子级级联属性。</span></div>
	</div>
	<!-- 存储过程操作表单 -->
	<div ng-if="selectEntityMethodVO.methodType == 'procedure'">
		<span class="span-label">存储过程选择：</span>
		<span cui_clickinput ng-model="selectEntityMethodVO.dbObjectCalled.objectName" ng-click="selectProduceFromDB()" width="100%" ></span>
	</div>
	<!-- 函数操作表单 -->
	<div ng-if="selectEntityMethodVO.methodType == 'function'">
		<span class="span-label">函数选择：</span>
		<span cui_clickinput ng-model="selectEntityMethodVO.dbObjectCalled.objectName" ng-click="selectFunctionFromDB()" width="100%" ></span>
	</div>
	<!-- 自定义SQL调用表单 -->
	<div ng-if="selectEntityMethodVO.methodType == 'userDefinedSQL' && !displayPMethod">
		<div ng-if="false">
			<span class="span-label">查询参数：</span>
			<span cui_clickinput id="queryParams" ng-model="queryParams"  ng-click="selectEntityAttrubute('queryParams')" width="100%"></span>
			<span class="span-label">返回结果：</span>
			<span cui_clickinput id="returnResult" ng-model="returnResult" ng-click="selectEntityAttrubute('returnResult')" width="100%"></span>
		</div>
		<span class="span-label">SQL脚本：</span>
		<div class="right-area" style="width:auto">
			<span cui_code id="querySQL" ng-model="selectEntityMethodVO.userDefinedSQL.querySQL"></span>
		</div>
		<span class="span-label">排序语句：</span>
		<div class="right-area" style="width:auto">
			<span cui_code id="sortSQL" ng-model="selectEntityMethodVO.userDefinedSQL.sortSQL"></span>
		</div>
		<span><font color="red">提示：</font>代码编辑框按<b>F11</b>进入全屏编辑，按<b>ESC</b>退出全屏编辑</span>
	</div>
	 <!--  查询建模  -->
	 <div ng-if="selectEntityMethodVO.methodType =='queryModeling'">
	 		<%@include file="/cap/bm/dev/entity/QueryModel.jsp" %>
	 </div>
	  <!-- sql查询重写界面  -->
	  <div ng-if="selectEntityMethodVO.queryExtend!=null && !displayPMethod">
	  	<div ng-show="entitySource =='exist_entity_input'">
	  		<span class="span-label">selectId:</span>
	  		<span cui_input id="selectId" name="selectId" ng-model="selectEntityMethodVO.queryExtend.selectId" width="25%" ></span>
	  		<a style="color:red;">注:selectId默认情况下不需要填,它影响生成的sql.xml的select id,如果是特殊命名才需要修改.</a>
	  	</div>
	  	<div>
	  		<span class="span-label">SQL内容:</span>
	  		<span ng-if="entitySource !='exist_entity_input'" cui_button id="sqlPreview" ng-click="sqlPreview('isView')" label="SQL预览"></span>
	  		<div style="overflow: auto;border: 1px solid #ccc;">
				<span style="overflow: auto;height: 100%;" cui_code id="mybatisSQL" name="mybatisSQL" ng-model="selectEntityMethodVO.queryExtend.mybatisSQL"></span>
			</div>
	  	</div>
	  </div>
</div>
<!-- 服务设计(没啥鸟用) -->
<div>
	<span ng-show="selectEntityMethodVO.queryExtend ==null" id="serviceDesign" class="notUnbind cap-group">服务设计(用于生成设计文档)
	<!-- <a style="cursor:pointer;" ng-click="showOrHidenService(displayFlag)">点击{{displayFlag?'隐藏':'展开'}}服务设计属性</a> -->	
	</span>
</div>
<div ng-show="selectEntityMethodVO.queryExtend ==null" id="serviceDesign_div" class="method-div-group">
	 <div>
	 		<span class="span-label">服务特点：</span>
	 		<span cui_input id="features" ng-model="selectEntityMethodVO.features"  width="100%"></span>
	 		<span class="span-label">性能预期：</span>
	 		<span cui_input id="expPerformance" ng-model="selectEntityMethodVO.expPerformance" width="100%"></span>
	 		<span class="span-label">约束设计：</span>
	 		<span cui_input id="constraint" ng-model="selectEntityMethodVO.constraint" width="100%"></span>
	 		<span class="span-label">内部服务：</span>
	 		<div cui_radiogroup  id="privateService" name="privateService" ng-model="selectEntityMethodVO.privateService" >
				<input type="radio" name="privateService" value="true" />是
				<input type="radio" name="privateService" value="false" />否
			</div>
	 </div>
</div>
<script>
	$(".cap-group").addClass("cap-group-icon-on");
	$("#serviceDesign").addClass("cap-group-icon-off").removeClass("cap-group-icon-on");
	$("#serviceDesign_div").hide();
	$(".cap-group").click(function(){
		var className = $(this).attr("class");
		if(className.indexOf('cap-group-icon-off') >=0 ){
			$(this).addClass("cap-group-icon-on").removeClass("cap-group-icon-off");
			var divId = $(this).attr("id")+"_div";
			$('#'+divId).show();
		}else{
			$(this).addClass("cap-group-icon-off").removeClass("cap-group-icon-on");
			var divId = $(this).attr("id")+"_div";
			$('#'+divId).hide();
		}
	});
	
</script>