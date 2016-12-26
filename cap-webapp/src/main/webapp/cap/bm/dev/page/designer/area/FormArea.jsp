<%
    /**********
    *设计器
    *@author pengxiangwei
    */
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='formArea'>
<head>
    <meta charset="UTF-8">
    <title>快速表单布局</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:link href="/cap/bm/dev/page/designer/css/ez.css"></top:link>
	<top:link href="/cap/bm/dev/page/designer/css/preview.css"></top:link>
	<style type="text/css">
  	    #maskLayer{display: none; position: absolute; top: 0%; left: 0%; width: 100%; height: 100%; background-color: black; z-index:1001; -moz-opacity: 0.7; opacity:.70; filter: alpha(opacity=70);}  
        #show{display: none; text-align:left; position: absolute; top: 20%; left: 16%; width: 65%; height: 30%; padding: 8px; border: 8px solid #E8E9F7; background-color: white; z-index:1002; overflow: auto;} 
        .col-top{text-align:right; margin-bottom: 5px;}
        .col-title{float: left; padding-top: 5px; font-weight: bold;}
        .col-main{margin: 10px 0;}
        .col-footer{margin-top: 15px}
        .col-table{
        	width: 100%; 
  			border-collapse: collapse;
            border: none;
        }
        .col-table tr th, .col-table tr td{
        	height:30px;
        	text-align:center;
        	border: 1px solid #ddd;
        }
        .col-table tr th{
		    background-color: #f5f5f5;
		    color: #333;
		    border: 1px solid #ddd; 
        }
    </style>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <script type="text/javascript">$ = jQuery = comtop.cQuery</script>
    <top:script src="/cap/bm/common/base/js/angular.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/dev/page/designer/js/lodash.min.js"></top:script>
    <top:script src="/cap/bm/dev/page/designer/js/utils.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/ComponentFacade.js'></top:script>
</head>
<body ng-controller="formAreaCtrl">
<!-- Layout 3 -->
<div class="ez-wr">
  <div class="ez-box">
  		<div class="btns bb clearfix">
		    <div class="left">
		        对象 :<span uitype="Menu" id="menuLabel" class="u-menu"  trigger="mouseover" type="button" on_click="clickItem" datasource="menudata" ng-bind="menuLabel" data-menuId="{{menuId}}" ng-model="menuId"></span>
		       &nbsp;&nbsp;<a title="添加" style="cursor:pointer;" onclick="openDataStoreSelect()"><span class="cui-icon" style="font-size:12pt; color:#333;">&#xf067;</span></a>
		    </div>
		    <div class="rigth">
		    	布局: <span cui_pulldown mode="Single" ng-model="col" width="60" datasource="pulldownData" id="colNum"></span>
		    	<span id="setWidth" uitype="Button" label="列宽" ng-click="showColWidthDiv()"></span>
		        <span id="addButton" uitype="Button" label="添加" on_click="addBtn"></span>
		        <span id="delButton" uitype="Button" label="删除" on_click="delBtn"></span>
		        <span id="up" uitype="Button" label="上移" on_click="moveUp"></span>
		        <span id="down" uitype="Button" label="下移" on_click="moveDown"></span>
		        <span id="saveButton" uitype="Button" button_type="green-button" on_click="saveData" label="保存"></span>

		    </div>
		</div>
  </div>
    <!-- Module 3A -->
    <div class="ez-wr">
      <div class="ez-fl ez-negmx ez-33">
        <div class="ez-box">
	      	<div  id="left" style="margin:10px 0 0 10px;">
	        	<table id="entityGrid" uitype="Grid" rowclick_callback="rowclick"  selectRows="no" resizewidth="eWidth" pagination="false"  datasource="initData" gridheight="425px">
	        		<thead>
				    <tr>
				        <th align="center" bindName="label">属性名</th>
				        <th align="center" bindName="name">英文名</th>
				    </tr>
				    </thead>
	        	</table>
        	</div>
        </div>
      </div>
      <div class="ez-last ez-oh">
        <div class="ez-box">
        	<div class="ez-wr">
        		<div class="ez-fl ez-negmr ez-25" style="width:10%">
			      <div class="ez-box">
			      		<div class="btn-arrow">
			      			<div class="tools-arrow">
				        		<span ng-show="false" class="cui-icon arrow" ng-click="moveLeft()" title="全部左移动">&#xf04a;</span>
				        		<span class="cui-icon arrow" ng-click="moveRight()" title="全部左移动">&#xf04e;</span>
			      			</div>
			        	</div>
			      </div>
			    </div>
		    	<div class="ez-last ez-oh main">
			      	<div ng-show="hasShowAppendComponentPanel == false">
					    <table id="formGrid" uitype="EditableGrid" submitdata="submitdata" pagination="false" gridheight="425px" class="cui_grid_list" edittype="editTypeToFormGrid" datasource="init" primarykey="id" resizewidth="reWidth" editafter="editafterByEditGrid">
					        <thead>
					        <tr>
					            <th align="center" width="50px"><input type="checkbox"/></th>
					            <th align="center" bindName="label">中文名</th>
					            <th align="center" bindName="name">英文名</th>
					            <th align="center" bindName="required">是否必填</th>
					            <th align="center" width="100px" bindName="componentModelId">控件类型</th>
					            <!-- <th align="center" bindName="readonly">是否只读</th> -->
					            <th align="center" bindName="colspan" width="60px">控件列宽</th>
					            <th align="center" bindName="levelComponents" width="60px" render="renderOperateColumns">追加控件</th>
					        </tr>
					        </thead>
					    </table>
					</div>
					<div ng-show="hasShowAppendComponentPanel == true" style="margin-top:-5px;">
					    <table width="100%">
							<tr>
								<td align="left" height="23px">往【{{selectedRowData4FormGrid.label}}】控件所在的tb单元格中追加控件</td>
								<td align="right" valign="bottom"><span class="cui-icon" title="返回" style="font-size:12pt;color:red;cursor:pointer;" onclick="hideAppendComponentPanel()">&#xf045;</span></td>
							</tr>
						</table>
					    <table id="appendComponentGrid" uitype="EditableGrid" pagination="false" submitdata="submitdata" gridheight="400px" class="cui_grid_list" edittype="editType" datasource="initData" primarykey="id" resizewidth="reWidthToAppendCompGrid" editafter="editafterByEditGrid">
					        <thead>
					        <tr>
					            <th align="center" width="50px"><input type="checkbox"/></th>
					            <th align="center" bindName="label">中文名</th>
					            <th align="center" bindName="name">英文名</th>
					            <th align="center" bindName="required">是否必填</th>
					            <th align="center" width="100px" bindName="componentModelId">控件类型</th>
					        </tr>
					        </thead>
					    </table>
					</div>
		      	</div>
		    </div>
        </div>
      </div>
    </div>
</div>
<!-- 遮盖层 -->
<div id="maskLayer"></div>  
<!-- 设置列宽弹出层 -->
<div id="show">
	<div class="col-top"><div class="col-title">列宽设置</div>
	<span id="white-space" cui_checkboxGroup ng-model="whiteSpace" name="nowrap">
		<input type="checkbox" name="nowrap" value="nowrap"/>强制换行
	</span>
	<span id="sureBtn" uitype="Button" label="确定" ng-click="ensureColWidth()"></span>&nbsp;&nbsp;<span id="sureBtn" uitype="Button" label="关闭" ng-click="closeColWidthDiv()"></span></div>
    <div id="col-main" class="col-main">
	    <table class="col-table">
	        <thead>
	        	<tr>
	            	<th ng-repeat="colWidth in tbStyleList track by $index">
	            		td
	                </th>
	            </tr>
	        </thead>
	        <tbody>
	            <tr>
	            	<td ng-repeat="colWidth in tbStyleList track by $index">
	            		<span cui_input id="col-{{$index + 1}}" ng-model="colWidth.width" validate="[{type: 'numeric',rule: {m: '只能输入数字类型'}}]" width="100%"/>
	                </td>
	            </tr>
	       </tbody>
	    </table>
    </div>
    <div class="col-footer">说明：列宽以百分比（%）为单位。</div>
</div> 
<script type="text/javascript">
	var pageId = "<%=request.getParameter("pageId")%>";
	var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	var pageSession = new cap.PageStorage(pageId);
	var pageDataStores = pageSession.get("dataStore");
	//处理数据 把数据变为{id:xxx,label:'xx',item:[{id:'',label:''}]}
	var menudata = getMenuData(pageDataStores);
	var toolsdata = window.opener.toolsdata;
    var _cdata = window.opener._cdata;
    var _OldCdata = _.cloneDeep(_cdata);//复制Table(快速布局table)中的数据
    var colspan = [{id:'1',text:'1列'},{id:'2',text:'2列'},{id:'3',text:'3列'}];
	var currSelectEntityAttrVO = {};
    var id =URL.dataId;
    var ntable = _cdata.getMapData().get(id);
    var uitypes = getUitypes();
    var uitypesToFormGrid = _.filter(uitypes, function(n){return n.componentModelId !='uicomponent.common.component.label';});
    var defaultCol = ntable.options.col || 2;
    
    function getUitypes(){
    	var dataList = [];
		dwr.TOPEngine.setAsync(false);
	    ComponentFacade.queryComponentList('form', ['dev'], function(data){
	    	//delete data['uicomponent.common.component.label'];
	    	dataList = _.map(_.values(data),function(n){
	            return {componentModelId:n.modelId,modelName:n.modelName}
	        });
	    });
	    dwr.TOPEngine.setAsync(true);
	    return dataList;
	}
    
    var componentList = getComponentByUItypes(uitypes);
    function getComponentByUItypes(uitypes){
		 var uitypeArr=_.pluck(_.filter(toolsdata, function(chr) {
			  return chr.componentType =="common" || chr.componentType =="expand";
		 }), 'children');
     
		 var ar=[];
		 for(var i=0;i<uitypeArr.length;i++){
			 ar=ar.concat(uitypeArr[i]);
		 }
		 var modelIds = [];
		 for(var i=0;i<uitypes.length;i++){
			 modelIds.push(uitypes[i].componentModelId);
		 }
		 ar= _.filter(ar,function(n){
		    	return _.indexOf(modelIds,n.componentModelId)>=0
		 });
		 return ar;
	}
    
    function getMenuData(pageDataStores){
        return _.map(_.filter(pageDataStores,function(n){
            return n.modelType =="object";
        }),function(n){
            n.entityVO.bindObject=n.ename;
            var sub = _.map(n.subEntity,function(m){
            	var relationId = _.find(n.entityVO.lstRelation, {targetEntityId: m.modelId}).relationId;
	        	var engName = _.find(n.entityVO.attributes, {relationId: relationId}).engName;//父实体关联子实体的关联属性名称
                m.bindObject=n.ename+"."+engName;
                return {id:m.modelId,label:m.engName+"("+m.engName+")",bindObject:m.bindObject}
            });
            return {id:n.entityVO.modelId,label:n.entityVO.engName+"("+n.ename+")",bindObject:n.ename,items:sub.length>0?sub:null}
        });
    }

    function validate(msg) {
        return [{'type':'required', 'rule':{'m': msg+'不能为空'}}]
    }

  	function clickItem(item){
  		var ctr = $("body").scope();
  	 	ctr.menuLabel = item.label;
  	 	ctr.menuId = item.id;
  	 	ctr.bindObject = item.bindObject;
  	 	ctr.$digest();
	 }

	function rowclick(rowData,isChecked,index){
		cui("#entityGrid").removeData(parseInt(index));
		var validate = generateValidate(rowData);
		if(validate.length > 0){
			rowData.validate = validate;
		}
		rowData.id = Tools.randomId("id");
		cui("#"+getEditGridIdAttrVal()).insertRow(transforData(rowData));
		if("appendComponentGrid" === getEditGridIdAttrVal()){
			scope.selectedRowData4FormGrid.otherComponents.push(rowData);
		}
	}
	
	//由左边数据转换到右边[由数据类型转换对应的组件和加入组件componentModelId]
	function transforData(rowData){
		rowData.componentModelId = getComponentFromAttType(rowData.uitype);
		var sourceType = rowData.uitype.source;
		if(sourceType === 'dataDictionary'){
			rowData.dictionary = rowData.uitype.value;
		} else if(sourceType === 'enumType'){
			rowData.enumdata = rowData.uitype.value;
		}
		if(sourceType === 'dataDictionary' || sourceType === 'enumType'){
			rowData.componentModelId = rowData.uitype.type != 'boolean' ? 'uicomponent.common.component.pullDown' : rowData.componentModelId;//不是布尔类型，强行更改为下拉框控件
		}
		delete rowData.uitype; //删除 防止覆盖
		rowData.colspan="1";
		rowData.databind=scope.bindObject+"."+rowData.name;
		rowData.otherComponents = [];
		return rowData;
	}
	
	function getComponentFromAttType(attType){
		var componentModelId = "uicomponent.common.component.input";
		if(attType.type === 'java.sql.Date' || attType.type === 'java.sql.Timestamp'){
			componentModelId = "uicomponent.common.component.calender";
		} else if(attType.type === 'boolean'){
			componentModelId = "uicomponent.common.component.radioGroup";
		}
	    return componentModelId;
	}

	/**
	 * 根据databind绑定的属性，生成对应校验规则
	 * @param attribute 属性对象（已处理过的属性对象）
	 */
	function generateValidate(attribute){
		var validate = [];
		var cname = attribute.label;
		if(attribute.required){// 校验是否为空
			validate.push({'type':'required', 'rule':{m: cname+'不能为空'}});
		} 
		var attributeType = attribute.uitype.type;
		if(attributeType != 'java.sql.Date' && attributeType != 'java.sql.Timestamp' &&
				attribute.uitype.source != 'dataDictionary' && attribute.uitype.source != 'enumType'){
			if(attribute.attributeLength > 0){// 最大长度
				if(attribute.precision > 0){
					//如果是精度+小数点一位
					validate.push({'type':'length', 'rule':{max:attribute.attributeLength+1,maxm: cname+'长度不能大于'+(attribute.attributeLength+1)+'个字符'}});
				}else{
					validate.push({'type':'length', 'rule':{max:attribute.attributeLength,maxm: cname+'长度不能大于'+attribute.attributeLength+'个字符'}});
				}
			}
			if(attribute.precision > 0){// 校验数字精度
				var regex = '^[0-9]{1,' + (attribute.attributeLength-attribute.precision) + '}(\\.[0-9]{1,'+attribute.precision+'})?$';
				validate.push({'type':'format', 'rule':{pattern: regex,m: "整数最多为"+(attribute.attributeLength-attribute.precision)+"位，小数最多为"+attribute.precision+'位'}});
			}
		}
		return validate;
	}
	
	function initData(grid,query){
		grid.setDatasource([],0);
	}
    
    function getData(){
        var firstUI = [];
        var otherUI = {};
        _.forEach(ntable.children,function(tr){
        	_.forEach(tr.children,function(td){
        		var firstChildren = [];
        		if(td.children != null && td.children.length > 0){
        			firstChildren = td.children[0];
        			_.forEach(td.children,function(n, index){
	        			if(index == 0){
		        			otherUI[firstChildren.id] = [];
	        			} else {
	        				var options = {id:Tools.randomId("id"),uid:n.id,label:n.options.label,name:n.options.name,componentModelId:n.componentModelId,required:n.options.required};
	                		if(n.options.validate != null && n.options.validate != ''){
	                			options.validate = typeof n.options.validate === 'string' ? JSON.parse(n.options.validate) : n.options.validate;
	                			options.required = _.findWhere(options.validate, {'type': 'required'}) != null ? true : false;
	                		}
	        				otherUI[firstChildren.id].push(options);
	        			}
        			})
        		}
        		firstUI = firstUI.concat(firstChildren);
        	})
        })
        return {firstUI: firstUI, otherLevelUI: otherUI};
    }
    
    function notAllowRepeatNameToFormGrid(value){
    	if(value === ''){
    		return true;
    	}
    	var count = 0;
    	var data = cui("#"+getEditGridIdAttrVal()).getData();
    	count = _.filter(data,{name:value}).length;
    	for(var i in data){
    		count += _.filter(data[i].otherComponents, {name:value}).length;
    	}
    	return count == 1;
    }
    
    function notAllowRepeatName(value){
    	if(value === ''){
    		return true;
    	}
    	var count = 0;
    	var data = cui("#"+getEditGridIdAttrVal()).getData();
    	count = _.filter(data,{name:value}).length;
    	if(count == 1){
    		data = cui("#formGrid").getData();
    		count += _.filter(data,{name:value}).length;
        	for(var i in data){
        		count += _.filter(data[i].otherComponents, {name:value}).length;
        	}
    	}
    	return count == 1;
    }
    
    var editTypeToFormGrid = {
        label: {
            uitype: 'Input',
            validate: [
                {
                    type: 'required',
                    rule: {
                        m: 'label不能为空'
                    }
                }
            ]
        },
        name: {
            uitype: 'Input',
            validate: [
                {
                    type: 'required',
                    rule: {
                        m: '对应属性不能为空'
                    }
                },{
                	type:'custom',
                	rule:{
                		against:"notAllowRepeatNameToFormGrid",
                		m:'不能重复名字'
                	}
                }
            ]
        },
        componentModelId:{
            uitype: 'SinglePullDown',
            label_field:'modelName',
            value_field:'componentModelId',
            validate: [
                {
                    type: 'required',
                    rule: {
                        m: '控件类型不能为空'
                    }
                }
            ],
            datasource:uitypesToFormGrid
        },
        required:{
            uitype:'radioGroup',
            name:"radio",
            radio_list:[{text:"是",value:true},{text:"否",value:false}]
        },
        colspan:{
            uitype: 'SinglePullDown' ,
            label_field:'text',
            value_field:'id',
            validate: [
                {
                    type: 'required',
                    rule: {
                        m: '控件列宽不能为空'
                    }
                }
            ],
            datasource:colspan.slice(0, defaultCol)
        }
    };

    var editType = {
            label: editTypeToFormGrid.label,
            name: {
                uitype: 'Input',
                validate: [
                    {
                    	type:'custom',
                    	rule:{
                    		against:"notAllowRepeatName",
                    		m:'不能重复名字'
                    	}
                    }
                ]
            },
            componentModelId:{
                uitype: 'SinglePullDown',
                label_field:'modelName',
                value_field:'componentModelId',
                validate: [
                    {
                        type: 'required',
                        rule: {
                            m: '控件类型不能为空'
                        }
                    }
                ],
                datasource:uitypes
            },
            required: editTypeToFormGrid.required
        };
    
    //列数据源
    function pulldownData(obj){
        obj.setDatasource([{id:1,text:"1列"},{id:2,text:"2列"},{id:3,text:"3列"}]);
    }

    //右边EditorGrid编辑
    function init(grid){
        var formda =[], k = ntable.options.children;

        try{
        	k = JSON.parse(k)
        }catch(e){
        	k = null;
        }
        if(_.isArray(k)){
        	//提取ui 数组[[ui1,labelId1],[ui2,labelId2]]=》[ui1,ui2]
        	var zipped = _.map(k,function(n){
        		return n[0]
        	});
        	
        	var allUI = getData();
        	
        	//进行和_cdata匹配如果匹配成功则返回，反之过滤
        	var formda = _.map(_.filter(allUI.firstUI,function(n){
        		if(_.indexOf(zipped,n.id)>=0){
        			return n;
        		}
        	}),function(n){
        		n.options.uid = n.id;
        		var options = {id:Tools.randomId("id"),uid:n.id,label:n.options.label,name:n.options.name,componentModelId:n.options.componentModelId,required:n.options.required,colspan:n.options.colspan,otherComponents:allUI.otherLevelUI[n.id]};
        		if(n.options.validate != null && n.options.validate != ''){
        			options.validate = JSON.parse(n.options.validate);
        			options.required = _.findWhere(options.validate, {'type': 'required'}) != null ? true : false;
        		}
        		return options;
        	});
        }

        grid.setDatasource(formda,formda.length);
    }

    function reWidth(){
        return $('.main').innerWidth();
    }
    function reWidthToAppendCompGrid(){
        return $('#formGrid').innerWidth();
    }
    function eWidth(){
    	return $("#left").innerWidth();
    }
    //新增数据
    function addBtn(){
    	var newData = {id:Tools.randomId("id"),label:"用户",componentModelId:"uicomponent.common.component.input",colspan:"1",databind:"",required:false,otherComponents:[]};
        cui("#"+getEditGridIdAttrVal()).insertRow(newData);
        if("appendComponentGrid" === getEditGridIdAttrVal()){
	        scope.selectedRowData4FormGrid.otherComponents.push(newData);
        }
    }

    function delBtn(){
    	var getSelectedRowData =cui("#"+getEditGridIdAttrVal()).getSelectedRowData();
        if(getSelectedRowData.length){
             if("appendComponentGrid" === getEditGridIdAttrVal()){
            	 for(var i = 0; i < getSelectedRowData.length; i++){
         			var index = _.findIndex(scope.selectedRowData4FormGrid.otherComponents, function(n){return n.id == getSelectedRowData[i].id});
         			if(index != -1){
	         			scope.selectedRowData4FormGrid.otherComponents.splice(index, 1);
         			}
         		}
             }
             cui("#"+getEditGridIdAttrVal()).deleteSelectRow();
             refreshLeftGrid(scope.menuId);
        }
    }

    function moveDown(){
    	down(getEditGridIdAttrVal())
    }
    function moveUp(){
    	up(getEditGridIdAttrVal())
    }
    //下移
	function down(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var index = indexs[indexs.length-1];
		var datas = cui("#" + gridId).getData();
		if(index === datas.length - 1){
			return;
		}
		for(var i=indexs.length-1;i>=0;i--){
			var datas = cui("#" + gridId).getData();
			var currentData = datas[indexs[i]];
			var nextData = datas[indexs[i] + 1];

			var temp = currentData.sortNO;
			currentData.sortNO = nextData.sortNO;
			nextData.sortNO = temp;

			if(currentData.areaItemId && !nextData.areaItemId){
				nextData.areaItemId = currentData.areaItemId;
				nextData.areaId = currentData.areaId;
				delete currentData.areaItemId;
				delete currentData.areaId;
			}

			if(!currentData.areaItemId && nextData.areaItemId){
				currentData.areaItemId = nextData.areaItemId;
				currentData.areaId = nextData.areaId;
				delete nextData.areaItemId;
				delete nextData.areaId;
			}

			//避免primaryKey丢失
			cui("#" + gridId).data[indexs[i]].__insertId__ = undefined;
			cui("#" + gridId).data[indexs[i] + 1].__insertId__ = undefined;
			cui("#" + gridId).changeData(currentData, indexs[i] + 1,true,true);
			cui("#" + gridId).changeData(nextData, indexs[i],true,true);
			cui("#" + gridId).selectRowsByIndex(indexs[i], false);
			cui("#" + gridId).selectRowsByIndex(indexs[i] + 1, true);
		}
	}

	//上移
	function up(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var index = indexs[0];
		if(index == 0){
			return;
		}
		for(var i=0;i<indexs.length;i++){
			var datas = cui("#" + gridId).getData();
			var currentData   = datas[indexs[i]];
			var  frontData = datas[indexs[i]-1];

			var temp = currentData.sortNO;
			currentData.sortNO = frontData.sortNO;
			frontData.sortNO = temp;

			if(currentData.areaItemId && !frontData.areaItemId){
				frontData.areaItemId = currentData.areaItemId;
				frontData.areaId = currentData.areaId;
				delete currentData.areaItemId;
				delete currentData.areaId;
			}
			if(!currentData.areaItemId && frontData.areaItemId){
				currentData.areaItemId = frontData.areaItemId;
				currentData.areaId = frontData.areaId;
				delete frontData.areaItemId;
				delete frontData.areaId;
			}

			//避免primaryKey丢失
			cui("#" + gridId).data[indexs[i]].__insertId__ = undefined;
			cui("#" + gridId).data[indexs[i] - 1].__insertId__ = undefined;
			cui("#" + gridId).changeData(currentData, indexs[i] - 1,true,true);
			cui("#" + gridId).changeData(frontData,indexs[i],true,true);
			cui("#" + gridId).selectRowsByIndex(indexs[i] -1, true);
			cui("#" + gridId).selectRowsByIndex(indexs[i], false);
		}
	}

    function saveData(){
    	var res = '';
    	if(scope.hasShowAppendComponentPanel){
    		res = hideAppendComponentPanel();
    		if(res == 'fail'){
    			return ;
    		}
    	}
	    res = cui("#formGrid").submit();
	    if(res==="noChange"){
	        notifyParent();
	        window.close();
	    }else if(res==="success"){
	  		window.close();
	    }
        window.opener.$("#cIndicator").hide();
    }

    function submitdata(grid){
    	if(!scope.hasShowAppendComponentPanel){
	        notifyParent();
    	}
        grid.submitComplete();
    }
    
    //用于创建UI函数
    function createUI(componentModelId,ui){
      	var b = _.cloneDeep(_.find(filter(toolsdata),{"componentModelId":componentModelId}));
      	var layoutVo = Tools.createUI(b);
      	if(ui){
      		uiAttributeAssignment(layoutVo,ui);
      	}
      	var data = autoCreateAction(b.componentVo.events);
      	layoutVo.options = jQuery.extend(false, data, layoutVo.options);
      	layoutVo.objectOptions = jQuery.extend(false, data, layoutVo.objectOptions);
       	return layoutVo;
    }
    
    /**
     * 从源ui中获取属性值为指定ui属性赋值
     * 
     * @param targetUI 目标ui
     * @param sourceUI 源ui
     * @return targetUI
     */
    function uiAttributeAssignment(targetUI,sourceUI){
    	//为ui的options和objectOptions属性中的databind赋值
    	if(sourceUI.options.databind){
    		targetUI.options.databind = sourceUI.options.databind;
    	}
    	if(sourceUI.objectOptions.databind){
    		targetUI.objectOptions.databind = sourceUI.objectOptions.databind;
    	}
    	
    	return targetUI;
    }
    
    //获取所有菜单子类
	function filter(data){
    	var ary = [];
        _.forEach(data,function(n){
        	if(n.isFolder){
            	ary = ary.concat(filter(n.children));
          	}else{
            	ary.push(n);
          	}
      	})
      	return ary;
    }
    
    //更新组件属性
    function updateUIopt(ui,options){
        if(ui.objectOptions){
          	$.extend(true,ui.objectOptions,options);
        }
        $.extend(true,ui.options, _.mapValues(_.clone( options ),function(value,key) {
            if(_.isArray( key )||_.isObject( key )){
              return JSON.stringify(value)
            }else{
              return value;
            }
        }))
        return ui;
    }
    
    /**
    *根据右边表格数据转换二维数据结构
    *@param data 右边表格数据
    *@param col 列数
    * example  [ui] - 2列 ===> [[ui,td]];
    * example  [ui] - 3列 ===> [[ui,td,td]]
    * example  [ui,ui,ui] - 2列 ===> [[ui,ui],[ui,td]]
    * example  [ui 2列,ui,ui] -2列 ===>[[ui,""],[ui,ui]] 第一ui占2列被合并列则转换中占空字符
    * td为无ui补齐td；空字符串不做任何操作
    */
    function tranformData(data,col){
        var cell = [],row = [];
        //组装为二维数组
        _.forEach(data,function(n,i){
            //cell+uicolspan 不能超过col
            if((cell.length+parseInt(n.colspan))<=col){
                    cell.push(n);
                _.times(n.colspan-1,function(){
                    cell.push("")
                });
                if(cell.length == col){
                    row.push(cell.splice(0,cell.length))
                }
            }else{
                if(cell.length<col){
                    _.times(col-cell.length,function(){cell.push("td")});
                }
                row.push(cell.splice(0,cell.length));
                cell.push(n);
                _.times(n.colspan-1,function(){
                    cell.push("");
                });
            }

            if((i==data.length-1) && (cell.length>0)){
                if(cell.length<col){
                    _.times(col-cell.length,function(){cell.push("td")});
                }
                row.push(cell.splice(0,cell.length));
            }
        })
        return row;
    }
    
    //设置td宽度
    function setLabelTdWidth(col){
    	return col == 1 ? "30%" : (col == 2 ? "20%" : "10%");
    }
    
    //设置td宽度
    function setTdWidth(col, colspan, index){
    	var tdWidthList = _.map(scope.tbStyleList, "width");
    	var cols = 1;
    	var tdWidth = Number(tdWidthList[index]);
    	if(colspan > 1){
	    	for(var i in tdWidthList){
				if(i > index && cols <= colspan){
					tdWidth += Number(tdWidthList[i]);
		    		cols++;
				}
			}
    	}
    	return tdWidth + "%";
    }
    
    //过滤数据
    function filterData(rowData){
    	var componentVo = _.find(componentList, {componentModelId: rowData.componentModelId});
    	_.forEach(rowData, function(value, key){
 			if(key != 'colspan' && key != 'componentModelId' && 
 					key != 'label' && key != 'name' && key != 'required' && 
 					typeof(componentVo.propertiesType[key]) == 'undefined'){
 				delete rowData[key];
 			}
 		});
    	delete rowData.id;
    	delete rowData.uid;
    }
    
    /**
    *二维数组进行插入_cdata树结构上去
    *example [[ui,""][ui,td]]  ---> ui转变为两个td 一个td为label名称 一个为组件 姓名：█████
    *                          ---> 空字符不做操作
    *                          ---> td为两个td td 占位
    */
    function notifyParent () {
    	var col=cui("#colNum").getValue(),AllCollen = [],id =URL.dataId;
    	//数据格式转换处理
        var row = tranformData(cui("#formGrid").getData(),col);
  		_cdata.clearChildren(id) //清除Tabel(快速布局table)中的子节点
		if(row.length==0){
	        var tr = Tools.createTr()
            _cdata.insert(ntable.id, tr);
            _cdata.insert(tr.id, Tools.createTd());
	        _cdata.refreshMap();
  			return ;
  		}
    	var controlTr = 0;//控制循环
    	//行号信息
    	var tableTrNo = [];
 		//获取原表单布局中trid信息
    	for(var i=0; i<_OldCdata.layoutData.length; i++){
    		var vLayoutObj = _OldCdata.layoutData[i];
    		if(id===vLayoutObj.id){
    			for(var k=0; k<vLayoutObj.children.length; k++){
    				var trObj = vLayoutObj.children[k];
    				tableTrNo[k]=trObj.id;
    			}
    		}
    	}
    	
    	_.forEach(row,function(n){
			var index = 0;
    		var tr;
    		//判断
    		if(tableTrNo.length>0){
    			if(controlTr<tableTrNo.length){
    				tr = Tools.createTr();
    				tr.key=tableTrNo[controlTr];
    				tr.id=tableTrNo[controlTr];
    			}else{
        			tr = Tools.createTr();
    			}
   				controlTr++;
    		}else{
    			tr = Tools.createTr();
    		}
	        _cdata.insert(id,tr); //插入tr
    		_.forEach(n,function(cell){
    			if(cell=="td"){ //含有td为空td
    				_.times(2,function(){
	    				var ltd = Tools.createTd({options:{"text-align":'right', width:setTdWidth(col, 1, index++)}});
	    				_cdata.insert(tr.id,ltd); //插入td--for 空
    				})
    			}else if(cell==""){ //b为空则是被合并的项

    			}else{
    				var b = jQuery.extend(false, {}, cell);
    				index = _.findIndex(n, {name: b.name})*2;
    				var ltd =  Tools.createTd({options:{"text-align":"right", "white-space": scope.whiteSpace != null ? scope.whiteSpace[0] : null, width:setTdWidth(col, 1, index)}});
	                _cdata.insert(tr.id,ltd); //插入td--for label
    				var td =  Tools.createTd({options:{colspan:b.colspan*2-1, "text-align":"left", "white-space": scope.whiteSpace != null ? scope.whiteSpace[0] : null, width:setTdWidth(col, b.colspan*2-1, index+1)}});
	                _cdata.insert(tr.id,td); //插入td -- for ui
                    
    				var label = createUI("uicomponent.common.component.label");
                    label = updateUIopt(label,{label:b.label,name:b.name+"Label",value:b.label+": ",isReddot:b.required})
                	//$.extend(label.options,{value:b.label+": ",isReddot:b.required==="true"?true:false});
                	_cdata.insert(ltd.id,label);

                	var ui,uiArarry=[];//用于存储label和ui值
                    if(b.uid){
	           			ui= _.cloneDeep(_cdata.getMapData().get(b.uid));
                        if(ui.componentModelId !=b.componentModelId){ //如果选择的UI不是原来的UI则重新新建一个UI
                            ui = createUI(b.componentModelId,ui)
                        }
                        _cdata.delete(b.uid);   
	           		}else{
	               		ui = createUI(b.componentModelId);
	           		}
                    if(ui.options.uitype === 'Label'){
                    	ui.options.value = ui.objectOptions.value = b.label;
                  	}
                    //过滤数据
    				filterData(b);
                    updateUIopt(ui,b);
                    notifyParentValidBefore(b, ui);
					_cdata.insert(td.id,ui);
					uiArarry.push(ui.id);
               		uiArarry.push(label.id);
					if(cell.otherComponents.length > 0){
						appendLevelComponents(td.id, cell.otherComponents, uiArarry);
					}
               		AllCollen.push(uiArarry);
    			}
    		})
    	})
		_cdata.updateopt(id,{children:JSON.stringify(AllCollen),col:col,objectId: scope.menuId,bindObject:scope.bindObject});
    	_cdata.refreshMap();

    }
    
    //保存前处理控件校验
    function notifyParentValidBefore(b, ui){
    	if(b.validate != null){
        	if(ui.uiType === "ChooseUser" || ui.uiType === "ChooseOrg" || ui.uiType === "RadioGroup" 
        			|| ui.uiType === "CheckboxGroup" || ui.uiType === "PullDown"){
				var valid = _.find(b.validate, {type: 'required'});
				b.validate = valid != null ? [valid] : [];
        	}
        	if(b.required){//如果填入必填 则加入必填项
        		var hasRequiredValidate = _.find(b.validate, {'type':'required'});
           		if(hasRequiredValidate == null){
            		b.validate.push({'type':'required', 'rule':{'m': (b.label||'')+'不能为空'}});
        		}
           		ui.objectOptions.validate = b.validate;
                ui.options.validate = JSON.stringify(b.validate);
            } else {
            	b.validate = _.remove(b.validate, function(n) {
            		  return n.type != 'required';
            		});
            	if(b.validate.length == 0){
            		delete ui.objectOptions.validate;
            		delete ui.options.validate;
            	} else {
            		ui.objectOptions.validate = b.validate;
                    ui.options.validate = JSON.stringify(b.validate);
            	}
            }
        } else if(b.required){//如果填入必填 则加入必填项
            ui.objectOptions.validate = validate(b.label||'');
            ui.options.validate = JSON.stringify(validate(b.label||''));
        }
    }

    //在td中追加控件
    function appendLevelComponents(tdId, otherComponents, uiArarry){
    	_.forEach(otherComponents, function(b){
    		var ui = {};
    		if(b.uid){
       			ui= _.cloneDeep(_cdata.getMapData().get(b.uid));
                if(ui.componentModelId !=b.componentModelId){ //如果选择的UI不是原来的UI则重新新建一个UI
                    ui = createUI(b.componentModelId, ui)
                }
                _cdata.delete(b.uid);   
       		}else{
           		ui = createUI(b.componentModelId);
       		}
    		if(ui.options.uitype === 'Label'){
            	ui.options.value = ui.objectOptions.value = b.label;
          	}
    		filterData(b);
    		updateUIopt(ui, b);
    		notifyParentValidBefore(b, ui);
	    	_cdata.insert(tdId, ui);
	    	uiArarry.push(ui.id);
    	});
    }
    
    /**
	 * 根据控件事件绑定的默认行为，控件第一次被放在设计器画布中时，自动创建行为
	 * @param events 控件事件集合
	 * @return 事件绑定的对应行为名称以及ID
	 */
	function autoCreateAction(events){
		var data = {};
		var pageActionId = (new Date()).valueOf();
		for(var i in events){
      var eventVo = jQuery.extend(true, {}, events[i]);
      eventVo.actionDefine = eventVo.actionDefine != null && eventVo.actionDefine != '' ? $.parseJSON(eventVo.actionDefine) : {};
      eventVo.actionDefine.methodOption = eventVo.actionDefine.methodOption || eventVo.methodOption;
      if(eventVo.actionDefine.methodOption && typeof eventVo.actionDefine.methodOption === 'string') {
        eventVo.actionDefine.methodOption = eval("("+ eventVo.actionDefine.methodOption + ")")
      }
      eventVo.actionDefine.modelId = eventVo.actionDefine.modelId || eventVo.methodTemplate;
      eventVo.actionDefine.ename = eventVo.actionDefine.ename || eventVo.defaultValue;
			if(isCreateDefaultAction(eventVo)){
	    		var pageActionEname = eventVo.actionDefine.ename;
	    		var pageActions = pageSession.get("action");
	        var q = new cap.CollectionUtil(pageActions);
	        var result = q.query("this.ename=='"+pageActionEname+"'");
	    		if(result.length > 0){
	    			data[eventVo.ename] = result[0].ename;
		    		data[eventVo.ename+"_id"] = result[0].pageActionId;
	    			break;
	    		}
				  var methodOption = eventVo.actionDefine.methodOption;
	    		methodOption = methodOption || {};
	    		pageActionId = (pageActionId + i).toString();
	    		//通知行为模块
		    	window.parent.sendMessage('actionFrame',{type:'pageActionChange',data:{pageActionId:pageActionId, ename:pageActionEname, cname:eventVo.actionDefine.cname, description:eventVo.actionDefine.description, methodTemplate:eventVo.actionDefine.modelId, methodOption:methodOption}});
		    	data[events[i].ename] = pageActionEname;
	    		data[events[i].ename+"_id"] = pageActionId;
			}
		}
		return data;
	}
    
	function isCreateDefaultAction(event){
	    var result = false;
	    if(event && event.actionDefine.ename != ''){
	        result = event.hasAutoCreate != false;
	    }
		return result;
	}

    function refreshLeftGrid(newvalue){
		var parents = _.pluck(_.filter(pageDataStores,function(n){
			return n.modelType=="object";
		}),"entityVO");
		
		var subs =	_.flatten(_.pluck(_.filter(pageDataStores,function(n){
				return n.modelType=="object";
			}),"subEntity"));
		currSelectEntityAttrVO = _.map(_.result(_.find(_.union(parents,subs),function(n){
			return n != null && n.modelId == newvalue;
		}),"attributes"),function(n){
			return {label:n.chName,name:n.engName,uitype:n.attributeType,required:!n.allowNull,attributeLength:n.attributeLength,precision:n.precision};
		})

		var b = cui("#formGrid").getData();
		var otherComponents = [];
		_.forEach(_.filter(_.map(b, "otherComponents"),function(n){return n.length > 0}), function(arr){ _.forEach(arr, function(n){ otherComponents.push(n);})});
		var attr = _.filter(currSelectEntityAttrVO,function(n){
			return _.indexOf(_.pluck(b,"name"),n.name)<0 && _.findIndex(otherComponents,{name: n.name})<0 && (n.uitype.source === "primitive" || n.uitype.source === "dataDictionary" || n.uitype.source === "enumType");
		})
 		cui("#entityGrid").setDatasource(attr);
    }

    
    //设置td宽度
    function setLabelTdWidth(col){
    	return col == 1 ? "30%" : (col == 2 ? "20%" : "10%");
    }
    
    var scope=null;
	angular.module('formArea',["cui"],angular.noop).controller('formAreaCtrl', function ($scope) {
		scope=$scope;
		$scope.col = defaultCol;
		$scope.defaultTbStyleList = [[{width: 30}, {width: 70}], [{width: 20}, {width: 30}, {width: 20}, {width: 30}], [{width:10}, {width:23.33}, {width:10}, {width:23.33}, {width:10}, {width:23.33}]];
		$scope.tbStyleList = ntable.options.tbStyleList != null ? JSON.parse(ntable.options.tbStyleList) : $scope.col == 1 ? $scope.defaultTbStyleList[0] : $scope.col == 2 ? $scope.defaultTbStyleList[1] : $scope.defaultTbStyleList[2];
		$scope.whiteSpace = scope.tbStyleList[0]['white-space'];
		$scope.menuLabel = _.result(_.find(_.union(_.filter(_.flatten(_.pluck(menudata,"items")),Boolean),menudata),function(n){
			return n.id == ntable.options.objectId && n.bindObject==ntable.options.bindObject;
		}),"label")||"数据对象";

		$scope.hasShowAppendComponentPanel = false;
		$scope.selectedRowData4FormGrid = {};
		
		$scope.menuId = ntable.options.objectId||"";
		$scope.bindObject = ntable.options.bindObject||"";
		$scope.moveRight = function(){
			//0:int,1:String,2:boolean,3:double;4:Java.sql.date;5:Timestamp;
			var data = _.map(cui("#entityGrid").getData(),function(n){
				return transforData(n);
			})
			cui("#entityGrid").setDatasource([]);
			var currData = cui("#"+getEditGridIdAttrVal()).getData();
			if("appendComponentGrid" === getEditGridIdAttrVal()){
				$scope.selectedRowData4FormGrid.otherComponents = _.union($scope.selectedRowData4FormGrid.otherComponents, data);
			}
			data = _.union(currData, data);
			_.forEach(data, function(objVal, key){
				if(objVal.id == null){
					objVal.id = Tools.randomId("id");
				}
	    	});
			cui("#"+getEditGridIdAttrVal()).setDatasource(data);
		}

		//监控菜单id 用于变化下面属性变化
		$scope.$watch("menuId",function(newValue, oldValue){
            if(newValue!==oldValue){
            	$scope.hasShowAppendComponentPanel = false;
            	cui("#formGrid").setDatasource([], 0);
                cui("#appendComponentGrid").setDatasource([], 0);
            }
            refreshLeftGrid(newValue);
		})
		
		//监控菜单id 用于变化下面属性变化
		$scope.$watch("col",function(newValue, oldValue){
			if(newValue != oldValue){
				$scope.tbStyleList = $scope.col == 1 ? $scope.defaultTbStyleList[0] : $scope.col == 2 ? $scope.defaultTbStyleList[1] : $scope.defaultTbStyleList[2];
				ntable.options.tbStyleList = JSON.stringify($scope.tbStyleList);
				// 重置跨列数
				resizeMergeColumns(newValue);
			}
		})

		//监控菜单id 用于变化下面属性变化
		$scope.showColWidthDiv = function(){
		    document.getElementById("maskLayer").style.display ="block";  
		    document.getElementById("show").style.display ="block";  
		}
	    
		$scope.ensureColWidth = function(){
	    	//验证表单指定部分，并返回验证信息
	    	var valid = cap.validater.validElement('AREA', '#col-main');
	    	if(!valid[2]){
	    		cui.alert("数据校验失败.");
		    	return ;
	    	}
	    	var arr = _.remove(_.map($scope.tbStyleList, "width"), function(n){return n != null});
	    	var totalNum = 0;
	    	for(var i in arr){
	    		totalNum += Number(arr[i]);
	    	}
	    	if(totalNum > 100){
	    		cui.alert("列宽总和不能大于100%.");
		    	return ;
	    	}
	    	_.forEach($scope.tbStyleList, function(objTd){
	    		objTd['white-space'] = $scope.whiteSpace != null ? $scope.whiteSpace[0] : undefined;
	    	});
	    	ntable.options.tbStyleList = JSON.stringify($scope.tbStyleList);
	    	$scope.hideColWidthDiv();
	    }
		
		$scope.closeColWidthDiv = function(){
			if(ntable.options.tbStyleList != null){
				$scope.tbStyleList = JSON.parse(ntable.options.tbStyleList); 
			}
			$scope.hideColWidthDiv();
		} 
		
		$scope.hideColWidthDiv = function(){
		    document.getElementById("maskLayer").style.display ='none';  
		    document.getElementById("show").style.display ='none';  
		} 
	});
    comtop.UI.scan();
    
    //打开数据模型选择界面
    function openDataStoreSelect() {
    	var url='../EditPageDataStoreSelect.jsp?packageId=' + packageId+'&modelId='+pageId+'&callbackMethod=openDataStoreSelectCallback&hideFlag='+true;
    	var top=(window.screen.availHeight-600)/2;
    	var left=(window.screen.availWidth-800)/2;
    	window.open (url,'importRoleAccess','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
    }
    
    //打开数据模型选择界面回调方法
    function openDataStoreSelectCallback(data){
    	pageDataStores.push(data);
    	menudata = getMenuData(pageDataStores);
    	cui('#menuLabel').setDatasource(menudata);
    	clickItem(menudata[menudata.length-1]);
    }
    
    //编辑完与当前行其他列进行联动
    function editafterByEditGrid(rowData, bindName) {
        //编辑联动
        if (bindName === "componentModelId") {
        	var modelId = rowData.componentModelId;
        	//如果是pullDown、checkboxGroup、radioGroup控件，自动给数据字典或枚举变量赋值(根据属性类型)
        	if(modelId === 'uicomponent.common.component.pullDown' || 
        			modelId === 'uicomponent.common.component.checkboxGroup' || 
        			modelId === 'uicomponent.common.component.radioGroup'){
        		var attr = _.find(currSelectEntityAttrVO, {name: rowData.name});
        		var sourceType = attr != null && attr.uitype != null ? attr.uitype.source : null;
        		var keys = {dataDictionary: 'dictionary', enumType: 'enumdata'};
        		if(sourceType === 'dataDictionary' || sourceType === 'enumType'){
	        		rowData[keys[sourceType]] = attr.uitype.value;
        		} else {
        			delete rowData[keys[sourceType]];
        		}
    		} else {
    			if(rowData.dictionary){
        			delete rowData.dictionary;
        		}
    			if(rowData.enumdata){
        			delete rowData.enumdata;
    			}
    		} 
        	//自动绑定databind值
        	if(modelId === 'uicomponent.expand.component.chooseUser' || modelId === 'uicomponent.expand.component.chooseOrg'){
        		var uitype = modelId.substr(modelId.lastIndexOf('.') + 1, 1).toUpperCase() + modelId.substr(modelId.lastIndexOf('.') + 2);
        		rowData.idName = scope.bindObject + '.' + rowData.name;
        		rowData.databind = rowData.idName + uitype;
        	} else if(typeof rowData.databind != 'undefinded'){
        		rowData.databind = scope.bindObject + '.' + rowData.name;
        	}
        }
        return rowData;
    }
    
	function renderOperateColumns(rd, index, col) {
		return '<span class="cui-icon" title="追加控件" style="font-size:12pt;color:red;cursor:pointer;" onclick="showAppendComponentPanel(\''+rd.id+'\')">&#xf101;</span>';
   	}
    
	//显示追加控件面板
	function showAppendComponentPanel(primaryKey){
		scope.hasShowAppendComponentPanel = true;
		var grid = cui("#formGrid");
		scope.selectedRowData4FormGrid = grid.getRowsDataByPK(primaryKey)[0];
		var selectedPrimaryKeys = grid.getSelectedPrimaryKey();
		for(var i in selectedPrimaryKeys){
			grid.selectRowsByPK(selectedPrimaryKeys[i], false);
		}
		grid.selectRowsByPK(scope.selectedRowData4FormGrid.id, true);
		var datasource = scope.selectedRowData4FormGrid.otherComponents != null ? scope.selectedRowData4FormGrid.otherComponents : [];
		cui("#appendComponentGrid").setDatasource(datasource, datasource.length);
		cap.digestValue(scope);
	}
	
	//隐藏追加控件面板
	function hideAppendComponentPanel(){
		var data = cui("#appendComponentGrid").getData();
		var rowDataIndexs = [];
		for(var i in data){
			if(data[i].componentModelId != 'uicomponent.common.component.label' && $.trim(data[i].name) == ''){
				rowDataIndexs.push(parseInt(i)+1);
			}
		}
		if(rowDataIndexs.length > 0){
			cui.error('第"'+rowDataIndexs+'"行，"英文名" 列有错误：不能为空');
			return 'fail';
		}
		var result = cui("#appendComponentGrid").submit();
		if(result != 'fail'){
			var grid = cui("#formGrid");
			var rowIndex = grid.getSelectedIndex();
			var gridRowDatas = grid.getData();
			var selectedRowData = gridRowDatas[rowIndex];
			selectedRowData.otherComponents = data;
			
			grid.data[rowIndex].__insertId__ = undefined;
			grid.data[rowIndex].otherComponents = [];
			grid.changeData(selectedRowData, rowIndex);
			scope.selectedRowData4FormGrid = {};
			scope.hasShowAppendComponentPanel = false;
			cap.digestValue(scope);
		}
		return result;
	}
	
	//获取editgrid控件id值
	function getEditGridIdAttrVal(){
		return scope.hasShowAppendComponentPanel == false ? "formGrid" : "appendComponentGrid";
	}
	
	//重新设置合并列
	function resizeMergeColumns(layoutCol){
		var grid = cui("#formGrid"),
		    dict = colspan,
		    gridRowDatas = grid.getData();
		grid.editDict.colspan = dict.slice(0, layoutCol);
		grid.editType.colspan.datasource = dict.slice(0, layoutCol);
		_.forEach(gridRowDatas, function(rowData, rowIndex){
			if(layoutCol < rowData.colspan){
				rowData.__insertId__ = undefined;
				rowData.colspan = layoutCol.toString();
				grid.changeData(rowData, rowIndex);
			}
		});
	}
</script>
</body>
</html>
