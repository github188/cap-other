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
import com.comtop.cap.bm.biz.domain.model.BizDomainVO;
import com.comtop.cap.bm.biz.flow.appservice.BizRelInfoAppService;
import com.comtop.cap.bm.biz.flow.dao.BizRelInfoDAO;
import com.comtop.cap.bm.biz.flow.model.BizRelInfoVO;
import com.comtop.cap.bm.biz.items.model.BizItemsVO;
import com.comtop.cap.doc.biz.convert.BizRelationConverter;
import com.comtop.cap.doc.biz.model.BizProcessNodeDTO;
import com.comtop.cap.doc.biz.model.BizRelationDTO;
import com.comtop.cap.doc.biz.model.BizRelationDataItemDTO;
import com.comtop.cap.doc.service.BizAbstractWordDataAccessor;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.doc.service.IndexBuilder;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.runtime.component.facade.AutoGenNumberFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * 业务关联文档操作门面。对于业务关联的导入，只处理配置具体的流程节点下的关联数。其它数据只是汇总处理。咨询过生产陶伟伟确认。
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-16 李志勇
 */
@PetiteBean
@IndexBuilder(dto = BizRelationDTO.class)
public class BizRelationDocAppservice extends BizAbstractWordDataAccessor<BizRelInfoVO, BizRelationDTO> {
    
    /** 业务关联 数据项文档操作服务 */
    @PetiteInject
    protected BizRelDataDocAppservice bizRelDataDocAppservice;
    
    /** 业务关联服务 */
    @PetiteInject
    protected BizRelInfoAppService bizRelInfoAppService;
    
    /** 业务关联服务 */
    @PetiteInject
    protected BizProcessNodeDocAppservice bizProcessNodeDocAppservice;
    
    /** 业务关联 DAO */
    @PetiteInject
    protected BizRelInfoDAO bizRelInfoDAO;
    
    @Override
    protected void saveBizData(List<BizRelationDTO> collection) {
        if (collection == null || collection.size() == 0) {
            return;
        }
        for (BizRelationDTO bizRelationDTO : collection) {
            fillRelationObjectIds(bizRelationDTO);
            String id = saveData(bizRelationDTO);
            List<BizRelationDataItemDTO> dataItems = bizRelationDTO.getDataItemList();
            if (dataItems != null && dataItems.size() > 0) {
                for (BizRelationDataItemDTO bizRelationDataItemDTO : dataItems) {
                    bizRelationDataItemDTO.setRelationId(id);
                }
                bizRelDataDocAppservice.saveData(dataItems);
            }
        }
    }
    
    @Override
    protected void fillRelationObjectIds(BizRelationDTO bizRelationDTO) {
        if (bizRelationDTO.isNewData()) {
            if (StringUtils.isNotBlank(bizRelationDTO.getRoleaNodeName())) {
                BizProcessNodeDTO nodeDTO = BizRelationConverter.convert2ProcessNode(bizRelationDTO, null);
                String nodeId = bizProcessNodeDocAppservice.findIdFromRelation(nodeDTO);
                bizRelationDTO.setRoleaNodeId(nodeId);
            } else {
                //
            }
        }
    }
    
    @Override
    protected void initOneData(BizRelationDTO bizRelationDTO) {
        setBizDomain(bizRelationDTO);
        BizRelationDataItemDTO queryCondition = new BizRelationDataItemDTO();
        queryCondition.setRelationId(bizRelationDTO.getId());
        List<BizRelationDataItemDTO> dataItemList = bizRelDataDocAppservice.loadData(queryCondition);
        bizRelationDTO.setDataItemList(dataItemList);
    }
    
    /**
     * 设置流程业务域
     *
     * @param bizRelationDTO 业务流程
     */
    private void setBizDomain(BizRelationDTO bizRelationDTO) {
        setRoleABizDomain(bizRelationDTO);
        setRoleBBizDomain(bizRelationDTO);
    }
    
    /**
     * 设置角色B的业务域
     *
     * @param bizRelationDTO 关联
     */
    private void setRoleBBizDomain(BizRelationDTO bizRelationDTO) {
        // 设置roleb的业务域
        BizItemsVO bizItemsVO = CommonDataManager.getBizItemsVO(bizRelationDTO.getRolebItemId());
        if (bizItemsVO == null) {
            return;
        }
        BizDomainVO bizDomainVO = CommonDataManager.getBizDomainVO(bizItemsVO.getDomainId());
        // 业务域不为空才操作
        if (bizDomainVO == null) {
            return;
        }
        bizRelationDTO.setRolebSecondLevelBiz(bizDomainVO.getName());
        String domainId = bizDomainVO.getPaterId();
        if (StringUtils.isBlank(domainId)) {
            bizRelationDTO.setRolebFirstLevelBiz(bizDomainVO.getName());
            bizRelationDTO.setRolebDomainId(bizDomainVO.getId());
            bizRelationDTO.setRolebDomainName(bizDomainVO.getName());
            return;
        }
        bizDomainVO = CommonDataManager.getBizDomainVO(domainId);
        if (bizDomainVO == null) {
            return;
        }
        bizRelationDTO.setRolebFirstLevelBiz(bizDomainVO.getName());
        domainId = bizDomainVO.getPaterId();
        if (StringUtils.isNotBlank(domainId)) {
            bizDomainVO = CommonDataManager.getBizDomainVO(domainId);
            if (bizDomainVO != null) {
                bizRelationDTO.setRolebDomainId(bizDomainVO.getId());
                bizRelationDTO.setRolebDomainName(bizDomainVO.getName());
            }
        }
    }
    
    /**
     * 设置角色A的业务域
     *
     * @param bizRelationDTO 关联
     */
    private void setRoleABizDomain(BizRelationDTO bizRelationDTO) {
        // 设置rolea的业务域
        BizItemsVO bizItemsVO = CommonDataManager.getBizItemsVO(bizRelationDTO.getRoleaItemId());
        if (bizItemsVO == null) {
            return;
        }
        BizDomainVO bizDomainVO = CommonDataManager.getBizDomainVO(bizItemsVO.getDomainId());
        // 业务域不为空才操作
        if (bizDomainVO == null) {
            return;
        }
        bizRelationDTO.setRoleaSecondLevelBiz(bizDomainVO.getName());
        String domainId = bizDomainVO.getPaterId();
        if (StringUtils.isBlank(domainId)) {
            bizRelationDTO.setRoleaFirstLevelBiz(bizDomainVO.getName());
            bizRelationDTO.setRoleaDomainId(bizDomainVO.getId());
            bizRelationDTO.setRoleaDomainName(bizDomainVO.getName());
            return;
        }
        bizDomainVO = CommonDataManager.getBizDomainVO(domainId);
        if (bizDomainVO == null) {
            return;
        }
        bizRelationDTO.setRoleaFirstLevelBiz(bizDomainVO.getName());
        domainId = bizDomainVO.getPaterId();
        if (StringUtils.isNotBlank(domainId)) {
            bizDomainVO = CommonDataManager.getBizDomainVO(domainId);
            if (bizDomainVO != null) {
                bizRelationDTO.setRoleaDomainId(bizDomainVO.getId());
                bizRelationDTO.setRoleaDomainName(bizDomainVO.getName());
            }
        }
    }
    
    @Override
    public String saveNewData(BizRelationDTO newData) {
        if (StringUtils.isBlank(newData.getCode())) {
            newData.setCode(generateCode(BizRelInfoVO.getCodeExpr(), null));
        }
        newData.setSortNo(generateSortNo("BizRelation-SortNo"));
        BizRelInfoVO vo = dto2VO(newData);
        String id = this.bizRelInfoAppService.save(vo);
        newData.setId(id);
        return id;
    }
    
    @Override
    protected String getUri(BizRelationDTO data) {
        StringBuffer keyBuilder = new StringBuffer(128);
        keyBuilder.append(StringUtils.trim(data.getRoleaNodeId())).append('-');
        keyBuilder.append(StringUtils.trim(data.getRolebDomainName())).append('-');
        keyBuilder.append(StringUtils.trim(data.getRolebProcessName())).append('-');
        keyBuilder.append(StringUtils.trim(data.getRolebNodeName()));
        return keyBuilder.toString();
    }
    
    @Override
    protected MDBaseAppservice<BizRelInfoVO> getBaseAppservice() {
        return this.bizRelInfoAppService;
    }
    
    @Override
    protected BizRelInfoVO dto2VO(BizRelationDTO data) {
        BizRelInfoVO retData = DocDataUtil.dto2VO(data, BizRelInfoVO.class);
        retData.setRoleaNodeId(data.getRoleaNodeId());
        if (StringUtils.isBlank(retData.getRoleaDomainId())) {
            retData.setRoleaDomainId(data.getDomainId());
        }
        data.setRoleaDomainId(data.getDomainId());
        return retData;
    }
    
    @Override
    protected BizRelationDTO vo2DTO(BizRelInfoVO vo) {
        BizRelationDTO bizRelationDTO = DocDataUtil.vo2DTO(vo, BizRelationDTO.class);
        bizRelationDTO.setDomainId(bizRelationDTO.getRoleaDomainId());
        return bizRelationDTO;
    }
    
    /**
     * 更新编码和序号
     *
     */
    public void updateCodeAndSortNo() {
        List<BizRelInfoVO> alData = loadBizRelInfoNotExistCodeOrSortNo();
        AutoGenNumberFacade autoGenNumberService = AppBeanUtil.getBean(AutoGenNumberFacade.class);
        for (BizRelInfoVO data : alData) {
            if (StringUtils.isBlank(data.getCode())) {
                String code = autoGenNumberService.genNumber(BizRelInfoVO.getCodeExpr(), null);
                bizRelInfoAppService.updatePropertyById(data.getId(), "code", code);
            }
            
            if (data.getSortNo() == null) {
                String sortNoExpr = DocDataUtil.getSortNoExpr("BizRelation-SortNo", data.getRoleaDomainId());
                String code = autoGenNumberService.genNumber(sortNoExpr, null);
                bizRelInfoAppService.updatePropertyById(data.getId(), "sortNo", code);
            }
        }
    }
    
    /**
     * 查询关联
     *
     * @param condition 条件
     * @return 关联
     */
    @Override
    public List<BizRelationDTO> queryDTOList(BizRelationDTO condition) {
        if (StringUtil.isNotBlank(condition.getId())) {
            return bizRelInfoDAO.queryList("com.comtop.cap.bm.biz.flow.model.queryBizRelationDTOListById", condition);
        }
        return bizRelInfoDAO.queryList("com.comtop.cap.bm.biz.flow.model.queryBizRelationDTOList", condition);
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
        bizRelInfoDAO.update("com.comtop.cap.bm.biz.flow.model.updateRelinfoRelationToNode", params);
    }
    
    /**
     * 更新roleadomainId
     *
     */
    public void updateRoleaDomainId() {
        bizRelInfoDAO.update("com.comtop.cap.bm.biz.flow.model.updateRelinfoDomainId", null);
    }
    
    /**
     * 加载不存在编码或排序号的数据
     *
     * @return 数据集
     */
    public List<BizRelInfoVO> loadBizRelInfoNotExistCodeOrSortNo() {
        return bizRelInfoDAO.queryList("com.comtop.cap.bm.biz.flow.model.loadBizRelInfoNotExistCodeOrSortNo", null);
    }
    
}
