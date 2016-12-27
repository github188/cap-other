/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.operatelog.appservice;

import java.util.List;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.doc.operatelog.dao.DocOperLogDAO;
import com.comtop.cap.doc.operatelog.model.DocOperLogVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 文档 业务逻辑处理类
 * 
 * @author CIP
 * @since 1.0
 * @version 2015-11-9 CIP
 */
@PetiteBean
public class DocOperLogAppService extends MDBaseAppservice<DocOperLogVO> {
    
    /** 注入DAO **/
    @PetiteInject
    protected DocOperLogDAO docOperLogDAO;
    
    /**
     * 
     * 新增操作记录
     *
     * 
     * @param operLogVO 操作记录
     * @return 操作记录Id
     */
    public String inserOperLog(DocOperLogVO operLogVO) {
        return docOperLogDAO.inserOperLog(operLogVO);
    }
    
    /**
     * 
     * 更新操作结果
     * 
     * @param operLogId 操作记录Id
     * @param result 操作结果
     */
    public void updateOperResult(String operLogId, String result) {
        docOperLogDAO.updateOperResult(operLogId, result);
    }
    
    /**
     * 分页查询操作记录条数
     * 
     * @param docOperLog 查询条件
     * @return map对象
     */
    public int queryOperLogCountByPage(DocOperLogVO docOperLog) {
        return docOperLogDAO.queryOperLogCountByPage(docOperLog);
    }
    
    /**
     * 分页查询操作记录列表
     * 
     * @param docOperLog 查询条件
     * @return map对象
     */
    public List<DocOperLogVO> queryOperLogListByPage(DocOperLogVO docOperLog) {
        return docOperLogDAO.queryOperLogListByPage(docOperLog);
    }
    
    @Override
    protected MDBaseDAO<DocOperLogVO> getDAO() {
        return docOperLogDAO;
    }
    
    /**
     * 删除操作记录
     * 
     * @param docOperLogList 操作记录
     */
    public void deleteOperLog(List<DocOperLogVO> docOperLogList) {
        docOperLogDAO.deleteOperLog(docOperLogList);
    }
}
