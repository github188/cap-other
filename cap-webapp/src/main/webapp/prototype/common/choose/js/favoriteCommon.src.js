/**
 * 用途：该js为常用部门js
 *
 * 常量：
 * 		webPath：项目的根path
 * 		objDept：常用部门绑定事件变量，当选中某个常用部门时，则为选中的dom对象 
 * 		updateLinkId：当前修改的分组id
 * 		jctTemplate：保存常用部门的模板字串
 * 		gGroupId：常用部门组id 
 * 		prefixOfDeptQueryFavorite：检索框<a>标签的class，常用部门
 * 		pageNo: 第几次点击更多数据
 * 		currentIndex：检索下拉框中,选中a的位置
 */
// 常用部门绑定事件变量，当选中某个常用部门时，则为选中的dom对象
var objDept={}; 
// 当前修改的分组id
var updateLinkId;
// 保存常用部门的模板字串
var jctTemplate=null;
// 常用部门组id
var gGroupId;   
// 是否已加载常用联系人数据
var isOnloadFavoriteData = false;  

var tempFavoriteFunc,tempNoDataFavoriteFunc;
/**
 * 方法：
 * 		addFavoriteGroup() 添加常用部门分组  转移到deptMultSelectPage.jsp
 * 		calcelGroup() 添加常用部门分组中取消按钮事件
 * 		saveGroup() 常用部门添加分组点击确定事件,保存常用部门分组
 * 		groupOnclick(obj) 常用部门分组上单击事件 展开或关闭分组
 * 		addFavoriteDept(groupId) 添加常用部门
 * 		checkGroupName(groupName) 检查组名是否重复
 * 		cancelUpdateGroup(linkId) 常用部门分组点击修改名称后，取消按钮事件
 * 		groupOnMouseOver(obj) 常用部门光标over事件
 * 		groupOnMouseOut(obj) 常用部门光标out事件
 * 		updateGroupName(oldGroupName,groupId) 更新常用部门分组名称
 * 		queryDataOfFavorite() 常用部门搜索框输入查询
 * 		bindEvent() 添加常用部门树中的绑定点击事件
 * 		deleteFavoriteById(favoriteId) 删除常用部门
 */

var isReloadData = true;

/**
 * 将左边选择的常用联系人/组织 添加到右边已选框
 * @param selected 要添加的li元素对象
 * @param 是否清除选中
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
 * 双击左边的常用联系人/组织 
 * 单选时：选中
 * 多选时：添加到右边已选框
 *  @param favoriteId li元素的id 即li_ favoriteId
 * */
function dbClickFavorite(favoriteId){
	var $selectEle = $("#"+favoriteId);
	if(chooseMode==1){//单选
		var nowSelectedKey = $selectEle.attr("objectid");
		submitSelected([nowSelectedKey]);
	}else{//多选
		var obj = _buildSelectedData($selectEle);
		if(!obj){
			return;
		}
		// 把该部门放到已选框中
		putToSelectedBox(obj); 	
	}
}

/**
 * 组装选择的数据 
 * @param ele 当前的元素对象
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
 * 添加常用部门分组中取消按钮事件
 */
function calcelGroup(){
	var $addFavoriteGroup_li = $("#addFavoriteGroup_li");
	cui("#groupName").setValue("");
	$("#addFavoriteDiv").show();
	$addFavoriteGroup_li.find(".editFavoriteGroupName").hide();
}

/**
 * 添加常用部门分组
 */
function addFavoriteGroup(){
	//添加常用分组前，先清除当前正在更新的分组
	if(updateLinkId!=""){
		cancelUpdateGroup(updateLinkId);
	}
	var $addFavoriteGroup_li = $("#addFavoriteGroup_li");
	$("#addFavoriteDiv").hide();
	$addFavoriteGroup_li.find(".editFavoriteGroupName").css("display","inline");
	cui("#groupName").focus();
}

/**
 * 常用部门添加分组点击确定事件,保存常用部门分组
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
		//分组名称必填
		showErrorMessage("\u5206\u7EC4\u540D\u79F0\u5FC5\u586B");
		return;
	}
	var vGroupName = groupName;
	//添加分组
	var obj={"favoriteGroupName":vGroupName,"favoriteClassify":chooseType=="org"?2:1};
	
	//分组添加成功
	showSuccessMessage("\u5206\u7EC4\u6DFB\u52A0\u6210\u529F\u3002");
	calcelGroup();
	addNewGroupToLast(obj);
}

/**
 * 在最后新增一个分组
 */
function addNewGroupToLast(data) {
    data.children = [];
    //data.favoriteGroupName = data.name;
    var lstData = [data];
    var jctInstance = new comtop.JCT(jctTemplate);
    jctInstance.Build();
    var html = jctInstance.GetView(lstData);
    $("#addFavoriteGroup_li").before(html);
    $("#addFavoriteGroup_li").remove();
    bindEvent($("li[name='groupLi'][favoriteGourpId='" + data.favoriteGroupId + "']"));
}

/**
 * 刷新常用部门的数据
 */
function initFavoriteDept(){
	
	var structureId = cui('#orgStructure_favorite').getValue(),
	     data = [];
		 
	$.each(dataSource, function(i, n){ 
	   if(n.orgStructureId === structureId){
		  data = n.favorite;
	   }
	});
	
	if(data.length){

		if(jctTemplate==null){
			jctTemplate = getTemplate(chooseType);
		}
		var	jctInstance = new comtop.JCT(jctTemplate);
		jctInstance.Build();
		var html = jctInstance.GetView(data);
		$(".favoriteTree").html(html);
		bindEvent();
		comtop.UI.scan($("#addFavoriteGroup_li"));
		isOnloadFavoriteData = true;
	}
	$('#div_tree_favorite').show();
}
/**
 * 根据类型获取对应模板
 */
function getTemplate(type){ 
   if(type == 'org'){
      return $('#orgTemplate').html();
   }else{
      return $('#userTemplate').html();
   
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
 * 常用部门搜索框输入查询
 */
function queryDataOfFavorite(event){
	// 判断键盘事件，抛弃上下键跟回车键
	if(typeof event == "undefined" || isValidKeyCodeForQueryData(event.keyCode)){
		clearTimeout(tempFavoriteFunc);
		clearTimeout(tempNoDataFavoriteFunc);
		pageNo=1;
		tempFavoriteFunc = setTimeout(function(){_queryDataOfFavorite("replace")},300);
	}
}

function _queryDataOfFavorite(type){
	// 获取查询的字段
	var queryStr = handleStr($.trim(cui('#keyword_favorite').getValue()));
	// 如果字段为空，即用户清空查询字段后，收起div
	if(queryStr == ""){
		closeFastDataDiv("searchDivOfFavorite");
		return;
	}else{
		var orgStructureId = cui('#orgStructure_favorite').getValue();
		// 快速查询常用部门数据
		if(orgStructureId){
			var data = [],
				 favorite = function(){
					return $.each(dataSource, function(i, n){
					   if(n.orgStructureId == orgStructureId){
						   return n.favorite; 
					   }
					});
				};
				 
			favorite.length ? $.each(favorite, function(i,n){
				if(n.title.indexOf(queryStr) !== -1){
				   data.push(n);
				}else if(n.children){
					$.each(n.children, function(i,c){
						if(c.title.indexOf(queryStr) !== -1){
						   data.push(c);
						}
					});
				}
			}) : "" ;
			var objDiv ={};
			objDiv.searchDiv = "searchDivOfFavorite";
			objDiv.queryDataAreaDiv = "queryDataAreaOfFavorite";
			objDiv.moreDataDiv = "moreDataOfFavorite";
			if(data.length==0){
				cacheData = null;
				$("#moreDataOfFavorite").css('display','none');
				$('#queryDataAreaOfFavorite').height(0);
				if(chooseType=="org"){
					//常用组织中无该组织
					$('#queryDataAreaOfFavorite').html('<span class="no_data" >&nbsp;\u5e38\u7528\u7ec4\u7ec7\u4e2d\u65e0\u8be5\u7ec4\u7ec7</span>');
				}else{
					//常用联系人中无该人员
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
						cacheData = data;
					}else{
						$.each(data,function(){
							cacheData.push(this);
						});
					}
					//然后将数据拼装到DIV中
					installData(objDiv,data,type);
					showOrDisplay(objDiv,prefixOfQuery);
					var moreData = $("#"+objDiv.moreDataDiv);
					moreData.removeClass("more_data_disable");
					moreData.addClass("more_data");
					if(type==="add"){
						scrollHoverPositionToBottom(true,len-1);
						cui("#keyword_favorite").focus();
					}
				}

		}
	}
}

//选择常用分组的部门
var globalGroupId="";
/**
 * 常用部门分组上单击事件 展开或关闭分组
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

    if ("none" == ul.css("display")) { // 切换关闭分组图片
        $(obj.data.obj).removeClass("showFavoriteGroupNameClose");
        ul.show();
    } else { // 切换打开分组图片
        $(obj.data.obj).addClass("showFavoriteGroupNameClose");
        clearFavoriteTreeSelected();
        ul.hide();
    }
    return false;
}
/**
 * 清除常用分组上的背景色
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
 * 获取group的li
 */
function getGroupLi(groupId){
	 return $("li[name='groupLi'][favoriteGourpId='" + groupId + "']").eq(0);
}

/**
 * 获取人员选择标签及常用联系人/组织选择弹出窗口的尺寸
 * 弹出窗口居中显示
 * @param chooseMode 选择模式 1单选 其它 多选
 * @returns {width,height,offsetLeft,offsetTop}
 * */
function getWindowSize(){
	var winWidth=535;//弹出窗宽度
	var winHeight = 495;//弹出窗高度
	var offsetLeft,offsetTop;//弹出窗位置
	//多选布局调整后，宽度增加
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
 * 添加常用部门
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
				//选择常用组织
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
 * 常用部门检查组名是否重复
 */
function checkGroupName(groupName){ 
	var passFlag = true;
	if(groupName==""){
		//分组名称必填
		showErrorMessage("\u5206\u7EC4\u540D\u79F0\u5FC5\u586B");
		return false;
	}
	//新增及修改时需判断
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
 * 常用部门编辑分组名称后，取消按钮的事件
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
 * 常用部门光标over事件
 */
function groupOnMouseOver(obj){
	tmpObj = $(obj.data.obj);
	var div = tmpObj.find("div");
	if(chooseType=="org"){
		//常用组织
		if("\u5E38\u7528\u7EC4\u7EC7" !=tmpObj.parent().attr("groupName")){
			div.css("display","inline");
		}
	}else{
		//常用联系人
		if("\u5E38\u7528\u8054\u7CFB\u4EBA" !=tmpObj.parent().attr("groupName")){
			div.css("display","inline");
		}
	}
}

/**
 * 常用部门光标out事件
 */
function groupOnMouseOut(obj){
	$(obj.data.obj).find("div").hide();
}

/**
 * 删除常用部门分组
 */
function deleteFavoriteGroup(favoriteGroupId) {
    var $CurrentGroup = getGroupLi(favoriteGroupId);
    var $GroupInof = $CurrentGroup.children(".favorite_floder");
    if ($GroupInof.attr("count") == 0) {
        __deleteFavoriteGroup($CurrentGroup, favoriteGroupId);
        return;
    }
    //分组中有[常用组织]，确定删除吗？
    var msg = chooseType=="org"?'\u5206\u7EC4\u4E2D\u6709\u005B\u5E38\u7528\u7EC4\u7EC7\u005D\uFF0C\u786E\u5B9A\u5220\u9664\u5417\uFF1F':
    '\u5206\u7EC4\u4E2D\u6709\u005B\u5E38\u7528\u4EBA\u5458\u005D\uFF0C\u786E\u5B9A\u5220\u9664\u5417\uFF1F';
    cui.confirm(msg, {
        onYes: function() {
        	__deleteFavoriteGroup($CurrentGroup, favoriteGroupId);
        },
        width: 200,
        //删除
        title: "\u5220\u9664<b>["+$GroupInof.attr("groupName")+"]</b>"
    });
}

function __deleteFavoriteGroup(currentGroup, deptGroupId) {
	currentGroup.remove();
	//分组删除成功
	showSuccessMessage("\u5206\u7EC4\u5220\u9664\u6210\u529F\u3002");
}
/**
 * 更新常用部门分组名称
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
   		//分组修改成功
   		showSuccessMessage("\u5206\u7EC4\u4FEE\u6539\u6210\u529F\u3002");
	});
}


var priorSelected= null;
/**
 * 添加常用部门树中的绑定点击事件
 */
function bindEvent(targetObj){
	var $DeptGroup = $(".deptName");
	var $DeptGroupName = $("span.showFavoriteGroupName");
	if(typeof targetObj !== "undefined"){
		$DeptGroup = targetObj.find(".deptName");
		$DeptGroupName = targetObj.find("span.showFavoriteGroupName");
	}
	// click事件
	$DeptGroup.on("click",function(event){
		var shiftFlag = event.shiftKey;
		// 获取选中的dom对象
		var tmpObject = $(event.target).closest("li[id^=li_]");
		if(tmpObject.length==0){
			return false;
		}
		objDept = tmpObject;
		if(tmpObject&&tmpObject.attr("unselectable")!=="true"){
			var thisID = tmpObject.attr("id");
			// 如果有已选部门，则先取消已选样式
			if(objDept.className != "addFavoriteDept"){
				if(tmpObject.hasClass("favoriteDeptOrUserChoose")){ //如果已经选中，则设置成未选中状态
					priorSelected = null;
					clearFavoriteSelected(thisID);
				}else if(thisID&&chooseMode==1){//单选
					clearFavoriteTreeSelected();
					selectFavorite(tmpObject);
				}else if(thisID&&chooseMode!=1&&shiftFlag){//多选
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
 * 查询所有的常用组织、联系人LI元素
 * */
function _getAllFavoriteEle(){
	//查出所有的常用组织、联系人
	var allFavorite = $(".favoriteTree").find("li[id^=li_]");
	return allFavorite;
}
/**
 * 根据id获取行号
 * @param allFavorite 所有的常用组织、联系人LI元素
 * @param rowId 选中的行元素id
 */
function _getRowIndexById(allFavorite,rowId){
    var index = allFavorite.index($('li[id=' + rowId + ']'));
    return index;
}

/**
 * 获取左边所有选中的常用联系人/组织
 * */
function getAllSelectedFavorite(){
	return $(".favoriteTree").find(".favoriteDeptOrUserChoose");
}

/**选中常用组织、联系人中的对象
 * @param selectEle 当前选中的元素
 * */
function selectFavorite(selectEle){
	selectEle.addClass("favoriteDeptOrUserChoose");
	selectEle.removeClass("slideDIV");
//	selectEle.find("span").addClass("display_block");
}

/**
 * 删除常用部门
 */
function deleteFavoriteById(favoriteId){
	var msg = "";
	if(chooseType=="org"){
		//常用组织
		msg = "\u5e38\u7528\u7ec4\u7ec7";
	}else{
		//常用联系人
		msg = "\u5e38\u7528\u8054\u7cfb\u4eba";
	}

	//删除成功
	showSuccessMessage(msg+"\u5220\u9664\u6210\u529F\u3002");
}

/**
 * 清除常用部门li和span上已选记录。
 * @param ele 添加过去的元素对象
 */
function clearSelectedFavorite(ele) {
	if (ele&&ele.length) {
		ele.removeClass("favoriteDeptOrUserChoose");
		ele.removeClass("slideDIV");
		ele.find("span").removeClass("display_block");
	}
}

/**
 * 清除常用部门li和span上已选记录。
 */
function clearFavoriteSelected(selectedId) {
	if(selectedId){
		var $SelectedLi = $("#" + selectedId);
		clearSelectedFavorite($SelectedLi);
	}
}

/**
 * 清除常用部门li和span上已选记录。
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
 * 常用部门分组点击修改事件
 */
function updateFavoriteGroup(linkId){
	calcelGroup();
	if(updateLinkId !=""){
		cancelUpdateGroup(updateLinkId);
	}
	updateLinkId = linkId;
	var obj = $("#"+linkId);
	//先将分组的内容显示出来，冒泡到父元素click事件时会关闭分组内容
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
