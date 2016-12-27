/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.operatelog.dao;

import java.util.List;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.doc.operatelog.model.DocOperLogVO;
import com.comtop.cip.jodd.jtx.JtxPropagationBehavior;
import com.comtop.cip.jodd.jtx.meta.Transaction;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 文档DAO
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-9 CAP
 */
@PetiteBean
public class DocOperLogDAO extends MDBaseDAO<DocOperLogVO> {
    
    /**
     * 
     * 新增操作记录
     *
     * 
     * @param operLogVO 操作记录
     * @return 操作记录Id
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public String inserOperLog(DocOperLogVO operLogVO) {
        return (String) super.insert(operLogVO);
    }
    
    /**
     * 
     * 更新操作结果
     * 
     * @param operLogId 操作记录Id
     * @param result 操作结果
     */
    @Transaction(propagation = JtxPropagationBehavior.PROPAGATION_REQUIRED, readOnly = false)
    public void updateOperResult(String operLogId, String result) {
        DocOperLogVO log = new DocOperLogVO();
        log.setId(operLogId);
        log.setOperResult(result);
        super.update("com.comtop.cap.doc.operatelog.model.updateOperResult", log);
    }
    
    /**
     * 分页查询操作记录条数
     * 
     * @param docOperLog 查询条件
     * @return map对象
     */
    public int queryOperLogCountByPage(DocOperLogVO docOperLog) {
        return ((Integer) selectOne("com.comtop.cap.doc.operatelog.model.queryOperLogCount", docOperLog)).intValue();
    }
    
    /**
     * 分页查询操作记录列表
     * 
     * @param docOperLog 查询条件
     * @return map对象
     */
    public List<DocOperLogVO> queryOperLogListByPage(DocOperLogVO docOperLog) {
        return queryList("com.comtop.cap.doc.operatelog.model.queryOperLogList", docOperLog, docOperLog.getPageNo(),
            docOperLog.getPageSize());
    }
    
    /**
     * 删除操作记录
     * 
     * @param docOperLogList 操作记录
     */
    public void deleteOperLog(List<DocOperLogVO> docOperLogList) {
        super.delete(docOperLogList);
    }
}
