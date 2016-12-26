//cap命名空间
var cap = cap?cap:{};
/**
 * 获取页面相对url以便于页面跳转
 * 
 * @param url page页面url 如：
 * @param modelPackage 调用页面的所在的modelPackage
 * @return 相对url
 */
cap.getRelativeURL = function(url, modelPackage) {
	var relativeURL = "";
	if(!modelPackage){
		return relativeURL;
	}
	var matchResult = /^(com\.comtop\.prototype\.)(.+)/.exec(modelPackage);
	if(!matchResult){
		return relativeURL;
	}
	var packageArray = matchResult[2].split(/\./);
	for(var i = 0, len = packageArray.length; i < len; i++){
		relativeURL += "../";
	}
	return relativeURL + url;
};