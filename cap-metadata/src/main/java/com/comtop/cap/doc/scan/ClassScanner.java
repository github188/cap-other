/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.scan;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.scan.Resource;
import com.comtop.cap.document.scan.asm.ClassReader;
import com.comtop.cap.document.scan.support.PathMatchingResourcePatternResolver;
import com.comtop.cap.document.scan.support.ResourcePatternResolver;
import com.comtop.cap.document.scan.util.ScanStringUtils;

/**
 * CAP文档管理工程_类扫描器
 * 
 * @author 李小强
 * @since 1.0
 * @version 2015-11-18 李小强
 */

public final class ClassScanner {
    
    /** 资源扫描器 */
    private static final ResourcePatternResolver OBJ_RES_PATTERN = new PathMatchingResourcePatternResolver();
    
    /** 日志对象 */
    private static final Logger LOGGER = LoggerFactory.getLogger(ClassScanner.class);
    
    /**
     * 构造函数
     */
    private ClassScanner() {
        
    }
    
    /**
     * 处理表达式获取所对应有类资源,每次处理一段scan
     * 
     * @param scanRegex 扫描正则表达式
     * @return 解析符合注册规则的服务类、方法描述
     */
    public static List<Class<?>> scanClass(String[] scanRegex) {
        List<Class<?>> lstServiceVo = new ArrayList<Class<?>>();
        try {
            // 第一步：扫描的类的表达式格式转换
            
            for (int k = 0; k < scanRegex.length; k++) {
                String strRegex = getResourcePattern(scanRegex[k]);
                // 第二步：扫描类资源
                Resource[] objResources = OBJ_RES_PATTERN.getResources(strRegex);
                Class<?> objClazz = null;
                for (int i = 0, j = objResources.length; i < j; i++) {
                    // 只处理class
                    if (objResources[i].getFilename().endsWith("class")) {
                        // 第三步：解析需要注册类、方法信息
                        objClazz = reflectClass(getClassName(objResources[i]));
                        if (null != objClazz) {
                            lstServiceVo.add(objClazz);
                        }
                    }
                }
            }
            
        } catch (IOException e) {
            LOGGER.error("注册服务失败，按指定规则：" + toString(scanRegex) + "进行扫描时，出现异常。", e);
        }
        return lstServiceVo;
    }
    
    /**
     * 字符串数组转为字符串
     *
     * @param inputs 字符串数组
     * @return 字符串
     */
    private static String toString(String[] inputs) {
        StringBuffer sb = new StringBuffer();
        sb.append('[').append(inputs[0]);
        for (int i = 1; i < inputs.length; i++) {
            sb.append(',').append(inputs[i]);
        }
        sb.append(']');
        return sb.toString();
    }
    
    /**
     * 反射类
     * 
     * @param className 类名
     * @return 类对象
     */
    private static Class<?> reflectClass(String className) {
        if (ScanStringUtils.isBlank(className)) {
            return null;
        }
        try {
            Class<?> objClazz = Class.forName(className);
            // 如果当前类是成员类--内部类，则直接返回null,
            if (objClazz.isMemberClass()) {
                return null;
            }
            return objClazz;
        } catch (Throwable e) {
            LOGGER.warn("扫描类装载失败!通过Class.forName((String className)注册类:" + className + "失败，请检查类路径是否指定正确、类是否能被装载", e);
            return null;
        }
    }
    
    /**
     * 根据资源信息获取className
     * 
     * @param resource
     *            资源
     * @return 资源的className
     */
    private static String getClassName(Resource resource) {
        InputStream objIs = null;
        ClassReader objClassReader = null;
        try {
            objIs = resource.getInputStream();
            // 类文件字节码读取对象
            objClassReader = new ClassReader(objIs);
            return objClassReader.getClassName().replaceAll("\\/", "\\.");
        } catch (IOException e) {
            LOGGER.error("扫描类文件出现异常。", e);
            return "";
        } finally {
            try {
                if (objIs != null) {
                    objIs.close();
                }
            } catch (IOException e) {
                LOGGER.error("扫描类文件出现异常。", e);
            }
        }
    }
    
    /**
     * 截取需要扫描的类的表达式，--类表达式截取 org.apache.**.BeanMap(test*,demo*)
     * 
     * @param regexStr
     *            原正则表达式
     * @return 格式化后的内容
     */
    private static String getResourcePattern(String regexStr) {
        String[] strRegx = regexStr.split("\\(");
        String strTemp = strRegx[0].replace(".", "/");
        strTemp = "classpath*:" + (strTemp.endsWith("*") ? strTemp : strTemp + ".class");
        return strTemp;
    }
}
