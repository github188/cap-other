/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用
 * 复制、修改或发布本软件
 *****************************************************************************/

package com.comtop.cip.graph.image.utils;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.imageio.ImageIO;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cip.graph.image.GraphToImageConstants;
import com.comtop.cip.graph.image.model.ImageVO;

/**
 * 图形转图片工具类
 * 
 * @author duqi
 *
 */
public class GraphToImageUtil {
    
    /**
     * 使用WebKit内置浏览器打开页面，并进行截图操作。
     * 
     * @param pageUrl 需要截图的页面访问地址
     * @param cookieString 访问cookieString（将会使用Base64算法解密），访问页面需要登录时使用
     * @param browserWidth 用于打开页面的浏览器宽度
     * @param browserHeight 用于打开页面的浏览器高度
     * @param imagePath 截图后图片保存的位置
     * @param selector 元素选择器，用于确定截图的页面内容, 可选参数，若为空则截取整个窗口。<br/>
     *            示例：
     *            <ul>
     *            <li>#pageRoot 表示id为pageRoot的元素内的内容将会被截图</li>
     *            <li>.geDiagramContainer 表示样式为geDiagramContainer的元素内的内容将会被截图</li>
     *            </ul>
     * @param logdir 截图操作日志目录
     */
    public static void screenshot(String pageUrl, String cookieString, int browserWidth, int browserHeight,
        String imagePath, String selector, String logdir) {
        execCommand(pageUrl, imagePath, cookieString, "width=" + browserWidth, "height=" + browserHeight, "logdir="
            + logdir, "selector=" + selector);
    }
    
    /** 日志 */
    private final static Logger LOGGER = LoggerFactory.getLogger(GraphToImageUtil.class);
    
    /**
     * 执行生成图片名称
     * 
     * @param url 页面URL
     * @param imagePath 图案片保存路
     * @param cookieString cookie字符
     * @param resolution bowser的分辨率，宽度、高度
     */
    public static void execCommand(String url, String imagePath, String cookieString, String... resolution) {
        String command = getCommand(url, imagePath, cookieString, resolution);
        try {
            LOGGER.debug("执行生成图片命令" + command);
            Process process = Runtime.getRuntime().exec(getCommand(url, imagePath, cookieString, resolution));
            int flag = process.waitFor();
            if (flag == 0) {
                LOGGER.debug("生成图片命令执行成功");
            } else {
                LOGGER.error("生成图片命令执行失败，flag=" + flag);
                throw new RuntimeException("生成图片命令执行失败，flag=" + flag);
            }
        } catch (IOException e) {
            LOGGER.error("生成图片命令执行出现失败" + command, e);
            throw new RuntimeException("生成图片命令执行失败", e);
        } catch (InterruptedException e) {
            LOGGER.error("生成图片命令执行出现中断", e);
            throw new RuntimeException("生成图片命令执行出现中断", e);
        }
    }
    
    /**
     * 获得执行命令字符
     * 
     * @param url 页面url
     * @param imagePath 图片路径
     * @param cookieString cookie字符
     * @param resolution bowser的分辨率，宽度、高度
     * @return 执行命令字符
     */
    private static String getCommand(String url, String imagePath, String cookieString, String... resolution) {
        
        String jarPath = getWebinfPath() + File.separator + "cap" + File.separator + "bm" + File.separator + "graph"
            + File.separator + "jar" + File.separator + GraphToImageConstants.EXECUTE_JAR_NAME;
        StringBuffer sb = new StringBuffer();
        sb.append("java -jar");
        sb.append(" ");
        sb.append(jarPath);
        sb.append(" ");
        sb.append(url);
        sb.append(" ");
        sb.append(imagePath);
        sb.append(" ");
        if (resolution != null && resolution.length > 0) {
            for (int i = 0, len = resolution.length; i < len; i++) {
                sb.append(resolution[i]);
                sb.append(" ");
            }
        }
        // 如果没有传入日志的路径，那么使用默认的日志路径
        Pattern p = Pattern.compile("\\blogdir=.+\\b");
        Matcher m = p.matcher(sb.toString());
        if (!m.find()) {
            sb.append("logdir" + GraphToImageConstants.LOG_DIR);
        }
        if (cookieString != null) {
            sb.append(" ");
            sb.append("cookies" + Base64Util.encode(cookieString));
        }
        return sb.toString();
    }
    
    /**
     * 获取webapp路径
     *
     * @return WebinfPath
     */
    public static String getWebinfPath() {
        String classesFilePath = Thread.currentThread().getContextClassLoader().getResource("").getFile();
        File file = new File(classesFilePath);
        File parentFile = new File(file.getParent());
        // 返回webapp路径
        return parentFile.getParent();
    }
    
    /**
     * 执行图片生成命令（宽高需要一起传）
     * 
     * @param url 页面url
     * @param imageSavePath 图片保存目录路径
     * @param cookieString cookie字符
     * @param width 分辨率 宽
     * @param height 分辨率 高
     * @param logDir 日志保存目录路径
     * @return ImageVO 图片对象
     */
    public static ImageVO execExportImageCommand(String url, String imageSavePath, String cookieString, String width,
        String height, String logDir) {
        
        ImageVO objImageVO = new ImageVO();
        String name = System.currentTimeMillis() + ".png";
        String imagePath = imageSavePath + File.separator + name;
        
        String[] arrColumns = new String[3];
        if (width != null && !"".equals(width) && height != null && !"".equals(height)) {
            arrColumns[0] = "width=" + width;
            arrColumns[1] = "height=" + height;
        }
        if (logDir != null && !"".equals(logDir)) {
            arrColumns[2] = "logDir=" + logDir;
        }
        execCommand(url, imagePath, cookieString, arrColumns);
        try {
            BufferedImage image = ImageIO.read(new FileInputStream(imagePath));
            objImageVO.setHigh(image.getHeight());
            objImageVO.setWidth(image.getWidth());
        } catch (FileNotFoundException e) {
            LOGGER.error("找不到图片", e);
        } catch (IOException e) {
            LOGGER.error("读取图片出错", e);
        }
        objImageVO.setImageName(name);
        objImageVO.setImagePath(imagePath);
        return objImageVO;
    }
    
}
