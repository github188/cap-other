
<%
    /**********************************************************************
	 * ��ԱȨ�޲鿴
	 * 2014-07-08 л��  �½�
	 * 2015-03-25 ����  ����
	 **********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<html>
<head>
<title>��ԱȨ�޲鿴</title>

<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/css/choose.css" type="text/css"/>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/js/choose.js" ></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/AuthorityFinderAction.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ChooseAction.js" ></script>

</head>
<style type="text/css">

html{width:97%;} 
th {
	font-weight: bold;
	font-size: 14px;
}
 .post_label {
        display: inline-block;
        padding: 2px 4px;
        font-size: 12px;
        font-weight: bold;
        line-height: 14px;
        color: #fff; 
        vertical-align: baseline;
        white-space: nowrap;
        text-shadow: 0 -1px 0 rgba(0,0,0,0.25);
        border-radius: 3px;
        cursor: pointer;
        margin:2px 5px;
    }
    .post_name_color{
        background-color: #22A7B8; 
    }
    .post_other_name_color{
    	background-color: #38B3E8; 
    }
</style>

<body>
	<div style="width: 90%;">
		<table class="form_table" style="table-layout:fixed;">
			<tr>
				<td class="td_content" style="text-align: center">
					<span uitype="ChooseUser" id="userId" name="userId" width="400px" height="29px"  chooseMode="1" userType="1"  isSearch="true" callback='keyWordQuery'>
					</span>
				</td>
			</tr>
			<tr >
				<td class="divTitle" style="padding-left:10%;">��λ��Ϣ</td>
			</tr>
			<tr>    
				<td id="role_div" style="padding-left:15%;">
					<div id="post_div">��</div>
				</td>
			</tr>
			<tr>
				<td class="divTitle" style="padding-left:10%;">Ȩ���б�</td>
			</tr>
			<tr>
				<td>
					<div id="menuAuthorityDiv" style="padding-left:11%; width: 80%;">
						 <div style="margin-bottom:8px; margin-right: 5px;"> 
							    <span uitype="clickInput"  editable="true" id="keyword" name="keyword" on_iconclick="iconclick" 
										emptytext="����Ӧ����������" icon="search" width="240px" enterable="true"></span>
								<div uitype="checkboxGroup" id="showAllPermissionFunc" name="showAllPermissionFunc" on_change="showAllPermission" style="margin-left: 18px;">
								 		<input type="checkbox" name="showAllPermissionFuncbox" id="showAllPermissionFuncCheckbox" value="1" > ֻ��ʾ��ȨӦ��
								 </div>
								<span style="margin-left: 18px;">
									Ӧ�÷��ࣺ<span id="classifyTypeName" uitype="PullDown" mode="Single" value_field="CLASSIFYID" label_field="CLASSIFYNAME" datasource="initClassifyTypeNameData" empty_text="��ѡ�����" on_change="changeClassifyType"></span>
								</span>		
			  			</div> 
						<table id="menuAuthorityGrid" uitype="grid" datasource="menuDataProvider" selectrows="no" pagination="true" titlelock="false" 
							 primarykey="funcId" colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
							<tr>
								<th bindName="funcName" style="width:20%;" renderStyle="text-align: left">Ӧ������</th>
								<th bindName="funcCode" style="width:20%;" renderStyle="text-align: left">Ӧ�ñ���</th>
								<th bindName="permissionType" style="width:10%;" renderStyle="text-align: center">�Ƿ�����Ȩ</th>
								<th bindName="classifyName" style="width:20%;" renderStyle="text-align: center">Ӧ�÷���</th>
							</tr>
						</table>
				</td>
			</tr>
		</table>
	</div>
	
<script language="javascript">
	var keyword="";//��ѯ�ؼ���
	$(document).ready(function() {
		comtop.UI.scan();
	});
	
	/**
	* Ӧ�÷�������Դ
	*/
	function initClassifyTypeNameData(obj){
		var names = [];
		if(cui("#userId").getValue()!=null && cui("#userId").getValue().length>0){
			var userId_val = cui("#userId").getValue()['0']['id'];
			//�ӵ��ļ���ȫ��������
			names.push({'CLASSIFYID':'all','CLASSIFYNAME':'ȫ��'});
			dwr.TOPEngine.setAsync(false);
			AuthorityFinderAction.getCategory(userId_val,function(data){
				if(data&&data.length>0){
					for(var i = 0 ;i<data.length;i++){
							names.push(data[i]);
					}
				}
			});
			dwr.TOPEngine.setAsync(true);
			obj.setDatasource(names);
		}else{
			obj.setDatasource(names);
		}
	}
	
	var showAllPermissionFunc;
	function showAllPermission(){
		var values = cui('#showAllPermissionFunc').getValue(); 
		if(values &&  values.length == 1 && values[0] == 1){
			showAllPermissionFunc = 'yes'
		}else{
			showAllPermissionFunc = 'no'
		}
		 //���²�ѯ������ҳ��Ϊ1
		cui("#menuAuthorityGrid").setQuery({pageNo:1});
		cui("#menuAuthorityGrid").loadData();
	}
	
	function changeClassifyType(){
		cui("#menuAuthorityGrid").loadData();
	}
	/**
	** ��ѯ��ԱȨ��
	**/
	function keyWordQuery(){
		var userId_val = "";
		if(cui("#userId").getValue()!=null && cui("#userId").getValue().length>0){
			userId_val = cui("#userId").getValue()['0']['id'];
		}
		AuthorityFinderAction.queryPostListByUserId(userId_val,function(data){
			var postInfo = data;
			if(postInfo&&postInfo.length>0){
                 var postName = [];
                 for(var i=0;i<postInfo.length;i++){
                	 if(postInfo[i].POSTNAME){
                		 if(postInfo[i].POSTTYPE == 1){
		                     postName.push($('<label class="post_label post_name_color" title="'+postInfo[i].FULLNAME+'">'+postInfo[i].POSTNAME+'</label>').data('post-info',postInfo[i]));
                		 }else{
                			 postName.push($('<label class="post_label post_other_name_color" title="'+postInfo[i].FULLNAME+'">'+postInfo[i].POSTNAME+'</label>').data('post-info',postInfo[i]));
                		 }
                	 }
                 }
                 $('#post_div').html(postName);
			}else{//�޸�λ��Ϣ�����
				  $('#post_div').html("��");
			}
		});
			cui("#menuAuthorityGrid").setQuery({pageNo:1,sortType:[],sortName:[]});
			cui("#menuAuthorityGrid").loadData();
			//���¼���classifyTypename����
			initClassifyTypeNameData(cui('#classifyTypeName'));
	}
		
  $('#post_div').on('click','.post_label',function(){
			   var postInfo = $(this).data('post-info');
			   cui.dialog({
			       src:webPath + '/top/workbench/personal/RoleListForPost.jsp?postId='+postInfo.POSTID,
		            refresh:false,
		            modal: true,
		            title: '��ɫ�б�',
		            width:600,
		            height:400
			   }).show();
			});

	//���̻س�����ѯ 
	function keyDownQuery() {
		if ( event.keyCode ==13) {
			keyWordQuery();
		}
	}
	
	//����grid��� 
	function resizeWidth() {
		return (document.documentElement.clientWidth || document.body.clientWidth) - 200;
	}

	//����grid�߶�
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 250;
	}
	//չʾ����
	function menuDataProvider(tableObj,query){
		//��ȡ�����ֶ���Ϣ
		var sortFieldName = query.sortName[0];
	    var sortType = query.sortType[0];
		var condition = {pageNo:query.pageNo,pageSize:query.pageSize,
				sortFieldName:sortFieldName,
				sortType:sortType};
		
		var userId = "";
		if(cui("#userId").getValue()!=null && cui("#userId").getValue().length>0){
			userId = cui("#userId").getValue()['0']['id'];
			condition.userId = userId;
			//�ؼ��ֲ�ѯ
			condition.keyword = keyword;
			//����ȨӦ�ò�ѯ
			if(showAllPermissionFunc == 'yes'){
				condition.permissionType = 2;
			}
			//�������ѯ
			var classifyType = cui('#classifyTypeName').getValue();
			if(classifyType){
				condition.classifyId = classifyType;
			}
			dwr.TOPEngine.setAsync(false);
			AuthorityFinderAction.queryPersonFuncList(condition,function(data){
		    	tableObj.setDatasource(data.list, data.count);
			});
			dwr.TOPEngine.setAsync(true);
		}else{
			tableObj.setDatasource([],0);
		}
	}

	//������ͼƬ����¼�
	function iconclick() {
		keyword = cui("#keyword").getValue().replace(new RegExp("/", "gm"), "//");
		keyword = keyword.replace(new RegExp("%", "gm"), "/%");
		keyword = keyword.replace(new RegExp("_","gm"), "/_");
		keyword = keyword.replace(new RegExp("'","gm"), "''");
	   cui("#menuAuthorityGrid").setQuery({pageNo:1});
	   //ˢ���б�
		cui("#menuAuthorityGrid").loadData();
	}
	
	/**
	*����Ⱦ
	**/
	function columnRenderer(data,field) {
		if(field == "permissionType"){
			if(data["permissionType"] == 1){
				return "��";
			}else{
				return "��";
			}
		}else if(field == "funcName"){
			return "<a onclick='javascript:viewFuncPermission(\"" + data["funcId"] + "\",\""+data["funcName"]+"\");'><font style='color:#096DD1;'>" + data["funcName"] + "</font></a>";
		}else if(field == 'classifyName' && !data["classifyName"]){
			return "����";
		}
	}
	
	/**
	* չ��Ȩ��
	*/
	function viewFuncPermission(funcId, funcName){
		var userId = "";
		if(cui("#userId").getValue()!=null && cui("#userId").getValue().length>0){
			//����ѯ����Աid
			userId = cui("#userId").getValue()['0']['id'];
		}
		var height = (document.documentElement.clientHeight || document.body.clientHeight)-100;
		var width = (document.documentElement.clientWidth || document.body.clientWidth)-100;  
		var url = 'PersonAccessFuncList.jsp?funcId=' + funcId + "&userId=" + userId; 
		var title = "��" + funcName + "��Ȩ����Ϣ";
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		});
		dialog.show(url);
	}
</script>
</body>
</html>
