var showDialog =
/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	
	function showDialog(data,fn){
	    if(cui("#show_Dialog").isCUI){
	    	var dialog = cui("#show_Dialog").show();
	    	cui(comtop.cQuery('.tree',dialog._$dialogContent)).setDatasource(data);
	    }else{
			var dialog = cui.dialog({
					id:'show_Dialog',
					height:400,
		            modal: true,
		            title: '选择控件树',
		            html:__webpack_require__(1),
		            buttons:[
		            	{name:'确定',handler:function(){
		            		var selectNode = cui(comtop.cQuery('.tree',dialog._$dialogContent)).getSelectedNodes();
		            		var result = [];
		            		comtop.cQuery.each(selectNode,function(i,item){
		            			result.push(item.getData());
		            		});
		            		fn.call(this,result);
		            	}},
		            	{name:'取消',handler:function(){
		            		this.hide();
		            	}}
		            ]
			    }).show();
	    	cui(comtop.cQuery('.tree',dialog._$dialogContent)).tree({
		    	children:data,
		    	checkbox:true,
		    	select_mode:3
	    	})
	    }
	}

	module.exports = showDialog;

/***/ },
/* 1 */
/***/ function(module, exports) {

	module.exports = "<div class=\"tree\"></div>";

/***/ }
/******/ ]);