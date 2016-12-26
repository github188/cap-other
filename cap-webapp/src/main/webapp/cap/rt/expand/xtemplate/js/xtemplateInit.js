cap.beforeLoadXTemplate=function (itemid,item){
KISSY.use('kg/xtemplate/4.2.0/',function(S,XTemplate){
   var tplString =item.tplContent();
   var tplContext =item.initData();//item.tplContext;
   var html = new XTemplate(tplString).render(tplContext);
   document.getElementById(itemid).innerHTML=html;
});


}