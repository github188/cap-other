begin
	 --开始注册实体SOA扩展参数信息
	P_CAP_INSERT_SOA_PARAM_EXT('jerryProjectTask','com.comtop.cap.demo.treeModule',0);
	--开始注册实体SOA服务信息
 	 P_SOA_REG_SERVICE('jerryProjectTaskFacade','','soa','com.comtop.cap.runtime.spring.SoaBeanBuilder4Cap','com.comtop.cap.demo.treeModule.facade.JerryProjectTaskFacade(*)','com.comtop.cap.demo.treeModule.facade.JerryProjectTaskFacade');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.delete','','delete','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.delete_O','jerryProjectTaskFacade.delete','','2','0','boolean','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.delete_I0','jerryProjectTaskFacade.delete','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.deleteCascadeList','','deleteCascadeList','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.deleteCascadeList_O','jerryProjectTaskFacade.deleteCascadeList','','2','0','boolean','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.deleteCascadeList_I0','jerryProjectTaskFacade.deleteCascadeList','','1','0','java.util.List','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.deleteCascadeList_I1','jerryProjectTaskFacade.deleteCascadeList','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.queryVOCount','','queryVOCount','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.queryVOCount_O','jerryProjectTaskFacade.queryVOCount','','2','0','int','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.queryVOCount_I0','jerryProjectTaskFacade.queryVOCount','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.queryVOListByCondition','','queryVOListByCondition','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.queryVOListByCondition_O','jerryProjectTaskFacade.queryVOListByCondition','','2','0','java.util.List','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.queryVOListByCondition_I0','jerryProjectTaskFacade.queryVOListByCondition','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.save','','save','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.save_O','jerryProjectTaskFacade.save','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.save_I0','jerryProjectTaskFacade.save','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.deleteCascadeVO','','deleteCascadeVO','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.deleteCascadeVO_O','jerryProjectTaskFacade.deleteCascadeVO','','2','0','boolean','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.deleteCascadeVO_I0','jerryProjectTaskFacade.deleteCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.deleteCascadeVO_I1','jerryProjectTaskFacade.deleteCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.loadById','','loadById','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.loadById_O','jerryProjectTaskFacade.loadById','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.loadById_I0','jerryProjectTaskFacade.loadById','','1','0','java.lang.String','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.load','','load','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.load_O','jerryProjectTaskFacade.load','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.load_I0','jerryProjectTaskFacade.load','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.saveCascadeVO','','saveCascadeVO','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.saveCascadeVO_O','jerryProjectTaskFacade.saveCascadeVO','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.saveCascadeVO_I0','jerryProjectTaskFacade.saveCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.saveCascadeVO_I1','jerryProjectTaskFacade.saveCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.loadCascadeById','','loadCascadeById','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.loadCascadeById_O','jerryProjectTaskFacade.loadCascadeById','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.loadCascadeById_I0','jerryProjectTaskFacade.loadCascadeById','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.loadCascadeById_I1','jerryProjectTaskFacade.loadCascadeById','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.queryVOListByPage','','queryVOListByPage','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.queryVOListByPage_O','jerryProjectTaskFacade.queryVOListByPage','','2','0','java.util.Map','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.queryVOListByPage_I0','jerryProjectTaskFacade.queryVOListByPage','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.update','','update','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.update_O','jerryProjectTaskFacade.update','','2','0','boolean','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.update_I0','jerryProjectTaskFacade.update','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.getAppService','','getAppService','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.getAppService_O','jerryProjectTaskFacade.getAppService','','2','0','com.comtop.cap.demo.treeModule.appservice.JerryProjectTaskAppService','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.queryVOList','','queryVOList','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.queryVOList_O','jerryProjectTaskFacade.queryVOList','','2','0','java.util.List','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.queryVOList_I0','jerryProjectTaskFacade.queryVOList','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.batchUpdate','','batchUpdate','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.batchUpdate_O','jerryProjectTaskFacade.batchUpdate','','2','0','int','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.batchUpdate_I0','jerryProjectTaskFacade.batchUpdate','','1','0','java.util.List','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.batchUpdate_I1','jerryProjectTaskFacade.batchUpdate','','1','1','java.lang.String[]','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.updateCascadeVO','','updateCascadeVO','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.updateCascadeVO_O','jerryProjectTaskFacade.updateCascadeVO','','2','0','boolean','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.updateCascadeVO_I0','jerryProjectTaskFacade.updateCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.updateCascadeVO_I1','jerryProjectTaskFacade.updateCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.deleteList','','deleteList','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.deleteList_O','jerryProjectTaskFacade.deleteList','','2','0','boolean','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.deleteList_I0','jerryProjectTaskFacade.deleteList','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.insertCascadeVO','','insertCascadeVO','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.insertCascadeVO_O','jerryProjectTaskFacade.insertCascadeVO','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.insertCascadeVO_I0','jerryProjectTaskFacade.insertCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.insertCascadeVO_I1','jerryProjectTaskFacade.insertCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('jerryProjectTaskFacade.insert','','insert','jerryProjectTaskFacade','0','0','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.insert_O','jerryProjectTaskFacade.insert','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('jerryProjectTaskFacade.insert_I0','jerryProjectTaskFacade.insert','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');

end;
/
commit;