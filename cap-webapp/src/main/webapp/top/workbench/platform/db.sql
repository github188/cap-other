/*==============================================================*/
/* DBMS name:      ORACLE Version 10gR2                         */
/* Created on:     2014/7/21 17:55:42                           */
/*==============================================================*/

drop table WORKBENCH_PLATFORM cascade constraints;

drop table WORKBENCH_PLATFORM_PORTLET cascade constraints;

drop table WORKBENCH_PORTLET cascade constraints;

drop table WORKBENCH_TEMPLATE cascade constraints;

drop table WORKBENCH_TEMPLATE_PORTEL cascade constraints;

/*==============================================================*/
/* Table: WORKBENCH_PLATFORM                                    */
/*==============================================================*/
create table WORKBENCH_PLATFORM  (
   PLATFORM_ID          VARCHAR2(32)                    not null,
   USER_ID              VARCHAR2(32),
   PLATFORM_NAME        VARCHAR2(80),
   IS_DEFAULT_PLATFORM  char(1),
   TEMPLATE_ID          VARCHAR(32),
   PLATFORM_NUMBER      INTEGER,
   PLATFORM_LAST_MODIFY_TIME DATE,
   PLATFORM_CREATE_TIME DATE,
   constraint PK_WORKBENCH_PLATFORM primary key (PLATFORM_ID)
);

comment on table WORKBENCH_PLATFORM is
'���ڴ洢�û��Ĺ���̨������Ϣ';

comment on column WORKBENCH_PLATFORM.PLATFORM_ID is
'����';

comment on column WORKBENCH_PLATFORM.USER_ID is
'�û�ID����¼��ǰ��¼���û�';

comment on column WORKBENCH_PLATFORM.PLATFORM_NAME is
'����̨����';

comment on column WORKBENCH_PLATFORM.IS_DEFAULT_PLATFORM is
'�Ƿ���Ĭ�Ϲ���̨';

comment on column WORKBENCH_PLATFORM.TEMPLATE_ID is
'��¼�ù���̨�Ǵ��ĸ�ģ�帴�ƹ���������';

comment on column WORKBENCH_PLATFORM.PLATFORM_NUMBER is
'����̨���(��¼�ǵڼ�������̨������1,2,3,4����)';

comment on column WORKBENCH_PLATFORM.PLATFORM_LAST_MODIFY_TIME is
'����޸�ʱ��';

comment on column WORKBENCH_PLATFORM.PLATFORM_CREATE_TIME is
'΢������ʱ��';

/*==============================================================*/
/* Table: WORKBENCH_PLATFORM_PORTLET                            */
/*==============================================================*/
create table WORKBENCH_PLATFORM_PORTLET  (
   ID                   VARCHAR2(32)                    not null,
   PLATFORM_ID          VARCHAR2(32)                    not null,
   PORTLET_ID           VARCHAR2(32)                    not null,
   PT_ORDER              CHAR(1)                         not null,
   EDITABLE             CHAR(1),
   SELF_NAME            VARCHAR2(500),
   ADD_TIME             DATE,
   constraint PK_WORKBENCH_PLATFORM_PORTLET primary key (ID)
);

comment on table WORKBENCH_PLATFORM_PORTLET is
'�û���¼ÿһ���û�����̨��ϸ��Ӧ����Щportlet��ÿ��portlet��λ�á�˳���';

comment on column WORKBENCH_PLATFORM_PORTLET.ID is
'����';

comment on column WORKBENCH_PLATFORM_PORTLET.PLATFORM_ID is
'����pub_user_paltform���ĳһ��������¼';

comment on column WORKBENCH_PLATFORM_PORTLET.PORTLET_ID is
'����΢�����ĳһ��������¼';

comment on column WORKBENCH_PLATFORM_PORTLET.PT_ORDER is
'���գ�1��2,��3��4...������';

comment on column WORKBENCH_PLATFORM_PORTLET.EDITABLE is
'��ҳ��һ������̨Ĭ�ϵ�portlet�ǲ��ɱ༭�ģ��Լ���ӵĿ��Ա༭';

comment on column WORKBENCH_PLATFORM_PORTLET.SELF_NAME is
'�Զ����΢������';

comment on column WORKBENCH_PLATFORM_PORTLET.ADD_TIME is
'��Ӹ�΢����ʱ��';

/*==============================================================*/
/* Table: WORKBENCH_PORTLET                                     */
/*==============================================================*/
create table WORKBENCH_PORTLET  (
   PORTLET_ID           VARCHAR2(32)                    not null,
   PORTLET_NAME         VARCHAR2(200)                   not null,
   PORTLET_RIGHT_CODE   VARCHAR2(100)                   not null,
   PORTLET_URL          VARCHAR2(500),
   PORTLET_POSTION      CHAR(1),
   PORTLET_TAG          VARCHAR2(100)                   not null,
   PIC_ADDRESS          VARCHAR2(100 ),
   PORTLET_DESCRIBE     VARCHAR2(500),
   PORTLET_CREATE_TIME  DATE                            not null,
   PORTLET_MOFIFY_TIME  DATE,
   constraint PK_WORKBENCH_PORTLET primary key (PORTLET_ID)
);

comment on table WORKBENCH_PORTLET is
'���ڴ洢����ҵ��ϵͳ�Ĺ���΢����˽��΢��';

comment on column WORKBENCH_PORTLET.PORTLET_ID is
'����';

comment on column WORKBENCH_PORTLET.PORTLET_NAME is
'΢��Ĭ������';

comment on column WORKBENCH_PORTLET.PORTLET_RIGHT_CODE is
'΢�����ӵ��ľ���ҳ���Ȩ�ޱ���';

comment on column WORKBENCH_PORTLET.PORTLET_URL is
'���ӵ��ľ���ҳ���URL';

comment on column WORKBENCH_PORTLET.PORTLET_POSTION is
'0����ࡢ1���Ҳࣻ��ʾ�������΢��ʱ������ӵ�����';

comment on column WORKBENCH_PORTLET.PORTLET_TAG is
'΢�������ķ���trag�����������΢��ʱ��������';

comment on column WORKBENCH_PORTLET.PIC_ADDRESS is
'ͼƬ��ַ';

comment on column WORKBENCH_PORTLET.PORTLET_DESCRIBE is
'΢��������';

comment on column WORKBENCH_PORTLET.PORTLET_CREATE_TIME is
'΢������ʱ��';

comment on column WORKBENCH_PORTLET.PORTLET_MOFIFY_TIME is
'����޸�΢����ʱ��';

/*==============================================================*/
/* Table: WORKBENCH_TEMPLATE                                    */
/*==============================================================*/
create table WORKBENCH_TEMPLATE  (
   TEMPLATE_ID          VARCHAR2(32)                    not null,
   TEMPLATE_RIGHT_CODE  VARCHAR(100),
   TEMPLATE_NAME         VARCHAR2(150)                   not null,
   TEMPLATE_PIC          VARCHAR2(60),
   IS_SUPER_TEMPLATE    CHAR(1)                         not null,
   IS_DEFAULT           CHAR(1),
   TEMPLATE_DESCRIBE    VARCHAR2(500),
   TEMPLATE_CREATE_TIME DATE                            not null,
   constraint PK_WORKBENCH_TEMPLATE primary key (TEMPLATE_ID)
);

comment on table WORKBENCH_TEMPLATE is
'���ڴ洢���еĹ���̨ģ��';

comment on column WORKBENCH_TEMPLATE.TEMPLATE_ID is
'����';

comment on column WORKBENCH_TEMPLATE.TEMPLATE_RIGHT_CODE is
'��Ӧ4A��Ȩ�ޱ���';

comment on column WORKBENCH_TEMPLATE.TEMPLATE_NAME is
'ģ�������,���û�ѡ���ģ���½�����̨��ʱ����';

comment on column WORKBENCH_TEMPLATE.TEMPLATE_PIC is
'����̨ģ���Ӧ��չʾ��ҪͼƬ��ַ';

comment on column WORKBENCH_TEMPLATE.IS_SUPER_TEMPLATE is
'����ģ���ǹ��û�������ɫû��Ĭ��ģ��ʱ���õġ�ϵͳΨһ';

comment on column WORKBENCH_TEMPLATE.IS_DEFAULT is
'�Ƿ��Ǹý�ɫ��Ĭ��ģ��';

comment on column WORKBENCH_TEMPLATE.TEMPLATE_DESCRIBE is
'ģ���������Ϣ';

comment on column WORKBENCH_TEMPLATE.TEMPLATE_CREATE_TIME is
'��ģ���ʵ�ʴ���ʱ��';

/*==============================================================*/
/* Table: WORKBENCH_TEMPLATE_PORTEL                             */
/*==============================================================*/
create table WORKBENCH_TEMPLATE_PORTEL  (
   ID                   VARCHAR2(32)                    not null,
   TEMPLATE_ID          VARCHAR2(32),
   PORTLET_ID           VARCHAR2(32),
   PORTLET_ORDER        INTEGER,
   constraint PK_WORKBENCH_TEMPLATE_PORTEL primary key (ID)
);

comment on table WORKBENCH_TEMPLATE_PORTEL is
'��¼ÿһ������̨ģ�����ϸportlet������ܵĲ���˳��';

comment on column WORKBENCH_TEMPLATE_PORTEL.ID is
'����';

comment on column WORKBENCH_TEMPLATE_PORTEL.TEMPLATE_ID is
'��������̨ģ��������';

comment on column WORKBENCH_TEMPLATE_PORTEL.PORTLET_ID is
'����΢�����ĳһ������';

comment on column WORKBENCH_TEMPLATE_PORTEL.PORTLET_ORDER is
'˳����1,2,3,4����';