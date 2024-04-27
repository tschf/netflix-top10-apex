--liquibase formatted sql

--changeset tschf:tmdb_request_api_spec runOnChange:true endDelimiter:/ rollbackEndDelimiter:/
create or replace package tmdb_request_api
authid definer
as

  function make_request(
    p_url in varchar2,
    p_http_method in varchar2 default 'GET',
    p_wallet_path in varchar2 default 'system:'
  )
  return clob;

end tmdb_request_api;
/
--rollback not required
