--微件表
SELECT * FROM WORKBENCH_PORTLET order by portlet_id asc  FOR UPDATE;

--模板
SELECT * FROM WORKBENCH_TEMPLATE FOR UPDATE;

--模板和微件关系
SELECT * FROM Workbench_Template_Portel FOR UPDATE;



select rt.*  from V_USER_FUNCCODE_PERMISSION rt for update 

--私有工作台表
select pf.* from workbench_platform pf  where pf.user_id='SuperAdmin' order by pf.platform_number asc 

--私有工作台和微件关系
select * from workbench_platform_portlet for update;



select *
  from workbench_platform_portlet
   for update

/*查询某个工作台id对应的左侧或者右侧的所有的portlet、权限过滤、位置排序*/
select p.portlet_id,
       p.portlet_name,
       r.self_name,
       r.pt_order,
       p.portlet_url,
       p.pic_address,
       p.portlet_postion,
       p.portlet_tag,
       r.editable
  from workbench_platform            pl,
       workbench_portlet             p,
       workbench_platform_portlet    r,
       V_USER_FUNCCODE_PERMISSION rc
 where pl.platform_id = r.platform_id
   and p.portlet_id = r.portlet_id
   and p.portlet_right_code = rc.func_code
   and pl.platform_id = 'pl001'
   and p.portlet_postion = '1'
   and rc.user_id = 'hudingbo'
 order by r.pt_order;

   
 --权限查询
 select rc.func_code  from V_USER_FUNCCODE_PERMISSION  rc where rc.user_id='SuperAdmin'
 
 select p.* from workbench_platform p where p.user_id='hudingbo'  order by p.platform_number

select count(*) cont from workbench_template t ,v_subject_pagecode_permission rt where t.template_right_code = rt.func_code  and t.is_default=1 and rt.user_id='bobby'
select * from workbench_template for update 

select rt.*  from V_USER_FUNCCODE_PERMISSION rt for update 



select t.*
  from workbench_template t, v_subject_pagecode_permission rt
 where t.is_super_template = '0'
   and t.is_default = '1'
   and rt.func_code = t.template_right_code
   and rt.user_id = 'bobby'
 order by t.template_create_time asc
 
 
 
select tp.*
  from workbench_template t, workbench_template_portel tp
 where t.template_id = '01'
   and t.template_id = tp.template_id
   
   
   
   select * from workbench_template;
   select * from workbench_platform for update;
   select * from workbench_platform_portlet for update
   
   
    select t.* from workbench_template t for update
   	select t.* from workbench_template t where t.is_super_template ='1'
    
    
    
    
    select p.*
      from workbench_portlet p, V_USER_FUNCCODE_PERMISSION rt
     where p.portlet_right_code = rt.func_code
       and rt.user_id = 'bobby'
       and p.portlet_id not in
           (select distinct pt.portlet_id
              from workbench_platform pf, workbench_platform_portlet pt
             where pf.user_id = rt.user_id
               and pf.platform_id = pt.platform_id
               and pf.platform_id = 'xx')
     order by p.portlet_create_time asc
     
     
    
    select t.portlet_tag, count(t.portlet_tag) count
      from (select p.portlet_tag
              from workbench_portlet p, V_USER_FUNCCODE_PERMISSION rt
             where p.portlet_right_code = rt.func_code
               and rt.user_id = 'bobby'
               and p.portlet_id not in
                   (select distinct pt.portlet_id
                      from workbench_platform         pf,
                           workbench_platform_portlet pt
                     where pf.user_id = rt.user_id
                       and pf.platform_id = pt.platform_id
                       and pf.platform_id = 'xx')
             order by p.portlet_create_time asc) t
     group by t.portlet_tag
         
--查询登陆用户的sql   
select e.EMPLOYEE_NAME,e.ACCOUNT,u.USER_ID,e.ISLOCK,e.LOCK_PASSWORD,e.STATE,e.rowId from TOP_EMPLOYEE e ,TOP_user u where e.employee_id = u.employee_id