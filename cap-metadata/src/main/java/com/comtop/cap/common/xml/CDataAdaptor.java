/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.common.xml;

import javax.xml.bind.annotation.adapters.XmlAdapter;

/**
 * CDATA
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月22日 lizhongwen
 */
public class CDataAdaptor extends XmlAdapter<String, String> {
    
    /** CDATA结束标志 */
    private static final String CDATA_END = "]]>";
    
    /** CDATA开始标志 */
    private static final String CDATA_BEGIN = "<![CDATA[";
    
    /**
     * @see javax.xml.bind.annotation.adapters.XmlAdapter#unmarshal(java.lang.Object)
     */
    @Override
    public String unmarshal(String str) throws Exception {
        String result = str;
        if (str.startsWith(CDATA_BEGIN) && str.endsWith(CDATA_END)) {
            result = str.substring(CDATA_BEGIN.length(), str.length() - CDATA_END.length());
        }
        return result;
    }
    
    /**
     * @see javax.xml.bind.annotation.adapters.XmlAdapter#marshal(java.lang.Object)
     */
    @Override
    public String marshal(String str) throws Exception {
        return CDATA_BEGIN + str + CDATA_END;
    }
    
}
