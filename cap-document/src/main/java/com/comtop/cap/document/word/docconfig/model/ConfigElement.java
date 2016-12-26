/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.model;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;

/**
 * 配置Word元素基类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月21日 lizhiyong
 */
@XmlType(name = "ConfigElementType")
@XmlAccessorType(XmlAccessType.FIELD)
public abstract class ConfigElement implements Serializable {
    
    /** 类序列号 */
    private static final long serialVersionUID = 1L;
    
    /**
     * 映射到。根据子类的不同，映射的uri可能代表属性，也可能代表类。
     * 按照规则，章节、表格映射到类，单元格、文本、对象映射到属性。
     * 导入word文档时，该值表明将数据映射到哪个对象或哪个属性上。
     * 导出word时，该值表明从哪个对象或哪个属性上取数据。
     * 该属性是模板配置中的核心属性之一。该属性的值必须是表达式引擎支持的表达式格式。
     * 
     * 对于表达式定义如下：<br/>
     * 服务取值 # ，并将取得的值 赋给变量biz[]。其中参数可以为常量字符串，也可以为上下文变量val,还可以为全局变量。参数之间以，分隔
     * “biz[]=”表示取值 类型为集合，“biz="表示取值类型为一个对象或值。其中biz可以被上下文中的其它变量引用 ,但变量定义不是必须的。 <br/>
     * 举例如下：<br/>
     * 1、查询表达式，亦即服务表达式，格式 为 变量名=#服务名(参数1,参数2...)。<br/>
     * 变量名带[]表示是一个集合，也可以不带[]，表明是单个对象。<br/>
     * 服务名是com.comtop.cap.document.expression.annotation.DocumentService 注解的name属性的值，由容器自动扫描注册。<br/>
     * 参数格式为 对象属性名=属性值，属性值可以是常量，如数字1，字符串'abc'，也可以是某个属性表达式，还可以是全局变量表达式。<br/>
     * 如：<br/>
     * biz[] = #BizObject(domain= $domainId,docId='abc'，type=0,parentId=package.id)<br/>
     * 上述表达式调用服务BizObject进行查询，值赋给biz[]（值为集合）。查询条件为：<br/>
     * domain= $domainId(参数类型为全局变量表达式),<br/>
     * docId='abc'(参数类型为字符串型)，<br/>
     * type=0(参数类型为数字型),<br/>
     * parentId=package.id(参数类型为属性表达式，其中package为上下文中定义的另外一个变量)<br/>
     * 
     * 2、属性表达式，格式为：变量名1=变量名2.属性名,变量名表示当前变量 ，变量名2表示上下文变量，如果不需要变量名1，则格式变为：变量名2.属性名<br/>
     * 1)biz[] = domain.bizObjects 取domain变量(其中domain为上下文中定义的一个变量)的bizObjects属性，将其赋值给biz[]<br/>
     * 2)biz.name 取biz变量的属性name <br/>
     * 
     * 3、函数表达式。格式$函数名(参数1,参数2...),其中函数名来自于注册到容器中的函数的名称，即代码中使用了com.comtop.cap.document.expression.annotation.
     * Function注解的name属性<br/>
     * 1）$conect(biz.o,'ddddd') 将函数的值赋值给某个元素的某个属性<br/>
     * 
     * 4、全局变量表达式
     * 1）$documentId：定义一个全局变量表达式,将其值赋值给模板中的某个元素的属性<br/>
     * 2）biz[] = #BizObject(domain= $domainId,docId='abc'，type=0,parentId=package.id)：$domainId作为查询服务的参数<br/>
     */
    @XmlAttribute
    private String mappingTo;
    
    /**
     * 元素是否可选 。目前未启用
     * 
     * 对表格而言，可用于对表格进行非精确匹配。
     * 比如模板中定义的表格和word中的实际表格基本一致，但word中有一个非关键列不存在，
     * 此时optional值可以true,解析程序则可以根据该标志位来进行表格的模糊匹配。
     * 
     * 对章节而言，可以定义章节是否需要输出，对其它内容而言，可以定义内容是否必须存在。
     */
    @XmlAttribute
    private Boolean optional;
    
    /** 元素名称。非必须，主要用于区分模板中的相同类型的不同元素，配置后对于输出准确的模板校验日志会有帮助 */
    @XmlAttribute
    private String name;
    
    /** 元素的id，即元素的唯一标记，目前未启用 */
    @XmlAttribute
    private String id;
    
    /** 元素的序号。在同一层次下的元素的序号，对于章节内容的定位很帮助。 */
    @XmlTransient
    private Integer sortNo;
    
    /** 同层次下元素的最多出现次数，目前未启用。 */
    @XmlAttribute
    private Integer maxOccurs;
    
    /**
     * 初始化
     * 
     */
    public void initConfig() {
        //
    }
    
    /**
     * @return 获取 maxOccurs属性值
     */
    public int getMaxOccurs() {
        return maxOccurs == null ? Integer.MAX_VALUE : (maxOccurs < 0 ? Integer.MAX_VALUE : maxOccurs);
    }
    
    /**
     * @param maxOccurs 设置 maxOccurs 属性值为参数值 maxOccurs
     */
    public void setMaxOccurs(int maxOccurs) {
        this.maxOccurs = maxOccurs;
    }
    
    /**
     * 获得映射的URI。根据子类的不同，映射的uri可能代表属性，也可能代表类
     *
     * @return 根据子类的不同，映射的uri可能代表属性，也可能代表类
     */
    public String getMappingTo() {
        return mappingTo;
    }
    
    /***
     * 
     * 设置映射的URI
     *
     * @param mappingTo 映射uri
     */
    public void setMappingTo(String mappingTo) {
        this.mappingTo = mappingTo;
    }
    
    /**
     * @return 获取 optional属性值
     */
    public Boolean getOptional() {
        return optional;
    }
    
    /**
     * @param optional 设置 optional 属性值为参数值 optional
     */
    public void setOptional(Boolean optional) {
        this.optional = optional;
    }
    
    /**
     * @return 获取 name属性值
     */
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 name 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 id属性值
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 sortNo属性值
     */
    public Integer getSortNo() {
        return sortNo == null ? 0 : sortNo;
    }
    
    /**
     * @param sortNo 设置 sortNo 属性值为参数值 sortNo
     */
    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
    
}
