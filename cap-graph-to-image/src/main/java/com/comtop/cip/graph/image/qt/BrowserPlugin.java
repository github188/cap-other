/******************************************************************************
* Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
* All Rights Reserved.
* 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
* 复制、修改或发布本软件.
*****************************************************************************/

package com.comtop.cip.graph.image.qt;

/**
 * @author  杨赛
 * @since   jdk1.6
 * @version 2016年12月1日 杨赛
 */
public interface BrowserPlugin {
	
	/**
	 * 在浏览器中做些什么，具体要做什么插件自己实现。
	 * @param browser 浏览器对象
	 */
	void done(Browser browser);
}
