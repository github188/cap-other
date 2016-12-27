define([webPath + "/top/sys/tools/file/underscore/underscore-min.js"], function() {
	_.templateSettings = {
	    interpolate: /\<\@\=(.+?)\@\>/gim,
	    evaluate: /\<\@([\s\S]+?)\@\>/gim,
	    escape: /\<\@\-([\s\S]+?)\@\>/gim
	};
	return _;
}); 