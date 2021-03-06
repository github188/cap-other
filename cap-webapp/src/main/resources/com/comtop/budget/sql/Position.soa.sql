begin
	 --开始注册实体SOA扩展参数信息
	P_CAP_INSERT_SOA_PARAM_EXT('position','com.comtop.budget',0,'position');
	--开始注册实体SOA服务信息
 	 P_SOA_REG_SERVICE('positionFacade','','soa','com.comtop.cap.runtime.spring.SoaBeanBuilder4Cap','com.comtop.budget.facade.PositionFacade(*)','com.comtop.budget.facade.PositionFacade');
 	 P_SOA_REG_Method('positionFacade.deleteList','','deleteList','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.deleteList_O','positionFacade.deleteList','','2','0','boolean','','');
 	 p_soa_reg_Params('positionFacade.deleteList_I0','positionFacade.deleteList','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('positionFacade.updateCascadeVO','','updateCascadeVO','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.updateCascadeVO_O','positionFacade.updateCascadeVO','','2','0','boolean','','');
 	 p_soa_reg_Params('positionFacade.updateCascadeVO_I0','positionFacade.updateCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('positionFacade.updateCascadeVO_I1','positionFacade.updateCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('positionFacade.queryVOListNoPaging','','queryVOListNoPaging','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.queryVOListNoPaging_O','positionFacade.queryVOListNoPaging','','2','0','java.util.List','','');
 	 p_soa_reg_Params('positionFacade.queryVOListNoPaging_I0','positionFacade.queryVOListNoPaging','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('positionFacade.loadById','','loadById','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.loadById_O','positionFacade.loadById','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('positionFacade.loadById_I0','positionFacade.loadById','','1','0','java.lang.String','','');
 	 P_SOA_REG_Method('positionFacade.batchUpdate','','batchUpdate','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.batchUpdate_O','positionFacade.batchUpdate','','2','0','int','','');
 	 p_soa_reg_Params('positionFacade.batchUpdate_I0','positionFacade.batchUpdate','','1','0','java.util.List','','');
 	 p_soa_reg_Params('positionFacade.batchUpdate_I1','positionFacade.batchUpdate','','1','1','java.lang.String[]','','');
 	 P_SOA_REG_Method('positionFacade.queryVOList','','queryVOList','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.queryVOList_O','positionFacade.queryVOList','','2','0','java.util.List','','');
 	 p_soa_reg_Params('positionFacade.queryVOList_I0','positionFacade.queryVOList','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('positionFacade.loadCascadeById','','loadCascadeById','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.loadCascadeById_O','positionFacade.loadCascadeById','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('positionFacade.loadCascadeById_I0','positionFacade.loadCascadeById','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('positionFacade.loadCascadeById_I1','positionFacade.loadCascadeById','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('positionFacade.load','','load','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.load_O','positionFacade.load','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('positionFacade.load_I0','positionFacade.load','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('positionFacade.getAppService','','getAppService','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.getAppService_O','positionFacade.getAppService','','2','0','com.comtop.budget.appservice.PositionAppService','','');
 	 P_SOA_REG_Method('positionFacade.save','','save','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.save_O','positionFacade.save','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('positionFacade.save_I0','positionFacade.save','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('positionFacade.delete','','delete','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.delete_O','positionFacade.delete','','2','0','boolean','','');
 	 p_soa_reg_Params('positionFacade.delete_I0','positionFacade.delete','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('positionFacade.deleteCascadeVO','','deleteCascadeVO','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.deleteCascadeVO_O','positionFacade.deleteCascadeVO','','2','0','boolean','','');
 	 p_soa_reg_Params('positionFacade.deleteCascadeVO_I0','positionFacade.deleteCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('positionFacade.deleteCascadeVO_I1','positionFacade.deleteCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('positionFacade.insertCascadeVO','','insertCascadeVO','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.insertCascadeVO_O','positionFacade.insertCascadeVO','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('positionFacade.insertCascadeVO_I0','positionFacade.insertCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('positionFacade.insertCascadeVO_I1','positionFacade.insertCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('positionFacade.queryVOListByCondition','','queryVOListByCondition','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.queryVOListByCondition_O','positionFacade.queryVOListByCondition','','2','0','java.util.List','','');
 	 p_soa_reg_Params('positionFacade.queryVOListByCondition_I0','positionFacade.queryVOListByCondition','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('positionFacade.queryVOCount','','queryVOCount','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.queryVOCount_O','positionFacade.queryVOCount','','2','0','int','','');
 	 p_soa_reg_Params('positionFacade.queryVOCount_I0','positionFacade.queryVOCount','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('positionFacade.update','','update','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.update_O','positionFacade.update','','2','0','int','','');
 	 p_soa_reg_Params('positionFacade.update_I0','positionFacade.update','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('positionFacade.deleteCascadeList','','deleteCascadeList','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.deleteCascadeList_O','positionFacade.deleteCascadeList','','2','0','boolean','','');
 	 p_soa_reg_Params('positionFacade.deleteCascadeList_I0','positionFacade.deleteCascadeList','','1','0','java.util.List','','');
 	 p_soa_reg_Params('positionFacade.deleteCascadeList_I1','positionFacade.deleteCascadeList','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('positionFacade.saveCascadeVO','','saveCascadeVO','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.saveCascadeVO_O','positionFacade.saveCascadeVO','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('positionFacade.saveCascadeVO_I0','positionFacade.saveCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('positionFacade.saveCascadeVO_I1','positionFacade.saveCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('positionFacade.queryVOListByPage','','queryVOListByPage','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.queryVOListByPage_O','positionFacade.queryVOListByPage','','2','0','java.util.Map','','');
 	 p_soa_reg_Params('positionFacade.queryVOListByPage_I0','positionFacade.queryVOListByPage','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('positionFacade.insert','','insert','positionFacade','0','0','');
 	 p_soa_reg_Params('positionFacade.insert_O','positionFacade.insert','','2','0','int','','');
 	 p_soa_reg_Params('positionFacade.insert_I0','positionFacade.insert','','1','0','java.util.List','','');

end;
/
commit;