/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.image;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cip.graph.image.qt.Browser;
import com.comtop.cip.graph.image.qt.ScreenshotPlugin;
import com.trolltech.qt.gui.QApplication;

/**
 * 生成图片工具类
 * 
 * @author duqi
 */
public class GraphToImageTool {
    
    /**
     * 日志
     */
    private static Logger LOGGER;
    
    // http://127.0.0.1:8080/web/cip/graph/editor/Editor.jsp?moduleId=-1&diagramType=logic
    // http://127.0.0.1:8080/web/cip/graph/ModuleRelationGraph.jsp
    
    /**
     * 初始换日志文件目录
     * 
     * @param logDir
     *            日志目录
     */
    private static void initLogDir(String logDir) {
        String finalLogDir = logDir;
        if (finalLogDir == null || finalLogDir.length() == 0) {
            finalLogDir = System.getProperty("user.dir");
        }
        System.setProperty("logs.home", finalLogDir);
        LOGGER = LoggerFactory.getLogger(GraphToImageTool.class);
    }
    
    /**
     * 使用WebKit内置浏览器打开页面，并进行截图操作。 
     * @param pageUrl	需要截图的页面访问地址
     * @param cookieString	访问cookieString（将会使用Base64算法解密），访问页面需要登录时使用
     * @param browserWidth	用于打开页面的浏览器宽度
     * @param browserHeight 用于打开页面的浏览器高度
     * @param imagePath	截图后图片保存的位置
     * @param selector 元素选择器，用于确定截图的页面内容, 可选参数，若为空则截取整个页面。<br/>
     * 示例：
     * <ul>
     * <li>#pageRoot 表示id为pageRoot的元素内的内容将会被截图</li>
     * <li>.geDiagramContainer 表示样式为geDiagramContainer的元素内的内容将会被截图</li>
     * </ul>
     */
    public static void screenshot(String pageUrl, String cookieString, String browserWidth, String browserHeight, String imagePath, String selector) {
        LOGGER.info("图片生成工具启动成功。");
        String[] initArgs = new String[1];
        QApplication.initialize(initArgs);
        Browser browser = null;
        // 在浏览器打开之前，设置浏览器的分辨率
        if (null != browserWidth && browserWidth.length() > 0 && null != browserHeight && browserHeight.length() > 0) {
            browser = new Browser(Integer.parseInt(browserWidth), Integer.parseInt(browserHeight));
        }else {
        	browser = new Browser();
        }
        browser.addPlugin(new ScreenshotPlugin(imagePath, selector));
        browser.open(pageUrl, cookieString);
//      browser.show();
        
        QApplication.execStatic();
        QApplication.shutdown();
    }
    
    /**
     * 入口函数
     * 
     * @param args 请求参数， {@link com.comtop.cip.graph.image.GraphToImageToolTest#testMain()}
     */
    public static void main(String[] args) {
        if (args.length < 2) {
            System.exit(1);
        }
        String url = null;
        String imagePath = null;
        String logDir = null;
        String cookieString = null;
        String width = null;
        String height = null;
        String selector = null;
        for (int i = 0; i < args.length; i++) {
            String param = args[i];
            if (i == 0) {
                url = param;
                continue;
            }
            if (i == 1) {
                imagePath = param;
                continue;
            }
            if (param == null) {
                continue;
            }
            if (param.startsWith("logdir=")) {
                logDir = param.replaceFirst("logdir=", "");
            } else if (param.startsWith("logdir")) {
                logDir = param.replaceFirst("logdir", "");
            }
            if (param.startsWith("cookies")) {
                cookieString = param.replaceFirst("cookies", "");
            }
            if (param.startsWith("width=")) {
                width = param.replaceFirst("width=", "");
            }
            if (param.startsWith("height=")) {
                height = param.replaceFirst("height=", "");
            }
            if (param.startsWith("selector=")) {
            	selector = param.replaceFirst("selector=", "");
            }
        }
        initLogDir(logDir);
        for (int i = 0; i < args.length; i++) {
            LOGGER.info("传入参数" + i + ":" + args[i]);
        }
        
        screenshot(url, cookieString, width, height, imagePath, selector);
    }
}
