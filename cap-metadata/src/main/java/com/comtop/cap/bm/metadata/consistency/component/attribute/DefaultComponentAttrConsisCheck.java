/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.consistency.component.attribute;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comtop.cap.bm.metadata.base.consistency.ConsistencyCheckUtil;
import com.comtop.cap.bm.metadata.base.consistency.model.ConsistencyCheckResult;
import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyConfigVO;
import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.consistency.ConsistencyResultAttrName;
import com.comtop.cap.bm.metadata.consistency.component.IComponentAttrConsisCheck;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.ComponentVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.EventVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.PropertyVO;

/**
 * 控件属性一致性校验
 *
 * @author 诸焕辉
 * @since jdk1.6
 * @version 2016年6月28日 诸焕辉
 */
public class DefaultComponentAttrConsisCheck implements IComponentAttrConsisCheck {
    
    @Override
    public ConsistencyCheckResult checkAttrValueConsis(ComponentVO com, BaseMetadata baseMetadataVO, LayoutVO data,
        PageVO root) {
        FieldConsistencyConfigVO objConsistencyConfig = null;
        String strEname = null;
        if (baseMetadataVO instanceof PropertyVO) {
            objConsistencyConfig = ((PropertyVO) baseMetadataVO).getConsistencyConfig();
            strEname = ((PropertyVO) baseMetadataVO).getEname();
        } else if (baseMetadataVO instanceof EventVO) {
            objConsistencyConfig = ((EventVO) baseMetadataVO).getConsistencyConfig();
            strEname = ((EventVO) baseMetadataVO).getEname();
        }
        return this.checkConsistencyWithExpr(com, strEname, objConsistencyConfig, data, root);
    }
    
    /**
     * 根据xpath表达式校验控件属性
     * 
     * @param com 控件定义对象
     * @param ename 控件属性名称
     * @param data 布局对象
     * @param consistencyConfig 控件属性校验配置信息
     * @param root 页面对象
     * @return 校验结果
     */
    protected ConsistencyCheckResult checkConsistencyWithExpr(ComponentVO com, String ename,
        FieldConsistencyConfigVO consistencyConfig, LayoutVO data, PageVO root) {
        Object objProValue = data.getOptions().get(ename);
        if (ConsistencyCheckUtil.executeExpression(root, consistencyConfig.getExpression(),
            consistencyConfig.getCheckScope(), objProValue)) {
            return null;
        }
        ConsistencyCheckResult obj = new ConsistencyCheckResult();
        obj.setMessage(this.createMessage(com, consistencyConfig.getFieldName(), objProValue, data));
        obj.setAttrMap(this.createLayoutAttrMap(root, data, ename));
        return obj;
    }
    
    /**
     * 封装布局控件的关键信息
     * 
     * @param root 页面对象
     * @param data 布局
     * @param ename 属性名称
     * @return 校验结果所需参数
     */
    protected Map<String, String> createLayoutAttrMap(PageVO root, LayoutVO data, String ename) {
        Map<String, String> objAttrMap = new HashMap<String, String>();
        objAttrMap.put(ConsistencyResultAttrName.PAGE_ATTRNAME_PK.getValue(), root.getModelId());
        objAttrMap.put(ConsistencyResultAttrName.PAGE_LAYOUT_ATTRNAME_PK.getValue(), data.getId());
        objAttrMap.put(ConsistencyResultAttrName.PAGE_LAYOUT_ATTRNAME_COMPONENT_PRO.getValue(), ename);
        return objAttrMap;
    }
    
    /**
     * 包装提示信息
     * 
     * @param com 控件定义
     * @param field 属性
     * @param value 属性值
     * @param data layout对象
     * @return 返回消息
     */
    @SuppressWarnings("unchecked")
    protected String createMessage(ComponentVO com, String field, Object value, LayoutVO data) {
        StringBuffer sbMsg = new StringBuffer();
        Map<String, Object> objOptions = data.getOptions();
        sbMsg.append("页面控件（");
        sbMsg.append(com.getModelName());
        sbMsg.append("->");
        if (objOptions.get("label") != null) {
            sbMsg.append(objOptions.get("label"));
        } else if (objOptions.get("name") != null) {
            sbMsg.append(objOptions.get("name"));
        } else if (objOptions.get("id") != null) {
            sbMsg.append(objOptions.get("id"));
        } else {
            sbMsg.append(data.getId());
        }
        sbMsg.append("）的属性");
        sbMsg.append(field);
        sbMsg.append("关联的对象");
        sbMsg.append(value);
        return sbMsg.toString();
    }

    @Override
    public ConsistencyCheckResult checkAttrValueDependOnEntityAttr(BaseMetadata baseMetadataVO,
        List<EntityAttributeVO> entityAttrs, List<DataStoreVO> relationDataStores, LayoutVO data, PageVO page) {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        return null;
    }
}
