--΢����
SELECT * FROM WORKBENCH_PORTLET order by portlet_id asc  FOR UPDATE;

--ģ��
SELECT * FROM WORKBENCH_TEMPLATE FOR UPDATE;

--ģ���΢����ϵ
SELECT * FROM Workbench_Template_Portel FOR UPDATE;



select rt.*  from V_USER_FUNCCODE_PERMISSION rt for update 

--˽�й���̨��
select pf.* from workbench_platform pf  where pf.user_id='SuperAdmin' order by pf.platform_number asc 

--˽�й���̨��΢����ϵ
select * from workbench_platform_portlet for update;



select *
  from workbench_platform_portlet
   for update

/*��ѯĳ������̨id��Ӧ���������Ҳ�����е�portlet��Ȩ�޹��ˡ�λ������*/
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

   
 --Ȩ�޲�ѯ
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
         
--��ѯ��½�û���sql   
select e.EMPLOYEE_NAME,e.ACCOUNT,u.USER_ID,e.ISLOCK,e.LOCK_PASSWORD,e.STATE,e.rowId from TOP_EMPLOYEE e ,TOP_user u where e.employee_id = u.employee_id