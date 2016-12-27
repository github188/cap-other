/**
 * ��;����Ա��֯��ǩ����js
 *
 */
/**
 * ����ѡ���ò��ŵ�ʱ��ȷ��rootId
 * */
function getRootId(vRootId,vOrgStructureId){
	if(vRootId!=''){
		dwr.TOPEngine.setAsync(false);
		var nodeVo = {};
		nodeVo.orgId = vRootId;
		nodeVo.orgStructureId = vOrgStructureId;
		ChooseAction.getRootId(nodeVo,function(data){
			vRootId = data;
		});
		dwr.TOPEngine.setAsync(true);		
	}
	return vRootId;
}
	 /*** �����ϼ����ź�Ĭ�ϲ��ŷ���start**/
	/**
	 * �Ƿ���ʾ�����ϼ���֯��ť
	 * @return ������Ĭ����֯��Ӧ����֯�ṹid
	 * */
	function showHigherUpOrNot(){
		var showOrNot = false;
		//���ָ����defaultOrgId���ԣ��������ʾ����
		if(defaultOrgId){
			//��֯�ṹId
			var orgStructureId = cui('#orgStructure').getValue();
			var rootDeptId = "-1";
			if(rootId){
				rootDeptId=rootId;
			}
			if(chooseType==="user"){
				levelFilter = 999;
			}
			var condition = {"rootDepartmentId":rootDeptId,"orgId":defaultOrgId,"levelFilter":levelFilter,"orgStructureId":orgStructureId};
			dwr.TOPEngine.setAsync(false);
			ChooseAction.isChildrenOrg(condition,function(isChildren){
				if(isChildren){
					$('#higherUpOrg').show();
					showOrNot =  true;
					$('#backDefaultOrg').hide()
				}else{
					$('#higherUpOrg').hide();
					$('#backDefaultOrg').hide();
				}
				
			});
			dwr.TOPEngine.setAsync(true);
		}
		return showOrNot;
	}
	
	//�����ϼ�����
	function higherUpOrg(){
    	    //��ȡˢ��ǰ�ĸ��ڵ㸸�ڵ�id
		    var tmpParentId=cui('#tree').getRoot().firstChild().getData().parentId;
			initRoot(tmpParentId);
			 //��ȡˢ�º�ĸ��ڵ㸸�ڵ�id
		    var tmpParentIdRefreshLater=cui('#tree').getRoot().firstChild().getData().parentId;
		    var tmpRootId = cui('#tree').getRoot().firstChild().getData().key;
			if(tmpRootId==rootId||tmpParentIdRefreshLater=='-1'){
				$('#higherUpOrg').hide();
				$('#backDefaultOrg').show()
				$('#choose_page_left_bottom').attr("class","choose_page_left_bottom_higherUpOrg");
			}
      	}
	

	 //����Ĭ�ϲ���
	function backDefaultOrg(){
			initRoot(defaultOrgId);
		    $('#higherUpOrg').show();
			$('#backDefaultOrg').hide();
			$('#choose_page_left_bottom').attr("class","choose_page_left_bottom_higherUpOrg");
	 }
	
	/*** �����ϼ����ź�Ĭ�ϲ��ŷ���end**/
	
	/**
	 * ����չʾ����JS
	 * **/
	
	//ת���ڵ㼯��
	function handleNodeList(lst){
		for(var i=0;i<lst.length;++i){
			var vo = lst[i];
			handleNodeData(vo);
		}
	}
	
	//ת���ڵ�
	function handleNodeData(data){
		data.isLazy = data.isLazy=='true'?true:false;
		if(data.isFolder=='true'){//��֯�ڵ�
			data.isFolder=true;
			if(chooseType==="org"&&data.unselectable){
				data.icon='./images/folder_close_readonly.gif';
			}else{
				data.icon='./images/folder_close.gif';
				if(chooseType==="user"&&data.unselectable){
					data.hideCheckbox=true;
				}
			}
		}else{//�û��ڵ�
			data.isFolder=false;
			if(data.sex==2){//Ů
				data.icon='./images/girl.gif';
			}else{//��
				data.icon='./images/boy.gif';
			}
		}
	}
	//�����¼��ڵ�
	function lazyData(node){
		if(chooseType==="org"&&node.getData('unselectable')){
			node.setData('icon','./images/folder_open_readonly.gif');
		}else{
			node.setData('icon','./images/folder_open.gif');
		}
		if(chooseType=='user'){//��Ա
			ChooseAction.queryChildOrgAndUser(node.getData().key,userType,function(data){
				handleNodeList(data);
				node.addChild(data);
			});
		}else{
			ChooseAction.queryChildOrg(node.getData().key,levelFilter,unselectableCode,function(data){
				handleNodeList(data);
				node.addChild(data);
			});
		}
	}
	
	//���ڵ�չ�����𴥷�
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
	ѡ�нڵ�ʱ�ص�
	@param node ѡ�еĽڵ�
	*/
	function selectNode(node){
		if(chooseType==="user"&&node.getData().isFolder){
			return;
		}
		node.toggleSelect();
	}
	
	/**
	 * �Ƶ���ѡ��¼��
	 * @returns true ��ӳɹ�����Ҫ�����ߵ�ѡ�б�־,false ���ʧ�ܣ�����Ҫ�����ߵ�ѡ�б�־
	 */
	function putToSelectedBox(obj){ 
		var container= getSelectedBox();
		//ID�滻ʮ���������ļ����š���Ϊԭ����ӦΪ<>��������ʾ����20160427
		obj.id = obj.id.replace("\u300a","<").replace("\u300b",">");
		var exist = container.has("[id=div_"+escapeJquery(obj.id)+"]");
		if(exist&&exist.length){
			//����Ѿ���ӣ���ֱ�ӷ���
			return true;
		}
		var len = container.children().length;
		if(chooseMode>1&&len==chooseMode){
			//���ѡ��  ����Ա
			if(chooseType=='user'){
				cui.alert('\u6700\u591A\u9009\u62E9'+chooseMode+'\u4e2a\u4eba\u5458');
			} else{ //���ѡ�� ����֯
				cui.alert('\u6700\u591A\u9009\u62E9'+chooseMode+'\u4e2a\u7ec4\u7ec7');
			}
			return false;
		}
		var objDiv = $('<div>').attr('title',obj.fullName).attr('id','div_'+obj.id)
					.attr('orgCode',obj.orgCode).append($('<span>').html(obj.name))
					.append($('<a>').attr('href','#').attr('class','block_delete').click(function(){
							$(this).parent().remove();
							renderSelectedCount();
							return false;
					}));
		if(obj.isOther){
			objDiv.attr('class','block_stand_other');
		}else{
			objDiv.attr('class','block_stand');
		}
		container.append(objDiv);
		renderSelectedCount();
		return true;
	}

	/**
	 * ��ȡ�����tabҳ���������֯�ṹtabҳ����û��tab��addFavoriteҳ���򷵻�true������ǳ��ò���tabҳ���򷵻�false
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
	 * ��tabҳ�¼�
	 */
	function changeTab(){
		// �л�tabҳ�¼�
		cui("#tab").bind("switch",function(event,data){
			pageNo = 1;
			if(data.fromTab == 0 && data.toTab == 1){
				// ��"��֯�ṹ"�л���"���ò���"
				// �����û���س�����ϵ�����ݣ������
				if(isOnloadFavoriteData == false){
					initFavoriteDept();
				}
				$("#div_selected_favorite").append($("#div_selected div:nth-child(n-1)"));
				$("#div_selected div:nth-child(n-1)").remove();
			}else if(data.fromTab == 1 && data.toTab == 0){
				clearFavoriteTreeSelected();
				// ��"���ò���"�л���"��֯�ṹ"
				$("#div_selected").append($("#div_selected_favorite div:nth-child(n-1)"));
				$("#div_selected_favorite div:nth-child(n-1)").remove();
			}
			renderSelectedCount();
		});
	}
	
	/**
	 * ��ѡ��tabҳ�¼� 
	 * */
	function repaint(){
		// �л�tabҳ�¼�
		cui("#tab").bind("switch",function(event,data){
			if(data.fromTab == 0 && data.toTab == 1){
				$("#favorite").parent().addClass("repaint");
			}else if(data.fromTab == 1 && data.toTab == 0){
				$("#choose_page_box").parent().addClass("repaint");
			}
		});
	}
	
	//�ж��Ƿ��Ѿ���ѡ��
	function isSelected(id){
		var selectedContainer =getSelectedBox();
		var exist = selectedContainer.has("[id=div_"+escapeJquery(id)+"]");
		if(exist&&exist.length){
			return true;
		}
		return false;
	}
	/**ɾ���ұ�ѡ������Ѿ�ѡ��Ľڵ�
	*/
	function deleteSelectedData(){
		var container = getSelectedBox();
		//��ȡ����ѡ�еĽڵ�
		var $SelectData  = container.children(".selectedDiv");
		if($SelectData.length==0){
			return ;
		}
		
		$SelectData.remove();
		renderSelectedCount();
	}
	
	//��������ťʱ �����ѡ��¼
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
	���һ���ڵ�
	@return �������ټ������ʱ����false ���򷵻�true
	*/
	function addOneNode(node){
		if(node&&node.dNode){
			var data = node.getData();
			if(chooseType=='user'&&data.isFolder){//ѡ����Աʱ��������֯�ڵ�
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
	
	//����ӽڵ�
	function addDataChild(){
		//�����ǰ��ڵ�����֯�ṹ
		var node = cui('#tree').getActiveNode();
		if(node!=null&&node.dNode){
			var data = node.getData();
			if(chooseType=='user'&&data.isFolder){//ѡ��֯��ֱ���û�
				ChooseAction.queryChildUser(data.key,userType,function(lst){
					var flag ;
					for(var i=0;i<lst.length;++i){
						flag = addDataToSelected(lst[i]);
						if(!flag){
							break;
						}
					}
				});
			}else if(chooseType=='org'){//ѡ��֯���¼���֯
				ChooseAction.queryChildOrg(data.key,levelFilter,unselectableCode,function(lst){
					var flag ;
					for(var i=0;i<lst.length;++i){
						flag = addDataToSelected(lst[i]);
						if(!flag){
							break;
						}
					}
				});
			}
			node.select(false);
		}			
	}
	
	//˫�����ڵ�
	function dbclickNode(node){
		var data = node.getData();
		if(chooseType==="org"&&data.unselectable){
			return;
		}
		if(chooseMode==1){//��ѡʱֱ���ύ���رմ���
			if(chooseType=='user'&&data.isFolder){
				//ѡ����Աʱ��˫����֯�ڵ�
				return;
			}else{
				submitSelected(data.key);
			}
		}else{//��ѡʱ��ӵ��ұ���ѡ��
			if(chooseType=='user'&&data.isFolder){//ѡ����Աʱ��˫����֯�ڵ�
				ChooseAction.queryChildUser(data.key,userType,function(lst){
					var flag;
					for(var i=0;i<lst.length;i++){
						flag = addDataToSelected(lst[i]);
						if(!flag){
							break;
						}
					}
				});	
			}else{
				addDataToSelected(data);
			}
		}
	}
	
	//������ݵ���ѡ��¼
	function addDataToSelected(data){
		if(chooseType==="org"&&data.unselectable){
			return true;
		}
		var obj = {};
		obj.id = data.key;
		obj.name = data.title;
		obj.fullName=data.fullName;
		return	putToSelectedBox(obj);
	}
	
	/**���ѡ�еĽڵ���¼
	   ���ڽ������ѡ������ڵ������ϵ��/��֯�ڵ㣬��ӵ��ұ���ѡ��ȥ
	**/
	function addData(isQuery){
		//�����ǰ��ڵ�����֯�ṹ
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
	 * ����չʾ����JS END
	 * **/
	
	
	var tempFunc;
	var tempNoDataFunc,tempSelectFunc;
	// ȫ�ֱ��������ڱ���������������б��У��������ĸ�����id
	var rootDeptTabId;
	// ������<a>��ǩ��idǰ׺���������Ĳ��ű�ǩ��ʽΪ��<a><span></span><span></span></a>
	var prefixOfQueryA = "a_query_";
	// ������<a>��ǩ��class����֯�ṹ
	var prefixOfDeptQuery = "dept_query";
	// ������<a>��ǩ��class�����ò���
	var prefixOfDeptQueryFavorite = "dept_query";
	//��Ա������<a>��ǩ��class 
	var prefixOfUserQuery = "user_query";
	
	//���ٲ�ѯ�����ָ�����ʽ 
	var lineClassName="cutoff_line";
	
	var cacheData;//���ٲ�ѯ�������
	var currentIndex =-1;
	
	/**
	 * �Ƿ�Ϊ��Ч����
	 */
	function isValidKeyCodeForQueryData(keyCode){
		//�س�Ҫ�ų������򵯳����ڻ���ʾ����
		if(keyCode === 13 || keyCode === 37 || keyCode === 38
			|| keyCode === 39 || keyCode === 40){
			return false;
		}
		return true;
	}

	/**
	 * �����������ѯ
	 */
	function queryData(event){

		//�жϼ����¼����������¼����س���
		if(typeof event == "undefined" || isValidKeyCodeForQueryData(event.keyCode)){
			clearTimeout(tempFunc);
			clearTimeout(tempNoDataFunc);
			pageNo = 1;
			tempFunc = setTimeout(function(){_queryData("replace")},300);
		}
	}

	/**
	 * @param type add||replace
	 * @param orgStructureId ��֯�ṹid ������ʱ��������ȡ ����ӳ�����ϵ��/��֯ҳ��ᴫ��
	 * @param rootId ���ڵ�id ������ʱ�������ڵ�ȡ ����ӳ�����ϵ��/��֯ҳ��ᴫ��
	 * **/
	function _queryData(type){
		if(!cui('#orgStructure').getValue()){
			return;
		}
		// ��ȡ��ѯ���ֶ�
		var queryStr =handleStr($.trim(cui('#keyword').getValue()));
		
		// ����ֶ�Ϊ�գ����û���ղ�ѯ�ֶκ�����div
		if(queryStr == ""){
			closeFastDataDiv("searchDiv");
//			$("#searchDiv").slideUp("fast");
			return;
		}else{
			// ����������ֵ����������ķ�Χ
			var vo = {};
			vo.keyword = queryStr;
			vo.orgStructureId = cui('#orgStructure').getValue();
			vo.rootDepartmentId = cui('#tree').getRoot().firstChild().getData().key;
			vo.pageNo = pageNo;
			vo.pageSize=pageSize;
			vo.chooseType = chooseType;
			_doQuery(vo,type);
		}
	}
	
	/**
	 * @param vo ��ѯ���� 
	 * **/
	function _doQuery(vo,type){
		if(chooseType=='user'){//��Ա
			vo.userType = userType;
			ChooseAction.fastQueryUserPagination(vo,function(data){
				_doQueryCallBack("user",type,data);
			});
		}else{
			vo.levelFilter = levelFilter;
			ChooseAction.fastQueryOrgPagination(vo,unselectableCode,function(data){
				_doQueryCallBack("org",type,data);
			});
		}
	}
	
	/**
	 * ���ٲ�ѯ������ ƴװ�����չʾ
	 * "org",operatorType,data
	 * @param type ��ʶ����֯��ǩ��ѯ�����û���ǩ��ѯ
	 * @param operatorType ��ʶ���²�ѯ�����ǵ����������
	 * @param data ��ѯ���صĽ��
	 * **/
	function _doQueryCallBack(type,operatorType,data){

		var objDiv ={};
		objDiv.searchDiv = "searchDiv";
		objDiv.queryDataAreaDiv = "queryDataArea";
		objDiv.moreDataDiv = "moreData";
		if(data.count==0){
			cacheData = null;
   		   	$("#moreData").css('display','none');
   		   	$('#queryDataArea').height(0);
   		   	var nodataHtml = "";
   		   	if(type==="org"){
	   		   	//δ�鵽����֯\u672a\u67e5\u5230\u8be5\u7ec4\u7ec7
   		   		nodataHtml='<span class="no_data" >&nbsp;\u672a\u67e5\u5230\u8be5\u7ec4\u7ec7</span>';
   		   	}else if(type==="user"){
   		   		//δ�鵽����Ա
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
        	len =children.length ;
   			if(operatorType==="replace"){
   				currentIndex = -1;
   				cacheData = data.list;
   			}else{
   				if(!cacheData){
   					cacheData = [];
   				}
   				$.each(data.list,function(){
   					cacheData.push(this);
   				});
   			}
   			//Ȼ������ƴװ��DIV��
			installData(objDiv,data,operatorType);
			
			var prefixOfQuery="";
			if(type==="org"){
				prefixOfQuery=prefixOfDeptQuery;
			}else if(type==="user"){
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
//	    $('#choose_page_left_bottom').attr("class","choose_page_left_bottom");
	
	}
	/**
	 * չʾ��������
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
	 * ��ȡ����������ģ��;
	 */
	function getMenuItemTemplate(obj,i) {
		// ��ò��ŵ��ϼ�����ȫ��
		var subDeptFullName = subDepartmentFullName(obj.fullName,obj.title);
		// �����ϵͳ�����ţ�������fullname��û���ϼ����ţ�����õ�����ʾ
		if(subDeptFullName == ""){
			// ���ģ���е�<a>��ǩid�����ڸı���ʽ����˫�е���ʽ��Ϊ����
			rootDeptTabId = prefixOfQueryA + obj.key;
			// ��������ģ��
			var bufferSingle = [
		       		"<a href='#' class='",
		       		obj.className,"' id='",prefixOfQueryA,obj.key,"'","orgreadonly='",obj.unselectable, "'>",
			    		"<span class='", obj.firstClassName, "' title='",obj.title, "'>",obj.title,"</span>",
		    		"</a>"
			       	];
			return bufferSingle.join("");
		}else{
			// �Ǹ����������˫����ʾ
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
     * ��ȡ��Ա����������ģ��html����
     * @param data,��ѯ���������count,list
     * */
    function buildListItemTemplate(data){
    	var objDiv = "";
    	var tempCount = data.list.length;
    	var tmpData = data.list;
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
     * ��ȡ�û���ѯ�����ģ��
     **/
    function getUserMenuItemTemplate(data,i) {
    	//�����ͬ������Ա��ʹ�����е���ʽչ�֡�
    	if(data.hasSameName){
    		// ����û����ڲ��ŵ��ϼ�����ȫ��
    		var subDeptFullName = subDepartmentFullName(data.fullName,data.orgName);
    		var userClass= "";
    		if(data.hasCutoffLine){
    			userClass = "user_query user-same-name user-same-name-last"
    		}else{
    			userClass = "user_query user-same-name";
    		}
    		//�����ڸ�ÿ�������������¼�ʱ��Ҫ�õ�className�����Ը������user_query��class������ͬ������ԱҪ������һ����ʽչ�֣����Լ���style���ԣ�����user_query��ʽ��
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
     * ��ʾ����Ա������ͬ�����ݣ��������չ�ֲ�ͬ��Ч��
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
     * ��װ��������div����
     * @param divObj ���������divid 
     * @param data ����
     * @param operatorType �������
     */
	function installData(divObj,data,operatorType){
		var totalPage = Math.ceil(data.count/pageSize) ;
    	var objDiv = buildListItemTemplate(data);
    	
    	// �������֯�ṹtabҳ�ļ�����
    	if(operatorType=="add"){
    		$('#'+divObj.queryDataAreaDiv).append(objDiv);
    	}else if(operatorType=="replace"){
    		$('#'+divObj.queryDataAreaDiv).height(0);
    		$('#'+divObj.queryDataAreaDiv).html(objDiv);
    	}
    	// ����Ǹ����ţ�������ʾ
    	if(rootDeptTabId != ""&&chooseType==="org"){
    		$("#"+rootDeptTabId).css("height","20px");
    	}
    	//�����ѯ������������������ÿҳ��ʾ����������ʾ�������ݡ�
    	if(pageNo==totalPage){
    		$("#"+divObj.moreDataDiv).css('display','none');
    	}else{
    		$("#"+divObj.moreDataDiv).css('display','block');
    	}
    }
	
	/**
	 * ��������������չʾ�����ط���
	 * @param objDiv �õ���divid 
	 */
	function showOrDisplay(objDiv,queryClass){
		var tmpSearchDiv = $("#"+objDiv.searchDiv);
		var $queryDataArea = $('#'+objDiv.queryDataAreaDiv);
		// ������ģ��ƴ�ӵ����ݣ��������������document�Ŵ��ں�����show()
    	$queryDataArea.hide();
//    	var pageHeight = $(document).height();
    	// չ��ģ��ƴ�ӵ�����
    	var defaultHeight = 200;
    	var searchDivMaxHeight = defaultHeight;
//    	if($queryDataArea.height()>defaultHeight){
    		$queryDataArea.css('height',defaultHeight)
//    	}
    	// �ж��Ƿ��С��������ݡ�,5�������ǲ���ʱ����������ƫ��5�����ز�����ʾ�߿򣬾���ԭ����������
    	if("none" !=$("#"+objDiv.moreDataDiv).css('display')){
    		var heightOfMoreDataDiv = $("#"+objDiv.moreDataDiv).height();
    		searchDivMaxHeight = searchDivMaxHeight - heightOfMoreDataDiv - 5
    	}
    	var listLength = $("."+queryClass).length;
    	//�ж��Ƿ��з�������
    	if(listLength > 0){
    		openFastDataDiv(objDiv,searchDivMaxHeight);
    		$queryDataArea.show();
    		$queryDataArea.scrollTop(0);
    	}else{
    		closeFastDataDiv(objDiv.searchDiv);
    	}
	}
	
	/**
     * �رտ��ٲ�ѯ������DIV
     */
	function closeFastDataDiv(searchDiv){
    	// �ջ�divʱ����currentIndex
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
     * ��ʾ���ٲ�ѯ������DIV
     */
	function openFastDataDiv(objDiv,searchDivMaxHeight){
    	var tepWidth = $("#"+objDiv.searchDiv).prev().innerWidth();
    	tepWidth = tepWidth-2;
    	$("#"+objDiv.moreDataDiv).css("width",tepWidth);
    	$("#"+objDiv.searchDiv).width(tepWidth+"px");
    	$("#"+objDiv.searchDiv).slideDown("fast");
    	//����������ĸ߶�
    	var dataArea = $('#'+objDiv.queryDataAreaDiv);
    	if(dataArea.height() > searchDivMaxHeight){
    		dataArea.css('height',searchDivMaxHeight+'px')
    	}
    }

	/**
	 * ��ȡ������ѯ���id
	 *  @isFavorite ���ָ����ò��Ż�����֯�ṹ
	 * */
	function getQueryDataAreaId(isFavorite){
		var queryArea = "queryDataArea";//�����������ݲ���DIV��ID
	    if(isFavorite){
		    queryArea = "queryDataAreaOfFavorite";
	    }
	    return queryArea;
	}
	/**
	 * �����������������¼������������¼�
	 * @isFavorite ���ָ����ò��Ż�����֯�ṹ�󶨼����¼�
	 */
	function keyboardEvent(isFavorite){
		var searchDiv = "searchDiv";//������DIV��ID
		var queryArea =getQueryDataAreaId(isFavorite);//�����������ݲ���DIV��ID
		var keyword = "keyword";//����INPUT���ID
		var dept_query = chooseType==="org"?prefixOfDeptQuery:prefixOfUserQuery;//������<a>��ǩ��class ֵΪdept_query
	    var queryDeptIdHidden = "queryDeptId";// ��������Ĳ���id�����ڼ�������������У���Ҫ����ʧȥѡ����ٴ�ͨ���Ŵ󾵰�ť��λ����
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
    			//���û����������
    			return;
    		}
    		//����ʱ��¼���λ��
	    	myPageX = e.pageX;
    		myPageY= e.pageY;
    		var $currObj =$(e.target).closest("a");
			$(className).removeClass(currentClassName);//�������ʽ ��������̳�ͻ
			$currObj.addClass(currentClassName);
			currentIndex = -1;
	    }).on("mouseout.choose",function(e){
	    	if(myPageX==e.pageX&&myPageY==e.pageY){
    			//���û����������
    			return;
    		}
	    	$(className).removeClass(currentClassName);//�������ʽ ��������̳�ͻ
	    });
		$("#"+queryArea).
			on('click','.'+dept_query,function(e){
				var $currObj = $(this);
				var queryDataArea = $("#"+queryArea);
				currentIndex= queryDataArea.children().index($(e.target).closest("a")) ;
				 if($currObj.attr("orgreadonly") !== "true"){
					if(currentIndex!==-1 &&cacheData&&cacheData.length>0){
	        		    var record = getSelectValue();
	        		   //�������֯�ṹ�ļ�����������֯�ṹ�ļ���������ֵ
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

	    $keyword.find("input").off().on("keydown.choose", function (event) {//Ϊʲô��keydown����Ϊ���Ų����������޹���
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
	        			//�Ƴ�ǰһ������
	        			queryList.eq(hoverIndex || 0).removeClass(currentClassName);
	                    //ʵ��ѭ��
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
	                    //��չ��״̬
	                    hoverIndex = 0;
	                    queryList.removeClass(currentClassName);
	                    queryList.eq(hoverIndex).addClass(currentClassName);
	                } else {
	                    //�Ƴ�ǰһ������
	                	queryList.eq(hoverIndex || 0).removeClass(currentClassName);
	                    //ʵ��ѭ��
	                    if (len === ++hoverIndex) {
	                        hoverIndex = 0;
	                    }
	                    queryList.eq(hoverIndex).addClass(currentClassName);
	                }
	                currentIndex = hoverIndex;
	                scrollHoverPosition(queryDataArea,hoverIndex);
	            }
	        } else if(event.keyCode==13){//�����س���
		        	// ��ûس�ʱѡ�е�a��ǩ
		        	var tmpIndex = currentIndex==-1?0:currentIndex;
		        	var choosedA = $("."+dept_query).eq(tmpIndex).eq(0);
		        	if(choosedA.attr("orgreadonly") === "true"){
		        		choosedA.addClass("current_select");
		        		return false;
		        	}
	        		if(currentIndex!==-1&&cacheData&&cacheData.length>0){
	        		   var record = getSelectValue();
	        		   //�������֯�ṹ�ļ�����������֯�ṹ�ļ���������ֵ
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
         * ����������λ��
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
		 * �ӿ��ٲ�ѯѡ�е����л�ȡ��Ӧ������
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
     * ��ʾ��������ʱ����������ҳ�ĵ�һ�� ����λ��
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
	 * ��ȡ����ȫ���еı������������ڲ��ſ�����������ʾ������ʾ
	 */
	function subDepartmentFullName(deptFullName,name){
		// ��ò���ȫ�������һ��"/"��λ��
		var iEnd = deptFullName.lastIndexOf($.trim(name));
		// ���ؽ�ȡ��Ĳ���
		if(iEnd > 0){
			return deptFullName.substring(0,iEnd);
		}else{
			return "";
		}
	}
	
	/**
	 * �����ж�λ������Ĳ���
	 * @param userOrDeptId Ҫ��ѯ���û�����֯id
	 */
	function locationInTree(userOrDeptId){
		// ��������������ж��Ƿ��ǵ���Ŵ󾵽��ж�λ
		var isMagnifier = false;
		// ��֯�ṹ���ж�λ
		if(typeof getTab!=="function"||getTab()){
			var queryVo ={};
			if(userOrDeptId == undefined){
				isMagnifier = true;
				userOrDeptId = $("#queryDeptId").attr("value");
			}
			if(chooseType==='org'){//��ѯ����
				queryVo = $.extend({},{"orgId":userOrDeptId});
			}else{//��ѯ�û�
				levelFilter =999;
				queryVo = $.extend({},{"userId":userOrDeptId});
			}
			// �ȳ��������ϵü����Ĳ���
			var fastQueryNode = cui("#tree").getNode(userOrDeptId);
			// �������û�м���Ҫ����Ľڵ㣬����ͨ��ajax��ѯ�ýڵ�������ϼ��ڵ�id
			if(!fastQueryNode){
				var superDeptNode;
				var rootOrgId = "-1";
				//���ǵ���Ĭ����֯���������ֱ��ȡ�������������rootIdδ���أ����м�ڵ���ص��µı���
				rootOrgId = cui('#tree').getRoot().firstChild().getData().parentId;
				/*if(typeof defaultOrgId !=="undefined"&&defaultOrgId){
					rootOrgId=defaultOrgId;
				}else if(typeof rootId !=="undefined"&&rootId){
					rootOrgId = rootId;
				}*/ 
				queryVo = $.extend({},queryVo, {"rootDepartmentId":rootOrgId,"levelFilter":levelFilter,"chooseType":chooseType});
				dwr.TOPEngine.setAsync(false);
				ChooseAction.getAllSuperOrgsByOrgId(queryVo,function(data){
					// ���Ų飬�Ȱ����ϼ�����ȡ��
			   		for(var i=data.length-1; i>=0; i--){
			   			superDeptNode = cui("#tree").getNode(data[i].key);
			   			// ����������ϻ���û���ظýڵ㣬����������ط����ȰѸ��ڵ��µ�ֱ���ӽڵ�ȫ������
			   			if(!superDeptNode&&i+1<data.length){
							lazyData(cui("#tree").getNode(data[i+1].key));
			   			}
			   			//������ϲ�Ľڵ㶼û�м��أ���break;
			   			if(!superDeptNode&&i+1==data.length){
			   				break;
			   			}
			   		}
			   		if(data.length>0&&chooseType==="user"){
			   			lazyData(cui("#tree").getNode(data[0].key));
			   		}
			   		//�ٴλ��Ҫ����ڵ�
				    fastQueryNode = cui("#tree").getNode(userOrDeptId);
				});
				dwr.TOPEngine.setAsync(true);
			}
			// ����ڵ㣬���øýڵ������б�ѡ�У����ҰѸýڵ���ӵ���ѡ����
			if(fastQueryNode!=null){
				fastQueryNode.activate(true);
				// �ڵ��ȡ����
				fastQueryNode.focus();
			}
		}else{
			// ����ǵ�Ŵ󾵰�ť��λ�������������������ȡid
			if(userOrDeptId == undefined){
				isMagnifier = true;
				userOrDeptId = $("#queryDeptIdOfFavorite").attr("value");
			}
			// �ڳ��ò������ж�λ
			clearFavoriteTreeSelected();
			//�����ַ�����
			var userOrDeptId2 =escapeJquery(userOrDeptId);
			var $NowSelectedLi = $(".favoriteTree").find("li[objectid="+userOrDeptId2+"]");
			if($NowSelectedLi.length==0){
				return;
			}
			// ����������ѡ�еĲ��Ÿ������ò��ŵ�ǰѡ�в���
			var targetSelectedId = $NowSelectedLi.attr("id");
			$NowSelectedLi = $NowSelectedLi.eq(0);
			clearGroupBackGround();
			$NowSelectedLi.parent().show();
			var $favoriteTree =$("#div_tree_favorite"); 
			var treeHeight =$favoriteTree.height();
			//�����Ҫչʾ�Ľڵ��ڹ�����֮��
			$favoriteTree.scrollTop(0);
			if($NowSelectedLi.offset().top>treeHeight){
				$favoriteTree.scrollTop($NowSelectedLi.offset().top-(treeHeight/2));
			}
			// ��ѡ�в��Ŷ���ֵ,�����л��ڵ�ʱ�ж��Ƿ�����ѡ��ڵ�
			objDept = $NowSelectedLi.children()[0];
			// �ڳ��ò������иı�ѡ�нڵ����ʽ
			$NowSelectedLi.toggleClass("favoriteDeptOrUserChoose");
			// չ��Сxx
			$NowSelectedLi.find("span").toggleClass("display_block")
			// li��ǩ��ò������㣬a��ǩ���Ի�ý���
			//$("#a_"+userOrDeptId).focus();
		}
		// ���ǵ���Ŵ󾵶�λ�����Ƕ�ѡ������������
		if(isMagnifier === false && $("#choose_page_right").css("display")!=="none"){
			// �����ж�λ�󣬰Ѹýڵ���ӵ���ѡ��
			addData(true);
		}
	}
	
	/**
	 * �����ַ�ת��
	 * */
	function escapeJquery(srcString)
	{
	    // ת��֮��Ľ��
	    var escapseResult = srcString;
	    // javascript������ʽ�е������ַ�
	    var jsSpecialChars = ["\\", "^", "$", "*", "?", ".", "+", "(", ")", "[",
	            "]", "|", "{", "}"];
	    // jquery�е������ַ�,����������ʽ�е������ַ�
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
	
	//ȡ����ѡ
	function cacelSelect(){
		return false;
	}
	var preSelect = "";
	//��ѡ���¼��󶨣����¼���ȡ�����������ȾЧ��
	function selectedClick(){
		if(document.all){
			//ie�£����������ѡ
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
			//����ѡ��������ӵ�ǰ��������ID
			thisID ,
			shiftFlag = event.shiftKey;

			if(selectId){
				thisID = selectId.substring(4);
				//ɾ��ͼ�����¼�
				if (tar.prop("tagName") === "A") {
					$obj.remove();
					renderSelectedCount();
					return;
				}
				//��ctrl��shiftʱ
				if($obj.hasClass("selectedDiv")){
					$obj.removeClass("selectedDiv");
					preSelect = null;
				}else if(!shiftFlag){//ctrl
					//���ѡ�ж����Ѿ���������ѡ�����У���˵���Ѿ���ѡ���ͷ�ѡ��ȥ����ʽ�����������Ƴ�
					if($obj.hasClass("selectedDiv")){
						$obj.removeClass("selectedDiv")
					}else{//���������ѡ�����У��ͱ�ѡ�У������ʽ����ֵpush��������
						$obj.addClass("selectedDiv")
					}
					preSelect = $obj;
				}else if(shiftFlag){//shift
					//���������ѡ����
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
						//��ʼ�ͽ�������ͬһ��div
						if(preSelect.attr("id") !=  $obj.attr("id") ){
							//���ҵ�shift��Ŀ�ʼ��
							if( !selectedFlag && (divID == preSelect.attr("id") ||divID == $obj.attr("id"))){
								selectedFlag = true;
								continue;
							}
							//���ҵ�������
							else if(selectedFlag && (divID == preSelect.attr("id") || divID == $obj.attr("id"))){
								selectedFlag = false;
								continue;
							}
							//��ʼ��ͽ�����֮��ļ�¼��ɫ�����档
							if(selectedFlag){
								thisDIV.addClass("selectedDiv")
							}
						}
					}
					//����һ��ѡ�к����һ��ѡ����ӵ���ѡID����
					if(preSelect.attr("id") !=  $obj.attr("id")){
						//ֻ���һ��
						preSelect.addClass("selectedDiv")
					}
					$obj.addClass("selectedDiv")
				}else{//ͬʱ����ctrl��shift
					//ʲô������
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
	
	//�Ҳ���ѡ����������
	function arrowUp(){
		moveSelected(1);
	}
	//�Ҳ���ѡ����������
	function arrowDown(){
		moveSelected(2);
	}
	
	/**
	 * �����ƶ� 
	 * @param up �����ƶ���ʶ��1 ���ƣ�2����
	 * */
	function moveSelected(up){
		var allSelected = getAllSelectedInBox();
		//ѡ��һ�������ǲ���������
		if(allSelected&&allSelected.length==1){
			var selectDIV = allSelected.eq(0);
			if(up==1){ //����
				//������滹��Ԫ�أ�������
				if(selectDIV.prev()){
					selectDIV.prev().before(selectDIV);//��ѡ�ж�����뵽ǰһ������֮ǰ
					scorllReSize(selectDIV);
				}
			}else if(up==2){//����
				//������滹��Ԫ�أ�������
				if(selectDIV.next()){
					selectDIV.next().after(selectDIV);
					scorllReSize(selectDIV);
				}
			}
		}
	}
	/**
	 * ��ȡ�ұ���ѡ����ѡ�е����м�¼
	 * */
	function getAllSelectedInBox(){
		var container = getSelectedBox();
		return container.children(".selectedDiv");
	}
	
	/**���ұ���ѡ��������ѡ�еļ�¼ ȥ��ѡ��״̬
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
	 * ��ѡDiv��λ�õ���
	 */
	function scorllReSize(selectDIV) {
	    var divheight = selectDIV.height(),
	    divTop = selectDIV.position().top;
	    var $DivSelected = getSelectedBox();
	    //��ѡDIV���·�������
	    if ((divTop + divheight - $DivSelected.height()) > 0 ) {
	    	var v_scrollTop =$DivSelected.scrollTop() + divheight;
	        $DivSelected.scrollTop(v_scrollTop);
	        divTop = selectDIV.position().top;
	    }else if(divTop<0){
	    //��ѡDIV���Ϸ�������
	    	var v_scrollTop =$DivSelected.scrollTop() - divheight;
		 	$DivSelected.scrollTop(v_scrollTop);
		 	divTop = selectDIV.position().top;
	    }
	    //������û����ʾ��ֱ����ʾ��������
	    if(divTop<0 || (divTop + divheight - $DivSelected.height()) > 0){
	    	$DivSelected.scrollTop($DivSelected.scrollTop()+divTop);
	    }
	}
	
	/**
	 * ��ȡ�ұ���ѡ�����
	 * 
	 * */
	function getSelectedBox(){
		var $DivSelected;
		// ͨ��tabҳ�жϰѲ��żӵ��ĸ���ѡ���У�0��ʾ"��֯�ṹ" 1��ʾ"���ò���"
		if (getTab()) {
			//addFavoriteҳ�������ChoosePageҳ�����֯�ṹҳ��
	        $DivSelected = $("#div_selected");
	    } else {
	        $DivSelected = $("#div_selected_favorite");
	    }
		return $DivSelected;
	}
	/**
	 * ������ѡ��������
	 * @param pageType 1:��֯����Աѡ��ѡ��ҳ�� 2��������֯����ϵ��ѡ��ҳ��
	 */
	function renderSelectedCount(){
		var selectedContainer =getSelectedBox();
		var selected = selectedContainer.children();
		var isTreePage = getTab(); 
		if(chooseType==="org"){
			//��ѡ��֯�� ��
			if(isTreePage){
				$("#selectCountDiv").text("\u5df2\u9009\u7ec4\u7ec7\uff1a"+selected.length+" \u4e2a");
			}else{
				$("#selectCountFavoriteDiv").text("\u5df2\u9009\u7ec4\u7ec7\uff1a"+selected.length+" \u4e2a");
			}
		}else{
			//��ѡ��Ա��
			if(isTreePage){
				$("#selectCountDiv").text("\u5df2\u9009\u4eba\u5458\uff1a"+selected.length+" \u4e2a");
			}else{
				$("#selectCountFavoriteDiv").text("\u5df2\u9009\u4eba\u5458\uff1a"+selected.length+" \u4e2a");
			}
		}
	}