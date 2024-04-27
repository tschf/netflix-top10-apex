--liquibase formatted sql

--changeset tschf:show_info_api_spec runOnChange:true endDelimiter:/ rollbackEndDelimiter:/
create or replace package show_info_api
authid definer
as

  -- Get the show record. If the additional data hasn't yet been synced from TMDB
  -- first fetch and update the record.
  function get_movie_show_info(
    p_show_id in number
  )
  return show%rowtype;

end show_info_api;
/
--rollback not required
