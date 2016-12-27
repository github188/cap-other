/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.appservice;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.bm.biz.items.appservice.BizItemsAppService;
import com.comtop.cap.bm.biz.items.appservice.BizItemsRoleAppService;
import com.comtop.cap.bm.biz.items.dao.BizItemsDAO;
import com.comtop.cap.bm.biz.items.model.BizItemsRoleVO;
import com.comtop.cap.bm.biz.items.model.BizItemsVO;
import com.comtop.cap.doc.biz.convert.BizRoleConverter;
import com.comtop.cap.doc.biz.model.BizItemDTO;
import com.comtop.cap.doc.biz.model.BizRoleDTO;
import com.comtop.cap.doc.service.BizAbstractWordDataAccessor;
import com.comtop.cap.doc.service.CommonDataManager;
import com.comtop.cap.doc.service.IndexBuilder;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cap.document.word.docmodel.data.WordDocument;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务事项 文档操作 门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-11 李志勇
 */
@PetiteBean
@IndexBuilder(dto = BizItemDTO.class)
public class BizItemsDocAppservice extends BizAbstractWordDataAccessor<BizItemsVO, BizItemDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizItemsAppService bizItemsAppService;
    
    /** 注入DAO **/
    @PetiteInject
    protected BizItemsDAO bizItemsDAO;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizProcessInfoDocAppservice bizProcessInfoFacade;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRoleDocAppservice bizRoleDocAppservice;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizItemsRoleAppService bizItemsRoleAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizDomainDocAppservice bizDomainDocAppservice;
    
    @Override
    protected MDBaseAppservice<BizItemsVO> getBaseAppservice() {
        return this.bizItemsAppService;
    }
    
    @Override
    protected void saveBizData(List<BizItemDTO> collection) {
        // 获得当前导入的文档时选择的业务域id
        // String domainId = CommonDataManager.getCurrentWordDocument().getDomainId();
        // 对业务事项按其所属的业务域进行分组
        for (BizItemDTO bizItemDTO : collection) {
            fillRelationObjectIds(bizItemDTO);
            saveData(bizItemDTO);
        }
    }
    
    @Override
    protected String saveData(BizItemDTO dto) {
        String id = super.saveData(dto);
        saveRolesMap(dto.getRolesMap(), id);
        return id;
    }
    
    @Override
    protected void fillRelationObjectIds(BizItemDTO bizItemDTO) {
        if (bizItemDTO.isNewData()) {
            String parentUri = getDomainUri(bizItemDTO);
            if (StringUtils.isNotBlank(parentUri)) {
                String parentId = bizDomainDocAppservice.findId(parentUri);
                // 如果上级Uri不为空但无法获得数据，表明该Uri对应的业务域对象还不存在，需要用户先手动建立。故在此记录日志
                if (StringUtils.isBlank(parentId)) {
                    importDataCheckLogger.errorBizItemDTO(bizItemDTO,
                        "所属业务域不存在，暂将其挂在所选的业务域上。（造成此问题的原因可能是数据本身有问题，请调整文档数据；也可能是业务域未建立，请手动在系统中建立该业务事项对应的业务域。");
                } else {
                    bizItemDTO.setDomainId(parentId);
                }
            }
        }
    }
    
    /**
     * 上级Uri
     *
     * @param bizItemDTO 业务事项
     * @return 上级Uri
     */
    private String getDomainUri(BizItemDTO bizItemDTO) {
        String domainKey = null;
        if (StringUtils.isNotBlank(bizItemDTO.getSecondLevelBiz())) {
            domainKey = bizItemDTO.getSecondLevelBiz();
        }
        if (StringUtils.isNotBlank(bizItemDTO.getFirstLevelBiz())) {
            domainKey = bizItemDTO.getFirstLevelBiz() + "/" + domainKey;
        }
        return domainKey;
    }
    
    @Override
    protected void initOneData(BizItemDTO bizItemDTO) {
        setRolesMap(bizItemDTO);
    }
    
    @Override
    protected BizItemsVO dto2VO(BizItemDTO data) {
        return DocDataUtil.dto2VO(data, BizItemsVO.class);
    }
    
    @Override
    protected BizItemDTO vo2DTO(BizItemsVO vo) {
        return DocDataUtil.vo2DTO(vo, BizItemDTO.class);
    }
    
    @Override
    public String saveNewData(BizItemDTO newData) {
        if (StringUtils.isBlank(newData.getCode())) {
            newData.setCode(generateCode(BizItemsVO.getCodeExpr(), null));
        }
        newData.setSortNo(generateSortNo("BizItems-SortNo"));
        BizItemsVO vo = dto2VO(newData);
        String id = this.bizItemsAppService.save(vo).toString();
        newData.setId(id);
        saveRolesMap(newData.getRolesMap(), id);
        return id;
    }
    
    /**
     * 设置业务事项的角色分布信息
     *
     * @param bizItemDTO bizItemDTO
     */
    private void setRolesMap(BizItemDTO bizItemDTO) {
        // 获得当前业务事项关联的所有角色，并按业务层级分组，拼装字符串
        List<BizItemsRoleVO> roles = bizItemsRoleAppService.queryBizItemsRolesById(bizItemDTO.getId());
        Map<String, String> rolesMap = BizRoleConverter.convertToRolesMapByBizLevel(roles);
        bizItemDTO.setRolesMap(rolesMap);
    }
    
    /**
     * 保存业务事项和角色的关联
     *
     * @param rolesMap 角色集合
     * @param bizItemId 保存角色集合
     */
    private void saveRolesMap(Map<String, String> rolesMap, String bizItemId) {
        if (rolesMap == null || rolesMap.size() == 0) {
            return;
        }
        // 获得当前正在处理的文档对象
        WordDocument document = CommonDataManager.getCurrentWordDocument();
        List<BizRoleDTO> roleCollection = new ArrayList<BizRoleDTO>();
        for (Entry<String, String> entry : rolesMap.entrySet()) {
            String value = entry.getValue();
            if (StringUtils.isNotBlank(value)) {
                List<BizRoleDTO> roles = BizRoleConverter.convertToRoleList(value, entry.getKey(), document);
                roleCollection.addAll(roles);
            }
        }
        // 保存角色
        bizRoleDocAppservice.saveData(roleCollection);
        
        // 建立角色与业务事项的关联
        List<BizItemsRoleVO> bizItemRoleList = new ArrayList<BizItemsRoleVO>();
        for (BizRoleDTO bizRoleDTO : roleCollection) {
            BizItemsRoleVO bizItemsRoleVO = new BizItemsRoleVO();
            bizItemsRoleVO.setItemsId(bizItemId);
            bizItemsRoleVO.setRoleId(bizRoleDTO.getId());
            bizItemsRoleVO.setSortNo(generateSortNo("bizItemsRole-SortNo"));
            bizItemRoleList.add(bizItemsRoleVO);
        }
        // 保存角色与业务事项的关联（ 先删除原来的，再建立新的）。
        bizItemsRoleAppService.updateBizItemsRoleList(bizItemRoleList, bizItemId);
    }
    
    @Override
    protected String getUri(BizItemDTO data) {
        return data.getDomainId() + "-" + data.getName();
    }
    
    /**
     * 查询DTO数据集
     *
     * @param condition 条件
     * @return DTO数据集
     */
    @Override
    public List<BizItemDTO> queryDTOList(BizItemDTO condition) {
        return bizItemsDAO.queryList("com.comtop.cap.bm.biz.items.model.queryBizItemDTOList", condition);
    }
}
