begin
	 --开始注册实体SOA扩展参数信息
	P_CAP_INSERT_SOA_PARAM_EXT('xcMeetingroom','com.comtop.meeting',1);
	--开始注册实体SOA服务信息
 	 P_SOA_REG_SERVICE('xcMeetingroomFacade','','soa','com.comtop.cap.runtime.spring.SoaBeanBuilder4Cap','com.comtop.meeting.facade.XcMeetingroomFacade(*)','com.comtop.meeting.facade.XcMeetingroomFacade');
 	 P_SOA_REG_Method('xcMeetingroomFacade.batchReassign','','batchReassign','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.batchReassign_I0','xcMeetingroomFacade.batchReassign','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.back','','back','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.back_I0','xcMeetingroomFacade.back','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowParam','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryExtendAttrOfFirstNode','','queryExtendAttrOfFirstNode','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryExtendAttrOfFirstNode_O','xcMeetingroomFacade.queryExtendAttrOfFirstNode','','2','0','java.util.Map','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryExtendAttrOfFirstNode_I0','xcMeetingroomFacade.queryExtendAttrOfFirstNode','','1','0','java.lang.String','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryEntryVOList','','queryEntryVOList','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryEntryVOList_O','xcMeetingroomFacade.queryEntryVOList','','2','0','java.util.List','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryEntryVOList_I0','xcMeetingroomFacade.queryEntryVOList','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.batchBack','','batchBack','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.batchBack_I0','xcMeetingroomFacade.batchBack','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.testSQL','','testSQL','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.testSQL_O','xcMeetingroomFacade.testSQL','','2','0','com.comtop.meeting.model.XcMeetingroomVO','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.testSQL_I0','xcMeetingroomFacade.testSQL','','1','0','java.lang.String','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryExtendAttrByTaskId','','queryExtendAttrByTaskId','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryExtendAttrByTaskId_O','xcMeetingroomFacade.queryExtendAttrByTaskId','','2','0','java.util.Map','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryExtendAttrByTaskId_I0','xcMeetingroomFacade.queryExtendAttrByTaskId','','1','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryExtendAttrByTaskId_I1','xcMeetingroomFacade.queryExtendAttrByTaskId','','1','1','java.lang.String','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.update','','update','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.update_O','xcMeetingroomFacade.update','','2','0','boolean','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.update_I0','xcMeetingroomFacade.update','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.deleteList','','deleteList','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.deleteList_O','xcMeetingroomFacade.deleteList','','2','0','boolean','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.deleteList_I0','xcMeetingroomFacade.deleteList','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.fore','','fore','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.fore_I0','xcMeetingroomFacade.fore','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowParam','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.updateCascadeVO','','updateCascadeVO','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.updateCascadeVO_O','xcMeetingroomFacade.updateCascadeVO','','2','0','boolean','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.updateCascadeVO_I0','xcMeetingroomFacade.updateCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.updateCascadeVO_I1','xcMeetingroomFacade.updateCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryToEntryVOList','','queryToEntryVOList','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryToEntryVOList_O','xcMeetingroomFacade.queryToEntryVOList','','2','0','java.util.List','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryToEntryVOList_I0','xcMeetingroomFacade.queryToEntryVOList','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryBackTransNodes','','queryBackTransNodes','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryBackTransNodes_O','xcMeetingroomFacade.queryBackTransNodes','','2','0','com.comtop.bpms.common.model.NodeInfo[]','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryBackTransNodes_I0','xcMeetingroomFacade.queryBackTransNodes','','1','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryBackTransNodes_I1','xcMeetingroomFacade.queryBackTransNodes','','1','1','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryBackTransNodes_I2','xcMeetingroomFacade.queryBackTransNodes','','1','2','java.lang.String','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.batchUpdate','','batchUpdate','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.batchUpdate_O','xcMeetingroomFacade.batchUpdate','','2','0','int','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.batchUpdate_I0','xcMeetingroomFacade.batchUpdate','','1','0','java.util.List','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.batchUpdate_I1','xcMeetingroomFacade.batchUpdate','','1','1','java.lang.String[]','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryVOCount','','queryVOCount','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryVOCount_O','xcMeetingroomFacade.queryVOCount','','2','0','int','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryVOCount_I0','xcMeetingroomFacade.queryVOCount','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryDoneVOListByPage','','queryDoneVOListByPage','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryDoneVOListByPage_O','xcMeetingroomFacade.queryDoneVOListByPage','','2','0','java.util.Map','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryDoneVOListByPage_I0','xcMeetingroomFacade.queryDoneVOListByPage','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryExtendAttrByNodeId','','queryExtendAttrByNodeId','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryExtendAttrByNodeId_O','xcMeetingroomFacade.queryExtendAttrByNodeId','','2','0','java.util.Map','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryExtendAttrByNodeId_I0','xcMeetingroomFacade.queryExtendAttrByNodeId','','1','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryExtendAttrByNodeId_I1','xcMeetingroomFacade.queryExtendAttrByNodeId','','1','1','java.lang.String','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryIntersecHumanNodesByUserIds','','queryIntersecHumanNodesByUserIds','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryIntersecHumanNodesByUserIds_O','xcMeetingroomFacade.queryIntersecHumanNodesByUserIds','','2','0','java.util.List','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryIntersecHumanNodesByUserIds_I0','xcMeetingroomFacade.queryIntersecHumanNodesByUserIds','','1','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryIntersecHumanNodesByUserIds_I1','xcMeetingroomFacade.queryIntersecHumanNodesByUserIds','','1','1','java.lang.String','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.test','','test','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.test_O','xcMeetingroomFacade.test','','2','0','java.lang.String','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryTodoVOListByPage','','queryTodoVOListByPage','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryTodoVOListByPage_O','xcMeetingroomFacade.queryTodoVOListByPage','','2','0','java.util.Map','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryTodoVOListByPage_I0','xcMeetingroomFacade.queryTodoVOListByPage','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.backEntry','','backEntry','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.backEntry_I0','xcMeetingroomFacade.backEntry','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowParam','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.hungup','','hungup','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.hungup_I0','xcMeetingroomFacade.hungup','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowParam','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.recover','','recover','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.recover_I0','xcMeetingroomFacade.recover','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowParam','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryObjectAndTaskVOById','','queryObjectAndTaskVOById','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryObjectAndTaskVOById_O','xcMeetingroomFacade.queryObjectAndTaskVOById','','2','0','com.comtop.cap.runtime.base.model.CapWorkflowVO','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryObjectAndTaskVOById_I0','xcMeetingroomFacade.queryObjectAndTaskVOById','','1','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryObjectAndTaskVOById_I1','xcMeetingroomFacade.queryObjectAndTaskVOById','','1','1','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryObjectAndTaskVOById_I2','xcMeetingroomFacade.queryObjectAndTaskVOById','','1','2','java.lang.String','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.saveNote','','saveNote','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.saveNote_O','xcMeetingroomFacade.saveNote','','2','0','boolean','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.saveNote_I0','xcMeetingroomFacade.saveNote','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowParam','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryUserListByNode','','queryUserListByNode','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryUserListByNode_O','xcMeetingroomFacade.queryUserListByNode','','2','0','com.comtop.bpms.common.model.UserInfo[]','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryUserListByNode_I0','xcMeetingroomFacade.queryUserListByNode','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowParam','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryUserListByNode_I1','xcMeetingroomFacade.queryUserListByNode','','1','1','int','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryUserListByNode_I2','xcMeetingroomFacade.queryUserListByNode','','1','2','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryUserListByNode_I3','xcMeetingroomFacade.queryUserListByNode','','1','3','java.lang.String','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.jump','','jump','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.jump_O','xcMeetingroomFacade.jump','','2','0','com.comtop.bpms.common.model.ProcessInstanceInfo','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.jump_I0','xcMeetingroomFacade.jump','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowParam','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.undo','','undo','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.undo_I0','xcMeetingroomFacade.undo','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowParam','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.deleteCascadeVO','','deleteCascadeVO','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.deleteCascadeVO_O','xcMeetingroomFacade.deleteCascadeVO','','2','0','boolean','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.deleteCascadeVO_I0','xcMeetingroomFacade.deleteCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.deleteCascadeVO_I1','xcMeetingroomFacade.deleteCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.saveCascadeVO','','saveCascadeVO','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.saveCascadeVO_O','xcMeetingroomFacade.saveCascadeVO','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.saveCascadeVO_I0','xcMeetingroomFacade.saveCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.saveCascadeVO_I1','xcMeetingroomFacade.saveCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryForeTransNodes','','queryForeTransNodes','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryForeTransNodes_O','xcMeetingroomFacade.queryForeTransNodes','','2','0','com.comtop.bpms.common.model.NodeInfo[]','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryForeTransNodes_I0','xcMeetingroomFacade.queryForeTransNodes','','1','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryForeTransNodes_I1','xcMeetingroomFacade.queryForeTransNodes','','1','1','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryForeTransNodes_I2','xcMeetingroomFacade.queryForeTransNodes','','1','2','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryForeTransNodes_I3','xcMeetingroomFacade.queryForeTransNodes','','1','3','java.util.Map','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.reassign','','reassign','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.reassign_I0','xcMeetingroomFacade.reassign','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowParam','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryEntryVOCount','','queryEntryVOCount','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryEntryVOCount_O','xcMeetingroomFacade.queryEntryVOCount','','2','0','int','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryEntryVOCount_I0','xcMeetingroomFacade.queryEntryVOCount','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryTodoVOCount','','queryTodoVOCount','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryTodoVOCount_O','xcMeetingroomFacade.queryTodoVOCount','','2','0','int','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryTodoVOCount_I0','xcMeetingroomFacade.queryTodoVOCount','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryVOListByPage','','queryVOListByPage','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryVOListByPage_O','xcMeetingroomFacade.queryVOListByPage','','2','0','java.util.Map','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryVOListByPage_I0','xcMeetingroomFacade.queryVOListByPage','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.insert','','insert','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.insert_O','xcMeetingroomFacade.insert','','2','0','int','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.insert_I0','xcMeetingroomFacade.insert','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryProcessInsTransTrack','','queryProcessInsTransTrack','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryProcessInsTransTrack_O','xcMeetingroomFacade.queryProcessInsTransTrack','','2','0','com.comtop.bpms.common.model.NodeTrackInfo[]','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryProcessInsTransTrack_I0','xcMeetingroomFacade.queryProcessInsTransTrack','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowParam','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.testJL','','testJL','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.testJL_O','xcMeetingroomFacade.testJL','','2','0','com.comtop.meeting.model.XcMeetingroomVO','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.testJL_I0','xcMeetingroomFacade.testJL','','1','0','java.lang.String','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryVOList','','queryVOList','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryVOList_O','xcMeetingroomFacade.queryVOList','','2','0','java.util.List','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryVOList_I0','xcMeetingroomFacade.queryVOList','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryNewTaskId','','queryNewTaskId','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryNewTaskId_O','xcMeetingroomFacade.queryNewTaskId','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryNewTaskId_I0','xcMeetingroomFacade.queryNewTaskId','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowParam','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryNewTaskId_I1','xcMeetingroomFacade.queryNewTaskId','','1','1','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryNewTaskId_I2','xcMeetingroomFacade.queryNewTaskId','','1','2','java.lang.String','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.abort','','abort','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.abort_I0','xcMeetingroomFacade.abort','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowParam','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryEntryVOListByPage','','queryEntryVOListByPage','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryEntryVOListByPage_O','xcMeetingroomFacade.queryEntryVOListByPage','','2','0','java.util.Map','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryEntryVOListByPage_I0','xcMeetingroomFacade.queryEntryVOListByPage','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryToEntryVOCount','','queryToEntryVOCount','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryToEntryVOCount_O','xcMeetingroomFacade.queryToEntryVOCount','','2','0','int','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryToEntryVOCount_I0','xcMeetingroomFacade.queryToEntryVOCount','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.delete','','delete','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.delete_O','xcMeetingroomFacade.delete','','2','0','boolean','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.delete_I0','xcMeetingroomFacade.delete','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.loadById','','loadById','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.loadById_O','xcMeetingroomFacade.loadById','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.loadById_I0','xcMeetingroomFacade.loadById','','1','0','java.lang.String','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryDoneVOCount','','queryDoneVOCount','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryDoneVOCount_O','xcMeetingroomFacade.queryDoneVOCount','','2','0','int','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryDoneVOCount_I0','xcMeetingroomFacade.queryDoneVOCount','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.deleteCascadeList','','deleteCascadeList','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.deleteCascadeList_O','xcMeetingroomFacade.deleteCascadeList','','2','0','boolean','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.deleteCascadeList_I0','xcMeetingroomFacade.deleteCascadeList','','1','0','java.util.List','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.deleteCascadeList_I1','xcMeetingroomFacade.deleteCascadeList','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryHumanNodesByProcessId','','queryHumanNodesByProcessId','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryHumanNodesByProcessId_O','xcMeetingroomFacade.queryHumanNodesByProcessId','','2','0','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryDoneVOList','','queryDoneVOList','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryDoneVOList_O','xcMeetingroomFacade.queryDoneVOList','','2','0','java.util.List','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryDoneVOList_I0','xcMeetingroomFacade.queryDoneVOList','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.getDeptFilerParam','','getDeptFilerParam','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.getDeptFilerParam_O','xcMeetingroomFacade.getDeptFilerParam','','2','0','com.comtop.bpms.common.model.UserInfo','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.getDeptFilerParam_I0','xcMeetingroomFacade.getDeptFilerParam','','1','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.getDeptFilerParam_I1','xcMeetingroomFacade.getDeptFilerParam','','1','1','java.lang.String','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.batchEntry','','batchEntry','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.batchEntry_I0','xcMeetingroomFacade.batchEntry','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.insertCascadeVO','','insertCascadeVO','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.insertCascadeVO_O','xcMeetingroomFacade.insertCascadeVO','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.insertCascadeVO_I0','xcMeetingroomFacade.insertCascadeVO','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.insertCascadeVO_I1','xcMeetingroomFacade.insertCascadeVO','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryVOListByCondition','','queryVOListByCondition','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryVOListByCondition_O','xcMeetingroomFacade.queryVOListByCondition','','2','0','java.util.List','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryVOListByCondition_I0','xcMeetingroomFacade.queryVOListByCondition','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.batchFore','','batchFore','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.batchFore_I0','xcMeetingroomFacade.batchFore','','1','0','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.save','','save','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.save_O','xcMeetingroomFacade.save','','2','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.save_I0','xcMeetingroomFacade.save','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryToEntryVOListByPage','','queryToEntryVOListByPage','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryToEntryVOListByPage_O','xcMeetingroomFacade.queryToEntryVOListByPage','','2','0','java.util.Map','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryToEntryVOListByPage_I0','xcMeetingroomFacade.queryToEntryVOListByPage','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.getAppService','','getAppService','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.getAppService_O','xcMeetingroomFacade.getAppService','','2','0','com.comtop.meeting.appservice.XcMeetingroomAppService','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.loadCascadeById','','loadCascadeById','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.loadCascadeById_O','xcMeetingroomFacade.loadCascadeById','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.loadCascadeById_I0','xcMeetingroomFacade.loadCascadeById','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.loadCascadeById_I1','xcMeetingroomFacade.loadCascadeById','','1','1','java.util.List','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryTodoVOList','','queryTodoVOList','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryTodoVOList_O','xcMeetingroomFacade.queryTodoVOList','','2','0','java.util.List','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryTodoVOList_I0','xcMeetingroomFacade.queryTodoVOList','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.overFlow','','overFlow','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.overFlow_O','xcMeetingroomFacade.overFlow','','2','0','com.comtop.bpms.common.model.ProcessInstanceInfo','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.overFlow_I0','xcMeetingroomFacade.overFlow','','1','0','com.comtop.cap.runtime.base.model.CapWorkflowParam','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.load','','load','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.load_O','xcMeetingroomFacade.load','','2','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.load_I0','xcMeetingroomFacade.load','','1','0','com.comtop.cap.runtime.base.model.CapBaseVO','','');
 	 P_SOA_REG_Method('xcMeetingroomFacade.queryReassignTransNodes','','queryReassignTransNodes','xcMeetingroomFacade','0','0','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryReassignTransNodes_O','xcMeetingroomFacade.queryReassignTransNodes','','2','0','com.comtop.bpms.common.model.NodeInfo[]','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryReassignTransNodes_I0','xcMeetingroomFacade.queryReassignTransNodes','','1','0','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryReassignTransNodes_I1','xcMeetingroomFacade.queryReassignTransNodes','','1','1','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryReassignTransNodes_I2','xcMeetingroomFacade.queryReassignTransNodes','','1','2','java.lang.String','','');
 	 p_soa_reg_Params('xcMeetingroomFacade.queryReassignTransNodes_I3','xcMeetingroomFacade.queryReassignTransNodes','','1','3','java.util.Map','','');

end;
/
commit;