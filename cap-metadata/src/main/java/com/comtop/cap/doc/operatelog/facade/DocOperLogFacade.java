
package com.comtop.cap.doc.operatelog.facade;

/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

import java.util.List;
import java.util.Map;

import com.comtop.cap.doc.operatelog.appservice.DocOperLogAppService;
import com.comtop.cap.doc.operatelog.model.DocOperLogVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * FIXME 类注释信息
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月10日 lizhiyong
 */
@PetiteBean
public class DocOperLogFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected DocOperLogAppService docOperLogAppService;
    
    /**
     * 
     * 新增操作记录
     *
     * 
     * @param operLogVO 操作记录
     * @return 操作记录Id
     */
    public String inserOperLog(DocOperLogVO operLogVO) {
        return docOperLogAppService.inserOperLog(operLogVO);
    }
    
    /**
     * 
     * 更新操作结果
     * 
     * @param operLogId 操作记录Id
     * @param result 操作结果
     */
    public void updateOperResult(String operLogId, String result) {
        docOperLogAppService.updateOperResult(operLogId, result);
    }
    
    /**
     * 分页查询操作记录条数
     * 
     * @param docOperLog 查询条件
     * @return map对象
     */
    public int queryOperLogCountByPage(DocOperLogVO docOperLog) {
        return docOperLogAppService.queryOperLogCountByPage(docOperLog);
    }
    
    /**
     * 分页查询操作记录列表
     * 
     * @param docOperLog 查询条件
     * @return map对象
     */
    public List<DocOperLogVO> queryOperLogListByPage(DocOperLogVO docOperLog) {
        return docOperLogAppService.queryOperLogListByPage(docOperLog);
    }
    
    /**
     * 更新
     * 
     * @param id 主键
     * @param properties 属性集
     *
     */
    public void updatePropertiesById(String id, Map<String, Object> properties) {
        docOperLogAppService.updatePropertiesById(id, properties);
    }
    
    /**
     * 更新
     * 
     * @param id 主键
     * @param property 属性
     * @param value 值
     *
     */
    public void updatePropertyById(String id, String property, Object value) {
        docOperLogAppService.updatePropertyById(id, property, value);
    }
    
    /**
     * 删除操作记录
     * 
     * @param docOperLogList 操作记录
     */
    public void deleteOperLog(List<DocOperLogVO> docOperLogList) {
        docOperLogAppService.deleteOperLog(docOperLogList);
    }
}
