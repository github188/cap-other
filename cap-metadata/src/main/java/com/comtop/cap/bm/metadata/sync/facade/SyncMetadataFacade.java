/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.sync.facade;

import java.io.File;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.database.dbobject.facade.FunctionFacade;
import com.comtop.cap.bm.metadata.database.dbobject.facade.ProcedureFacade;
import com.comtop.cap.bm.metadata.database.dbobject.facade.TableFacade;
import com.comtop.cap.bm.metadata.database.dbobject.facade.ViewFacade;
import com.comtop.cap.bm.metadata.database.dbobject.model.FunctionVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ProcedureVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewVO;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.facade.ExceptionFacade;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.model.ExceptionVO;
import com.comtop.cap.bm.metadata.page.desinger.facade.PageFacade;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.template.facade.MetadataGenerateFacade;
import com.comtop.cap.bm.metadata.page.template.model.MetadataGenerateVO;
import com.comtop.cap.bm.metadata.serve.facade.ServiceObjectFacade;
import com.comtop.cap.bm.metadata.serve.model.ServiceObjectVO;
import com.comtop.cap.bm.metadata.sysmodel.facade.PackageObjectFacade;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cap.bm.util.CapFileUtils;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.StringUtil;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 同步元数据facade类
 *
 * @author 诸焕辉
 * @since 1.0
 * @version 2016年3月28日 诸焕辉
 */
@DwrProxy
@PetiteBean
public class SyncMetadataFacade {
    
    /**
     * 实体facade
     */
    protected EntityFacade entityFacade = AppContext.getBean(EntityFacade.class);
    
    /**
     * 实体对应表facade
     */
    protected TableFacade tableFacade = AppContext.getBean(TableFacade.class);
    
    /**
     * 异常facade
     */
    protected ExceptionFacade exceptionFacade = AppContext.getBean(ExceptionFacade.class);
    
    /**
     * 界面facade
     */
    protected PageFacade pageFacade = AppContext.getBean(PageFacade.class);
    
    /**
     * 元数据生成facade
     */
    protected MetadataGenerateFacade metadataGenerateFacade = AppContext.getBean(MetadataGenerateFacade.class);
    
    /**
     * 函数facade
     */
    protected FunctionFacade functionFacade = AppContext.getBean(FunctionFacade.class);
    
    /**
     * 视图facade
     */
    protected ViewFacade viewFacade = AppContext.getBean(ViewFacade.class);
    
    /**
     * 存储过程facade
     */
    protected ProcedureFacade procedureFacade = AppContext.getBean(ProcedureFacade.class);
    
    /**
     * 模块首页代码路径facade
     */
    protected PackageObjectFacade packageFacade = AppContext.getBean(PackageObjectFacade.class);
    
    /**
     * 服务facade
     */
    protected ServiceObjectFacade serveFacade = AppContext.getBean(ServiceObjectFacade.class);
    
    /**
     * 包路径发生变更，该包下的元数据数据也要做相应同步修改操作
     * 
     * @param newFullPath 新包名
     * @param oldFullPath 旧包名
     * @return 回馈处理后的信息
     */
    @RemoteMethod
    public boolean syncOperate(String newFullPath, String oldFullPath) {
        boolean bResult = true;
        // 迁移元数据文件，并修改文件相关内容
        Map<String, String[]> objResult4Entity = entityFacade.updateFullPath(newFullPath, oldFullPath,
            "entity[modelPackage='" + oldFullPath + "']", EntityVO.class);
        Map<String, String[]> objResult4Table = tableFacade.updateFullPath(newFullPath, oldFullPath,
            "table[modelPackage='" + oldFullPath + "']", TableVO.class);
        Map<String, String[]> objResult4Page = pageFacade.updateFullPath(newFullPath, oldFullPath,
            "page[modelPackage='" + oldFullPath + "']", PageVO.class);
        Map<String, String[]> objResult4MetadataGenerate = metadataGenerateFacade.updateFullPath(newFullPath,
            oldFullPath, "metadataGenerate[modelPackage='" + oldFullPath + "']", MetadataGenerateVO.class);
        Map<String, String[]> objResult4Exception = exceptionFacade.updateFullPath(newFullPath, oldFullPath,
            "exception[modelPackage='" + oldFullPath + "']", ExceptionVO.class);
        // 新增
        Map<String, String[]> objResult4Function = functionFacade.updateFullPath(newFullPath, oldFullPath,
            "function[modelPackage='" + oldFullPath + "']", FunctionVO.class);
        Map<String, String[]> objResult4View = viewFacade.updateFullPath(newFullPath, oldFullPath,
            "view[modelPackage='" + oldFullPath + "']", ViewVO.class);
        Map<String, String[]> objResult4Procedure = procedureFacade.updateFullPath(newFullPath, oldFullPath,
            "procedure[modelPackage='" + oldFullPath + "']", ProcedureVO.class);
        Map<String, String[]> objResult4Serve = serveFacade.updateFullPath(newFullPath, oldFullPath,
            "serve[modelPackage='" + oldFullPath + "']", ServiceObjectVO.class);
        Map<String, String[]> objResult4Pacakage = packageFacade.updateFullPath(newFullPath, oldFullPath,
            "package[modelPackage='" + oldFullPath + "']", CapPackageVO.class);
        // 更改失败，则回滚操作（模拟事务回滚）
        if (objResult4Entity.get("error").length > 0 || objResult4Table.get("error").length > 0
            || objResult4Page.get("error").length > 0 || objResult4MetadataGenerate.get("error").length > 0
            || objResult4Exception.get("error").length > 0 || objResult4Procedure.get("error").length > 0
            || objResult4View.get("error").length > 0 || objResult4Serve.get("error").length > 0
            || objResult4Function.get("error").length > 0 || objResult4Pacakage.get("error").length > 0) {
            if (objResult4Entity.get("success").length > 0) {
                entityFacade.delEntitys(objResult4Entity.get("success"));
            }
            if (objResult4Table.get("success").length > 0) {
                tableFacade.delTables(objResult4Table.get("success"));
            }
            if (objResult4Page.get("success").length > 0) {
                pageFacade.deleteModels(objResult4Page.get("success"));
            }
            if (objResult4MetadataGenerate.get("success").length > 0) {
                metadataGenerateFacade.deleteModels(objResult4MetadataGenerate.get("success"));
            }
            if (objResult4Exception.get("success").length > 0) {
                exceptionFacade.delExceptions(objResult4Exception.get("success"));
            }
            
            // 新增
            if (objResult4Procedure.get("success").length > 0) {
                procedureFacade.delProcedures(objResult4Procedure.get("success"));
            }
            if (objResult4View.get("success").length > 0) {
                viewFacade.delVeiws(objResult4View.get("success"));
            }
            if (objResult4Serve.get("success").length > 0) {
                serveFacade.delServiceObjectList(objResult4Serve.get("success"));
            }
            if (objResult4Function.get("success").length > 0) {
                functionFacade.delFunctions(objResult4Function.get("success"));
            }
            
            if (objResult4Pacakage.get("success").length > 0) {
                packageFacade.delPackages(objResult4Pacakage.get("success"));
            }
            
            bResult = false;
        }
        
        return bResult;
    }
    
    /**
     * 根据包路径，删除元数据
     * 
     * @param fullPath 包名
     * @return 回馈处理后的信息
     * @throws ValidateException 校验异常
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean deleteMetadataByPackage(String fullPath) throws ValidateException, OperateException {
        boolean bResult = true;
        Map<String, List<EntityVO>> objResult4Entity = entityFacade.deleteMetadataByPackage(fullPath,
            "entity[modelPackage='" + fullPath + "']", EntityVO.class);
        Map<String, List<TableVO>> objResult4Table = tableFacade.deleteMetadataByPackage(fullPath,
            "table[modelPackage='" + fullPath + "']", TableVO.class);
        Map<String, List<PageVO>> objResult4Page = pageFacade.deleteMetadataByPackage(fullPath, "page[modelPackage='"
            + fullPath + "']", PageVO.class);
        Map<String, List<MetadataGenerateVO>> objResult4MetadataGenerate = metadataGenerateFacade
            .deleteMetadataByPackage(fullPath, "metadataGenerate[modelPackage='" + fullPath + "']",
                MetadataGenerateVO.class);
        Map<String, List<ExceptionVO>> objResult4Exception = exceptionFacade.deleteMetadataByPackage(fullPath,
            "exception[modelPackage='" + fullPath + "']", ExceptionVO.class);
        // 新增
        Map<String, List<FunctionVO>> objResult4Function = functionFacade.deleteMetadataByPackage(fullPath,
            "function[modelPackage='" + fullPath + "']", FunctionVO.class);
        Map<String, List<ViewVO>> objResult4View = viewFacade.deleteMetadataByPackage(fullPath, "view[modelPackage='"
            + fullPath + "']", ViewVO.class);
        Map<String, List<ProcedureVO>> objResult4Procedure = procedureFacade.deleteMetadataByPackage(fullPath,
            "procedure[modelPackage='" + fullPath + "']", ProcedureVO.class);
        Map<String, List<ServiceObjectVO>> objResult4Serve = serveFacade.deleteMetadataByPackage(fullPath,
            "serve[modelPackage='" + fullPath + "']", ServiceObjectVO.class);
        Map<String, List<CapPackageVO>> objResult4Pacakage = packageFacade.deleteMetadataByPackage(fullPath,
            "package[modelPackage='" + fullPath + "']", CapPackageVO.class);
        // 删除失败，则回滚操作（模拟事务回滚）
        if (objResult4Entity.get("error").size() > 0 || objResult4Table.get("error").size() > 0
            || objResult4Page.get("error").size() > 0 || objResult4MetadataGenerate.get("error").size() > 0
            || objResult4Exception.get("error").size() > 0 || objResult4Procedure.get("error").size() > 0
            || objResult4View.get("error").size() > 0 || objResult4Serve.get("error").size() > 0
            || objResult4Function.get("error").size() > 0 || objResult4Pacakage.get("error").size() > 0) {
            List<EntityVO> lstEntityVO = objResult4Entity.get("success");
            for (EntityVO objEntityVO : lstEntityVO) {
                entityFacade.saveEntity(objEntityVO);
            }
            List<TableVO> lstTableVO = objResult4Table.get("success");
            for (TableVO objTableVO : lstTableVO) {
                tableFacade.saveModel(objTableVO);
            }
            List<PageVO> lstPageVO = objResult4Page.get("success");
            for (PageVO objPageVO : lstPageVO) {
                pageFacade.saveModel(objPageVO);
            }
            List<MetadataGenerateVO> lstMetadataGenerateVO = objResult4MetadataGenerate.get("success");
            for (MetadataGenerateVO objMetadataGenerateVO : lstMetadataGenerateVO) {
                metadataGenerateFacade.saveModel(objMetadataGenerateVO);
            }
            List<ExceptionVO> lstExceptionVO = objResult4Exception.get("success");
            for (ExceptionVO objExceptionVO : lstExceptionVO) {
                exceptionFacade.saveException(objExceptionVO);
            }
            
            // 新增
            List<FunctionVO> lstFunctionVO = objResult4Function.get("success");
            for (FunctionVO objFunctionVO : lstFunctionVO) {
                functionFacade.saveFunction(objFunctionVO);
            }
            
            List<ViewVO> lstViewVO = objResult4View.get("success");
            for (ViewVO objViewVO : lstViewVO) {
                viewFacade.saveModel(objViewVO);
            }
            
            List<ProcedureVO> lstProcedureVO = objResult4Procedure.get("success");
            for (ProcedureVO objProcedureVO : lstProcedureVO) {
                procedureFacade.saveProcedure(objProcedureVO);
            }
            
            List<ServiceObjectVO> lstServiceObjectVO = objResult4Serve.get("success");
            for (ServiceObjectVO objServiceObjectVO : lstServiceObjectVO) {
                serveFacade.saveServiceObject(objServiceObjectVO);
            }
            
            List<CapPackageVO> lstCapPackageVO = objResult4Pacakage.get("success");
            for (CapPackageVO objCapPackageVO : lstCapPackageVO) {
                packageFacade.saveCapPackageVO(objCapPackageVO);
            }
            bResult = false;
        }
        // 删除目录
        if (bResult) {
            this.deleteOldPackageDir(fullPath);
        }
        
        return bResult;
    }
    
    /**
     * 删除旧包名目录
     * 
     * @param oldFullPath 旧包名
     * @return 是否成功
     */
    private boolean deleteOldPackageDir(String oldFullPath) {
        if (StringUtil.isBlank(oldFullPath)) {
            return true;
        }
        String[] strPaths = oldFullPath.split("\\.");
        String strMetaTmpTypeFolderPath = CacheOperator.getMetaDataRootPath();
        for (String objPath : strPaths) {
            strMetaTmpTypeFolderPath += objPath + File.separator;
        }
        // 删除空目录
        return CapFileUtils.deleteEmptyDir(strMetaTmpTypeFolderPath);
    }
    
}
