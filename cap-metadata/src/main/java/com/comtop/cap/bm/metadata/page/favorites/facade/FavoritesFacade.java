/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.favorites.facade;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.base.facade.CapBmBaseFacade;
import com.comtop.cap.bm.metadata.common.model.CuiTreeNodeVO;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.page.favorites.model.FavoritesVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.json.JSONArray;

import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 收藏夹facade类
 *
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2016-5-20 诸焕辉
 */
@DwrProxy
@PetiteBean
public class FavoritesFacade extends CapBmBaseFacade {
    
    /**
     * 加载模型文件
     * 
     * @param modelId 模型Id
     * @return 操作结果
     * @throws OperateException 操作异常
     * @throws ValidateException 校验异常
     */
    @RemoteMethod
    public FavoritesVO loadModel(String modelId) throws OperateException, ValidateException {
        FavoritesVO objFavoritesVO = null;
        if (StringUtils.isNotBlank(modelId)) {
            objFavoritesVO = (FavoritesVO) CacheOperator.readById(modelId);
            if (objFavoritesVO == null) {
                objFavoritesVO = new FavoritesVO();
                objFavoritesVO.setModelId(modelId);
                objFavoritesVO.setModelName(modelId.substring(modelId.lastIndexOf(".") + 1, modelId.length()));
                objFavoritesVO.saveModel();
            }
        }
        return objFavoritesVO;
    }
    
    /**
     * 保存
     *
     * @param model 被保存的对象
     * @return 是否成功
     * @throws ValidateException 异常
     */
    @RemoteMethod
    public boolean saveModel(FavoritesVO model) throws ValidateException {
        return model.saveModel();
    }
    
    
    /**
     * 查询
     * 
     * @param modelId 模型Id
     * @param condition 条件
     * @return 操作结果
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<CuiTreeNodeVO> searchAction(String modelId, String condition) throws OperateException {
        return FavoritesVO.searchAction(modelId, condition);
    }
    
    /**
     * 加载模型文件
     * 
     * @param modelId 模型Id
     * @return 操作结果
     * @throws OperateException xml操作异常
     * @throws ValidateException 校验异常
     */
    @RemoteMethod
    public List<CuiTreeNodeVO> queryFolderNodeByModelId(String modelId) throws OperateException, ValidateException {
        FavoritesVO objFavoritesVO = this.loadModel(modelId);
        List<CuiTreeNodeVO> lstCuiTreeNodeVO = new ArrayList<CuiTreeNodeVO>();
        if (objFavoritesVO != null) {
            String strJson = JSONArray.toJSONString(objFavoritesVO.getDatasource());
            lstCuiTreeNodeVO = JSONArray.parseArray(strJson, CuiTreeNodeVO.class);
            this.removeLeaf(lstCuiTreeNodeVO);
        }
        return lstCuiTreeNodeVO;
    }
    
    /**
     * 新增书签
     * 
     * @param modelId 模型ID
     * @param newCuiTreeNodeVO 子节点
     * @return 页面对象
     * @throws ValidateException 校验失败异常
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean addBookmarks(String modelId, CuiTreeNodeVO newCuiTreeNodeVO) throws ValidateException,
        OperateException {
        boolean bResult = false;
        FavoritesVO objFavoritesVO = this.loadModel(modelId);
        if (objFavoritesVO != null) {
            String strParentId = newCuiTreeNodeVO.getParentId();
            // 查找父节点
            CuiTreeNodeVO objCuiTreeNodeVO = this.queryTreeNodeByParentId(objFavoritesVO.getDatasource(), strParentId);
            if (objCuiTreeNodeVO != null) {
                List<CuiTreeNodeVO> lstCuiTreeNodeVO = objCuiTreeNodeVO.getChildren();
                if (lstCuiTreeNodeVO == null) {
                    lstCuiTreeNodeVO = new ArrayList<CuiTreeNodeVO>();
                    objCuiTreeNodeVO.setChildren(lstCuiTreeNodeVO);
                }
                if (StringUtils.isBlank(newCuiTreeNodeVO.getId())) {
                    newCuiTreeNodeVO.setId(strParentId + "_" + (lstCuiTreeNodeVO.size() + 1));
                }
                lstCuiTreeNodeVO.add(newCuiTreeNodeVO);
            } else {
                newCuiTreeNodeVO.setId("code_" + (objFavoritesVO.getDatasource().size() + 1));
                objFavoritesVO.getDatasource().add(newCuiTreeNodeVO);
            }
            bResult = objFavoritesVO.saveModel();
        }
        return bResult;
    }
    
    /**
     * 查找父节点
     *
     * @param lstCuiTreeNodeVO 树数据源
     * @param parentId 父节点Id
     * @return 树节点对象
     */
    private CuiTreeNodeVO queryTreeNodeByParentId(List<CuiTreeNodeVO> lstCuiTreeNodeVO, String parentId) {
        CuiTreeNodeVO objCuiTreeNodeVO = null;
        if (StringUtils.isNotBlank(parentId) && lstCuiTreeNodeVO != null) {
            for (int i = 0, len = lstCuiTreeNodeVO.size(); i < len; i++) {
                if (parentId.equals(lstCuiTreeNodeVO.get(i).getId())) {
                    objCuiTreeNodeVO = lstCuiTreeNodeVO.get(i);
                    break;
                } else if(lstCuiTreeNodeVO.get(i).getChildren() != null){
                    CuiTreeNodeVO objNodeVO = this.queryTreeNodeByParentId(lstCuiTreeNodeVO.get(i).getChildren(), parentId);
                    objCuiTreeNodeVO  =  objNodeVO != null ? objNodeVO : objCuiTreeNodeVO;
                }
            }
        }
        return objCuiTreeNodeVO;
    }
    
}
