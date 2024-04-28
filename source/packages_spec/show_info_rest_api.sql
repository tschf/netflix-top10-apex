--liquibase formatted sql

--changeset tschf:show_info_rest_api_spec runOnChange:true endDelimiter:/ rollbackEndDelimiter:/
create or replace package show_info_rest_api
authid definer
as

  procedure show_details(
    p_show_id in show.show_id%type
  );

end show_info_rest_api;
/
--rollback not required
