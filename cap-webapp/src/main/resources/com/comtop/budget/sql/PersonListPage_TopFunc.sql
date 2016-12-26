begin 
	 update TOP_PER_FUNC set FUNC_NAME='员工信息列表页面',FUNC_CODE='budget_personListPage',FUNC_TAG='',PARENT_FUNC_ID='8A8B5C3950DA4219BBEEBEC648BFF52B',PARENT_FUNC_TYPE='',SORT_NO='0',FUNC_NODE_TYPE='4',FUNC_URL='/budget/personListPage.ac',STATUS='1',PERMISSION_TYPE='2',MODULE_CODE='',DESCR='',MENU_ICON_URL='',APP_SHOW='0',MENU_FULL_NAME='',MENU_ID_FULL_PATH='',CREATOR_ID='',CREATE_TIME='',MODIFIER_ID='',UPDATE_TIME='',FUNC_UPD_URL='',HELP_DOCUMENT_URL='' where FUNC_ID = 'd3787eeeedc54a48aab065e99c6ffb6a'; 
	UPDATE top_per_func a
		SET a.MENU_FULL_NAME = 
		 
				(SELECT b.MENU_FULL_NAME||'\'||'员工信息列表页面'
                  FROM top_per_func b 
                  WHERE b.func_id = a.parent_func_id)
			 
		WHERE a.func_id = 'd3787eeeedc54a48aab065e99c6ffb6a'; 
	UPDATE top_per_func a 
		SET a.menu_full_name = (
			select b.name_path from (
				SELECT a.func_id, (SELECT menu_full_name FROM top_per_func WHERE func_id = 'd3787eeeedc54a48aab065e99c6ffb6a')||sys_connect_by_path(func_name,'\') name_path
				FROM top_per_func a 
				START WITH a.parent_func_id = 'd3787eeeedc54a48aab065e99c6ffb6a'
				CONNECT BY PRIOR a.func_id = a.parent_func_id
			) b where a.func_id = b.func_id )
		where a.func_id in 
			(select func_id from top_per_func start with parent_func_id = 'd3787eeeedc54a48aab065e99c6ffb6a' connect by prior func_id = parent_func_id); 
end; 
/ 
commit; 