--liquibase formatted sql

--changeset tschf:tmdb_read_access_web_credential runOnChange:true endDelimiter:/ rollbackEndDelimiter:/
declare
  l_credential_static_id varchar2(100) := 'tmdb_read_access';
begin

  apex_util.set_workspace('APP_DEV');

  apex_credential.create_credential(
    p_credential_name => 'The Movie DB API Read Access',
    p_credential_static_id => l_credential_static_id,
    p_authentication_type => apex_credential.C_TYPE_HTTP_HEADER,
    p_credential_comment => 'Tip: Use this credential with `p_credential_static_id` parameter in apex_web_service.'
  );

  apex_credential.set_persistent_credentials(
    p_credential_static_id => l_credential_static_id,
    p_username => 'Authorization',
    p_password => 'Bearer ${TMDB_READ_ACCESS_TOKEN}'
  );

end;
/
--rollback not required
