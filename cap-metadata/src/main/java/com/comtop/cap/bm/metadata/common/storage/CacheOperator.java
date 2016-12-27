/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.contentobjects.jnotify.JNotify;
import net.contentobjects.jnotify.JNotifyListener;

import org.apache.commons.beanutils.BeanUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.handler.DataHandlerStrategy;
import com.comtop.cap.bm.metadata.common.storage.handler.HandlerContext;
import com.comtop.cap.bm.metadata.common.storage.relation.AggregationMetadata;
import com.comtop.cap.bm.metadata.common.storage.relation.IgnoreMetadata;
import com.comtop.cap.bm.metadata.common.storage.relation.MarginMetadata;
import com.comtop.cip.json.JSON;
import com.comtop.cip.json.serializer.SerializerFeature;
import com.comtop.top.component.common.systeminit.WebGlobalInfo;

/**
 * 缓存操作
 *
 * @author 郑重
 * @version jdk1.5
 * @version 2015-4-22 郑重
 */
public class CacheOperator {
    
    /**
     * 构造函数
     */
    private CacheOperator() {
        
    }
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(CacheOperator.class);
    
    /**
     * 全局缓存集合
     */
    private static final String GLOBAL_CACHE = "g";
    
    /**
     * 模型类型映射配置，如果增加新的模型类则在此添加
     */
    private static final ModelClassConfig modelClassConfig = ModelClassConfig.load();
    
    /**
     * 模型缓存
     */
    private final static Map<String, Object> modelCache = new HashMap<String, Object>();
    
    /**
     * 对象操作
     */
    private final static ObjectOperator objectOperator = new ObjectOperator(modelCache);
    
    /**
     * 文件modify时间
     */
    private final static Map<String, Long> fileModifyMap = new HashMap<String, Long>();
    
    /** Graph观察者 */
	private static GraphMainObservable observable = GraphMainObservable.getInstance();
    
    /**
     * 元数据根目录
     */
    private static String metaDataRootPath;
    
    static {
        try {
            metaDataRootPath = WebGlobalInfo.getWebInfoPath() + File.separator + "metadata" + File.separator;
            initMetaDataFileListener();
            initMetaDataCache();
            initGraphObser();
        } catch (Throwable e) {
            logger.error("数据模型缓存启动失败", e);
        }
    }
    
    /**
     * @return the metaDataRootPath
     */
    public static String getMetaDataRootPath() {
        return metaDataRootPath;
    }
    
    /**
     * @param metaDataRootPath the metaDataRootPath to set
     */
    public static void setMetaDataRootPath(String metaDataRootPath) {
        CacheOperator.metaDataRootPath = metaDataRootPath;
    }
    
    /**
     * 根据模型ID获取模型文件
     * 
     * @param id 模型对象唯一标识
     * @return 文件
     */
    public static File getFile(final String id) {
        File objFile = null;
        // com.comtop.fwms.defect.entity.defect
        if (!"".equals(id)) {
            String[] strPaths = id.split("\\.");
            int iLong = strPaths.length;
            String strType = strPaths[iLong - 2];
            TypeConfig objTypeConfig = modelClassConfig.get(strType);
            String strName = strPaths[iLong - 1] + "." + strType + "." + objTypeConfig.getFileType();
            String strPackage = "";
            for (int i = 0; i < iLong - 2; i++) {
                strPackage += File.separator + strPaths[i];
            }
            String strFilePath = getMetaDataRootPath() + strPackage + File.separator + strType + File.separator
                + strName;
            objFile = new File(strFilePath);
        }
        return objFile;
    }
    
    /**
     * 对象克隆
     * 
     * @param value value
     * @return Object
     */
    public static Object clone(final Object value) {
        if (value != null) {
            String str = JSON.toJSONString(value, SerializerFeature.WriteClassName);
            // JSONObject object = (JSONObject) JSON.toJSON(value);
            return JSON.parseObject(str, value.getClass());
        }
        return null;
    }
    
    /**
     * 对象克隆
     * 
     * @param <T> Class
     * @param value value
     * @return Object
     */
    @SuppressWarnings("unchecked")
    public static <T extends BaseMetadata> List<T> cloneList(final List<T> value) {
        List<T> lstResult = null;
        if (value != null) {
            lstResult = new ArrayList<T>(value.size());
            for (int i = 0; i < value.size(); i++) {
                if (value.get(i) instanceof BaseModel) {
                    lstResult.add((T) readById(((BaseModel) value.get(i)).getModelId()));
                } else {
                    lstResult.add(value.get(i));
                }
            }
        }
        return lstResult;
    }
    
    /**
     * 读取模型对象
     * 
     * @param id 模型ID
     * @return 模型对象
     */
    @SuppressWarnings("unchecked")
    public static Object readById(final String id) {
        Map<String, Object> objGlobarMap = (Map<String, Object>) modelCache.get(GLOBAL_CACHE);
        Object objResult = clone(objGlobarMap.get(id));
        objResult = MarginMetadata.beans(objResult).margin();
        AggregationMetadata.beans(objResult).margin();
        return objResult;
    }
    
    /**
     * 读取模型对象,不包含继承的对象
     * 
     * @param id 模型ID
     * @return 模型对象
     */
    @SuppressWarnings("unchecked")
    public static Object read(final String id) {
        Map<String, Object> objGlobarMap = (Map<String, Object>) modelCache.get(GLOBAL_CACHE);
        Object objResult = clone(objGlobarMap.get(id));
        return objResult;
    }
    
    /**
     * 集合查询
     * 
     * @param expression 表达式
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public static List queryList(final String expression) throws OperateException {
        return cloneList(objectOperator.queryList(expression));
    }
    
    /**
     * 集合查询
     * 
     * @param expression 表达式
     * @return 数量
     * @throws OperateException 对象操作异常
     */
    @SuppressWarnings("rawtypes")
    public static int queryCount(final String expression) throws OperateException {
        List lst = objectOperator.queryList(expression);
        return lst == null ? 0 : lst.size();
    }
    
    /**
     * 集合查询
     * 
     * @param <T> BaseMetadata
     * @param expression 表达式
     * @param c 返回结果类型
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    public static <T extends BaseMetadata> List<T> queryList(final String expression, Class<T> c)
        throws OperateException {
        return cloneList(objectOperator.queryList(expression, c));
    }
    
    /**
     * 集合查询
     * 
     * @param expression 表达式
     * @param pageSize 1页记录数
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public static List queryList(final String expression, int pageSize) throws OperateException {
        return cloneList(objectOperator.queryList(expression, pageSize));
    }
    
    /**
     * 集合查询
     * 
     * @param <T> BaseMetadata
     * @param expression 表达式
     * @param c 返回结果类型
     * @param pageSize 1页记录数
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    public static <T extends BaseMetadata> List<T> queryList(final String expression, Class<T> c, int pageSize)
        throws OperateException {
        
        return cloneList(objectOperator.queryList(expression, c, pageSize));
    }
    
    /**
     * 集合查询
     * 
     * @param <T> BaseMetadata
     * @param expression 表达式
     * @param c 返回结果类型
     * @param pageNo 页码
     * @param pageSize 1页记录数
     * @return 查询结果集
     * @throws OperateException 对象操作异常
     */
    public static <T extends BaseMetadata> List<T> queryList(final String expression, Class<T> c, int pageNo,
        int pageSize) throws OperateException {
        
        return cloneList(objectOperator.queryList(expression, c, pageNo, pageSize));
    }
    
    /**
     * 系统启动初始化缓存
     */
    public static void initMetaDataCache() {
        fileSacn(new File(metaDataRootPath));
    }
    
	/**
	 * 等元数据加载完成后设置为可用状态
	 */
	public static void initGraphObser() {
		observable.setAlbe(true);
	}
    
    /**
     * 遍历元数据目录加载元数据到缓存
     * 
     * @param rootPath 元数据根目录
     */
    private static void fileSacn(File rootPath) {
        if (!rootPath.isDirectory()) {
            fileLoad(rootPath);
        } else {
            File[] objFile = rootPath.listFiles();
            for (int i = 0; i < objFile.length; i++) {
                if (!objFile[i].isDirectory()) {
                    fileLoad(objFile[i]);
                } else {
                    fileSacn(objFile[i]);
                }
            }
        }
    }
    
    /**
     * 加载元数据
     * 
     * @param file 加载文件
     */
    private static void fileLoad(File file) {
        if (file != null && file.exists() && !file.isDirectory() && file.getName().split("\\.").length == 3) {
            if (fileModifyMap.get(file.getPath()) == null || file.lastModified() > fileModifyMap.get(file.getPath())) {
                try {
                    String strModelType = getModelType(file);
                    TypeConfig objTypeConfig = modelClassConfig.get(strModelType);
                    Class<?> objModelType = objTypeConfig.getType();
                    BaseModel objBaseModel = (BaseModel) readFile(file, objModelType);
                    updateCache(objBaseModel);
                    fileModifyMap.put(file.getPath(), file.lastModified());
                    logger.debug("成功加载模型文件：" + file.getName());
                } catch (Exception e) {
                    logger.error("模型文件 " + file.getName() + " 加载失败", e);
                }
            }
        }
    }
    
    /**
     * 加载元数据
     * 
     * @param baseModel 元数据对象
     * 
     * @throws OperateException 异常
     */
    private static void updateCache(BaseModel baseModel) throws OperateException {
        for (Iterator<DataHandlerStrategy> it = HandlerContext.getLstHandler().iterator(); it.hasNext();) {
            DataHandlerStrategy handler = it.next();
            if (baseModel.getModelType().equals(handler.getModelType())) {
                handler.invoke(baseModel);
            }
        }
        try {
            // 存入全局缓存对象,如果首次加载能同时更新以下两个集合
            if (addGlobarMap(baseModel)) {
                // 存入模块同类缓存列表
                addMouduleMap(baseModel);
                // 存入全局同类缓存列表
                addGlobarList(baseModel);
            }
        } catch (Exception e) {
            throw new OperateException("模型更新缓存失败：" + baseModel.getModelId(), e);
        }
    }
    
    /**
     * 存入全局缓存对象
     * 
     * @param baseModel 模型对象
     * @return 是否新增对象
     * @throws InvocationTargetException 异常
     * @throws IllegalAccessException 异常
     */
    @SuppressWarnings("unchecked")
    private static boolean addGlobarMap(BaseModel baseModel) throws IllegalAccessException, InvocationTargetException {
        boolean bResult = true;
        BaseModel objDescBaseModel = baseModel;
        Map<String, Object> objGlobarMap = (Map<String, Object>) modelCache.get(GLOBAL_CACHE);
        if (objGlobarMap == null) {
            objGlobarMap = new HashMap<String, Object>();
            modelCache.put(GLOBAL_CACHE, objGlobarMap);
        }
        if (objGlobarMap.get(baseModel.getModelId()) != null) {
            bResult = false;
            objDescBaseModel = (BaseModel) objGlobarMap.get(baseModel.getModelId());
            BeanUtils.copyProperties(objDescBaseModel, baseModel);
        }
        
        objGlobarMap.put(baseModel.getModelId(), objDescBaseModel);
        return bResult;
    }
    
    /**
     * 存入模块同类缓存列表
     * 
     * @param baseModel 模型对象
     * @throws OperateException 异常
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    private static void addMouduleMap(BaseModel baseModel) throws OperateException {
        Map<String, Object> objMouduleMap = (Map<String, Object>) modelCache.get(baseModel.getModelPackage());
        if (objMouduleMap == null) {
            objMouduleMap = new HashMap<String, Object>();
            modelCache.put(baseModel.getModelPackage(), objMouduleMap);
        }
        List<?> objMouduleList = (List<?>) objMouduleMap.get(baseModel.getModelType());
        if (objMouduleList == null) {
            objMouduleList = new ArrayList();
            objMouduleMap.put(baseModel.getModelType(), objMouduleList);
        }
        objectOperator.add(baseModel.getModelPackage() + "/" + baseModel.getModelType(), baseModel);
    }
    
    /**
     * 存入全局同类缓存列表
     * 
     * @param baseModel 模型对象
     * @throws OperateException 异常
     */
    @SuppressWarnings({ "rawtypes" })
    private static void addGlobarList(BaseModel baseModel) throws OperateException {
        List<?> lstGlobarList = (List<?>) modelCache.get(baseModel.getModelType());
        if (lstGlobarList == null) {
            lstGlobarList = new ArrayList();
            modelCache.put(baseModel.getModelType(), lstGlobarList);
        }
        objectOperator.add(baseModel.getModelType(), baseModel);
    }
    
    /**
     * 根据文件名获取模型类型
     * 
     * @param file 文件
     * @return 模型类型
     */
    private static String getModelType(File file) {
        String strFileName = file.getName();
        return strFileName.split("\\.")[1];
    }
    
    /**
     * 读取属性
     * 
     * @param file 模型文件
     * @param t 转换的类型
     * @return 查询结果
     */
    public static Object readFile(final File file, Class<?> t) {
        Object objT = null;
        IFileOperator objFileOperator = FileOperatorFactory.getFileOperator(file);
        if (objFileOperator.getTempFile(file).exists()) {
            objT = objFileOperator.readFile(file, t, true);
        } else {
            objT = objFileOperator.readFile(file, t, false);
        }
        return objT;
    }
    
    /**
     * 保存模型
     * 
     * @param vo 模型对象
     * @return 操作结果
     */
    public static boolean save(final Object vo) {
        boolean bResult = true;
        try {
            // 清空忽略字段
            IgnoreMetadata.beans(vo).margin();
            File objFile = getFile(((BaseModel) vo).getModelId());
            TypeConfig objTypeConfig = modelClassConfig.get(((BaseModel) vo).getModelType());
            IFileOperator objFileOperator = FileOperatorFactory.getFileOperator(objTypeConfig.getFileType());
            bResult = objFileOperator.saveFile(vo, objFile, false);
            objFile = getFile(((BaseModel) vo).getModelId());
            fileModifyMap.put(objFile.getPath(), objFile.lastModified());
            updateCache((BaseModel) vo);
        } catch (OperateException e) {
            logger.error("保存模型失败：" + vo, e);
            bResult = false;
        }
        return bResult;
    }
    
    /**
     * 删除模型文件
     * 
     * @param id 模型唯一标识
     * @return 操作结果
     * @throws OperateException 异常
     */
    public static boolean delete(final String id) throws OperateException {
        File objFile = getFile(id);
        String strModelType = getModelType(objFile);
        TypeConfig objTypeConfig = modelClassConfig.get(strModelType);
        Class<?> objModelType = objTypeConfig.getType();
        BaseModel objBaseModel = (BaseModel) readFile(objFile, objModelType);
        objectOperator.delete(GLOBAL_CACHE + "/" + id);
        objectOperator.delete(objBaseModel.getModelPackage() + "/" + objBaseModel.getModelType() + "[modelId='" + id
            + "']");
        objectOperator.delete(objBaseModel.getModelType() + "[modelId='" + id + "']");
        IFileOperator objFileOperator = FileOperatorFactory.getFileOperator(objTypeConfig.getFileType());
        return objFileOperator.deleteFile(objFile);
    }
    
    /**
     * 初始化元数据文件监听器
     */
    public static void initMetaDataFileListener() {
        try {
            String strRootPath = metaDataRootPath;
            int mask = JNotify.FILE_CREATED | JNotify.FILE_MODIFIED;
            boolean watchSubtree = true;
            JNotify.addWatch(strRootPath, mask, watchSubtree, new Listener());
        } catch (Exception e) {
            logger.error("元数据文件监听器启动失败", e);
        }
    }
    
    /**
     * 监控内部类
     */
    static class Listener implements JNotifyListener {
        
        @Override
        public void fileModified(int wd, String rootPath, String name) {
            fileLoad(new File(rootPath + File.separator + name));
        }
        
        @Override
        public void fileCreated(int wd, String rootPath, String name) {
            // windows系统BUG新增的时候也会触发modify事件，故不对新增事件进行监听
            // fileLoad(new File(rootPath + File.separator + name));
        }
        
        @Override
        public void fileDeleted(int arg0, String arg1, String arg2) {
            //
        }
        
        @Override
        public void fileRenamed(int arg0, String arg1, String arg2, String arg3) {
            //
        }
    }
}
