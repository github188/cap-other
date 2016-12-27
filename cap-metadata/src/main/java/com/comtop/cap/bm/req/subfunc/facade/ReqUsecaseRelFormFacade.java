/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.subfunc.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.req.subfunc.appservice.ReqUsecaseRelFormAppService;
import com.comtop.cap.bm.req.subfunc.model.ReqUsecaseRelFormVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cap.runtime.base.facade.BaseFacade;

/**
 * 功能用例关联业务表单 业务逻辑处理类 门面
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-22 CAP
 */
@PetiteBean
public class ReqUsecaseRelFormFacade extends BaseFacade {
    
    /** 注入AppService **/
    @PetiteInject
    protected ReqUsecaseRelFormAppService reqUsecaseRelFormAppService;
    
    /**
     * 新增 功能用例关联业务表单
     * 
     * @param reqUsecaseRelFormVO 功能用例关联业务表单对象
     * @return 功能用例关联业务表单
     */
    public Object insertReqUsecaseRelForm(ReqUsecaseRelFormVO reqUsecaseRelFormVO) {
        return reqUsecaseRelFormAppService.insertReqUsecaseRelForm(reqUsecaseRelFormVO);
    }
    
    /**
     * 更新 功能用例关联业务表单
     * 
     * @param reqUsecaseRelFormVO 功能用例关联业务表单对象
     * @return 更新结果
     */
    public boolean updateReqUsecaseRelForm(ReqUsecaseRelFormVO reqUsecaseRelFormVO) {
        return reqUsecaseRelFormAppService.updateReqUsecaseRelForm(reqUsecaseRelFormVO);
    }
    
    /**
     * 保存或更新功能用例关联业务表单，根据ID是否为空
     * 
     * @param reqUsecaseRelFormVO 功能用例关联业务表单ID
     * @return 功能用例关联业务表单保存后的主键ID
     */
    public String saveReqUsecaseRelForm(ReqUsecaseRelFormVO reqUsecaseRelFormVO) {
        if (reqUsecaseRelFormVO.getId() == null) {
            String strId = (String) this.insertReqUsecaseRelForm(reqUsecaseRelFormVO);
            reqUsecaseRelFormVO.setId(strId);
        } else {
            this.updateReqUsecaseRelForm(reqUsecaseRelFormVO);
        }
        return reqUsecaseRelFormVO.getId();
    }
    
    /**
     * 读取 功能用例关联业务表单 列表，分页查询--新版设计器使用
     * 
     * @param condition 查询条件
     * @return 功能用例关联业务表单列表
     */
    public Map<String, Object> queryReqUsecaseRelFormListByPage(ReqUsecaseRelFormVO condition) {
        final Map<String, Object> ret = new HashMap<String, Object>(2);
        int count = reqUsecaseRelFormAppService.queryReqUsecaseRelFormCount(condition);
        List<ReqUsecaseRelFormVO> reqUsecaseRelFormVOList = null;
        if (count > 0) {
            reqUsecaseRelFormVOList = reqUsecaseRelFormAppService.queryReqUsecaseRelFormList(condition);
        }
        ret.put("list", reqUsecaseRelFormVOList);
        ret.put("count", count);
        return ret;
    }
    
    /**
     * 删除 功能用例关联业务表单
     * 
     * @param reqUsecaseRelFormVO 功能用例关联业务表单对象
     * @return 删除结果
     */
    public boolean deleteReqUsecaseRelForm(ReqUsecaseRelFormVO reqUsecaseRelFormVO) {
        return reqUsecaseRelFormAppService.deleteReqUsecaseRelForm(reqUsecaseRelFormVO);
    }
    
    /**
     * 删除 功能用例关联业务表单集合
     * 
     * @param reqUsecaseRelFormVOList 功能用例关联业务表单对象
     * @return 删除结果
     */
    public boolean deleteReqUsecaseRelFormList(List<ReqUsecaseRelFormVO> reqUsecaseRelFormVOList) {
        return reqUsecaseRelFormAppService.deleteReqUsecaseRelFormList(reqUsecaseRelFormVOList);
    }
    
    /**
     * 读取 功能用例关联业务表单
     * 
     * @param reqUsecaseRelFormVO 功能用例关联业务表单对象
     * @return 功能用例关联业务表单
     */
    public ReqUsecaseRelFormVO loadReqUsecaseRelForm(ReqUsecaseRelFormVO reqUsecaseRelFormVO) {
        return reqUsecaseRelFormAppService.loadReqUsecaseRelForm(reqUsecaseRelFormVO);
    }
    
    /**
     * 根据功能用例关联业务表单主键 读取 功能用例关联业务表单
     * 
     * @param id 功能用例关联业务表单主键
     * @return 功能用例关联业务表单
     */
    public ReqUsecaseRelFormVO loadReqUsecaseRelFormById(String id) {
        return reqUsecaseRelFormAppService.loadReqUsecaseRelFormById(id);
    }
    
    /**
     * 读取 功能用例关联业务表单 列表
     * 
     * @param condition 查询条件
     * @return 功能用例关联业务表单列表
     */
    public List<ReqUsecaseRelFormVO> queryReqUsecaseRelFormList(ReqUsecaseRelFormVO condition) {
        return reqUsecaseRelFormAppService.queryReqUsecaseRelFormList(condition);
    }
    
    /**
     * 读取 功能用例关联业务表单 数据条数
     * 
     * @param condition 查询条件
     * @return 功能用例关联业务表单数据条数
     */
    public int queryReqUsecaseRelFormCount(ReqUsecaseRelFormVO condition) {
        return reqUsecaseRelFormAppService.queryReqUsecaseRelFormCount(condition);
    }
    
    /**
     * 读取功能用例关联业务表单
     * 
     * @param subitemId 功能用例ID
     * @return 功能用例关联业务表单
     */
    public ReqUsecaseRelFormVO queryReqUsecaseRelFormBysubitemId(String subitemId) {
        return reqUsecaseRelFormAppService.queryReqUsecaseRelFormBysubitemId(subitemId);
    }
    
    /**
     * 保存或更新功能用例关联业务表单集合，根据ID是否为空
     * 
     * @param ReqUsecaseRelFormVO 功能用例关联业务表单ID
     */
    public void saveBizFormNodeRelList(List<ReqUsecaseRelFormVO> ReqUsecaseRelFormVO) {
        for (ReqUsecaseRelFormVO reqUsecaseRelFormVO : ReqUsecaseRelFormVO) {
            if (reqUsecaseRelFormVO.getId() == null) {
                String strId = (String) this.insertReqUsecaseRelForm(reqUsecaseRelFormVO);
                reqUsecaseRelFormVO.setId(strId);
            } else {
                this.updateReqUsecaseRelForm(reqUsecaseRelFormVO);
            }
        }
    }
    
    /**
     * 删除原有的功能用例关联业务表单
     * 
     * @param subitemId 功能用例ID
     */
    public void deleteReqUsecaseRelFormByUsecaseId(String subitemId) {
        reqUsecaseRelFormAppService.deleteReqUsecaseRelFormByUsecaseId(subitemId);
    }
}
