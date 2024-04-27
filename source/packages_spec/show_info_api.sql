--liquibase formatted sql

--changeset tschf:show_info_api_spec runOnChange:true endDelimiter:/ rollbackEndDelimiter:/
create or replace package show_info_api
authid definer
as

  type t_show_info is record (
    tmdb_id number,
    original_title varchar2(4000),
    release_date date,
    backdrop_path varchar2(4000),
    poster_path varchar2(4000)
  );

  function get_movie_show_info(
    p_show_id in number
  )
  return t_show_info;

end show_info_api;
/
--rollback not required
