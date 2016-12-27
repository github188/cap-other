/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pdm.facade;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.database.dbobject.facade.TableFacade;
import com.comtop.cap.bm.metadata.database.dbobject.facade.ViewFacade;
import com.comtop.cap.bm.metadata.database.dbobject.model.ReferenceVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewVO;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.pdm.dao.FacadeDAO;
import com.comtop.cap.bm.metadata.pdm.model.PdmSelectVO;
import com.comtop.cap.bm.metadata.pdm.model.PdmVO;
import com.comtop.cap.bm.metadata.pdm.util.PdmImport;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.top.component.app.session.HttpSessionUtil;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.sys.module.appservice.ModuleAppService;
import com.comtop.top.sys.module.model.ModuleVO;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * PDM实体facade类
 *
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DwrProxy
@PetiteBean
public class PdmFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(PdmFacade.class);
    
    /** 包Facade */
    private final SysmodelFacade packageFacade = AppContext.getBean(SysmodelFacade.class);
    
    /** 表Facade */
    private final TableFacade tableFacade = AppContext.getBean(TableFacade.class);
    
    /** 实体Facade */
    private final EntityFacade entityFacade = AppContext.getBean(EntityFacade.class);
    
    /** 视图Facade */
    private final ViewFacade viewFacade = AppContext.getBean(ViewFacade.class);
    
    /** PDM模型实体DAO */
    @PetiteInject
    protected FacadeDAO facadeDAO;
    
    /** 模块服务类 */
    @PetiteInject
    protected ModuleAppService moduleAppService;
    
    /**
     * @param packageId 当前模块包ID
     * @return 模块包路径
     */
    private String getPackagePath(String packageId) {
        CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
        return objPackageVO == null ? null : objPackageVO.getFullPath();
    }
    
    /**
     * 加载pdm
     * 
     * @param packageId 模块包Id
     * @return PdmVO PdmVO
     * @throws Exception Exception
     */
    @RemoteMethod
    public List<PdmSelectVO> loadPdmVO(String packageId) throws Exception {
        String strFilePath = (String) HttpSessionUtil.getSession().getAttribute("filePath");
        File objFile = new File(strFilePath);
        PdmVO objPdmVO = new PdmVO();
        // 判断文件是否存在
        if (objFile.exists()) {
            // pdm导入
            PdmImport objPdmImportUtils = new PdmImport();
            objPdmVO = objPdmImportUtils.pdmParser(objFile);
        } else {
            LOG.error("文件不存在");
            return null;
        }
        // 获取关联表的字段
        List<ReferenceVO> lstReferenceVO = objPdmVO.getReferences();
        Map<String, ReferenceVO> mapReferenceVO = new HashMap<String, ReferenceVO>();
        for (ReferenceVO referenceVO : lstReferenceVO) {
            mapReferenceVO.put(referenceVO.getChildTableId(), referenceVO);
        }
        List<PdmSelectVO> lstPdmSelectVO = new ArrayList<PdmSelectVO>();
        
        List<TableVO> lstTableVO = objPdmVO.getTables();
        for (TableVO tableVO : lstTableVO) {
            PdmSelectVO objPdmSelectVO = new PdmSelectVO();
            objPdmSelectVO.setType(1);
            BeanUtils.copyProperties(tableVO, objPdmSelectVO);
            ReferenceVO referenceVO = mapReferenceVO.get(tableVO.getId());
            if (referenceVO != null) {
                objPdmSelectVO.setParentTableName(referenceVO.getParentTable().getChName());
                objPdmSelectVO.setParentTableId(referenceVO.getParentTable().getId());
            }
            lstPdmSelectVO.add(objPdmSelectVO);
        }
        
        List<ViewVO> lstViewVO = objPdmVO.getViews();
        for (ViewVO viewVO : lstViewVO) {
            PdmSelectVO objPdmSelectVO = new PdmSelectVO();
            objPdmSelectVO.setType(2);
            BeanUtils.copyProperties(viewVO, objPdmSelectVO);
            lstPdmSelectVO.add(objPdmSelectVO);
        }
        return lstPdmSelectVO;
    }
    
    /**
     * 导入pdm
     * 
     * @param packageId 模块包Id
     * @param lstPdmSelectVO 选中表或者视图信息
     * @return true 成功 false失败
     * @throws Exception Exception
     */
    @RemoteMethod
    public boolean importPdm(String packageId, List<PdmSelectVO> lstPdmSelectVO) throws Exception {
        String strPackageFullPath = getPackagePath(packageId);
        if (StringUtil.isBlank(strPackageFullPath)) {
            LOG.error("模块包路径为空，packageId" + packageId);
            return false;
        }
        String strFilePath = (String) HttpSessionUtil.getSession().getAttribute("filePath");
		if (StringUtil.isEmpty(strFilePath))//再次点击导入,session中filePath已移除
			return true;
		
        File objFile = new File(strFilePath);
        PdmVO objPdmVO = new PdmVO();
        // 判断文件是否存在
        if (objFile.exists()) {
            // pdm导入
            PdmImport objPdmImport = new PdmImport();
            objPdmVO = objPdmImport.pdmParser(objFile);
        }
        
        Map<String, String> objSelectVO = new HashMap<String, String>();
        for (PdmSelectVO pdmSelectVO : lstPdmSelectVO) {
            objSelectVO.put(pdmSelectVO.getId(), pdmSelectVO.getId());
        }
        
        List<TableVO> lstTables = objPdmVO.getTables();
        List<TableVO> lstNewTables = new ArrayList<TableVO>();
        for (TableVO tableVO : lstTables) {
            String strTableId = tableVO.getId();
            if (objSelectVO.containsKey(strTableId)) {
                List<ReferenceVO> lstReferences = tableVO.getReferences();
                List<ReferenceVO> lstNewReferences = new ArrayList<ReferenceVO>();
                for (ReferenceVO referenceVO : lstReferences) {
                    if (objSelectVO.containsKey(referenceVO.getChildTableId())) {
                        lstNewReferences.add(referenceVO);
                    }
                }
                tableVO.setReferences(lstNewReferences);
                lstNewTables.add(tableVO);
            }
        }
        tableFacade.saveTableList(strPackageFullPath, lstNewTables);
        entityFacade.saveEntityFromTable(packageId, lstNewTables);
        
        List<ViewVO> lstViews = objPdmVO.getViews();
        List<ViewVO> lstNewViews = new ArrayList<ViewVO>();
        for (PdmSelectVO pdmSelectVO : lstPdmSelectVO) {
            String strId = pdmSelectVO.getId();
            for (ViewVO viewVO : lstViews) {
                String strTableId = viewVO.getId();
                if (strTableId.equals(strId)) {
                    lstNewViews.add(viewVO);
                }
            }
        }
        viewFacade.saveViewList(strPackageFullPath, lstNewViews);
        entityFacade.saveEntityFromView(strPackageFullPath, lstNewViews);
        
        objFile.delete();
        HttpSessionUtil.getSession().removeAttribute("filePath");
        return true;
    }
    
    /**
     * 导出pdm
     * 
     * @param packageId 模块包Id
     * @return PdmVO PdmVO
     * @throws OperateException OperateException
     */
    @RemoteMethod
    public PdmVO exportPdmForER(String packageId) throws OperateException {
        String strPackageFullPath = getPackagePath(packageId);
        if (StringUtil.isBlank(strPackageFullPath)) {
            LOG.error("模块包路径为空，packageId" + packageId);
        }
        List<TableVO> lstTableVO = tableFacade.queryTableList(strPackageFullPath);
        List<ViewVO> lstViewVO = viewFacade.queryViewList(strPackageFullPath);
        
        PdmVO objPdmVO = new PdmVO();
        objPdmVO.setTables(lstTableVO);
        objPdmVO.setViews(lstViewVO);
        return objPdmVO;
    }
    
    /**
     * 导出pdm
     * 
     * @param moduleId 模块Id
     * @return PdmVO PdmVO
     * @throws OperateException OperateException
     */
    @RemoteMethod
    public PdmVO exportPdm(String moduleId) throws OperateException {
        ModuleVO objModuleVO = moduleAppService.readModuleVO(moduleId);
        List<TableVO> lstTableVO = new ArrayList<TableVO>();
        List<ViewVO> lstViewVO = new ArrayList<ViewVO>();
        List<ModuleVO> lstModuleVO = facadeDAO.queryChildrenModuleVOList(moduleId);
        for (ModuleVO moduleVO : lstModuleVO) {
            lstTableVO.addAll(tableFacade.queryTableList(moduleVO.getFullPath()));
            lstViewVO.addAll(viewFacade.queryViewList(moduleVO.getFullPath()));
        }
        String strPackageFullPath = getPackagePath(moduleId);
        if (StringUtil.isNotBlank(strPackageFullPath)) {
            lstTableVO.addAll(tableFacade.queryTableList(strPackageFullPath));
            lstViewVO.addAll(viewFacade.queryViewList(strPackageFullPath));
        }
        
        PdmVO objPdmVO = new PdmVO();
        objPdmVO.setTables(lstTableVO);
        objPdmVO.setViews(lstViewVO);
        objPdmVO.setCode(objModuleVO.getModuleCode());
        return objPdmVO;
    }
    
}
