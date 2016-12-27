<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>�������ڵ���Ϣ</title>
    <meta http-equiv="X-UA-Compatible" content="edge" />
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/comtop.ui.emDialog.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/WorkflowAction.js"></script>
    <style type="text/css">
    	.ie6_list_header_wrap{
    		_height:25px;
    		_overflow:hidden;
    	}
    </style>
</head>
<body>

  <div class="list_header_wrap ie6_list_header_wrap">
	    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="�������������ƻ�ڵ�����" editable="true" width="250" on_iconclick="iconclick"
        		icon="search" iconwidth="18px"></span>
		<div class="top_float_right">
		<top:verifyAccess pageCode="TopPostAdmin" operateCode="addOrdelWorkflow">
			<span uiType="Button" label="�������̽ڵ�" on_click="selectWorkflow" id="selectWorkflow"></span>
		    <span uiType="Button" label="ɾ�����̽ڵ�" on_click="deleteWorkflowFromPost" id="deleteWorkflowFromPost"></span>
		</top:verifyAccess>
		</div>
 </div>
 <div id="userGridWrap">
     <table uitype="Grid" id="workflowGrid" primarykey="nodePostRelId"  gridheight="auto" sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
        <th  style="width:30px;"><input type="checkbox"></th>
		<th  bindName="processName" sort="true">����������</th>
		<th  bindName="nodeName" sort="true" >�ڵ�����</th>
		<th  bindName="userGroupValue" sort="true" >��Ա����</th>
		<th  bindName="moduleName"  sort="false"  renderStyle="text-align: center" >����ģ��</th>
	</table>
 
 </div>
<script language="javascript">
		var postId = "<c:out value='${param.postId}'/>"; 
		var postName = decodeURIComponent(decodeURIComponent("<c:out value='${param.postName}'/>"));
		var orgName= decodeURIComponent(decodeURIComponent("<c:out value='${param.orgName}'/>"));
	    var keyword="";
	  
	  //��ѡ���е������������������༭ʱ�Զ�ѡ��
		var selectedKey='';
	  
		$(document).ready(function(){
			comtop.UI.scan();
		});
		
		
		//��Ⱦ�б�����
		function initData(grid,query){
			//��ȡ�����ֶ���Ϣ
		    var sortFieldName = query.sortName[0];
		    var sortType = query.sortType[0];
		    //���ò�ѯ����
		    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:keyword,sortFieldName:sortFieldName,sortType:sortType,postId:postId};
		    WorkflowAction.queryWorkflowList(queryObj,{
		    	callback:function(data){
			    	var totalSize = data.count;
					var dataList = data.list;
					//��������Դ
					grid.setDatasource(dataList,totalSize);
					if(selectedKey!=''){
						grid.selectRowsByPK(selectedKey);
						selectedKey='';
					}
	        	},
	        	errorHander:function(){
	        		cui.error("��ѯ��������Ϣ����");
	        	},
	        	exceptionHandler:function(){cui.error("��ѯ��������Ϣ����");}
		    });
	  	}
	    //Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth)-20;
		}

		//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 60;
		}
		
		
		 //������ͼƬ����¼�
		 function iconclick() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
	        cui("#workflowGrid").setQuery({pageNo:1});
	        //ˢ���б�
			refresh();
	     }
		 
		 
		    
		//�Ӹ�λɾ����ɫ����
		function deleteWorkflowFromPost(){
			var selectIds = cui("#workflowGrid").getSelectedPrimaryKey();
			if(!selectIds||selectIds.length==0){
				cui.alert("��ѡ��Ҫɾ�������̽ڵ㡣");
				return;
			}
			WorkflowAction.deleteWorkflowFromPost(selectIds,{
				callback:function(){
			    	window.cui.message('���̽ڵ�ɾ���ɹ���','success');
			    	refresh();
	        	},
				errorHander:function(){
	        		cui.error("ɾ���������ڵ����");
	        	},
	        	exceptionHandler:function(){cui.error("ɾ���������ڵ����");}
			});
		}   
		
		/***
		ˢ���б�
		*/
		function refresh(){
			cui("#workflowGrid").loadData();
		}

		//�򿪹���������ҳ��
		function  selectWorkflow(){
			var url='${pageScope.cuiWebRoot}/top/sys/post/WorkFlowRelate.jsp?postId='+postId+"&postName="+encodeURIComponent(encodeURIComponent(postName))+"&orgName="+encodeURIComponent(encodeURIComponent(orgName));
			var height = $(window.top).height()-100;
			var width =  $(window.top).width();
			var dialog ;
			if(window.top.cuiEMDialog&&window.top.cuiEMDialog.dialogs){
				dialog = window.top.cuiEMDialog.dialogs["selectWorkflow"];
			}
			if(!dialog){
				dialog=	cui.extend.emDialog({
					id: 'selectWorkflow',
					title : '�����������ڵ�',
					src : url,
					width : width,
					height : height,
					onClose:refresh
			    });
			}else{
				dialog.reload(url);
			}
			dialog.show();
		} 
</script>
</body>
</html>