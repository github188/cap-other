var objDept={};var updateLinkId;var jctTemplate=null;var gGroupId;var isOnloadFavoriteData=false;var tempFavoriteFunc,tempNoDataFavoriteFunc;var isReloadData=true;function putSelectedFavoriteToBox(c,a){if(c&&c.length){var d={};var e;for(var b=0;b<c.length;b++){e=c.eq(b);d=_buildSelectedData(e);var f=putToSelectedBox(d);if(f&&!a){clearSelectedFavorite(e)}}}}function dbClickFavorite(d){var b=$("#"+d);if(chooseMode==1){var a=b.attr("objectid");submitSelected([a])}else{var c=_buildSelectedData(b);if(!c){return}putToSelectedBox(c)}}function _buildSelectedData(b){var a=b.attr("unselectable")==="true"?true:false;if(a){return null}var c={};c.id=b.attr("objectid");c.fullName=b.attr("fullname");c.name=b.attr("name");return c}function calcelGroup(){var a=$("#addFavoriteGroup_li");cui("#groupName").setValue("");$("#addFavoriteDiv").show();a.find(".editFavoriteGroupName").hide()}function getFavoriteGroupList(b,c){var a;if(chooseType=="org"){a=2}else{a=1}FavoriteAction.getFavoriteGroupList(a,function(d){if(!d){d=[]}b.setDatasource(d);c()})}function joinFavorite(){getFavoriteGroupList(cui("#favoriteGroupSelect"),function(){cui("#favoriteSelectWin").dialog({title:"\u9009\u62e9\u5206\u7ec4",modal:true,width:200,height:40,buttons:[{name:"\u786e\u5b9a",handler:function(){var a="",d=cui("#favoriteGroupSelect").getValue();if(chooseMode==1){var b=cui("#tree").getActiveNode();if(!b||(chooseType==="user"&&b.getData().isFolder)){this.hide();return}a=b.getData().key}else{var h=cui("#tree").getSelectedNodes(false);if(h&&h.length){for(var c=0;c<h.length;c++){a+=h[c].getData().key+";";h[c].select(false)}}}if(a){var f=cui("#favoriteGroupSelect").getText();if(d==f){if(f&&$.trim(f)){var e=comtop.String.getBytesLength(f);if(e>20){f=comtop.String.intercept(f,20)}var g={favoriteGroupName:f,favoriteClassify:chooseType=="org"?2:1};FavoriteAction.saveFavoriteGroup(g,function(i){addNewGroupToLast(i);saveFavoriteToDB(a,i.favoriteGroupId)})}}else{saveFavoriteToDB(a,d)}}this.hide()}},{name:"\u53d6\u6d88",handler:function(){this.hide()}}]}).show()})}function addFavoriteGroup(){if(updateLinkId!=""){cancelUpdateGroup(updateLinkId)}var a=$("#addFavoriteGroup_li");$("#addFavoriteDiv").hide();a.find(".editFavoriteGroupName").css("display","inline");cui("#groupName").focus()}function saveGroup(){var d=cui("#groupName");var c=window.validater.validOneElement(d);if(!c.valid){return}var e=$.trim(d.getValue());d.focus();if(e==""){showErrorMessage("\u5206\u7EC4\u540D\u79F0\u5FC5\u586B");return}var a=e;var b={favoriteGroupName:a,favoriteClassify:chooseType=="org"?2:1};FavoriteAction.saveFavoriteGroup(b,function(f){showSuccessMessage("\u5206\u7EC4\u6DFB\u52A0\u6210\u529F\u3002");calcelGroup();addNewGroupToLast(f)})}function addNewGroupToLast(d){d.children=[];var b=[d];var a=new jCT(jctTemplate);a.Build();var c=a.GetView(b);$("#addFavoriteGroup_li").before(c);$("#addFavoriteGroup_li").remove();bindEvent($("li[name='groupLi'][favoriteGourpId='"+d.favoriteGroupId+"']"))}function initFavoriteDept(){$("#div_tree_favorite").show();var a=cui("#orgStructure_favorite").getValue();if(a){var b=0;if(chooseType=="org"){b=2;userType=0}else{b=1;levelFilter=999}var c={rootDepartmentId:getRootId(favoriteRootId,a),favoriteClassify:b,userType:userType,orgStructureId:a,unselectableCode:unselectableCode,levelFilter:levelFilter};FavoriteAction.getCommonFavoriteList(c,function(f){if(jctTemplate==null){jctTemplate=$("#template").html()}var d=new jCT(jctTemplate);d.Build();var e=d.GetView(f);$(".favoriteTree").html(e);bindEvent();comtop.UI.scan($("#addFavoriteGroup_li"));isOnloadFavoriteData=true})}}function showMoreDataOfFavorite(){var a=$("#moreDataOfFavorite");if(a.hasClass("more_data")){pageNo++;a.removeClass("more_data");a.addClass("more_data_disable");_queryDataOfFavorite("add")}}function queryDataOfFavorite(a){if(typeof a=="undefined"||isValidKeyCodeForQueryData(a.keyCode)){clearTimeout(tempFavoriteFunc);clearTimeout(tempNoDataFavoriteFunc);pageNo=1;tempFavoriteFunc=setTimeout(function(){_queryDataOfFavorite("replace")},300)}}function _queryDataOfFavorite(c){var f=handleStr($.trim(cui("#keyword_favorite").getValue()));if(f==""){closeFastDataDiv("searchDivOfFavorite");return}else{var b=cui("#orgStructure_favorite").getValue();if(b){var a=prefixOfDeptQueryFavorite;var e;if(chooseType=="org"){userType=0;e=2}else{a=prefixOfUserQuery;e=1}var d={rootDepartmentId:getRootId(rootId,b),orgStructureId:b,pageSize:pageSize,pageNo:pageNo,keyword:f,unselectableCode:unselectableCode,levelFilter:levelFilter,userType:userType,favoriteClassify:e};FavoriteAction.fastQueryFavorite(d,function(k){var i={};i.searchDiv="searchDivOfFavorite";i.queryDataAreaDiv="queryDataAreaOfFavorite";i.moreDataDiv="moreDataOfFavorite";if(k.count==0){cacheData=null;$("#moreDataOfFavorite").css("display","none");$("#queryDataAreaOfFavorite").height(0);if(chooseType=="org"){$("#queryDataAreaOfFavorite").html('<span class="no_data" >&nbsp;\u5e38\u7528\u7ec4\u7ec7\u4e2d\u65e0\u8be5\u7ec4\u7ec7</span>')}else{$("#queryDataAreaOfFavorite").html('<span class="no_data" >&nbsp;\u5e38\u7528\u8054\u7cfb\u4eba\u4e2d\u65e0\u8be5\u4eba\u5458</span>')}showOrDisplay(i,"no_data");clearTimeout(tempNoDataFavoriteFunc);tempNoDataFavoriteFunc=setTimeout(function(){closeFastDataDiv("searchDivOfFavorite")},2000)}else{var l=$("#"+getQueryDataAreaId(true)),j=l.children(),h=j.length;if(c==="replace"){currentIndex=-1;cacheData=k.list}else{$.each(k.list,function(){cacheData.push(this)})}installData(i,k,c);showOrDisplay(i,a);var g=$("#"+i.moreDataDiv);g.removeClass("more_data_disable");g.addClass("more_data");if(c==="add"){scrollHoverPositionToBottom(true,h-1);cui("#keyword_favorite").focus()}}})}}}function renderOneFavoriteGroup(e){var b=$("li[name='groupLi'][favoriteGourpId='"+e+"']").eq(0);var a=cui("#orgStructure_favorite").getValue();var c;if(chooseType=="org"){userType=0;c=2}else{c=1;unselectableCode="";levelFilter=""}var d={rootDepartmentId:getRootId(favoriteRootId,a),userType:userType,favoriteClassify:c,orgStructureId:a,favoriteGroupId:e,unselectableCode:unselectableCode,levelFilter:levelFilter};FavoriteAction.getOneFavoriteDepartmentList(d,function(h){var f=new jCT(jctTemplate);f.Build();var g=f.GetView(h);b.replaceWith(g);b=$("li[name='groupLi'][favoriteGourpId='"+e+"']").eq(0);$("#addFavoriteGroup_li").remove();bindEvent(b)})}var globalGroupId="";function groupOnclick(c){if(c.target.innerHTML.indexOf("\u5220\u9664")>-1){return}var b=$(c.data.obj).parent();clearGroupBackGround();clearFavoriteTreeSelected();globalGroupId=b.attr("id").replace("div_","");addGroupBackGroup();var a=b.next();if("none"==a.css("display")){$(c.data.obj).removeClass("showFavoriteGroupNameClose");a.show()}else{$(c.data.obj).addClass("showFavoriteGroupNameClose");clearFavoriteTreeSelected();a.hide()}return false}function clearGroupBackGround(){if(globalGroupId!==""){var a=getGroupLi(globalGroupId);a.find("span[id^='span_favoriteGroupName_']").eq(0).removeClass("selectedDiv")}}function addGroupBackGroup(){if(globalGroupId!==""){var a=getGroupLi(globalGroupId);a.find("span[id^='span_favoriteGroupName_']").eq(0).addClass("selectedDiv")}}function getGroupLi(a){return $("li[name='groupLi'][favoriteGourpId='"+a+"']").eq(0)}function getWindowSize(){var b=535;var a=495;var f,e;var c=window.top.comtop.Browser.isQM;var d=comtop.Browser.isIE;if(d&&c){b+=18}f=(window.screen.width-20-b)/2;e=(window.screen.height-30-a)/2;return{width:b,height:a,offsetLeft:f,offsetTop:e}}function addFavoriteDept(e){gGroupId=e;var c=cui("#orgStructure_favorite").getValue();var g=cui("#orgStructure_favorite").getText();g=encodeURIComponent(encodeURIComponent(g));var f="";if(cmpID!=""){f=cmpID}else{f=getDialogId()}var b=getWindowSize();var a=webPath+"/top/sys/usermanagement/orgusertag/addFavorite.jsp?groupId="+gGroupId+"&&orgStructureId="+c+"&&rootId="+favoriteRootId+"&&orgStructureName="+g+"&unselectableCode="+unselectableCode+"&levelFilter="+levelFilter+"&chooseType="+chooseType+"&idSuffix="+f+"&winType="+winType;if(winType==="window"){window.open(a,"ChooseFavoritePage","left="+b.offsetLeft+",top="+b.offsetTop+",width="+b.width+",height="+b.height+",menu=no,toolbar=no,resizable=no,scrollbars=no")}else{var d;if(window.top.cuiEMDialog&&window.top.cuiEMDialog.dialogs){d=window.top.cuiEMDialog.dialogs["addFavoriteOrgDialog"+f]}if(!d){d=cui.extend.emDialog({id:"addFavoriteOrgDialog"+f,title:"\u9009\u62e9\u5e38\u7528\u7ec4\u7ec7",src:a,width:b.width,height:b.height})}else{d.reload(a)}d.show()}}function getDialogId(){var a="topdialogwithjsopen";if(jsID){a+=jsID}return a}function addFavoriteUser(f,a){gGroupId=f;var d=cui("#orgStructure_favorite").getValue();var h=cui("#orgStructure_favorite").getText();h=encodeURIComponent(encodeURIComponent(h));var g="";if(cmpID!=""){g=cmpID}else{g=getDialogId()}var c=getWindowSize();var b=webPath+"/top/sys/usermanagement/orgusertag/addFavorite.jsp?groupId="+gGroupId+"&&orgStructureId="+d+"&&rootId="+favoriteRootId+"&&orgStructureName="+h+"&&userType="+userType+"&chooseType="+chooseType+"&idSuffix="+g+"&winType="+winType;if(winType==="window"){window.open(b,"ChooseFavoritePage","left="+c.offsetLeft+",top="+c.offsetTop+",width="+c.width+",height="+c.height+",menu=no,toolbar=no,resizable=no,scrollbars=no")}else{var e;if(window.top.cuiEMDialog&&window.top.cuiEMDialog.dialogs){e=window.top.cuiEMDialog.dialogs["addFavoriteUserDialog"+g]}if(!e){e=cui.extend.emDialog({id:"addFavoriteUserDialog"+g,title:"\u9009\u62e9\u5e38\u7528\u8054\u7cfb\u4eba",src:b,width:c.width,height:c.height})}else{e.reload(b)}e.show()}}function saveFavoriteToDB(a,b){var c;var e="";if(chooseType=="org"){c=2;e="\u5e38\u7528\u7ec4\u7ec7"}else{c=1;e="\u5e38\u7528\u8054\u7cfb\u4eba"}var d={objectId:a,favoriteGroupId:b,favoriteClassify:c};FavoriteAction.saveFavorite(d,function(){renderOneFavoriteGroup(b);showSuccessMessage(e+"\u4FDD\u5B58\u6210\u529F\u3002")})}function checkGroupName(b){var a=true;if(b==""){showErrorMessage("\u5206\u7EC4\u540D\u79F0\u5FC5\u586B");return false}$(".favorite_floder").each(function(){if(updateLinkId==""){if($.trim(b)==$(this).attr("groupName")){a=false;return}}else{if($.trim(b)==$(this).attr("groupName")&&$(this).attr("id")!=updateLinkId){a=false;return}}});return a}function cancelUpdateGroup(c){updateLinkId="";var a=$("#"+c);a.children(".showFavoriteGroupName").show();var b=a.children(".editFavoriteGroupName");b.empty()}var tmpObj;function groupOnMouseOver(a){tmpObj=$(a.data.obj);var b=tmpObj.find("div");if(chooseType=="org"){if("\u5E38\u7528\u7EC4\u7EC7"!=tmpObj.parent().attr("groupName")){b.css("display","inline")}}else{if("\u5E38\u7528\u8054\u7CFB\u4EBA"!=tmpObj.parent().attr("groupName")){b.css("display","inline")}}}function groupOnMouseOut(a){$(a.data.obj).find("div").hide()}function deleteFavoriteGroup(d){var b=getGroupLi(d);var a=b.children(".favorite_floder");if(a.attr("count")==0){__deleteFavoriteGroup(b,d);return}var c=chooseType=="org"?"\u5206\u7EC4\u4E2D\u6709\u005B\u5E38\u7528\u7EC4\u7EC7\u005D\uFF0C\u786E\u5B9A\u5220\u9664\u5417\uFF1F":"\u5206\u7EC4\u4E2D\u6709\u005B\u5E38\u7528\u4EBA\u5458\u005D\uFF0C\u786E\u5B9A\u5220\u9664\u5417\uFF1F";cui.confirm(c,{onYes:function(){__deleteFavoriteGroup(b,d)},width:200,title:"\u5220\u9664<b>["+a.attr("groupName")+"]</b>"})}function __deleteFavoriteGroup(a,b){FavoriteAction.deleteFavoriteGroup(b,function(){a.remove();showSuccessMessage("\u5206\u7EC4\u5220\u9664\u6210\u529F\u3002")})}function updateGroupName(c,a){var b=$.trim(cui("#updateGroupName").getValue());if(c==b){cancelUpdateGroup("div_"+a);return}var f=window.validater.validOneElement(cui("#updateGroupName"));if(!f.valid){return}var d=b;var e={favoriteGroupId:a,favoriteGroupName:d};FavoriteAction.updateFavoriteGroup(e,function(){$("#span_favoriteGroupName_"+a).html("&nbsp;"+b+"&nbsp;");$("#div_"+a).attr("groupName",b);cancelUpdateGroup("div_"+a);showSuccessMessage("\u5206\u7EC4\u4FEE\u6539\u6210\u529F\u3002")})}var priorSelected=null;function bindEvent(c){var d=$(".deptName");var a=$("span.showFavoriteGroupName");if(typeof c!=="undefined"){d=c.find(".deptName");a=c.find("span.showFavoriteGroupName")}d.on("click",function(e){var g=e.shiftKey;var o=$(e.target).closest("li[id^=li_]");if(o.length==0){return false}objDept=o;if(o&&o.attr("unselectable")!=="true"){var m=o.attr("id");if(objDept.className!="addFavoriteDept"){if(o.hasClass("favoriteDeptOrUserChoose")){priorSelected=null;clearFavoriteSelected(m)}else{if(m&&chooseMode==1){clearFavoriteTreeSelected();selectFavorite(o)}else{if(m&&chooseMode!=1&&g){if(priorSelected==null){priorSelected=m}else{var l=_getAllFavoriteEle();var n=_getRowIndexById(l,m);var f=_getRowIndexById(l,priorSelected);clearFavoriteTreeSelected();for(var k=Math.min(n,f),h=Math.max(n,f);k<=h;k++){selectFavorite(l.eq(k))}}selectFavorite(o)}else{priorSelected=m;selectFavorite(o)}}}}if("addFavorite_li"!==m){clearGroupBackGround();globalGroupId=""}else{m=""}}return false});d.delegate(".group_delete","click",function(h){var i=this;var k=$(i).attr("favoriteGourpId");var e=$(i).parent();var j=e.attr("favoriteId");var g=$("#span_favoriteGroup_"+k);var f=g.html();clearFavoriteSelected(e.attr("id"));e.parent().prev().attr("count",f-1);g.html(f-1);deleteFavoriteById(j);e.remove()});$AllLi=d.find("li[id^='li_']");for(var b=0;b<$AllLi.length;b++){$AllLi.eq(b).on("mouseover",function(){$(this).addClass("slideDIV");$(this).find("span").addClass("display_block")}).on("mouseout",function(e){$(this).removeClass("slideDIV");$(this).find("span").removeClass("display_block")})}a.each(function(){$(this).bind("mouseover",{obj:this},groupOnMouseOver);$(this).bind("mouseout",{obj:this},groupOnMouseOut);$(this).bind("mousedown",{obj:this},groupOnclick)})}function _getAllFavoriteEle(){var a=$(".favoriteTree").find("li[id^=li_]");return a}function _getRowIndexById(c,b){var a=c.index($("li[id="+b+"]"));return a}function getAllSelectedFavorite(){return $(".favoriteTree").find(".favoriteDeptOrUserChoose")}function selectFavorite(a){a.addClass("favoriteDeptOrUserChoose");a.removeClass("slideDIV")}function deleteFavoriteById(b){var a="";if(chooseType=="org"){a="\u5e38\u7528\u7ec4\u7ec7"}else{a="\u5e38\u7528\u8054\u7cfb\u4eba"}FavoriteAction.deleteFavorite(b,function(){showSuccessMessage(a+"\u5220\u9664\u6210\u529F\u3002")})}function clearSelectedFavorite(a){if(a&&a.length){a.removeClass("favoriteDeptOrUserChoose");a.removeClass("slideDIV");a.find("span").removeClass("display_block")}}function clearFavoriteSelected(a){if(a){var b=$("#"+a);clearSelectedFavorite(b)}}function clearFavoriteTreeSelected(){var b=getAllSelectedFavorite();if(b&&b.length){var a=b.length;for(var c=0;c<a;c++){clearSelectedFavorite(b.eq(c))}}}function updateFavoriteGroup(e){calcelGroup();if(updateLinkId!=""){cancelUpdateGroup(updateLinkId)}updateLinkId=e;var d=$("#"+e);d.next().show();d.children(".showFavoriteGroupName").hide();var c=d.children(".editFavoriteGroupName");c.show();var f=d.attr("groupName");var a=d.attr("id").replace("div_","");var b="<img src=\"images/add.gif\"/>&nbsp;<span uitype=\"Input\" maxlength=\"20\" validate=\"[{'type':'required', 'rule':{'m': '\u5206\u7EC4\u540D\u79F0\u5FC5\u586B'}},{ 'type':'custom','rule':{'against':'checkGroupName', 'm':'\u540D\u79F0\u4E0D\u80FD\u91CD\u590D'}}]\" id=\"updateGroupName\" value=\""+f;b+='" name="input" width="100px" /><a class="submit" hidefocus="true" onclick="updateGroupName(\''+f+"','"+a+'\');return false;" href="#">&nbsp;&nbsp;\u786E\u5B9A</a>&nbsp;|&nbsp;<a class="cancel" hidefocus="true" onclick="cancelUpdateGroup(\''+e+'\');return false;" href="#">\u53D6\u6D88</a>';c.html(b);comtop.UI.scan(d);cui("#updateGroupName").focus()}function showSuccessMessage(a){cui.message(a,"success")}function showErrorMessage(a){cui.message(a,"error",{autoClose:4000})};