--liquibase formatted sql

--changeset tschf:netflix_etl_package_spec runOnChange:true endDelimiter:/ rollbackEndDelimiter:/
create or replace package body app_config_api
as

  function get_config_value(p_app_config_name in app_config.app_config_name%type)
  return app_config.app_config_value%type
  as
    l_app_config_value app_config.app_config_value%type;
  begin

    select app_config_value
    into l_app_config_value
    from app_config
    where app_config_name = p_app_config_name;

    return l_app_config_value;
  exception when no_data_found then
    -- I'm ok with returning null if the config doesn't exist (for now)
    return null;
  end get_config_value;

end app_config_api;
/
--rollback not required
