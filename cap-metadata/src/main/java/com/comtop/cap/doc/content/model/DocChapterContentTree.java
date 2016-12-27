/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.model;

import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.top.core.util.tree.AbstractTree;

/**
 * 章节内容结构树
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-16 李小芬
 */
public class DocChapterContentTree extends AbstractTree<DocChapterContentStructVO> {
    
    @Override
    public String getKey(DocChapterContentStructVO docChapterContentStructVO) {
        return docChapterContentStructVO.getTreeId();
    }
    
    @Override
    public String getParentKey(DocChapterContentStructVO docChapterContentStructVO) {
        return docChapterContentStructVO.getParentTreeId();
    }
    
    @Override
    public String getTitle(DocChapterContentStructVO docChapterContentStructVO) {
        if (StringUtil.isNotBlank(docChapterContentStructVO.getChapterWordNumber())) {
            return "<B>" + docChapterContentStructVO.getChapterWordNumber() + "</B> "
                + docChapterContentStructVO.getChapterName();
        }
        return docChapterContentStructVO.getChapterName();
    }
    
    @Override
    public String getIcon(DocChapterContentStructVO docChapterContentStructVO) {
        return "";
    }
    
    @Override
    public Boolean isLazy(DocChapterContentStructVO docChapterContentStructVO) {
        return docChapterContentStructVO.isHasChild();
    }
    
    @Override
    public Boolean isFolder(DocChapterContentStructVO docChapterContentStructVO) {
        return docChapterContentStructVO.isHasChild();
    }
    
}
