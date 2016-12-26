/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.support;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Collection;

/**
 * 可迭代的类型数据
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月17日 lizhongwen
 * @param <E> 参数类型
 */
public class IterableTypedValue<E> extends TypedValue {
    
    /** 集合 */
    private ArrayList<E> coll;
    
    /** 索引 */
    private int indexer = 0;
    
    /**
     * 构造函数
     * 
     */
    public IterableTypedValue() {
        this.coll = new ArrayList<E>();
        this.value = this.coll;
        this.descriptor = new TypeDescriptor(this.coll);
    }
    
    /**
     * 构造函数
     * 
     * @param element 元素
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    public IterableTypedValue(E element) {
        if (element instanceof ArrayList) {
            this.coll = (ArrayList) element;
        } else if (element instanceof Collection) {
            this.coll = new ArrayList((Collection) element);
        } else if (element.getClass().isArray()) {// 数组
            this.coll = new ArrayList<E>();
            int len = Array.getLength(element);
            for (int index = 0; index < len; index++) {
                this.addElement((E) Array.get(element, index));
            }
        } else {
            this.coll = new ArrayList<E>();
            this.addElement(element);
        }
        this.value = this.coll;
        this.descriptor = new TypeDescriptor(this.coll);
    }
    
    /**
     * @param element 添加一个元素
     */
    public void addElement(E element) {
        if (this.coll == null) {
            this.coll = new ArrayList<E>();
        }
        if (element == null) {
            return;
        }
        this.coll.add(element);
    }
    
    /**
     * @return 弹出一个元素
     */
    public E popElement() {
        if (this.coll == null || this.coll.isEmpty() || indexer >= this.coll.size()) {
            return null;
        }
        E element = this.coll.get(indexer);
        indexer++;
        return element;
    }
    
    /**
     * @return 取出一个元素
     */
    public E peekElement() {
        if (this.coll == null || this.coll.isEmpty()) {
            return null;
        }
        return coll.get(0);
    }
}
