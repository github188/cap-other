





--微件表
SELECT * FROM WORKBENCH_PORTLET  p  order by  p.portlet_create_time asc ,p.portlet_tag desc  


--模板管理，查询所有微件分类
  select t.portlet_tag, count(t.portlet_tag) count
    from (select p.portlet_tag
            from workbench_portlet p
           where p.portlet_id not in
                 (select distinct tpr.portlet_id
                    from workbench_template tp, workbench_template_portel tpr
                   where tp.template_id = tpr.template_id
                     and tp.template_id = 03)
           order by p.portlet_create_time asc) t
   group by t.portlet_tag
      
      

--查询微件
select p.*
  from workbench_portlet p
 WHERE (p.portlet_name LIKE '%个人%' escape
        '/' or p.portlet_describe LIKE '%个人%' escape '/')
   AND p.portletTag = '全部'
 order by p.is_common desc, p.portlet_create_time asc, p.portlet_tag desc
  
    --查询某个工作台对应的某侧的微件，根据序号排序
    select p.portlet_id,
           p.portlet_name,
           r.portlet_order,
           p.portlet_describe,
           p.pic_address,
           p.portlet_postion,
           p.portlet_tag
      from workbench_template        tp,
           workbench_portlet         p,
           workbench_template_portel r
     where tp.template_id = r.template_id
       and tp.template_id = 03
       and p.portlet_id = r.portlet_id
       and p.portlet_postion = 1
     order by r.portlet_order
 
 
 
--查询重名微件信息

--查询微件分类
select t.portlet_tag
  from (SELECT distinct (tmp.portlet_tag), tmp.is_common
          from WORKBENCH_PORTLET tmp
         order by tmp.IS_COMMON desc) t
--模板
SELECT * FROM WORKBENCH_TEMPLATE FOR UPDATE;
--模板和微件关系
SELECT * FROM Workbench_Template_Portel order by template_id desc ,portlet_id asc  FOR UPDATE;


--私有工作台表
select pf.* from workbench_platform pf  where pf.user_id='SuperAdmin' order by pf.platform_number asc 

--私有工作台和微件关系
select t.*
  from  workbench_platform_portlet t
 where t.platform_id in (select pf.platform_id
                           from workbench_platform pf
                          where pf.user_id = 'SuperAdmin')
--清空私有工作台
delete from workbench_platform pf where pf.user_id = 'SuperAdmin';
delete from workbench_platform_portlet t
 where t.platform_id in (select  pf.platform_id
                                  from workbench_platform pf
                                 where pf.user_id = 'SuperAdmin'
                         )
--管理员工作台微件
select p.portlet_id,
       p.portlet_name,
       r.self_name,
       r.pt_order,
       p.portlet_url,
       p.pic_address,
       p.portlet_postion,
       p.portlet_tag,
       r.editable
  from workbench_platform         pl,
       workbench_portlet          p,
       workbench_platform_portlet r
 where pl.platform_id = r.platform_id
   and p.portlet_id = r.portlet_id
   and p.portlet_postion = '1'
   and pl.platform_id = 'D58B01B3487B426AA050148AC1844A3B'
   and pl.user_id = 'SuperAdmin'
 order by r.pt_order


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
select e.EMPLOYEE_NAME,e.employee_password,u.USER_ID,e.ISLOCK,e.LOCK_PASSWORD,e.STATE,e.rowId from TOP_EMPLOYEE e ,TOP_user u where e.employee_id = u.employee_id