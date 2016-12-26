begin
	 --开始注册实体SOA扩展参数信息
	P_CAP_INSERT_SOA_PARAM_EXT('xcMeeting','com.comtop.meeting',0);
	--开始注册实体SOA服务信息
 	 P_SOA_REG_SERVICE('xcMeetingFacade','','soa','com.comtop.cap.runtime.spring.SoaBeanBuilder4Cap','com.comtop.meeting.facade.XcMeetingFacade(*)','com.comtop.meeting.facade.XcMeetingFacade');
 	 P_SOA_REG_Method('xcMeetingFacade.meetingView','','meetingView','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.meetingView_O','xcMeetingFacade.meetingView','','2','0','java.util.List','','');
 	 p_soa_reg_Params('xcMeetingFacade.meetingView_I0','xcMeetingFacade.meetingView','','1','0','java.util.Date','','');
 	 P_SOA_REG_Method('xcMeetingFacade.insert','','insert','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.insert_O','xcMeetingFacade.insert','','2','0','int','','');
 	 p_soa_reg_Params('xcMeetingFacade.insert_I0','xcMeetingFacade.insert','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingFacade.updateCascadeVO','','updateCascadeVO','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.updateCascadeVO_O','xcMeetingFacade.updateCascadeVO','','2','0','boolean','','');
 	 p_soa_reg_Params('xcMeetingFacade.updateCascadeVO_I0','xcMeetingFacade.updateCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingFacade.updateCascadeVO_I1','xcMeetingFacade.updateCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingFacade.deleteCascadeList','','deleteCascadeList','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.deleteCascadeList_O','xcMeetingFacade.deleteCascadeList','','2','0','boolean','','');
 	 p_soa_reg_Params('xcMeetingFacade.deleteCascadeList_I0','xcMeetingFacade.deleteCascadeList','','1','0','java.util.List','','');
 	 p_soa_reg_Params('xcMeetingFacade.deleteCascadeList_I1','xcMeetingFacade.deleteCascadeList','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingFacade.queryVOList','','queryVOList','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.queryVOList_O','xcMeetingFacade.queryVOList','','2','0','java.util.List','','');
 	 p_soa_reg_Params('xcMeetingFacade.queryVOList_I0','xcMeetingFacade.queryVOList','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingFacade.queryVOListByPage','','queryVOListByPage','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.queryVOListByPage_O','xcMeetingFacade.queryVOListByPage','','2','0','java.util.Map','','');
 	 p_soa_reg_Params('xcMeetingFacade.queryVOListByPage_I0','xcMeetingFacade.queryVOListByPage','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingFacade.delete','','delete','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.delete_O','xcMeetingFacade.delete','','2','0','boolean','','');
 	 p_soa_reg_Params('xcMeetingFacade.delete_I0','xcMeetingFacade.delete','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingFacade.deleteCascadeVO','','deleteCascadeVO','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.deleteCascadeVO_O','xcMeetingFacade.deleteCascadeVO','','2','0','boolean','','');
 	 p_soa_reg_Params('xcMeetingFacade.deleteCascadeVO_I0','xcMeetingFacade.deleteCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingFacade.deleteCascadeVO_I1','xcMeetingFacade.deleteCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingFacade.saveCascadeVO','','saveCascadeVO','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.saveCascadeVO_O','xcMeetingFacade.saveCascadeVO','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingFacade.saveCascadeVO_I0','xcMeetingFacade.saveCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingFacade.saveCascadeVO_I1','xcMeetingFacade.saveCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingFacade.insertCascadeVO','','insertCascadeVO','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.insertCascadeVO_O','xcMeetingFacade.insertCascadeVO','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingFacade.insertCascadeVO_I0','xcMeetingFacade.insertCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingFacade.insertCascadeVO_I1','xcMeetingFacade.insertCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingFacade.update','','update','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.update_O','xcMeetingFacade.update','','2','0','boolean','','');
 	 p_soa_reg_Params('xcMeetingFacade.update_I0','xcMeetingFacade.update','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingFacade.save','','save','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.save_O','xcMeetingFacade.save','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingFacade.save_I0','xcMeetingFacade.save','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingFacade.getAppService','','getAppService','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.getAppService_O','xcMeetingFacade.getAppService','','2','0','com.comtop.meeting.appservice.XcMeetingAppService','','');
 	 P_SOA_REG_Method('xcMeetingFacade.loadCascadeById','','loadCascadeById','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.loadCascadeById_O','xcMeetingFacade.loadCascadeById','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingFacade.loadCascadeById_I0','xcMeetingFacade.loadCascadeById','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingFacade.loadCascadeById_I1','xcMeetingFacade.loadCascadeById','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingFacade.deleteList','','deleteList','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.deleteList_O','xcMeetingFacade.deleteList','','2','0','boolean','','');
 	 p_soa_reg_Params('xcMeetingFacade.deleteList_I0','xcMeetingFacade.deleteList','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingFacade.queryVOCount','','queryVOCount','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.queryVOCount_O','xcMeetingFacade.queryVOCount','','2','0','int','','');
 	 p_soa_reg_Params('xcMeetingFacade.queryVOCount_I0','xcMeetingFacade.queryVOCount','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingFacade.queryVOListByCondition','','queryVOListByCondition','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.queryVOListByCondition_O','xcMeetingFacade.queryVOListByCondition','','2','0','java.util.List','','');
 	 p_soa_reg_Params('xcMeetingFacade.queryVOListByCondition_I0','xcMeetingFacade.queryVOListByCondition','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingFacade.batchUpdate','','batchUpdate','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.batchUpdate_O','xcMeetingFacade.batchUpdate','','2','0','int','','');
 	 p_soa_reg_Params('xcMeetingFacade.batchUpdate_I0','xcMeetingFacade.batchUpdate','','1','0','java.util.List','','');
 	 p_soa_reg_Params('xcMeetingFacade.batchUpdate_I1','xcMeetingFacade.batchUpdate','','1','1','java.lang.String[]','','');
 	 P_SOA_REG_Method('xcMeetingFacade.loadById','','loadById','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.loadById_O','xcMeetingFacade.loadById','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingFacade.loadById_I0','xcMeetingFacade.loadById','','1','0','java.lang.String','','');
 	 P_SOA_REG_Method('xcMeetingFacade.load','','load','xcMeetingFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingFacade.load_O','xcMeetingFacade.load','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingFacade.load_I0','xcMeetingFacade.load','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');

end;
/
commit;