<%
/*******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd All Rights
 * Reserved. 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、 复制、修改或发布本软件.
 * 
 * 实体元数据-查询建模页面
 * 
 * @author xuchang WWW.SZCOMTOP.COM 
 * @Date 2016-08-12
 ******************************************************************************/
 %>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!--  查询建模  -->
<table class="cap-table-fullWidth">
	    <tr style="display: none">
	       <td colspan="2"><span style="text-align:left;color: #39c;padding-right: 20px;">查询建模</span></td>
	    </tr>
	    <!-- 查询建模select -->
		<tr class="queryModel_tr" style="">
		    <td width="9%">
		       <a class="queryModelText" ng-click="selectAttrClick()">SELECT:</a>
		    </td>
		    <td width="91%">
		       <span cui_button id="mainQueryAttribute" ng-click="selectAttrClick()" label="SELECT属性选择"></span>
		      <!--  <span cui_button id="subQueryAttribute" ng-click="subQueryAttribute()" label="新增子查询属性"></span> -->
		       <span cui_button id="addAttributeExp" ng-click="addAttributeExp()" label="添加表达式"></span>
		       <span cui_button id="addAttributeExp" ng-click="clearSelectAttr()" label="清空SELECT"></span>
		    </td>
		</tr>
		<!-- select展示数据  -->
		<tr class="queryModel_tr">
			<td width="9%">&nbsp;</td>
		    <td width="91%">
			    <table style="width: 100%">
                  <tr ng-repeat="selectAttribute in selectEntityMethodVO.queryModel.select.selectAttributes track by $index">
                      <td ng-if="selectAttribute.sqlScript==null || selectAttribute.sqlScript==''" style="text-align:left;cursor:pointer;" width="20%" class="cap-queryModel-td">
                          <div>{{selectAttribute.tableAlias+"."+selectAttribute.columnName}} </div>
                      </td>
                      <td ng-if="selectAttribute.sqlScript!=null && selectAttribute.sqlScript!=''" style="text-align:left;cursor:pointer;" width="20%" class="cap-queryModel-td">
                          <div style="width:95%;"> {{selectAttribute.sqlScript}} </div>
                      </td>
                      <td style="text-align:left;cursor:pointer;" ng-click="" class="cap-queryModel-td">
                         <div>
                            <input type="text" ng-disabled="true" class="queryModel_shadow" style="width:100px;" name="selectAttribute" ng-model="selectAttribute.columnAlias" />
                            <span ng-click="selectAttributeClick(selectAttribute)"><img src="images/find.gif" class="ng-scope"/></span>
                         </div>
                      </td>
                      <td class="cap-queryModel-td">
                      	<a class="queryModel-del" ng-click="delSelectAttr($index)">
                      		<img src="images/invalid.png" class="ng-scope">
                      	</a>
                      </td>
                  </tr>
            	</table>
           	</td>
		</tr>

		<!-- 查询建模from -->
		<tr class="queryModel_tr">
			<td>
			   <a class="queryModelText" ng-click="addChildQuery()">FROM:</a>
			 </td>
			 <td>
			   <span cui_button id="addChildQuery" ng-click="addChildQuery()" label="添加查询对象"></span>
			   <span cui_button id="addSubQueryModel" ng-click="addSubQueryModel('addNew')" label="添加嵌套子查询"></span>
			 </td>
		</tr>
		<tr>
		  <td width="9%">&nbsp;</td>
		  <td width="91%">
			 
			 <table style="width: 100%">
			 	<tr>
			 		<td width="10%" class="cap-queryModel-td"></td>
			 		<td width="10%" class="cap-queryModel-td">
			 		<div>
			 			<span class="{{selectEntityMethodVO.queryModel.from.primaryTable.refQueryModel?'queryModel_a':''}}" ng-click="updateTables(selectEntityMethodVO.queryModel.from.primaryTable)"> 
			 				{{selectEntityMethodVO.queryModel.from.primaryTable.remark ? "【子查询】"+ selectEntityMethodVO.queryModel.from.primaryTable.remark : ""}} {{" "+selectEntityMethodVO.queryModel.from.primaryTable.subTableName}}
			 			</span>
			 		</div>
			 		</td>
			 		<td width="5%" align="center" class="cap-queryModel-td">{{selectEntityMethodVO.queryModel.from.primaryTable.subTableAlias}}</td>
			 		<td width="70%" class="cap-queryModel-td" colspan="4">
			 		</td>
			 		<td width="5%" class="cap-queryModel-td">
			 			<!-- 删除 -->
			 			<a  ng-if="selectEntityMethodVO.queryModel.from.primaryTable" ng-click="delFromAttr(selectEntityMethodVO.queryModel.from.primaryTable.subTableAlias,-1)" class="queryModel-del">
			 			   <img src="images/invalid.png" class="ng-scope">
			 		    </a>
			 		</td>
			 	</tr>
				 <tr ng-repeat="subquery in selectEntityMethodVO.queryModel.from.subquerys ">
                     <td style="text-align:left;cursor:pointer;" width="10%" class="cap-queryModel-td">
                         <span cui_pulldown id="joinType" ng-model="subquery.joinType" ng-change="joinTypeChange()" value_field="id" label_field="text" width="93%">
							<a value="left join">左连接</a>
							<a value="right join">右连接</a>
							<a value="inner join">内连接</a>
							<a value="full join">全连接</a>
						 </span>
                     </td>
                     <td width="10%" class="cap-queryModel-td">
                        <span class="{{subquery.refQueryModel?'queryModel_a':''}}" ng-click="updateTables(subquery)"> 
                        	{{subquery.remark ? "【子查询】"+ subquery.remark : ""}}{{subquery.subTableName}}
                        </span>
                     </td>
                     <td width="5%" align="center" class="cap-queryModel-td">{{subquery.subTableAlias}} </td>
                     <td width="5%" class="cap-queryModel-td">
                         on
                     </td>
                     <td width="20%" class="cap-queryModel-td">
                        {{subquery.onLeft.tableAlias+"."}}
                         <span  cui_pulldown id="{{'onLeftColumnName'+($index + 1)}}" index={{$index}} entityId="{{subquery.entityId}}" mode="Single" value_field="dbFieldId" label_field="dbFieldId" validate="checkColumnNeedRule"  editable="false" ng-model="subquery.onLeft.columnName" select="0"  datasource="initLeftTableColumnAlias"  width="65%">
			             </span>
                     </td>
                     <td width="5%" class="cap-queryModel-td">
                         =
                     </td>
                     <td width="20%" class="cap-queryModel-td">
                       <!--  <a>  {{subquery.onRight.tableAlias+"."+subquery.onRight.columnName}}  </a>  -->
                        <span cui_pulldown id="{{'onRightTableAlias'+($index + 1)}}" mode="Single" value_field="subTableAlias" label_field="subTableAlias" editable="false" ng-model="subquery.onRight.tableAlias" ng-change="changeRightColumns(subquery.onRight.tableAlias,'{{$index + 1}}')" select = "0" datasource="initTableAlias" readonly="{{false}}" width="27%">
						</span>&nbsp;.
                         
						<span  cui_pulldown id="{{'onRightColumnName'+($index + 1)}}" rightTableAlias="{{subquery.onRight.tableAlias}}" mode="Single" value_field="dbFieldId" label_field="dbFieldId" validate="checkColumnNeedRule" editable="false" ng-model="subquery.onRight.columnName"  select="0"  datasource="initRightTableColumnAlias"  width="65%">
			            </span>	

                     </td>
                     <td width="5%" class="cap-queryModel-td">
                     	<!-- 删除 -->
                     	<a ng-click="delFromAttr(subquery.subTableAlias,$index)" class="queryModel-del">
                     	   <img src="images/invalid.png" class="ng-scope">
                         </a>
                     </td>
                 </tr>
			 </table>
		  </td>
		</tr>

        <!-- 查询建模where -->
		<tr class="queryModel_tr">
			<td class="cap-queryModel-td">
			   <a class="queryModelText" ng-click="attrBatchUpdate('where')">WHERE:</a>
			</td>
			<td class="cap-queryModel-td">
			   <span cui_button id="addWhereCondition" ng-click="addWhereCondition()" label="添加查询条件"></span>
			   <span ng-show="false" cui_button id="saveCommonQueryCondition" ng-click="saveCommonQueryCondition()" label="存为公共查询条件"></span>
			   <span cui_button id="customQueryCondition" ng-click="customQueryCondition()" label="添加自定义条件"></span>
			   <span ng-show="validateQueryModel()">引用公共查询条件:<input id="refCommonCondtion" type="checkbox" name="refCommonCondtion" ng-model="selectEntityMethodVO.queryModel.where.refCommonCondtion" >
			   </span>
			</td>
		</tr>    
		<tr>
		  <td width="9%">&nbsp;</td>
		  <td width="91%">
		  	 <span class="queryModel_a" ng-if="validateQueryModel() && selectEntityMethodVO.queryModel.where.refCommonCondtion == true" ng-click="defaultQueryCondition()">include refid="{{root.entityAliasName}}_default_query_condition"</span>
			 <table style="width: 100%">
				<tr ng-repeat="whereCondition in selectEntityMethodVO.queryModel.where.whereConditions ">
		             <!-- 操作符  -->
		             <td width="10%" style="text-align:left;cursor:pointer;" class="cap-queryModel-td">
		                  <span cui_pulldown id="operatorType" ng-model="whereCondition.operatorType" ng-change="operatorTypeChange()" empty_text="" value_field="id" label_field="text" width="80%">
							<a value="and">AND</a>
							<a value="or">OR</a>
							<a value=""></a>
						  </span>
		             </td>

		             <!-- 左括号 -->
		             <td width="5%" class="cap-queryModel-td">
		             	<span cui_pulldown id="hasLeftBracket" ng-model="whereCondition.hasLeftBracket" value_field="id" label_field="text" width="90%" empty_text="">
							<a value=true>(</a>
							<a value=false></a>
						</span>
		             </td>

		             <!-- 自定义条件 -->
		             <td width="55%" colspan="4" ng-if ="whereCondition.wildcard ==null || whereCondition.wildcard =='' " class="cap-queryModel-td">
		             	<span cui_clickinput id="{{'customCondition'+($index + 1)}}" clickinputid="{{'customCondition'+($index + 1)}}" name="customCondition" ng-model ="whereCondition.customCondition" width="97%" editable="true" on_iconclick="customConditionClick"></span>
		             </td>

		             <!-- 字段属性名 -->
		             <td width="20%" ng-if ="whereCondition.wildcard != null && whereCondition.wildcard !=''" class="cap-queryModel-td">
		              <span cui_pulldown id="{{'onLeftWhereCondition'+($index + 1)}}" mode="Single" value_field="subTableAlias" label_field="subTableAlias" editable="false" ng-model="whereCondition.conditionAttribute.tableAlias" ng-change="changeRightColumnsByIdAndIndex('#onLeftWhereColumnName',whereCondition.conditionAttribute.tableAlias,'{{$index + 1}}',whereCondition.conditionAttribute)" select = "0" datasource="initTableAlias" readonly="{{false}}" width="30%">
					  </span>&nbsp;.
		                 
					  <span cui_pulldown id="{{'onLeftWhereColumnName'+($index + 1)}}" rightTableAlias="{{whereCondition.conditionAttribute.tableAlias}}" mode="Single" value_field="dbFieldId" label_field="dbFieldId" editable="false" ng-model="whereCondition.conditionAttribute.columnName"  select="0"  datasource="initRightTableColumnAlias"  width="60%">
		              </span>	

		             </td>

		             <!-- 通配符 -->
		             <td width="10%" ng-if ="whereCondition.wildcard != null && whereCondition.wildcard !=''" class="cap-queryModel-td">
		                 <span cui_pulldown id="wildcard" ng-model="whereCondition.wildcard" value_field="id" label_field="text" width="90%" empty_text="">
							<a value="=">等于</a>
							<a value=">">大于</a>
							<a value=">=">大于等于</a>
							<a value="<">小于</a>
							<a value="<=">小于等于</a>
							<a value="!=">不等于</a>
							<a value="IN">IN</a>
							<a value="NOT IN">NOT IN</a>
							<a value="%like%">%like%</a>
							<a value="%like">%like</a>
							<a value="like%">like%</a>
						 </span>
		             </td>
		             
		             <!-- 传值方式  -->
		             <td width="10%" ng-if ="whereCondition.wildcard != null && whereCondition.wildcard !=''" class="cap-queryModel-td">
		                 <span cui_pulldown id="{{'transferValPattern'+($index + 1)}}" ng-model="whereCondition.transferValPattern" ng-change="changeWhereConditionValue(whereCondition.transferValPattern,($index + 1))" value_field="id" label_field="text" width="90%" editable="false" empty_text="">
							<a value="constant">常量</a>
							<a value="entity_attribute">方法参数</a>
						 </span>
		             </td>

		             <!-- 值  -->
		             <td width="15%" ng-if ="whereCondition.wildcard != null && whereCondition.wildcard !=''" class="cap-queryModel-td">
		            	  <span cui_clickinput id="{{'whereConditionValue'+($index + 1)}}" index="{{($index + 1)}}" transferValPattern="{{whereCondition.transferValPattern}}" ng-model="whereCondition.value" enterable="true" ng-click="whereConditionValue(whereCondition)" width="90%" ng-if="whereCondition.transferValPattern=='entity_attribute'"></span> 
		            	  <span cui_input id="{{'whereConditionValue'+($index + 1)}}" index="{{($index + 1)}}" ng-model="whereCondition.value" ng-if="whereCondition.transferValPattern=='constant'" width="90%"></span>
		             </td>
		             
		             <!-- 右括号  -->
		             <td width="5%" class="cap-queryModel-td">
		                 <span cui_pulldown id="hasRightBracket" ng-model="whereCondition.hasRightBracket" value_field="id" label_field="text" width="90%" empty_text="">
					        <a value=true>)</a>
					        <a value=false></a>
				         </span>
		             </td>

		             <!-- 是否需要空判断 emptyCheck  -->
		             <td width="10%" ng-if ="whereCondition.wildcard != null && whereCondition.wildcard !=''" class="cap-queryModel-td">
		               	非空判断:<input id="emptyCheck" type="checkbox" name="emptyCheck" ng-model="whereCondition.emptyCheck" > 
		             </td>
		             <!--  空格 -->
		             <td width="10%" ng-if ="whereCondition.wildcard ==null || whereCondition.wildcard =='' ">
		               	&nbsp;
		             </td>

		             <td width="5%" class="cap-queryModel-td">
		               	<a class="queryModel-del" ng-click="delWhereAttr($index)">
		               		<!-- 删除 -->
		               		<img src="images/invalid.png" class="ng-scope">
		               	</a>
		             </td>	
                 </tr>
			 </table>
		  </td>
		</tr> 

        <!-- 查询建模order by -->
		<tr class="queryModel_tr">
			 <td >
			   <a class="queryModelText" ng-click="attrBatchUpdate('orderBy')">ORDER BY:</a>
			 </td>
			 <td >
			   <span cui_button id="addOrderBy" ng-click="addOrderBy()" label="添加排序条件"></span>
			 	<span ng-show="validateQueryModel()">
			 		添加动态排序条件:<input id="dynamicOrder" type="checkbox" ng-click="setDeafaultValue(selectEntityMethodVO.queryModel.orderBy.dynamicOrder,selectEntityMethodVO.queryModel.orderBy.dynamicAttribute.tableAlias)" name="dynamicOrder" ng-model="selectEntityMethodVO.queryModel.orderBy.dynamicOrder" >
			 	</span>
			 </td>
		</tr> 
		<tr>
		  <td width="9%">&nbsp;</td>
		  <td width="91%">
		  	 <!--  是否动态排序 -->
			 <table style="width: 100%">
			 	 <tr ng-if="selectEntityMethodVO.queryModel.orderBy.dynamicOrder">
			 	 	<td colspan="3" class="cap-queryModel-td">
	 	 		 	 	<span>
	 	 		 	 		<span cui_pulldown id="dynamicAttribute" mode="Single" value_field="subTableAlias" label_field="subTableAlias" editable="false" ng-model="selectEntityMethodVO.queryModel.orderBy.dynamicAttribute.tableAlias"  select = "0" empty_text="" datasource="initTableAlias" readonly="false" width="8%">
	 	 					</span>
	 	 		 	 		<a>.</a>
	 	 		 	 		<span > 
	 	 		 	 			<a>'$'{sortFieldName} '$'{sortType}</a>
	 	 		 	 		</span>
	 	 		 	 	</span>	
			 	 	</td>
			 	 </tr>
				 <tr ng-repeat="sort in selectEntityMethodVO.queryModel.orderBy.sorts">
				    <!-- 排序属性 -->
                     <td style="text-align:left;" width="27%" class="cap-queryModel-td">
                        <!--  {{ sort.sortAttribute.tableAlias + "." + sort.sortAttribute.columnName }} -->

                         <span cui_pulldown id="{{'sortAttribute'+($index + 1)}}" mode="Single" value_field="subTableAlias" label_field="subTableAlias" editable="false" ng-model="sort.sortAttribute.tableAlias" ng-change="changeRightColumnsByIdAndIndex('#sortAttributeColumnName',sort.sortAttribute.tableAlias,'{{$index + 1}}')" 
                         select = "0" datasource="initTableAlias" readonly="false" width="27%">
						 </span>&nbsp;.
                         
						 <span  cui_pulldown id="{{'sortAttributeColumnName'+($index + 1)}}" rightTableAlias="{{sort.sortAttribute.tableAlias}}" mode="Single" value_field="dbFieldId" label_field="dbFieldId" editable="false"  ng-model="sort.sortAttribute.columnName"  select="0"  datasource="initRightTableColumnAlias"  width="50%">
			             </span>	
                     </td>
                     <!-- 升降序  -->
                     <td width="60%" class="cap-queryModel-td">
                       <span cui_pulldown id="sortType" ng-model="sort.sortType" value_field="id" label_field="text" width="80px">
							<a value="asc">ASC</a>
							<a value="desc">DESC</a>
				       </span>
                     </td>
                     <td width="5%" class="cap-queryModel-td">
                     	<a class="queryModel-del" ng-click="delOrderAttr($index)">
                     		<!-- 删除 -->
                     		<img src="images/invalid.png" class="ng-scope">
                     	</a>
                     </td>
                 </tr>
			 </table>
			 <!-- 排序结尾 -->
			 <div ng-show="validateQueryModel() && (selectEntityMethodVO.queryModel.orderBy.dynamicOrder || selectEntityMethodVO.queryModel.orderBy.sorts.length > 0)">
			 	  <span>NULL值排序方式：</span>
			      <span cui_pulldown id="sortEnd" ng-model="selectEntityMethodVO.queryModel.orderBy.sortEnd" value_field="id" label_field="text" width="15%">
					<a value="NULLS LAST">NULLS LAST</a>
					<a value="NULLS FIRST">NULLS FIRST</a>
					<a value=""></a>
				  </span>
			 </div>
		  </td>
		</tr> 

		<!-- 查询建模group by -->
		<tr class="queryModel_tr">
			<td class="cap-queryModel-td">
				<a class="queryModelText" ng-click="attrBatchUpdate('groupBy')">GROUP BY:</a>
			</td>
			<td class="cap-queryModel-td">
				<span cui_button id="addGroupBy" ng-click="addGroupBy()" label="添加分组条件"></span>
			</td>
		</tr>
		<tr>
		  <td width="9%">&nbsp;</td>
		  <td width="91%">
			 <table style="width: 100%">
				 <tr ng-repeat="groupByAttr in selectEntityMethodVO.queryModel.groupBy.groupByAttributes ">
				    <!-- 排序属性 -->
                     <td style="text-align:left;" width="27%" class="cap-queryModel-td">
                        <!--  {{ sort.sortAttribute.tableAlias + "." + sort.sortAttribute.columnName }} -->
                         <span cui_pulldown id="{{'groupByAttr'+($index + 1)}}" mode="Single" value_field="subTableAlias" label_field="subTableAlias" editable="false" ng-model="groupByAttr.tableAlias" ng-change="changeRightColumnsByIdAndIndex('#groupByAttrColumnName',groupByAttr.tableAlias,'{{$index + 1}}')" 
                         select = "0" datasource="initTableAlias" readonly="false" width="27%">
						 </span>&nbsp;.
                         
						 <span cui_pulldown id="{{'groupByAttrColumnName'+($index + 1)}}" rightTableAlias="{{groupByAttr.tableAlias}}" mode="Single" value_field="dbFieldId" label_field="dbFieldId" editable="false" ng-model="groupByAttr.columnName"  select="0"  datasource="initRightTableColumnAlias"  width="50%">
				         </span>	
                     </td>
                     <td width="60%" class="cap-queryModel-td">&nbsp;</td>
                     <td width="5%" class="cap-queryModel-td">
                     	<a class="queryModel-del" ng-click="delGroupAttr($index)">
                     		<!-- 删除 -->
                     		<img src="images/invalid.png" class="ng-scope">
                     	</a>
                     </td>
                 </tr>
			 </table>
		  </td>
		</tr> 
</table>
