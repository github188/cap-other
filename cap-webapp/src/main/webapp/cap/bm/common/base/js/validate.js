/*
 * @author lingchen@szcomtop.com
 * @Date 2015-10-19
 */

/**
 * 校验英文名称是否符合标识符规范
 *
 * @param <code>eName</code> 英文名称
 * @return 校验结果.true:符合;false:不符合
 */
var checkEnNameChar= function(eName) {
	var regEx = "^[a-z]\\w*$";
	if(eName){
		var reg = new RegExp(regEx);
		return (reg.test(eName));
	}
	return true;
};