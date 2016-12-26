begin 
	 update TOP_PER_FUNC set FUNC_NAME='用户管理编辑页面',FUNC_CODE='budget_userEditPageForWorkFlow',FUNC_TAG='',PARENT_FUNC_ID='8A8B5C3950DA4219BBEEBEC648BFF52B',PARENT_FUNC_TYPE='',SORT_NO='0',FUNC_NODE_TYPE='4',FUNC_URL='/budget/userEditPageForWorkFlow.ac',STATUS='1',PERMISSION_TYPE='2',MODULE_CODE='',DESCR='',MENU_ICON_URL='',APP_SHOW='0',MENU_FULL_NAME='',MENU_ID_FULL_PATH='',CREATOR_ID='',CREATE_TIME='',MODIFIER_ID='',UPDATE_TIME='',FUNC_UPD_URL='',HELP_DOCUMENT_URL='' where FUNC_ID = '250ce44ee00348dba5d5631a7e6bcd9a'; 
	UPDATE top_per_func a
		SET a.MENU_FULL_NAME = 
		 
				(SELECT b.MENU_FULL_NAME||'\'||'用户管理编辑页面'
                  FROM top_per_func b 
                  WHERE b.func_id = a.parent_func_id)
			 
		WHERE a.func_id = '250ce44ee00348dba5d5631a7e6bcd9a'; 
	UPDATE top_per_func a 
		SET a.menu_full_name = (
			select b.name_path from (
				SELECT a.func_id, (SELECT menu_full_name FROM top_per_func WHERE func_id = '250ce44ee00348dba5d5631a7e6bcd9a')||sys_connect_by_path(func_name,'\') name_path
				FROM top_per_func a 
				START WITH a.parent_func_id = '250ce44ee00348dba5d5631a7e6bcd9a'
				CONNECT BY PRIOR a.func_id = a.parent_func_id
			) b where a.func_id = b.func_id )
		where a.func_id in 
			(select func_id from top_per_func start with parent_func_id = '250ce44ee00348dba5d5631a7e6bcd9a' connect by prior func_id = parent_func_id); 
end; 
/ 
commit; 