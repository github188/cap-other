/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.facade;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.model.CuiQueryVO;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewVO;
import com.comtop.cap.bm.metadata.database.loader.DatabaseLoaderFactory;
import com.comtop.cap.bm.metadata.database.loader.IDatabaseLoader;
import com.comtop.cap.bm.metadata.database.util.MetaConnection;
import com.comtop.cap.bm.metadata.entity.util.EntityImportUtils;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cip.common.util.DBUtil;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.jodd.AppContext;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 页面元数据facade类
 *
 * @author 郑重
 * @since jdk1.6
 * @version 2015-6-9 郑重
 */
@DwrProxy
@PetiteBean
public class ViewFacade extends CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(TableFacade.class);
    
    /** 包Facade */
    private final SysmodelFacade packageFacade = AppContext.getBean(SysmodelFacade.class);
    
    /**
     * 查询指定目录下所有的数据库视图
     * 
     * @param modelId 目录Id
     * @return 数据库视图列表
     */
    public List<ViewVO> queryViewOfPkgAndSubPkg(String modelId) {
        List<String> lstPkgPath = packageFacade.queryPkgPathAndAllSubPkgPathBy(modelId);
        if (lstPkgPath.isEmpty()) {
            return new ArrayList<ViewVO>(0);
        }
        List<ViewVO> lstFucntionVOs = new ArrayList<ViewVO>();
        List<ViewVO> lstTmep;
        for (String packagePath : lstPkgPath) {
            try {
                lstTmep = queryViewList(packagePath);
                lstFucntionVOs.addAll(lstTmep);
            } catch (OperateException e) {
                LOG.error("查询指定目录下的数据库视图出错，包路径：" + packagePath, e);
            }
        }
        return lstFucntionVOs;
    }
    
    /**
     * 保存
     *
     * @param viewVO 被保存的对象
     * @return 页面对象
     * @throws ValidateException 校验失败异常
     */
    @RemoteMethod
    public ViewVO saveModel(ViewVO viewVO) throws ValidateException {
        boolean bResult = viewVO.saveModel();
        return bResult ? viewVO : null;
    }
    
    /**
     * 读取数据库视图集合
     * 
     * @param queryText 过滤文本
     * @param vo 查询对象
     * @return 实体属性对象
     */
    @RemoteMethod
    public List<ViewVO> loadViewFromDatabase(String queryText, CuiQueryVO vo) {
        MetaConnection objMetaConn = EntityImportUtils.getMetaConnection();
        IDatabaseLoader objLoader = DatabaseLoaderFactory.getDataBaseLoader(objMetaConn);
        List<ViewVO> lstReturn = objLoader.loadViewFromDatabase(objMetaConn.getSchema(), queryText, false, objMetaConn);
        DBUtil.closeConnection(objMetaConn.getConn(), null, null);
        if (lstReturn == null) {
            return null;
        }
        
        int iCount = lstReturn.size();
        
        if (iCount > vo.getPageSize()) {
            int iFromIndex = (vo.getPageNo() - 1) * vo.getPageSize();
            int iToIndex = (vo.getPageNo() - 1) * vo.getPageSize() + vo.getPageSize();
            if (iToIndex > iCount) {
                iToIndex = iCount;
            }
            lstReturn.subList(iFromIndex, iToIndex);
        }
        return lstReturn;
    }
    
    /**
     * 删除模型
     *
     * @param models ID集合
     * @return 是否成功
     */
    @RemoteMethod
    public boolean delVeiws(String[] models) {
        boolean bResult = true;
        try {
            for (int i = 0; i < models.length; i++) {
                ViewVO.deleteModel(models[i]);
            }
        } catch (Exception e) {
            bResult = false;
            LOG.error("删除视图文件失败", e);
        }
        return bResult;
    }
    
    /**
     * 根据表ID，查询表对象
     *
     * @param moduleId 表ID
     * @return ViewVO 表对象
     */
    @RemoteMethod
    public ViewVO queryViewById(String moduleId) {
        ViewVO objViewVO = (ViewVO) CacheOperator.readById(moduleId);
        return objViewVO;
    }
    
    /**
     * importView
     * 
     * @param packagePath 包路径
     * @param viewVOs 视图集合
     * 
     * 
     * @return 是否导入成功
     */
    @RemoteMethod
    public boolean importView(String packagePath, ViewVO[] viewVOs) {
        if (viewVOs == null || viewVOs.length == 0) {
            // 如果未选中任何数据，则直接return
            return false;
        }
        List<ViewVO> lstViewVO = Arrays.asList(viewVOs);
        MetaConnection objMetaConn = EntityImportUtils.getMetaConnection();
        IDatabaseLoader objLoader = DatabaseLoaderFactory.getDataBaseLoader(objMetaConn);
        
        for (ViewVO objViewVO : lstViewVO) {
            List<ViewColumnVO> lstViewColumnVO = objLoader.loadViewColumnFromDataBase(objMetaConn.getSchema(),
                objViewVO.getEngName(), objMetaConn);
            objViewVO.setColumns(lstViewColumnVO);
        }
        DBUtil.closeConnection(objMetaConn.getConn(), null, null);
        this.saveViewList(packagePath, lstViewVO);
        return true;
    }
    
    /**
     * 
     * @param packagePath 模块包路径
     * @param lstViews 表元数据集合
     * @return true 成功 false 失败
     */
    public int saveViewList(String packagePath, List<ViewVO> lstViews) {
        int iCount = 0;
        String strModelId = null;
        boolean bResult = false;
        for (ViewVO viewVO : lstViews) {
            viewVO.setModelPackage(packagePath);
            viewVO.setModelType("view");
            viewVO.setModelName(viewVO.getEngName());
            strModelId = viewVO.getModelPackage() + "." + viewVO.getModelType() + "." + viewVO.getModelName();
            viewVO.setModelId(strModelId);
            convertViewColumnDataType(viewVO.getColumns());
            try {
                bResult = viewVO.saveModel();
                if (bResult) {
                    iCount++;
                }
            } catch (ValidateException e) {
                LOG.error("视图元数据对象保存失败：" + viewVO, e);
            }
        }
        return iCount;
    }
    
    /**
     * <pre>
     * 数据库列类型转换
     * </pre>
     * 
     * @param lstViewColumnVO lstViewColumnVO
     */
    private void convertViewColumnDataType(List<ViewColumnVO> lstViewColumnVO) {
        for (ViewColumnVO objViewColumnVO : lstViewColumnVO) {
            String strDataType = objViewColumnVO.getDataType();
            strDataType = strDataType.replaceAll("(\\(\\d+\\))", "");
            objViewColumnVO.setDataType(strDataType);
        }
    }
    
    /**
     * 根据应用id查询视图列表（供文档导入导出使用）
     * 
     * @param appId 应用id，即包id
     * 
     * @return 视图列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<ViewVO> queryViewListByAppId(String appId) throws OperateException {
        CapPackageVO objPackageVO = packageFacade.queryPackageById(appId);
        String strPackagePath = objPackageVO.getFullPath();
        return queryViewList(strPackagePath);
    }
    
    /**
     * 查询视图列表
     * 
     * @param packagePath 模块包路径
     * 
     * @return 实体列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<ViewVO> queryViewList(String packagePath) throws OperateException {
        List<ViewVO> lstViewVOs = CacheOperator.queryList(packagePath + "/view", ViewVO.class);
        return lstViewVOs;
        
    }
}
