--liquibase formatted sql

--changeset tschf:app_config_tmdb_api_key runOnChange:true endDelimiter:; rollbackEndDelimiter:;
--preconditions onFail:CONTINUE onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from dual where '${TMDB_API_KEY}' not like '${%}';
merge into app_config tgt
using (
  select
    'TMDB_API_KEY' app_config_name,
    '${TMDB_API_KEY}' app_config_value
  from
    dual
) src
on (tgt.app_config_name = src.app_config_name)
when not matched then insert
(
  app_config_name,
  app_config_value
)
values
(
  src.app_config_name,
  src.app_config_value
)
when matched then update
set tgt.app_config_value = src.app_config_value;
--rollback not required

--changeset tschf:app_config_tmdb_read_access_token runOnChange:true endDelimiter:; rollbackEndDelimiter:;
--preconditions onFail:CONTINUE onError:HALT
--precondition-sql-check expectedResult:1 select count(1) from dual where '${TMDB_READ_ACCESS_TOKEN}' not like '${%}';
merge into app_config tgt
using (
  select
    'TMDB_READ_ACCESS_TOKEN' app_config_name,
    '${TMDB_READ_ACCESS_TOKEN}' app_config_value
  from
    dual
) src
on (tgt.app_config_name = src.app_config_name)
when not matched then insert
(
  app_config_name,
  app_config_value
)
values
(
  src.app_config_name,
  src.app_config_value
)
when matched then update
set tgt.app_config_value = src.app_config_value;
--rollback not required

--changeset tschf:app_config_non_secrets runOnChange:true endDelimiter:; rollbackEndDelimiter:;
merge into app_config tgt
using (
  select
    'TMDB_CREDENTIAL_STATIC_ID' app_config_name,
    'tmdb_read_access' app_config_value
  from
    dual
) src
on (tgt.app_config_name = src.app_config_name)
when not matched then insert
(
  app_config_name,
  app_config_value
)
values
(
  src.app_config_name,
  src.app_config_value
)
when matched then update
set tgt.app_config_value = src.app_config_value;
--rollback not required