alter table workbench_platform_portlet add (pt_order_new INTEGER);
update workbench_platform_portlet t set t.pt_order_new = (select k.pt_order from workbench_platform_portlet k where t.id = k.id);
alter table workbench_platform_portlet drop (pt_order);
ALTER TABLE workbench_platform_portlet RENAME COLUMN pt_order_new TO pt_order;