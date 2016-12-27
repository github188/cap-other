<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
    <title>��������λ�б�</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/AssignManageAuthorityAction.js"></script>
</head>
<body>
	<div class="list_header_wrap" style="padding:0 0 10px 0px;">
	  	<div class="top_float_left">
		    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="�������λ���ơ�ȫƴ����ƴ" editable="true" width="250" on_iconclick="iconclick"  on_change="iconChange"
	        		icon="search" iconwidth="18px"></span>&nbsp;&nbsp;&nbsp;&nbsp;
	   	</div>
			<div class="top_float_right">
				<input type="checkbox" id="associateQuery" align="middle"  title="δ�����λ��ѯ" onclick="setAssociate(0)" style="cursor:pointer;"/>
				<label  onclick="setAssociate(1)" style="cursor:pointer;" id="label"><font color="#2894FF">ֻ��ʾδ�����λ</font></label>
				<span uitype="button" id="button_saveall" label="�������и�λ" on_click="doSaveAll"></span>
				<span uitype="button" id="button_add" label="����" on_click="doAdd"></span>
			</div>
	 </div>
	 <div id="doSaveAllBtn" style="display: none;text-align: left; margin-top:30px;margin-left:5px;line-height: 20px;"></div>
     <table uitype="grid" id="otherPostGrid"  primarykey="OTHER_POST_ID" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
		<th style="width:5%"><input type="checkbox" /></th>
		<th bindName="OTHER_POST_NAME" style="width:25%" renderStyle="text-align: left" sort="true">��λ����</th>
		<th bindName="OTHER_POST_CODE" style="width:25%" renderStyle="text-align: left" sort="true">��λ����</th>
		<th bindName="NAME_FULL_PATH" style="width:25%" renderStyle="text-align: left" sort="true">��������ȫ·��</th>
		<th bindName="OTHER_POST_FLAG" style="width:20%" renderStyle="text-align: left" sort="true">�Ƿ��׼��λ</th>
	</table>
 
<script language="javascript">
		var  classifyId= "<c:out value='${param.classifyId}'/>";//�ڵ�ID
	    var associateType ="<c:out value='${param.associateType}'/>";//������ѯ
	    var adminId = "<c:out value='${param.adminId}'/>";//����ԱID
	    var classifyName = "<c:out value='${param.classifyName}'/>";//������ 
	    var pageNo=""; 
	    var pageSize=""; 
	    var keyword="";
	    var dataList = null;
	    var oldResourceId_arr = [];
	    
	    
	    //��Ͻ����ID
    	var rootOrgId = "";
	    
		window.onload = function(){
		    comtop.UI.scan();
		}
		
		
		//��Ⱦ�б�����
		function initData(grid,query){
		    pageNo=query.pageNo;
		    pageSize=query.pageSize;
		    var isSelected=$('#associateQuery')[0].checked==true?1:0;
			//��ȡ�����ֶ���Ϣ
		    var sortFieldName = query.sortName[0];
		    var sortType = query.sortType[0];
		   
		    if(associateType==null){
		    	//Ĭ��Ϊ������
		    	associateType=0;
		    }
		    //���ò�ѯ����
		    var condition = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:keyword,sortName:sortFieldName,sortType:sortType};
		    condition.adminId = adminId;
		    condition.creatorId = globalUserId;
		    condition.classifyId = classifyId;
		    condition.isCascade = associateType;
		    condition.isSelected = isSelected;
		    dwr.TOPEngine.setAsync(false);
		    if(globalUserId=='SuperAdmin'){
		    	AssignManageAuthorityAction.querySuperAssignPostOtherList(condition,function(data){
			    	var totalSize = data.count;
					dataList = data.list;
					//��������Դ
					grid.setDatasource(dataList,totalSize);
	        	});
		    } else {
		    	AssignManageAuthorityAction.queryAssignPostOtherList(condition,function(data){
		    		var totalSize = data.count;
		    		dataList = data.list;
		    		grid.setDatasource(dataList,totalSize);
		    	});
		    }
		    dwr.TOPEngine.setAsync(true);
		    oldResourceId_arr = [];
			for(var index in dataList){
				if(dataList[index].ISSELECTED==2){
					oldResourceId_arr.push(dataList[index].OTHER_POST_ID);
					grid.selectRowsByPK(dataList[index].OTHER_POST_ID);
				}
			}
	  	}
	    //Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth)-21;
		}

		//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
		}
		
		
		//����Ⱦ
		function columnRenderer(data,field) {
	    	if(field == 'OTHER_POST_FLAG'){
				if(data["OTHER_POST_FLAG"]==1){
					   return "��";
				   }
				if(data["OTHER_POST_FLAG"]==2){
					   return "��";
				  }
			}
		}
		
		//�����Ƿ�ֻ��ʾδ����  1Ϊ δ���䣬0ΪĬ��
		function setAssociate(type){
			var isSelected=$('#associateQuery')[0].checked;
			if(type==1){
				if(isSelected)$('#associateQuery')[0].checked=false;
				else $('#associateQuery')[0].checked=true;
			}
			//ִ�в�ѯ
			cui("#otherPostGrid").loadData();
		}
		
		 //������ͼƬ����¼�
		 function iconclick() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
// 			setCookie("postOtherKeyword",keyword);
	        cui("#otherPostGrid").setQuery({pageNo:1});
	        //ˢ���б�
			cui("#otherPostGrid").loadData();
	     }
		 
		 //������ͼƬ����¼�
		 function iconChange() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
// 			setCookie("postOtherKeyword",keyword);
	     }
		 
		//������Ա����ָ�����������и�λ��ά��Ȩ��
		function doSaveAll(){
			var msg = "�Ƿ���Ҫ�����ࡾ"+classifyName+"���µ����и�λ�����ָ������Ա��";
			if(associateType == 1){
				msg = "�Ƿ���Ҫ�����ࡾ"+classifyName+"�������¼������µ����и�λ�����ָ������Ա��";
			}
			$('#doSaveAllBtn').html(msg);
			cui('#doSaveAllBtn').dialog({
				title:"��λ����",
				 buttons : [
	                {
	                    name : '&nbsp;&nbsp;��&nbsp;&nbsp;',
	                    handler : function() {
	                    	var condition = {};
	                    	condition.adminId = adminId;
	                		condition.classifyId = classifyId;
	                		condition.isCascade = associateType;
	                		condition.creatorId = globalUserId;
	                		dwr.TOPEngine.setAsync(true);
	                		if(globalUserId=='SuperAdmin'){
		                		AssignManageAuthorityAction.assignAllPostOther(condition, function(){
		                			cui.message('��λ��Ȩ�ɹ���','success');
		                			cui('#doSaveAllBtn').hide();
		            				setTimeout('cui("#otherPostGrid").loadData()',500);
		                		});
	                		} else {
	                			AssignManageAuthorityAction.assignAdminAllPostOther(condition, function(){
		                			cui.message('��λ��Ȩ�ɹ���','success');
		                			cui('#doSaveAllBtn').hide();
		            				setTimeout('cui("#otherPostGrid").loadData()',500);
		                		});
	                		}
	                		dwr.TOPEngine.setAsync(true);
	                    }
	                }, {
	                    name : '&nbsp;&nbsp;��&nbsp;&nbsp;',
	                    handler : function() {this.hide();}
	                }
	            ]
			}).show(); 
		}

		function doAdd(){
			// isCascade orgId  resourceList
			if(!adminId){
				return;
			}
			var selected = [];
			selected = cui("#otherPostGrid").getSelectedPrimaryKey();
			dwr.TOPEngine.setAsync(true);
			var condition = {};
			condition.adminId = adminId;
			condition.classifyId = classifyId;
			condition.isCascade = associateType;
			condition.creatorId = globalUserId;
			//ѭ����������ѡ�е��б�����
			var post_other_arr = [];
			if(selected!=null && selected.length>0){
				for(var i=0; i<selected.length; i++) {
					if(selected[i]){
						var post_other_obj = {};
						post_other_obj.subjectId= adminId;
						post_other_obj.resourceId= selected[i];
						post_other_obj.creatorId = globalUserId;
						post_other_arr.push(post_other_obj);
					}
				}
			}
			condition.resourceList = post_other_arr;
			condition.oldResourceIdList = oldResourceId_arr;
			dwr.TOPEngine.setAsync(false);
			AssignManageAuthorityAction.assignPostOther(condition,function(result) {
				if("success"==result){
					cui.message('��λ��Ȩ�ɹ���','success');
					setTimeout('cui("#otherPostGrid").loadData()',500);
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
</script>
</body>
</html>