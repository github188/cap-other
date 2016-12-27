/**
 * ��;����jsΪ���ò���js
 *
 * ������
 * 		webPath����Ŀ�ĸ�path
 * 		objDept�����ò��Ű��¼���������ѡ��ĳ�����ò���ʱ����Ϊѡ�е�dom���� 
 * 		updateLinkId����ǰ�޸ĵķ���id
 * 		jctTemplate�����泣�ò��ŵ�ģ���ִ�
 * 		gGroupId�����ò�����id 
 * 		prefixOfDeptQueryFavorite��������<a>��ǩ��class�����ò���
 * 		pageNo: �ڼ��ε����������
 * 		currentIndex��������������,ѡ��a��λ��
 */
// ���ò��Ű��¼���������ѡ��ĳ�����ò���ʱ����Ϊѡ�е�dom����
var objDept={}; 
// ��ǰ�޸ĵķ���id
var updateLinkId;
// ���泣�ò��ŵ�ģ���ִ�
var jctTemplate=null;
// ���ò�����id
var gGroupId;   
// �Ƿ��Ѽ��س�����ϵ������
var isOnloadFavoriteData = false;  

var tempFavoriteFunc,tempNoDataFavoriteFunc;
/**
 * ������
 * 		addFavoriteGroup() ��ӳ��ò��ŷ���  ת�Ƶ�deptMultSelectPage.jsp
 * 		calcelGroup() ��ӳ��ò��ŷ�����ȡ����ť�¼�
 * 		saveGroup() ���ò�����ӷ�����ȷ���¼�,���泣�ò��ŷ���
 * 		groupOnclick(obj) ���ò��ŷ����ϵ����¼� չ����رշ���
 * 		addFavoriteDept(groupId) ��ӳ��ò���
 * 		checkGroupName(groupName) ��������Ƿ��ظ�
 * 		cancelUpdateGroup(linkId) ���ò��ŷ������޸����ƺ�ȡ����ť�¼�
 * 		groupOnMouseOver(obj) ���ò��Ź��over�¼�
 * 		groupOnMouseOut(obj) ���ò��Ź��out�¼�
 * 		updateGroupName(oldGroupName,groupId) ���³��ò��ŷ�������
 * 		queryDataOfFavorite() ���ò��������������ѯ
 * 		bindEvent() ��ӳ��ò������еİ󶨵���¼�
 * 		deleteFavoriteById(favoriteId) ɾ�����ò���
 */

var isReloadData = true;

/**
 * �����ѡ��ĳ�����ϵ��/��֯ ��ӵ��ұ���ѡ��
 * @param selected Ҫ��ӵ�liԪ�ض���
 * @param �Ƿ����ѡ��
 * */
function putSelectedFavoriteToBox(selected,isClear){
	if(selected&&selected.length){
		var obj={};
		var $ele;
		for(var i=0;i<selected.length;i++){
			$ele = selected.eq(i);
			obj=_buildSelectedData($ele);
			var put= putToSelectedBox(obj);
			if(put&&!isClear){
				clearSelectedFavorite($ele);
			}
		}
	}
}

/**
 * ˫����ߵĳ�����ϵ��/��֯ 
 * ��ѡʱ��ѡ��
 * ��ѡʱ����ӵ��ұ���ѡ��
 *  @param favoriteId liԪ�ص�id ��li_ favoriteId
 * */
function dbClickFavorite(favoriteId){
	var $selectEle = $("#"+favoriteId);
	if(chooseMode==1){//��ѡ
		var nowSelectedKey = $selectEle.attr("objectid");
		submitSelected([nowSelectedKey]);
	}else{//��ѡ
		var obj = _buildSelectedData($selectEle);
		if(!obj){
			return;
		}
		// �Ѹò��ŷŵ���ѡ����
		putToSelectedBox(obj); 	
	}
}

/**
 * ��װѡ������� 
 * @param ele ��ǰ��Ԫ�ض���
 * */
function _buildSelectedData(ele){
	var unselectable=ele.attr("unselectable")==="true"?true:false;
	if(unselectable){
		return null;
	}
	var obj = {};
	obj.id = ele.attr("objectid");//id;
	obj.fullName = ele.attr("fullname");
	obj.name = ele.attr("name");
	return obj;
}

/**
 * ��ӳ��ò��ŷ�����ȡ����ť�¼�
 */
function calcelGroup(){
	var $addFavoriteGroup_li = $("#addFavoriteGroup_li");
	cui("#groupName").setValue("");
	$("#addFavoriteDiv").show();
	$addFavoriteGroup_li.find(".editFavoriteGroupName").hide();
}

/**��ȡ�����б�
 * */
function getFavoriteGroupList(obj,callback){
	var favoriteClassify;
	if(chooseType=='org'){
		favoriteClassify=2;
	}else{
		favoriteClassify=1;
	}
	FavoriteAction.getFavoriteGroupList(favoriteClassify,function(data){
		if(!data){data=[];}
		obj.setDatasource(data);
		callback();
	});
}
/**���볣����֯
 * */
function joinFavorite(){
	getFavoriteGroupList(cui('#favoriteGroupSelect'),function(){
	cui("#favoriteSelectWin").dialog({
		title:"\u9009\u62e9\u5206\u7ec4", //ѡ�����
		modal:true,
		width:200,
		height:40,
		buttons:[{name:'\u786e\u5b9a',handler:function(){
			var deptOrUserId="" ,groupId = cui("#favoriteGroupSelect").getValue();
			if(chooseMode==1){
				var selectNode = cui('#tree').getActiveNode();
				if(!selectNode||(chooseType==="user"&&selectNode.getData().isFolder)){
					this.hide();
					return;
				}
				deptOrUserId = selectNode.getData().key;
			}else{
				var selectedNodes = cui('#tree').getSelectedNodes(false);
				if(selectedNodes&&selectedNodes.length){
					for(var i=0;i<selectedNodes.length;i++){
						deptOrUserId += selectedNodes[i].getData().key+";";
						selectedNodes[i].select(false);
					}
				}
			}
			if(deptOrUserId){
				var vGroupName = cui("#favoriteGroupSelect").getText();
				if(groupId==vGroupName){ //���鲻����
					if(vGroupName&&$.trim(vGroupName)){
						//ֻ��ȡ20��
						 var currentLen = comtop.String.getBytesLength(vGroupName);
						 if (currentLen >20) {
		                	vGroupName = comtop.String.intercept(vGroupName,20);
						 }
						var obj={"favoriteGroupName":vGroupName,"favoriteClassify":chooseType=="org"?2:1};
						FavoriteAction.saveFavoriteGroup(obj,function(data){
							addNewGroupToLast(data);
							saveFavoriteToDB(deptOrUserId, data.favoriteGroupId);
						});
					}
				}else{
					saveFavoriteToDB(deptOrUserId, groupId);
				}
			}
			this.hide();
		}},{name:"\u53d6\u6d88",handler:function(){
			this.hide();
		}}]
	}).show();
	});
}

/**
 * ��ӳ��ò��ŷ���
 */
function addFavoriteGroup(){
	//��ӳ��÷���ǰ���������ǰ���ڸ��µķ���
	if(updateLinkId!=""){
		cancelUpdateGroup(updateLinkId);
	}
	var $addFavoriteGroup_li = $("#addFavoriteGroup_li");
	$("#addFavoriteDiv").hide();
	$addFavoriteGroup_li.find(".editFavoriteGroupName").css("display","inline");
	cui("#groupName").focus();
}

/**
 * ���ò�����ӷ�����ȷ���¼�,���泣�ò��ŷ���
 */
function saveGroup(){
	var CUI_groupName = cui("#groupName");
	var map = window.validater.validOneElement(CUI_groupName);
	if(!map.valid){
		return;
	}
	var groupName = $.trim(CUI_groupName.getValue());
	CUI_groupName.focus();
	if(groupName ==""){
		//�������Ʊ���
		showErrorMessage("\u5206\u7EC4\u540D\u79F0\u5FC5\u586B");
		return;
	}
	var vGroupName = groupName;
	//��ӷ���
	var obj={"favoriteGroupName":vGroupName,"favoriteClassify":chooseType=="org"?2:1};
	FavoriteAction.saveFavoriteGroup(obj,function(data){
		//������ӳɹ�
   		showSuccessMessage("\u5206\u7EC4\u6DFB\u52A0\u6210\u529F\u3002");
   		calcelGroup();
   		addNewGroupToLast(data);
	});
}

/**
 * ���������һ������
 */
function addNewGroupToLast(data) {
    data.children = [];
    //data.favoriteGroupName = data.name;
    var lstData = [data];
    var jctInstance = new jCT(jctTemplate);
    jctInstance.Build();
    var html = jctInstance.GetView(lstData);
    $("#addFavoriteGroup_li").before(html);
    $("#addFavoriteGroup_li").remove();
    bindEvent($("li[name='groupLi'][favoriteGourpId='" + data.favoriteGroupId + "']"));
}

/**
 * ˢ�³��ò��ŵ�����
 */
function initFavoriteDept(){
	$('#div_tree_favorite').show();
	var orgStructureId = cui('#orgStructure_favorite').getValue();
	if(orgStructureId){
		var favoriteClassify= 0;
		if(chooseType=='org'){
			favoriteClassify=2;
			userType = 0;
		}else{
			favoriteClassify=1;
			levelFilter=999;
		}
		var obj = {"rootDepartmentId":getRootId(favoriteRootId,orgStructureId),"favoriteClassify":favoriteClassify,"userType":userType,"orgStructureId":orgStructureId,"unselectableCode":unselectableCode,"levelFilter":levelFilter};
		FavoriteAction.getCommonFavoriteList(obj,function(data){
			if(jctTemplate==null){
	   			jctTemplate =$("#template").html();
	   		}
		   	var	jctInstance = new jCT(jctTemplate);
		    jctInstance.Build();
		    var html = jctInstance.GetView(data);
		    $(".favoriteTree").html(html);
		    bindEvent();
		    comtop.UI.scan($("#addFavoriteGroup_li"));
		    isOnloadFavoriteData = true;
		});
	}
}

function showMoreDataOfFavorite(){
	var moreData = $("#moreDataOfFavorite");
	if(moreData.hasClass("more_data")){
		pageNo++;
		moreData.removeClass("more_data");
		moreData.addClass("more_data_disable");
		_queryDataOfFavorite("add");
	}
}
/**
 * ���ò��������������ѯ
 */
function queryDataOfFavorite(event){
	// �жϼ����¼����������¼����س���
	if(typeof event == "undefined" || isValidKeyCodeForQueryData(event.keyCode)){
		clearTimeout(tempFavoriteFunc);
		clearTimeout(tempNoDataFavoriteFunc);
		pageNo=1;
		tempFavoriteFunc = setTimeout(function(){_queryDataOfFavorite("replace")},300);
	}
}

function _queryDataOfFavorite(type){
	// ��ȡ��ѯ���ֶ�
	var queryStr = handleStr($.trim(cui('#keyword_favorite').getValue()));
	// ����ֶ�Ϊ�գ����û���ղ�ѯ�ֶκ�����div
	if(queryStr == ""){
//		$("#searchDivOfFavorite").slideUp("fast");
		closeFastDataDiv("searchDivOfFavorite");
		return;
	}else{
//		cui('#addGroup').disable(true);
		var orgStructureId = cui('#orgStructure_favorite').getValue();
		// ���ٲ�ѯ���ò�������
		if(orgStructureId){
			var prefixOfQuery = prefixOfDeptQueryFavorite;
			var favoriteClassify;
			if(chooseType=="org"){
				userType=0;
				favoriteClassify = 2;
			}else{
				prefixOfQuery = prefixOfUserQuery;
				favoriteClassify=1;
			}
			var objVO = {"rootDepartmentId":getRootId(rootId,orgStructureId),"orgStructureId":orgStructureId,"pageSize":pageSize,"pageNo":pageNo,"keyword":queryStr,
					"unselectableCode":unselectableCode,"levelFilter":levelFilter,"userType":userType,"favoriteClassify":favoriteClassify};
			FavoriteAction.fastQueryFavorite(objVO,function(data){
				var objDiv ={};
				objDiv.searchDiv = "searchDivOfFavorite";
				objDiv.queryDataAreaDiv = "queryDataAreaOfFavorite";
				objDiv.moreDataDiv = "moreDataOfFavorite";
				if(data.count==0){
					cacheData = null;
			   		$("#moreDataOfFavorite").css('display','none');
			   		$('#queryDataAreaOfFavorite').height(0);
			   		if(chooseType=="org"){
			   			//������֯���޸���֯
			   			$('#queryDataAreaOfFavorite').html('<span class="no_data" >&nbsp;\u5e38\u7528\u7ec4\u7ec7\u4e2d\u65e0\u8be5\u7ec4\u7ec7</span>');
			   		}else{
			   			//������ϵ�����޸���Ա
			   			$('#queryDataAreaOfFavorite').html('<span class="no_data" >&nbsp;\u5e38\u7528\u8054\u7cfb\u4eba\u4e2d\u65e0\u8be5\u4eba\u5458</span>');
			   		}
	  				showOrDisplay(objDiv,"no_data");
			   		clearTimeout(tempNoDataFavoriteFunc);
			   		tempNoDataFavoriteFunc = setTimeout(function(){
//			   			$("#searchDivOfFavorite").slideUp("fast");
			   			closeFastDataDiv("searchDivOfFavorite");
			   		},2000);
			   		}else{
			   			var $box= $("#"+ getQueryDataAreaId(true)),
			   	    	children = $box.children(),
			   	    	len =children.length ;
			   			if(type==="replace"){
			   				currentIndex = -1;
			   				cacheData = data.list;
			   			}else{
			   				$.each(data.list,function(){
			   					cacheData.push(this);
			   				});
			   			}
			   			//Ȼ������ƴװ��DIV��
						installData(objDiv,data,type);
			   		    showOrDisplay(objDiv,prefixOfQuery);
//			   		$("#keywordOfFavorite").find("input").focus();
			   		    var moreData = $("#"+objDiv.moreDataDiv);
			   		    moreData.removeClass("more_data_disable");
			   		    moreData.addClass("more_data");
			   		    if(type==="add"){
			   		    	scrollHoverPositionToBottom(true,len-1);
			   		    	cui("#keyword_favorite").focus();
				   		}
			   		}
			});
		}
	}
}

/**
 * �ֲ�ˢ��һ�����ò���
 */
function renderOneFavoriteGroup(deptGroupId) {
    var $CurrentGroup = $("li[name='groupLi'][favoriteGourpId='" + deptGroupId + "']").eq(0);
	var orgStructureId = cui('#orgStructure_favorite').getValue();
	var favoriteClassify;
	if(chooseType=="org"){
		userType=0;
		favoriteClassify = 2;
	}else{
		favoriteClassify=1;
		unselectableCode="";
		levelFilter="";
	}
	var obj= {"rootDepartmentId":getRootId(favoriteRootId,orgStructureId),"userType":userType,"favoriteClassify":favoriteClassify,"orgStructureId":orgStructureId,"favoriteGroupId":deptGroupId,"unselectableCode":unselectableCode,"levelFilter":levelFilter};
	FavoriteAction.getOneFavoriteDepartmentList(obj,function(data){
		var jctInstance = new jCT(jctTemplate);
        jctInstance.Build();
        var html = jctInstance.GetView(data);
        $CurrentGroup.replaceWith(html);
        $CurrentGroup = $("li[name='groupLi'][favoriteGourpId='" + deptGroupId + "']").eq(0);
        $("#addFavoriteGroup_li").remove();
        bindEvent($CurrentGroup); //�����Ҫչʾ�Ľڵ��ڹ�����֮��
	});
}

//ѡ���÷���Ĳ���
var globalGroupId="";
/**
 * ���ò��ŷ����ϵ����¼� չ����رշ���
 */
function groupOnclick(obj) {
	if(obj.target.innerHTML.indexOf("\u5220\u9664") >-1){
		return;
	}
	var $SpanFavoriteGroup = $(obj.data.obj).parent();
	clearGroupBackGround();
	clearFavoriteTreeSelected();
	globalGroupId = $SpanFavoriteGroup.attr("id").replace("div_","")
    addGroupBackGroup();
    var ul = $SpanFavoriteGroup.next();

    if ("none" == ul.css("display")) { // �л��رշ���ͼƬ
        $(obj.data.obj).removeClass("showFavoriteGroupNameClose");
        ul.show();
    } else { // �л��򿪷���ͼƬ
        $(obj.data.obj).addClass("showFavoriteGroupNameClose");
        clearFavoriteTreeSelected();
        ul.hide();
    }
    return false;
}
/**
 * ������÷����ϵı���ɫ
 */
function clearGroupBackGround(){
	if(globalGroupId!==""){
		var $CurrentGroup = getGroupLi(globalGroupId);
		$CurrentGroup.find("span[id^='span_favoriteGroupName_']").eq(0).removeClass("selectedDiv");
	}
}

function addGroupBackGroup(){
	if(globalGroupId!==""){
		var $CurrentGroup = getGroupLi(globalGroupId);
		$CurrentGroup.find("span[id^='span_favoriteGroupName_']").eq(0).addClass("selectedDiv");
	}
}

/**
 * ��ȡgroup��li
 */
function getGroupLi(groupId){
	 return $("li[name='groupLi'][favoriteGourpId='" + groupId + "']").eq(0);
}

/**
 * ��ȡ��Աѡ���ǩ��������ϵ��/��֯ѡ�񵯳����ڵĳߴ�
 * �������ھ�����ʾ
 * @param chooseMode ѡ��ģʽ 1��ѡ ���� ��ѡ
 * @returns {width,height,offsetLeft,offsetTop}
 * */
function getWindowSize(){
	var winWidth=535;//���������
	var winHeight = 495;//�������߶�
	var offsetLeft,offsetTop;//������λ��
	//��ѡ���ֵ����󣬿������
	var isQM = window.top.comtop.Browser.isQM;
	var isIE = comtop.Browser.isIE;
	if(isIE&&isQM){
		winWidth += 18;
	}
	
	offsetLeft = (window.screen.width-20-winWidth)/2;
	offsetTop = (window.screen.height-30-winHeight)/2;
	return {"width":winWidth,"height":winHeight,"offsetLeft":offsetLeft,"offsetTop":offsetTop};
}

/**
 * ��ӳ��ò���
 */
function addFavoriteDept(groupId){
	gGroupId = groupId;
	var orgStructureId = cui('#orgStructure_favorite').getValue();
	var orgStructureName = cui('#orgStructure_favorite').getText();
	orgStructureName = encodeURIComponent(encodeURIComponent(orgStructureName));
	var idSuffix = "";
	if(cmpID!=''){
		idSuffix = cmpID;
	}else{
		idSuffix=getDialogId();
	}
	var winSize = getWindowSize();
	var url = webPath +'/top/sys/usermanagement/orgusertag/addFavorite.jsp?groupId='+gGroupId+"&&orgStructureId="+orgStructureId+"&&rootId="+favoriteRootId+"&&orgStructureName="+orgStructureName+"&unselectableCode="+unselectableCode+"&levelFilter="+levelFilter +"&chooseType="+chooseType+"&idSuffix="+idSuffix +"&winType="+winType;
	if(winType==="window"){
		window.open(url,"ChooseFavoritePage","left="+winSize.offsetLeft+",top="+winSize.offsetTop+",width="+winSize.width+",height="+winSize.height+",menu=no,toolbar=no,resizable=no,scrollbars=no");
	}else{
		var dialog ;
		if(window.top.cuiEMDialog&&window.top.cuiEMDialog.dialogs){
			dialog = window.top.cuiEMDialog.dialogs["addFavoriteOrgDialog"+idSuffix];
		}
		if(!dialog){
			dialog = cui.extend.emDialog({
				id:'addFavoriteOrgDialog'+idSuffix,
				//ѡ������֯
				title:"\u9009\u62e9\u5e38\u7528\u7ec4\u7ec7",
				src:url,
				width:winSize.width,
				height:winSize.height
			});
		}else{
			dialog.reload(url);
		}
		dialog.show();
	}
}

function getDialogId(){
	var dialogId = "topdialogwithjsopen";
	if(jsID){
		dialogId+=jsID;
	}
	return dialogId;
}

/**
 * ��ӳ�����ϵ��
 */
function addFavoriteUser(groupId,vRootId){
	gGroupId = groupId;
	var orgStructureId = cui('#orgStructure_favorite').getValue();
	var orgStructureName = cui('#orgStructure_favorite').getText();
	orgStructureName = encodeURIComponent(encodeURIComponent(orgStructureName));
	var idSuffix = "";
	if(cmpID!=''){
		idSuffix = cmpID;
	}else{
		idSuffix=getDialogId();
	}
	var winSize = getWindowSize();
	var url =webPath +'/top/sys/usermanagement/orgusertag/addFavorite.jsp?groupId='+gGroupId+"&&orgStructureId="+orgStructureId+"&&rootId="+favoriteRootId+"&&orgStructureName="+orgStructureName+"&&userType="+userType+"&chooseType="+chooseType +"&idSuffix="+idSuffix+"&winType="+winType;
	if(winType==="window"){
		window.open(url,"ChooseFavoritePage","left="+winSize.offsetLeft+",top="+winSize.offsetTop+",width="+winSize.width+",height="+winSize.height+",menu=no,toolbar=no,resizable=no,scrollbars=no");
	}else{
		var dialog ;
		if(window.top.cuiEMDialog&&window.top.cuiEMDialog.dialogs){
			dialog = window.top.cuiEMDialog.dialogs["addFavoriteUserDialog"+idSuffix];
		}
		if(!dialog){
			dialog = cui.extend.emDialog({
				id:'addFavoriteUserDialog'+idSuffix,
				//ѡ������ϵ��
				title:"\u9009\u62e9\u5e38\u7528\u8054\u7cfb\u4eba",
				src:url,
				width:winSize.width,
				height:winSize.height
			});
		}else{
			dialog.reload(url);
		}
		dialog.show();
	}
}

/**
 * ���泣�ò��ŵ����ݿ�
 */
function saveFavoriteToDB(deptOrUserId, groupId) {
	var favoriteClassify;
	var msg = "";
	if(chooseType=="org"){
		favoriteClassify = 2;
		//������֯
		msg = "\u5e38\u7528\u7ec4\u7ec7";
	}else{
		favoriteClassify=1;
		//������ϵ��
		msg = "\u5e38\u7528\u8054\u7cfb\u4eba";
	}
	var obj= {"objectId":deptOrUserId,"favoriteGroupId":groupId,"favoriteClassify":favoriteClassify};
	FavoriteAction.saveFavorite(obj,function(){
		renderOneFavoriteGroup(groupId);
		//����ɹ�
        showSuccessMessage(msg+"\u4FDD\u5B58\u6210\u529F\u3002");
	});
}

/**
 * ���ò��ż�������Ƿ��ظ�
 */
function checkGroupName(groupName){ 
	var passFlag = true;
	if(groupName==""){
		//�������Ʊ���
		showErrorMessage("\u5206\u7EC4\u540D\u79F0\u5FC5\u586B");
		return false;
	}
	//�������޸�ʱ���ж�
	$(".favorite_floder").each(function(){ 
		if(updateLinkId == ""){
			if($.trim(groupName)==$(this).attr("groupName")) {
				passFlag = false;
				return;
			}
		}else{
			if($.trim(groupName)==$(this).attr("groupName") && $(this).attr("id") != updateLinkId) {
				passFlag = false;
				return;
			}
		}
	});
	return passFlag;
}

/**
 * ���ò��ű༭�������ƺ�ȡ����ť���¼�
 */
function cancelUpdateGroup(linkId) {
    updateLinkId = "";
    var objA = $("#" + linkId);
    objA.children(".showFavoriteGroupName").show();
    var editText = objA.children(".editFavoriteGroupName");
    editText.empty();
}

var tmpObj;
/**
 * ���ò��Ź��over�¼�
 */
function groupOnMouseOver(obj){
	tmpObj = $(obj.data.obj);
	var div = tmpObj.find("div");
	if(chooseType=="org"){
		//������֯
		if("\u5E38\u7528\u7EC4\u7EC7" !=tmpObj.parent().attr("groupName")){
			div.css("display","inline");
		}
	}else{
		//������ϵ��
		if("\u5E38\u7528\u8054\u7CFB\u4EBA" !=tmpObj.parent().attr("groupName")){
			div.css("display","inline");
		}
	}
}

/**
 * ���ò��Ź��out�¼�
 */
function groupOnMouseOut(obj){
	$(obj.data.obj).find("div").hide();
}

/**
 * ɾ�����ò��ŷ���
 */
function deleteFavoriteGroup(favoriteGroupId) {
    var $CurrentGroup = getGroupLi(favoriteGroupId);
    var $GroupInof = $CurrentGroup.children(".favorite_floder");
    if ($GroupInof.attr("count") == 0) {
        __deleteFavoriteGroup($CurrentGroup, favoriteGroupId);
        return;
    }
    //��������[������֯]��ȷ��ɾ����
    var msg = chooseType=="org"?'\u5206\u7EC4\u4E2D\u6709\u005B\u5E38\u7528\u7EC4\u7EC7\u005D\uFF0C\u786E\u5B9A\u5220\u9664\u5417\uFF1F':
    '\u5206\u7EC4\u4E2D\u6709\u005B\u5E38\u7528\u4EBA\u5458\u005D\uFF0C\u786E\u5B9A\u5220\u9664\u5417\uFF1F';
    cui.confirm(msg, {
        onYes: function() {
        	__deleteFavoriteGroup($CurrentGroup, favoriteGroupId);
        },
        width: 200,
        //ɾ��
        title: "\u5220\u9664<b>["+$GroupInof.attr("groupName")+"]</b>"
    });
}

function __deleteFavoriteGroup(currentGroup, deptGroupId) {
	FavoriteAction.deleteFavoriteGroup(deptGroupId,function(){
		currentGroup.remove();
		//����ɾ���ɹ�
        showSuccessMessage("\u5206\u7EC4\u5220\u9664\u6210\u529F\u3002");
	});
}
/**
 * ���³��ò��ŷ�������
 */
function updateGroupName(oldGroupName,groupId){
	var newGroupName=$.trim(cui("#updateGroupName").getValue());
	if(oldGroupName==newGroupName){
		cancelUpdateGroup("div_"+groupId);
		return;
	}
	var map = window.validater.validOneElement(cui("#updateGroupName"));
	if(!map.valid){
		return;
	}
	var vGroupName = newGroupName;
	var obj={"favoriteGroupId":groupId,"favoriteGroupName":vGroupName};
	FavoriteAction.updateFavoriteGroup(obj,function(){
		$("#span_favoriteGroupName_"+groupId).html("&nbsp;"+newGroupName+"&nbsp;");
   		$("#div_"+groupId).attr("groupName",newGroupName);
   		cancelUpdateGroup("div_"+groupId);
   		//�����޸ĳɹ�
   		showSuccessMessage("\u5206\u7EC4\u4FEE\u6539\u6210\u529F\u3002");
	});
}


var priorSelected= null;
/**
 * ��ӳ��ò������еİ󶨵���¼�
 */
function bindEvent(targetObj){
	var $DeptGroup = $(".deptName");
	var $DeptGroupName = $("span.showFavoriteGroupName");
	if(typeof targetObj !== "undefined"){
		$DeptGroup = targetObj.find(".deptName");
		$DeptGroupName = targetObj.find("span.showFavoriteGroupName");
	}
	// click�¼�
	$DeptGroup.on("click",function(event){
		var shiftFlag = event.shiftKey;
		// ��ȡѡ�е�dom����
		var tmpObject = $(event.target).closest("li[id^=li_]");
		if(tmpObject.length==0){
			return false;
		}
		objDept = tmpObject;
		if(tmpObject&&tmpObject.attr("unselectable")!=="true"){
			var thisID = tmpObject.attr("id");
			// �������ѡ���ţ�����ȡ����ѡ��ʽ
			if(objDept.className != "addFavoriteDept"){
				if(tmpObject.hasClass("favoriteDeptOrUserChoose")){ //����Ѿ�ѡ�У������ó�δѡ��״̬
					priorSelected = null;
					clearFavoriteSelected(thisID);
				}else if(thisID&&chooseMode==1){//��ѡ
					clearFavoriteTreeSelected();
					selectFavorite(tmpObject);
				}else if(thisID&&chooseMode!=1&&shiftFlag){//��ѡ
					if(priorSelected==null){
						priorSelected = thisID;
					}else{
						var allFavorites = _getAllFavoriteEle();
	                    var currenIndex = _getRowIndexById(allFavorites,thisID);
	                    var preIndex = _getRowIndexById(allFavorites,priorSelected);
	                    clearFavoriteTreeSelected();
	                    for(var i = Math.min(currenIndex, preIndex),j = Math.max(currenIndex, preIndex); i <= j; i++) {
	                        selectFavorite(allFavorites.eq(i));
	                    }
	                
					}
					selectFavorite(tmpObject);
				}else{
					priorSelected = thisID;
					selectFavorite(tmpObject);
				}
			}
			if("addFavorite_li"!==thisID){
				clearGroupBackGround();
				globalGroupId="";
			}else{
				thisID="";
			}
		}
		return false;
	});
	$DeptGroup.delegate(".group_delete","click",function(event){
		var target = this;
		var favoriteGroupId = $(target).attr("favoriteGourpId");
		var $DataLi = $(target).parent();
		var favoriteId = $DataLi.attr("favoriteId");
		var $CountHtml = $("#span_favoriteGroup_"+favoriteGroupId);
		var html = $CountHtml.html();
		clearFavoriteSelected($DataLi.attr("id"));
		$DataLi.parent().prev().attr("count",html-1);
		$CountHtml.html(html-1);
		deleteFavoriteById(favoriteId);
		$DataLi.remove();
	});
	$AllLi = $DeptGroup.find("li[id^='li_']");
	for(var i=0;i<$AllLi.length;i++){
		$AllLi.eq(i).on('mouseover',function(){
		$(this).addClass("slideDIV");
		$(this).find("span").addClass("display_block");
		}).on('mouseout',function(event){
			$(this).removeClass("slideDIV");
			$(this).find("span").removeClass("display_block");
		});
	}
	$DeptGroupName.each(function(){
		$(this).bind("mouseover",{obj:this},groupOnMouseOver);
		$(this).bind("mouseout",{obj:this},groupOnMouseOut);
		$(this).bind("mousedown",{obj:this},groupOnclick);
	});
}

/**
 * ��ѯ���еĳ�����֯����ϵ��LIԪ��
 * */
function _getAllFavoriteEle(){
	//������еĳ�����֯����ϵ��
	var allFavorite = $(".favoriteTree").find("li[id^=li_]");
	return allFavorite;
}
/**
 * ����id��ȡ�к�
 * @param allFavorite ���еĳ�����֯����ϵ��LIԪ��
 * @param rowId ѡ�е���Ԫ��id
 */
function _getRowIndexById(allFavorite,rowId){
    var index = allFavorite.index($('li[id=' + rowId + ']'));
    return index;
}

/**
 * ��ȡ�������ѡ�еĳ�����ϵ��/��֯
 * */
function getAllSelectedFavorite(){
	return $(".favoriteTree").find(".favoriteDeptOrUserChoose");
}

/**ѡ�г�����֯����ϵ���еĶ���
 * @param selectEle ��ǰѡ�е�Ԫ��
 * */
function selectFavorite(selectEle){
	selectEle.addClass("favoriteDeptOrUserChoose");
	selectEle.removeClass("slideDIV");
//	selectEle.find("span").addClass("display_block");
}

/**
 * ɾ�����ò���
 */
function deleteFavoriteById(favoriteId){
	var msg = "";
	if(chooseType=="org"){
		//������֯
		msg = "\u5e38\u7528\u7ec4\u7ec7";
	}else{
		//������ϵ��
		msg = "\u5e38\u7528\u8054\u7cfb\u4eba";
	}

	FavoriteAction.deleteFavorite(favoriteId,function(){
		//ɾ���ɹ�
   		showSuccessMessage(msg+"\u5220\u9664\u6210\u529F\u3002");
	});
}

/**
 * ������ò���li��span����ѡ��¼��
 * @param ele ��ӹ�ȥ��Ԫ�ض���
 */
function clearSelectedFavorite(ele) {
	if (ele&&ele.length) {
		ele.removeClass("favoriteDeptOrUserChoose");
		ele.removeClass("slideDIV");
		ele.find("span").removeClass("display_block");
	}
}

/**
 * ������ò���li��span����ѡ��¼��
 */
function clearFavoriteSelected(selectedId) {
	if(selectedId){
		var $SelectedLi = $("#" + selectedId);
		clearSelectedFavorite($SelectedLi);
	}
}

/**
 * ������ò���li��span����ѡ��¼��
 */
function clearFavoriteTreeSelected() {
	var selectdEle = getAllSelectedFavorite();
	if(selectdEle&&selectdEle.length){
		var len = selectdEle.length;
		for(var i=0;i<len;i++){
			clearSelectedFavorite(selectdEle.eq(i));
		}
	}
}
/**
 * ���ò��ŷ������޸��¼�
 */
function updateFavoriteGroup(linkId){
	calcelGroup();
	if(updateLinkId !=""){
		cancelUpdateGroup(updateLinkId);
	}
	updateLinkId = linkId;
	var obj = $("#"+linkId);
	//�Ƚ������������ʾ������ð�ݵ���Ԫ��click�¼�ʱ��رշ�������
	obj.next().show();
	obj.children(".showFavoriteGroupName").hide();
	var editText = obj.children(".editFavoriteGroupName");
	editText.show();
	var groupName = obj.attr("groupName");
	var groupId = obj.attr("id").replace("div_","");
	var vHtml='<img src="images/add.gif"/>&nbsp;<span uitype="Input" maxlength="20" validate="[{\'type\':\'required\', \'rule\':{\'m\': \'\u5206\u7EC4\u540D\u79F0\u5FC5\u586B\'}},{ \'type\':\'custom\',\'rule\':{\'against\':\'checkGroupName\', \'m\':\'\u540D\u79F0\u4E0D\u80FD\u91CD\u590D\'}}]" id="updateGroupName" value="'+groupName;
	vHtml += '" name="input" width="100px" /><a class="submit" hidefocus="true" onclick="updateGroupName(\''+groupName+'\',\''+groupId+'\');return false;" href="#">&nbsp;&nbsp;\u786E\u5B9A</a>&nbsp;|&nbsp;<a class="cancel" hidefocus="true" onclick="cancelUpdateGroup(\''+linkId+'\');return false;" href="#">\u53D6\u6D88</a>';
	editText.html(vHtml);
	comtop.UI.scan(obj);
	cui("#updateGroupName").focus();
}

function showSuccessMessage(message){
   cui.message(message, 'success');
}

function showErrorMessage(message){
   cui.message(message, 'error', {autoClose:4000});
}
