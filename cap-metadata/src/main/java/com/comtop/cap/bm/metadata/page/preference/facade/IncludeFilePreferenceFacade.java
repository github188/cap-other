/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.preference.facade;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.page.desinger.facade.PageFacade;
import com.comtop.cap.bm.metadata.page.preference.model.IncludeFilePreferenceVO;
import com.comtop.cap.bm.metadata.page.preference.model.IncludeFileVO;
import com.comtop.cip.common.validator.ValidateResult;
import com.comtop.cip.common.validator.ValidatorUtil;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.util.StringUtil;
import com.comtop.top.core.util.constant.NumberConstant;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 环境变量首选项facade类
 *
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-5-28 诸焕辉
 */
@DwrProxy
@PetiteBean
public class IncludeFilePreferenceFacade extends CapBmBaseFacade {
    
    /** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(PageFacade.class);
    
    /**
     * 获取引用文件首选项
     *
     * @return 操作结果
     */
    @RemoteMethod
    public IncludeFilePreferenceVO queryList() {
        String strCustomModelId = IncludeFilePreferenceVO.getCustomModelId();
        IncludeFilePreferenceVO objIncludeFilePreferenceVO = null;
        objIncludeFilePreferenceVO = (IncludeFilePreferenceVO) CacheOperator.readById(strCustomModelId);
        if (objIncludeFilePreferenceVO == null) {
            objIncludeFilePreferenceVO = IncludeFilePreferenceVO.createCustomIncludeFilePreference();
            try {
                if (saveModel(objIncludeFilePreferenceVO)) {
                    objIncludeFilePreferenceVO = (IncludeFilePreferenceVO) CacheOperator.readById(strCustomModelId);
                }
            } catch (ValidateException e) {
                LOG.error("创建引入文件首选项配置出错", e);
            }
        }
        return objIncludeFilePreferenceVO;
    }
    
    /**
     * 获取引用文件首选项
     * @param modelIds 文件Id集合
     * @return 操作结果
     */
    @RemoteMethod
    public List<IncludeFilePreferenceVO> queryList(String[] modelIds) {
        List<IncludeFilePreferenceVO> lstIncludeFilePreferenceVO = new ArrayList<IncludeFilePreferenceVO>();
        for (int i = 0, len = modelIds.length; i < len; i++) {
            IncludeFilePreferenceVO objIncludeFilePreferenceVO = (IncludeFilePreferenceVO) CacheOperator.readById(modelIds[i]);
            if (objIncludeFilePreferenceVO != null) {
                lstIncludeFilePreferenceVO.add(objIncludeFilePreferenceVO);
            }
        }
        return lstIncludeFilePreferenceVO;
    }
    
    /**
     * 根据文件类型获取引用文件
     *
     * @param fileType 文件类型
     * @return 操作结果
     */
    @RemoteMethod
    public List<IncludeFileVO> queryListByFileType(String fileType) {
        List<IncludeFileVO> lstIncludeFileVO = null;
        if (StringUtils.isNotBlank(fileType)) {
            IncludeFilePreferenceVO objIncludeFilePreferenceVO = this.queryList();
            if ("jsp".equals(fileType)) {
                lstIncludeFileVO = objIncludeFilePreferenceVO.getJspList();
            } else if ("js".equals(fileType)) {
                lstIncludeFileVO = objIncludeFilePreferenceVO.getJsList();
            } else if ("css".equals(fileType)) {
                lstIncludeFileVO = objIncludeFilePreferenceVO.getCssList();
            }
        }
        return lstIncludeFileVO;
    }
    
    /**
     * 根据文件类型获取引用文件
     *
     * @param model 查询条件
     * @return 操作结果
     * @throws OperateException 异常
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public List<IncludeFileVO> queryListByCondition(IncludeFileVO model) throws OperateException {
        List<IncludeFileVO> lstIncludeFileVO = null;
        if (model != null) {
            String strFileType = model.getFileType();
            IncludeFilePreferenceVO obj = queryList();
            if (StringUtils.isNotBlank(strFileType)) {
                StringBuffer sbExpression = new StringBuffer();
                sbExpression.append("");
                if ("jsp".equals(strFileType)) {
                    sbExpression.append("jspList");
                } else if ("js".equals(strFileType)) {
                    sbExpression.append("jsList");
                } else if ("css".equals(strFileType)) {
                    sbExpression.append("cssList");
                }
                sbExpression.append("[contains(fileName, '" + model.getFileName() + "') or contains(filePath, '"
                    + model.getFilePath() + "') and defaultReference=0]");
                lstIncludeFileVO = obj.queryList(sbExpression.toString());
            }
        }
        return lstIncludeFileVO;
    }
    
    /**
     * 加载模型文件
     *
     * @param id 控件模型ID
     * @return 操作结果
     */
    @RemoteMethod
    public IncludeFilePreferenceVO loadModel(String id) {
        return (IncludeFilePreferenceVO) CacheOperator.readById(IncludeFilePreferenceVO.getCustomModelId());
    }
    
    /**
     * 验证VO对象
     *
     * @param model 被校验对象
     * @return 结果集
     */
    @SuppressWarnings("rawtypes")
    @RemoteMethod
    public ValidateResult validate(IncludeFilePreferenceVO model) {
        return ValidatorUtil.validate(model);
    }
    
    /**
     * 保存
     *
     * @param model 被保存的对象
     * @return 是否成功
     * @throws ValidateException 异常
     */
    @RemoteMethod
    public boolean saveModel(IncludeFilePreferenceVO model) throws ValidateException {
        return model.saveModel();
    }
    
    /**
     * 删除模型
     *
     * @param model 被删除的对象
     * @return 是否成功
     * @throws OperateException 异常
     */
    @RemoteMethod
    public boolean deleteModel(IncludeFilePreferenceVO model) throws OperateException {
        return model.deleteModel();
    }
    
    /**
     * 获取默认引用文件首选项
     *
     * @return 操作结果
     * @throws OperateException json操作异常
     */
    @RemoteMethod
    public List<IncludeFileVO> queryDefaultReferenceFiles() throws OperateException {
        return queryByDefaultReference(true);
    }
    
    /**
     * 获取可选引用文件首选项
     *
     * @return 操作结果
     * @throws OperateException json操作异常
     */
    @RemoteMethod
    public List<IncludeFileVO> queryOptionalFiles() throws OperateException {
        return queryByDefaultReference(false);
    }
    
    /**
     * 根据是否默认引用文件，获取引用文件首选项
     * 
     * @param defaultReference 是否是默认引用文件
     * 
     * @return 操作结果
     * @throws OperateException json操作异常
     */
    @SuppressWarnings("unchecked")
    private List<IncludeFileVO> queryByDefaultReference(boolean defaultReference) throws OperateException {
        IncludeFilePreferenceVO objIncludeFilePreferenceVO = this.queryList();
        StringBuffer sbExpression = new StringBuffer();
        int iBool = defaultReference == true ? NumberConstant.ONE : NumberConstant.ZERO;
        sbExpression.append("cssList[defaultReference=").append(iBool).append("] | ");
        sbExpression.append("jsList[defaultReference=").append(iBool).append("] | ");
        sbExpression.append("jspList[defaultReference=").append(iBool).append("]");
        List<IncludeFileVO> lstIncludeFileVO = objIncludeFilePreferenceVO.queryList(sbExpression.toString());
        return lstIncludeFileVO;
    }
    
    /**
     * 获取当前系统配置的默认引入文件；包括必须和可选的引入文件
     *
     * @return List<IncludeFileVO> List集合对象，集合中存放IncludeFileVO
     */
    @RemoteMethod
    public List<IncludeFileVO> queryIncludeFileList() {
        List<IncludeFileVO> lstIncludeFileVO = new ArrayList<IncludeFileVO>();
        IncludeFilePreferenceVO objFilePreference = this.queryList();
        lstIncludeFileVO.addAll(objFilePreference.getJsList());
        lstIncludeFileVO.addAll(objFilePreference.getJspList());
        lstIncludeFileVO.addAll(objFilePreference.getCssList());
        return lstIncludeFileVO;
    }
    
  
    
    /**
     * 根据参数名称获取引入文件对象
     *
     * @param strFilePath 文件路径
     * @return 引入文件对象 IncludeFileVO
     */
    @RemoteMethod
    public IncludeFileVO loadByFilePath(String strFilePath) {
        List<IncludeFileVO> lstIncludeFiles = this.queryIncludeFileList();
        for (Iterator<IncludeFileVO> iterator = lstIncludeFiles.iterator(); iterator.hasNext();) {
            IncludeFileVO objIncludeFileVO = iterator.next();
            if (StringUtil.equals(strFilePath, objIncludeFileVO.getFilePath())) {
                return objIncludeFileVO;
            }
        }
        return null;
    }
    
    /**
     * 获取所有引用文件
     *
     * @return 操作结果
     * @throws OperateException json操作异常
     */
    @SuppressWarnings("unchecked")
    @RemoteMethod
    public List<IncludeFileVO> queryAllIncludeFile() throws OperateException {
        IncludeFilePreferenceVO objIncludeFilePreferenceVO = this.queryList();
        return objIncludeFilePreferenceVO.queryList("cssList | jsList | jspList");
    }
    
    /**
     * 根据文件对象向集合中新增引入文件对象
     *
     * @param objIncludeFileVO 待新增引入文件对象
     * @param oldIncludeFileVO 旧文件对象
     * @return 操作结果
     * @throws ValidateException 对象验证异常
     */
    @RemoteMethod
    public boolean addIncludeFile(IncludeFileVO objIncludeFileVO, IncludeFileVO oldIncludeFileVO) throws ValidateException {
        IncludeFilePreferenceVO objFilePreference = this.queryList();
//        String strFileType = objIncludeFileVO.getFileType();
//        if (StringUtil.equals(strFileType, "js")) {
            List<IncludeFileVO> lstJs = updateIncludeFileList(objFilePreference.getJsList(), objIncludeFileVO,
                oldIncludeFileVO);
            objFilePreference.setJsList(lstJs);
//        }
//        if (StringUtil.equals(strFileType, "css")) {
            List<IncludeFileVO> lstCss = updateIncludeFileList(objFilePreference.getCssList(), objIncludeFileVO,
                oldIncludeFileVO);
            objFilePreference.setCssList(lstCss);
//        }
//        if (StringUtil.equals(strFileType, "jsp")) {
            List<IncludeFileVO> lstJsp = updateIncludeFileList(objFilePreference.getJspList(), objIncludeFileVO,
                oldIncludeFileVO);
            objFilePreference.setJspList(lstJsp);
//        }
        boolean rs = false;
        if (validate(objFilePreference).isOK()) {
            rs = objFilePreference.saveModel();
        }
        return rs;
    }
    
    
    /**
     * 根据IncludeFileVO来更新集合中IncludeFileVO对象信息
     *
     * @param lstIncludeFile 待更新的集合
     * @param objIncludeFile 需要更新的IncludeFileVO对象
     * @param oldIncludeFileVO 旧文件对象
     * @return 更新后的集合
     */
    private List<IncludeFileVO> updateIncludeFileList(List<IncludeFileVO> lstIncludeFile, IncludeFileVO objIncludeFile,
        IncludeFileVO oldIncludeFileVO) {
        List<IncludeFileVO> lstUpdatedFiles = new ArrayList<IncludeFileVO>();
        lstUpdatedFiles.addAll(lstIncludeFile);
        String strListType = "";
        for (Iterator<IncludeFileVO> iterator = lstIncludeFile.iterator(); iterator.hasNext();) {
            IncludeFileVO includeFileVO = iterator.next();
            if(!iterator.hasNext()){
                strListType = includeFileVO.getFileType();
            }
            if (StringUtil.equals(oldIncludeFileVO.getFilePath(), includeFileVO.getFilePath()) &&
                StringUtil.equals(oldIncludeFileVO.getFileType(), includeFileVO.getFileType())) {
                lstUpdatedFiles.remove(includeFileVO);
            }
        }
        if(StringUtil.equals(strListType, objIncludeFile.getFileType())){
            lstUpdatedFiles.add(objIncludeFile);
        }
        return lstUpdatedFiles;
    }
    
    /**
     * 默认引入文件删除方法
     *
     * @param lstIncludeFileVO 待删除引入文件集合，集合中存放IncludeFileVO对象
     * @return 操作结果
     * @throws ValidateException 对象验证异常
     */
    @RemoteMethod
    public boolean deleteIncludeFiles(List<IncludeFileVO> lstIncludeFileVO) throws ValidateException {
        IncludeFilePreferenceVO objFilePreference = this.queryList();
        for (Iterator<IncludeFileVO> iterator = lstIncludeFileVO.iterator(); iterator.hasNext();) {
            IncludeFileVO objIncludeFileVO = iterator.next();
            List<IncludeFileVO> lstJspFile = removeIncludeFile(objFilePreference.getJspList(), objIncludeFileVO);
            objFilePreference.setJspList(lstJspFile);
            List<IncludeFileVO> lstJsFile = removeIncludeFile(objFilePreference.getJsList(), objIncludeFileVO);
            objFilePreference.setJsList(lstJsFile);
            List<IncludeFileVO> lstCssFile = removeIncludeFile(objFilePreference.getCssList(), objIncludeFileVO);
            objFilePreference.setCssList(lstCssFile);
        }
        boolean rs = false;
        if (validate(objFilePreference).isOK()) {
            rs = objFilePreference.saveModel();
        }
        return rs;
    }
    
    /**
     * 根据文件路径删除集合中对应的引入文件对象
     *
     * @param objListFile 引入文件集合
     * @param removeIncludeFileVO 待删除引入文件对象
     * @return List<IncludeFileVO> 删除引入文件后的集合对象
     */
    private List<IncludeFileVO> removeIncludeFile(List<IncludeFileVO> objListFile, IncludeFileVO removeIncludeFileVO) {
        List<IncludeFileVO> lstIncludeFile = new ArrayList<IncludeFileVO>();
        lstIncludeFile.addAll(objListFile);
        for (Iterator<IncludeFileVO> iterator = objListFile.iterator(); iterator.hasNext();) {
            IncludeFileVO includeFileVO = iterator.next();
            if (StringUtil.equals(removeIncludeFileVO.getFilePath(), includeFileVO.getFilePath()) &&
                StringUtil.equals(removeIncludeFileVO.getFileType(), includeFileVO.getFileType()) ) {
                lstIncludeFile.remove(includeFileVO);
            }
        }
        return lstIncludeFile;
    }
}
