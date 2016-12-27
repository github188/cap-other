//比较时间的大小
	function comparedate(strDate1,strDate2){
		if(formatdate(strDate1,"-") == formatdate(strDate2,"-")){
			return 0;
		}else{
			if(formatdate(strDate1,"-") > formatdate(strDate2,"-")){
				return -1;
			}else{
				return 1;
			}
		}
	}

	//对时间进行格式化
	function formatdate(strDate,strSep){
		var strRet="";

		var strYear=strDate.substr(0,4);
		var strMonth="";
		var strDay="";
		if(isDigit(strDate.substr(6,1))){
			strMonth=strDate.substr(5,2);
			strDay=strDate.substr(8,strDate.length);
		}else{
			strMonth="0"+strDate.substr(5,1);
			strDay=strDate.substr(7,strDate.length);
		}

		if(strDay.length<2)strDay="0"+strDay;

		strRet=strYear+strSep+strMonth+strSep+strDay;

		return strRet;
	}
	
	//判断是否为数字
	function isDigit(num) {
	    var string="1234567890";
	    if (string.indexOf(num) != -1) {
	        return true;
	    }
	    return false;
	}