/**
 * 模块首页引入此js
 */
//复制页面选中的页面，回调
function selectPageData(selectPageDate){
	dwr.TOPEngine.setAsync(false);
	PageFacade.loadModel("",packageId,function(result){
		inserPageModelPackage = result.modelPackage;
	});
	dwr.TOPEngine.setAsync(true);
	var modelId = selectPageDate.modelId;
	param="?modelId="+modelId+"&packageId="+packageId+"&saveType=pageTemplate&modelPackage="+inserPageModelPackage;
	window.location="${pageScope.cuiWebRoot}/cap/bm/page/designer/PageMain.jsp"+param;
}