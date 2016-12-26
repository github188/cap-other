/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.datatype;

import javax.xml.bind.annotation.XmlEnum;

/**
 * 表格类型
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月21日 lizhiyong
 */
@XmlEnum
public enum TableType {
    
    /**
     * 行扩展表.主要是指横向表头(第一行或前几行)不变，数据纵向扩展的表格，是最常见的表格，是表格形式的结构化数据的一种， 一般用于表示同一类对象组成的数据集。如
     * 
     * <table name="业务流程清单1" border='1' cellspacing='0'>
     * <tr border='1'>
     * <th>业务事项</th>
     * <th>流程编码</th>
     * <th>业务流程名称</th>
     * <th>流程定义</th>
     * </tr >
     * 
     * <tr border='1'>
     * <td>年季月运行方式管理</td>
     * <td></td>
     * <td>年季月运行方式管理流程</td>
     * <td>XXXXXXXXXXXXXXXX</td>
     * </tr>
     * 
     * <tr border='1'>
     * <td>周日运行方式管理</td>
     * <td></td>
     * <td>周日运行方式管理流程</td>
     * <td>YYYYYYYYYYYYYYYYYY</td>
     * </tr>
     * </table>
     * 
     * 
     * 对应的 配置如下。
     * 
     * <pre>
     *  &lt;table type="EXT_ROWS" name="业务流程清单1"
     *         mappingTo="bizProcessInfo[]=#BizProcess(bizItemId=bizItem.id,bizItemName=bizItem.name)"
     *         selector="bizProcessInfo.processName"&gt;
     *         &lt;tr&gt;
     *             &lt;td mergeCellType="VERTICAL"  mappingTo="bizProcessInfo.bizItemName" storeStrategy="NO_STORE"&gt;业务事项&lt;/td&gt;
     *             &lt;td mappingTo="bizProcessInfo.code" storeStrategy="NULL_VALUE_NO_STORE"&gt;流程编码&lt;/td&gt;
     *             &lt;td mappingTo="bizProcessInfo.processName" nullAble="false"&gt;业务流程名称&lt;/td&gt;
     *             &lt;td mappingTo="bizProcessInfo.processDef" &gt;流程定义&lt;/td&gt;
     *         &lt;/tr&gt;
     *     &lt;/table&gt;
     * </pre>
     */
    EXT_ROWS,
    
    /**
     * 列扩展表。主要是指行表头动态扩展的表格。比如某班的成绩表，列头可能会因考试范围的不同而有变化，
     * 有些成绩表算语文数学外语的分数，有些还要加上物理化学的分数。而表格的列头具体是几个，由某一次
     * 具体的考试决定。对程序而言， 就是表头数据是根据数据查询组装出来的。如：
     * 
     * <table name="数据流转" border='1'>
     * <tr border='1'>
     * <th border='1' >逻辑实体</th>
     * <th border='1'>模块一</th>
     * <th border='1'>模块二</th>
     * <th border='1'>模块三</th>
     * <th border='1'>模块四</th>
     * <th border='1'>模块五</th>
     * <th border='1'>模块六</th>
     * <th border='1'>模块七</th>
     * <th border='1'>模块...</th>
     * <th border='1'>模块N</th>
     * </tr>
     * <tr border='1' >
     * <td border='1' >&nbsp;</td>
     * <td border='1'/>
     * <td border='1'/>
     * <td border='1'/>
     * <td border='1'/>
     * <td border='1'/>
     * <td border='1'/>
     * <td border='1'/>
     * <td border='1'/>
     * <td border='1'/>
     * </tr>
     * </table>
     * 
     * 上表中的模块一~N即为动态扩展的内容。配置如下：
     * 
     * <pre>
     * &lt;table name="数据流转" type="EXT_COLS" mappingTo="dataFlow[]=#DataFlow(packageId=$packageId)"&gt;
     *  &lt;tr&gt;
     *      &lt;td mappingTo="dataFlow.entityCnName"&gt;逻辑实体&lt;/td&gt;
     *      &lt;td extCell="true" mappingTo="dataFlow.flowMap" 
     *          extData="ext[]=#Package(parentId=$packageId,type=2,typeLevel=1,cascadeQuery=1)" headerLabel="ext.name" 
     *      valueKey="ext.id"/&gt;
     *  &lt;/tr&gt;
     * &lt;/table&gt;
     * </pre>
     */
    EXT_COLS,
    
    /**
     * 固定表 。主要是指表格单元格或行列结构固定的表格，一般用于表示一个对象，是表格形式的结构化数据的一种。比如个人简历信息登记表，就可以认为是一个固定表。如，下表即是一个固定表
     * <table type="FIXED" name="业务关联表" optional="1" border='1' descriptionBefore=".*关联信息.*" width='900'>
     * <tr border='1' >
     * <td width="20%" border='1'></td>
     * <td border='1'>本方业务</td>
     * <td border='1'>对方业务</td>
     * </tr>
     * <tr border='1'>
     * <td width="20%">关联关系编码</td>
     * <td />
     * </tr>
     * <tr border='1'>
     * <td width="20%">流程节点</td>
     * <td />
     * <td />
     * </tr>
     * </table>
     * 上述表结构的配置所下所示：
     * 
     * <pre>
     * &lt;table type="FIXED" name="业务关联表" optional="1"  descriptionBefore=".*关联信息.*"&gt;
     *  &lt;tr  &gt;
     *    &lt;td width="3" &gt;&lt/td&gt;
     *    &lt;td &gt;本方业务&lt/td&gt;
     *    &lt;td &gt;对方业务&lt/td&gt;
     *  &lt;/tr&gt;
     *  &lt;tr &gt;
     *    &lt;td width="3"&gt;关联关系编码&lt/td&gt;
     *    &lt;td colspan="2" mappingTo="bizRelation.code" storeStrategy="NULL_VALUE_NO_STORE"/&gt;
     *  &lt;/tr&gt;
     *  &lt;tr &gt;
     *    &lt;td width="3"&gt;流程节点&lt/td&gt;
     *    &lt;td mappingTo="bizRelation.roleaNodeName" /&gt;
     *    &lt;td mappingTo="bizRelation.rolebNodeName" /&gt;
     *  &lt;/tr&gt;
     * &lt;/table&gt;
     * </pre>
     */
    FIXED,
    
    // /** 固定表内行扩展 */
    // FIXED_EXT_ROWS,
    //
    // /** 固定表内列扩展 */
    // FIXED_EXT_COLS,
    //
    /**
     * 不确定结构表。未在模板中定义的表格均为UNKNOWN。
     * 模板中也可以定义UNKNOWN类型的表格，这种情况主要用于指定某个UNKNOWN类型的表格不需要存储。
     * 一般情况下，UNKNOWN表格是不需要定义的。UNKNOWN类型的表格如果要存储，会将其转换为Html的表格字符串。
     */
    UNKNOWN;
    
    /** 行列均扩展表 */
    // EXT_BOTH;
    
    @Override
    public String toString() {
        return this.name();
    }
}
