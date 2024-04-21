--liquibase formatted sql

--changeset tschf:netflix_etl_package_spec runOnChange:true endDelimiter:/ rollbackEndDelimiter:/
create or replace package app_config_api
authid definer
as

  function get_config_value(p_app_config_name in app_config.app_config_name%type)
  return app_config.app_config_value%type;

end app_config_api;
/
--rollback not required
