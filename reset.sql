-- App Tables (including liquibase tables)
drop table screen_ranking purge;
drop table show purge;
drop table country purge;
drop table app_config purge;

-- Liquibase tables
drop table databasechangelog purge;
drop table databasechangelog_actions purge;
drop table databasechangeloglock purge;

-- Packages
drop package netflix_etl;
drop package app_config_api;

-- Application
begin
  apex_application_install.set_workspace('APP_DEV');
  apex_application_install.remove_application (p_application_id => 100 );
end;
/

commit;