/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.dao;

import com.comtop.cap.base.MDBaseDAO;
import com.comtop.cap.doc.content.model.DefaultContentSegDTO;
import com.comtop.cap.doc.content.model.DefaultContentSegVO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * 缺省内容DAO
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-24 李志勇
 */
@PetiteBean
public class DefaultContentSegDAO extends MDBaseDAO<DefaultContentSegVO> {
    
    /**
     * 根据关键字查询内容
     * 
     * @param key 关键字
     * @return DefaultContentSegVO 未找到返回 null
     */
    public DefaultContentSegDTO readByKey(String key) {
        return (DefaultContentSegDTO) selectOne("com.comtop.cap.doc.content.model.readByKey", key);
    }
}
