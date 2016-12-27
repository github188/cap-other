/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.pdm.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by duqi on 2016/2/23.
 */
public class PdmReferanceSymbolVO extends PdmSymbolVO{

    /** 引用表ID */
    private String refReferanceId;

    /** 源 */
    private String sourceTableSymbolId;

    /** 目标 */
    private String destinationTableSymbolId;

    /** 坐标点集合 */
    private List<PdmPoint> pdmPoints = new ArrayList<PdmPoint>();

    /** 
     * 坐标点集合转换为字符串 
     * @return 坐标点集合转换为字符串 
     */
    public String pointsToString(){
        StringBuffer sb = new StringBuffer();
        sb.append("(");
        for (int i = 0; i < pdmPoints.size(); i++) {
            PdmPoint next =  pdmPoints.get(i);
            sb.append("(");
            sb.append(next.getX());
            sb.append(",");
            sb.append(next.getY());
            sb.append(")");
            if(i != pdmPoints.size() - 1){
                sb.append(",");
            }
        }
        sb.append(")");
        return sb.toString();
    }

    /**
     * @return 获取 refReferanceId属性值
     */
    public String getRefReferanceId() {
        return refReferanceId;
    }

    /**
     * @param refReferanceId 设置 refReferanceId 属性值为参数值 refReferanceId
     */
    public void setRefReferanceId(String refReferanceId) {
        this.refReferanceId = refReferanceId;
    }

    /**
     * @return 获取 sourceTableSymbolId
     */
    public String getSourceTableSymbolId() {
        return sourceTableSymbolId;
    }

    /**
     * @param sourceTableSymbolId 设置 sourceTableSymbolId 属性值为参数值 sourceTableSymbolId
     */
    public void setSourceTableSymbolId(String sourceTableSymbolId) {
        this.sourceTableSymbolId = sourceTableSymbolId;
    }

    /**
     * @return 获取 destinationTableSymbolId属性值
     */
    public String getDestinationTableSymbolId() {
        return destinationTableSymbolId;
    }

    /**
     * @param destinationTableSymbolId 设置 destinationTableSymbolId 属性值为参数值 destinationTableSymbolId
     */
    public void setDestinationTableSymbolId(String destinationTableSymbolId) {
        this.destinationTableSymbolId = destinationTableSymbolId;
    }

    /**
     * @return 获取 pdmPoints 属性值
     */
    public List<PdmPoint> getPdmPoints() {
        return pdmPoints;
    }

    /**
     * @param pdmPoints 设置 pdmPoints 属性值为参数值 pdmPoints
     */
    public void setPdmPoints(List<PdmPoint> pdmPoints) {
        this.pdmPoints = pdmPoints;
    }
}
