begin 
	 update TOP_PER_FUNC set FUNC_NAME='树形模板列表页面',FUNC_CODE='carstorage_treeStorageListPage',FUNC_TAG='',PARENT_FUNC_ID='1EB6F0B5F1694DBF8436281812055A42',PARENT_FUNC_TYPE='',SORT_NO='0',FUNC_NODE_TYPE='4',FUNC_URL='/carstorage/treeStorageListPage.ac',STATUS='1',PERMISSION_TYPE='2',MODULE_CODE='',DESCR='',MENU_ICON_URL='',APP_SHOW='0',MENU_FULL_NAME='',MENU_ID_FULL_PATH='',CREATOR_ID='',CREATE_TIME='',MODIFIER_ID='',UPDATE_TIME='',FUNC_UPD_URL='',HELP_DOCUMENT_URL='' where FUNC_ID = 'b73abb886d404e0a99446c6245b9bb0f'; 
	UPDATE top_per_func a
		SET a.MENU_FULL_NAME = 
		 
				(SELECT b.MENU_FULL_NAME||'\'||'树形模板列表页面'
                  FROM top_per_func b 
                  WHERE b.func_id = a.parent_func_id)
			 
		WHERE a.func_id = 'b73abb886d404e0a99446c6245b9bb0f'; 
	UPDATE top_per_func a 
		SET a.menu_full_name = (
			select b.name_path from (
				SELECT a.func_id, (SELECT menu_full_name FROM top_per_func WHERE func_id = 'b73abb886d404e0a99446c6245b9bb0f')||sys_connect_by_path(func_name,'\') name_path
				FROM top_per_func a 
				START WITH a.parent_func_id = 'b73abb886d404e0a99446c6245b9bb0f'
				CONNECT BY PRIOR a.func_id = a.parent_func_id
			) b where a.func_id = b.func_id )
		where a.func_id in 
			(select func_id from top_per_func start with parent_func_id = 'b73abb886d404e0a99446c6245b9bb0f' connect by prior func_id = parent_func_id); 
end; 
/ 
commit; 