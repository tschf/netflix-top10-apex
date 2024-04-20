-- Tables (including liquibase tables)
drop table screen_ranking purge;
drop table databasechangelog purge;
drop table databasechangelog_actions purge;
drop table databasechangeloglock purge;

-- Packages
drop package netflix_etl;

-- Application
begin
  apex_application_install.set_workspace('APP_DEV');
  APEX_APPLICATION_INSTALL.REMOVE_APPLICATION (p_application_id => 100 );
end;
/

commit;