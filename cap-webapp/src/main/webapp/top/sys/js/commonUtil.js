//���ַ����г��������滻Ϊ...
function cutOutSide(str,len){
	if(isOutside(str,len)){
		return cutStr(str,len)+'...';
	}else{
		return str;
	}
}

//���ַ����سɹ̶�����
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

//�ж�һ����Ӣ�Ļ�ϵ��ַ����Ƿ񳬳�
function isOutside(str,len){
    if(str.replace (/[^\x00-\xff]/g,"rr").length > len){
        return true
    }else{
        return false
    }
}


//������ٲ�ѯ�ؼ����ַ���
function handleStr(str){
	str = str.replace(new RegExp("/", "gm"), "//");
	str = str.replace(new RegExp("%", "gm"), "/%");
	str = str.replace(new RegExp("_", "gm"), "/_");
	str = str.replace(new RegExp("'", "gm"), "''");
	return str;
}

//��ȡ���������
function getExplorer() {
	var explorer = window.navigator.userAgent ;
	//ie �����
	if (explorer.indexOf("MSIE") >= 0) {
		return "ie";
	}
	//firefox ��������
	else if (explorer.indexOf("Firefox") >= 0) {
		return "Firefox";
	}
	//Chrome �ȸ������
	else if(explorer.indexOf("Chrome") >= 0){
		return "Chrome";
	}
	//Opera �����
	else if(explorer.indexOf("Opera") >= 0){
		return "Opera";
	}
	//Safari
	else if(explorer.indexOf("Safari") >= 0){
		return "Safari";
	}
}
