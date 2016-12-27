<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>������λ�б�</title>
	<meta http-equiv="X-UA-Compatible" content="edge" />
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/comtop.ui.emDialog.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostOtherAction.js"></script>
    <style type="text/css">
    	.ie6_list_header_wrap{
    		_height:25px;
    		_overflow:hidden;
    	}
    	th{
		    font-weight: bold;
		    font-size:14px;
		}
    </style>
</head>
<body>

  <div class="list_header_wrap ie6_list_header_wrap" style="padding:0 0 10px 0px;">
	  <div class="top_float_left">
		    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="�������λ���ơ�ȫƴ����ƴ" editable="true" width="250" on_iconclick="iconclick"  on_change="iconChange"
	        		icon="search" iconwidth="18px"></span>
	   </div>
	   <top:verifyAccess pageCode="TopOtherPostAdmin" operateCode="addOrdelPost">
			<div class="top_float_right">
		       <span uiType="Button" label="���������λ" on_click="selectPost" id="addPostButton" ></span>
		        <span uiType="Button" label="ɾ��������λ" on_click="deletePost" id="deletePostButton" ></span>
			</div>
	   </top:verifyAccess>		
	 </div>
 <div id="postGridWrap">
     <table uitype="Grid" id="postGrid"   pageno="<c:out value='${param.pageNo}'/>"   pagesize="<c:out value='${param.pageSize}'/>"   primarykey="postId"  sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer">
		<th style="width:30px"><input type="checkbox"/></th>
		<th bindName="postName" sort="true" style="width:30%">��λ����</th>
		<th bindName="postCode" sort="true"  style="width:20%">��λ����</th>
		<th bindName="orgFullName" sort="true" style="width:50%;"  renderStyle="text-align: center">������֯ȫ·��</th>
	</table>
 
 </div>
<script language="javascript">
	   
	   //��׼��λid
        var postId ="<c:out value='${param.postId}'/>";
        var rootOrgId = "<c:out value='${param.rootOrgId}'/>";//����֯id 
	    var keyword="";
	    
		
		window.onload = function(){
		    	comtop.UI.scan();
		}
		
		
		//��Ⱦ�б�����
		function initData(grid,query){

				//��ȡ�����ֶ���Ϣ
			    var sortFieldName = query.sortName[0];
			    var sortType = query.sortType[0];
			  
			    //���ò�ѯ����
			    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,postName:keyword,sortFieldName:sortFieldName,sortType:sortType,postId:postId};
			    dwr.TOPEngine.setAsync(false);
			    PostOtherAction.queryPostListByStandard(queryObj,function(data){
			    	var totalSize = data.count;
					var dataList = data.list;
					//��������Դ
					grid.setDatasource(dataList,totalSize);
	        	});
			    dwr.TOPEngine.setAsync(true);
			
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
	        cui("#postGrid").setQuery({pageNo:1});
	        //ˢ���б�
			cui("#postGrid").loadData();
	     }
		 
	
		 
		 //������ͼƬ����¼�
		 function iconChange() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
	     }
		 
			//ѡ��������λ
			function  selectPost(){
				var url='${pageScope.cuiWebRoot}/top/sys/post/PostSelectMain.jsp?rootOrgId='+rootOrgId+"&postId="+postId;
				var height =  750;
				var width =  500;
				
				cui.extend.emDialog({
					id: 'selectPost',
					title : '��λѡ��ҳ��',
					src : url,
					width : height,
					height : width
			    }).show(url);
				
			} 
			
			//ɾ��������λ
			function  deletePost(){
			
				  var selectIds = cui("#postGrid").getSelectedPrimaryKey();

					if(selectIds == null || selectIds.length == 0){
						cui.alert("��ѡ��ɾ���ĸ�λ��");
						return;
					}

					 dwr.TOPEngine.setAsync(false);
					 PostOtherAction.updatePostStandardRelation(postId,selectIds,2,function(){
					    	window.cui.message('ɾ���ɹ���','success');
					 		cui("#postGrid").loadData();
			     	 });
					 dwr.TOPEngine.setAsync(true);
			} 
			
		 
		 

</script>
</body>
</html>