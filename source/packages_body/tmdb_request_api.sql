--liquibase formatted sql

--changeset tschf:tmdb_request_api_body runOnChange:true endDelimiter:/ rollbackEndDelimiter:/
create or replace package body tmdb_request_api
as

  -- Expectation is that all requests to TMDB return JSON.
  procedure reset_headers
  as
  begin
    apex_web_service.g_request_headers.delete;

    apex_web_service.g_request_headers(1).name := 'Accept';
    apex_web_service.g_request_headers(1).value := 'application/json';
  end reset_headers;

  --

  function make_request(
    p_url in varchar2,
    p_http_method in varchar2 default 'GET',
    p_wallet_path in varchar2 default 'system:'
  )
  return clob
  as
    l_response_body clob;
  begin

    reset_headers;

    l_response_body :=
      apex_web_service.make_rest_request(
        p_url => p_url,
        p_http_method => p_http_method,
        p_wallet_path => p_wallet_path,
        p_credential_static_id => app_config_api.get_config_value('TMDB_CREDENTIAL_STATIC_ID')
      );

    return l_response_body;

  end make_request;

end tmdb_request_api;
/
--rollback not required
