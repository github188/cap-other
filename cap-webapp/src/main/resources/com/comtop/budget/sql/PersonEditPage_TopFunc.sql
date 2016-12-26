begin 
	 DELETE FROM TOP_PER_FUNC WHERE FUNC_ID = '785211DF1FA94423AACA659FF5C9A15E'; 
	 INSERT INTO TOP_PER_FUNC (FUNC_ID,FUNC_NAME,FUNC_CODE,FUNC_TAG,PARENT_FUNC_ID,PARENT_FUNC_TYPE,SORT_NO,FUNC_NODE_TYPE,FUNC_URL,STATUS,PERMISSION_TYPE,MODULE_CODE,DESCR,MENU_ICON_URL,APP_SHOW,MENU_FULL_NAME,MENU_ID_FULL_PATH,CREATOR_ID,CREATE_TIME,MODIFIER_ID,UPDATE_TIME,FUNC_UPD_URL,HELP_DOCUMENT_URL) VALUES ('785211DF1FA94423AACA659FF5C9A15E','员工信息编辑页面','budget_personEditPage','','8A8B5C3950DA4219BBEEBEC648BFF52B','','9','4','/budget/personEditPage.ac','1','2','','','','0','','','','','','','',''); 
	UPDATE top_per_func a
		SET menu_id_full_path = 
		 
				(SELECT b.menu_id_full_path||'/785211DF1FA94423AACA659FF5C9A15E'
		         FROM top_per_func b 
		         WHERE b.func_id = a.parent_func_id)
			 
		WHERE func_id = '785211DF1FA94423AACA659FF5C9A15E'; 
	UPDATE top_per_func a
		SET a.MENU_FULL_NAME = 
		 
				(SELECT b.MENU_FULL_NAME||'\'||'员工信息编辑页面'
                  FROM top_per_func b 
                  WHERE b.func_id = a.parent_func_id)
			 
		WHERE a.func_id = '785211DF1FA94423AACA659FF5C9A15E'; 
	 update TOP_PER_FUNC set FUNC_NAME='员工信息编辑页面',FUNC_CODE='budget_personEditPage',FUNC_TAG='',PARENT_FUNC_ID='8A8B5C3950DA4219BBEEBEC648BFF52B',PARENT_FUNC_TYPE='',SORT_NO='0',FUNC_NODE_TYPE='4',FUNC_URL='/budget/personEditPage.ac',STATUS='1',PERMISSION_TYPE='2',MODULE_CODE='',DESCR='',MENU_ICON_URL='',APP_SHOW='0',MENU_FULL_NAME='',MENU_ID_FULL_PATH='',CREATOR_ID='',CREATE_TIME='',MODIFIER_ID='',UPDATE_TIME='',FUNC_UPD_URL='',HELP_DOCUMENT_URL='' where FUNC_ID = '39421a28813241809b4ad267f57075c3'; 
	UPDATE top_per_func a
		SET a.MENU_FULL_NAME = 
		 
				(SELECT b.MENU_FULL_NAME||'\'||'员工信息编辑页面'
                  FROM top_per_func b 
                  WHERE b.func_id = a.parent_func_id)
			 
		WHERE a.func_id = '39421a28813241809b4ad267f57075c3'; 
	UPDATE top_per_func a 
		SET a.menu_full_name = (
			select b.name_path from (
				SELECT a.func_id, (SELECT menu_full_name FROM top_per_func WHERE func_id = '39421a28813241809b4ad267f57075c3')||sys_connect_by_path(func_name,'\') name_path
				FROM top_per_func a 
				START WITH a.parent_func_id = '39421a28813241809b4ad267f57075c3'
				CONNECT BY PRIOR a.func_id = a.parent_func_id
			) b where a.func_id = b.func_id )
		where a.func_id in 
			(select func_id from top_per_func start with parent_func_id = '39421a28813241809b4ad267f57075c3' connect by prior func_id = parent_func_id); 
end; 
/ 
commit; 