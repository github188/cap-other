/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.top.core.jodd.AppContext;


/**
 * 元数据工具类
 *
 * @author 罗珍明
 * @since jdk1.6
 * @version 2015-9-24 罗珍明
 */
public final class CapMetaDataUtil {
	/** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(CapMetaDataUtil.class);
    
    /**
     * 查询所有指定元数据个数
     * @param constant 元数据类型
     * @return 个数
     */
    public final static int queryAllMetaDataCount(CapMetaDataConstant constant){
    	int iCount = 0;
    	 try {
    		 iCount = CacheOperator.queryCount(constant.getMetaDataType());
		} catch (OperateException e) {
			LOG.error("查询系统所有页面数量出错", e);
		}
    	return iCount;
    }
    
    /**
     * 查询指定模块的元数据个数
     * @param packageId 模块Id
     * @param constant 元数据类型
     * @return 模块页面个数
     */
    public final static int queryMetaDataCountByPackageId(String packageId,CapMetaDataConstant constant){
    	int iCount = 0;
    	try {
    		String strPackageName = getPackageFullPath(packageId);
    		if(strPackageName == null){
    			return iCount;
    		}
    		iCount = CacheOperator.queryCount(strPackageName + "/"+constant.getMetaDataType());
		} catch (OperateException e) {
			LOG.error("查询模块页面数量出错，packageId："+packageId, e);
		}
    	return iCount;
    }
    

	/**
	 * 根据创建人、创建时间查询元数据个数
	 * @param startTime 开始时间
	 * @param endTime 结束时间
	 * @param createrId 创建人
	 * @param constant 元数据类型
	 * @return 满足条件的页面个数
	 */
    public final static int queryMetaDataCountByCreate(long startTime,long endTime,String createrId,CapMetaDataConstant constant) {
		int iCount = 0;
		try {
			String strQueryConstant = constant.getMetaDataType()+"[";
			StringBuffer queryExpression = new StringBuffer(256);
			queryExpression.append(strQueryConstant);
			String strTemp;
			if(startTime > 0){
				strTemp = "createTime>="+startTime;
				queryExpression.append(strTemp);
			}
			if(endTime > 0){
				queryExpression.append(" and ");
				strTemp = "createTime<="+endTime;
				queryExpression.append(strTemp);
			}
			if(createrId != null){
				queryExpression.append(" and ");
				strTemp = "createrId='"+createrId+"'";
				queryExpression.append(strTemp);
			}
			int length = strQueryConstant.length();
			if(queryExpression.length()>length){
				queryExpression.append("]");
			}else{
				queryExpression.substring(0,length-1);
			}
			iCount = CacheOperator.queryCount(queryExpression.toString());
		} catch (OperateException e) {
			LOG.error("查询模块页面数量出错，packageId：", e);
		}
		return iCount;
	}
	
    /**
     * 
     * @param packageId 包对象ID
     * @return packageFullPath
     */
	private static final String getPackageFullPath(String packageId){
		SysmodelFacade packageFacade = AppContext.getBean(SysmodelFacade.class);
		CapPackageVO objPackageVO = packageFacade.queryPackageById(packageId);
		return objPackageVO == null? null:objPackageVO.getFullPath();
	}
}
