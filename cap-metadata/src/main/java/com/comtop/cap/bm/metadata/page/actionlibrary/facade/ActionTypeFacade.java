/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.actionlibrary.facade;

import java.util.List;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.model.CuiTreeNodeVO;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.page.actionlibrary.model.ActionTypeVO;
import com.comtop.cap.bm.metadata.page.favorites.facade.FavoritesFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 行为分类facade类
 *
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-6-03 诸焕辉
 */
@DwrProxy
@PetiteBean
public class ActionTypeFacade extends CapBmBaseFacade {
    
    /**
     * 行为定义facade
     */
    @PetiteInject
    private ActionDefineFacade actionDefineFacade;
    
    /**
     * 收藏夹facade
     */
    @PetiteInject
    private FavoritesFacade favoritesFacade;
    
    /**
     * 根据行为类型模版Id，加载模型文件
     * 
     * @param modelId 行为类型模版Id
     * @return 操作结果
     * @throws OperateException 操作异常
     * @throws ValidateException 校验异常
     */
    @RemoteMethod
    public ActionTypeVO loadModel(String modelId) throws OperateException, ValidateException {
        ActionTypeVO objActionTypeVO = (ActionTypeVO) CacheOperator.readById(modelId);
        if (objActionTypeVO == null) {
            objActionTypeVO = ActionTypeVO.createMetaDataFile(modelId);
        }
        return objActionTypeVO;
    }
    
    /**
     * 查询
     * 
     * @param modelId 模型Id
     * @param condition 条件
     * @return 操作结果
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<CuiTreeNodeVO> search(String modelId, String condition) throws OperateException {
        return ActionTypeVO.search(modelId, condition);
    }
    
    /**
     * 保存
     *
     * @param model 被保存的对象
     * @return 是否成功
     * @throws ValidateException 异常
     */
    @RemoteMethod
    public boolean saveModel(ActionTypeVO model) throws ValidateException {
        return model.saveModel();
    }
    
}
