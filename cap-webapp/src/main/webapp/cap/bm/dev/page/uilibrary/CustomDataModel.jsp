<%
/**********************************************************************
* dataModel属性
* 2015-05-07 诸焕辉  
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<title>数据模型属性</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/hint/show-hint.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/display/fullscreen.css"></top:link>
    <style type="text/css">
    	.cap-table-fullWidth{
			margin-bottom: 5px;
		}
		.CodeMirror {
			height:493px;
		}
		.readCodeArea, .writeCodeArea{
			border-radius: 3.01px;
    		box-shadow: 0 2px 2px rgba(0,0,0,.1) inset;
    		transition: border .3s linear 0s;
    		border: 1px solid #ccc;
			-moz-transition:border .3s linear 0s;
			-webkit-transition:border .3s linear 0s;
			-o-transition:border .3s linear 0s
		}
	</style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/mode/javascript/javascript.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/show-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/javascript-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/display/fullscreen.js"></top:script>
	<top:script src="/cap/bm/common/base/js/jsformat.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/ComponentFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/BuiltInActionPreferenceFacade.js"></top:script>    
</head>
<body class="body_layout">
	<div class="cap-page">
		<div class="header" style="position: absolute;right: 16px; top: 16px; z-index: 1000">
			<span id="resetBtn" uitype="Button" on_click="reset" label="重置"></span> 
			<span id="ensureBtn" uitype="button" on_click="ensure" label="确定" ></span>
			<span id="closeWinBtn" uitype="button" on_click="closeWin" label="关闭" ></span>
		</div>
		<div class="cap-area" id="tab_area" uitype="tab" closeable="true"> 
			<div data-options='{"closeable":"false","tab_width":"70","title":"自定义数据"}'>
		        <table class="cap-table-fullWidth">
					<tr>
				        <td class="cap-td" style="text-align: left;">
				        	<span>
					        	<blockquote class="cap-form-group" style="margin: 0">
									<span>样板区域</span>
								</blockquote>
							</span>
				        </td>
				        <td class="cap-td" style="text-align: left;">
				        	<span>
					        	<blockquote class="cap-form-group">
									<span>代码自定义区域</span>
								</blockquote>
							</span>
				        </td>
				        <td class="cap-td" style="text-align: right; width:40%; padding: 5px 5px 0 0" align="right">
				        	<span uitype="button" id="codeformatterBtn" label="格式化" on_click="doFormat" ></span>
				        </td>
				    </tr>
				    <tr>
				        <td class="cap-td" style="text-align: left;">
				        	<div class="readCodeArea" style="width: 354px"><textarea id="codeTmp" name="codeTmp"></textarea></div>
				        </td>
				        <td class="cap-td" style="text-align: left;" colspan="2">
				        	<div class="writeCodeArea" style="width: 400px"><textarea id="code" name="code"></textarea></div>
				        </td>
				    </tr>
				</table>
		    </div>
		    <div data-options='{"closeable":"false","tab_width":"70","title":"行为函数"}' id="action_tab_item">
		    	<table width="100%">
				    <tr>
				        <td class="cap-td" style="text-align: left;padding:5px">
				        	行为类型：<span uitype="PullDown" id="actionType" mode="Single" width="100" select="0" value_field="id" label_field="text" datasource="initActionType" on_change="selectActionType"></span>&nbsp;&nbsp;
				        	<span uitype="ClickInput" id="quickSearch" width="240" name="search" editable="true" on_keydown="keyDownQuery" on_iconclick="keyWordQuery" emptytext="请输入行为中文名称" icon="search"></span>
				        </td>
				        <td class="cap-td" style="text-align: right;padding:5px">
				             <span id="addPageAction" uitype="Button" onclick="addPageAction()" label="新增"></span> 
				        </td>
				    </tr>
				</table>
				<table class="cap-table-fullWidth">
				    <tr>
				        <td class="cap-td">
				        	<table uitype="Grid" id="pageAction" primarykey="pageActionId" selectrows="single" colhidden="false" datasource="initPageActionData" pagination="false"
							 	resizewidth="getBodyWidth" resizeheight="getBodyHeight" primarykey="pageActionId" colrender="columnRenderer">
								<thead>
									<tr>
									    <th style="width:25px"></th>
										<th  style="width:35px" renderStyle="text-align: center;" bindName="1">序号</th>
										<th  style="width:20%" renderStyle="text-align: center;" render="editPage" bindName="cname">行为中文名称</th>
										<th  style="width:20%" renderStyle="text-align: center;" bindName="ename">行为英文名称</th>
										<th  style="width:20%" renderStyle="text-align: center;" bindName="actionDefineVO.modelName">行为模板</th>	
										<th  style="width:20%" renderStyle="text-align: center;" bindName="pageActionId" render="actionTypeRender">行为类型</th>		 
										<th  style="width:30%" renderStyle="text-align: left" bindName="description">描述</th>
									</tr>
								</thead>
							</table>
				        </td>
				    </tr>
				</table>
		    </div>
		</div>
	</div>
	<script type="text/javascript">
		var pageId = "<c:out value='${param.modelId}'/>";
		var packageId = "<c:out value='${param.packageId}'/>";
	   	var pageSession = new cap.PageStorage(pageId);
	   	var pageActions = pageSession.get("action");
		var propertyName = "<c:out value='${param.propertyName}'/>";
		var scopeName = "<c:out value='${param.scopeName}'/>";
		var scope = scopeName != '' ? eval("window.opener."+scopeName) : window.opener.scope;
		var initValue = scope.data.hasOwnProperty(propertyName) === true ? scope.data[propertyName] : scope.data.edittype.data[propertyName];
		var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
		var propertyVo = queryProperty(propertyName);
		var uitype = queryProperty('uitype').defaultValue;
		var defaultValue = propertyVo.defaultValue;
		var propertyType = propertyVo.type;
		var type = "<c:out value='${param.type}'/>"; 
		var removeTabIndex = "<c:out value='${param.removeTabIndex}'/>";
		//内置行为函数集合
		var lstBuiltInAction = removeTabIndex == 1 ?  [] : queryBuiltInActionList();
		var defaultValues = {
				PullDown: {datasource: '[{id:"item1",text:"选项1"},{id:"item2",text:"选项2"},{id:"item3",text:"选项3"}]'}, 
				RadioGroup: {radio_list: '[{text:"值1",value:1},{text:"值2",value:2},{text:"值3",value:3}]'}, 
				CheckboxGroup: {checkbox_list: '[{text:"值1",value:1},{text:"值2",value:2},{text:"值3",value:3}]'},
				Button: {menu: '{datasource: [{id: "1",label:"值1"},{id: "2", label: "值2"}],on_click: function(obj) {}}'},
				Menu: {datasource: '[{id:"item1",label:"选项1"},{id:"item2",label:"选项2"},{id:"item3",label:"选项3"}]'},
				Tree: {children: '[{title:"设备类别结构",key:"k1"},{title:"Folder 2",key:"k2",isFolder:"true"},{title:"其他",key:"k3",hideCheckbox:"true"}]'},
				ListBox: {datasource: '[{id:"item1",text:"选项1"}, {id:"item2",text:"选项2"}, {id:"item3",text:"选项3"}]'},
				CodeArea: {text: '<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<title>标题</title>\n\t\t<meta http-equiv="Content-Type" content="text/html charset=UTF-8">\n\t</head>\n\t<body>\n\t</body>\n</html>'},
				Editor: {toolbars: '[["anchor", "redo", "bold", "indent", "italic"]]'}
		};
		
		//选中的行为数据回调
		function selectPageActionData(objAction,flag){
			cui("#quickSearch").setValue(''); 
			cui("#actionType").setValue("0");  
			cui("#pageAction").addData(objAction);
			cui("#pageAction").selectRowsByPK(objAction.pageActionId, true);
		}
		
		//初始化行为类型pulldown数据源
		function initActionType(obj){
			obj.setDatasource([{id:'0',text:'全部'},{id:'1',text:'内置'},{id:'2',text:'自定义'}]);
		}
		
		//新增行为
		function addPageAction(){
			var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageActionEdit.jsp?modelId='+pageId+'&packageId='+packageId+"&operationType=insert&showGobackBtn=false&actionType="+actionType+'&type='+type;
		    var width=800; //窗口宽度
		    var height=650;//窗口高度
		    var top=(window.screen.height-30-height)/2;
		    var left=(window.screen.width-10-width)/2;
		    window.open(url, "pageActionEdit", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
		}
		
		//行为类型改变选择事件
		function selectActionType(){
			keyWordQuery();
		}
		
		 //快速查询,根据行为中文名称过滤数据
		function keyWordQuery(){
			var keyWord = cui("#quickSearch").getValue(); 
			var actionType = cui("#actionType").getValue();  
			var showPageActionData = getShowPageActionData();
			if(keyWord != ""){
				var serchPageActions = new cap.CollectionUtil(showPageActionData);
			    var lstSerchPageActions = serchPageActions.query("this.cname.indexOf('"+ keyWord +"') != -1");
			    cui("#pageAction").setDatasource(lstSerchPageActions,lstSerchPageActions.length);
			}else{
				cui("#pageAction").setDatasource(showPageActionData,showPageActionData.length);
			}
		}
		 
		//键盘回车键快速查询 
		function keyDownQuery() {
			if (event.keyCode ==13) {
				keyWordQuery();
			}
		}
		
		//获取内置行为方法
	    function queryBuiltInActionList(){
	    	var builtInActionList = [];
	    	var page = pageSession.get("page");
			var includeFileList = page.includeFileList;
			var filePaths=[];
			for(var i=0;i<includeFileList.length;i++){
				if(includeFileList[i].fileType === 'js'){
					filePaths.push(includeFileList[i].filePath);
				}
			}
			dwr.TOPEngine.setAsync(false);
			BuiltInActionPreferenceFacade.queryListByFileName(filePaths,function(data){
				if(data!=null){
					builtInActionList = data;
				}
			});	
			dwr.TOPEngine.setAsync(true);
			return builtInActionList;
	    }
		
		//初始化页面模板列表
		function initPageActionData(gridObj, query) {
			var dataSource = getShowPageActionData();
			gridObj.setDatasource(dataSource, dataSource.length);
		}
		
		//页面展示可供选择的行为
		function getShowPageActionData(){
			var selectActionType = cui("#actionType").getValue();
			var allPageActions =[];//行为函数
			var pageActions4built = [];//内置行为
			if(selectActionType == "0"){
				allPageActions = jQuery.extend(true, [], pageActions);
				pageActions4built = lstBuiltInAction;
			} else if(selectActionType == "1"){
				pageActions4built = lstBuiltInAction;
			} else {
				allPageActions = pageActions;
			}
			if(pageActions4built.length > 0){
				for(var i in pageActions4built){
					var objbuiltInAction = pageActions4built[i];
					var objAction ={pageActionId:objbuiltInAction.actionMethodName,cname:objbuiltInAction.description,ename:objbuiltInAction.actionMethodName,description:objbuiltInAction.description,actionDefineVO:{modelName:""}};
					allPageActions.push(objAction);
				}
			}
	    	return allPageActions;
		}
		
		//行为类型列渲染函数
		function actionTypeRender(rd, index, col) {
			return $.isNumeric(rd.pageActionId) ? "自定义" : "内置";
		}
		
		/**
		 * 表格自适应宽度
		 */
		function getBodyWidth () {
		    return (document.documentElement.clientWidth || document.body.clientWidth) - 33;
		}

		/**
		 * 表格自适应高度
		 */
		function getBodyHeight () {
		    return (document.documentElement.clientHeight || document.body.clientHeight) - 110;
		}
		
		
		/**
		 * 查找属性
		 * @param 属性英文名称
		 */
		function queryProperty(ename){
			var propertyVo = {};
			var properties = scope.component.properties;
			for(var i in properties){
				if(properties[i].ename === ename){
					propertyVo = properties[i];
					break;
				}
			}
			return propertyVo;
		}
		
		//清空
		function reset(){
			editor.setValue('');
			cui("#pageAction").loadData();
		}
		
		//确定（如果自定义数据和行为函数都有值，优先选择行为函数）
		function ensure(){
			var val = $.trim(editor.getValue());
			var selectRowData = cui("#pageAction").getSelectedRowData();
			if(selectRowData.length > 0){
				val = selectRowData[0].ename;
			} 
			try{
				if(propertyType == 'String'){
					val = val.replace(/"/g, '\\"');
				}
				window.opener[callbackMethod](propertyName, val);
			    closeWin();
			}catch(err){ 
				console.log(err);
			}
			
	    }
		
		//关闭窗口
		function closeWin(){
			window.close();
		}
	
		//创建codeMirror组件
		var editorTmp = CodeMirror.fromTextArea(document.getElementById('codeTmp'), {
	    	lineNumbers: true,
	        //根据页面类型生成codeMirror类型
            viewportMargin: Infinity,
            theme: "eclipse",
            mode: "javascript",
            lineWrapping:true,
            readOnly:true
		});
		
		//创建codeMirror组件
		var editor = CodeMirror.fromTextArea(document.getElementById('code'), {
	    	lineNumbers: true,
	        //根据页面类型生成codeMirror类型
            viewportMargin: Infinity,
            theme: "eclipse",
            mode: "javascript",
            lineWrapping:true
		});
		
		//格式化json代码
		function doFormat(){
			var value = $.trim(editor.getValue());
			if(value != ''){
				editor.setValue(jsCodeformatter(value));
			}
		}
		
		/**
		 * 格式化js代码
		 * @param txt js代码
		 */
	 	function jsCodeformatter(txt){
	 		txt = txt.replace(/^\s+/, ''); 
	        if (txt && txt.charAt(0) === '<') {
	        	txt = style_html(txt, 4, ' ', 80);
	        } else {
	        	txt = js_beautify(txt, 4, ' ');
	        }
			return txt;
	 	}
		
		//初始化页面数据
		function initPage(){
			var pageAction = _.find(cui("#pageAction").getData(), {ename: initValue});
	        if(pageAction){
	        	cui("#pageAction").selectRowsByPK(pageAction.pageActionId, true);
	        	cui("#tab_area").switchTo(1);
	        } else if(propertyType == 'Json'){
			    editor.setValue(jsCodeformatter(initValue));
	        } else {
	        	editor.setValue(initValue.replace(/\\/g, ''));
	        }
	        //初始化样板区域案例
	        if(propertyType == 'Json'){
	        	editorTmp.setValue(jsCodeformatter(defaultValues[uitype][propertyName]));
	        } else if (propertyType == 'String'){
		        cui("#codeformatterBtn").hide();
	        	editorTmp.setValue(defaultValues[uitype][propertyName]);
	        }
		}
		
		jQuery(document).ready(function(){
			var title = uitype + '_' + propertyName + '属性编辑';
			$("title").text(title);
	        comtop.UI.scan();
	        initPage();
	        if(removeTabIndex){
				cui("#tab_area").removeTab(removeTabIndex);
	        }
	    });
	</script>
</body>
</html>

