(function(c){cui.extend=cui.extend||{};var a=window.top;cui.extend.emDialog=function(d,e){a=e||a;a.cuiEMDialog=a.cuiEMDialog||{dialogs:{},wins:{}};d=c.extend({id:"emDialog_"+new Date().getTime()},d);if(a.cuiEMDialog.dialogs[d.id]){return a.cuiEMDialog.dialogs[d.id]}a.cuiEMDialog.dialogs[d.id]=a.cui.dialog(d);a.cuiEMDialog.wins[d.id]=window;return a.cuiEMDialog.dialogs[d.id]};if(!a.cuiEMDialog||b(a.cuiEMDialog.dialogs)){window._emDialogTopMark=true}c(window).bind("unload.emDialog",function(){if(window._emDialogTopMark){if(a.cuiEMDialog&&a.cuiEMDialog.dialogs){for(var d in a.cuiEMDialog.dialogs){if(a&&a.cuiEMDialog&&a.cuiEMDialog.dialogs){a.cuiEMDialog.dialogs[d].destroy();delete a.cuiEMDialog.dialogs[d];delete a.cuiEMDialog.wins[d]}}}}});function b(e){for(var d in e){return false}return true}})(comtop.cQuery);(function(f,a){var b=38;var c=40;var j=37;var h=13;var l=8;var d="a_query_";var g="cutoff_line";var k="searchDiv_",e="queryDataArea_",i="moreData_";a.UI.Choose=a.UI.Base.extend({options:{id:"",value:[],width:"",height:"",chooseMode:0,readonly:false,isAllowOther:false,callback:null,orgStructureId:"",rootId:"",delCallback:null,openCallback:null,textmode:false,isSearch:true,_defaultInputWidth:20,defaultOrgId:"",maxLength:-1,canSelect:true,byByte:true,formName:"",idName:"",valueName:"",opts:"",winType:"dialog"},tipPosition:".choose_box_wrap",pageSize:10,pageNo:1,fastQueryFunc:null,tempNoDataFunc:null,_init:function(m){if(!this.options.id){this.options.id="Choose_"+a.guid()}this.options.el.attr("id",this.options.id);if(this.options.isSearch){this.searchDivId=k+this.options.id,this.queryDataAreaDivId=e+this.options.id,this.moreDataDivId=i+this.options.id}if(!this.options.width){this.options.width="200px"}if(typeof this.options.width==="string"&&!/%/.test(this.options.width)){this.options.width=this.options.width.substring(0,this.options.width.length-2);var n=parseInt(this.options.width,10)-2;this.options.width=n+"px"}this.options.el.attr("width",this.options.width);if(!this.options.height){this.options.height="100%"}if(typeof this.options.height==="string"&&!/%/.test(this.options.height)){this.options.height=this.options.height.substring(0,this.options.height.length-2);var o=parseInt(this.options.height,10)-2;this.options.height=o+"px"}this.options.el.attr("height",this.options.height);this.$el=f("#"+this.options.id);if(this.options.opts){if(typeof this.options.opts==="string"&&typeof window[this.options.opts]==="object"){this.options.opts=window[this.options.opts]}else{this.options.opts=f.parseJSON(this.options.opts.replace(/\'/g,'"'))}}this._setValueFormHidden()},_setValueFormHidden:function(){var m=this.options;var p;if(m.formName){p=document.forms[m.formName]}var n=this._getHiddenVal(p,m.idName);if(n){var x=n.split(";");var v=this._getHiddenVal(p,m.valueName);if(v){var u=v.split(";");var t=[];if(m.opts&&m.opts.codeName){var o=this._getHiddenVal(p,m.opts.codeName);if(o){t=o.split(";")}}var q=[];var s=[];var w="";for(var r=0;r<x.length;r++){if(f.inArray(x[r],q)>-1){continue}if(r>=u.length){break}q.push(x[r]);w='{"id":"'+x[r]+'",';w+='"name":"'+u[r];if(t&&r<t.length){w+='","orgCode":"'+t[r]+'"}'}else{w+='"}'}s.push(f.parseJSON(w))}this.options.value=s;return}var q=this._loadValueFromDb(n);if(!q){q=[]}this.options.value=q}},_getHiddenVal:function(m,n){var p=f("#"+n);var o="";if(p.length==0&&m){p=m[n];if(p){o=p.value}}else{o=p.val()}return o},getFormData:function(){var m,o=this.options;if(o.formName){m=document.forms[o.formName]}var n={};if(o.idName){n[o.idName]=this._getHiddenVal(m,o.idName)}if(o.valueName){n[o.valueName]=this._getHiddenVal(m,o.valueName)}if(o.opts&&o.opts.codeName){n[o.opts.codeName]=this._getHiddenVal(m,o.opts.codeName)}return n},setTextMode:function(){this._createDom();this.__renderTextMode()},__renderTextMode:function(){f("#"+this.options.id+"_choose_box").attr("class","cui_ext_textmode");f("#"+this.options.id+"_open").hide();f("#"+this.options.id+"_choose_input").hide();this.options.el.attr("tip","")},_create:function(){var n=this.options;this._createDom();if(this.options.readonly){f("#"+this.options.id+"_open").hide();f("#"+this.options.id+"_choose_input").hide();f("#"+this.options.id+"_choose_box").attr("class","choose_box_readonly")}this._bindClickEvent();if(n.isAllowOther||n.isSearch){this._bindKeyEvent();var m=f("#"+this.options.id+"_choose_input");m.css("max-width",(m.parent(".choose_box").eq(0).width()-5))}if(n.isSearch){this._bindMouseEvent()}},_bindClickEvent:function(){var m=this,o=this.options;f("#"+this.options.id+"_choose_box").off().on("click.choose",function(p){m._clickHandler(p);return false});if(o.canSelect){f("#"+this.options.id+"_open").off().on("click.choose",function(p){m._aHandler(this);return false})}if(o.isSearch){var n=f("#"+this.moreDataDivId);n.off().on("click.choose",function(){if(f("#"+m.moreDataDivId).hasClass("more_data")){m._showMoreData()}return false});n.on("mouseup",function(){m.hideAble=true}).on("mousedown",function(){m.hideAble=false})}},_bindMouseEvent:function(){var m=this;var n="current_select";var o=f("#"+this.queryDataAreaDivId);o.off().on("mouseover.choose",function(r){if(m.pageX==r.pageX&&m.pageY==r.pageY){return}m.pageX=r.pageX;m.pageY=r.pageY;if(m.t){clearTimeout(m.t)}delete m.t;var p=f(r.target).closest("a");var q=f("#"+m.queryDataAreaDivId);q.children().removeClass(n);p.addClass(n);m.__clearHover()}).on("mouseout.choose",function(p){if(m.pageX==p.pageX&&m.pageY==p.pageY){return}if(m.t){clearTimeout(m.t)}m.t=setTimeout(function(){var q=f("#"+m.queryDataAreaDivId);q.children().removeClass(n)},200)});o.on("mouseup",function(p){m.hideAble=true}).on("mousedown",function(){m.hideAble=false});o.on("click.choose",function(p){var q=f("#"+this.queryDataAreaDivId);m.hoverIndex=q.children().index(f(p.target).closest("a"));m._selectRow();return false})},_bindKeyEvent:function(){var n=this,o=this.options,p;var m=f("#"+this.options.id+"_choose_input");m.unbind("keydown.choose").bind("keydown.choose",function(q){p=q.keyCode;switch(p){case l:if(!f("#"+n.options.id+"_choose_input").val()){n._popData()}break;case b:if(o.isSearch&&n.__keyDownUPHandler){n.__keyDownUPHandler()}break;case c:if(o.isSearch&&n.__keyDownDownHandler){n.__keyDownDownHandler()}break;case h:if(n.__keyDownEnterHandler){n.__keyDownEnterHandler()}break}});if(n.options.isSearch){m.unbind("keyup.choose").bind("keyup.choose",function(q){n._keyup(q)})}m.bind("keyup.choose",function(r){var s=n._textWidth(f(this));var q=f(this).width();if(s>q){f(this).width(s)}});if(o.isAllowOther&&o.maxLength>-1){o.byByte||m.attr("maxLength",o.maxLength);m.on("propertychange.choose",function(q){o.byByte&&n._textCounter()});this._textCounter()}m.focus(function(){var s=f("#"+n.options.id+"_choose_input");if(!s.is(":hidden")){var q=f("#"+o.id+"_choose_box");q.addClass("choose_input_focus");var r=s.val();s.val(r)}n.onValid()});m.blur(function(){var q=f("#"+o.id+"_choose_box");q.removeClass("choose_input_focus");n._blurHandler()})},_textWidth:function(q){var p=q.val(),p=f("<div style='display:none'/>").text(p).html(),m=q.css("font");var o=f("<pre>"+p+"</pre>").css({display:"none"});f("body").append(o);o.css("font",m);var n=o.width();o.remove();return n},_textCounter:function(){var o=this.options;var m=f("#"+this.options.id+"_choose_input");var p=m.val().toString();if(o.isAllowOther&&o.maxLength>-1){var n=this._getStringLength(p);if(n>o.maxLength){m.val(this._interceptString(p,o.maxLength))}else{return false}}return false},_getStringLength:function(n){var m=this.options;return m.byByte?a.String.getBytesLength(n):n.length},_interceptString:function(o,n){var m=this.options;return m.byByte?a.String.intercept(o,n):a.String.interceptString(o,n)},_createHiddenInput:function(){var p=this.options;var m=null;if(p.formName){m=document.forms[p.formName]}var o="";o+=this._createHiddens(m,p.idName);o+=this._createHiddens(m,p.valueName);var q=null;if(p.opts&&p.opts.codeName){o+=this._createHiddens(m,p.opts.codeName)}if(o){if(m&&typeof(m)!=="undefined"){var n=f(m);n.append(o)}else{this.$el.before(o)}}},_createHiddens:function(m,o){var q="";if(o){var p=f("#"+o);var n=false;if(p.length>0){n=true}if(m&&m[o]){n=true}if(!n){q='<input type="hidden" name="'+o+'" id="'+o+'"/>'}}return q},_createDom:function(){var p=this.options,o=this.$el,n,r;r=[];if(!f.isArray(this.options.value)){this.options.value=[this.options.value]}if(p.chooseMode==1&&this.options.value.length>1){this.options.value=[this.options.value[0]]}r.push(this._buildSelect());if(!this.options.textmode&&(this.options.isAllowOther||this.options.isSearch)){r.push('<input id="');r.push(this.options.id+'_choose_input"  class="choose_input" ');if(p.chooseMode==1&&this.options.value.length==1){r.push(" style='display:none;' ")}r.push(' type="text"/>')}if(!this.options.textmode&&this.options.isSearch){var m=[];m.push('<div id="'+this.searchDivId+'" class="search_div">');m.push('<div id="'+this.queryDataAreaDivId+'" class="queryList" ></div>');m.push('<div id="'+this.moreDataDivId+'" class="more_data"><a href="#" hidefocus="true">\u66f4\u591a\u6570\u636e...</a></div>');m.push("</div>");f("body").append(m.join(""))}this._createHiddenInput();var q='<a id="'+this.options.id+'_open" flag="openWin" href="#" class="'+(this.options.uitype==="ChooseOrg"?"icon_org":"icon_user")+'" ></a>';if(!this.options.canSelect){q=""}n=['<div class="choose_box_wrap" style="width:',this.options.width,'">','<div id="',this.options.id,'_choose_box" class="choose_box" style="height:',this.options.height,';width: 100%;">',r.join(""),"</div>","</div>",q];o.html(n.join(""));if(r.length){this._setMaxWidth(f(".block_cross_other",this.options.el));this._setMaxWidth(f(".block_cross",this.options.el))}},_setMaxWidth:function(o){if(o&&o.length){var n=o.eq(0).parent(".choose_box").width()-37;for(var m=0;m<o.length;m++){o.eq(m).css("max-width",n)}}},_setValueToHidden:function(m,n,o){if(n){var p=f("#"+n);if(p.length==0){if(m&&m[n]){p=f(m[n])}}if(p.length==1){p.val(o)}}},_setHiddenElement:function(q){var m=this.options;if(m.idName){var n=[],t=[],o=[];var r="name";if(m.uitype==="ChooseOrg"&&m.showLevel!=-1&&m.isFullName){r="fullName"}for(var s=0,p=q.length;s<p;s++){n.push(q[s]["id"]);t.push(q[s][r]);o.push(q[s]["orgCode"])}var u;if(m.formName){u=document.forms[m.formName]}this._setValueToHidden(u,m.idName,n.join(";"));this._setValueToHidden(u,m.valueName,t.join(";"));this._setValueToHidden(u,m.opts.codeName,o.join(";"))}},_clickHandler:function(n){var m=n.target;switch(m.nodeName){case"A":this._aHandler(m);return false;break;case"SPAN":break;case"DIV":this._divHandler(m);break}},__keyDownUPHandler:function(){var o=this.options.uitype==="ChooseOrg"?".dept_query":".user_query";var p="current_select";var r=f("#"+this.queryDataAreaDivId),m=r.find(o).length,q,n;if(m){q=r.find(o);n=this.hoverIndex;if(typeof n==="undefined"){n=m-1;q.removeClass(p);q.eq(n).addClass(p)}else{q.eq(n||0).removeClass(p);if(--n===-1){n=m-1}q.eq(n).addClass(p)}this.hoverIndex=n;this.__scrollHoverPosition(n)}},__keyDownDownHandler:function(){var o=this.options.uitype==="ChooseOrg"?".dept_query":".user_query";var p="current_select";var r=f("#"+this.queryDataAreaDivId),m=r.find(o).length,q,n;if(m){q=r.find(o);n=this.hoverIndex;if(typeof n==="undefined"){n=0;q.removeClass(p);q.eq(n).addClass(p)}else{q.eq(n||0).removeClass(p);if(m===++n){n=0}q.eq(n).addClass(p)}this.hoverIndex=n;this.__scrollHoverPosition(n)}},__clearHover:function(){var n=this.hoverIndex;if(typeof n!=="undefined"){var m=this.options.uitype==="ChooseOrg"?".dept_query":".user_query";var o="current_select";var q=f("#"+this.queryDataAreaDivId),p;p=q.find(m);p.eq(n).removeClass(o);delete this.hoverIndex}},_divHandler:function(m){f("#"+this.options.id+"_choose_input").focus()},_getWindowSize:function(){var o=this.options.chooseMode;var r;var s=536;var q,n;if(comtop.Browser.notIE){r=o==1?342:505}else{r=o==1?335:505}var m=window.top.comtop.Browser.isQM;var p=window.top.comtop.Browser.isIE;var t=false;if(p){var u=window.top.navigator.userAgent.toLowerCase();if(u.indexOf("msie 8.0")==-1&&(u.indexOf("msie 7.0")>-1||u.indexOf("msie 6.0")>-1)){t=true}}if(o!=1){r=r+30;if(p&&(m||t)){r+=18}}else{r=r-28;if(p&&(m||t)){r+=15}}q=(window.screen.width-20-r)/2;n=(window.screen.height-30-s)/2;return{width:r,height:s,offsetLeft:q,offsetTop:n}},_aHandler:function(s){var r=f(s);if(r.attr("flag")=="del"){this._deleteData(r.parent().attr("id"))}else{if(this.options.openCallback){var q=this.options.openCallback(this.options.id);if(!q){return}}var n;n=webPath+"/top/sys/usermanagement/orgusertag/ChoosePage.jsp?id="+this.options.id+"&chooseType="+this.options.uitype+"&chooseMode="+this.options.chooseMode+"&winType="+this.options.winType;var p=this.options.uitype==="ChooseUser"?"\u9009\u62e9\u4eba\u5458":"\u9009\u62e9\u7ec4\u7ec7";var m=this._getWindowSize();if(this.options.winType==="window"){window.open(n,"ChoosePage","left="+m.offsetLeft+",top="+m.offsetTop+",width="+m.width+",height="+m.height+",menu=no,toolbar=no,resizable=no,scrollbars=no")}else{var o;if(window.top.cuiEMDialog&&window.top.cuiEMDialog.dialogs){o=window.top.cuiEMDialog.dialogs["topdialog_"+this.options.id]}if(!o){o=cui.extend.emDialog({id:"topdialog_"+this.options.id,title:p,modal:true,src:n,width:m.width,height:m.height})}else{o.reload(n)}o.show()}}},_deleteData:function(p){var n=this.options.value;var o;p=p.replace(this.options.id,"");for(var m=0;m<n.length;++m){if(n[m].id==p){o=n.splice(m,1)}}this.__setValue(n);if(this.options.delCallback){this.options.delCallback(o,this.options.id)}},_isSelected:function(o){var n=this.options.value;for(var m=0;m<n.length;++m){if(n[m].id==o){return true}}return false},_appendData:function(o){if(this.options.chooseMode>0&&this.options.value.length==this.options.chooseMode){if(this.options.uitype=="user"||this.options.uitype=="ChooseUser"){cui.alert("\u6700\u591A\u9009\u62E9"+this.options.chooseMode+"\u4e2a\u4eba\u5458")}else{cui.alert("\u6700\u591A\u9009\u62E9"+this.options.chooseMode+"\u4e2a\u7ec4\u7ec7")}return}if(!this._isSelected(o.id)){var n=o;if(!o.isOther){var m=this._loadValueFromDb(o.id);n=m[0]}this.options.value.push(n);this.__setValue(this.options.value);if(this.options.callback){this.options.callback(this.options.value,this.options.id)}}},_popData:function(){var m=this.options.value[this.options.value.length-1];if(m){var n=m.id;this._deleteData(n)}},__setValue:function(r,s){if(!r){r=[]}if(!f.isArray(r)){r=[r]}r=f.extend(true,[],r);if(this.options.chooseMode>0&&r.length>=this.options.chooseMode){r=r.slice(0,this.options.chooseMode)}this.options.value=r;var m=this.options.value.length;f(".block_cross_other",this.options.el).remove();f(".block_cross",this.options.el).remove();if(this.options.textmode){var o=f("#"+this.options.id+"_choose_box");var q=[];for(var p=0;p<m;p++){if(!this.options.value[p].title){this.options.value[p].title=this.options.value[p].name}q.push(this.options.value[p].title)}o.html(q.join(";"));this.__renderTextMode()}else{if(this.options.isSearch||this.options.isAllowOther){var n=f("#"+this.options.id+"_choose_input",this.options.el);var q=this._buildSelect();n.before(q);n.val("");if(this.options.chooseMode==1&&this.options.chooseMode==this.options.value.length){n.hide()}else{n.show()}}else{var o=f("#"+this.options.id+"_choose_box");var q=this._buildSelect();o.append(q)}}this._setMaxWidth(f(".block_cross_other",this.options.el));this._setMaxWidth(f(".block_cross",this.options.el));if(this.options.readonly){this.setReadonly(true)}this._setHiddenElement(r);this._resizeInputWidth();s||this._triggerHandler("change")},_loadValueFromDb:function(s){if(!s){return null}var m=[];var o=[];if(f.isArray(s)&&s.length>0){o=s.slice(0);for(var n=0;n<s.length;n++){m.push(s[n].id)}}else{if(typeof s==="string"){m=s.split(";")}}if(!m||m.length==0){return o}dwr.TOPEngine.setAsync(false);var r;var q=this.options.uitype==="ChooseOrg"?"org":"user";ChooseAction.querySelectedDataByIds(m,{chooseType:q,showLevel:this.options.showLevel||0,showOrder:this.options.showOrder||""},function(u){if(!u){u=[]}r=u});dwr.TOPEngine.setAsync(true);if(o&&o.length){var p=[];var t=-1;for(var n=0;n<o.length;n++){if(t<r.length-1&&o[n].id===r[t+1].id){p.push(r[t+1]);t++}else{o[n].isOther=true;p.push(o[n])}}return p}return r},setValue:function(n,o){var m=this._loadValueFromDb(n);this.__setValue(m,o)},_resizeInputWidth:function(){f("#"+this.options.id+"_choose_input",this.options.el).width(this.options._defaultInputWidth)},_getMultiStype:function(){return this.options.chooseMode!=1?"block_cross_multi":""},_buildSelect:function(){var o=[],m=this.options.value.length;if(this.options.textmode){var r="";for(var n=0;n<m;n++){r=!this.options.value[n].showName?this.options.value[n].name:this.options.value[n].showName;o.push(r)}return o.join(";")}else{var p=this._getMultiStype();var q="";var r="";for(var n=0;n<m;n++){q=this.options.value[n].isOther?"block_cross_other":"block_cross";r=!this.options.value[n].showName?this.options.value[n].name:this.options.value[n].showName;o.push('<div class="'+q+" "+p+'" title="'+r+'" id="'+this.options.id+this.options.value[n].id+'"><span class="c_content">'+r+'</span><a flag="del" href="#" class="block_delete"></a></div>')}return o.join("")}},getValue:function(){return f.extend(true,[],this.options.value)},setReadonly:function(m){this.options.readonly=m;if(m){f("#"+this.options.id+"_open").hide();f("#"+this.options.id+"_choose_input").hide();f("#"+this.options.id+"_choose_box").attr("class","choose_box_readonly");this.options.el.attr("tip","");f("#"+this.options.id+"_choose_box").children().children(".block_delete").hide()}else{f("#"+this.options.id+"_open").show();f("#"+this.options.id+"_choose_input").show();f("#"+this.options.id+"_choose_box").removeClass("choose_box_readonly");f("#"+this.options.id+"_choose_box").addClass("choose_box");f("#"+this.options.id+"_choose_box").children().children(".block_delete").show()}},setAttr:function(m,n){if(m==="rootId"){this.options.rootId=n;this.options.el.attr("rootId",n)}if(m==="defaultOrgId"){this.options.defaultOrgId=n;this.options.el.attr("defaultOrgId",n)}if(m==="orgStructureId"){this.options.orgStructureId=n;this.options.el.attr("orgStructureId",n)}if(this.options.uitype==="ChooseOrg"&&m==="unselectableCode"){this.options.el.attr("unselectableCode",n)}},onInValid:function(o,p){f("#"+this.options.id+"_choose_box").addClass("choose_invalid");var m=this,n=m.options;if(n.tipTxt==null){n.tipTxt=n.el.attr("tip")||""}n.el.attr("tip",p);f(m.tipPosition,n.el).attr("tipType","error")},onValid:function(o){var m=this,n=m.options,q=f(m.tipPosition,n.el).attr("tipID");f("#"+this.options.id+"_choose_box").removeClass("choose_invalid");if(n.tipTxt==null){n.tipTxt=n.el.attr("tip")||""}if(q!==undefined){var p=cui.tipList[q];typeof p!=="undefined"&&p.hide()}n.el.attr("tip",n.tipTxt);f(m.tipPosition,n.el).attr("tipType","normal")},_blurHandler:function(){if(this.hideAble==false){return}this._closeFastDataDiv();this._resizeInputWidth()},_subDepartmentFullName:function(n,o){var m=n.lastIndexOf(f.trim(o));if(m>0){return n.substring(0,m)}else{return""}},_installData:function(p,q){var o=Math.ceil(p.count/this.pageSize);var m=this._buildListItemTemplate(p);var n=f("#"+this.queryDataAreaDivId);if(q=="add"){n.append(m)}else{if(q=="replace"){n.height("");n.html(m)}}if(this.pageNo==o){f("#"+this.moreDataDivId).css("display","none")}else{f("#"+this.moreDataDivId).css("display","block")}},__scrollHoverPosition:function(n){var r=f("#"+this.queryDataAreaDivId),q=r.scrollTop(),m=r.children(),t=m.eq(n),s=r.height(),p=t.outerHeight(),o=t[0].offsetTop;if(q>o){r.scrollTop(o)}else{if(q<o+p-s){r.scrollTop(o+p-s)}}},__scrollHoverToBottom:function(o){var r=f("#"+this.queryDataAreaDivId),q=r.scrollTop(),n=r.children(),m=n.length,s=n.eq(Math.min(m-1,o)),p=s[0].offsetTop;r.scrollTop(p)},_showOrDisplay:function(x){var t=f("#"+this.options.id+"_choose_box").parent();var y=f("#"+this.searchDivId);var q=f("#"+this.queryDataAreaDivId);q.hide();var p=f(window).height();var n;var r=p-t.offset().top-t.height();var w=t.offset().top;var m=200;var u=false;if(r-m<0&&w>r){u=true}if(x==="no_data"&&r>20){u=false}y.css("overflow-y","");if(u){var v=(t.parent().outerHeight(false)+t.parent().offset().top-t.offset().top);y.css("bottom",v);y.css("border-top","1px solid #ddd");y.css("top","");n=w>m?m:w}else{var v=(t.outerHeight(false)-t.parent().offset().top+t.offset().top);y.css("top",v);y.css("border-bottom","1px solid #ddd");y.css("bottom","");y.css("border-top","1px solid #ddd");n=r>m?m:r}if("none"!=f("#"+this.moreDataDivId).css("display")){var o=f("#"+this.moreDataDivId).height();n=n-o-5}var s=f("."+x).length;if(s>0){this._openFastDataDiv(n,u);q.show();q.scrollTop(0)}else{this._closeFastDataDiv()}},_closeFastDataDiv:function(){this.__clearHover();this.pageNo=1;this.tempNoDataFunc=null;this.fastQueryFunc=null;var m=f("#"+this.searchDivId);m.css("z-index","");var o=f("#"+this.queryDataAreaDivId);o.children().remove();m.children().hide();m.slideUp("fast");var n=f("#"+this.options.id+"_choose_input");if(!n.is(":hidden")){n.val("")}},_openFastDataDiv:function(n,v){var u=f("#"+this.searchDivId);u.show();var w=f("#"+this.options.id+"_choose_box").parent();var o=w.innerWidth();f("#"+this.moreDataDivId).css("width",o);var t=f("#"+this.searchDivId);t.width(o+"px");t.slideDown("fast");var m=f("#"+this.queryDataAreaDivId);if(m.height()>n){m.css("height",n+"px")}var r=m.height();if("none"!=f("#"+this.moreDataDivId).css("display")){var q=f("#"+this.moreDataDivId).height();r=r+q}var p=w.offset().top;if(v){p=p-r}else{p=p+w.height()-1}var s={};s.left=w.offset().left;s.top=p;u.offset(s);u.css("width",(f("#"+this.searchDivId).width())+"px");u.css("height",r+"px")},_handleStr:function(m){m=m.replace(new RegExp("/","gm"),"//");m=m.replace(new RegExp("%","gm"),"/%");m=m.replace(new RegExp("_","gm"),"/_");m=m.replace(new RegExp("'","gm"),"''");return m},_showMoreData:function(){this.pageNo++;var m=f("#"+this.moreDataDivId);m.removeClass("more_data");m.addClass("more_data_disable");var n=this._handleStr(f("#"+this.options.id+"_choose_input").val());n=f.trim(n);if(n==""){this._closeFastDataDiv();this._closed===true;return}else{this._fastQuery(n,"add")}},_keyup:function(o){if(!(o.keyCode>=j&&o.keyCode<=c)){this.pageNo=1;var n=this;if(this.fastQueryFunc){window.clearTimeout(this.fastQueryFunc)}if(this.tempNoDataFunc){window.clearTimeout(this.tempNoDataFunc)}var m=this._handleStr(f("#"+this.options.id+"_choose_input").val());m=f.trim(m);if(m==""){this._closeFastDataDiv();this._closed===true;return}else{this.fastQueryFunc=setTimeout(function(){n._fastQuery(m,"replace")},300)}}},__keyDownEnterHandler:function(){this._selectRow()},_selectRow:function(){var u=this.options.uitype==="ChooseOrg"?".dept_query":".user_query";var v=this.options.singleChoose;var p=f("#"+this.queryDataAreaDivId),t=p.find(u).length;var w=this.hoverIndex;if(t==1&&v==true){w=0;this.hoverIndex=0}var q={};if(typeof w!=="undefined"){if(this._beforeSelect&&!this._beforeSelect(w)){return false}var r=".current_select";var p=f("#"+this.queryDataAreaDivId);var s=p.find(r);if(s.length==0&&t==1&&v==true){var s=p.find(".user_query")}if(s&&s.length){var n=s.attr("id").replace(d,"");q.id=n;this._appendData(q)}}else{if(this.options.isAllowOther&&f.trim(f("#"+this.options.id+"_choose_input").val())){this._textCounter();var m=f("<div style='display:none'/>").text(f("#"+this.options.id+"_choose_input").val()).html();q.id=m.replace(/&lt;/g,"\u300a").replace(/&gt;/g,"\u300b");q.name=m;q.isOther=true;this._appendData(q)}}var o=f("#"+this.options.id+"_choose_box");if(o.scrollTop()>0){o.scrollTop(o[0].scrollHeight)}this._blurHandler();f("#"+this.options.id+"_choose_input").focus()},_queryCallBack:function(s,o,p){if(this._closed===true){return}var v=this;if(p.count==0){f("#"+this.moreDataDivId).css("display","none");f("#"+this.queryDataAreaDivId).height("");var u="";if(s==="user"){u='<span class="no_data" >&nbsp;\u672a\u67e5\u5230\u8be5\u4eba\u5458</span>'}else{if(s==="org"){u='<span class="no_data" >&nbsp;\u672a\u67e5\u5230\u8be5\u7ec4\u7ec7</span>'}}f("#"+this.queryDataAreaDivId).html(u);this._showOrDisplay("no_data");clearTimeout(this.tempNoDataFunc);this.tempNoDataFunc=setTimeout(function(){v._closeFastDataDiv()},2000)}else{var m=f("#"+this.queryDataAreaDivId),n=m.children(),r=n.length;if(o==="replace"){this.__clearHover()}this._installData(p,o);var t="";if(s==="user"){t="user_query"}else{if(s==="org"){t="dept_query"}}this._showOrDisplay(t);var q=f("#"+this.moreDataDivId);q.removeClass("more_data_disable");q.addClass("more_data");if(o==="add"){this.__scrollHoverToBottom(r-1);f("#"+this.options.id+"_choose_input").focus()}}}});a.UI.Choose.setChooseOpt=function(m){var q,o=this,n;if(typeof m==="object"){for(q in m){if(typeof q==="string"&&q==="ChooseUser"){f.extend(comtop.UI.ChooseUser.prototype.options,m[q])}if(typeof q==="string"&&q==="ChooseOrg"){f.extend(comtop.UI.ChooseOrg.prototype.options,m[q])}}}};a.UI.ChooseUser=a.UI.Choose.extend({options:{uitype:"ChooseUser",userType:0,singleChoose:false},_fastQuery:function(n,p){this._closed=false;var m=this;var o={};o.keyword=n;o.userType=this.options.userType;o.orgStructureId=this.options.orgStructureId;o.rootDepartmentId=this.options.rootId;o.pageNo=this.pageNo;o.pageSize=this.pageSize;ChooseAction.fastQueryUserPagination(o,function(q){m._queryCallBack("user",p,q)})},_sameNameDispose:function(q,o){var p=1;for(var n=0;n<o;n+=p){p=1;for(var m=n+1;m<o;m++){if(q[n].title==q[m].title){q[n].hasSameName=true;q[m].hasSameName=true;p++}else{if(q[m-1].hasSameName){q[m-1].hasCutoffLine=true}break}}}return q},_buildListItemTemplate:function(q){var m="";var o=q.list.length;var p=q.list;p=this._sameNameDispose(p,o);for(var n=0;n<o;n++){m+=this._getMenuItemTemplate(p[n],n)}return m},_getMenuItemTemplate:function(p,n){if(p.hasSameName){var o=this._subDepartmentFullName(p.fullName,p.orgName);var q="";if(p.hasCutoffLine){q="user_query user-same-name user-same-name-last"}else{q="user_query user-same-name"}var m=["<a href='#' class='"+q+"' id='",d,p.key,"'>","<span class='user-name' title='",p.title,"'>",p.title,"</span>","<span class='user-deptname' title='",p.orgName,"'>",p.orgName,"</span>","<span class='user-deptfullname' title='",o,"'>",o,"</span>","</a>"];return m.join("")}else{var m=["<a href='#' class='user_query' id='",d,p.key,"'>","<span class='user_first' title='",p.title,"'>",p.title,"</span>","<span class='user_last' title='",p.fullName,"'>",p.fullName,"</span>","</a>"];return m.join("")}}});a.UI.ChooseOrg=a.UI.Choose.extend({options:{uitype:"ChooseOrg",showLevel:-1,showOrder:"order",levelFilter:999,unselectableCode:"",isFullName:false,childSelect:false},_getMenuItemTemplate:function(r,o){var p="";var q=this.options.rootId;if(q&&q===r.key){p=r.fullName}else{p=this._subDepartmentFullName(r.fullName,r.title)}if(p==""){var m=["<a href='#' class='",r.className,"' id='",d,r.key,"'","orgreadonly='",r.unselectable,"' style='height:20px;'>","<span class='",r.firstClassName,"' title='",r.title,"'>",r.title,"</span>","</a>"];return m.join("")}else{var n=["<a href='#' class='",r.className,"' id='",d,r.key,"'","orgreadonly='",r.unselectable,"'>","<span class='",r.firstClassName,"' title='",r.title,"'>",r.title,"</span>","<span class='",r.lastClassName,"' title='",p,"'>",p,"</span>","</a>"];return n.join("")}},_buildListItemTemplate:function(q){var n="";var p=q.list.length;var m;for(var o=0;o<p;o++){m=q.list[o];if(m.unselectable){m.className="dept_query dept_query_readonly"}else{m.className="dept_query"}m.firstClassName="dept_first";m.lastClassName="dept_last";n+=this._getMenuItemTemplate(m,o)}return n},_beforeSelect:function(n){var o=f("#"+this.queryDataAreaDivId).find(".dept_query").eq(n);var m=f(o).attr("orgreadonly");if(m==="true"||m==true){return false}return true},_fastQuery:function(n,p){var m=this;this._closed=false;var o={};o.keyword=n;o.orgStructureId=this.options.orgStructureId;o.rootDepartmentId=this.options.rootId;o.pageNo=this.pageNo;o.pageSize=this.pageSize;o.levelFilter=this.options.levelFilter;ChooseAction.fastQueryOrgPagination(o,this.options.unselectableCode,function(q){m._queryCallBack("org",p,q)})}})})(window.comtop.cQuery,window.comtop);