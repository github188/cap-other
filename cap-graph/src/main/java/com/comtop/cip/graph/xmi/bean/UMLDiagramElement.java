
package com.comtop.cip.graph.xmi.bean;

import org.dom4j.Element;

import com.comtop.cip.graph.xmi.utils.XMIUtil;

/**
 * 
 * 图标内的元素信息：主要包含位置信息
 *
 * @author duqi
 * @since jdk1.6
 * @version 2015年10月20日 duqi
 */
public class UMLDiagramElement {
    
    /** 几何图形及位置信息 */
    private String geometry;
    
    /** 主题 关联的UML元素的ID */
    private String subject;
    
    /** 序列化号 */
    private String seqno;
    
    /** 样式 */
    private String style;
    
    /** DUID */
    private String DUID;
    
    /**
     * 构造函数
     * 
     * @param geometry 几何图形
     * @param subject 主题
     * @param seqno 序列化号
     */
    public UMLDiagramElement(String geometry, String subject, String seqno) {
        this.geometry = geometry;
        this.subject = subject;
        this.seqno = seqno;
        this.DUID = XMIUtil.getDUID();
        this.style = "DUID=" + this.DUID;
    }
    
    /**
     * 构造函数
     * 
     * @param geometry 几何图形
     * @param subject 主题
     * @param seqno 序列化号
     * @param style 样式
     */
    public UMLDiagramElement(String geometry, String subject, String seqno, String style) {
        this.geometry = geometry;
        this.subject = subject;
        this.seqno = seqno;
        this.style = style;
    }
    
    /**
     * 
     * 转换为XML的DOM结构
     *
     * @param parent 父DOM元素
     */
    public void toDom(Element parent) {
        Element diagram = parent.addElement("UML:DiagramElement");
        XMIUtil.addElementAttribute(diagram, "geometry", this.geometry);
        XMIUtil.addElementAttribute(diagram, "subject", this.subject);
        XMIUtil.addElementAttribute(diagram, "seqno", this.seqno);
        XMIUtil.addElementAttribute(diagram, "style", this.style);
    }
    
    /**
     * @return 获取 geometry属性值
     */
    public String getGeometry() {
        return geometry;
    }
    
    /**
     * @param geometry 设置 geometry 属性值为参数值 geometry
     */
    public void setGeometry(String geometry) {
        this.geometry = geometry;
    }
    
    /**
     * @return 获取 subject属性值
     */
    public String getSubject() {
        return subject;
    }
    
    /**
     * @param subject 设置 subject 属性值为参数值 subject
     */
    public void setSubject(String subject) {
        this.subject = subject;
    }
    
    /**
     * @return 获取 seqno属性值
     */
    public String getSeqno() {
        return seqno;
    }
    
    /**
     * @param seqno 设置 seqno 属性值为参数值 seqno
     */
    public void setSeqno(String seqno) {
        this.seqno = seqno;
    }
    
    /**
     * @return 获取 style属性值
     */
    public String getStyle() {
        return style;
    }
    
    /**
     * @param style 设置 style 属性值为参数值 style
     */
    public void setStyle(String style) {
        this.style = style;
    }
    
    /**
     * @return 获取 dUID属性值
     */
    public String getDUID() {
        return DUID;
    }
    
    /**
     * @param dUID 设置 dUID 属性值为参数值 dUID
     */
    public void setDUID(String dUID) {
        DUID = dUID;
    }
    
}
