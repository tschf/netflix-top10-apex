--liquibase formatted sql

--changeset tschafer:netflix_etl_package_spec runOnChange:true endDelimiter:/ rollbackEndDelimiter:/
create or replace package netflix_etl
authid definer
as

  procedure sync_to_table(p_upload_file in blob);

end netflix_etl;
/
--rollback not required
