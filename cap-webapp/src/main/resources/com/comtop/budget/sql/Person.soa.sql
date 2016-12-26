begin
	 --开始注册实体SOA扩展参数信息
	P_CAP_INSERT_SOA_PARAM_EXT('person','com.comtop.budget',0,'person');
	--开始注册实体SOA服务信息
 	 P_SOA_REG_SERVICE('personFacade','','soa','com.comtop.cap.runtime.spring.SoaBeanBuilder4Cap','com.comtop.budget.facade.PersonFacade(*)','com.comtop.budget.facade.PersonFacade');
 	 P_SOA_REG_Method('personFacade.cascadeSave','cascadeSave','cascadeSave','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.cascadeSave_O','personFacade.cascadeSave','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('personFacade.cascadeSave_I0','personFacade.cascadeSave','','1','0','com.comtop.budget.model.PersonVO','','');
 	 P_SOA_REG_Method('personFacade.update','','update','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.update_O','personFacade.update','','2','0','int','','');
 	 p_soa_reg_Params('personFacade.update_I0','personFacade.update','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('personFacade.loadCascadeById','','loadCascadeById','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.loadCascadeById_O','personFacade.loadCascadeById','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('personFacade.loadCascadeById_I0','personFacade.loadCascadeById','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('personFacade.loadCascadeById_I1','personFacade.loadCascadeById','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('personFacade.loadById','','loadById','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.loadById_O','personFacade.loadById','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('personFacade.loadById_I0','personFacade.loadById','','1','0','java.lang.String','','');
 	 P_SOA_REG_Method('personFacade.queryVOListNoPaging','','queryVOListNoPaging','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.queryVOListNoPaging_O','personFacade.queryVOListNoPaging','','2','0','java.util.List','','');
 	 p_soa_reg_Params('personFacade.queryVOListNoPaging_I0','personFacade.queryVOListNoPaging','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('personFacade.deleteList','','deleteList','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.deleteList_O','personFacade.deleteList','','2','0','boolean','','');
 	 p_soa_reg_Params('personFacade.deleteList_I0','personFacade.deleteList','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('personFacade.queryVOListByCondition','','queryVOListByCondition','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.queryVOListByCondition_O','personFacade.queryVOListByCondition','','2','0','java.util.List','','');
 	 p_soa_reg_Params('personFacade.queryVOListByCondition_I0','personFacade.queryVOListByCondition','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('personFacade.deleteCascadeList','','deleteCascadeList','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.deleteCascadeList_O','personFacade.deleteCascadeList','','2','0','boolean','','');
 	 p_soa_reg_Params('personFacade.deleteCascadeList_I0','personFacade.deleteCascadeList','','1','0','java.util.List','','');
 	 p_soa_reg_Params('personFacade.deleteCascadeList_I1','personFacade.deleteCascadeList','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('personFacade.cascadeDelete','cascadeDelete','cascadeDelete','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.cascadeDelete_O','personFacade.cascadeDelete','','2','0','java.lang.Boolean','','');
 	 p_soa_reg_Params('personFacade.cascadeDelete_I0','personFacade.cascadeDelete','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('personFacade.queryVOListByPage','','queryVOListByPage','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.queryVOListByPage_O','personFacade.queryVOListByPage','','2','0','java.util.Map','','');
 	 p_soa_reg_Params('personFacade.queryVOListByPage_I0','personFacade.queryVOListByPage','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('personFacade.batchUpdate','','batchUpdate','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.batchUpdate_O','personFacade.batchUpdate','','2','0','int','','');
 	 p_soa_reg_Params('personFacade.batchUpdate_I0','personFacade.batchUpdate','','1','0','java.util.List','','');
 	 p_soa_reg_Params('personFacade.batchUpdate_I1','personFacade.batchUpdate','','1','1','java.lang.String[]','','');
 	 P_SOA_REG_Method('personFacade.delete','','delete','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.delete_O','personFacade.delete','','2','0','boolean','','');
 	 p_soa_reg_Params('personFacade.delete_I0','personFacade.delete','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('personFacade.queryVOCount','','queryVOCount','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.queryVOCount_O','personFacade.queryVOCount','','2','0','int','','');
 	 p_soa_reg_Params('personFacade.queryVOCount_I0','personFacade.queryVOCount','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('personFacade.save','','save','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.save_O','personFacade.save','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('personFacade.save_I0','personFacade.save','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('personFacade.insert','','insert','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.insert_O','personFacade.insert','','2','0','int','','');
 	 p_soa_reg_Params('personFacade.insert_I0','personFacade.insert','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('personFacade.saveCascadeVO','','saveCascadeVO','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.saveCascadeVO_O','personFacade.saveCascadeVO','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('personFacade.saveCascadeVO_I0','personFacade.saveCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('personFacade.saveCascadeVO_I1','personFacade.saveCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('personFacade.getAppService','','getAppService','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.getAppService_O','personFacade.getAppService','','2','0','com.comtop.budget.appservice.PersonAppService','','');
 	 P_SOA_REG_Method('personFacade.insertCascadeVO','','insertCascadeVO','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.insertCascadeVO_O','personFacade.insertCascadeVO','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('personFacade.insertCascadeVO_I0','personFacade.insertCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('personFacade.insertCascadeVO_I1','personFacade.insertCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('personFacade.cascadeRead','cascadeRead','cascadeRead','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.cascadeRead_O','personFacade.cascadeRead','','2','0','com.comtop.budget.model.PersonVO','','');
 	 p_soa_reg_Params('personFacade.cascadeRead_I0','personFacade.cascadeRead','','1','0','java.lang.String','','');
 	 P_SOA_REG_Method('personFacade.load','','load','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.load_O','personFacade.load','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('personFacade.load_I0','personFacade.load','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('personFacade.deleteCascadeVO','','deleteCascadeVO','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.deleteCascadeVO_O','personFacade.deleteCascadeVO','','2','0','boolean','','');
 	 p_soa_reg_Params('personFacade.deleteCascadeVO_I0','personFacade.deleteCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('personFacade.deleteCascadeVO_I1','personFacade.deleteCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('personFacade.updateCascadeVO','','updateCascadeVO','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.updateCascadeVO_O','personFacade.updateCascadeVO','','2','0','boolean','','');
 	 p_soa_reg_Params('personFacade.updateCascadeVO_I0','personFacade.updateCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('personFacade.updateCascadeVO_I1','personFacade.updateCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('personFacade.queryVOList','','queryVOList','personFacade','0','0','');
 	 p_soa_reg_Params('personFacade.queryVOList_O','personFacade.queryVOList','','2','0','java.util.List','','');
 	 p_soa_reg_Params('personFacade.queryVOList_I0','personFacade.queryVOList','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');

end;
/
commit;