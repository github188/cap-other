window.webPath = window.webPath || '/web';
var nowDate = new Date();
requirejs.config({
	urlArgs: 'v=' + nowDate.getFullYear() + nowDate.getMonth() + nowDate.getDate(),
	baseUrl: webPath + '/top',
	paths: {
		'text': 'workbench/component/requirejs/text',
		'underscore': 'workbench/component/underscore/module.underscore',
		'jquery': 'js/jquery',
		'cui': 'workbench/component/cui/module.cui',
        'sidebar':'workbench/component/sidebar/js/sidebar',
        'jqueryui':'workbench/component/jquery/jquery-ui',
        'json2': 'js/json2',
        'autoIframe' : 'workbench/component/autoiframe/autoIframe',
        'uochoose':'workbench/component/cui/module.uochoose',
        'loginAction':'sys/dwr/interface/LoginAction',
        'logAction':'sys/dwr/interface/LogAction',
        'cui.storage':'workbench/component/cui/cStorage/cStorage.full.min',
        'cui.emDialog':'sys/js/comtop.ui.emDialog'
	},
	shim: {
		'underscore': {
			exports: '_'
		},
		'json2': {
			exports: 'JSON'
		},
		'uochoose' :{
		    deps:['cui']
		},
		'loginAction':{
		    exports: 'LoginAction'
		},
		'cui.emDialog':{
		    deps:['cui']
		}
	}
});

