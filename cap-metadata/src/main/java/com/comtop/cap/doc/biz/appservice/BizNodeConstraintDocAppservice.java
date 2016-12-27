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
import com.comtop.cap.bm.biz.flow.appservice.BizNodeConstraintAppService;
import com.comtop.cap.bm.biz.flow.dao.BizNodeConstraintDAO;
import com.comtop.cap.bm.biz.flow.model.BizNodeConstraintVO;
import com.comtop.cap.doc.biz.convert.BizNodeConstraintConverter;
import com.comtop.cap.doc.biz.model.BizNodeConstraintDTO;
import com.comtop.cap.doc.biz.model.BizObjectDTO;
import com.comtop.cap.doc.biz.model.BizObjectDataItemDTO;
import com.comtop.cap.doc.biz.model.BizProcessNodeDTO;
import com.comtop.cap.doc.service.BizAbstractWordDataAccessor;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.doc.service.IndexBuilder;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 流程节点数据项约束 文档操作 门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-20 李志勇
 */
@PetiteBean
@IndexBuilder(dto = BizNodeConstraintDTO.class)
public class BizNodeConstraintDocAppservice extends
    BizAbstractWordDataAccessor<BizNodeConstraintVO, BizNodeConstraintDTO> {
    
    /** 注入节点约束AppService **/
    @PetiteInject
    protected BizNodeConstraintAppService bizNodeConstraintAppService;
    
    /** 注入App节点约束DAO **/
    @PetiteInject
    protected BizNodeConstraintDAO bizNodeConstraintDAO;
    
    /** 节点的文档操作服务 */
    @PetiteInject
    protected BizProcessNodeDocAppservice bizProcessNodeDocAppservice;
    
    /** 业务对象的文档操作服务 */
    @PetiteInject
    protected BizObjInfoDocAppservice bizObjInfoDocAppservice;
    
    /** 业务对象数据项的文档操作服务 */
    @PetiteInject
    protected BizObjDataItemDocAppservice bizObjDataItemDocAppservice;
    
    @Override
    protected MDBaseAppservice<BizNodeConstraintVO> getBaseAppservice() {
        return this.bizNodeConstraintAppService;
    }
    
    @Override
    protected void saveBizData(List<BizNodeConstraintDTO> collection) {
        // 节点约束有两种。一种来源于节点章节的下级（一组数据中只有一个上级），
        // 一种来源于文档末尾的汇总章节(一组数据中有多个上级)，均需要支持。所以需要按上级进行分组.
        // 对数据按其所属的上级进行分组，并将其挂在上级下
        for (BizNodeConstraintDTO dto : collection) {
            fillRelationObjectIds(dto);
            saveData(dto);
        }
    }
    
    @Override
    protected void fillRelationObjectIds(BizNodeConstraintDTO dto) {
        // 获得当前正在导入的文档
        if (dto.isNewData()) {
            WordDocument document = CommonDataManager.getCurrentWordDocument();
            if (StringUtils.isNotBlank(dto.getNodeName())) {
                BizProcessNodeDTO nodeDTO = BizNodeConstraintConverter.convert2ProcessNode(dto, document);
                String nodeId = bizProcessNodeDocAppservice.findIdFromRelation(nodeDTO);
                dto.setNodeId(nodeId);
            } else {
                //
            }
            
            if (StringUtils.isNotBlank(dto.getObjectName())) {
                BizObjectDTO bizObjectDTO = BizNodeConstraintConverter.convert2BizObject(dto, document);
                String objectId = bizObjInfoDocAppservice.findIdFromRelation(bizObjectDTO);
                dto.setObjectId(objectId);
            } else {
                //
            }
            if (StringUtils.isNotBlank(dto.getDataItemName())) {
                BizObjectDataItemDTO dataItemDTO = BizNodeConstraintConverter.convert2BizObjectDataItem(dto, document);
                String itemId = bizObjDataItemDocAppservice.findIdFromRelation(dataItemDTO);
                dto.setDataItemId(itemId);
            } else {
                //
            }
        }
    }
    
    @Override
    public List<BizNodeConstraintDTO> loadData(BizNodeConstraintDTO condition) {
        // 如果存在节点id，则以节点id进行查询
        List<BizNodeConstraintDTO> alRet = null;
        if (StringUtils.isNotBlank(condition.getNodeId())) {
            alRet = queryBizNodeConstraintDTOListByNodeId(condition.getNodeId());
        } else {
            // 如果不存在，则以条件查询
            alRet = queryDTOList(condition);
        }
        setSortIndex(alRet);
        return alRet;
    }
    
    @Override
    public String saveNewData(BizNodeConstraintDTO newData) {
        newData.setSortNo(generateSortNo("BizNodeConstraint-SortNo"));
        BizNodeConstraintVO vo = dto2VO(newData);
        String id = this.bizNodeConstraintAppService.save(vo);
        newData.setId(id);
        return id;
    }
    
    @Override
    protected String getUri(BizNodeConstraintDTO data) {
        return data.getNodeId() + "-" + data.getObjectId() + "-" + data.getDataItemId();
    }
    
    @Override
    protected BizNodeConstraintVO dto2VO(BizNodeConstraintDTO data) {
        BizNodeConstraintVO retData = DocDataUtil.dto2VO(data, BizNodeConstraintVO.class);
        retData.setNodeId(data.getNodeId());
        retData.setBizObjId(data.getObjectId());
        retData.setObjDataId(data.getDataItemId());
        retData.setBizObjName(data.getObjectName());
        return retData;
    }
    
    @Override
    protected BizNodeConstraintDTO vo2DTO(BizNodeConstraintVO vo) {
        BizNodeConstraintDTO retData = DocDataUtil.vo2DTO(vo, BizNodeConstraintDTO.class);
        retData.setNodeId(vo.getNodeId());
        retData.setObjectId(vo.getBizObjId());
        retData.setObjectName(vo.getBizObjName());
        retData.setDataItemId(vo.getObjDataId());
        return retData;
    }
    
    /**
     * 加载节点约束数据
     *
     * @param bizNodeConstraintDTO 条件
     * @return 节点约束数据
     */
    @Override
    public List<BizNodeConstraintDTO> queryDTOList(BizNodeConstraintDTO bizNodeConstraintDTO) {
        return bizNodeConstraintDAO.queryList("com.comtop.cap.bm.biz.flow.model.queryBizNodeConstraintDTOList",
            bizNodeConstraintDTO);
    }
    
    /**
     * 加载指定节点下的节点约束数据
     *
     * @param nodeId 条件
     * @return 节点约束数据
     */
    public List<BizNodeConstraintDTO> queryBizNodeConstraintDTOListByNodeId(String nodeId) {
        return bizNodeConstraintDAO.queryList("com.comtop.cap.bm.biz.flow.model.queryBizNodeConstraintDTOListByNodeId",
            nodeId);
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
        bizNodeConstraintDAO.update("com.comtop.cap.bm.biz.flow.model.updateConstraintRelationToNode", params);
    }
    
}
