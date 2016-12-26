//选择模板分类
var addTemplateDialog;
function addTemplate(){
	var data = validatePagesAreas();
	if(data == null){
		cui.alert("该模块下没有任何页面！");
		return;
	}
	if(data.result){
		var height = 200;
		var width = 450;
		if(!addTemplateDialog){
			addTemplateDialog = cui.dialog({
			  	title : "新增模版分类",
			  	src : addTemplateURL,
			    width : width,
			    height : height
			});
		}
		addTemplateDialog.show(addTemplateURL);
	} else {
		cui.alert(data.message, null, {width:380});
	}
}

//验证页面的可变区域设置是否合法（具有相同的区域编码和区域ID的可变区域，如果绑定的实体不同(一个有绑定实体为空，一个没绑定实体也视为不同)则非法）
function validatePagesAreas(){
	var data = {};
	var pageTemplateList = cui.utils.parseJSON(cui.utils.stringifyJSON(page));
	if(!page || !Array.isArray(page) || page.length <= 0){
		return null;
	}
	dwr.TOPEngine.setAsync(false);
	MetadataPageConfigFacade.validatePagesAreas(pageTemplateList, function(result) {
		data = result;
	});
	dwr.TOPEngine.setAsync(true);
	return data;
}

//新增模版分类
function saveTemplateType(obj){
	var metadataTmpTypeVO ={typeCode:obj.templateTypeCode, typeName:obj.templateTypeName};
	var isSuccess = false;
	dwr.TOPEngine.setAsync(false);
	MetadataTmpTypeFacade.addMetadataTmpTypeNode(metadataTmpTypeVO, obj.parentemplateTypeCode, function(data){
		if(data){
			isSuccess = true;
		}
	});
	dwr.TOPEngine.setAsync(true);
	if(isSuccess){
		metaDateBuilder(obj.templateTypeCode,obj.templateTypeName);
	}
}

/**
 * 保存为模板并生成元数据录入界面的xml
 *
 */
var metaDateBuilder = function(templateTypeCode,templateTypeName){
	//clone页面，
	var pageTemplateList = cui.utils.parseJSON(cui.utils.stringifyJSON(page));
	var result;
	dwr.TOPEngine.setAsync(false);
	MetadataPageConfigFacade.generateTemplateFiles(pageTemplateList, templateTypeCode,templateTypeName,function(data) {
		result = data;
	});
	dwr.TOPEngine.setAsync(true);
	//clone页面失败，提示后结束
	if(!result){
		addTemplateDialog.hide();
		cui.alert('模板保存失败', function(){});
		return null;
	}else{
		addTemplateDialog.hide();
		cui.message("模板保存成功。","success");
	}
}

var selectTemplateDialog
//选择界面录入元数据模版
function selectTemplate(){
	var height = 350;
	var width = 280;
	if(!selectTemplateDialog){
		selectTemplateDialog = cui.dialog({
		  	title : "元数据模版分类选择页面",
		  	src : fromTemplateUrl,
		    width : width,
		    height : height
		});
	}
	selectTemplateDialog.show(fromTemplateUrl);
}