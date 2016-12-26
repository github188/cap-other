/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import java.util.List;

import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.word.docmodel.data.ContentSeg;

/**
 * FIXME 类注释信息
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月8日 lizhongwen
 */
@DocumentService(name = "ContentSeg", dataType = ContentSeg.class)
public class ContentSegService {
    
    /**
     * 保存
     *
     * @param datas 数据
     */
    public void saveContentSegList(List<ContentSeg> datas) {
        System.out.println("saveContentSegList~~~~~~~~~~~~~~~~~~~~~~~~~");
    }
    
    /**
     * 查询数据
     *
     * @param condition 查询条件
     * @return 查询结果
     */
    public List<ContentSeg> loadContentSegList(final ContentSeg condition) {
        System.out.println("loadContentSegList~~~~~~~~~~~~~~~~~~~~~~~~~");
        return null;
    }
}
