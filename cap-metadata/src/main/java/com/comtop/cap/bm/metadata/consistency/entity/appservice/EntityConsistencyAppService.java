/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency.entity.appservice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.runtime.base.appservice.CapBaseAppService;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 实体一致性校验服务类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年6月28日 许畅 新建
 */
@SuppressWarnings("rawtypes")
@PetiteBean
public class EntityConsistencyAppService extends CapBaseAppService {
    
    /** 校验数据库statement id */
    private static final String VALIDATE_TABLE_ID = "com.comtop.cap.bm.metadata.consistency.entity.validateIsExistTable";
    
    /** 日志 */
    private final static Logger LOGGER = LoggerFactory.getLogger(EntityConsistencyAppService.class);
    
    /**
     * 校验数据表是否存在
     * 
     * @param entity
     *            实体对象
     * @return 表的数量
     */
    public Integer validateIsExistTable(EntityVO entity) {
        Integer tables = null;
        try {
            tables = (Integer) capBaseCommonDAO.selectOne(VALIDATE_TABLE_ID, entity);
        } catch (Exception e) {
            LOGGER.debug(e.getMessage(), e);
        }
        
        return tables;
    }
    
    /**
     * 校验数据表是否存在
     * 
     * @param entity
     *            实体对象
     * @return 表的数量
     */
    public boolean checkTableIsExist_oracle(EntityVO entity) {
        Integer tables = this.validateIsExistTable(entity);
        return tables != null;
    }
}
