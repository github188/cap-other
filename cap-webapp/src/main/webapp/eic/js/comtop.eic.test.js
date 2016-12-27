Namespace = new Object();
Namespace.register = function(fullNS) {
	var nsArray = fullNS.split('.');
	var sEval = "";
	var sNS = "";
	for ( var i = 0; i < nsArray.length; i++) {
		if (i != 0)
			sNS += ".";
		sNS += nsArray[i];
		sEval += "if (typeof(" + sNS + ") == 'undefined') " + sNS
				+ " = new Object();"
	}
	if (sEval != "")
		eval(sEval);
}

Namespace.register("Comtop.EIC");

Comtop.EIC.WordExport = function(option) {
	this.options = {
		userId : option.userId,
		wordId : option.wordId,
		asyn : option.asyn,
		webRoot : option.webRoot,
		param : option.param,
		sysName : option.sysName
	};
}

Comtop.EIC.WordExport.prototype = {
	showExport : function() {
		var userId = this.options.userId;
		var wordId = this.options.wordId;
		var asyn = this.options.asyn;
		var webRoot = this.options.webRoot;
		var param = this.options.param;
		var sysName = this.options.sysName;
		var r = (Math.random() + '').replace(/\./, "");
		var url = webRoot + "/eic/view/WordExport.jsp?asyn=" + asyn
				+ "&userId=" + userId + "&wordId=" + wordId + "&exparam="
				+ param + "&webroot=" + webRoot + "&sysname=" + sysName + "&r=" + r;
		if (!this.wordExportDialog) {
			this.wordExportDialog = cui.dialog( {
				title : 'µ¼³öWordÎÄµµ',
				src : url,
				width : 400,
				height : 150
			})
		}
		
		Comtop.EIC.WordExport[r] = this;
		this.wordExportDialog.show(url);
	},
	
	closeExport : function() {
		if (this.wordExportDialog) {
			this.wordExportDialog.hide();
		}
	}
}