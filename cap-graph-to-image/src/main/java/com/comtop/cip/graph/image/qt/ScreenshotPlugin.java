/******************************************************************************
* Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
* All Rights Reserved.
* 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
* 复制、修改或发布本软件.
*****************************************************************************/

package com.comtop.cip.graph.image.qt;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cip.graph.image.qt.Browser;
import com.comtop.cip.graph.image.qt.BrowserPlugin;
import com.trolltech.qt.core.QSize;
import com.trolltech.qt.gui.QImage;
import com.trolltech.qt.gui.QPainter;
import com.trolltech.qt.webkit.QWebElement;
import com.trolltech.qt.webkit.QWebPage;

/**
 * 浏览器页面截图插件，可以对浏览器打开的页面截图
 * @author  杨赛
 * @since   jdk1.6
 * @version 2016年12月1日 杨赛
 */
public class ScreenshotPlugin implements BrowserPlugin {

	/** 日志 */
    private static final Logger LOGGER = LoggerFactory.getLogger(ScreenshotPlugin.class);
    
    /** 截图后图片保存路径 */
    private String imagePath;
    
    /**
     * 元素选择器，用于确定截图的页面内容, 可选参数，若为空则截取整个页面。<br/>
     * 示例：
     * <ul>
     * <li>#pageRoot 表示id为pageRoot的元素内的内容将会被截图</li>
     * <li>.geDiagramContainer 表示样式为geDiagramContainer的元素内的内容将会被截图</li>
     * </ul>
     */
    private String selector;
    
    /**
	 * 构造函数
	 * @param imagePath 图片保存路径
     * @param selector 元素选择器，用于确定截图的页面内容，例如：
     * <ul>
     * <li>#pageRoot 表示id为pageRoot的元素内的内容将会被截图</li>
     * <li>.geDiagramContainer 表示样式为geDiagramContainer的元素内的内容将会被截图</li>
     * </ul>
	 */
	public ScreenshotPlugin(String imagePath, String selector) {
		this.imagePath = imagePath;
		this.selector = selector;
	}

	/**
	 * 
	 * @see com.comtop.cip.graph.image.qt.BrowserPlugin#done(com.comtop.cip.graph.image.qt.Browser)
	 */
	@Override
	public void done(Browser browser) {
		LOGGER.info("开始截图。");
		QImage img;
        if (selector != null && !selector.equals("")) {
        	img = getAssignScreenshot(selector, browser);
        } else {
        	QWebPage qpage = browser.getView().page();
        	QWebElement elemDiv = qpage.mainFrame().findFirstElement(".geDiagramContainer");
        	if(elemDiv.isNull()) {
        		img = getWindowScreenshot(browser);
        	} else {
        		img = getGraphScreenshot(browser);
        	}
        }
        img.save(imagePath);
        LOGGER.info("截图生成完成，保存到：" + imagePath);
	}
	
	
	/**
	 * 获取整个window截图页面 
	 * @param browser 浏览器对象
	 * @return 截图对象
	 */
	private QImage getWindowScreenshot(Browser browser) {
		QImage img;
		QWebPage qpage = browser.getView().page();
		qpage.setViewportSize(qpage.mainFrame().contentsSize());
        img = new QImage(qpage.mainFrame().contentsSize(), QImage.Format.Format_RGB32);
        QPainter painter = new QPainter();
        painter.begin(img);
        qpage.mainFrame().render(painter);
        painter.end();
		return img;
	}

	/**
	 * 获取graph截图，这里是特殊判断处理，目的是兼容以前代码。
	 * @param browser 浏览器对象
	 * @return 截图对象
	 */
	private QImage getGraphScreenshot(Browser browser) {
		QImage img;
		QWebPage qpage = browser.getView().page();
    	QWebElement elemDiv = qpage.mainFrame().findFirstElement(".geDiagramContainer");
		QWebElement elemSvg = qpage.mainFrame().findFirstElement(".geDiagramContainer svg");
        String minWidth = elemSvg.styleProperty("min-width", QWebElement.StyleResolveStrategy.InlineStyle);
        String minHeight = elemSvg.styleProperty("min-height", QWebElement.StyleResolveStrategy.InlineStyle);
        int minW = Integer.parseInt(minWidth.replace("px", ""));
        int minH = Integer.parseInt(minHeight.replace("px", ""));
        int w;
        int h;
        int offsetX = 30;
        int offsetY = 30;
        if (minW < 10) {
            w = 800;
            h = 600;
            browser.reSizeBrowser(900, 700);
        } else {
            w = minW;
            h = minH;
        }
        img = new QImage(new QSize(w + offsetX, h + offsetY), QImage.Format.Format_RGB32);
        QPainter painter = new QPainter();
        painter.begin(img);
        elemDiv.render(painter);
        painter.end();
        return img;
	}
	
	/**
	 * 获取指定区域的截图
	 * @param assignSelector	指定区域的元素选择器
	 * @param browser	浏览器对象
	 * @return 截图对象
	 */
	private QImage getAssignScreenshot(String assignSelector, Browser browser) {
		QImage img;
		QWebPage qpage = browser.getView().page();
		qpage.setViewportSize(qpage.mainFrame().contentsSize());
        // 根据selector获取对应的元素
        QWebElement pageArea = qpage.mainFrame().findFirstElement(assignSelector);
        if(pageArea.isNull()) {	 //不存在元素
        	LOGGER.info("截图失败，页面上不存在对应selector[{}]的元素", assignSelector);
        	throw new IllegalArgumentException("截图失败，页面上不存在对应selector[" + assignSelector +"]的元素");
        }
        img = new QImage(pageArea.geometry().size(), QImage.Format.Format_RGB32);
        QPainter painter = new QPainter();
        painter.begin(img);
        pageArea.document().render(painter, pageArea.geometry());
        painter.end();
        return img;
	}
	
	/**
	 * @return 获取 imagePath属性值
	 */
	public String getImagePath() {
		return imagePath;
	}

	/**
	 * @param imagePath 设置 imagePath 属性值为参数值 imagePath
	 */
	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	/**
	 * @return 元素选择器 <br/>
	 * 主要用于确定截图的页面内容, 可选参数，若为空则截取整个页面。<br/>
     * 示例：
     * <ul>
     * <li>#pageRoot 表示id为pageRoot的元素内的内容将会被截图</li>
     * <li>.geDiagramContainer 表示样式为geDiagramContainer的元素内的内容将会被截图</li>
     * </ul>
	 */
	public String getSelector() {
		return selector;
	}

	/**
	 * @param selector 设置 selector 属性值为参数值 selector
	 */
	public void setSelector(String selector) {
		this.selector = selector;
	}
}
