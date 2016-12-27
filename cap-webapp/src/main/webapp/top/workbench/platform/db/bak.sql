prompt PL/SQL Developer import file
prompt Created on 2014年7月23日 by hudingbo
set feedback off
set define off
prompt Creating V_USER_FUNCCODE_PERMISSION...
create table V_USER_FUNCCODE_PERMISSION
(
  USER_ID   VARCHAR2(32),
  FUNC_CODE VARCHAR2(100)
)
;

prompt Creating WORKBENCH_PLATFORM...
create table WORKBENCH_PLATFORM
(
  PLATFORM_ID               VARCHAR2(32) not null,
  USER_ID                   VARCHAR2(32),
  PLATFORM_NAME             VARCHAR2(80),
  TEMPLATE_ID               VARCHAR2(32),
  PLATFORM_NUMBER           INTEGER,
  PLATFORM_LAST_MODIFY_TIME DATE,
  PLATFORM_CREATE_TIME      DATE
)
;
comment on table WORKBENCH_PLATFORM
  is '用于存储用户的工作台基本信息';
comment on column WORKBENCH_PLATFORM.PLATFORM_ID
  is '主键';
comment on column WORKBENCH_PLATFORM.USER_ID
  is '用户ID，记录当前登录的用户';
comment on column WORKBENCH_PLATFORM.PLATFORM_NAME
  is '工作台名称';
comment on column WORKBENCH_PLATFORM.TEMPLATE_ID
  is '记录该工作台是从哪个模板复制过来的数据';
comment on column WORKBENCH_PLATFORM.PLATFORM_NUMBER
  is '工作台序号(记录是第几个工作台，按照1,2,3,4递增)';
comment on column WORKBENCH_PLATFORM.PLATFORM_LAST_MODIFY_TIME
  is '最后修改时间';
comment on column WORKBENCH_PLATFORM.PLATFORM_CREATE_TIME
  is '微件创建时间';
alter table WORKBENCH_PLATFORM
  add constraint PK_WORKBENCH_PLATFORM primary key (PLATFORM_ID);

prompt Creating WORKBENCH_PLATFORM_PORTLET...
create table WORKBENCH_PLATFORM_PORTLET
(
  ID          VARCHAR2(32) not null,
  PLATFORM_ID VARCHAR2(32) not null,
  PORTLET_ID  VARCHAR2(32) not null,
  PT_ORDER    CHAR(1) not null,
  EDITABLE    CHAR(1),
  SELF_NAME   VARCHAR2(500),
  ADD_TIME    DATE
)
;
comment on table WORKBENCH_PLATFORM_PORTLET
  is '用户记录每一个用户工作台详细对应了哪些portlet、每个portlet的位置、顺序等';
comment on column WORKBENCH_PLATFORM_PORTLET.ID
  is '主键';
comment on column WORKBENCH_PLATFORM_PORTLET.PLATFORM_ID
  is '关联pub_user_paltform表的某一条主键记录';
comment on column WORKBENCH_PLATFORM_PORTLET.PORTLET_ID
  is '关联微件表的某一条主键记录';
comment on column WORKBENCH_PLATFORM_PORTLET.PT_ORDER
  is '按照（1、2,、3、4...递增）';
comment on column WORKBENCH_PLATFORM_PORTLET.EDITABLE
  is '首页第一个工作台默认的portlet是不可编辑的，自己添加的可以编辑';
comment on column WORKBENCH_PLATFORM_PORTLET.SELF_NAME
  is '自定义的微件名称';
comment on column WORKBENCH_PLATFORM_PORTLET.ADD_TIME
  is '添加该微件的时间';
alter table WORKBENCH_PLATFORM_PORTLET
  add constraint PK_WORKBENCH_PLATFORM_PORTLET primary key (ID);

prompt Creating WORKBENCH_PORTLET...
create table WORKBENCH_PORTLET
(
  PORTLET_ID          VARCHAR2(32) not null,
  PORTLET_NAME        VARCHAR2(200) not null,
  PORTLET_RIGHT_CODE  VARCHAR2(100) not null,
  PORTLET_URL         VARCHAR2(500),
  PORTLET_POSTION     CHAR(1),
  PORTLET_TAG         VARCHAR2(100) not null,
  PIC_ADDRESS         VARCHAR2(100),
  PORTLET_DESCRIBE    VARCHAR2(500),
  PORTLET_CREATE_TIME DATE not null,
  PORTLET_MOFIFY_TIME DATE
)
;
comment on table WORKBENCH_PORTLET
  is '用于存储各个业务系统的公共微件和私有微件';
comment on column WORKBENCH_PORTLET.PORTLET_ID
  is '主键';
comment on column WORKBENCH_PORTLET.PORTLET_NAME
  is '微件默认名称';
comment on column WORKBENCH_PORTLET.PORTLET_RIGHT_CODE
  is '微件连接到的具体页面的权限编码';
comment on column WORKBENCH_PORTLET.PORTLET_URL
  is '链接到的具体页面的URL';
comment on column WORKBENCH_PORTLET.PORTLET_POSTION
  is '0：左侧、1：右侧；标示了在添加微件时候能添加到哪里';
comment on column WORKBENCH_PORTLET.PORTLET_TAG
  is '微件所属的分类trag、用于在添加微件时候左侧分类';
comment on column WORKBENCH_PORTLET.PIC_ADDRESS
  is '图片地址';
comment on column WORKBENCH_PORTLET.PORTLET_DESCRIBE
  is '微件的描述';
comment on column WORKBENCH_PORTLET.PORTLET_CREATE_TIME
  is '微件创建时间';
comment on column WORKBENCH_PORTLET.PORTLET_MOFIFY_TIME
  is '最后修改微件的时间';
alter table WORKBENCH_PORTLET
  add constraint PK_WORKBENCH_PORTLET primary key (PORTLET_ID);

prompt Creating WORKBENCH_TEMPLATE...
create table WORKBENCH_TEMPLATE
(
  TEMPLATE_ID          VARCHAR2(32) not null,
  TEMPLATE_RIGHT_CODE  VARCHAR2(100),
  TMPLATE_NAME         VARCHAR2(150) not null,
  IS_SUPER_TEMPLATE    CHAR(1) not null,
  IS_DEFAULT           CHAR(1),
  TEMPLATE_DESCRIBE    VARCHAR2(500),
  TEMPLATE_CREATE_TIME DATE not null
)
;
comment on table WORKBENCH_TEMPLATE
  is '用于存储所有的工作台模板';
comment on column WORKBENCH_TEMPLATE.TEMPLATE_ID
  is '主键';
comment on column WORKBENCH_TEMPLATE.TEMPLATE_RIGHT_CODE
  is '对应4A的权限编码';
comment on column WORKBENCH_TEMPLATE.TMPLATE_NAME
  is '模板的名称,供用户选择从模板新建工作台的时候用';
comment on column WORKBENCH_TEMPLATE.IS_SUPER_TEMPLATE
  is '超级模板是供用户所属角色没有默认模板时候用的、系统唯一';
comment on column WORKBENCH_TEMPLATE.IS_DEFAULT
  is '是否是该角色的默认模板';
comment on column WORKBENCH_TEMPLATE.TEMPLATE_DESCRIBE
  is '模板的描述信息';
comment on column WORKBENCH_TEMPLATE.TEMPLATE_CREATE_TIME
  is '该模板的实际创建时间';
alter table WORKBENCH_TEMPLATE
  add constraint PK_WORKBENCH_TEMPLATE primary key (TEMPLATE_ID);

prompt Creating WORKBENCH_TEMPLATE_PORTEL...
create table WORKBENCH_TEMPLATE_PORTEL
(
  ID            VARCHAR2(32) not null,
  TEMPLATE_ID   VARCHAR2(32),
  PORTLET_ID    VARCHAR2(32),
  PORTLET_ORDER INTEGER
)
;
comment on table WORKBENCH_TEMPLATE_PORTEL
  is '记录每一个工作台模板的详细portlet项、包括总的布局顺序';
comment on column WORKBENCH_TEMPLATE_PORTEL.ID
  is '主键';
comment on column WORKBENCH_TEMPLATE_PORTEL.TEMPLATE_ID
  is '关联工作台模板表的主键';
comment on column WORKBENCH_TEMPLATE_PORTEL.PORTLET_ID
  is '关联微件表的某一个主键';
comment on column WORKBENCH_TEMPLATE_PORTEL.PORTLET_ORDER
  is '顺序按照1,2,3,4递增';
alter table WORKBENCH_TEMPLATE_PORTEL
  add constraint PK_WORKBENCH_TEMPLATE_PORTEL primary key (ID);

prompt Loading V_USER_FUNCCODE_PERMISSION...
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('bobby', '001');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('bobby', '002');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('bobby', '003');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('bobby', '004');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('bobby', '005');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('bobby', '006');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('bobby', '007');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('bobby', '008');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('bobby', '009');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('hudingbo', '001');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('hudingbo', '002');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('hudingbo', '003');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('hudingbo', '004');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('hudingbo', '005');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('hudingbo', '006');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('hudingbo', '007');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('hudingbo', '008');
insert into V_USER_FUNCCODE_PERMISSION (USER_ID, FUNC_CODE)
values ('hudingbo', '009');
commit;
prompt 18 records loaded
prompt Loading WORKBENCH_PLATFORM...
insert into WORKBENCH_PLATFORM (PLATFORM_ID, USER_ID, PLATFORM_NAME, TEMPLATE_ID, PLATFORM_NUMBER, PLATFORM_LAST_MODIFY_TIME, PLATFORM_CREATE_TIME)
values ('2652E7D8198947B3844725AE4AA8347A', 'bobby', '复制的工作台、测试名称', '02', 1, to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WORKBENCH_PLATFORM (PLATFORM_ID, USER_ID, PLATFORM_NAME, TEMPLATE_ID, PLATFORM_NUMBER, PLATFORM_LAST_MODIFY_TIME, PLATFORM_CREATE_TIME)
values ('B2AE8F144595434FA5D16445106B5DF5', 'bobby', '复制的工作台、测试名称', '01', 2, to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WORKBENCH_PLATFORM (PLATFORM_ID, USER_ID, PLATFORM_NAME, TEMPLATE_ID, PLATFORM_NUMBER, PLATFORM_LAST_MODIFY_TIME, PLATFORM_CREATE_TIME)
values ('pl001', 'hudingbo', '第一工作台', '001', 1, to_date('22-07-2014', 'dd-mm-yyyy'), to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM (PLATFORM_ID, USER_ID, PLATFORM_NAME, TEMPLATE_ID, PLATFORM_NUMBER, PLATFORM_LAST_MODIFY_TIME, PLATFORM_CREATE_TIME)
values ('pl002', 'hudingbo', '第二工作台', '002', 2, to_date('22-07-2014', 'dd-mm-yyyy'), to_date('22-07-2014', 'dd-mm-yyyy'));
commit;
prompt 4 records loaded
prompt Loading WORKBENCH_PLATFORM_PORTLET...
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('01', 'pl001', '01', '1', '0', '微件名1', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('02', 'pl001', '02', '2', '1', '微件名2', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('03', 'pl001', '03', '1', '0', '微件名3', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('04', 'pl001', '04', '2', '1', '微件名4', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('05', 'pl002', '01', '2', '1', '微件名5', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('06', 'pl002', '02', '1', '1', '微件名6', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('07', 'pl002', '03', '2', '1', '微件名7', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('08', 'pl002', '04', '1', '1', '微件名8', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('25501F6BBC884E2FB7057C8A68F213E8', '2652E7D8198947B3844725AE4AA8347A', '01', '1', '0', null, to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('85585D0A43B44552A5E7DC5A36CE7160', '2652E7D8198947B3844725AE4AA8347A', '02', '2', '0', null, to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('47C8AFD7E526471A8740F3CAFD52F91C', '2652E7D8198947B3844725AE4AA8347A', '03', '1', '0', null, to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('658A836CA98E401396245581ED5C10B0', '2652E7D8198947B3844725AE4AA8347A', '04', '2', '0', null, to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('D662CF3D02BB4F878FD3B0A460BFFF31', 'B2AE8F144595434FA5D16445106B5DF5', '01', '1', '0', null, to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('26B7D4B23C9540FD8B40151A742C3C56', 'B2AE8F144595434FA5D16445106B5DF5', '02', '2', '0', null, to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('D5ECC0C3A347468287274D76289BC90B', 'B2AE8F144595434FA5D16445106B5DF5', '03', '1', '0', null, to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('6600B4DFC9514ED3A4030C1A66071B76', 'B2AE8F144595434FA5D16445106B5DF5', '04', '2', '0', null, to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'));
commit;
prompt 16 records loaded
prompt Loading WORKBENCH_PORTLET...
insert into WORKBENCH_PORTLET (PORTLET_ID, PORTLET_NAME, PORTLET_RIGHT_CODE, PORTLET_URL, PORTLET_POSTION, PORTLET_TAG, PIC_ADDRESS, PORTLET_DESCRIBE, PORTLET_CREATE_TIME, PORTLET_MOFIFY_TIME)
values ('01', '我的微件1', '002', 'test.html', '0', '分类1', 'abc.png', '这是一个由开发组开发出来的微件、该微件可以供所有的有权限使用的人员随意拖拽使用！', to_date('21-07-2014', 'dd-mm-yyyy'), to_date('21-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PORTLET (PORTLET_ID, PORTLET_NAME, PORTLET_RIGHT_CODE, PORTLET_URL, PORTLET_POSTION, PORTLET_TAG, PIC_ADDRESS, PORTLET_DESCRIBE, PORTLET_CREATE_TIME, PORTLET_MOFIFY_TIME)
values ('02', '我的微件2', '001', 'test.html', '0', '分类1', 'abc.png', '这是一个由开发组开发出来的微件、该微件可以供所有的有权限使用的人员随意拖拽使用！', to_date('21-07-2014', 'dd-mm-yyyy'), to_date('21-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PORTLET (PORTLET_ID, PORTLET_NAME, PORTLET_RIGHT_CODE, PORTLET_URL, PORTLET_POSTION, PORTLET_TAG, PIC_ADDRESS, PORTLET_DESCRIBE, PORTLET_CREATE_TIME, PORTLET_MOFIFY_TIME)
values ('03', '我的微件3', '002', 'test.html', '1', '分类2', 'abc.png', '这是一个由开发组开发出来的微件、该微件可以供所有的有权限使用的人员随意拖拽使用！', to_date('21-07-2014', 'dd-mm-yyyy'), to_date('21-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PORTLET (PORTLET_ID, PORTLET_NAME, PORTLET_RIGHT_CODE, PORTLET_URL, PORTLET_POSTION, PORTLET_TAG, PIC_ADDRESS, PORTLET_DESCRIBE, PORTLET_CREATE_TIME, PORTLET_MOFIFY_TIME)
values ('04', '我的微件4', '001', 'test.html', '1', '分类2', 'abc.png', '这是一个由开发组开发出来的微件、该微件可以供所有的有权限使用的人员随意拖拽使用！', to_date('21-07-2014', 'dd-mm-yyyy'), to_date('21-07-2014', 'dd-mm-yyyy'));
commit;
prompt 4 records loaded
prompt Loading WORKBENCH_TEMPLATE...
insert into WORKBENCH_TEMPLATE (TEMPLATE_ID, TEMPLATE_RIGHT_CODE, TMPLATE_NAME, IS_SUPER_TEMPLATE, IS_DEFAULT, TEMPLATE_DESCRIBE, TEMPLATE_CREATE_TIME)
values ('01', '001', '工作台模板1', '0', '1', '工作台模板1基本描述I信息', to_date('21-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_TEMPLATE (TEMPLATE_ID, TEMPLATE_RIGHT_CODE, TMPLATE_NAME, IS_SUPER_TEMPLATE, IS_DEFAULT, TEMPLATE_DESCRIBE, TEMPLATE_CREATE_TIME)
values ('02', '002', '工作台模板2', '0', '1', '工作台模板1基本描述I信息', to_date('21-07-2014', 'dd-mm-yyyy'));
commit;
prompt 2 records loaded
prompt Loading WORKBENCH_TEMPLATE_PORTEL...
insert into WORKBENCH_TEMPLATE_PORTEL (ID, TEMPLATE_ID, PORTLET_ID, PORTLET_ORDER)
values ('01', '01', '01', 1);
insert into WORKBENCH_TEMPLATE_PORTEL (ID, TEMPLATE_ID, PORTLET_ID, PORTLET_ORDER)
values ('02', '01', '02', 2);
insert into WORKBENCH_TEMPLATE_PORTEL (ID, TEMPLATE_ID, PORTLET_ID, PORTLET_ORDER)
values ('03', '01', '03', 1);
insert into WORKBENCH_TEMPLATE_PORTEL (ID, TEMPLATE_ID, PORTLET_ID, PORTLET_ORDER)
values ('04', '01', '04', 2);
insert into WORKBENCH_TEMPLATE_PORTEL (ID, TEMPLATE_ID, PORTLET_ID, PORTLET_ORDER)
values ('05', '02', '01', 1);
insert into WORKBENCH_TEMPLATE_PORTEL (ID, TEMPLATE_ID, PORTLET_ID, PORTLET_ORDER)
values ('06', '02', '02', 2);
insert into WORKBENCH_TEMPLATE_PORTEL (ID, TEMPLATE_ID, PORTLET_ID, PORTLET_ORDER)
values ('07', '02', '03', 1);
insert into WORKBENCH_TEMPLATE_PORTEL (ID, TEMPLATE_ID, PORTLET_ID, PORTLET_ORDER)
values ('08', '02', '04', 2);
commit;
prompt 8 records loaded
set feedback on
set define on
prompt Done.
