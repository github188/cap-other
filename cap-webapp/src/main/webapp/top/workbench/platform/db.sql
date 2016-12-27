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
'用于存储用户的工作台基本信息';

comment on column WORKBENCH_PLATFORM.PLATFORM_ID is
'主键';

comment on column WORKBENCH_PLATFORM.USER_ID is
'用户ID，记录当前登录的用户';

comment on column WORKBENCH_PLATFORM.PLATFORM_NAME is
'工作台名称';

comment on column WORKBENCH_PLATFORM.IS_DEFAULT_PLATFORM is
'是否是默认工作台';

comment on column WORKBENCH_PLATFORM.TEMPLATE_ID is
'记录该工作台是从哪个模板复制过来的数据';

comment on column WORKBENCH_PLATFORM.PLATFORM_NUMBER is
'工作台序号(记录是第几个工作台，按照1,2,3,4递增)';

comment on column WORKBENCH_PLATFORM.PLATFORM_LAST_MODIFY_TIME is
'最后修改时间';

comment on column WORKBENCH_PLATFORM.PLATFORM_CREATE_TIME is
'微件创建时间';

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
'用户记录每一个用户工作台详细对应了哪些portlet、每个portlet的位置、顺序等';

comment on column WORKBENCH_PLATFORM_PORTLET.ID is
'主键';

comment on column WORKBENCH_PLATFORM_PORTLET.PLATFORM_ID is
'关联pub_user_paltform表的某一条主键记录';

comment on column WORKBENCH_PLATFORM_PORTLET.PORTLET_ID is
'关联微件表的某一条主键记录';

comment on column WORKBENCH_PLATFORM_PORTLET.PT_ORDER is
'按照（1、2,、3、4...递增）';

comment on column WORKBENCH_PLATFORM_PORTLET.EDITABLE is
'首页第一个工作台默认的portlet是不可编辑的，自己添加的可以编辑';

comment on column WORKBENCH_PLATFORM_PORTLET.SELF_NAME is
'自定义的微件名称';

comment on column WORKBENCH_PLATFORM_PORTLET.ADD_TIME is
'添加该微件的时间';

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
'用于存储各个业务系统的公共微件和私有微件';

comment on column WORKBENCH_PORTLET.PORTLET_ID is
'主键';

comment on column WORKBENCH_PORTLET.PORTLET_NAME is
'微件默认名称';

comment on column WORKBENCH_PORTLET.PORTLET_RIGHT_CODE is
'微件连接到的具体页面的权限编码';

comment on column WORKBENCH_PORTLET.PORTLET_URL is
'链接到的具体页面的URL';

comment on column WORKBENCH_PORTLET.PORTLET_POSTION is
'0：左侧、1：右侧；标示了在添加微件时候能添加到哪里';

comment on column WORKBENCH_PORTLET.PORTLET_TAG is
'微件所属的分类trag、用于在添加微件时候左侧分类';

comment on column WORKBENCH_PORTLET.PIC_ADDRESS is
'图片地址';

comment on column WORKBENCH_PORTLET.PORTLET_DESCRIBE is
'微件的描述';

comment on column WORKBENCH_PORTLET.PORTLET_CREATE_TIME is
'微件创建时间';

comment on column WORKBENCH_PORTLET.PORTLET_MOFIFY_TIME is
'最后修改微件的时间';

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
'用于存储所有的工作台模板';

comment on column WORKBENCH_TEMPLATE.TEMPLATE_ID is
'主键';

comment on column WORKBENCH_TEMPLATE.TEMPLATE_RIGHT_CODE is
'对应4A的权限编码';

comment on column WORKBENCH_TEMPLATE.TEMPLATE_NAME is
'模板的名称,供用户选择从模板新建工作台的时候用';

comment on column WORKBENCH_TEMPLATE.TEMPLATE_PIC is
'工作台模板对应的展示简要图片地址';

comment on column WORKBENCH_TEMPLATE.IS_SUPER_TEMPLATE is
'超级模板是供用户所属角色没有默认模板时候用的、系统唯一';

comment on column WORKBENCH_TEMPLATE.IS_DEFAULT is
'是否是该角色的默认模板';

comment on column WORKBENCH_TEMPLATE.TEMPLATE_DESCRIBE is
'模板的描述信息';

comment on column WORKBENCH_TEMPLATE.TEMPLATE_CREATE_TIME is
'该模板的实际创建时间';

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
'记录每一个工作台模板的详细portlet项、包括总的布局顺序';

comment on column WORKBENCH_TEMPLATE_PORTEL.ID is
'主键';

comment on column WORKBENCH_TEMPLATE_PORTEL.TEMPLATE_ID is
'关联工作台模板表的主键';

comment on column WORKBENCH_TEMPLATE_PORTEL.PORTLET_ID is
'关联微件表的某一个主键';

comment on column WORKBENCH_TEMPLATE_PORTEL.PORTLET_ORDER is
'顺序按照1,2,3,4递增';