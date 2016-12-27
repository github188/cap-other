/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.dbd.facade;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.database.dbobject.facade.FunctionFacade;
import com.comtop.cap.bm.metadata.database.dbobject.facade.ProcedureFacade;
import com.comtop.cap.bm.metadata.database.dbobject.facade.TableFacade;
import com.comtop.cap.bm.metadata.database.dbobject.facade.ViewFacade;
import com.comtop.cap.bm.metadata.database.dbobject.model.FunctionVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ProcedureVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewVO;
import com.comtop.cap.doc.dbd.convert.DBObjectConverter;
import com.comtop.cap.doc.dbd.model.DBObjectDTO;
import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.word.dao.IWordDataAccessor;
import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.top.core.jodd.AppContext;

/**
 * 数据库文档处理封装类-数据表操作
 * 
 * @author 李小强
 * @since 1.0
 * @version 2015-12-30 李小强
 */
@PetiteBean
@DocumentService(name = "DBObject", description = "数据库文档处理封装类-数据库对象", dataType = DBObjectDTO.class)
public class DataBaseObjectDocFacade implements IWordDataAccessor<DBObjectDTO> {
    
    /** 函数facade类 */
    protected FunctionFacade functionFacade = AppContext.getBean(FunctionFacade.class);
    
    /** 存储过程facade类 */
    protected ProcedureFacade procedureFacade = AppContext.getBean(ProcedureFacade.class);
    
    /** 视图facade类 */
    protected ViewFacade viewFacade = AppContext.getBean(ViewFacade.class);
    
    /** 表facade类 */
    protected TableFacade tableFacade = AppContext.getBean(TableFacade.class);
    
    @Override
    public void saveData(List<DBObjectDTO> collection) {
        // FunctionFacade.queryFunctionOfPkgAndSubPkg
        // ProcedureFacade.queryProcedureOfPkgAndSubPkg
        // TableFacade.queryTableOfPkgAndSubPkg
        // ViewFacade.queryViewOfPkgAndSubPkg
        
    }
    
    @Override
    public List<DBObjectDTO> loadData(DBObjectDTO condition) {
        String packageId = condition.getPackageId();
        /** 类型<扩展字段>-对象类型（1、表；2、视图；3、存储过程；4：函数） */
        int type = condition.getType();
        switch (type) {
            case 1: {
                return loadTableData(packageId);
            }
            case 2: {
                return loadViewData(packageId);
            }
            case 3: {
                return loadProcedureData(packageId);
            }
            case 4: {
                return loadFunctionData(packageId);
            }
            default: {
                List<DBObjectDTO> list = new ArrayList<DBObjectDTO>();
                list.addAll(loadTableData(packageId));
                list.addAll(loadViewData(packageId));
                list.addAll(loadProcedureData(packageId));
                list.addAll(loadFunctionData(packageId));
                setSortIndex(list);
                return list;
            }
        }
    }
    
    /**
     * 加载函数
     *
     * @param packageId 模块id
     * @return 函数清单
     */
    public List<DBObjectDTO> loadFunctionData(String packageId) {
        List<FunctionVO> lstTables = functionFacade.queryFunctionOfPkgAndSubPkg(packageId);
        List<DBObjectDTO> lstDto = new ArrayList<DBObjectDTO>(lstTables.size());
        DBObjectConverter.functionVOs2DBObjectDTOs(lstTables, lstDto);
        return lstDto;
    }
    
    /**
     * 存储过程
     *
     * @param packageId 模块id
     * @return 函数清单
     */
    public List<DBObjectDTO> loadProcedureData(String packageId) {
        List<ProcedureVO> lstTables = procedureFacade.queryProcedureOfPkgAndSubPkg(packageId);
        List<DBObjectDTO> lstDto = new ArrayList<DBObjectDTO>(lstTables.size());
        DBObjectConverter.procedureVOs2DBObjectDTOs(lstTables, lstDto);
        return lstDto;
    }
    
    /**
     * 加载视图
     *
     * @param packageId 模块id
     * @return 函数清单
     */
    public List<DBObjectDTO> loadViewData(String packageId) {
        List<ViewVO> lstViews = viewFacade.queryViewOfPkgAndSubPkg(packageId);
        List<DBObjectDTO> lstDto = new ArrayList<DBObjectDTO>(lstViews.size());
        DBObjectConverter.viewVOs2DBObjectDTOs(lstViews, lstDto);
        return lstDto;
    }
    
    /**
     * 加载数据表
     *
     * @param packageId 模块id
     * @return 数据表清单
     */
    public List<DBObjectDTO> loadTableData(String packageId) {
        List<TableVO> lstTables = tableFacade.queryTableOfPkgAndSubPkg(packageId);
        List<DBObjectDTO> lstDto = new ArrayList<DBObjectDTO>(lstTables.size());
        DBObjectConverter.tableVOs2DBObjectDTOs(lstTables, lstDto);
        return lstDto;
    }
    
    @Override
    public void updatePropertyByID(String id, String property, Object value) {
        // TODO 自动生成的方法存根
        
    }
    
    /**
     * 设置排序号
     * @param <T> BaseDTO
     * @param datas 数据集
     */
    protected <T extends BaseDTO> void setSortIndex(List<T> datas) {
        if (datas != null && datas.size() > 0) {
            int i = 1;
            for (T t : datas) {
                t.setSortIndex(i++);
            }
        }
    }
}
