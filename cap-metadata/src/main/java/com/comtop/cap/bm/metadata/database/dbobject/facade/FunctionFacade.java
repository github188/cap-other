
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
import com.comtop.cap.bm.metadata.database.dbobject.model.FunctionColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.FunctionVO;
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
 * @author zhangzunzhi
 * @since 1.0
 * @version 2015-12-23 zhangzunzhi
 */
@DwrProxy
@PetiteBean
public class FunctionFacade extends CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(TableFacade.class);
    
    /** 包Facade */
    private final SysmodelFacade packageFacade = AppContext.getBean(SysmodelFacade.class);
    
    /**
     * 查询指定目录下所有的数据库函数
     * 
     * @param modelId 目录Id
     * @return 数据库函数列表
     */
    public List<FunctionVO> queryFunctionOfPkgAndSubPkg(String modelId) {
        List<String> lstPkgPath = packageFacade.queryPkgPathAndAllSubPkgPathBy(modelId);
        if (lstPkgPath.isEmpty()) {
            return new ArrayList<FunctionVO>(0);
        }
        List<FunctionVO> lstFucntionVOs = new ArrayList<FunctionVO>();
        List<FunctionVO> lstTmep;
        for (String packagePath : lstPkgPath) {
            try {
                lstTmep = queryProcedureList(packagePath);
                lstFucntionVOs.addAll(lstTmep);
            } catch (OperateException e) {
                LOG.error("查询指定目录下的数据库函数出错，包路径：" + packagePath, e);
            }
        }
        return lstFucntionVOs;
    }
    
    /**
     * 读取数据库函数集合
     * 
     * @param queryText 过滤文本
     * @param vo 查询对象
     * @return 实体属性对象
     */
    @RemoteMethod
    public List<FunctionVO> loadFunctinFromDatabase(String queryText, CuiQueryVO vo) {
        MetaConnection objMetaConn = EntityImportUtils.getMetaConnection();
        IDatabaseLoader objLoader = DatabaseLoaderFactory.getDataBaseLoader(objMetaConn);
        List<FunctionVO> lstReturn = objLoader.loadFunctionsFromDatabase(objMetaConn.getSchema(), queryText, false,
            objMetaConn);
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
    public boolean delFunctions(String[] models) {
        boolean bResult = true;
        try {
            for (int i = 0; i < models.length; i++) {
                FunctionVO.deleteModel(models[i]);
            }
        } catch (Exception e) {
            bResult = false;
            LOG.error("删除函数文件失败", e);
        }
        return bResult;
    }
    
    /**
     * 根据表ID，查询存储过程对象
     *
     * @param moduleId 表ID
     * @return ViewVO 表对象
     */
    @RemoteMethod
    public FunctionVO queryFunctionById(String moduleId) {
        FunctionVO objFunctionVO = (FunctionVO) CacheOperator.readById(moduleId);
        return objFunctionVO;
    }
    
    /**
     * importView
     * 
     * @param packagePath 包路径
     * @param functionVOs 视图集合
     * 
     * 
     * @return 是否导入成功
     */
    @RemoteMethod
    public boolean importFunctions(String packagePath, FunctionVO[] functionVOs) {
        if (functionVOs == null || functionVOs.length == 0) {
            // 如果未选中任何数据，则直接return
            return false;
        }
        List<FunctionVO> lstFunctionVO = Arrays.asList(functionVOs);
        MetaConnection objMetaConn = EntityImportUtils.getMetaConnection();
        IDatabaseLoader objLoader = DatabaseLoaderFactory.getDataBaseLoader(objMetaConn);
        
        for (FunctionVO objFunctionVO : lstFunctionVO) {
            List<FunctionColumnVO> lstFunctionColumnVO = objLoader.loadFunctionColumnFromDataBase(
                objMetaConn.getSchema(), objFunctionVO.getEngName(), objMetaConn);
            objFunctionVO.setFunctionColumns(lstFunctionColumnVO);
        }
        DBUtil.closeConnection(objMetaConn.getConn(), null, null);
        this.saveFunctionList(packagePath, lstFunctionVO);
        return true;
    }
    
    /**
     * 
     * @param packagePath 模块包路径
     * @param lstFunctionVO 函数元数据集合
     * @return true 成功 false 失败
     */
    public int saveFunctionList(String packagePath, List<FunctionVO> lstFunctionVO) {
        int iCount = 0;
        String strModelId = null;
        boolean bResult = false;
        for (FunctionVO objFunctionVO : lstFunctionVO) {
            objFunctionVO.setModelPackage(packagePath);
            objFunctionVO.setModelType("function");
            objFunctionVO.setModelName(objFunctionVO.getEngName());
            strModelId = objFunctionVO.getModelPackage() + "." + objFunctionVO.getModelType() + "."
                + objFunctionVO.getModelName();
            objFunctionVO.setModelId(strModelId);
            try {
                bResult = objFunctionVO.saveModel();
                if (bResult) {
                    iCount++;
                }
            } catch (ValidateException e) {
                LOG.error("函数元数据对象保存失败：" + objFunctionVO, e);
            }
        }
        return iCount;
    }
    
    /**
     * 根据应用id查询函数列表（供文档导入导出使用）
     * 
     * @param appId 应用id，即包id
     * 
     * @return 函数列表
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<FunctionVO> queryFunctionListByAppId(String appId) throws OperateException {
        CapPackageVO objPackageVO = packageFacade.queryPackageById(appId);
        String strPackagePath = objPackageVO.getFullPath();
        return queryProcedureList(strPackagePath);
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
    public List<FunctionVO> queryProcedureList(String packagePath) throws OperateException {
        List<FunctionVO> lstFunctionVOs = CacheOperator.queryList(packagePath + "/function", FunctionVO.class);
        return lstFunctionVOs;
        
    }
    
    /**
     * 保存
     * 
     * @param functionVO 被保存的对象
     * @return 实体对象
     * @throws ValidateException 校验失败异常
     */
    @RemoteMethod
    public FunctionVO saveFunction(FunctionVO functionVO) throws ValidateException {
        boolean bResult = functionVO.saveModel();
        return bResult ? functionVO : null;
    }
}
