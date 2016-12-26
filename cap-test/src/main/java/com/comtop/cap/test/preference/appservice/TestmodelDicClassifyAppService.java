/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.preference.appservice;

import java.util.List;

import com.comtop.cap.test.preference.model.TestmodelDicClassifyVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.core.base.dao.CoreDAO;
import com.comtop.top.core.util.StringEscapeUtil;

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
public class TestmodelDicClassifyAppService {
    
    /**
     * 注入 commonDAO
     */
    @SuppressWarnings("rawtypes")
    @PetiteInject
    protected CoreDAO coreDAO;
    
    /**
     * 
     * 根据字典分类父ID获取字典集合
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @param parentId 字典分类父ID
     * @return 字典分类集合
     */
    public List<TestmodelDicClassifyVO> queryClassifyListByParentId(String parentId) {
        List<TestmodelDicClassifyVO> lstTestmodelDicClassifyVO = coreDAO.queryList(
            "com.comtop.cap.test.preference.model.queryClassifyListByParentId", parentId);
        return lstTestmodelDicClassifyVO;
    }
    
    /**
     * 
     * 根据字典分类父ID获取字典集合
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @param id 字典分类ID
     * @return 字典分类集合
     */
    public TestmodelDicClassifyVO readClassifyVOById(String id) {
        TestmodelDicClassifyVO objTestmodelDicClassifyVO = new TestmodelDicClassifyVO();
        objTestmodelDicClassifyVO.setId(id);
        return (TestmodelDicClassifyVO) coreDAO.load(objTestmodelDicClassifyVO);
    }
    
    /**
     * 
     * 更新字典分类
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @param testmodelDicClassifyVO 字典分类对象
     * @return 成功或失败信息
     */
    public boolean updateClassifyVO(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return coreDAO.update(testmodelDicClassifyVO);
    }
    
    /**
     * 
     * 新增字典分类
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @param testmodelDicClassifyVO 字典分类对象
     * @return 新增后的ID
     */
    public String insertClassifyVO(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return (String) coreDAO.insert(testmodelDicClassifyVO);
    }
    
    /**
     * 
     * 删除字典分类
     * 
     * <pre>
     * 
     * </pre>
     * 
     * @param testmodelDicClassifyVO 字典分类对象
     * @return 成功或失败信息
     */
    public boolean deleteClassifyVOById(TestmodelDicClassifyVO testmodelDicClassifyVO) {
        return coreDAO.delete(testmodelDicClassifyVO);
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
        TestmodelDicClassifyVO objTestmodelDicClassifyVO = new TestmodelDicClassifyVO();
        objTestmodelDicClassifyVO.setDictionaryName(StringEscapeUtil.escapeSql(strKeyword));
        return coreDAO.queryList("com.comtop.cap.test.preference.model.fastQueryClassify", objTestmodelDicClassifyVO);
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
        int iCount = (Integer) coreDAO.selectOne("com.comtop.cap.test.preference.model.isExitClassifyCode",
            testmodelDicClassifyVO);
        return iCount > 0 ? true : false;
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
        int iCount = (Integer) coreDAO.selectOne("com.comtop.cap.test.preference.model.isExitClassifyName",
            testmodelDicClassifyVO);
        return iCount > 0 ? true : false;
    }
    
}
