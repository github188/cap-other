window.comtop = window.comtop || {};
window.comtop.tool = window.comtop.tool || {};
/**
 * 常用工具
 */
window.comtop.tool = {
    /**
     * 打开新窗口，默认情况下，新建窗口居中显示
     * （注：下面方法尽量兼容各大浏览器，对于360这类包壳的不作任何兼容测试）
     * @param url {String} 新窗口URL
     * @param name {String} 新窗口name
     * @param params {Object} 新窗口配置参数
     * @returns {window} 新窗口对象
     * @example
     * 1)comtop.tool.openWindow('http://www.baidu.com', 'baiduWin', {width:500, height:200});
     * 2)comtop.tool.openWindow('http://www.baidu.com', 'baiduWin', {fullscreen:1, channelmode:1});//满屏显示
     * @Author chaoqun.lin
     */
    openWindow: function(url, name, params){
        //下面配置参数并不全部，只是放置各大浏览器普遍支持的参数
        var default_params = {
            width: 300,
            height: 200,
            toolbar:0,      //Chrome不支持
            menubar:0,      //Chrome Opera 中，不论 "menubar" 值如何设置，永远不显示菜单栏。
            scrollbars:0,   //Safari Chrome 中，在页面存在滚动条的情况下，无论 "scrollbars"值如何设置，滚动条始终可见。
            location:0,     //Safari 中，开启 "location" 选项与开启 "toolbar" 选项时显示效果一致
            status:0,       //Firefox 中，无论 "status" 值如何设置，状态栏始终可见，而 Chrome Opera 中，则与前者相反，状态栏始终不可见。
         //   fullscreen:0,   //只有IE支持，其它标准浏览器出于安全考虑均不支持
            resizeable:0    //Firefox Safari Chrome Opera 中，无论 "resizable"值如何设置，窗口永远可由用户调整大小。
        };
 
        for(var i in default_params){
            if(typeof params[i] != 'undefined'){
                default_params[i] = params[i];
            }
        }
        //Chrome Opera 中，不支持在没有设定 "width" 与 "height" 值的情况下独立使用 "left" 和 "top"，此时 "left" "top" 设定值均不生效
        default_params.top = typeof params.top == 'undefined' ?
            (window.screen.availHeight - 30 - default_params.height)/2 : params.top;
        default_params.left = typeof params.left == 'undefined' ?
            (window.screen.availWidth - 10 - default_params.width)/2 : params.left;

        var paramArray = [];
        for(i in default_params){
            paramArray.push(i + '=' + default_params[i]);
        } 
        return window.open(url, name, paramArray.join(','));
    },
    
    /**
     * [safeHtml 过滤html尖括号("<,>,u003c,u003e"),防止XSS脚本攻击].
     * 返回字符串请勿用于textarea或者input赋值.
     * @param  {[str]} html [需要传入的html代码]
     * @return {[str]}      [过滤后的html代码]
     */
    safeHtml: function (html) {
    	if(!html){
           return html;
    	}else{
    		 return html.toString().replace(/<|u\s*0\s*0\s*3\s*c/ig, "&lt;").replace(/>|u\s*0\s*0\s*3\s*e/ig, "&gt;");
    	}
    }
};
