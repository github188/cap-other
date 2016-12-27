/**
 * 用途：人员组织标签公用js
 *
 */
	
	/**
	 * 树型展示公共JS
	 * **/
	
	//转换节点集合
	function handleNodeList(lst){
		for(var i=0;i<lst.length;++i){
			var vo = lst[i];
			handleNodeData(vo);
		}
	}
	
	//转换节点
	function handleNodeData(data){
		data.isLazy = data.isLazy=='true'?true:false;
		if(data.isFolder=='true'){//组织节点
			data.isFolder=true;
			if(chooseType==="org"&&data.unselectable){
				data.icon='./images/folder_close_readonly.gif';
			}else{
				data.icon='./images/folder_close.gif';
				if(chooseType==="user"&&data.unselectable){
					data.hideCheckbox=true;
				}
			}
		}else{//用户节点
			data.isFolder=false;
			if(data.sex==2){//女
				data.icon='./images/girl.gif';
			}else{//男
				data.icon='./images/boy.gif';
			}
		}
	}
	//加载下级节点
	function lazyData(node){
		var data = []
		if(chooseType==="org"&&node.getData('unselectable')){
			node.setData('icon','./images/folder_open_readonly.gif');
		}else{
			node.setData('icon','./images/folder_open.gif');
		}
		
		data = node.getData().children;
		handleNodeList(data);
		node.addChild(data);
	}
	
	//树节点展开合起触发
	function onExpand(flag,node){
		if(flag){
			if(chooseType==="org"&&node.getData('unselectable')){
				node.setData('icon','./images/folder_open_readonly.gif');
			}else{
				node.setData('icon','./images/folder_open.gif');
			}
		}else{
			if(chooseType==="org"&&node.getData('unselectable')){
				node.setData('icon','./images/folder_close_readonly.gif');
			}else{
				node.setData('icon','./images/folder_close.gif');
			}
		}
	}

	/**
	选中节点时回调
	@param node 选中的节点
	*/
	function selectNode(node){
		if(chooseType==="user"&&node.getData().isFolder){
			return;
		}
		node.toggleSelect();
	}
	
	/**
	 * 推到已选记录框
	 * @returns true 添加成功，需要清除左边的选中标志,false 添加失败，不需要清除左边的选中标志
	 */
	function putToSelectedBox(name){ 
		var container= getSelectedBox();
		
		var exist = container.has("[title="+name+"]");
		if(exist&&exist.length){
			//如果已经添加，则直接返回
			return true;
		}
		var len = container.children().length;
		if(chooseMode>1&&len==chooseMode){
			//最多选择  个人员
			if(chooseType=='user'){
				cui.alert('\u6700\u591A\u9009\u62E9'+chooseMode+'\u4e2a\u4eba\u5458');
			} else{ //最多选择 个组织
				cui.alert('\u6700\u591A\u9009\u62E9'+chooseMode+'\u4e2a\u7ec4\u7ec7');
			}
			return false;
		}
		var objDiv = $('<div>').attr('title',name).attr('id','div_'+name)
					.append($('<span>').html(name))
					.append($('<a>').attr('href','#').attr('class','block_delete').click(function(){
							$(this).parent().remove();
							renderSelectedCount();
							return false;
					}));
		objDiv.attr('class','block_stand');
		container.append(objDiv);
		renderSelectedCount();
		return true;
	}

	/**
	 * 获取激活的tab页，如果是组织结构tab页或者没有tab即addFavorite页，则返回true，如果是常用部门tab页，则返回false
	 * 
	 */
	function getTab(){ 
		var tab = cui("#tab");
		if(!tab.getActiveTab||tab.getActiveTab() == tab.getTab(0)){
			return true;
		}
		return false;
	}
	
	/**
	 * 绑定tab页事件
	 */
	function changeTab(){
		// 切换tab页事件
		cui("#tab").bind("switch",function(event,data){
			pageNo = 1;
			if(data.fromTab == 0 && data.toTab == 1){
				// 从"组织结构"切换到"常用部门"
				// 如果还没加载常用联系人数据，则加载
				if(isOnloadFavoriteData == false){
					initFavoriteDept();
				}
				$("#div_selected_favorite").append($("#div_selected div:nth-child(n-1)"));
				$("#div_selected div:nth-child(n-1)").remove();
			}else if(data.fromTab == 1 && data.toTab == 0){
				clearFavoriteTreeSelected();
				// 从"常用部门"切换到"组织结构"
				$("#div_selected").append($("#div_selected_favorite div:nth-child(n-1)"));
				$("#div_selected_favorite div:nth-child(n-1)").remove();
			}
			renderSelectedCount();
		});
	}
	
	/**
	 * 单选绑定tab页事件 
	 * */
	function repaint(){
		// 切换tab页事件
		cui("#tab").bind("switch",function(event,data){
			if(data.fromTab == 0 && data.toTab == 1){
				$("#favorite").parent().addClass("repaint");
			}else if(data.fromTab == 1 && data.toTab == 0){
				$("#choose_page_box").parent().addClass("repaint");
			}
		});
	}
	
	//判断是否已经被选择
	function isSelected(id){
		var selectedContainer =getSelectedBox();
		var exist = selectedContainer.has("[id=div_"+escapeJquery(id)+"]");
		if(exist&&exist.length){
			return true;
		}
		return false;
	}
	/**删除右边选择框中已经选择的节点
	*/
	function deleteSelectedData(){
		var container = getSelectedBox();
		//获取所有选中的节点
		var $SelectData  = container.children(".selectedDiv");
		if($SelectData.length==0){
			return ;
		}
		
		$SelectData.remove();
		renderSelectedCount();
	}
	
	//点击清除按钮时 清除已选记录
	function clearSelected(){
		if(chooseMode==1){
			var curNode = cui("#tree").getActiveNode();
			if(curNode){
				curNode.deactivate();
			}
			clearFavoriteTreeSelected();
			return;			
		}
		$('#div_selected').children().remove();
		$('#div_selected_favorite').children().remove();
		renderSelectedCount();
	}
	
	/**
	添加一个节点
	@return 当不能再继续添加时返回false 否则返回true
	*/
	function addOneNode(node){
		if(node&&node.dNode){
			var data = node.getData();
			if(chooseType=='user'&&data.isFolder){//选择人员时，跳过组织节点
				return false;
			}
			if(data.unselectable==false){
				var added =addDataToSelected(data); 
				if(added){
					node.select(false)
				}
	        	return added;
			}
			return true;
		}
	}
	
	//TODO:chooseMode==0，多选状态时
	//添加子节点
	function addDataChild(){
		//如果当前活动节点是组织结构
		var node = cui('#tree').getActiveNode();
		if(node!=null&&node.dNode){
			var data = node.getData();
//			if(chooseType=='user'&&data.isFolder){//选组织的直属用户
//				ChooseAction.queryChildUser(data.key,userType,function(lst){
//					var flag ;
//					for(var i=0;i<lst.length;++i){
//						flag = addDataToSelected(lst[i]);
//						if(!flag){
//							break;
//						}
//					}
//				});
//			}else if(chooseType=='org'){//选组织的下级组织
//				ChooseAction.queryChildOrg(data.key,levelFilter,unselectableCode,function(lst){
//					var flag ;
//					for(var i=0;i<lst.length;++i){
//						flag = addDataToSelected(lst[i]);
//						if(!flag){
//							break;
//						}
//					}
//				});
//			}
			node.select(false);
		}			
	}
	
	//双击树节点
	function dbclickNode(node){
		var data = node.getData();
		if(chooseType==="org"&&data.unselectable){
			return;
		}
		if(chooseMode==1){//单选时直接提交并关闭窗口
			if(chooseType=='user'&&data.isFolder){
				//选择人员时，双击组织节点
				return;
			}else{
				submitSelected(data.key);
			}
		}else{//多选时添加到右边已选框
			if(chooseType=='user'&&data.isFolder){//选择人员时，双击组织节点
				var flag;
				for(var i=0;i<data.children.length;i++){
					flag = addDataToSelected(data.children[i]);
					if(!flag){
						break;
					}
				}
			}else{
				addDataToSelected(data);
			}
		}
	}
	
	//添加数据到已选记录
	function addDataToSelected(data){
		if(chooseType==="org"&&data.unselectable){
			return true;
		}
		return	putToSelectedBox(data.title);
	}
	
	/**添加选中的节点或记录
	   用于将从左边选择的树节点或常用联系人/组织节点，添加到右边已选框去
	**/
	function addData(isQuery){
		//如果当前活动节点是组织结构
		if(getTab()){
			var selectNodes= cui('#tree').getSelectedNodes(false);
			if(selectNodes&&selectNodes.length){
				var node;
				for(var i=0;i<selectNodes.length;i++){
					node = selectNodes[i];
					if(addOneNode(node)==false){
						break;
					}
				}
			}
		}else{
			var selected = getAllSelectedFavorite();
			putSelectedFavoriteToBox(selected,isQuery);
		}
	}
	/**
	 * 树型展示公共JS END
	 * **/
	
	
	var tempFunc;
	var tempNoDataFunc,tempSelectFunc;
	// 全局变量，用于保存快速搜索下拉列表中，搜索出的根部门id
	var rootDeptTabId;
	// 检索框<a>标签的id前缀，检索出的部门标签格式为：<a><span></span><span></span></a>
	var prefixOfQueryA = "a_query_";
	// 检索框<a>标签的class，组织结构
	var prefixOfDeptQuery = "dept_query";
	// 检索框<a>标签的class，常用部门
	var prefixOfDeptQueryFavorite = "dept_query";
	//人员检索框<a>标签的class 
	var prefixOfUserQuery = "user_query";
	
	//快速查询结果框分割线样式 
	var lineClassName="cutoff_line";
	
	var cacheData;//快速查询结果缓存
	var currentIndex =-1;
	
	/**
	 * 是否为有效按键
	 */
	function isValidKeyCodeForQueryData(keyCode){
		//回车要排除，否则弹出窗口会显示两次
		if(keyCode === 13 || keyCode === 37 || keyCode === 38
			|| keyCode === 39 || keyCode === 40){
			return false;
		}
		return true;
	}

	/**
	 * 搜索框输入查询
	 */
	function queryData(event){

		//判断键盘事件，抛弃上下键跟回车键
		if(typeof event == "undefined" || isValidKeyCodeForQueryData(event.keyCode)){
			clearTimeout(tempFunc);
			clearTimeout(tempNoDataFunc);
			pageNo = 1;
			tempFunc = setTimeout(function(){_queryData("replace")},300);
		}
	}

	/**
	 * @param type add||replace
	 * @param orgStructureId 组织结构id 不传递时从下拉框取 。添加常用联系人/组织页面会传递
	 * @param rootId 根节点id 不传递时从树根节点取 。添加常用联系人/组织页面会传递
	 * **/
	function _queryData(type){
		if(!cui('#orgStructure').getValue()){
			return;
		}
		// 获取查询的字段
		var queryStr =handleStr($.trim(cui('#keyword').getValue()));
		
		// 如果字段为空，即用户清空查询字段后，收起div
		if(queryStr == ""){
			closeFastDataDiv("searchDiv");
//			$("#searchDiv").slideUp("fast");
			return;
		}else{
			// 获得下拉框的值，即搜索框的范围
			_doQuery(queryStr,type);
		}
	}
	
	/**
	 * 快速查询结束后 拼装结果并展示
	 * "org",operatorType,data
	 * @param queryStr 查询字段
	 * **/
	function _doQuery(queryStr, operatorType){
		var data = [],
		     treeData = cui('#tree').getDatasource();
		treeData ? $.each(treeData, function(i,n){
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

		var objDiv ={},
		     type = chooseType;
		objDiv.searchDiv = "searchDiv";
		objDiv.queryDataAreaDiv = "queryDataArea";
		objDiv.moreDataDiv = "moreData";
		if(data.length === 0){
			cacheData = null;
   		   	$("#moreData").css('display','none');
   		   	$('#queryDataArea').height(0);
   		   	var nodataHtml = "";
   		   	if(type === "org"){
	   		   	//未查到该组织\u672a\u67e5\u5230\u8be5\u7ec4\u7ec7
   		   		nodataHtml='<span class="no_data" >&nbsp;\u672a\u67e5\u5230\u8be5\u7ec4\u7ec7</span>';
   		   	}else if(type === "user"){
   		   		//未查到该人员
   		   		nodataHtml='<span class="no_data" >&nbsp;\u672a\u67e5\u5230\u8be5\u4eba\u5458</span>';
   		   	}
			$('#queryDataArea').html(nodataHtml);
			showOrDisplay(objDiv,"no_data");
   		  	clearTimeout(tempNoDataFunc);
   		  	tempNoDataFunc = setTimeout(function(){
   		  		closeFastDataDiv("searchDiv");
   		  	},2000);
   		}else{
   			var $box= $("#"+ getQueryDataAreaId(false)),
        	children = $box.children(),
        	len = children.length ;
   			if(operatorType==="replace"){
   				currentIndex = -1;
   				cacheData = data;
   			}else{
   				if(!cacheData){
   					cacheData = [];
   				}
   				$.each(data,function(){
   					cacheData.push(this);
   				});
   			}
   			//然后将数据拼装到DIV中
			installData(objDiv,data,operatorType);
			
			var prefixOfQuery="";
			if(type === "org"){
				prefixOfQuery=prefixOfDeptQuery;
			}else if(type === "user"){
				prefixOfQuery=prefixOfUserQuery;
			}
   			showOrDisplay(objDiv,prefixOfQuery);
   			var moreData = $("#"+objDiv.moreDataDiv);
   			moreData.removeClass("more_data_disable");
   			moreData.addClass("more_data");
   			if(operatorType==="add"){
   				scrollHoverPositionToBottom(false,len-1);
   				cui("#keyword").focus();
   			}
   		}
	}
	/**
	 * 展示更多数据
	 */
	function showMoreData(){
		var moreData = $("#moreData");
		if(moreData.hasClass("more_data")){
			pageNo++;
			moreData.removeClass("more_data");
			moreData.addClass("more_data_disable");
			_queryData("add");
		}
	}

	/**
	 * 获取搜索下拉框模板;
	 */
	function getMenuItemTemplate(obj,i) {
		// 获得部门的上级部门全名
		var subDeptFullName = subDepartmentFullName(obj.fullName,obj.title);
		// 如果是系统根部门，即部门fullname中没有上级部门，则采用单行显示
		if(subDeptFullName == ""){
			// 获得模板中的<a>标签id，用于改变样式，把双行的样式改为单行
			rootDeptTabId = prefixOfQueryA + obj.key;
			// 创建单行模板
			var bufferSingle = [
		       		"<a href='#' class='",
		       		obj.className,"' id='",prefixOfQueryA,obj.key,"'","orgreadonly='",obj.unselectable, "'>",
			    		"<span class='", obj.firstClassName, "' title='",obj.title, "'>",obj.title,"</span>",
		    		"</a>"
			       	];
			return bufferSingle.join("");
		}else{
			// 非根部门则采用双行显示
			var bufferDouble = [
		       		"<a href='#' class='",obj.className,"' id='",prefixOfQueryA,obj.key,"'","orgreadonly='",obj.unselectable, "'>",
			    		"<span class='", obj.firstClassName, "' title='",obj.title, "'>",obj.title,"</span>",
			    		"<span class='", obj.lastClassName, "' title='",subDeptFullName,"'>",subDeptFullName,"</span>",
		    		"</a>"
			       	];
			return bufferDouble.join("");
		}
	}
	
    /**
     * 获取人员搜索下拉框模板html代码
     * @param data,查询结果，包括count,list
     * */
    function buildListItemTemplate(data){
    	var objDiv = "";
    	var tempCount = data.length;
    	var tmpData = data;
    	if(chooseType==="user"){
    		tmpData = sameNameDispose(tmpData,tempCount);
    	}
    	var oneNode 
    	if(chooseType==="user"){
    		for(var i=0;i<tempCount;i++){
    			objDiv += getUserMenuItemTemplate(tmpData[i],i);
    		}
    	}else{
    		for(var i=0;i<tempCount;i++){
    			oneNode = tmpData[i];
    			if(oneNode.unselectable){
    				oneNode.className= "dept_query dept_query_readonly";
    			}else{
    				oneNode.className="dept_query";
    			}
    			oneNode.firstClassName="dept_first";
    			oneNode.lastClassName="dept_last";
    			
    			objDiv += getMenuItemTemplate(tmpData[i],i);
    		}
    	}
    	return objDiv;
    }
    
    /**
     * 获取用户查询结果的模板
     **/
    function getUserMenuItemTemplate(data,i) {
    	//如果是同名的人员，使用两行的样式展现。
    	if(data.hasSameName){
    		// 获得用户所在部门的上级部门全名
    		var subDeptFullName = subDepartmentFullName(data.fullName,data.orgName);
    		var userClass= "";
    		if(data.hasCutoffLine){
    			userClass = "user_query user-same-name user-same-name-last"
    		}else{
    			userClass = "user_query user-same-name";
    		}
    		//由于在给每个搜索结果添加事件时，要用到className，所以给他添加user_query的class，但是同名的人员要用另外一种样式展现，所以加上style属性，覆盖user_query样式。
    		var bufferDouble = [
    		                    "<a href='#' class='"+userClass+"' " +
    		               		"id='",prefixOfQueryA,data.key,"'>",
    		        	    		"<span class='user-name' title='",data.title, "'>",data.title,"</span>",
    		        	    		"<span class='user-deptname' title='",data.orgName,"'>",data.orgName,"</span>",
    		        	    		"<span class='user-deptfullname' title='",subDeptFullName,"'>",subDeptFullName,"</span>",
    		            		"</a>"
    		        	    	];
        	return bufferDouble.join("");
    	}else{
    		var bufferDouble = [
    		               		"<a href='#' class='user_query' id='",prefixOfQueryA,data.key,"'>",
    		        	    		"<span class='user_first' title='",data.title, "'>",data.title,"</span>",
    		        	    		"<span class='user_last' title='",data.fullName,"'>",data.fullName,"</span>",
    		            		"</a>"
    		        	       	];
        	return bufferDouble.join("");
    	}

    }
    
    /**
     * 标示出人员名称相同的数据，方面后续展现不同的效果
     */
    function sameNameDispose(data,tempCount){
    	var i=0;
    	for(var j=i+1;j<tempCount;j++){
    		if(data[i].title==data[j].title){
    			data[i].hasSameName=true;
    			data[j].hasSameName = true;
    		}else{
    			if(data[i].hasSameName){
    				data[i].hasCutoffLine = true;
    			}
    		}
    		i++;
    	}
    	return data;
    }
    
	/**
     * 组装检索下拉div数据
     * @param divObj 检索框相关divid 
     * @param data 数据
     * @param operatorType 操作类别
     */
	function installData(divObj,data,operatorType){
		var totalPage = Math.ceil(data.length / 10 ) ;
    	var objDiv = buildListItemTemplate(data);
    	
    	// 如果是组织结构tab页的检索框
    	if(operatorType=="add"){
    		$('#'+divObj.queryDataAreaDiv).append(objDiv);
    	}else if(operatorType=="replace"){
    		$('#'+divObj.queryDataAreaDiv).height(0);
    		$('#'+divObj.queryDataAreaDiv).html(objDiv);
    	}
    	// 如果是根部门，则单行显示
    	if(rootDeptTabId != ""&&chooseType==="org"){
    		$("#"+rootDeptTabId).css("height","20px");
    	}
    	//如果查询出来的数据条数大于每页显示条数，则显示更多数据。
    	if(pageNo==totalPage){
    		$("#"+divObj.moreDataDiv).css('display','none');
    	}else{
    		$("#"+divObj.moreDataDiv).css('display','block');
    	}
    }
	
	/**
	 * 搜索结果下拉框的展示或隐藏方法
	 * @param objDiv 用到的divid 
	 */
	function showOrDisplay(objDiv,queryClass){
		var tmpSearchDiv = $("#"+objDiv.searchDiv);
		var $queryDataArea = $('#'+objDiv.queryDataAreaDiv);
		// 先隐藏模板拼接的数据，避免数据量大把document撑大，在后面再show()
    	$queryDataArea.hide();
//    	var pageHeight = $(document).height();
    	// 展现模板拼接的数据
    	var defaultHeight = 200;
    	var searchDivMaxHeight = defaultHeight;
//    	if($queryDataArea.height()>defaultHeight){
    		$queryDataArea.css('height',defaultHeight)
//    	}
    	// 判断是否有“更多数据”,5个像素是测试时，发现上下偏移5个像素才能显示边框，具体原因需后面跟踪
    	if("none" !=$("#"+objDiv.moreDataDiv).css('display')){
    		var heightOfMoreDataDiv = $("#"+objDiv.moreDataDiv).height();
    		searchDivMaxHeight = searchDivMaxHeight - heightOfMoreDataDiv - 5
    	}
    	var listLength = $("."+queryClass).length;
    	//判断是否有返回内容
    	if(listLength > 0){
    		openFastDataDiv(objDiv,searchDivMaxHeight);
    		$queryDataArea.show();
    		$queryDataArea.scrollTop(0);
    	}else{
    		closeFastDataDiv(objDiv.searchDiv);
    	}
	}
	
	/**
     * 关闭快速查询的数据DIV
     */
	function closeFastDataDiv(searchDiv){
    	// 收回div时重置currentIndex
		pageNo = 1;
		currentIndex = -1;
		cacheData = null;
    	var tmpSearchDiv = $("#"+searchDiv);
    	tmpSearchDiv.css("z-index",'');
    	var queryDataArea = tmpSearchDiv.children().eq(0);
    	queryDataArea.children().remove();
    	tmpSearchDiv.children().hide();
    	tmpSearchDiv.slideUp("fast");
    }
    
	/**
     * 显示快速查询的数据DIV
     */
	function openFastDataDiv(objDiv,searchDivMaxHeight){
    	var tepWidth = $("#"+objDiv.searchDiv).prev().innerWidth();
    	tepWidth = tepWidth-2;
    	$("#"+objDiv.moreDataDiv).css("width",tepWidth);
    	$("#"+objDiv.searchDiv).width(tepWidth+"px");
    	$("#"+objDiv.searchDiv).slideDown("fast");
    	//设置搜索框的高度
    	var dataArea = $('#'+objDiv.queryDataAreaDiv);
    	if(dataArea.height() > searchDivMaxHeight){
    		dataArea.css('height',searchDivMaxHeight+'px')
    	}
    }

	/**
	 * 获取下拉查询框的id
	 *  @isFavorite 区分给常用部门还是组织结构
	 * */
	function getQueryDataAreaId(isFavorite){
		var queryArea = "queryDataArea";//检索框中数据部分DIV的ID
	    if(isFavorite){
		    queryArea = "queryDataAreaOfFavorite";
	    }
	    return queryArea;
	}
	/**
	 * 添加搜索下拉框鼠标事件，键盘上下事件
	 * @isFavorite 区分给常用部门还是组织结构绑定键盘事件
	 */
	function keyboardEvent(isFavorite){
		var searchDiv = "searchDiv";//检索框DIV的ID
		var queryArea =getQueryDataAreaId(isFavorite);//检索框中数据部分DIV的ID
		var keyword = "keyword";//检索INPUT框的ID
		var dept_query = chooseType==="org"?prefixOfDeptQuery:prefixOfUserQuery;//检索框<a>标签的class 值为dept_query
	    var queryDeptIdHidden = "queryDeptId";// 把搜索框的部门id保存在检索框的隐藏域中，主要用于失去选择后，再次通过放大镜按钮定位部门
	    if(isFavorite){
		    searchDiv = "searchDivOfFavorite";
		    keyword = "keyword_favorite";
		    dept_query = chooseType==="org"?prefixOfDeptQueryFavorite:prefixOfUserQuery;//dept_query_favorite
	        queryDeptIdHidden = "queryDeptIdOfFavorite";
	    }
	    var content = $("#" + queryArea);
	    var $keyword = $("#" + keyword);

	    var className = chooseType==='org'?".dept_query":".user_query";
    	var currentClassName ="current_select";
    	var myPageX,myPageY;
	    $("#"+queryArea).on("mouseover.choose",function(e){
	    	if(myPageX==e.pageX&&myPageY==e.pageY){
    			//鼠标没动，不处理
    			return;
    		}
    		//进入时记录光标位置
	    	myPageX = e.pageX;
    		myPageY= e.pageY;
    		var $currObj =$(e.target).closest("a");
			$(className).removeClass(currentClassName);//先清除样式 避免跟键盘冲突
			$currObj.addClass(currentClassName);
			currentIndex = -1;
	    }).on("mouseout.choose",function(e){
	    	if(myPageX==e.pageX&&myPageY==e.pageY){
    			//鼠标没动，不处理
    			return;
    		}
	    	$(className).removeClass(currentClassName);//先清除样式 避免跟键盘冲突
	    });
		$("#"+queryArea).
			on('click','.'+dept_query,function(e){
				var $currObj = $(this);
				var queryDataArea = $("#"+queryArea);
				currentIndex= queryDataArea.children().index($(e.target).closest("a")) ;
				 if($currObj.attr("orgreadonly") !== "true"){
					if(currentIndex!==-1 &&cacheData&&cacheData.length>0){
	        		    var record = getSelectValue();
	        		   //如果是组织结构的检索框，则往组织结构的检索框中设值
	        		    var userOrDeptId = record.id;
        			    $("#"+queryDeptIdHidden).attr("value",userOrDeptId);
						cui('#' + keyword).setValue(record.name);
						locationInTree(userOrDeptId);
						clearTimeout(tempSelectFunc);
						tempSelectFunc = setTimeout(function(){
			   		  		closeFastDataDiv(searchDiv);
			   		  	},100);
	        		}
				}else{
					cui("#"+keyword).focus();
				}
				 return false;
			});

	    $keyword.find("input").off().on("keydown.choose", function (event) {//为什么用keydown？因为按着不动可以无限滚动
	        var keyCode = event.keyCode;
	        if (keyCode === 38) {//up
	        	
	        	var queryDataArea =$("#"+queryArea),
	        	 len = queryDataArea.children().length,queryList,hoverIndex;
	        	if(len){
	        		queryList = queryDataArea.children();//find(className);
	        		hoverIndex = currentIndex;
	        		if(hoverIndex===-1){
	        			hoverIndex = len-1;
	        			queryList.removeClass(currentClassName);
	        			queryList.eq(hoverIndex).addClass(currentClassName);
	        		}else{
	        			//移除前一条高亮
	        			queryList.eq(hoverIndex || 0).removeClass(currentClassName);
	                    //实现循环
	                    if (--hoverIndex === -1) {
	                        hoverIndex = len - 1;
	                    }
	                    queryList.eq(hoverIndex).addClass(currentClassName);
	        		}
	        		currentIndex = hoverIndex;
	        		scrollHoverPosition(queryDataArea,hoverIndex);
	        	}
	        } else if (keyCode === 40) {//down
	        	var queryDataArea =$("#"+queryArea),
	        	 len = queryDataArea.children().length,queryList,hoverIndex;
	            if (len) {
	            	queryList =queryDataArea.children();//find(className);
	                hoverIndex = currentIndex;
	                if (hoverIndex === -1) {
	                    //刚展开状态
	                    hoverIndex = 0;
	                    queryList.removeClass(currentClassName);
	                    queryList.eq(hoverIndex).addClass(currentClassName);
	                } else {
	                    //移除前一条高亮
	                	queryList.eq(hoverIndex || 0).removeClass(currentClassName);
	                    //实现循环
	                    if (len === ++hoverIndex) {
	                        hoverIndex = 0;
	                    }
	                    queryList.eq(hoverIndex).addClass(currentClassName);
	                }
	                currentIndex = hoverIndex;
	                scrollHoverPosition(queryDataArea,hoverIndex);
	            }
	        } else if(event.keyCode==13){//监听回车键
		        	// 获得回车时选中的a标签
		        	var tmpIndex = currentIndex==-1?0:currentIndex;
		        	var choosedA = $("."+dept_query).eq(tmpIndex).eq(0);
		        	if(choosedA.attr("orgreadonly") === "true"){
		        		choosedA.addClass("current_select");
		        		return false;
		        	}
	        		if(currentIndex!==-1&&cacheData&&cacheData.length>0){
	        		   var record = getSelectValue();
	        		   //如果是组织结构的检索框，则往组织结构的检索框中设值
	        		   var userOrDeptId = record.id;
        			   $("#"+queryDeptIdHidden).attr("value",userOrDeptId);
						cui('#' + keyword).setValue(record.name);
						$("#"+searchDiv).slideUp("fast");
						locationInTree(userOrDeptId);
	        		}
	        }
	    });

		$(document).on("mouseup",function(event){
			if($("#"+searchDiv).css("display")!=="none"){
				var queryDataArea=$("#" + searchDiv);
				if(queryDataArea.offset()){
					var pTop=queryDataArea.offset().top,
					pLeft = queryDataArea.offset().left,
					pHeight = queryDataArea.height(),
					pWidth = queryDataArea.width();
					if(event.clientX>pLeft+pWidth ||event.clientX<pLeft || event.clientY<pTop || event.clientY>pTop+pHeight+20){
//						$("#"+keyword).find("input").val('');
						closeFastDataDiv(searchDiv);
					}
				}
			}
	    });

		 /**
         * 滚动到焦点位置
         * @param {number} positionIndex
         * @private
         */
		function scrollHoverPosition (queryDataArea,positionIndex) {
            var currentClassName = ".current_select";
	      	var $box= queryDataArea,
	      	scrollTop = $box.scrollTop(),
	          $ele = $(currentClassName),
	          boxHeight = $box.height(),
	          lineHeight = $ele.outerHeight(),
	          offsetTop = $ele[0].offsetTop;
	  	    if (scrollTop > offsetTop) {
	  	    	$box.scrollTop(offsetTop);
	  	    } else if (scrollTop < offsetTop + lineHeight - boxHeight) {
	  	    	$box.scrollTop(offsetTop + lineHeight - boxHeight);
	  	    }
        }
		
		/**
		 * 从快速查询选中的行中获取对应的数据
		 * */
		function getSelectValue(){
			var record = cacheData[currentIndex];
			var data= {};
			data.id = record.key;
			data.name =record.title;
    		return data;
		}
	}
	
	/**
     * 显示更多数据时，滚动到上页的第一条 焦点位置
     * @param {boolean} isFavorite
     * @param {number} positionIndex
     * @private
     */
	function scrollHoverPositionToBottom (isFavorite,positionIndex) {
		var id = getQueryDataAreaId(isFavorite);
		var $box= $("#"+id),
    	children = $box.children(),
    	size = children.length,
        $ele =children.eq(Math.min(size-1,positionIndex)),
        offsetTop = $ele[0].offsetTop;
    	$box.scrollTop(offsetTop);
    }
	
	/**
	 * 截取部门全名中的本部门名，用于部门快速搜索的提示框中显示
	 */
	function subDepartmentFullName(deptFullName,name){
		// 获得部门全名中最后一个"/"的位置
		var iEnd = deptFullName.lastIndexOf($.trim(name));
		// 返回截取后的部门
		if(iEnd > 0){
			return deptFullName.substring(0,iEnd);
		}else{
			return "";
		}
	}
	
	/**TODO:
	 * 在树中定位检索框的部门
	 * @param userOrDeptId 要查询的用户或组织id
	 */
	function locationInTree(userOrDeptId){
		// 定义变量，用于判断是否是点击放大镜进行定位
		var isMagnifier = false;
		// 组织结构树中定位
		if(typeof getTab!=="function"||getTab()){
			var queryVo ={};
			if(userOrDeptId == undefined){
				isMagnifier = true;
				userOrDeptId = $("#queryDeptId").attr("value");
			}
			if(chooseType==='org'){//查询部门
				queryVo = $.extend({},{"orgId":userOrDeptId});
			}else{//查询用户
				levelFilter =999;
				queryVo = $.extend({},{"userId":userOrDeptId});
			}
			// 先尝试在树上得检索的部门
			var fastQueryNode = cui("#tree").getNode(userOrDeptId);
			// 如果树上没有加载要激活的节点，则先通过ajax查询该节点的所有上级节点id
			if(!fastQueryNode){
				var superDeptNode;
				var rootOrgId = "-1";
				//考虑到有默认组织这种情况，直接取树根，避免出现rootId未加载，而中间节点加载导致的报错
				rootOrgId = cui('#tree').getRoot().firstChild().getData().parentId;

				queryVo = $.extend({},queryVo, {"rootDepartmentId":rootOrgId,"levelFilter":levelFilter,"chooseType":chooseType});
				dwr.TOPEngine.setAsync(false);
				ChooseAction.getAllSuperOrgsByOrgId(queryVo,function(data){
					// 倒着查，先把最上级部门取出
			   		for(var i=data.length-1; i>=0; i--){
			   			superDeptNode = cui("#tree").getNode(data[i].key);
			   			// 如果部门树上还是没加载该节点，则调用懒加载方法先把父节点下的直接子节点全部加载
			   			if(!superDeptNode&&i+1<data.length){
							lazyData(cui("#tree").getNode(data[i+1].key));
			   			}
			   			//如果最上层的节点都没有加载，则break;
			   			if(!superDeptNode&&i+1==data.length){
			   				break;
			   			}
			   		}
			   		if(data.length>0&&chooseType==="user"){
			   			lazyData(cui("#tree").getNode(data[0].key));
			   		}
			   		//再次获得要激活节点
				    fastQueryNode = cui("#tree").getNode(userOrDeptId);
				});
				dwr.TOPEngine.setAsync(true);
			}
			// 激活节点，即让该节点在树中被选中，并且把该节点添加到已选框中
			if(fastQueryNode!=null){
				fastQueryNode.activate(true);
				// 节点获取焦点
				fastQueryNode.focus();
			}
		}else{
			// 如果是点放大镜按钮定位，则从搜索框的隐藏域获取id
			if(userOrDeptId == undefined){
				isMagnifier = true;
				userOrDeptId = $("#queryDeptIdOfFavorite").attr("value");
			}
			// 在常用部门树中定位
			clearFavoriteTreeSelected();
			//特殊字符处理
			var userOrDeptId2 =escapeJquery(userOrDeptId);
			var $NowSelectedLi = $(".favoriteTree").find("li[objectid="+userOrDeptId2+"]");
			if($NowSelectedLi.length==0){
				return;
			}
			// 把搜索框中选中的部门赋给常用部门当前选中部门
			var targetSelectedId = $NowSelectedLi.attr("id");
			$NowSelectedLi = $NowSelectedLi.eq(0);
			clearGroupBackGround();
			$NowSelectedLi.parent().show();
			var $favoriteTree =$("#div_tree_favorite"); 
			var treeHeight =$favoriteTree.height();
			//如果需要展示的节点在滚动条之外
			$favoriteTree.scrollTop(0);
			if($NowSelectedLi.offset().top>treeHeight){
				$favoriteTree.scrollTop($NowSelectedLi.offset().top-(treeHeight/2));
			}
			// 给选中部门对象赋值,用于切换节点时判断是否有已选择节点
			objDept = $NowSelectedLi.children()[0];
			// 在常用部门树中改变选中节点的样式
			$NowSelectedLi.toggleClass("favoriteDeptOrUserChoose");
			// 展现小xx
			$NowSelectedLi.find("span").toggleClass("display_block")
			// li标签获得不到焦点，a标签可以获得焦点
			//$("#a_"+userOrDeptId).focus();
		}
		// 不是点击放大镜定位，且是多选的情况，才添加
		if(isMagnifier === false && $("#choose_page_right").css("display")!=="none"){
			// 在树中定位后，把该节点添加到已选框
			addData(true);
		}
	}
	
	/**
	 * 特殊字符转义
	 * */
	function escapeJquery(srcString) {
	    // 转义之后的结果
	    var escapseResult = srcString;
	    // javascript正则表达式中的特殊字符
	    var jsSpecialChars = ["\\", "^", "$", "*", "?", ".", "+", "(", ")", "[",
	            "]", "|", "{", "}"];
	    // jquery中的特殊字符,不是正则表达式中的特殊字符
	    var jquerySpecialChars = ["~", "`", "@", "#", "%", "&", "=", "'", "\"",
	            ":", ";", "<", ">", ",", "/"];
	    for (var i = 0; i < jsSpecialChars.length; i++) {
	        escapseResult = escapseResult.replace(new RegExp("\\"
	                                + jsSpecialChars[i], "g"), "\\"
	                        + jsSpecialChars[i]);
	    }
	    for (var i = 0; i < jquerySpecialChars.length; i++) {
	        escapseResult = escapseResult.replace(new RegExp(jquerySpecialChars[i],
	                        "g"), "\\" + jquerySpecialChars[i]);
	    }
	    return escapseResult;
	}
	
	//取消拖选
	function cacelSelect(){
		return false;
	}
	var preSelect = "";
	//已选框事件绑定，将事件抽取出来，提高渲染效率
	function selectedClick(){
		if(document.all){
			//ie下，禁用鼠标拖选
			var $divSelect = $("#div_selected");
			var $divSelectFavorite =$("#div_selected_favorite");
			if($divSelect.length>0){
				$divSelect[0].onselectstart = cacelSelect;
			}
			if($divSelectFavorite.length>0){
				$divSelectFavorite[0].onselectstart = cacelSelect;
			}
		}
		$(".choose_page_right_bottom").on('click', function(event){
			var tar = $(event.target),
			$obj = tar.closest(".block_stand");
			if($obj&&$obj.length==0){
				$obj = tar.closest(".block_stand_other");
			}
			var selectId =  $obj.attr("id"),
			//往已选数组中添加当前点击对象的ID
			thisID ,
			shiftFlag = event.shiftKey;

			if(selectId){
				thisID = selectId.substring(4);
				//删除图标点击事件
				if (tar.prop("tagName") === "A") {
					$obj.remove();
					renderSelectedCount();
					return;
				}
				//无ctrl和shift时
				if($obj.hasClass("selectedDiv")){
					$obj.removeClass("selectedDiv");
					preSelect = null;
				}else if(!shiftFlag){//ctrl
					//如果选中对象已经存在于已选数组中，则说明已经被选，就反选，去掉样式，从数组中移除
					if($obj.hasClass("selectedDiv")){
						$obj.removeClass("selectedDiv")
					}else{//如果不在已选数组中，就被选中，添加样式，将值push到数组中
						$obj.addClass("selectedDiv")
					}
					preSelect = $obj;
				}else if(shiftFlag){//shift
					//首先清空已选数组
					clearAllSelectedInBox();
					var $selected = $(".choose_page_right_bottom").children();
					if(!preSelect){
						preSelect = $obj;
					}
					var selectedFlag = false;
					for(var i=0;i<$selected.length;i++){
						var thisDIV = $selected.eq(i),
						divID = thisDIV.attr("id"),
						deptId = divID.substring(4);
						//开始和结束不是同一个div
						if(preSelect.attr("id") !=  $obj.attr("id") ){
							//先找到shift后的开始点
							if( !selectedFlag && (divID == preSelect.attr("id") ||divID == $obj.attr("id"))){
								selectedFlag = true;
								continue;
							}
							//在找到结束点
							else if(selectedFlag && (divID == preSelect.attr("id") || divID == $obj.attr("id"))){
								selectedFlag = false;
								continue;
							}
							//开始点和结束点之间的记录标色，保存。
							if(selectedFlag){
								thisDIV.addClass("selectedDiv")
							}
						}
					}
					//将第一个选中和最后一个选中添加到已选ID数组
					if(preSelect.attr("id") !=  $obj.attr("id")){
						//只添加一次
						preSelect.addClass("selectedDiv")
					}
					$obj.addClass("selectedDiv")
				}else{//同时按下ctrl和shift
					//什么都不做
				}
			}else{
				clearAllSelectedInBox();
			}
			
		}).on('mouseover',function(event){
			var $obj = $(event.target).closest(".block_stand");
			if($obj&&$obj.length==0){
				$obj = $(event.target).closest(".block_stand_other");
			}
			$obj.addClass("slideDIV");
			$obj.find("a").addClass("display_block");

		}).on('mouseout',function(event){
			var $obj = $(event.target).closest(".block_stand");
			if($obj&&$obj.length==0){
				$obj = $(event.target).closest(".block_stand_other");
			}
			$obj.removeClass("slideDIV");
			$obj.find("a").removeClass("display_block");
		});
	}
	
	//右侧已选框数据上移
	function arrowUp(){
		moveSelected(1);
	}
	//右侧已选框数据下移
	function arrowDown(){
		moveSelected(2);
	}
	
	/**
	 * 上下移动 
	 * @param up 上下移动标识：1 上移，2下移
	 * */
	function moveSelected(up){
		var allSelected = getAllSelectedInBox();
		//选择一条数据是才上移下移
		if(allSelected&&allSelected.length==1){
			var selectDIV = allSelected.eq(0);
			if(up==1){ //上移
				//如果上面还有元素，就上移
				if(selectDIV.prev()){
					selectDIV.prev().before(selectDIV);//将选中对象插入到前一个对象之前
					scorllReSize(selectDIV);
				}
			}else if(up==2){//下移
				//如果下面还有元素，就下移
				if(selectDIV.next()){
					selectDIV.next().after(selectDIV);
					scorllReSize(selectDIV);
				}
			}
		}
	}
	/**
	 * 获取右边已选框中选中的所有记录
	 * */
	function getAllSelectedInBox(){
		var container = getSelectedBox();
		return container.children(".selectedDiv");
	}
	
	/**将右边已选框中所有选中的记录 去除选中状态
	 * */
	function clearAllSelectedInBox(){
		var allSelected =  getAllSelectedInBox();
		if(allSelected&&allSelected.length){
			for(var i=0;i<allSelected.length;i++){
				allSelected.eq(i).removeClass("selectedDiv");
			}
		}
	}
	/**
	 * 已选Div的位置调整
	 */
	function scorllReSize(selectDIV) {
	    var divheight = selectDIV.height(),
	    divTop = selectDIV.position().top;
	    var $DivSelected = getSelectedBox();
	    //所选DIV在下方被隐藏
	    if ((divTop + divheight - $DivSelected.height()) > 0 ) {
	    	var v_scrollTop =$DivSelected.scrollTop() + divheight;
	        $DivSelected.scrollTop(v_scrollTop);
	        divTop = selectDIV.position().top;
	    }else if(divTop<0){
	    //所选DIV在上方被隐藏
	    	var v_scrollTop =$DivSelected.scrollTop() - divheight;
		 	$DivSelected.scrollTop(v_scrollTop);
		 	divTop = selectDIV.position().top;
	    }
	    //调整后还没有显示，直接显示到最上面
	    if(divTop<0 || (divTop + divheight - $DivSelected.height()) > 0){
	    	$DivSelected.scrollTop($DivSelected.scrollTop()+divTop);
	    }
	}
	
	/**
	 * 获取右边已选框对象
	 * 
	 * */
	function getSelectedBox(){
		var $DivSelected;
		// 通过tab页判断把部门加到哪个已选框中：0表示"组织结构" 1表示"常用部门"
		if (getTab()) {
			//addFavorite页面或者是ChoosePage页面的组织结构页面
	        $DivSelected = $("#div_selected");
	    } else {
	        $DivSelected = $("#div_selected_favorite");
	    }
		return $DivSelected;
	}
	/**
	 * 计算已选部门数量
	 * @param pageType 1:组织、人员选择选择页面 2：常用组织、联系人选择页面
	 */
	function renderSelectedCount(){
		var selectedContainer =getSelectedBox();
		var selected = selectedContainer.children();
		var isTreePage = getTab(); 
		if(chooseType==="org"){
			//已选组织： 个
			if(isTreePage){
				$("#selectCountDiv").text("\u5df2\u9009\u7ec4\u7ec7\uff1a"+selected.length+" \u4e2a");
			}else{
				$("#selectCountFavoriteDiv").text("\u5df2\u9009\u7ec4\u7ec7\uff1a"+selected.length+" \u4e2a");
			}
		}else{
			//已选人员：
			if(isTreePage){
				$("#selectCountDiv").text("\u5df2\u9009\u4eba\u5458\uff1a"+selected.length+" \u4e2a");
			}else{
				$("#selectCountFavoriteDiv").text("\u5df2\u9009\u4eba\u5458\uff1a"+selected.length+" \u4e2a");
			}
		}
	}