prompt PL/SQL Developer import file
prompt Created on 2014��7��23�� by hudingbo
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
  is '���ڴ洢�û��Ĺ���̨������Ϣ';
comment on column WORKBENCH_PLATFORM.PLATFORM_ID
  is '����';
comment on column WORKBENCH_PLATFORM.USER_ID
  is '�û�ID����¼��ǰ��¼���û�';
comment on column WORKBENCH_PLATFORM.PLATFORM_NAME
  is '����̨����';
comment on column WORKBENCH_PLATFORM.TEMPLATE_ID
  is '��¼�ù���̨�Ǵ��ĸ�ģ�帴�ƹ���������';
comment on column WORKBENCH_PLATFORM.PLATFORM_NUMBER
  is '����̨���(��¼�ǵڼ�������̨������1,2,3,4����)';
comment on column WORKBENCH_PLATFORM.PLATFORM_LAST_MODIFY_TIME
  is '����޸�ʱ��';
comment on column WORKBENCH_PLATFORM.PLATFORM_CREATE_TIME
  is '΢������ʱ��';
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
  is '�û���¼ÿһ���û�����̨��ϸ��Ӧ����Щportlet��ÿ��portlet��λ�á�˳���';
comment on column WORKBENCH_PLATFORM_PORTLET.ID
  is '����';
comment on column WORKBENCH_PLATFORM_PORTLET.PLATFORM_ID
  is '����pub_user_paltform���ĳһ��������¼';
comment on column WORKBENCH_PLATFORM_PORTLET.PORTLET_ID
  is '����΢�����ĳһ��������¼';
comment on column WORKBENCH_PLATFORM_PORTLET.PT_ORDER
  is '���գ�1��2,��3��4...������';
comment on column WORKBENCH_PLATFORM_PORTLET.EDITABLE
  is '��ҳ��һ������̨Ĭ�ϵ�portlet�ǲ��ɱ༭�ģ��Լ���ӵĿ��Ա༭';
comment on column WORKBENCH_PLATFORM_PORTLET.SELF_NAME
  is '�Զ����΢������';
comment on column WORKBENCH_PLATFORM_PORTLET.ADD_TIME
  is '��Ӹ�΢����ʱ��';
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
  is '���ڴ洢����ҵ��ϵͳ�Ĺ���΢����˽��΢��';
comment on column WORKBENCH_PORTLET.PORTLET_ID
  is '����';
comment on column WORKBENCH_PORTLET.PORTLET_NAME
  is '΢��Ĭ������';
comment on column WORKBENCH_PORTLET.PORTLET_RIGHT_CODE
  is '΢�����ӵ��ľ���ҳ���Ȩ�ޱ���';
comment on column WORKBENCH_PORTLET.PORTLET_URL
  is '���ӵ��ľ���ҳ���URL';
comment on column WORKBENCH_PORTLET.PORTLET_POSTION
  is '0����ࡢ1���Ҳࣻ��ʾ�������΢��ʱ������ӵ�����';
comment on column WORKBENCH_PORTLET.PORTLET_TAG
  is '΢�������ķ���trag�����������΢��ʱ��������';
comment on column WORKBENCH_PORTLET.PIC_ADDRESS
  is 'ͼƬ��ַ';
comment on column WORKBENCH_PORTLET.PORTLET_DESCRIBE
  is '΢��������';
comment on column WORKBENCH_PORTLET.PORTLET_CREATE_TIME
  is '΢������ʱ��';
comment on column WORKBENCH_PORTLET.PORTLET_MOFIFY_TIME
  is '����޸�΢����ʱ��';
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
  is '���ڴ洢���еĹ���̨ģ��';
comment on column WORKBENCH_TEMPLATE.TEMPLATE_ID
  is '����';
comment on column WORKBENCH_TEMPLATE.TEMPLATE_RIGHT_CODE
  is '��Ӧ4A��Ȩ�ޱ���';
comment on column WORKBENCH_TEMPLATE.TMPLATE_NAME
  is 'ģ�������,���û�ѡ���ģ���½�����̨��ʱ����';
comment on column WORKBENCH_TEMPLATE.IS_SUPER_TEMPLATE
  is '����ģ���ǹ��û�������ɫû��Ĭ��ģ��ʱ���õġ�ϵͳΨһ';
comment on column WORKBENCH_TEMPLATE.IS_DEFAULT
  is '�Ƿ��Ǹý�ɫ��Ĭ��ģ��';
comment on column WORKBENCH_TEMPLATE.TEMPLATE_DESCRIBE
  is 'ģ���������Ϣ';
comment on column WORKBENCH_TEMPLATE.TEMPLATE_CREATE_TIME
  is '��ģ���ʵ�ʴ���ʱ��';
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
  is '��¼ÿһ������̨ģ�����ϸportlet������ܵĲ���˳��';
comment on column WORKBENCH_TEMPLATE_PORTEL.ID
  is '����';
comment on column WORKBENCH_TEMPLATE_PORTEL.TEMPLATE_ID
  is '��������̨ģ��������';
comment on column WORKBENCH_TEMPLATE_PORTEL.PORTLET_ID
  is '����΢�����ĳһ������';
comment on column WORKBENCH_TEMPLATE_PORTEL.PORTLET_ORDER
  is '˳����1,2,3,4����';
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
values ('2652E7D8198947B3844725AE4AA8347A', 'bobby', '���ƵĹ���̨����������', '02', 1, to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WORKBENCH_PLATFORM (PLATFORM_ID, USER_ID, PLATFORM_NAME, TEMPLATE_ID, PLATFORM_NUMBER, PLATFORM_LAST_MODIFY_TIME, PLATFORM_CREATE_TIME)
values ('B2AE8F144595434FA5D16445106B5DF5', 'bobby', '���ƵĹ���̨����������', '01', 2, to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-07-2014 10:53:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into WORKBENCH_PLATFORM (PLATFORM_ID, USER_ID, PLATFORM_NAME, TEMPLATE_ID, PLATFORM_NUMBER, PLATFORM_LAST_MODIFY_TIME, PLATFORM_CREATE_TIME)
values ('pl001', 'hudingbo', '��һ����̨', '001', 1, to_date('22-07-2014', 'dd-mm-yyyy'), to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM (PLATFORM_ID, USER_ID, PLATFORM_NAME, TEMPLATE_ID, PLATFORM_NUMBER, PLATFORM_LAST_MODIFY_TIME, PLATFORM_CREATE_TIME)
values ('pl002', 'hudingbo', '�ڶ�����̨', '002', 2, to_date('22-07-2014', 'dd-mm-yyyy'), to_date('22-07-2014', 'dd-mm-yyyy'));
commit;
prompt 4 records loaded
prompt Loading WORKBENCH_PLATFORM_PORTLET...
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('01', 'pl001', '01', '1', '0', '΢����1', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('02', 'pl001', '02', '2', '1', '΢����2', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('03', 'pl001', '03', '1', '0', '΢����3', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('04', 'pl001', '04', '2', '1', '΢����4', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('05', 'pl002', '01', '2', '1', '΢����5', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('06', 'pl002', '02', '1', '1', '΢����6', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('07', 'pl002', '03', '2', '1', '΢����7', to_date('22-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PLATFORM_PORTLET (ID, PLATFORM_ID, PORTLET_ID, PT_ORDER, EDITABLE, SELF_NAME, ADD_TIME)
values ('08', 'pl002', '04', '1', '1', '΢����8', to_date('22-07-2014', 'dd-mm-yyyy'));
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
values ('01', '�ҵ�΢��1', '002', 'test.html', '0', '����1', 'abc.png', '����һ���ɿ����鿪��������΢������΢�����Թ����е���Ȩ��ʹ�õ���Ա������קʹ�ã�', to_date('21-07-2014', 'dd-mm-yyyy'), to_date('21-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PORTLET (PORTLET_ID, PORTLET_NAME, PORTLET_RIGHT_CODE, PORTLET_URL, PORTLET_POSTION, PORTLET_TAG, PIC_ADDRESS, PORTLET_DESCRIBE, PORTLET_CREATE_TIME, PORTLET_MOFIFY_TIME)
values ('02', '�ҵ�΢��2', '001', 'test.html', '0', '����1', 'abc.png', '����һ���ɿ����鿪��������΢������΢�����Թ����е���Ȩ��ʹ�õ���Ա������קʹ�ã�', to_date('21-07-2014', 'dd-mm-yyyy'), to_date('21-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PORTLET (PORTLET_ID, PORTLET_NAME, PORTLET_RIGHT_CODE, PORTLET_URL, PORTLET_POSTION, PORTLET_TAG, PIC_ADDRESS, PORTLET_DESCRIBE, PORTLET_CREATE_TIME, PORTLET_MOFIFY_TIME)
values ('03', '�ҵ�΢��3', '002', 'test.html', '1', '����2', 'abc.png', '����һ���ɿ����鿪��������΢������΢�����Թ����е���Ȩ��ʹ�õ���Ա������קʹ�ã�', to_date('21-07-2014', 'dd-mm-yyyy'), to_date('21-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_PORTLET (PORTLET_ID, PORTLET_NAME, PORTLET_RIGHT_CODE, PORTLET_URL, PORTLET_POSTION, PORTLET_TAG, PIC_ADDRESS, PORTLET_DESCRIBE, PORTLET_CREATE_TIME, PORTLET_MOFIFY_TIME)
values ('04', '�ҵ�΢��4', '001', 'test.html', '1', '����2', 'abc.png', '����һ���ɿ����鿪��������΢������΢�����Թ����е���Ȩ��ʹ�õ���Ա������קʹ�ã�', to_date('21-07-2014', 'dd-mm-yyyy'), to_date('21-07-2014', 'dd-mm-yyyy'));
commit;
prompt 4 records loaded
prompt Loading WORKBENCH_TEMPLATE...
insert into WORKBENCH_TEMPLATE (TEMPLATE_ID, TEMPLATE_RIGHT_CODE, TMPLATE_NAME, IS_SUPER_TEMPLATE, IS_DEFAULT, TEMPLATE_DESCRIBE, TEMPLATE_CREATE_TIME)
values ('01', '001', '����̨ģ��1', '0', '1', '����̨ģ��1��������I��Ϣ', to_date('21-07-2014', 'dd-mm-yyyy'));
insert into WORKBENCH_TEMPLATE (TEMPLATE_ID, TEMPLATE_RIGHT_CODE, TMPLATE_NAME, IS_SUPER_TEMPLATE, IS_DEFAULT, TEMPLATE_DESCRIBE, TEMPLATE_CREATE_TIME)
values ('02', '002', '����̨ģ��2', '0', '1', '����̨ģ��1��������I��Ϣ', to_date('21-07-2014', 'dd-mm-yyyy'));
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
