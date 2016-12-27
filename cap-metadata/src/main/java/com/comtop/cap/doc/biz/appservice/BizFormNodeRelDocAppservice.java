/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.appservice;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.bm.biz.flow.appservice.BizFormNodeRelAppService;
import com.comtop.cap.bm.biz.flow.dao.BizFormNodeRelDAO;
import com.comtop.cap.bm.biz.flow.model.BizFormNodeRelVO;
import com.comtop.cap.doc.biz.convert.BizFormNodeRelConverter;
import com.comtop.cap.doc.biz.model.BizFormDTO;
import com.comtop.cap.doc.biz.model.BizFormNodeDTO;
import com.comtop.cap.doc.biz.model.BizProcessNodeDTO;
import com.comtop.cap.doc.service.BizAbstractWordDataAccessor;
import com.comtop.cap.doc.service.IndexBuilder;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务表单和业务流程节点关系 文档操作 门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-24 李志勇
 */
@PetiteBean
@IndexBuilder(dto = BizFormNodeDTO.class)
public class BizFormNodeRelDocAppservice extends BizAbstractWordDataAccessor<BizFormNodeRelVO, BizFormNodeDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizFormNodeRelAppService bizFormNodeRelAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizFormNodeRelDAO bizFormNodeRelDAO;
    
    /** 注入业务表单文档操作类 **/
    @PetiteInject
    protected BizFormDocAppservice bizFormDocAppservice;
    
    /** 业务关联服务 */
    @PetiteInject
    protected BizProcessNodeDocAppservice bizProcessNodeDocAppservice;
    
    @Override
    protected MDBaseAppservice<BizFormNodeRelVO> getBaseAppservice() {
        return this.bizFormNodeRelAppService;
    }
    
    @Override
    protected void saveBizData(List<BizFormNodeDTO> collection) {
        // 表单与节点的关联关系，必须在节点下，因节点无法前端过滤，
        // 因此每次都是新建的对象，可以直接保存，待节点合并时进行数据合并。
        
        for (BizFormNodeDTO bizFormNodeDTO : collection) {
            fillRelationObjectIds(bizFormNodeDTO);
            saveData(bizFormNodeDTO);
        }
    }
    
    @Override
    protected void fillRelationObjectIds(BizFormNodeDTO bizFormNodeDTO) {
        if (bizFormNodeDTO.isNewData()) {
            if (StringUtils.isNotBlank(bizFormNodeDTO.getNodeName())) {
                BizProcessNodeDTO nodeDTO = BizFormNodeRelConverter.convert2ProcessNode(bizFormNodeDTO, null);
                String nodeId = bizProcessNodeDocAppservice.findIdFromRelation(nodeDTO);
                bizFormNodeDTO.setNodeId(nodeId);
            } else {
                //
            }
            if (StringUtils.isNotBlank(bizFormNodeDTO.getFormName())) {
                BizFormDTO formDTO = BizFormNodeRelConverter.convert2BizForm(bizFormNodeDTO, null);
                String formId = bizFormDocAppservice.findIdFromRelation(formDTO);
                bizFormNodeDTO.setFormId(formId);
            } else {
                //
            }
        }
    }
    
    @Override
    public List<BizFormNodeDTO> loadData(BizFormNodeDTO condition) {
        List<BizFormNodeDTO> alRet = queryDTOList(condition);
        setSortIndex(alRet);
        return alRet;
    }
    
    @Override
    public String saveNewData(BizFormNodeDTO newData) {
        newData.setSortNo(generateSortNo("BizFormNode-SortNo"));
        BizFormNodeRelVO vo = dto2VO(newData);
        String id = this.bizFormNodeRelAppService.save(vo);
        newData.setId(id);
        return id;
    }
    
    @Override
    protected String getUri(BizFormNodeDTO data) {
        return data.getNodeId() + "-" + data.getFormId();
    }
    
    @Override
    protected BizFormNodeRelVO dto2VO(BizFormNodeDTO data) {
        BizFormNodeRelVO retData = DocDataUtil.dto2VO(data, BizFormNodeRelVO.class);
        retData.setNodeId(data.getNodeId());
        return retData;
    }
    
    @Override
    protected BizFormNodeDTO vo2DTO(BizFormNodeRelVO vo) {
        return DocDataUtil.vo2DTO(vo, BizFormNodeDTO.class);
    }
    
    /**
     * 加载FormNodeDTO
     *
     * @param condition 条件
     * @return FormNodeDTO集合
     */
    @Override
    public List<BizFormNodeDTO> queryDTOList(BizFormNodeDTO condition) {
        return bizFormNodeRelDAO.queryList("com.comtop.cap.bm.biz.flow.model.queryBizFormNodeDTOList", condition);
    }
    
    /**
     * 更新到节点的关系
     *
     * @param newNodeId 新的节点id
     * @param oldNodeId 旧的节点id
     */
    public void updateRelationToNode(String newNodeId, String oldNodeId) {
        Map<String, String> params = new HashMap<String, String>();
        params.put("newNodeId", newNodeId);
        params.put("oldNodeId", oldNodeId);
        bizFormNodeRelDAO.update("com.comtop.cap.bm.biz.flow.model.updateFormRelationToNode", params);
    }
    
}
