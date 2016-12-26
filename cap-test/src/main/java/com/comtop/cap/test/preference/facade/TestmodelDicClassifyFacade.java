/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.preference.facade;

import java.util.List;

import com.comtop.cap.test.preference.appservice.TestmodelDicClassifyAppService;
import com.comtop.cap.test.preference.model.TestmodelDicClassifyVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.component.app.session.HttpSessionUtil;
import com.comtop.top.component.common.systeminit.UniTimeInfo;

/**
 * 测试建模字典分类管理
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
@PetiteBean
public class TestmodelDicClassifyFacade {
    
    /** Service */
    @PetiteInject
    protected TestmodelDicClassifyAppService testmodelDicClassifyAppService;
    
    /**
     * <pre>
     * 根据字典分类父ID获取字典集合
     * </pre>
     * 
     * @param parentId 字典分类父ID
     * @return 字典分类集合
     */
    public List<TestmodelDicClassifyVO> queryClassifyListByParentId(String parentId) {
        return testmodelDicClassifyAppService.queryClassifyListByParentId(parentId);
    }
    
    /**
     * <pre>
     * 根据字典分类父ID获取字典集合
     * </pre>
     * 
     * @param id 字典分类ID
     * @return 字典分类集合
     */
    public TestmodelDicClassifyVO readClassifyVOById(String id) {
        return testmodelDicClassifyAppService.readClassifyVOById(id);
    }
    
    /**
     * <pre>
     * 更新字典分类
     * </pre>
     * 
     * @param testmodelDicClassifyVO 字典分类对象
     * @return 成功或失败信息
     */
    public boolean updateClassifyVO(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        testmodelDicClassifyVO.setModifierId(HttpSessionUtil.getCurUserId());
        testmodelDicClassifyVO.setUpdateTime(UniTimeInfo.currentTimestamp());
        return testmodelDicClassifyAppService.updateClassifyVO(testmodelDicClassifyVO);
    }
    
    /**
     * <pre>
     * 新增字典分类
     * </pre>
     * 
     * @param testmodelDicClassifyVO 字典分类对象
     * @return 新增后的ID
     */
    public String insertClassifyVO(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        testmodelDicClassifyVO.setCreatorId(HttpSessionUtil.getCurUserId());
        testmodelDicClassifyVO.setCreateTime(UniTimeInfo.currentTimestamp());
        return testmodelDicClassifyAppService.insertClassifyVO(testmodelDicClassifyVO);
    }
    
    /**
     * <pre>
     * 删除字典分类
     * </pre>
     * 
     * @param testmodelDicClassifyVO 字典分类对象
     * @return 成功或失败信息
     */
    public boolean deleteClassifyVOById(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return testmodelDicClassifyAppService.deleteClassifyVOById(testmodelDicClassifyVO);
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
    public List<TestmodelDicClassifyVO> fastQueryClassify(String strKeyword) {
        return testmodelDicClassifyAppService.fastQueryClassify(strKeyword);
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
    public boolean isExitClassifyCode(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return testmodelDicClassifyAppService.isExitClassifyCode(testmodelDicClassifyVO);
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
    public boolean isExitClassifyName(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return testmodelDicClassifyAppService.isExitClassifyName(testmodelDicClassifyVO);
    }
}
