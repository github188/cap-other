/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse;

import java.util.HashMap;
import java.util.Map;

import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTLvl;

/**
 * 列表 上下文
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月23日 lizhiyong
 */
public class ListContext extends ListItemContext {
    
    /** 列表项上下文集 */
    private final Map<Integer, ListItemContext> listItemByLevel;
    
    /** 最大层级 */
    private int levelMax;
    
    /**
     * 构造函数
     */
    public ListContext() {
        super(null, 0, null);
        this.listItemByLevel = new HashMap<Integer, ListItemContext>();
    }
    
    /**
     * 添加列表项
     *
     * @param lvl lvl
     * @return ListItemContext
     */
    public ListItemContext addItem(CTLvl lvl) {
        int level = lvl.getIlvl().intValue();
        ListItemContext parent = getParent(level - 1);
        ListItemContext newItem = parent.createAndAddItem(lvl);
        for (int i = level; i <= levelMax; i++) {
            listItemByLevel.remove(i);
        }
        listItemByLevel.put(level, newItem);
        if (level > levelMax) {
            levelMax = level;
        }
        return newItem;
    }
    
    /**
     * 获得指定层级的上级上下文
     *
     * @param level level
     * @return ListItemContext
     */
    private ListItemContext getParent(int level) {
        if (level < 0) {
            return this;
        }
        ListItemContext parent = null;
        for (int i = level; i >= 0; i--) {
            parent = listItemByLevel.get(level);
            if (parent != null) {
                return parent;
            }
        }
        return this;
    }
    
    @Override
    public boolean isRoot() {
        return true;
    }
}
