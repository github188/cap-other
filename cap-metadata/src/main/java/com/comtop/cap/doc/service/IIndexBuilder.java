/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.service;

import java.util.Map;

/**
 * 索引构建器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月29日 lizhiyong
 */
public interface IIndexBuilder {
    
    /**
     * 组装对象的索引集
     *
     * @param packageId 包id 即从哪个数据范围内进行组装。一般情况下，可能是一个业务域，或者一个模块。该参数值 一般由用户在页面上选择的业务域或模块节点id值来指定。
     * @return 索引集。key 对象的非id唯一识别码 value id
     */
    Map<String, String> fixIndexMap(String packageId);
    
}
