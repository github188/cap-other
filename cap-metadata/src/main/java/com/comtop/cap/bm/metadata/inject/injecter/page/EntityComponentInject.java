package com.comtop.cap.bm.metadata.inject.injecter.page;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter;
import com.comtop.cap.bm.metadata.inject.injecter.util.MetadataInjectProvider;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.template.model.MetadataGenerateVO;
import com.comtop.cap.bm.metadata.page.template.model.RowFromEntityAreaVO;
import com.comtop.top.core.util.StringUtil;

/**
 * 实体信息封装
 *
 * @author  肖威
 * @since   jdk1.6
 * @version 2016年1月8日 肖威
 */
public class EntityComponentInject implements IMetaDataInjecter {

    /** 日志 */
    protected final static Logger LOG = LoggerFactory.getLogger(GirdAndRenderActionInjecter.class);
 
	
    /**
     * 
     * @see com.comtop.cap.bm.metadata.inject.injecter.IMetaDataInjecter#inject(java.lang.Object, java.lang.Object)
     */
    @Override
    public void inject(Object obj, Object source) {
        MetadataGenerateVO objMetadataGenerate = (MetadataGenerateVO) obj;
        
        List<RowFromEntityAreaVO> lstEntities;
		try {
			lstEntities = objMetadataGenerate.queryList("metadataValue/entityComponentList/rowList", RowFromEntityAreaVO.class);
			Map<String,String> entityIdMap = new HashMap<String,String>();
			
			for (RowFromEntityAreaVO rowFromEntityAreaVO : lstEntities) {
				entityIdMap.put(rowFromEntityAreaVO.getSuffix(), rowFromEntityAreaVO.getModelId());
			}
			
			List<DataStoreVO> lstDataStores = MetadataInjectProvider.queryList(source, "dataStoreVOList[alias != '']", DataStoreVO.class);
			
			for (DataStoreVO dataStoreVO : lstDataStores) {
				String strEntityId = entityIdMap.get(dataStoreVO.getAlias());
				if(StringUtil.isNotBlank(strEntityId)){
					dataStoreVO.setEntityId(strEntityId);
				}
			}
		} catch (OperateException e) {
			LOG.error("注入实体异常", e);
		}
       /* 
        MetadataValueVO objMetadataValue = objMetadataGenerate.getMetadataValue();
        List<EntitySelectionAreaComponentVO> lstEntityComponents = objMetadataValue.getEntityComponentList();
        if(lstEntityComponents==null||lstEntityComponents.size()==0){
            return;
        }
        for (Iterator<EntitySelectionAreaComponentVO> iterator = lstEntityComponents.iterator(); iterator.hasNext();) {
            EntitySelectionAreaComponentVO entitySelectionAreaComponentVO = iterator.next();
            List<RowFromEntityAreaVO>  lstEntities= entitySelectionAreaComponentVO.getRowList();
            for (Iterator<RowFromEntityAreaVO> iterator2 = lstEntities.iterator(); iterator2.hasNext();) {
                RowFromEntityAreaVO rowFromEntityAreaVO = iterator2.next();
                this.updateEntity(rowFromEntityAreaVO, source);
            }
        }*/
    }
    
//    /**
//     * 根据实体集合信息更新对应页面中实体
//     * @param entity 新实体信息
//     * @param source 待更新页面对象集合
//     * @return 操作结果
//     */
//    private boolean updateEntity(RowFromEntityAreaVO entity,List<Object> source){
//            String strSuffix = entity.getSuffix();
//            String strModelId = entity.getModelId();
//            for (Iterator iterator = source.iterator(); iterator.hasNext();) {
//                PageVO pageVO = (PageVO) iterator.next();
//                List<DataStoreVO> lstDataStores;
//                try {
//                    lstDataStores = pageVO.queryList("dataStoreVOList[contains(alias,"+strSuffix+")]");
//                    if(lstDataStores==null||lstDataStores.size()==0){
//                        return false;
//                    }
//                    for (Iterator<DataStoreVO> iterator2 = lstDataStores.iterator(); iterator2.hasNext();) {
//                        DataStoreVO objDataStoreVO = iterator2.next();
//                        if(StringUtil.equals(strSuffix, objDataStoreVO.getAlias())){
//                            MetadataInjectProvider.update(objDataStoreVO, "entityId", strModelId);
//                        }
//                    }
//                } catch (OperateException e) {
////                    e.printStackTrace();
//                    return false;
//                }
//            }
//        return true;
//    }
}