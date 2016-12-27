//��һ���´���
function openWindow(url,windowName,iHeight,iWidth){
	var iTop = (window.screen.availHeight-30-iHeight)/2;       //��ô��ڵĴ�ֱλ��;
  var iLeft = (window.screen.availWidth-10-iWidth)/2;           //��ô��ڵ�ˮƽλ��;
	window.open(url,windowName,'height='+iHeight+',width='+iWidth+',top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,directories=no,scrollbars=yes,resizable=yes,location=no,status=no,z-look=yes,alwaysRaised=yes')
}
/******************************************
ѡ�����̴���
jsonStr ���ö˴����JSON�ַ�
webRoot web��·��
modulePath ��ϵͳ����ģ��·��
*******************************************/
function chooseProcess(jsonStr, webRoot, modulePath) {
	var url;
	if(webRoot){
		url = webRoot;
	}else{
		url = getContextPath();
	}
	if(modulePath){
		url = url + modulePath;
	}
	//������ѡ��jsp
	var iTop = (window.screen.availHeight-30-600)/2; //��ô��ڵĴ�ֱλ��;
  	var iLeft = (window.screen.availWidth-10-995)/2; //��ô��ڵ�ˮƽλ��;
  	jsonStr = encodeURI(encodeURI(jsonStr));
	var windowSrc = url+"/bpms/flex/ChooseDeployedProgress.jsp?jsonStr="+jsonStr;
	window.open(windowSrc, "ѡ������", 'height=600,width=995,top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
}

function getContextPath(){ 
	var pathName = document.location.pathname; 
	var index = pathName.substr(1).indexOf("/"); 
	var result = pathName.substr(0,index+1); 
	return result; 
} 


/******************************************
ѡ�����̽ڵ㴰��
jsonStr ���ö˴����JSON�ַ�
webRoot web��·��
modulePath ��ϵͳ����ģ��·��
*******************************************/
function chooseProcessNode(jsonStr, webRoot, modulePath) {
	var url;
	if(webRoot){
		url = webRoot;
	}else{
		url = getContextPath();
	}
	if(modulePath){
		url= url + modulePath;
	}
	//������ѡ��jsp
	var iTop = (window.screen.availHeight-30-600)/2; //��ô��ڵĴ�ֱλ��;
  	var iLeft = (window.screen.availWidth-10-995)/2; //��ô��ڵ�ˮƽλ��;
  	jsonStr = encodeURI(encodeURI(jsonStr));
	var windowSrc = url+"/bpms/flex/ChooseProcessNode.jsp?jsonStr="+jsonStr;
	window.open(windowSrc, "ѡ��ڵ�", 'height=600,width=1065,top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
}

/******************************************
����ѡ�����̽ڵ�Ļص�����
*******************************************/
function chooseNodeDataCallback(jsonStr){
	//alert(jsonStr);
}
/******************************************
����ѡ�����̵Ļص�����
*******************************************/
function chooseProcessDataCallback(jsonStr){
	//alert(jsonStr);
}