var LODOP;

/* 
 * 初始化打印控件
 * taskName 打印任务名
 *
 * paperSize 纸张大小"A3"、"A4"
 * orientation 纸张打印方向 1为纵向，2为横向
 * strTaskName 打印任务名
 */
function initLodop(strPaperSize,intOrient,strTaskName){
    LODOP=getLodop(document.getElementById('LODOP'),document.getElementById('LODOP_EM'));
    if(null == LODOP || 'undefined' == LODOP ){
        return false;
    }
    
    LODOP.PRINT_INIT(strTaskName);
    LODOP.SET_PREVIEW_WINDOW(1,2,1,0,0,"");
    
    //intOrient 1纵向 2横向
    //strPaperSize A3|A4
    LODOP.SET_PRINT_PAGESIZE(intOrient,0,0,strPaperSize);
    
    LODOP.SET_SHOW_MODE("HIDE_PAPER_BOARD",1);
    LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT",'Auto-Width');
    LODOP.SET_SHOW_MODE("HIDE_PAGE_PERCENT",true);
    LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED",1);
    LODOP.SET_SHOW_MODE("AUTO_CLOSE_PREWINDOW",1);
    return true;
}

/* 
 * 加载打印内容
 * paperSize 纸张大小"A3"、"A4"
 * orientation 纸张打印方向 1为纵向，2为横向
 */
function printLoop(strType,strContent){
    if(null == LODOP || 'undefined' == LODOP ){
        return false;
    }
    var tmpArr = strContent;
    for(var i = 0 ; i < tmpArr.length;i++){
    	alert(i);
        if(i!=0)
            LODOP.NewPageA();
        if('URL' == strType){
            LODOP.ADD_PRINT_TBURL('5%','1%','95%','95%',tmpArr[i]);
        }else if('HTM' == strType || 'HTML' == strType){
            LODOP.ADD_PRINT_HTM('5%','1%','95%','95%',tmpArr[i]);
        }
        LODOP.SET_PRINT_STYLEA(0,"TableHeightScope",1);
    }
}

/* 
 * 打印
 * paperSize 纸张大小"A3"、"A4"
 * orientation 纸张打印方向 1为纵向，2为横向
 * strTaskName 打印任务名
 * strType 添加内容类别
 * strContent 内容
 * arrCss  打印样式
 */
function doPrint(paperSize,orientation,strTaskName,strType,strContent,arrCss){
	try{
	    initLodop(paperSize,orientation,strTaskName);
	    
	    if(null == LODOP || 'undefined' == LODOP ){
	        return -1;
	    }
	}catch(err){
		//alert("本机未安装Lodop控件!");
		if(confirm("本机未安装Lodop控件，是否下载安装!")){
			window.open(install_lodop_Url);
		}
        return -1; 
	}
    addPrintContent(strType,strContent,arrCss);
    return LODOP.PRINTA();
}

/* 
 * 打印预览
 * paperSize 纸张大小"A3"、"A4"
 * orientation 纸张打印方向 1为纵向，2为横向
 * strTaskName 打印任务名
 * strType 添加内容类别
 * strContent 内容
 * arrCss  打印样式
 */
function doPrintPreview(paperSize,orientation,strTaskName,strType,strContent,arrCss){
	try{
		initLodop(paperSize,orientation,strTaskName);
	    
	    if(null == LODOP || 'undefined' == LODOP ){
	        return -1;
	    }
	}catch(err){
		//alert("本机未安装Lodop控件!");
		if(confirm("本机未安装Lodop控件，是否下载安装!")){
			window.open(install_lodop_Url);
		}
		
        return -1; 
	}
    
    
    addPrintContent(strType,strContent,arrCss);
    return LODOP.PREVIEW();
}

/* 
 * 添加打印内容
 * strType 添加内容类别
 * strContent 内容
 */
function addPrintContent(strType,strContent,arrCss){
    /*
     if('url' == strType){
     if(null == LODOP || 'undefined' == LODOP ){
     return false;
     }
     var tmpArr = strContent.split(";");

     for(var i = 0 ; i < tmpArr.length;i++){
     if(i!=0)
     LODOP.NewPageA();
     LODOP.ADD_PRINT_TBURL('5%','1%','95%','95%',tmpArr[i]);
     LODOP.SET_PRINT_STYLEA(0,"TableHeightScope",1);
     }
     }
     */

    if(null == LODOP || 'undefined' == LODOP ){
        return false;
    }
    
    //获取打印样式
    var strCss = "";
    if('HTM' == strType || 'HTML' == strType){
    	strCss = getPrintCss(arrCss);
    }    
   
    var tmpArr = strContent;
    var resultConent = strCss;
    
    for(var i = 0 ; i < tmpArr.length;i++){
        if(i!=0)
            LODOP.NewPageA();
        if('URL' == strType){
            LODOP.ADD_PRINT_URL('5%','1%','95%','95%',tmpArr[i]);
        }else if('HTM' == strType || 'HTML' == strType){
        	resultConent = strCss + "<body>" + tmpArr[i] + "</body>";
            LODOP.ADD_PRINT_HTM('5%','1%','95%','95%',resultConent);
        }
        LODOP.SET_PRINT_STYLEA(0,"TableHeightScope",1);
    }
}

/**
 * 获取打印样式
 * @param arrCss　样式数组
 * @return 组装样式
 */
function getPrintCss(arrCss){
    var strCss = "<style>";
    
	for(var i=0,j=arrCss.length; i < j; i++){
		if(arrCss[i].indexOf('/') == 0){
			$.ajax({
	            url: arrCss[i],
	            async: false,
	            dataType: 'text',
	            success: function(data){
				   strCss = strCss + "\r\n" + data;             
			    },
	            error: function(){
	                //alert('\'加载模板出错，请检查下网络或模板文件是否存在\'');
	            }
	        });		  
		}else{
			strCss = strCss + "\r\n" + arrCss[i];   
		}		 
	}
	strCss  = strCss + "\r\n" + "</style>";
	return strCss;
}

//获取所有加载JS文件
var jsFileArray = document.scripts;
//获取JS文件集合内最后一个JS文件,也就是当前JS文件
var jsFile = jsFileArray[jsFileArray.length-1]
//截取当前JS文件的路径,返回打印工具的路径
var install_lodop_Url = jsFile.src.substring(0,jsFile.src.lastIndexOf("/js/")+1) + "install/install_lodop.exe";

function installLodop(){
	window.location.href = install_lodop_Url;
}

function getLodop(oOBJECT,oEMBED){
    /**************************
     本函数根据浏览器类型决定采用哪个对象作为控件实例：
     IE系列、IE内核系列的浏览器采用oOBJECT，
     其它浏览器(Firefox系列、Chrome系列、Opera系列、Safari系列等)采用oEMBED。
     **************************/
	/*var strHtml1="<script language='javascript'>function installLodop(){window.location.href = '/web/component/lodop/install/install_lodop.exe';}</script><br><font color='#FF00FF'>打印控件未安装!点击这里<a href='#' onclick='javascript:installLodop()'>执行安装</a>,安装后重新进入。</font>";
    var strHtml2="<script language='javascript'>function upgradeLodop(){window.location.href = '/web/component/lodop/install/install_lodop.exe';}</script><br><font color='#FF00FF'>打印控件需要升级!点击这里<a href='#' onclick='javascript:upgradeLodop()'>执行升级</a>,升级后请重新进入。</font>";*/
	var strHtml1="<script language='javascript'>function installLodop(){window.location.href = '"+install_lodop_Url+"';}</script><br><font color='#FF00FF'>打印控件未安装!点击这里<a href='#' onclick='javascript:installLodop()'>执行安装</a>,安装后重新进入。</font>";
	var strHtml2="<script language='javascript'>function upgradeLodop(){window.location.href = '"+install_lodop_Url+"';}</script><br><font color='#FF00FF'>打印控件需要升级!点击这里<a href='#' onclick='javascript:upgradeLodop()'>执行升级</a>,升级后请重新进入。</font>";
	
    var strHtml3="<br><br><font color='#FF00FF'>注意：<br>1：如曾安装过Lodop旧版附件npActiveXPLugin,请在【工具】->【附加组件】->【扩展】中先卸它;<br>2：如果浏览器表现出停滞不动等异常，建议关闭其“plugin-container”(网上搜关闭方法)功能;</font>";
    var OLODOP=oEMBED;
    try{
        if (navigator.appVersion.indexOf("MSIE")>=0){
        	OLODOP=oOBJECT;
        }
        if ((OLODOP==null)||(typeof(OLODOP.VERSION)=="undefined")) {
            if (navigator.userAgent.indexOf('Firefox')>=0)
                document.documentElement.innerHTML=strHtml3+document.documentElement.innerHTML;
            if (navigator.appVersion.indexOf("MSIE")>=0){
            	document.write(strHtml1);
            }else{
                document.documentElement.innerHTML=strHtml1;//document.documentElement.innerHTML
            }
            return OLODOP;
        } else if (OLODOP.VERSION<"6.0.4.6") {
            if (navigator.appVersion.indexOf("MSIE")>=0)
                document.write(strHtml2);
            else
                document.documentElement.innerHTML=strHtml2+document.documentElement.innerHTML;
            return OLODOP;
        }
        //*****如下空白位置适合调用统一功能:*********

        //*******************************************
        return OLODOP;
    }catch(err){
        document.documentElement.innerHTML="Error:"+strHtml1+document.documentElement.innerHTML;
        return OLODOP;
    }
}