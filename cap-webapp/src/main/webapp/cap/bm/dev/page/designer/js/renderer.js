define(["lodash","utils"],function() {
   /**
   	*td中options解析样式和属性
   	*/
   function sumoption(td,defalutWidth){
      var style = "width:{0};".formatValue(defalutWidth),attr="";
      if(_.isPlainObject(td.options)){
            _.forEach(td.options,function(el,i) {
              if(Tools.tdOption.indexOf(i)>=0){
                if(i=="width"){
                    style = style.replace(/width:[0-9.]+(%|px);/,"width:"+el+";");
                 }else{
                    style+=i+":"+el+";";
                 }
              }else{
                attr+= i+"="+el + " ";
              }
            });
      }
      return {"style":style,"attr":attr};
    }
   
   /**
     *生成CUI组件占位符
     * @param op
     * @returns {*}
     */
    function buildCUIHTML(data){
        var html=[];
        if(data){
            if(_.isPlainObject(data) && !_.isEmpty(data)){
                data =[data];
            }
            _.forEach(data,function(item){
                if(!_.isEmpty(item)){
                    //Grid和EditableGrid做特殊处理
                    var initOption = Tools.defaultInit[item.uiType] ||{};
                    var options = item.objectOptions ||item.options;
                    options.textmode = false; //设置文本模式 时候不能让其生效
                    options.designMode = true;
                    window.uiConfig[item.id] = _.assign({},initOption,options);
                    if(_.indexOf(["Grid","EditableGrid"],item.uiType)>=0){
                        html.push('<table class="cui-component" id="{0}" uiType="{1}">'.formatValue(item.id,item.uiType));
                        html.push('</table>');
                        window.uiConfig[item.id].datasource = initOption.datasource;
                    }else if(_.indexOf(["Editor","Tab","Borderlayout"],item.uiType)>=0){
                        html.push('<div class="cui-component" id="{0}" uiType="{1}"></div>'.formatValue(item.id,item.uiType));
                    }else if(_.indexOf(["Menu"],item.uiType)>=0){
                        html.push(Tools.craeteMenu(item.id,options.name));
                    }else{
                        html.push('<span class="cui-component" ');
                        html.push('id="{0}" uiType="{1}"'.formatValue(item.id,item.uiType));
                        if(options){
                           options =  _.mapValues(options,function(prop){
                                if(prop==="false"||prop==="true"){
                                  return eval(prop);
                                }
                                return prop;
                            })
                        }
                        html.push('></span> ');
                    }
                    html.push('<div class="cIndicator" id="{0}_indicator" data-uiid="{0}" data-foruitype="{1}"><div class="dot a"></div><div class="dot b"></div><div class="dot c"></div><div class="dot d"></div><div class="dot e"></div><div class="dot f"></div><div class="dot g"></div><div class="dot h"></div></div>'.formatValue(item.id,item.uiType));
                }
            })
        }
        return html.join('');
    }

	return function(table_data){
    _.templateSettings = {
        interpolate: /\<\@\=(.+?)\@\>/gim,
        evaluate: /\<\@([\s\S]+?)\@\>/gim,
        escape: /\<\@\-([\s\S]+?)\@\>/gim
    }; 
		var html = "";
    var tableuid = _.template($('#tableTemplate').html(),{imports:{"buildCUIHTML":buildCUIHTML,"sumoption":sumoption}});
		_.forEach(table_data,function(val){
          //if(val.type==="layout" && val.uiType==="table"){
              html += tableuid({"table":val});
          //}
       })
		return html;
	}
})