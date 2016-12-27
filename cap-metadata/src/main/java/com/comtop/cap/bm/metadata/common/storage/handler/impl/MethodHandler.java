/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage.handler.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.handler.DataHandlerStrategy;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * 方法处理策略
 * 
 * @author 林玉千
 * @version jdk1.6
 * @version 2016-5-20 林玉千
 */
public class MethodHandler implements DataHandlerStrategy {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(MethodHandler.class);
    
    /**
     * 数据的模型类型
     * 
     * @see com.comtop.cap.bm.metadata.common.storage.handler.DataHandlerStrategy#getModelType()
     */
    @Override
    public String getModelType() {
        return "entity";
    }
    
    /**
     * 对方法的别名进行处理 方法有别名，则不处理，若方法没有别名，则把方法的英文名称首写字母转小写当做别名
     * 
     * @see com.comtop.cap.bm.metadata.common.storage.handler.DataHandlerStrategy#invoke(Object)
     */
    @Override
    public void invoke(Object obj) {
        EntityVO entity = (EntityVO) obj;
        List<MethodVO> methods = entity.getMethods();
        if (methods != null) {
            for (MethodVO methodVO : methods) {
                // 当实体别名为空，进行处理
                String methodAliasName = getAliasName(methodVO);
                methodVO.setAliasName(methodAliasName);
                if (isExistAliasName(methods, methodVO)) {
                    LOG.error("元数据装载异常，实体：" + entity.getModelId() + "存在同名的方法别名,方法：" + methodVO.getEngName());
                }
            }
        }
    }
    
    /**
     * 获取当前方法的别名，如果另名为空则引用方法名
     * 
     * @param methodVO
     *            方法对象
     * @return 方法的别名
     */
    private static String getAliasName(MethodVO methodVO) {
        if (StringUtil.isBlank(methodVO.getAliasName())) {
            return methodVO.getEngName();
        }
        return methodVO.getAliasName();
    }
    
    /**
     * 检查是否存在同名的方法别名
     * 
     * @param methods 方法集合
     * @param currMehtod 当前方法对象
     * @return 如果存在则返回true,否则返回false
     */
    private static boolean isExistAliasName(List<MethodVO> methods, MethodVO currMehtod) {
        for (MethodVO methodVO : methods) {
            if (currMehtod.getMethodId().equals(methodVO.getMethodId())) {
                continue;
            }
            if (currMehtod.getAliasName().equals(methodVO.getAliasName())) {
                return true;
            }
        }
        return false;
    }
}
