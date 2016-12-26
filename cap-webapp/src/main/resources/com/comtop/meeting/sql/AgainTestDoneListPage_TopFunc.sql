begin 
	 update TOP_PER_FUNC set FUNC_NAME='测试工作流已办页面',FUNC_CODE='meeting_againTestDoneListPage',FUNC_TAG='',PARENT_FUNC_ID='1D324F877A8C496F97FB0B25BC430698',PARENT_FUNC_TYPE='',SORT_NO='0',FUNC_NODE_TYPE='4',FUNC_URL='/meeting/againTestDoneListPage.ac',STATUS='1',PERMISSION_TYPE='2',MODULE_CODE='',DESCR='',MENU_ICON_URL='',APP_SHOW='0',MENU_FULL_NAME='',MENU_ID_FULL_PATH='',CREATOR_ID='',CREATE_TIME='',MODIFIER_ID='',UPDATE_TIME='',FUNC_UPD_URL='',HELP_DOCUMENT_URL='' where FUNC_ID = '27da755ff49e4f0e9bb7f883ea92fc57'; 
	UPDATE top_per_func a
		SET a.MENU_FULL_NAME = 
		 
				(SELECT b.MENU_FULL_NAME||'\'||'测试工作流已办页面'
                  FROM top_per_func b 
                  WHERE b.func_id = a.parent_func_id)
			 
		WHERE a.func_id = '27da755ff49e4f0e9bb7f883ea92fc57'; 
	UPDATE top_per_func a 
		SET a.menu_full_name = (
			select b.name_path from (
				SELECT a.func_id, (SELECT menu_full_name FROM top_per_func WHERE func_id = '27da755ff49e4f0e9bb7f883ea92fc57')||sys_connect_by_path(func_name,'\') name_path
				FROM top_per_func a 
				START WITH a.parent_func_id = '27da755ff49e4f0e9bb7f883ea92fc57'
				CONNECT BY PRIOR a.func_id = a.parent_func_id
			) b where a.func_id = b.func_id )
		where a.func_id in 
			(select func_id from top_per_func start with parent_func_id = '27da755ff49e4f0e9bb7f883ea92fc57' connect by prior func_id = parent_func_id); 
end; 
/ 
commit; 