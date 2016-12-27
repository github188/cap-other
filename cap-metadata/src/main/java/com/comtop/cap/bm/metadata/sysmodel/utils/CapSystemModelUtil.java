/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.sysmodel.utils;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.cap.bm.metadata.pkg.model.PackageVO;
import com.comtop.top.core.jodd.AppContext;

/**
 * CAP系统模块工具类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年7月11日 许畅 新建
 */
public final class CapSystemModelUtil {
    
    /** 日志 */
    private final static Logger LOGGER = LoggerFactory.getLogger(CapSystemModelUtil.class);
    
    /**
     * 构造方法
     */
    private CapSystemModelUtil() {
        
    }
    
    /**
     * 实体查询CapPackageVO
     * 
     * @param entityVO
     *            实体
     * @return CapPackageVO
     */
    public static CapPackageVO queryCapPackageByEntity(EntityVO entityVO) {
        String expression = entityVO.getModelPackage() + "/package[@moduleId='" + entityVO.getPackageId() + "']";
        return queryCapPackage(expression);
    }
    
    /**
     * 页面查询CapPackageVO
     * 
     * @param pageVO 页面
     * @return CapPackageVO
     */
    public static CapPackageVO queryCapPackageBypage(PageVO pageVO) {
        if (StringUtil.isEmpty(pageVO.getModelPackageId())) {
            SysmodelFacade sysmodelFacade = AppContext.getBean(SysmodelFacade.class);
            PackageVO vo = sysmodelFacade.queryPackageVOByPath(pageVO.getModelPackage());
            if (vo != null)
                pageVO.setModelPackageId(vo.getId());
        }
        
        String expression = pageVO.getModelPackage() + "/package[@moduleId='" + pageVO.getModelPackageId() + "']";
        return queryCapPackage(expression);
    }
    
    /**
     * 查询 CapPackageVO
     * 
     * @param expression
     *            xpath表达式
     * @return CapPackageVO
     */
    private static CapPackageVO queryCapPackage(String expression) {
        CapPackageVO capPackageVO = null;
        try {
            List<CapPackageVO> capPackageVOs = CacheOperator.queryList(expression, CapPackageVO.class);
            if (capPackageVOs != null && capPackageVOs.size() > 0) {
                capPackageVO = capPackageVOs.get(0);
            }
        } catch (OperateException e) {
            LOGGER.error("查询模块代码路径失败:" + e.getMessage(), e);
        }
        return capPackageVO;
    }
    
}
