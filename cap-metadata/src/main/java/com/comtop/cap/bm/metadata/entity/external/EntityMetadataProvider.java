/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.external;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.constant.NumberConstant;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 实体元数据提供的相关接口
 *
 *
 * @author zhuhuanhui
 * @since jdk1.6
 * @version 2016年7月19日 zhuhuanhui
 */
@DwrProxy
public class EntityMetadataProvider {
    
    /** 实体Facade */
    private final EntityFacade entityFacade = AppContext.getBean(EntityFacade.class);
    
    /**
     * 获取本实体及所有父实体的所有方法
     *
     * @param modelId 模块Id
     * @return 页面集合
     */
    @RemoteMethod
    public Map<String, Object> querySelfAndParentMethods(String modelId) {
        Map<String, Object> objResult = new HashMap<String, Object>();
        if (StringUtils.isBlank(modelId)) {
            objResult.put("result", NumberConstant.ZERO);
            objResult.put("message", "参数值不能为空！");
        } else {
            List<MethodVO> lstMethod = entityFacade.getSelfAndParentMethods(modelId);
            objResult.put("result", NumberConstant.ONE);
            objResult.put("message", "查询成功！");
            objResult.put("dataList", lstMethod);
        }
        return objResult;
    }
}
