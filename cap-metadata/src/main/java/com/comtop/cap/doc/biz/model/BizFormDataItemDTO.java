/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.model;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务表单数据项DTO，目前暂无自己的属性。
 * 此种方式是为了便于在配置模板时方便，通过类名和服务名和唯一性建立和服务一对一的关系。此外，还有业务对象数据项等也是类似的方式。
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月7日 lizhiyong
 */
@DataTransferObject
public class BizFormDataItemDTO extends DataItemDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
}
