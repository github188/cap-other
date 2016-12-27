/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.sysmodel.facade;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 保存模块首页代码存放路径Facade类
 *
 * @author 刘城
 * @since jdk1.6
 * @version 2016年7月20日 刘城
 */
@PetiteBean
public class PackageObjectFacade extends CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(PackageObjectFacade.class);
    
    /**
     * 删除模型
     *
     * @param models ID集合
     * @return 是否成功
     */
    @RemoteMethod
    public boolean delPackages(String[] models) {
        boolean bResult = true;
        try {
            for (int i = 0; i < models.length; i++) {
                CapPackageVO.deleteModel(models[i]);
            }
        } catch (Exception e) {
            bResult = false;
            LOG.error("删除Package文件失败", e);
        }
        return bResult;
    }
    
    /**
     * 保存服务
     * 
     * @param capPackageVO 被保存的服务对象
     * @return 实体对象
     * @throws ValidateException 校验失败异常
     */
    @RemoteMethod
    public CapPackageVO saveCapPackageVO(CapPackageVO capPackageVO) throws ValidateException {
        boolean bResult = capPackageVO.saveModel();
        return bResult ? capPackageVO : null;
    }
}
