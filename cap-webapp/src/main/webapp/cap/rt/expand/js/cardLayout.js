/**
 * 渲染自动编码控件
 */
cap.beforeLoadCardLayout=function(itemId,item){
	document.getElementById(itemId).setAttribute('uitype','CardLayout');
	comtop.UI.scan();
}