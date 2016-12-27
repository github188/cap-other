/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.appservice;

import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.base.MDBaseAppservice;
import com.comtop.cap.bm.biz.domain.model.BizDomainVO;
import com.comtop.cap.bm.biz.role.appservice.BizRoleAppService;
import com.comtop.cap.bm.biz.role.dao.BizRoleDAO;
import com.comtop.cap.bm.biz.role.model.BizRoleVO;
import com.comtop.cap.bm.common.BizLevel;
import com.comtop.cap.doc.biz.model.BizRoleDTO;
import com.comtop.cap.doc.hld.model.RoleDataConstraintDTO;
import com.comtop.cap.doc.service.BizAbstractWordDataAccessor;
import com.comtop.cap.doc.service.IndexBuilder;
import com.comtop.cap.doc.util.DocDataUtil;
import com.comtop.cip.common.util.CAPCollectionUtils;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 业务角色文档操作门面
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-11 李志勇
 */
@PetiteBean
@IndexBuilder(dto = BizRoleDTO.class)
public class BizRoleDocAppservice extends BizAbstractWordDataAccessor<BizRoleVO, BizRoleDTO> {
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRoleAppService roleAppService;
    
    /** 注入AppService **/
    @PetiteInject
    protected BizRoleDAO bizRoleDAO;
    
    @Override
    protected void saveBizData(List<BizRoleDTO> collection) {
        for (BizRoleDTO bizRoleDTO : collection) {
            saveData(bizRoleDTO);
        }
    }
    
    @Override
    public List<BizRoleDTO> loadData(BizRoleDTO condition) {
        List<BizRoleDTO> alRet = queryDTOList(condition);
        int i = 0;
        for (BizRoleDTO bizRoleDTO : alRet) {
            bizRoleDTO.setSortIndex(++i);
            String description = bizRoleDTO.getDescription();
            String cnBizLevel = "(" + BizLevel.getBizLevelByCode(bizRoleDTO.getBizLevel()).getCnName() + ")";
            if (StringUtils.isBlank(description)) {
                description = cnBizLevel;
            } else {
                if (description.indexOf(cnBizLevel) < 0) {
                    description += cnBizLevel;
                }
            }
            String remark = bizRoleDTO.getRemark();
            if (StringUtils.isBlank(remark)) {
                remark = cnBizLevel;
            } else {
                if (remark.indexOf(cnBizLevel) < 0) {
                    remark += cnBizLevel;
                }
            }
            bizRoleDTO.setDescription(description);
            bizRoleDTO.setRemark(remark);
        }
        return alRet;
    }
    
    @Override
    public String saveNewData(BizRoleDTO newData) {
        newData.setCode(generateCode(BizRoleVO.getCodeExpr(), null));
        newData.setSortNo(generateSortNo("BizRole-SortNo"));
        BizRoleVO vo = dto2VO(newData);
        String id = getBaseAppservice().insert(vo);
        newData.setId(id);
        return id;
    }
    
    @Override
    protected String getUri(BizRoleDTO data) {
        return data.getDomainId() + "-" + data.getBizLevel() + "-" + data.getName();
    }
    
    @Override
    protected MDBaseAppservice<BizRoleVO> getBaseAppservice() {
        return this.roleAppService;
    }
    
    @Override
    protected BizRoleVO dto2VO(BizRoleDTO data) {
        BizRoleVO bizRoleVO = DocDataUtil.dto2VO(data, BizRoleVO.class);
        bizRoleVO.setRoleName(data.getName());
        bizRoleVO.setRoleCode(data.getCode());
        return bizRoleVO;
    }
    
    @Override
    protected BizRoleDTO vo2DTO(BizRoleVO vo) {
        BizRoleDTO bizRoleDTO = DocDataUtil.vo2DTO(vo, BizRoleDTO.class);
        bizRoleDTO.setName(vo.getRoleName());
        bizRoleDTO.setCode(vo.getRoleCode());
        return bizRoleDTO;
    }
    
    /**
     * 加载角色DTO
     *
     * @param role 角色
     * @return 角色集
     */
    @Override
    public List<BizRoleDTO> queryDTOList(BizRoleDTO role) {
        return bizRoleDAO.queryList("com.comtop.cap.bm.biz.role.model.loadBizRoleDTOList", role);
    }
    
    /**
     * 查询业务域集合下的所有角色
     *
     * @param lstBizDomain 查询条件
     * @return 业务域下所有角色
     */
    public List<RoleDataConstraintDTO> queryRoleDataConstraintDTO(List<BizDomainVO> lstBizDomain) {
        if (CAPCollectionUtils.isNotEmpty(lstBizDomain)) {
            return bizRoleDAO.queryList("com.comtop.cap.bm.biz.role.model.queryRoleDataConstraintDTO", lstBizDomain);
        }
        return null;
    }
    
}
