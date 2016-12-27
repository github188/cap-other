/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.consistency.ConsistencyCheckUtil;
import com.comtop.cap.bm.metadata.base.consistency.IConsistencyCheck;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.model.CuiTreeNodeVO;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.page.PageUtil;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.preferencesconfig.PreferenceConfigQueryUtil;
import com.comtop.cip.json.JSONObject;

/**
 * 元数据基础facade类
 * 
 * @author 郑重
 * @version jdk1.5
 * @version 2015-5-12 郑重
 */
public abstract class CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(CapBmBaseFacade.class);
    
    /**
     * 校验整个对象的一致性
     * 
     * @param data 数据
     * @return 返回校验结果
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public Map<String, Object> checkConsistency(Object data) {
        Map<String, Object> objReult = new HashMap<String, Object>();
        
        Object objChecker = ConsistencyCheckUtil.getBaseModelConsistencyChecker(data);
        if (objChecker == null) {
            return objReult;
        }
        IConsistencyCheck objConsistencyCheck = (IConsistencyCheck) objChecker;
        List<ConsistencyCheckResult> objCheckResult = objConsistencyCheck.checkCurrentDependOn(data);
        // 校验数据依赖的其他数据是否还存在
        if (!objCheckResult.isEmpty()) {
            objReult.put("currentDependOn", objCheckResult);
        }
        // 校验其他数据依赖于当前数据的信息是否还存在
        objCheckResult = objConsistencyCheck.checkBeingDependOnWhenChange(data);
        
        if (!objCheckResult.isEmpty()) {
            objReult.put("dependOnCurrent", objCheckResult);
        }
        if (objReult.isEmpty()) {
            objReult.put("validateResult", true);
        } else {
            objReult.put("validateResult", false);
        }
        return objReult;
    }
    
    /**
     * 通过开关校验元数据一致性
     * 
     * @param data
     *            数据
     * @return 返回校验结果集
     */
    public Map<String, Object> checkConsistencyBySwitch(Object data) {
        Map<String, Object> objReult = new HashMap<String, Object>();
        if (!isCheckConsistency()) {
            objReult.put("validateResult", true);
            return objReult;
        }
        return this.checkConsistency(data);
    }
    
    /**
     * 是否一致性校验
     * 
     * @return 是否一致性校验
     */
    private boolean isCheckConsistency() {
        return PreferenceConfigQueryUtil.isMetadataConsistency();
    }
    
    /**
     * 校验对象指定属性的一致性
     * 
     * @param data 数据
     * @param fieldName 指定属性
     * @param field 属性值
     * @return 返回校验结果
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public Map<String, Object> checkConsistencyByField(String fieldName, Object field, Object data) {
        Map<String, Object> objReult = new HashMap<String, Object>();
        
        Object objChecker = ConsistencyCheckUtil.getBaseModelConsistencyChecker(data);
        if (objChecker == null) {
            return objReult;
        }
        
        IConsistencyCheck objConsistencyCheck = (IConsistencyCheck) objChecker;
        
        List<ConsistencyCheckResult> objCheckResult = objConsistencyCheck.checkFieldDependOn(fieldName, field, data);
        // 校验数据依赖的其他数据是否还存在
        if (!objCheckResult.isEmpty()) {
            objReult.put("currentDependOn", objCheckResult);
        }
        // 校验其他数据依赖于当前数据的信息是否还存在
        objCheckResult = objConsistencyCheck.checkBeingDependOn(fieldName, field, data);
        
        if (!objCheckResult.isEmpty()) {
            objReult.put("dependOnCurrent", objCheckResult);
        }
        if (objReult.isEmpty()) {
            objReult.put("validateResult", true);
        } else {
            objReult.put("validateResult", false);
        }
        return objReult;
    }
    
    /**
     * 校验其他数据依赖于当前数据的信息是否还存在
     * 
     * @param lstPageVOs 数据
     * @return 返回校验结果
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public Map<String, Object> checkConsistency4BeingDependOn(List<PageVO> lstPageVOs) {
        Map<String, Object> objReult = new HashMap<String, Object>();
        
        // 校验其他数据依赖于当前数据的信息是否还存在
        List<ConsistencyCheckResult> results = new ArrayList<ConsistencyCheckResult>();
        for (PageVO page : lstPageVOs) {
            Object objChecker = ConsistencyCheckUtil.getBaseModelConsistencyChecker(page);
            if (objChecker == null) {
                return objReult;
            }
            IConsistencyCheck objConsistencyCheck = (IConsistencyCheck) objChecker;
            List<ConsistencyCheckResult> objCheckResult = objConsistencyCheck.checkBeingDependOn(page);
            if (objCheckResult != null) {
                results.addAll(objCheckResult);
            }
        }
        if (!results.isEmpty()) {
            objReult.put("dependOnCurrent", results);
        }
        if (objReult.isEmpty()) {
            objReult.put("validateResult", true);
        } else {
            objReult.put("validateResult", false);
        }
        return objReult;
    }
    
    /**
     * 通过开关校验页面元数据一致性
     * 
     * @param lstPageVOs
     *            数据
     * @return 返回校验结果
     */
    public Map<String, Object> checkConsistency4BeingDependOnBySwatch(List<PageVO> lstPageVOs) {
        Map<String, Object> objReult = new HashMap<String, Object>();
        if (!isCheckConsistency()) {
            objReult.put("validateResult", true);
            return objReult;
        }
        return checkConsistency4BeingDependOn(lstPageVOs);
    }
    
    /**
     * 更改包路径
     * 
     * @param <T> BaseMetadata
     * @param newFullPath 新包名
     * @param oldFullPath 旧包名
     * @param expression 表达式
     * @param type 元数据VO对象类型
     * @return 更新是否成功
     */
    @SuppressWarnings("unchecked")
    public <T extends BaseModel> Map<String, String[]> updateFullPath(String newFullPath, String oldFullPath,
        String expression, Class<T> type) {
        List<String> lstUpdateSucceedModelIds = new ArrayList<String>();
        List<String> lstUpdateErrorModelIds = new ArrayList<String>();
        try {
            List<T> lstBean = CacheOperator.queryList(expression);
            if (lstBean.size() > 0) {
                boolean bResult = false;
                // 包路径规则
                Map<String, String> objRegAndRep = this.getMetaDataReplacementRule(newFullPath, oldFullPath);
                // 迁移元数据文件，并修改文件相关内容
                for (T objBean : lstBean) {
                    String strJson = JSONObject.toJSONString(objBean);
                    for (Map.Entry<String, String> objEntry : objRegAndRep.entrySet()) {
                        strJson = strJson.replaceAll(objEntry.getKey(), objEntry.getValue());
                    }
                    T objModelVO = JSONObject.parseObject(strJson, type);
                    bResult = objModelVO.saveModel();
                    if (!bResult) {
                        lstUpdateErrorModelIds.add(objModelVO.getModelId());
                    } else {
                        lstUpdateSucceedModelIds.add(objModelVO.getModelId());
                    }
                }
            }
        } catch (SecurityException e) {
            LOG.error(type + "权限异常.", e);
        } catch (IllegalArgumentException e) {
            LOG.error(type + "没有定义的方法异常.", e);
        } catch (OperateException e) {
            LOG.error(type + "元数据操作异常.", e);
        } catch (ValidateException e) {
            LOG.error(type + "校验异常.", e);
        }
        
        Map<String, String[]> objResult = new HashMap<String, String[]>();
        objResult.put("success", lstUpdateSucceedModelIds.toArray(new String[lstUpdateSucceedModelIds.size()]));
        objResult.put("error", lstUpdateErrorModelIds.toArray(new String[lstUpdateErrorModelIds.size()]));
        
        return objResult;
    }
    
    /**
     * 
     * 根据包路径，删除元数据信息
     *
     * @param <T> BaseMetadata
     * @param fullPath 包名
     * @param expression 表达式
     * @param type 元数据VO对象类型
     * @return 删除是否成功
     */
    @SuppressWarnings("unchecked")
    public <T extends BaseModel> Map<String, List<T>> deleteMetadataByPackage(String fullPath, String expression,
        Class<T> type) {
        List<T> lstDeleteSucceedModelVos = new ArrayList<T>();
        List<T> lstDeleteErrorModelVos = new ArrayList<T>();
        try {
            List<T> lstBean = CacheOperator.queryList(expression);
            // 删除元数据
            for (T objBean : lstBean) {
                boolean bResult = objBean.deleteModel();
                if (!bResult) {
                    lstDeleteErrorModelVos.add(objBean);
                } else {
                    lstDeleteSucceedModelVos.add(objBean);
                }
            }
        } catch (OperateException e) {
            LOG.error(type + "元数据操作异常.", e);
        }
        
        Map<String, List<T>> objResult = new HashMap<String, List<T>>();
        objResult.put("success", lstDeleteSucceedModelVos);
        objResult.put("error", lstDeleteErrorModelVos);
        
        return objResult;
    }
    
    /**
     * 获取正则表达替换规则（针对元数据文件）
     *
     * 【需要替换的字符串参考案例如下：
     * "com.comtop.ipb.vendor.bizprocess"
     * 'com.comtop.ipb.vendor.bizprocess'
     * "com.comtop.ipb.vendor.bizprocess/"
     * "com.comtop.ipb.vendor.bizprocess.entity.VendorStorageApply/queryTodoVendorAllVOListPagination"
     * 'com.comtop.ipb.vendor.bizprocess.entity.VendorStorageApply'
     * "com.comtop.ipb.vendor.bizprocess.entity.VendorStorageApply"
     * "com.comtop.ipb.vendor.bizprocess.table.IPB_VENDOR_STORAGE_APPLY"
     * "com.comtop.ipb.vendor.bizprocess.metadataGenerate.vendorStorageApply"
     * "com.comtop.ipb.vendor.bizprocess.exception.CustomException"
     * "com.comtop.ipb.vendor.bizprocess.function.F_GET_LAST_VALUE"
     * "com.comtop.ipb.vendor.bizprocess.package.lc_training"
     * "com.comtop.ipb.vendor.bizprocess.procedure.PRO_BPMS_COUNT_OVER_TASK1"
     * "com.comtop.ipb.vendor.bizprocess.serve.getMetaDataReplacementRule"
     * "com.comtop.ipb.vendor.bizprocess.view.TOP_MODULE"
     * "/ipb/vendor/bizprocess/vendorStorageApplyTodoList.ac"
     * 】
     * 
     * @param newFullPath 新包名
     * @param oldFullPath 旧包名
     *
     * @return 返回替换规则
     */
    private Map<String, String> getMetaDataReplacementRule(String newFullPath, String oldFullPath) {
        Map<String, String> objRegAndRep = new HashMap<String, String>();
        objRegAndRep.put(oldFullPath + ".entity.", newFullPath + ".entity.");
        objRegAndRep.put(oldFullPath + ".table.", newFullPath + ".table.");
        objRegAndRep.put(oldFullPath + ".page.", newFullPath + ".page.");
        objRegAndRep.put(oldFullPath + ".metadataGenerate.", newFullPath + ".metadataGenerate.");
        objRegAndRep.put(oldFullPath + ".exception.", newFullPath + ".exception.");
        objRegAndRep.put(oldFullPath + ".function.", newFullPath + ".function.");
        objRegAndRep.put(oldFullPath + ".package.", newFullPath + ".package.");
        objRegAndRep.put(oldFullPath + ".procedure.", newFullPath + ".procedure.");
        objRegAndRep.put(oldFullPath + ".serve.", newFullPath + ".serve.");
        objRegAndRep.put(oldFullPath + ".view.", newFullPath + ".view.");
        objRegAndRep.put("\"" + oldFullPath + "\"", "\"" + newFullPath + "\"");
        objRegAndRep.put("'" + oldFullPath + "'", "'" + newFullPath + "'");
        objRegAndRep.put(oldFullPath + "/", "" + newFullPath + "/");
        objRegAndRep.put(PageUtil.getPageFilePath(oldFullPath) + "([\\w]*.)([\\w]*)",
            PageUtil.getPageFilePath(newFullPath) + "$1" + "$2");
        return objRegAndRep;
    }
    
    /**
     * 去除叶子
     *
     * @param lstCuiTreeNodeVO 树集合
     */
    public void removeLeaf(List<CuiTreeNodeVO> lstCuiTreeNodeVO) {
        for (int i = 0, len = lstCuiTreeNodeVO.size(); i < len; i++) {
            CuiTreeNodeVO objCuiTreeNodeVO = lstCuiTreeNodeVO.get(i);
            if (objCuiTreeNodeVO.getIsFolder() == true) {
                List<CuiTreeNodeVO> lstSubCuiTreeNodeVO = objCuiTreeNodeVO.getChildren();
                if (lstSubCuiTreeNodeVO != null && lstSubCuiTreeNodeVO.size() > 0) {
                    this.removeLeaf(lstSubCuiTreeNodeVO);
                }
            } else {
                lstCuiTreeNodeVO.remove(i);
                i--;
                len--;
            }
        }
    }
    
    /**
     * 根据树节点的显示名称，过滤树节点
     *
     * @param lstCuiTreeNodeVO 树集合
     * @param condition 条件
     */
    public void filterCuiTreeNodeByTitle(List<CuiTreeNodeVO> lstCuiTreeNodeVO, String condition) {
        for (int i = 0, len = lstCuiTreeNodeVO.size(); i < len; i++) {
            CuiTreeNodeVO objCuiTreeNodeVO = lstCuiTreeNodeVO.get(i);
            String strTitle = objCuiTreeNodeVO.getTitle();
            strTitle = strTitle != null ? strTitle : "";
            if (strTitle.indexOf(condition) < 0) {
                List<CuiTreeNodeVO> lstNextSubCuiTreeNodeVO = objCuiTreeNodeVO.getChildren();
                if (lstNextSubCuiTreeNodeVO != null) {
                    this.filterCuiTreeNodeByTitle(lstNextSubCuiTreeNodeVO, condition);
                    if (lstNextSubCuiTreeNodeVO.size() == 0) {
                        lstCuiTreeNodeVO.remove(i);
                        i--;
                        len--;
                    }
                } else {
                    lstCuiTreeNodeVO.remove(i);
                    i--;
                    len--;
                }
            }
        }
    }
}
