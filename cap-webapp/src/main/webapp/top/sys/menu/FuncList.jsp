<%
/**********************************************************************
* Ӧ���б�ҳ��:Ӧ����Դ�б�ҳ
* 2014-7-6 ʯ�� �½�
**********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
    <title>Ӧ����Դ�б�ҳ</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/comtop.ui.emDialog.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/map.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/FuncAction.js"></script>
</head>
<body>
<div class="list_header_wrap" style="padding-bottom: 15px;padding-left: 1px;padding-right:5px;">
	<div class="top_float_left">
		<div class="thw_title" style="margin-top:0px;">
			<font id="pageTittle" class="fontTitle">Ӧ����Դ�б�</font> 
		</div>
		<span uitype="RadioGroup" name="ball" value="0" br="[2, 4]" on_change="changeHandler">
		        <input type="radio" value="0" text="ȫ����Դ��ͼ" />
		        <input type="radio" value="1" text="�˵���ͼ" /> 
    	</span>
	</div>
	<div class="top_float_right" <% if(isHideSystemBtn){ %> style="display:none" <% } %>>
		<span uitype="button" label="�鿴Ȩ��" id="button_right" on_click="rightRecommend"></span>
		<span uitype="button" id="sysSameButtonGroup" label="����ͬ��" menu="sysSameButtonGroup"></span>
		<span uitype="button" id="sysSubButtonGroup" label="�����¼�" menu="sysSubButtonGroup"></span>
		<span uitype="button" label="�༭" id="button_edit" on_click="updateFunc"></span>
		<span uitype="button" label="ɾ��" id="button_del" on_click="delFunc"></span>
	</div>
	<div class="top_float_right">
		<span uitype="button" label="����" id="button_up" on_click="upFunc"></span>
		<span uitype="button" label="����" id="button_down" on_click="downFunc"></span>
	</div>
</div>
<div style="padding:0 5px 0 15px">
<table id="FuncGrid" uitype="grid" datasource="dataProvider"  titlelock="true" pagination="false" selectrows="single"
	primarykey="funcId" colrender="columnRenderer" rowclick_callback="selectFuncData" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
	<tr>
		<th style="width:5%;display:none"></th>
		<th bindName="firstName" style="width:15%;" renderStyle="text-align: left">Ŀ¼/�˵�/ҳ��/����</th>
		<th bindName="secondName" style="width:15%;" renderStyle="text-align: left">�˵�/ҳ��/����</th>
		<th bindName="threeName" style="width:30%;" renderStyle="text-align: left">����</th>
	</tr>
</table>
</div>
<div style="padding-top:10px;padding-left: 15px;">
	ע��<img src="${pageScope.cuiWebRoot}/top/sys/images/func_menu_dir.gif"/>��ʾĿ¼��
		<img src="${pageScope.cuiWebRoot}/top/sys/images/func_menu.gif"/>��ʾ�˵���
		<img src="${pageScope.cuiWebRoot}/top/sys/images/func_page.gif"/>��ʾҳ�棬
		<img src="${pageScope.cuiWebRoot}/top/sys/images/func_oper.gif"/>��ʾ����
</div>
<script language="javascript"> 
	//���ڵ�ID�����ڵ�����
	var parentFuncId = "<c:out value='${param.parentResourceId}'/>";
	var parentFuncName = decodeURIComponent(decodeURIComponent("<c:out value='${param.parentName}'/>"));
	var parentPermissionType = "<c:out value='${param.permissionType}'/>";
	
	window.onload = function(){
		comtop.UI.scan();
		cui('#button_up').hide();
		cui('#button_down').hide();
		cui('.grid-head').hide();
		
		cui('#button_right').hide();
	}
	
	//����ͬ����ť��ʼ��
  	var sysSameButtonGroup = {
    	datasource: [
             {id:'insertSameMenuDir',label:'����ͬ��Ŀ¼'},
             {id:'insertSameMenu',label:'����ͬ���˵�'},
             {id:'insertSamePage',label:'����ͬ��ҳ��'},
             {id:'insertSameOper',label:'����ͬ������'}
        ],
        on_click:function(obj){
        	if(obj.id=='insertSameMenuDir'){
        		insertSameFunc(1);
        	}else if(obj.id=='insertSameMenu'){
        		insertSameFunc(2);
        	}else if(obj.id == 'insertSamePage'){
        		insertSameFunc(4);
        	}else if(obj.id == 'insertSameOper'){
        		insertSameFunc(5);
        	}
        }
    };
	
  	//�����¼���ť��ʼ��
	var sysSubButtonGroup = {
		datasource: [
             {id:'insertSubMenuDir',label:'�����¼�Ŀ¼'},
             {id:'insertSubMenu',label:'�����¼��˵�'},
             {id:'insertSubPage',label:'�����¼�ҳ��'},
             {id:'insertSubOper',label:'�����¼�����'}
        ],
        on_click:function(obj){
        	if(obj.id=='insertSubMenuDir'){
        		insertSubFunc(1);
        	}else if(obj.id=='insertSubMenu'){
        		insertSubFunc(2);
        	}else if(obj.id == 'insertSubPage'){
        		insertSubFunc(4);
        	}else if(obj.id == 'insertSubOper'){
        		insertSubFunc(5);
        	}
        }
	}
	
	//����
	function upFunc(){
		nodeSort("up");
	}
	
	//����
	function downFunc(){
		nodeSort("down");
	}
	
	//���ƻ������ƣ�sortType Ϊ up ���� down
	function nodeSort(sortType){
		//�����ǰ�б�����Ϊ0 ���� Ϊ1 ����������
		if(dataCount == 0 || dataCount == 1){
			return ;
		}
		var selData = cui("#FuncGrid").getSelectedPrimaryKey();
		if (selData.length == 0) {
		   return;
		} 
		var nodeData = cui('#FuncGrid').getRowsDataByPK(selData[0]); 
		var selectIndex = cui('#FuncGrid').getSelectedIndex(); 
		var index = selectIndex[0];
		if(sortType == 'up' && index == 0){
			//�Ѿ��ö���
			return ;
		}else if(sortType == 'down' && index == dataCount-1){
			//�Ѿ��õ���			
			return ;
		} 
		var selData = cui("#FuncGrid").getSelectedPrimaryKey();
		//���ϱ������ݣ����жϵ�ǰ��Ҫ�ƶ����������ڵڼ���
		var nodeLevel = $('input[name="checkFunc"]:checked').attr("level");
		var exchangeId = "";
		if(nodeLevel == 1){
			//����ǵ�һ�У����жϵ�ǰ��һ�м��ϵ�˳��
			exchangeId = getExchangeFuncId(firstLevelResource, sortType, nodeData[0].funcId); 
		}else if(nodeLevel == 2){
			//����ǵڶ��У����жϵ�ǰ���ڵ����ӽڵ㼯�ϵ�˳��
			exchangeId = getExchangeFuncId(secondLevelMap.get(nodeData[0].parentFuncId), sortType, nodeData[0].funcId); 
		}
		if(exchangeId != null){
			var sortArrays = [];
			sortArrays.push(exchangeId);
			sortArrays.push(nodeData[0].funcId);
			//�滻��ǰ�ڵ㼰ָ���ڵ��˳��
			dwr.TOPEngine.setAsync(false);
			FuncAction.updateFuncSortNo(sortArrays,function(data){
				//������ɺ�ˢ����Դ�б�ͬʱ����ѡ�е�ǰ�ڵ� 
				cui('#FuncGrid').loadData();
				selectFunc(nodeData[0].funcId, nodeData[0].funcNodeType, nodeData[0].funcName, nodeData[0].permissionType);
			});
			dwr.TOPEngine.setAsync(true);
		}
	}
	
	//�����Ҫ�滻˳��Ľڵ�
	function getExchangeFuncId(resourceArrays, sortType, selectFuncId){
		if(resourceArrays.length == 1){
			//����ֻ��һ�У���Ҳ��������
			return null;
		}
		var changeFuncId = "";
		for(var i=0 ;i<resourceArrays.length;i++){
			if(resourceArrays[i] == selectFuncId){
				if(sortType == 'up'){
					if(i  == 0){
						//���ϵĵ�һ�У�Ҳ��������
						return null;	
					}else{
						//��Ҫ�滻���ǵ�ǰ�е���һ�еĹ���ID
						return resourceArrays[i-1];
					}
				}else if(sortType == 'down'){
					//���ϵ����һ�У���������
					if(i == resourceArrays.length -1){
						return null;
					}else{
						//��Ҫ�滻������һ�еĹ���ID
						return resourceArrays[i+1];
					}
				}				
			}
		}
	}
	
  	//����¼��
	var dialog;
  	
  	//����ͬ��������Դ 1 �˵�Ŀ¼ 2 �˵� 4 ҳ�� 5 ���� 
  	function insertSameFunc(funcNodeType){
  		var url = '${pageScope.cuiWebRoot}/top/sys/menu/MenuEdit.jsp?actionType=add&parentFuncType=FUNC&funcNodeType='+funcNodeType;
  		if(!selectData.funcLevel || selectData.funcLevel == 1){
  			url = url + '&parentFuncId='+parentFuncId+'&parentFuncName='+encodeURIComponent(encodeURIComponent(parentFuncName)) +"&parentPermissionType="+parentPermissionType;
  		}else{
  			url = url + '&parentFuncId='+selectData.parentNodeId;
  		}
  		cui.extend.emDialog({
			id: 'funcDialog',
			title : '',
			src : url,
			width : 700,
			height : 300
	    }, window.parent.parent).show(url);
  	}
	
	//�����¼�������Դ��1 �˵�Ŀ¼ 2 �˵� 4 ҳ�� 5 ���� 
	function insertSubFunc(funcNodeType){
		var url = '${pageScope.cuiWebRoot}/top/sys/menu/MenuEdit.jsp?actionType=add&parentFuncType=FUNC&funcNodeType='+funcNodeType;
		if(selectData.funcId){
			url = url + '&parentFuncId='+selectData.funcId+'&parentFuncName='+encodeURIComponent(encodeURIComponent(selectData.funcName)) +"&parentPermissionType=" + selectData.permissionType;
		}else{
			url = url + '&parentFuncId='+parentFuncId+'&parentFuncName='+encodeURIComponent(encodeURIComponent(parentFuncName)) +"&parentPermissionType="+parentPermissionType;		
		}
		cui.extend.emDialog({
			id: 'funcDialog',
			title : '',
			src : url,
			width : 750,
			height : 300
	    }, window.parent.parent).show(url);
	}
	
	//�����ť�༭
	function updateFunc(){
		var selData = cui("#FuncGrid").getSelectedPrimaryKey();
		if (selData.length == 0) {
		    cui.alert("��ѡ��Ҫ�༭����Դ��");
		} else {
			var nodeData = cui('#FuncGrid').getRowsDataByPK(selData[0]);
			editFunc(nodeData[0].funcId, nodeData[0].funcNodeType);
		}
	}
	
	//�༭������Դ
	function editFunc(funcId, funcNodeType){
		var url = '${pageScope.cuiWebRoot}/top/sys/menu/MenuEdit.jsp?actionType=edit&funcId='+funcId+'&funcNodeType='+funcNodeType;
		cui.extend.emDialog({
			id: 'funcDialog',
			title : '',
			src : url,
			width : 750,
			height : 300
	    }, window.parent.parent).show(url);
	}
	
	//��ʾ�˵��Ľ�ɫ�͸�λ����
	function rightRecommend(){
		var selData = cui("#FuncGrid").getSelectedPrimaryKey();
		if (selData.length == 0) {
		    cui.alert("��ѡ��Ҫ�鿴����Դ��");
		} else {
			var nodeData = cui('#FuncGrid').getRowsDataByPK(selData[0]);
			var url = '${pageScope.cuiWebRoot}/top/sys/menu/RoleList.jsp?actionType=edit&funcId='+nodeData[0].funcId;
			cui.extend.emDialog({
				id: 'roleDialog',
				title : '��Ȩ��Ϣ',
				src : url,
				width : 750,
				height : 450
	    	}, window.parent.parent).show(url);
		}
	}
	
	
	//��Դ�б��л���ֻ��ʾ�˵���ȫ����ʾ
	function changeHandler(value){
		cui('#button_right').hide();
		if(value == 1){
			cui('#button_up').show();
			cui('#button_down').show();
			//ֻ��ѯĿ¼�˵�����
			condition.funcLevel = 2;
		}else{
			cui('#button_up').hide();
			cui('#button_down').hide();
			//ȫ����ѯ
			condition.funcLevel = 0;
		}
		selectData = {};
		
		cui('#sysSameButtonGroup').getMenu().disable("insertSameMenuDir",false);	
		cui('#sysSameButtonGroup').getMenu().disable("insertSameOper",false);	
		cui('#sysSameButtonGroup').getMenu().disable("insertSameMenu",false);	
		cui('#sysSameButtonGroup').getMenu().disable("insertSamePage",false);
		
		cui('#sysSubButtonGroup').getMenu().disable("insertSubMenuDir",false);	
		cui('#sysSubButtonGroup').getMenu().disable("insertSubOper",false);	
		cui('#sysSubButtonGroup').getMenu().disable("insertSubMenu",false);	
		cui('#sysSubButtonGroup').getMenu().disable("insertSubPage",false);	 
		cui('#FuncGrid').loadData();
	}
	
	//һ��Ŀ¼��ʾ
	var firstLevelResource = [];
	var secondLevelMap = new Map();
	
	var dataCount = 0;
	var condition={funcLevel:0};
	//grid����Դ
	function dataProvider(tableObj,query){
		condition.parentFuncId = parentFuncId;
		dwr.TOPEngine.setAsync(false);
		FuncAction.queryAllFunc(condition,function(data){
			firstLevelResource = [];
			secondLevelMap = new Map();
			var dataList = data;
			tableObj.setDatasource(dataList);
			if(dataList && dataList.length > 0){
				dataCount = dataList.length;
			}
		});
		dwr.TOPEngine.setAsync(true);
		jQuery('.grid-container').height(jQuery('.grid-container').height()-30);
	}
	
	//grid����Ⱦ
	function columnRenderer(data,field){
		var funcId = data["funcId"];
		var funcName = data["funcName"];
		var parentId = data["parentFuncId"];
		var funcCode = data["funcCode"];
		var funcNodeType = data["funcNodeType"];
		var permissionType = data["permissionType"];
		var funcLevel = data["funcLevel"];
		var imgurl = "${pageScope.cuiWebRoot}/top/sys/images/";
		//ָ��ͼ��
		if(funcNodeType == 1){
			imgurl = imgurl + "func_menu_dir.gif";
		}else if(funcNodeType == 2){
			imgurl = imgurl + "func_menu.gif";
		}else if(funcNodeType == 4){
			imgurl = imgurl + "func_page.gif";
		}else if(funcNodeType == 5){
			imgurl = imgurl + "func_oper.gif";
		}
		if((field == 'firstName'&&funcLevel == 1)
				||(field == 'secondName'&&funcLevel == 2)
				   ||(field == 'threeName'&&funcLevel == 3)){
			//��ʼ��һ��˳��ֵ
			if(funcLevel == 1){
				firstLevelResource.push(funcId);
			}else if(funcLevel == 2){
				//��ʼ������˳��ֵ
				var valarray = secondLevelMap.get(parentId);
				if(valarray){
					valarray.push(funcId);
				}else{
					valarray = [];
					valarray.push(funcId);
					secondLevelMap.put(parentId, valarray);
				}
			}
			return "<a href='javascript:editFunc(\""+funcId+"\",\""+data["funcNodeType"]+"\");'><input id=\""+funcId+"\" type=\"radio\" level=\""+funcLevel+"\" name=\"checkFunc\" value=\""+funcName+"\" onclick=\"selectFunc(\'"+funcId+"\',"+funcNodeType+",\'"+funcName+"\',"+permissionType+","+funcLevel+",\'"+parentId+"\')\" /> <img src=\""+imgurl+"\">&nbsp;"+funcName+"</a>";
		}
	}
	
	//ѡ��ֵ
	var selectData = {};
	
	//ѡ��Ӧ����Դ�б��е�ĳ������ 
	function selectFuncData(rowData, isChecked, index){
		selectFunc(rowData.funcId, rowData.funcNodeType, rowData.funcName, rowData.permissionType, rowData.funcLevel, rowData.parentFuncId);
	}
	
	//ѡ�й�����
	function selectFunc(funcId, funcNodeType, funcName, permissionType, funcLevel, parentNodeId){ 
		selectData.funcId = funcId;
		selectData.funcNodeType = funcNodeType;
		selectData.funcName = funcName;
		selectData.permissionType = permissionType;
		selectData.funcLevel = funcLevel;
		selectData.parentNodeId = parentNodeId;
		$('#'+funcId).attr("checked","true");
		cui('#FuncGrid').selectRowsByPK(funcId);
		//ѡ�в˵����жϵ�ǰ��������ǵ�һ����Ҳ�ǿ��������κζ���
		if(funcLevel == 1){
			cui('#sysSameButtonGroup').getMenu().disable("insertSameMenuDir",false);	
			cui('#sysSameButtonGroup').getMenu().disable("insertSameOper",false);	
			cui('#sysSameButtonGroup').getMenu().disable("insertSameMenu",false);	
			cui('#sysSameButtonGroup').getMenu().disable("insertSamePage",false);
		}
		//ѡ��Ŀ¼��Ҫ���� �˵���ҳ�水ť
		if(funcNodeType == 1){
			//Ŀ¼��Ȼ�ǵ�һ����ͬ�����������κζ�����
			cui('#sysSubButtonGroup').getMenu().disable("insertSubMenuDir",true);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubOper",true);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubMenu",false);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubPage",false);	
		}else if(funcNodeType == 2 || funcNodeType == 4){
			//ѡ�в˵���Ҫ���� ���� ��ť
			if(funcLevel == 2){
				//����ǵڶ�������ֻ������ͬ���˵�����ҳ��
				cui('#sysSameButtonGroup').getMenu().disable("insertSameMenuDir",true);	
				cui('#sysSameButtonGroup').getMenu().disable("insertSameOper",true);	
				cui('#sysSameButtonGroup').getMenu().disable("insertSameMenu",false);	
				cui('#sysSameButtonGroup').getMenu().disable("insertSamePage",false);
			}
			//�����¼�
			cui('#sysSubButtonGroup').getMenu().disable("insertSubMenuDir",true);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubMenu",true);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubPage",true);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubOper",false);
		}else if(funcNodeType == 5){
			//ѡ�в��������а�ť������
			if(funcLevel != 1){
				cui('#sysSameButtonGroup').getMenu().disable("insertSameMenuDir",true);	
				cui('#sysSameButtonGroup').getMenu().disable("insertSameOper",false);	
				cui('#sysSameButtonGroup').getMenu().disable("insertSameMenu",true);	
				cui('#sysSameButtonGroup').getMenu().disable("insertSamePage",true);
			}
			cui('#sysSubButtonGroup').getMenu().disable("insertSubMenuDir",true);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubMenu",true);
			cui('#sysSubButtonGroup').getMenu().disable("insertSubPage",true);	
			cui('#sysSubButtonGroup').getMenu().disable("insertSubOper",true);
		}
		
		if(funcNodeType != 1 && condition.funcLevel == 0 && permissionType == 2){
			cui('#button_right').show();
		}else{
			cui('#button_right').hide();
		}
	}
	
	//ɾ��ָ����Ӧ������
	function delFunc(){
	    var selData = cui("#FuncGrid").getSelectedPrimaryKey();
		if (selData.length == 0) {
		    cui.alert("��ѡ��Ҫɾ������Դ��");
		} else {
		    var msg = "ȷ��Ҫɾ��ѡ�е���Դ��";
		    var nodeData = cui('#FuncGrid').getRowsDataByPK(selData[0]);
		    cui.confirm(msg, {
		        onYes: function () {
		        	//ɾ��ҳ����߲˵�ʱֱ��ɾ����ɾ��Ŀ¼ʱ���ж��¼��Ƿ��нڵ�
		        	var hasChild = true;
		        	if(nodeData[0].funcNodeType == 1){
		        		dwr.TOPEngine.setAsync(false);
			            FuncAction.getNoDelFuncId(selData, function(data){
			            	if(data != null && data.length > 0){
		            			var selectName = nodeData[0].funcName;
			            		cui.message('Ŀ¼"' + selectName + "\"�´��ڲ˵�����ҳ�����ݣ�����ɾ����","alert");
			            		hasChild = false;
			            	}
			            });
			            dwr.TOPEngine.setAsync(true);
		        	}
		        	if(hasChild){
		        		dwr.TOPEngine.setAsync(false);
		        		FuncAction.deleteFunc(nodeData[0].funcId, nodeData[0].funcNodeType, function () {
			            	var cuiTable = cui("#FuncGrid");
	                        cuiTable.removeData(cuiTable.getSelectedIndex());
	                        cui.message("��Դɾ���ɹ���", "success");
	                        cui('#button_right').hide();
	                        cui("#FuncGrid").loadData();
			            });
		        		dwr.TOPEngine.setAsync(true);
		        	}
		        }
		    });
		}
	}
	
	//�ص�����
	function editFuncCallBack(type, key){
		//������Ϣ
		if(type=="add"){
			cui('#FuncGrid').setQuery({pageNo:1,sortType:[],sortName:[]});
			cui.message("��Դ�����ɹ���","success");
		}else{
			cui.message("��Դ�޸ĳɹ���","success");
		}
		//ˢ��Ӧ����Դ�б�ͬʱѡ��������
		cui('#FuncGrid').loadData();
		var nodeData = cui('#FuncGrid').getRowsDataByPK(key);
		if(nodeData){
			selectFunc(nodeData[0].funcId, nodeData[0].funcNodeType, nodeData[0].funcName, nodeData[0].permissionType, nodeData[0].funcLevel, nodeData[0].parentFuncId);
		}
	}
	
	//grid ���
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 38;
	}
	//grid�߶�
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 95;
	}
 </script>
</body>
</html>