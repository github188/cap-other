<%
    /**********************************************************************
	 * 页面设计器
	 * 2016-11-11 zhuhuanhui 新建
	 **********************************************************************/
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
			.main{margin:10px 10px 5px 10px}
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
	    <top:script src="/cap/bm/common/lodash/js/lodash.min.js"></top:script>
	    <top:script src="/cap/bm/req/prototype/design/js/utils.js"></top:script>
	    <top:script src='/cap/dwr/engine.js'></top:script>
	    <top:script src='/cap/dwr/util.js'></top:script>
	    <top:script src='/cap/dwr/interface/ComponentFacade.js'></top:script>
	    <top:script src="/cap/dwr/interface/ReqFunctionSubitemAction.js"></top:script>
	</head>
	<body ng-controller="formAreaCtrl">
		<div class="ez-wr">
		  	<div class="ez-box">
		  		<div class="btns bb clearfix">
				    <div class="left">
				    	<span id="addButton" uitype="Button" label="添加" menu="addFormItemsMenu"></span> 
				        <span id="delButton" uitype="Button" label="删除" on_click="delBtn"></span>
				    </div>
				    <div class="rigth">
				    	布局: <span cui_pulldown mode="Single" ng-model="col" width="60" datasource="pulldownData" id="colNum"></span>
				    	<span id="setWidth" uitype="Button" label="列宽" ng-click="showColWidthDiv()"></span>
				        <span id="up" uitype="Button" label="上移" on_click="moveUp"></span>
				        <span id="down" uitype="Button" label="下移" on_click="moveDown"></span>
				        <span id="saveButton" uitype="Button" button_type="green-button" on_click="saveData" label="保存"></span>
				    </div>
				</div>
		  	</div>
		    <div class="ez-last ez-oh main">
		     	<div ng-show="hasShowAppendComponentPanel == false">
			    	<table id="formGrid" uitype="EditableGrid" submitdata="submitdata" pagination="false" gridheight="430px" class="cui_grid_list" edittype="editTypeToFormGrid" datasource="init" primarykey="id" resizewidth="reWidth">
			        	<thead>
				        	<tr>
					            <th align="center" width="30px"><input type="checkbox"/></th>
					            <th align="center" bindName="name">中文名</th>
					            <th align="center" bindName="value">默认值</th>
					            <th align="center" bindName="required" width="150px">是否必填</th>
					            <th align="center" width="150px" bindName="componentModelId">控件类型</th>
					            <th align="center" bindName="colspan" width="80px">控件列宽</th>
					            <th align="center" bindName="levelComponents" width="80px" render="renderOperateColumns">追加控件</th>
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
				    <table id="appendComponentGrid" uitype="EditableGrid" pagination="false" submitdata="submitdata" gridheight="400px" class="cui_grid_list" edittype="editTypeToAppendComponentGrid" datasource="initAppendComponentGrid" primarykey="id" resizewidth="reWidthToAppendCompGrid">
				        <thead>
					        <tr>
					            <th align="center" width="30px"><input type="checkbox"/></th>
					            <th align="center" bindName="name">中文名</th>
					            <th align="center" bindName="value">默认值</th>
					            <th align="center" bindName="required" width="150px">是否必填</th>
					            <th align="center" width="100px" bindName="componentModelId">控件类型</th>
					        </tr>
				        </thead>
				    </table>
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
			var namespaces = "<%=request.getParameter("namespaces")%>";
			var reqFunctionSubitemId = "<%=request.getParameter("reqFunctionSubitemId")%>";
			var pageSession = new cap.PageStorage(namespaces);
			var toolsdata = window.opener.toolsdata;
		    var _cdata = window.opener._cdata;
		    var _oldCdata = _.cloneDeep(_cdata);//复制Table(快速布局table)中的数据
		    var colspan = [{id:'1',text:'1列'},{id:'2',text:'2列'},{id:'3',text:'3列'}];
		    var id = URL.dataId;
		    var ntable = _cdata.getMapData().get(id);
		    var uitypes = getUitypes();
		    var uitypesToFormGrid = _.filter(uitypes, function(n){return n.componentModelId !='req.uicomponent.common.component.label';});
		    var componentList = getComponentByUItypes(uitypes);
		    var domainId = getDomainId(reqFunctionSubitemId);
		    var defaultCol = ntable.options.col || 2;
		    //获取控件定义列数据源
		    function getUitypes(){
		    	var dataList = [];
				dwr.TOPEngine.setAsync(false);
			    ComponentFacade.queryComponentList('form', ['req'], function(data){
			    	dataList = _.map(_.values(data),function(n){
			            return {componentModelId:n.modelId,modelName:n.modelName}
			        });
			    });
			    dwr.TOPEngine.setAsync(true);
			    return dataList;
			}
		    
		 	//新增表单项
	    	var addFormItemsMenu = {
		        datasource: [
					{id:'batchAddItems',label:'批量表单项'},
		            {id:'customAddItem',label:'自定义表单项'}
		        ],
		        on_click : function(obj){
		        	if(obj.id === 'batchAddItems'){
		        		openSelectBizObjectMainWin(domainId);
		        	}else if(obj.id === 'customAddItem'){
		        		var newData = {id:Tools.randomId("id"), name:"用户", componentModelId:"req.uicomponent.common.component.input", colspan:"1", required:false, otherComponents:[]};
				        cui("#"+getEditGridIdAttrVal()).insertRow(newData);
				        if("appendComponentGrid" === getEditGridIdAttrVal()){
					        scope.selectedRowData4FormGrid.otherComponents.push(newData);
				        }
		        	}
		        }
		    };
		  
	    	/**
			 * 根据控件类型，获取对应的控件元数据模型对象
			 * @param uitypes 控件类型数组
			 */
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
		    
			//初始化追加控件表格数据源
			function initAppendComponentGrid(grid, query){
				grid.setDatasource([], 0);
			}

			function validate(msg) {
		        return [{'type':'required', 'rule':{'m': msg+'不能为空'}}]
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
			        				var options = {id:Tools.randomId("id"), uid:n.id, label:n.options.name, name:n.options.name, value:n.options.value, componentModelId:n.componentModelId, required:n.options.required};
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
		        name: {
		            uitype: 'Input',
		            validate: [
		                {
		                    type: 'required',
		                    rule: {
		                        m: '中文名不能为空'
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
		        value: {
		            uitype: 'Input'
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
		
		    var editTypeToAppendComponentGrid = {
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
		            value: {
			            uitype: 'Input'
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
		        		var options = {id:Tools.randomId("id"), uid:n.id, label:n.options.name, name:n.options.name, value:n.options.value, componentModelId:n.options.componentModelId, required:n.options.required, colspan:n.options.colspan, otherComponents:allUI.otherLevelUI[n.id]};
		        		if(n.options.validate != null && n.options.validate != ''){
		        			options.validate = JSON.parse(n.options.validate);
		        			options.required = _.findWhere(options.validate, {'type': 'required'}) != null ? true : false;
		        		}
		        		return options;
		        	});
		        }
		        grid.setDatasource(formda, formda.length);
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
		    
		    //删除表单项
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
		
			//保存表单数据
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
		    function createUI(componentModelId, ui){
		      	var b = _.cloneDeep(_.find(filter(toolsdata),{"componentModelId":componentModelId}));
		      	var layoutVo = Tools.createUI(b);
		      	var data = autoCreateAction(b.componentVo.events);
		      	layoutVo.options = jQuery.extend(false, data, layoutVo.options);
		      	layoutVo.objectOptions = jQuery.extend(false, data, layoutVo.objectOptions);
		       	return layoutVo;
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
		    function updateUIopt(ui, options, delOptionKeys){
		        if(ui.objectOptions){
		          	$.extend(true,ui.objectOptions, options);
		        }
		        $.extend(true,ui.options, _.mapValues(_.clone( options ),function(value,key) {
		            if(_.isArray( key )||_.isObject( key )){
		              return JSON.stringify(value)
		            }else{
		              return value;
		            }
		        }));
		        if(delOptionKeys){
		          	_.forEach(delOptionKeys, function(value, key){
			            delete ui.objectOptions[value];
			            delete ui.options[value];
			      	});
	          	}
		        return ui;
		    }
		    
		    /**
		    * 根据右边表格数据转换二维数据结构
		    * @param data 右边表格数据
		    * @param col 列数
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
		    	var delUIOptionKeys = [];
		    	var componentVo = _.find(componentList, {componentModelId: rowData.componentModelId});
		    	_.forEach(rowData, function(value, key){
		 			if(key != 'colspan' && key != 'componentModelId' && 
		 					key != 'label' && key != 'name' && key != 'required' && (!value || key === 'otherComponents')){
		 				delete rowData[key];
		 				delUIOptionKeys.push(key);
		 			}
		 		});
		    	delete rowData.id;
		    	delete rowData.uid;
		    	return delUIOptionKeys;
		    }
		    
		    /**
		    * 二维数组进行插入_cdata树结构上去
		    * example [[ui,""][ui,td]]  ---> ui转变为两个td 一个td为label名称 一个为组件 姓名：█████
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
		    	for(var i=0, len=_oldCdata.layoutData.length; i<len; i++){
		    		var vLayoutObj = _oldCdata.layoutData[i];
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
		    				var ltd = Tools.createTd({options:{"text-align":"right", "white-space": scope.whiteSpace != null ? scope.whiteSpace[0] : null, width:setTdWidth(col, 1, index)}});
			                _cdata.insert(tr.id,ltd); //插入td--for label
		    				var td = Tools.createTd({options:{colspan:b.colspan*2-1, "text-align":"left", "white-space": scope.whiteSpace != null ? scope.whiteSpace[0] : null, width:setTdWidth(col, b.colspan*2-1, index+1)}});
			                _cdata.insert(tr.id,td); //插入td -- for ui
		                    
		    				var label = createUI("req.uicomponent.common.component.label");
		                    label = updateUIopt(label,{label:b.name,name:b.name+"Label",value:b.name+": ",isReddot:b.required})
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
		                  	} else {
		                  		ui.label = b.name;
		                  		ui.options.label = b.name;
		                  	}
		                    //过滤数据
		    				var delUIOptionKeys = filterData(b);
		                    updateUIopt(ui,b,delUIOptionKeys);
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
				_cdata.updateopt(id, {children:JSON.stringify(AllCollen), col:col});
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
		          	} else {
		          		ui.label = b.name;
		          		ui.options.label = b.name;
		          	}
		    		var delUIOptionKeys = filterData(b);
		    		updateUIopt(ui, b, delUIOptionKeys);
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
		    
			/**
			 * 根据控件事件属性，判断是否需要创建默认行为
			 * @param events 控件事件集合
			 * @return 是否需要创建
			 */
			function isCreateDefaultAction(event){
			    var result = false;
			    if(event && event.actionDefine.ename != ''){
			        result = event.hasAutoCreate != false;
			    }
				return result;
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
				$scope.hasShowAppendComponentPanel = false;
				$scope.selectedRowData4FormGrid = {};
				
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
					if(data[i].componentModelId != 'req.uicomponent.common.component.label' && $.trim(data[i].name) == ''){
						rowDataIndexs.push(parseInt(i)+1);
					}
				}
				if(rowDataIndexs.length > 0){
					cui.error('第"'+rowDataIndexs+'"行，“中文名”列有错误：不能为空');
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
			
			/**
			 * 打开业务对象转表数据---业务对象属性选择 
			 * @param domainIds
			 * @param packageId
			 */
			function openSelectBizObjectMainWin(domainIds, packageId){
				var width=800; //窗口宽度
			    var height=600; //窗口高度
			    var top=(window.screen.availHeight-height)/2;
			    var left=(window.screen.availWidth-width)/2;
			    var url=webPath + '/cap/bm/biz/info/SelectBizObjectMain.jsp?tabLen=2&domainIds=' + domainIds;
			    window.open(url, "selectBizObjectMain", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
			} 

			/**
			 * 打开业务对象转表数据回调函数(批量插入数据)
			 * @param datasource 业务对象属性对象集合
			 */
			function callbackConfirm(datasource){
				_.forEach(datasource, function(obj, key){
					_.forEach(obj.dataItems, function(dataItem, key){
						if(!notAllowRepeatNameToFormGrid(dataItem.name) && !notAllowRepNameToAppeCompGrid(dataItem.name)){
							var newData = {id:Tools.randomId("id"), name:dataItem.name, value: dataItem.value ? dataItem.value: null, componentModelId:"req.uicomponent.common.component.input", colspan:"1", required:false, otherComponents:[]};
							cui("#"+getEditGridIdAttrVal()).insertRow(newData);
							if("appendComponentGrid" === getEditGridIdAttrVal()){
						        scope.selectedRowData4FormGrid.otherComponents.push(newData);
					        }
						}
					});
				});
				cap.digestValue(scope);
			}

			function notAllowRepNameToAppeCompGrid(value){
		    	if(value === ''){
		    		return true;
		    	}
		    	var count = 0;
		    	var data = cui("#"+getEditGridIdAttrVal()).getData();
		    	count = _.filter(data,{name:value}).length;
		    	if(count == 0){
		    		data = cui("#formGrid").getData();
		    		count += _.filter(data,{name:value}).length;
		        	for(var i in data){
		        		count += _.filter(data[i].otherComponents, {name:value}).length;
		        	}
		    	}
		    	return count == 1;
		    }
			
			/**
			 * 根据子功能项获取业务域Id
			 * @param reqFunSubItemId 功能子项ID
			 */
			function getDomainId(reqFunSubItemId){
				var ret = '';
				dwr.TOPEngine.setAsync(false);
				ReqFunctionSubitemAction.queryDomainByfuncSubId(reqFunSubItemId, function(data){
					ret = data ? data.id : ret;
				});
				dwr.TOPEngine.setAsync(true);
				return ret;
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
