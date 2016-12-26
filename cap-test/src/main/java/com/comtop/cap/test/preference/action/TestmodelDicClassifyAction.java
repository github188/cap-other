/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.preference.action;

import java.util.List;

import com.comtop.cap.test.preference.facade.TestmodelDicClassifyFacade;
import com.comtop.cap.test.preference.model.TestmodelDicClassifyTree;
import com.comtop.cap.test.preference.model.TestmodelDicClassifyVO;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.core.util.tree.TreeTransformUtils;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 字典分类管理
 *
 * <pre>
 * [调用关系:
 * 实现接口及父类:
 * 子类:
 * 内部类列表:
 * ]
 * </pre>
 *
 * @author 章尊志
 * @since jdk1.6
 * @version 2016年6月24日 章尊志
 */
@DwrProxy
public class TestmodelDicClassifyAction {
    
    /**
     * facade层 面向接口开发
     * 注入ModuleFacade
     */
    @PetiteInject
    protected TestmodelDicClassifyFacade testmodelDicClassifyFacade;
    
    /**
     * <pre>
     * 根据字典分类父ID获取字典集合
     * </pre>
     * 
     * @param classifyVO 字典分类父ID
     * @return 字典分类集合
     */
    @RemoteMethod
    public String queryClassifyTreeNode(TestmodelDicClassifyVO classifyVO) {
        TestmodelDicClassifyVO objTestmodelDicClassifyVO = null;
        if (("-1").equals(classifyVO.getParentId())) {
            List<TestmodelDicClassifyVO> lstRootClassifyVO = testmodelDicClassifyFacade
                .queryClassifyListByParentId(classifyVO.getParentId());
            if (lstRootClassifyVO == null || lstRootClassifyVO.size() == 0) {
                return "";
            }
            objTestmodelDicClassifyVO = lstRootClassifyVO.get(0);
            classifyVO.setId(objTestmodelDicClassifyVO.getId());
        } else {
            objTestmodelDicClassifyVO = testmodelDicClassifyFacade.readClassifyVOById(classifyVO.getId());
        }
        String strJson = "";
        if (objTestmodelDicClassifyVO != null) {
            List<TestmodelDicClassifyVO> lstTestmodelDicClassifyVO = testmodelDicClassifyFacade
                .queryClassifyListByParentId(classifyVO.getId());
            lstTestmodelDicClassifyVO.add(0, objTestmodelDicClassifyVO);
            strJson = TreeTransformUtils.listToTree(lstTestmodelDicClassifyVO, new TestmodelDicClassifyTree());
        }
        return strJson;
    }
    
    /**
     * <pre>
     * 根据字典分类父ID获取字典集合
     * </pre>
     * 
     * @param id 字典分类ID
     * @return 字典分类集合
     */
    @RemoteMethod
    public TestmodelDicClassifyVO readClassifyVOById(String id) {
        return testmodelDicClassifyFacade.readClassifyVOById(id);
    }
    
    /**
     * <pre>
     * 更新字典分类
     * </pre>
     * 
     * @param testmodelDicClassifyVO 字典分类对象
     * @return 成功或失败信息
     */
    @RemoteMethod
    public boolean updateClassifyVO(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return testmodelDicClassifyFacade.updateClassifyVO(testmodelDicClassifyVO);
    }
    
    /**
     * <pre>
     * 新增字典分类
     * </pre>
     * 
     * @param testmodelDicClassifyVO 字典分类对象
     * @return 新增后的ID
     */
    @RemoteMethod
    public String insertClassifyVO(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return testmodelDicClassifyFacade.insertClassifyVO(testmodelDicClassifyVO);
    }
    
    /**
     * <pre>
     * 删除字典分类
     * </pre>
     * 
     * @param testmodelDicClassifyVO 字典分类对象
     * @return 成功或失败信息
     */
    @RemoteMethod
    public boolean deleteClassifyVOById(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return testmodelDicClassifyFacade.deleteClassifyVOById(testmodelDicClassifyVO);
    }
    
    /**
     * 根据关键字快速搜索分类
     *
     * <pre>
     * 
     * </pre>
     * 
     * @param strKeyword 分类名称关键字
     * @return 分类集合
     */
    @RemoteMethod
    public List<TestmodelDicClassifyVO> fastQueryClassify(String strKeyword) {
        return testmodelDicClassifyFacade.fastQueryClassify(strKeyword);
    }
    
    /**
     * 根据ID和分类名称判断是否存在相同的编码
     *
     * <pre>
     * 
     * </pre>
     * 
     * @param testmodelDicClassifyVO 分类
     * @return 分类集合
     */
    @RemoteMethod
    public boolean isExitClassifyCode(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return testmodelDicClassifyFacade.isExitClassifyCode(testmodelDicClassifyVO);
    }
    
    /**
     * 根据ID和分类名称判断是否存在相同的名称
     *
     * <pre>
     * 
     * </pre>
     * 
     * @param testmodelDicClassifyVO 分类
     * @return 分类集合
     */
    @RemoteMethod
    public boolean isExitClassifyName(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return testmodelDicClassifyFacade.isExitClassifyName(testmodelDicClassifyVO);
    }
}
