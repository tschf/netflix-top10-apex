-- App Tables (including liquibase tables)
drop table screen_ranking purge;
drop table show purge;
drop table country purge;
drop table app_config purge;

-- Liquibase tables
drop table databasechangelog purge;
drop table databasechangelog_actions purge;
drop table databasechangeloglock purge;
drop view databasechangelog_details;

-- Packages
drop package netflix_etl;
drop package app_config_api;
drop package show_info_api;
drop package show_info_rest_api;
drop package tmdb_request_api;

-- Views
drop view screen_ranking_v;

-- Application
begin
  apex_util.set_workspace('APP_DEV');
  apex_credential.drop_credential(p_credential_static_id => 'tmdb_read_access');
  apex_application_install.remove_application (p_application_id => 100 );
end;
/

commit;