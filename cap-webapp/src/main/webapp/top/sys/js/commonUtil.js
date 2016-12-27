//½«×Ö·û´®ÖĞ³¬³¤²¿·ÖÌæ»»Îª...
function cutOutSide(str,len){
	if(isOutside(str,len)){
		return cutStr(str,len)+'...';
	}else{
		return str;
	}
}

//½«×Ö·û´®½Ø³É¹Ì¶¨³¤¶È
function cutStr(str,len){
	if(isOutside(str,len)){
		str = str.substr(0,len-2);
		if(isOutside(str,len)){
			str = str.substring(0,str.length-2);
			return cutStr(str,len);
		}else{
			return str;
		}
	}else{
		return str;
	}
}

//ÅĞ¶ÏÒ»¸öÖĞÓ¢ÎÄ»ìºÏµÄ×Ö·û´®ÊÇ·ñ³¬³¤
function isOutside(str,len){
    if(str.replace (/[^\x00-\xff]/g,"rr").length > len){
        return true
    }else{
        return false
    }
}


//´¦Àí¿ìËÙ²éÑ¯¹Ø¼ü×Ö×Ö·û´®
function handleStr(str){
	str = str.replace(new RegExp("/", "gm"), "//");
	str = str.replace(new RegExp("%", "gm"), "/%");
	str = str.replace(new RegExp("_", "gm"), "/_");
	str = str.replace(new RegExp("'", "gm"), "''");
	return str;
}

//»ñÈ¡ä¯ÀÀÆ÷ÀàĞÍ
function getExplorer() {
	var explorer = window.navigator.userAgent ;
	//ie ä¯ÀÀÆ÷
	if (explorer.indexOf("MSIE") >= 0) {
		return "ie";
	}
	//firefox »ğºüä¯ÀÀÆ÷
	else if (explorer.indexOf("Firefox") >= 0) {
		return "Firefox";
	}
	//Chrome ¹È¸èä¯ÀÀÆ÷
	else if(explorer.indexOf("Chrome") >= 0){
		return "Chrome";
	}
	//Opera ä¯ÀÀÆ÷
	else if(explorer.indexOf("Opera") >= 0){
		return "Opera";
	}
	//Safari
	else if(explorer.indexOf("Safari") >= 0){
		return "Safari";
	}
}
