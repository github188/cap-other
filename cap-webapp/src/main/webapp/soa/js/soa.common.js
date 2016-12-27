/**
 * 判断字符串参数是否为空或未定义
 */
function checkStrEmty(strParam){
    if(strParam == null || strParam == ""
        || strParam == "undefined" || strParam == "null"){
        return true;
    }
    return false;
}

//键盘回车键进行快速查询 
function keyDownQuery(event) {
	var event = event || window.event;
	if ( event.keyCode ==13) {
		fastQuery();
	}
}
