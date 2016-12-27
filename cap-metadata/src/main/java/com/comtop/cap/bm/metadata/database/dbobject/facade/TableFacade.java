/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.biz.domain.facede.BizDomainFacade;
import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.consistency.entity.appservice.EntityConsistencyAppService;
import com.comtop.cap.bm.metadata.database.analyze.CompareAnalyzerFactory;
import com.comtop.cap.bm.metadata.database.datasource.CompareState;
import com.comtop.cap.bm.metadata.database.dbobject.IDBType;
import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableCompareResult;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableIndexVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.database.dbobject.util.DBType;
import com.comtop.cap.bm.metadata.database.dbobject.util.DBTypeAdapter;
import com.comtop.cap.bm.metadata.database.dbobject.util.TableSysncEntityUtil;
import com.comtop.cap.bm.metadata.database.loader.DatabaseLoaderFactory;
import com.comtop.cap.bm.metadata.database.loader.IDatabaseLoader;
import com.comtop.cap.bm.metadata.database.model.AnalyzeResult;
import com.comtop.cap.bm.metadata.database.model.CompareVO;
import com.comtop.cap.bm.metadata.database.util.MetaConnection;
import com.comtop.cap.bm.metadata.database.util.TableUtils;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.util.EntityImportUtils;
import com.comtop.cap.bm.metadata.preferencesconfig.PreferenceConfigQueryUtil;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.bm.metadata.utils.StringConvertor;
import com.comtop.cap.runtime.base.dao.CapBaseCommonDAO;
import com.comtop.cap.runtime.core.AppBeanUtil;
import com.comtop.cip.common.util.DBUtil;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.core.jodd.AppContext;

import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * Table元数据facade类
 * 
 * @author 许畅
 * @since jdk1.7
 * @version 2016-11-8 许畅
 */
@DwrProxy
@PetiteBean
public class TableFacade extends CapBmBaseFacade implements IDBType {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(TableFacade.class);
    
    /** 包Facade */
    private final SysmodelFacade packageFacade = AppContext.getBean(SysmodelFacade.class);
    
    /** 业务域业务逻辑处理类面Facade */
    protected final BizDomainFacade bizDomainFacade = AppBeanUtil.getBean(BizDomainFacade.class);
    
    /** 注入EntityConsistencyAppService */
    private final EntityConsistencyAppService entityConsistencyAppService = AppContext
        .getBean(EntityConsistencyAppService.class);
    
    /**
     * 查询指定目录下所有的数据库表
     * 
     * @param modelId 目录Id
     * @return 数据库表列表
     */
    public List<TableVO> queryTableOfPkgAndSubPkg(String modelId) {
        List<String> lstPkgPath = packageFacade.queryPkgPathAndAllSubPkgPathBy(modelId);
        if (lstPkgPath.isEmpty()) {
            return new ArrayList<TableVO>(0);
        }
        List<TableVO> lstFucntionVOs = new ArrayList<TableVO>();
        List<TableVO> lstTmep;
        for (String packagePath : lstPkgPath) {
            try {
                lstTmep = queryTableList(packagePath);
                lstFucntionVOs.addAll(lstTmep);
            } catch (OperateException e) {
                LOG.error("查询指定目录下的数据库表出错，包路径：" + packagePath, e);
            }
        }
        return lstFucntionVOs;
    }
    
    /**
     * 保存
     * 
     * @param tableVO 被保存的对象
     * @return 页面对象
     * @throws ValidateException 校验失败异常
     */
    @RemoteMethod
    public TableVO saveModel(TableVO tableVO) throws ValidateException {
        TableSysncEntityUtil.initPrimarykeyIndex(tableVO);
        boolean bResult = tableVO.saveModel();
        return bResult ? tableVO : null;
    }
    
    /**
     * 保存并同步实体属性
     * 
     * @param tableVO
     *            保存的对象
     * @param packageId
     *            包id
     * @return Table 元数据对象
     * @throws ValidateException
     *             校验失败异常
     * @throws OperateException
     *             Xml操作异常
     */
    @RemoteMethod
    public TableVO saveAndSysncEntity(TableVO tableVO, String packageId) throws ValidateException, OperateException {
        // 分析差异
        CompareVO compareVO = this.analyzeDifferent(tableVO, packageId);
        // 同步实体
        this.synscEntity(compareVO);
        
        return compareVO.getSrc();
    }
    
    /**
     * 分析表结构和实体属性差异信息
     * 
     * @param tableVO
     *            表信息
     * @param packageId
     *            包id
     * @return map
     * @throws ValidateException
     *             ValidateException
     */
    @RemoteMethod
    public CompareVO analyzeDifferent(TableVO tableVO, String packageId) throws ValidateException {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("packageId", packageId);
        return CompareAnalyzerFactory.getCompareAnalyzer(tableVO, param).deepAnalyze();
    }
    
    /**
     * 同步实体
     * 
     * @param compareVO
     *            比较VO模型
     * 
     * @throws ValidateException
     *             校验异常
     * @throws OperateException
     *             操作异常
     */
    @RemoteMethod
    public void synscEntity(CompareVO compareVO) throws ValidateException, OperateException {
        TableVO tableVO = compareVO.getSrc();
        List<AnalyzeResult> lst = compareVO.getAnalyzeResults();
        boolean isNew = compareVO.isNew();
        // 保存表信息
        this.saveModel(tableVO);
        EntityVO objEntity = compareVO.getTarget();
        
        // 更新实体
        if (!isNew) {
            objEntity = (EntityVO) CacheOperator.readById(objEntity.getModelId());
        }
        Map<String, EntityAttributeVO> deleteMap = new HashMap<String, EntityAttributeVO>();
        Map<String, EntityAttributeVO> modifyMap = new HashMap<String, EntityAttributeVO>();
        List<EntityAttributeVO> addedAttr = new ArrayList<EntityAttributeVO>();
        for (AnalyzeResult data : lst) {
            EntityAttributeVO attr = data.getAttribute();
            if (CompareState.ADD.getValue().equals(data.getState())) {
                addedAttr.add(attr);
            }
            if (CompareState.DELETE.getValue().equals(data.getState())) {
                deleteMap.put(attr.getEngName(), attr);
            }
            if (CompareState.MODIFY.getValue().equals(data.getState())) {
                modifyMap.put(attr.getEngName(), attr);
            }
        }
        List<EntityAttributeVO> totalAttr = new ArrayList<EntityAttributeVO>();// 所有属性
        List<EntityAttributeVO> relationAttr = new ArrayList<EntityAttributeVO>();// 关系属性
        if (!isNew)
            for (EntityAttributeVO attr : objEntity.getAttributes()) {
                if (deleteMap.containsKey(attr.getEngName())) {
                    continue;
                } else if (modifyMap.containsKey(attr.getEngName())) {
                    totalAttr.add(modifyMap.get(attr.getEngName()));
                } else if (StringUtils.isNotEmpty(attr.getRelationId())) {
                    relationAttr.add(attr);
                } else {
                    // 没有发生变化的
                    totalAttr.add(attr);
                }
            }
        totalAttr.addAll(addedAttr);
        totalAttr.addAll(relationAttr);
        // 排序属性
        TableSysncEntityUtil.sortEntityAttributes(totalAttr);
        objEntity.setAttributes(totalAttr);
        this.setEntityBaseAttribute(objEntity, tableVO);
        // 保存实体属性
        objEntity.saveModel();
    }
    
    /**
     * 同步基础信息
     * 
     * @param compareVO
     *            比较信息
     * @throws OperateException
     *             OperateException
     * @throws ValidateException
     *             ValidateException
     */
    @RemoteMethod
    public void sysncBaseInfo(CompareVO compareVO) throws ValidateException, OperateException {
        EntityVO entity = (EntityVO) CacheOperator.readById(compareVO.getTarget().getModelId());
        TableVO table = compareVO.getSrc();
        this.saveModel(table);
        setEntityBaseAttribute(entity, table);
        entity.saveModel();
    }
    
    /**
     * 设置实体基本属性
     * 
     * @param entity
     *            实体信息
     * @param table
     *            表信息
     * @throws ValidateException 校验异常
     * @throws OperateException 操作异常
     */
    private void setEntityBaseAttribute(EntityVO entity, TableVO table) throws ValidateException, OperateException {
        entity.setChName(table.getChName());
        entity.setDescription(table.getDescription());
        // 如果表名发生改变,删除旧实体,生成新实体
        if (!table.getEngName().equals(entity.getDbObjectName())) {
            entity.deleteModel();// 删除旧实体
            String strEngName = StringConvertor.toCamelCase(table.getEngName(),
                PreferenceConfigQueryUtil.getTablePrefixIngore());
            String aliasName = strEngName.substring(0, 1).toLowerCase() + strEngName.substring(1);
            entity.setEngName(strEngName);
            entity.setAliasName(aliasName);
            entity.setDbObjectName(table.getEngName());
            entity.setModelName(entity.getEngName());
            String strModelId = entity.getModelPackage() + "." + entity.getModelType() + "." + entity.getModelName();
            entity.setModelId(strModelId);
        }
    }
    
    /**
     * 初始化Table业务控制信息
     * 
     * @param tableName
     *            表名
     * @param funcCode 模块id
     * @return 是否存在该表
     */
    @RemoteMethod
    public Map<String, Object> initTableBizControl(String tableName, String funcCode) {
        Map<String, Object> bizControl = new HashMap<String, Object>();
        EntityVO entity = new EntityVO();
        entity.setDbObjectName(tableName);
        
        bizControl.put("isTableExsit", entityConsistencyAppService.checkTableIsExist_oracle(entity));
        bizControl.put("reqTreeVOs", bizDomainFacade.queryDomainListByfuncCode(funcCode));
        return bizControl;
    }
    
    /**
     * 根据表ID，查询表对象
     * 
     * @param moduleId 表ID
     * @return TableVO 表对象
     */
    @RemoteMethod
    public TableVO queryTableById(String moduleId) {
        TableVO objTableVO = (TableVO) CacheOperator.readById(moduleId);
        return objTableVO;
    }
    
    /**
     * 删除表
     * 
     * @param models ID集合
     * @return 是否成功
     */
    @RemoteMethod
    public boolean delTables(String[] models) {
        boolean bResult = true;
        try {
            for (int i = 0; i < models.length; i++) {
                TableVO.deleteModel(models[i]);
            }
        } catch (Exception e) {
            bResult = false;
            LOG.error("删除表文件失败", e);
        }
        return bResult;
    }
    
    /**
     * 
     * @param packagePath 模块包路径
     * @param lstTables 表元数据集合
     * @return true 成功 false 失败
     */
    public int saveTableList(String packagePath, List<TableVO> lstTables) {
        int iCount = 0;
        String strModelId = null;
        boolean bResult = false;
        for (TableVO tableVO : lstTables) {
            tableVO.setModelPackage(packagePath);
            tableVO.setModelType("table");
            tableVO.setModelName(tableVO.getEngName());
            strModelId = tableVO.getModelPackage() + "." + tableVO.getModelType() + "." + tableVO.getModelName();
            tableVO.setModelId(strModelId);
            convertTableColumnDataType(tableVO.getColumns());
            try {
                bResult = tableVO.saveModel();
                if (bResult) {
                    iCount++;
                }
            } catch (ValidateException e) {
                LOG.error("表元数据对象保存失败：" + tableVO, e);
            }
        }
        return iCount;
    }
    
    /**
     * <pre>
     * 数据库列类型转换
     * </pre>
     * 
     * @param lstColumnVO lstColumnVO
     */
    private void convertTableColumnDataType(List<ColumnVO> lstColumnVO) {
        for (ColumnVO objColumnVO : lstColumnVO) {
            String strDataType = objColumnVO.getDataType();
            strDataType = strDataType.replaceAll("\\(.+\\)", "");
            objColumnVO.setDataType(strDataType);
        }
    }
    
    /**
     * 查表列表
     * 
     * @param packagePath 模块包路径
     * 
     * @return 实体列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<TableVO> queryTableList(String packagePath) throws OperateException {
        List<TableVO> lstTableVOs = CacheOperator.queryList(packagePath + "/table", TableVO.class);
        return lstTableVOs;
    }
    
    /**
     * 根据表名查询Table元数据
     * 
     * @param table
     *            Table元数据信息
     * @return table列表集合
     * @throws OperateException
     *             异常
     */
    @RemoteMethod
    public List<TableVO> queryTableByName(TableVO table) throws OperateException {
        String expression = table.getModelPackage() + "/table[@engName='" + table.getEngName() + "' and @modelId!='"
            + table.getModelId() + "']";
        List<TableVO> lstTableVOs = CacheOperator.queryList(expression, TableVO.class);
        return lstTableVOs;
    }
    
    /**
     * 比较table,用于生成数据库增量SQL
     * 
     * @param modelIds modelId列表
     * @return 表比较结果列表
     */
    public List<TableCompareResult> compareTable(List<String> modelIds) {
        List<TableCompareResult> lstResult = null;
        if (null != modelIds) {
            lstResult = new ArrayList<TableCompareResult>();
            MetaConnection objMetaConn = EntityImportUtils.getMetaConnection();
            for (String modelId : modelIds) {
                // 通过modelId获取表本地表元数据
                TableVO srcTableVO = (TableVO) TableVO.loadModel(modelId);
                // 通过表名获取数据库最新的表信息元数据
                List<TableVO> lstTableVO = loadTableFromDatabase(objMetaConn.getSchema(), srcTableVO.getEngName(), 2,
                    true, true, objMetaConn);
                if (null != lstTableVO && lstTableVO.size() > 0) {
                    TableVO targetTableVO = setMessageToTableVO(lstTableVO.get(0), srcTableVO);
                    // 获取比较结果
                    TableCompareResult objResult = TableUtils.compareTable(srcTableVO, targetTableVO,
                        srcTableVO.getEngName());
                    lstResult.add(objResult);
                } else {
                    TableCompareResult objResult = new TableCompareResult();
                    objResult.setResult(TableCompareResult.TABLE_NOT_EXISTS);
                    lstResult.add(objResult);
                }
            }
            DBUtil.closeConnection(objMetaConn.getConn(), null, null);
        }
        return lstResult;
    }
    
    /**
     * 比较table,元数据同步至数据库,以元数据为主
     * 
     * @param modelIds
     *            modelIds
     * @return TableCompareResult
     */
    public List<TableCompareResult> compareMetadataToDB(List<String> modelIds) {
        List<TableCompareResult> lstResult = null;
        if (null != modelIds) {
            lstResult = new ArrayList<TableCompareResult>();
            MetaConnection objMetaConn = EntityImportUtils.getMetaConnection();
            for (String modelId : modelIds) {
                // 通过modelId获取表本地表元数据
                TableVO srcTableVO = (TableVO) TableVO.loadModel(modelId);
                // 通过表名获取数据库最新的表信息元数据
                List<TableVO> lstTableVO = loadTableFromDatabase(objMetaConn.getSchema(), srcTableVO.getEngName(), 2,
                    true, true, objMetaConn);
                if (null != lstTableVO && lstTableVO.size() > 0) {
                    TableVO targetTableVO = setMessageToTableVO(lstTableVO.get(0), srcTableVO);
                    // 获取比较结果
                    TableCompareResult objResult = TableUtils.compareTable(targetTableVO, srcTableVO,
                        srcTableVO.getEngName());
                    lstResult.add(objResult);
                } else {
                    TableCompareResult objResult = new TableCompareResult();
                    objResult.setResult(TableCompareResult.TABLE_NOT_EXISTS);
                    objResult.setTargetTable(srcTableVO);
                    lstResult.add(objResult);
                }
            }
            DBUtil.closeConnection(objMetaConn.getConn(), null, null);
        }
        return lstResult;
    }
    
    /**
     * 从数据库中获取表
     * 
     * @param schema 数据库模式
     * @param tablePatten 表名称模式
     * @param prefix 忽略前缀数
     * @param exact 精确的，TRUE表示精确查询，false表示模糊查询
     * @param cascade 是否级联查询表字段和表索引
     * @param conn 数据库连接元数据
     * 
     * @return 表对象集合，当为精确查询时，返回的集合中应该只有一个表对象
     */
    public List<TableVO> loadTableFromDatabase(final String schema, final String tablePatten, final Integer prefix,
        final boolean exact, final boolean cascade, final MetaConnection conn) {
        IDatabaseLoader objLoader = DatabaseLoaderFactory.getDataBaseLoader(conn);
        List<TableVO> lstTableVO = objLoader.loadEntityFromDatabase(schema, tablePatten, prefix, exact, conn);
        
        if (CollectionUtils.isEmpty(lstTableVO)) {
            return null;
        }
        if (cascade) {
            for (TableVO objTableVO : lstTableVO) {
                // 获取字段
                String strTableName = objTableVO.getCode();
                // 数据库列对象集合
                List<ColumnVO> lstColumnVO = objLoader.loadEntityAttributeFromDataBase(schema, strTableName, conn);
                objTableVO.setColumns(lstColumnVO);
                // 数据库索引对象集合
                List<TableIndexVO> lstTableIndexVO = objLoader.loadTableIndexesFromDataBase(schema, strTableName, conn);
                objTableVO.setIndexs(lstTableIndexVO);
            }
        }
        return lstTableVO;
    }
    
    /**
     * 
     * 从数据库load出数据后，设置相关表的信息 ，如 modelId
     * 
     * @param newTableVO 新表对象
     * @param oldTableVO 旧表对象
     * @return 表对象 newTableVO
     */
    public TableVO setMessageToTableVO(TableVO newTableVO, TableVO oldTableVO) {
        newTableVO.setCreaterId(oldTableVO.getCreaterId());
        newTableVO.setCreaterName(oldTableVO.getCreaterName());
        newTableVO.setCreateTime(System.currentTimeMillis());
        newTableVO.setEngName(newTableVO.getCode());
        newTableVO.setModelPackage(oldTableVO.getModelPackage());
        newTableVO.setModelType("table");
        newTableVO.setModelName(newTableVO.getEngName());
        newTableVO.setModelId(oldTableVO.getModelId());
        convertTableColumnDataType(newTableVO.getColumns());
        return newTableVO;
    }
    
    /**
     * 
     * 判断表比较结果对象列表中的表是否发生变化
     * 
     * @param lstResult 表比较结果对象列表
     * @return 是否存在变化的表
     */
    public int getTableChangeType(List<TableCompareResult> lstResult) {
        int changeType = 0;
        for (TableCompareResult objResult : lstResult) {
            if (objResult.getResult() == TableCompareResult.TABLE_DIFF) {
                changeType = 1;
                break;
            } else if (objResult.getResult() == TableCompareResult.TABLE_NOT_EXISTS) {
                changeType = -1;
                break;
            }
        }
        return changeType;
    }
    
    /**
     * 查询DB当前表是否存在
     * 
     * @param tableName
     *            表名
     * @return 当前表是否存在
     */
    @RemoteMethod
    public boolean isTableExsits(String tableName) {
        CapBaseCommonDAO<?> capBaseCommonDAO = AppContext.getBean(CapBaseCommonDAO.class);
        Map<String, String> params = new HashMap<String, String>();
        params.put("tableName", tableName);
        Integer counts = null;
        try {
            counts = (Integer) capBaseCommonDAO.selectOne("com.comtop.cap.bm.metadata.pdm.isTableExsits", params);
        } catch (Exception e) {
            LOG.debug(e.getMessage(), e);
        }
        return counts != null;
    }
    
    /**
     * 获取数据库类型
     * 
     * @return 数据库类型
     * 
     * @see com.comtop.cap.bm.metadata.database.dbobject.IDBType#getDataBaseType()
     */
    @Override
    public DBType getDataBaseType() {
        return DBTypeAdapter.getDBType();
    }
    
	/**
	 * 获取首选项工作流字段
	 * 
	 * @return 获取首选项工作流字段
	 */
	@RemoteMethod
	public String[] getWorkflowMarchRule() {
		return PreferenceConfigQueryUtil.getWorkflowMarchRule();
	}
    
	/**
	 * 获取数据库类型
	 * 
	 * @return 数据库类型
	 */
	@RemoteMethod
	public String getDBType() {
		return getDataBaseType().getValue();
	}
    
    /**
     * 查询该包路径下是否存在相同实体名称
     * 
     * @param modelPackage 包全路径
     * @param engName 实体名称
     * @param modelId 实体模块ID
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistSameNameTable(String modelPackage, String engName, String modelId) throws OperateException {
        boolean bResult = false;
        List<TableVO> lstTableVO = CacheOperator.queryList(modelPackage + "/table", TableVO.class);
        for (TableVO objTableVO : lstTableVO) {
            String strEngName = objTableVO.getEngName();
            String strModelId = objTableVO.getModelId();
            if (strEngName.equals(engName) && !strModelId.equals(modelId)) {
                bResult = true;
                break;
            }
        }
        return bResult;
    }
}
