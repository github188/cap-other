?;(function($, C) {

    /**
     * 获取字符串字节数
     * @param str 字符串
     * @return {Number}
     */
    C.UI.getBytesLength = function(str) {
        var len = 0;
        for (var i = 0; i < str.length; i++) {
            var c = str.charCodeAt(i);
            //单字节加1
            if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {
                len ++;
            } else {
                len += 2;
            }
        }
        return len;
    }

    /**
     * 截取多少个字节
     * @param str 字符串
     * @param length 字节数
     * @return {String}
     */
    C.UI.intercept = function(str, length) {
        var temp = '';
        var w = 0;

        for (var i = 0; i < str.length; i++) {
            var c = str.charCodeAt(i);
            //单字节加1
            if ((c >= 0x0000 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {
                w++;
            }
            else {
                w+=2;
            }
            if (w <= length) {
                temp += str.charAt(i);
            } else {
                break;
            }
        }

        return temp;
    }
})(window.comtop.cQuery, window.comtop);