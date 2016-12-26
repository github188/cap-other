begin
	 --开始注册实体SOA扩展参数信息
	P_CAP_INSERT_SOA_PARAM_EXT('queryEntity','com.comtop.meeting',0);
	--开始注册实体SOA服务信息
 	 P_SOA_REG_SERVICE('queryEntityFacade','','soa','com.comtop.cap.runtime.spring.SoaBeanBuilder4Cap','com.comtop.meeting.facade.QueryEntityFacade(*)','com.comtop.meeting.facade.QueryEntityFacade');
 	 P_SOA_REG_Method('queryEntityFacade.deleteList','','deleteList','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.deleteList_O','queryEntityFacade.deleteList','','2','0','boolean','','');
 	 p_soa_reg_Params('queryEntityFacade.deleteList_I0','queryEntityFacade.deleteList','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('queryEntityFacade.load','','load','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.load_O','queryEntityFacade.load','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('queryEntityFacade.load_I0','queryEntityFacade.load','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('queryEntityFacade.delete','','delete','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.delete_O','queryEntityFacade.delete','','2','0','boolean','','');
 	 p_soa_reg_Params('queryEntityFacade.delete_I0','queryEntityFacade.delete','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('queryEntityFacade.insert','','insert','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.insert_O','queryEntityFacade.insert','','2','0','int','','');
 	 p_soa_reg_Params('queryEntityFacade.insert_I0','queryEntityFacade.insert','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('queryEntityFacade.queryVOCount','','queryVOCount','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.queryVOCount_O','queryEntityFacade.queryVOCount','','2','0','int','','');
 	 p_soa_reg_Params('queryEntityFacade.queryVOCount_I0','queryEntityFacade.queryVOCount','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('queryEntityFacade.loadById','','loadById','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.loadById_O','queryEntityFacade.loadById','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('queryEntityFacade.loadById_I0','queryEntityFacade.loadById','','1','0','java.lang.String','','');
 	 P_SOA_REG_Method('queryEntityFacade.queryVOList','','queryVOList','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.queryVOList_O','queryEntityFacade.queryVOList','','2','0','java.util.List','','');
 	 p_soa_reg_Params('queryEntityFacade.queryVOList_I0','queryEntityFacade.queryVOList','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('queryEntityFacade.insertCascadeVO','','insertCascadeVO','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.insertCascadeVO_O','queryEntityFacade.insertCascadeVO','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('queryEntityFacade.insertCascadeVO_I0','queryEntityFacade.insertCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('queryEntityFacade.insertCascadeVO_I1','queryEntityFacade.insertCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('queryEntityFacade.batchUpdate','','batchUpdate','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.batchUpdate_O','queryEntityFacade.batchUpdate','','2','0','int','','');
 	 p_soa_reg_Params('queryEntityFacade.batchUpdate_I0','queryEntityFacade.batchUpdate','','1','0','java.util.List','','');
 	 p_soa_reg_Params('queryEntityFacade.batchUpdate_I1','queryEntityFacade.batchUpdate','','1','1','java.lang.String[]','','');
 	 P_SOA_REG_Method('queryEntityFacade.queryVOListByPage','','queryVOListByPage','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.queryVOListByPage_O','queryEntityFacade.queryVOListByPage','','2','0','java.util.Map','','');
 	 p_soa_reg_Params('queryEntityFacade.queryVOListByPage_I0','queryEntityFacade.queryVOListByPage','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('queryEntityFacade.save','','save','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.save_O','queryEntityFacade.save','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('queryEntityFacade.save_I0','queryEntityFacade.save','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('queryEntityFacade.getAppService','','getAppService','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.getAppService_O','queryEntityFacade.getAppService','','2','0','com.comtop.meeting.appservice.QueryEntityAppService','','');
 	 P_SOA_REG_Method('queryEntityFacade.saveCascadeVO','','saveCascadeVO','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.saveCascadeVO_O','queryEntityFacade.saveCascadeVO','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('queryEntityFacade.saveCascadeVO_I0','queryEntityFacade.saveCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('queryEntityFacade.saveCascadeVO_I1','queryEntityFacade.saveCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('queryEntityFacade.updateCascadeVO','','updateCascadeVO','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.updateCascadeVO_O','queryEntityFacade.updateCascadeVO','','2','0','boolean','','');
 	 p_soa_reg_Params('queryEntityFacade.updateCascadeVO_I0','queryEntityFacade.updateCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('queryEntityFacade.updateCascadeVO_I1','queryEntityFacade.updateCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('queryEntityFacade.deleteCascadeVO','','deleteCascadeVO','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.deleteCascadeVO_O','queryEntityFacade.deleteCascadeVO','','2','0','boolean','','');
 	 p_soa_reg_Params('queryEntityFacade.deleteCascadeVO_I0','queryEntityFacade.deleteCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('queryEntityFacade.deleteCascadeVO_I1','queryEntityFacade.deleteCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('queryEntityFacade.loadCascadeById','','loadCascadeById','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.loadCascadeById_O','queryEntityFacade.loadCascadeById','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('queryEntityFacade.loadCascadeById_I0','queryEntityFacade.loadCascadeById','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('queryEntityFacade.loadCascadeById_I1','queryEntityFacade.loadCascadeById','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('queryEntityFacade.deleteCascadeList','','deleteCascadeList','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.deleteCascadeList_O','queryEntityFacade.deleteCascadeList','','2','0','boolean','','');
 	 p_soa_reg_Params('queryEntityFacade.deleteCascadeList_I0','queryEntityFacade.deleteCascadeList','','1','0','java.util.List','','');
 	 p_soa_reg_Params('queryEntityFacade.deleteCascadeList_I1','queryEntityFacade.deleteCascadeList','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('queryEntityFacade.update','','update','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.update_O','queryEntityFacade.update','','2','0','boolean','','');
 	 p_soa_reg_Params('queryEntityFacade.update_I0','queryEntityFacade.update','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('queryEntityFacade.queryVOListByCondition','','queryVOListByCondition','queryEntityFacade','0','0','');
 	 p_soa_reg_Params('queryEntityFacade.queryVOListByCondition_O','queryEntityFacade.queryVOListByCondition','','2','0','java.util.List','','');
 	 p_soa_reg_Params('queryEntityFacade.queryVOListByCondition_I0','queryEntityFacade.queryVOListByCondition','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');

end;
/
commit;