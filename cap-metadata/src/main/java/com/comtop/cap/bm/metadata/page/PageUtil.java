/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.preferencesconfig.PreferenceConfigQueryUtil;
import com.comtop.top.core.util.StringUtil;

/**
 * @author luozhenming
 *
 */
public class PageUtil {
    
    /**
     * 获取页面访问url的后缀
     * 
     * @return 字符串
     */
    public static final String getPageUrlSuffix() {
        String strPageUrlSuffix = PreferenceConfigQueryUtil.getPageUrlSuffix();
        if (!StringUtil.isBlank(strPageUrlSuffix)) {
            return strPageUrlSuffix;
        }
        String strFramewok = PreferenceConfigQueryUtil.getGenerateCodeFramework();
        if (PreferenceConfigQueryUtil.GENERATECODE_FRAMEWORK_SPRING.equals(strFramewok)) {
            return ".bpms";
        }
        return ".ac";
    }
    
    /**
     * 返回页面的URL
     * 
     * @param page 页面对象
     * @return URL
     */
    public static final String getPageUrl(BaseModel page) {
        String pageUrlPrefix = PreferenceConfigQueryUtil.getPageUrlPrefix();
        String strPageModeName = page.getModelName();
        strPageModeName = strPageModeName.substring(0, 1).toLowerCase() + strPageModeName.substring(1);
        
        String urlPath = page.getModelPackage().replaceAll(pageUrlPrefix, "").replaceAll("\\.", "/");
        
        return "/" + urlPath + "/" + strPageModeName + getPageUrlSuffix();
    }
    
    /**
     * 返回页面的在web下的文件目录
     * 
     * @param modelPackage 页面对象
     * @return URL
     */
    public static final String getPageFilePath(String modelPackage) {
        String pageUrlPrefix = PreferenceConfigQueryUtil.getPageUrlPrefix();
        return "/" + modelPackage.replaceAll(pageUrlPrefix, "").replaceAll("\\.", "/") + "/";
    }
    
    /**
     * 返回页面的在web下的文件目录
     * 
     * @param modelPackage 页面对象
     * @return URL
     */
    public static final String replaceUrlPrefix(String modelPackage) {
        String pageUrlPrefix = PreferenceConfigQueryUtil.getPageUrlPrefix();
        return modelPackage.replaceAll(pageUrlPrefix, "");
    }
    
    /**
     * 返回页面的在web下的文件目录
     * 
     * @param modelPackage 页面对象
     * @param modelName 文件名称
     * @return URL
     */
    public static final String getPageURL(String modelPackage, String modelName) {
        if (modelName == null || modelName.length() == 0) {
            return "";
        }
        String strUrlPath = getPageFilePath(modelPackage);
        String strPageModelName = modelName.substring(0, 1).toLowerCase() + modelName.substring(1);
        String strURL = strUrlPath + strPageModelName + getPageUrlSuffix();
        return strURL;
    }
}
