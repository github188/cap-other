/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.datatype;

import javax.xml.bind.annotation.XmlEnum;

/**
 * ChapterType 章节类型。
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月21日 lizhiyong
 */
@XmlEnum
public enum ChapterType {
    
    /**
     * 固定章节 代表名称固定的章节，比如编制目的、综述等
     * 
     * <pre>
     *  &lt;WtChapter type="FIXED" title="综述"&gt;
     *      &lt;WtChapter type="FIXED" title="编制目的" /&gt;
     *      &lt;WtChapter type="FIXED" title="规范性引用资料" optional="true" /&gt;
     *      &lt;WtChapter type="FIXED" title="术语" optional="true" /&gt;
     *  &lt;/WtChapter&gt;
     * </pre>
     */
    FIXED,
    
    /**
     * 动态章节 ，指根据业务数据形成的章节，比如业务事项、业务流程、流程节点。举例：
     *
     * <pre>
     *  &lt;WtChapter type="FIXED" title="业务事项设计"&gt;
     *      &lt;WtChapter type="DYNAMIC" mappingTo="bizItem[]=#BizItem(domainId=$domainId)" title="bizItem.name"&gt;
     *          &lt;WtChapter type="FIXED" title="业务说明"&gt;
     *               &lt;span mappingTo="bizItem.bizDesc" /&gt;
     *          &lt;/WtChapter&gt;
     *      &lt;/WtChapter&gt;
     * &lt;/WtChapter&gt;
     * </pre>
     */
    DYNAMIC,
    
    /** 用户手动添加的章节 ，指用户通过系统添加的章节。暂未启用 */
    MANUAL,
    
    /** 未定义的章节 */
    UNDEFINED;
    
    @Override
    public String toString() {
        return this.name();
    }
}
