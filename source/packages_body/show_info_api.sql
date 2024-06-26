--liquibase formatted sql

--changeset tschf:show_info_api_body runOnChange:true endDelimiter:/ rollbackEndDelimiter:/
create or replace package body show_info_api
as

  function get_movie_show_info(
    p_show_id in number
  )
  return show%rowtype
  as
    l_show_rec show%rowtype;
    l_show_search_resp_body clob;
  begin

    select *
    into l_show_rec
    from show
    where show_id = p_show_id;
    apex_debug.info('movie show_title='||l_show_rec.show_title);

    if l_show_rec.category != 'Films' then
      raise_application_error(-20001, apex_string.format('Show "%s" is of wrong category', l_show_rec.show_title));
    end if;

    if l_show_rec.date_metadata_synchronized is null then

      -- Doc reference: https://developer.themoviedb.org/reference/search-movie
      l_show_search_resp_body :=
        tmdb_request_api.make_request(
          p_url => apex_string.format('https://api.themoviedb.org/3/search/movie?query=%s', l_show_rec.show_title)
        );
      apex_debug.info(p_message => 'movie search json='||l_show_search_resp_body);

      select
        tmdb_info.id,
        tmdb_info.release_date,
        tmdb_info.backdrop_path,
        tmdb_info.poster_path
      into
        l_show_rec.tmdb_id,
        l_show_rec.release_date,
        l_show_rec.backdrop_path,
        l_show_rec.poster_path
      from
        json_table(
          l_show_search_resp_body,
          '$.results[*]'
          columns (
            id number path '$.id',
            original_title varchar2(4000) path '$.original_title',
            title varchar2(4000) path '$.title',
            backdrop_path varchar2(4000) path '$.backdrop_path',
            poster_path varchar2(4000) path '$.poster_path',
            release_date date path '$.release_date'
            -- TODO: genre_ids is an array of numbers: [55, 34, 12]
            -- genre_ids varchar2(4000) path '$.genre_ids'
          )
        ) tmdb_info
      where
        -- original title and title could differ. Case in point is "The Tearsmith"
        -- which has original title "Fabbricante di lacrime" but title "The Tearsmith".
        -- Lets go with filtering only on `title` for now.
        tmdb_info.title = l_show_rec.show_title
      -- Just returning the first match. There are a number of cases returning
      -- more than one title, so we need to choose one. Could be incorrect.
      fetch first row only;

      l_show_rec.date_metadata_synchronized := sysdate;

      update show
      set row = l_show_rec
      where show_id = l_show_rec.show_id;

    end if;

    return l_show_rec;
  end get_movie_show_info;

  --

  function get_tv_show_info(
    p_show_id in number
  )
  return show%rowtype
  as
    l_show_rec show%rowtype;
    l_show_search_resp_body clob;
  begin

    select *
    into l_show_rec
    from show
    where show_id = p_show_id;
    apex_debug.info('tv show_title='||l_show_rec.show_title);

    if l_show_rec.category != 'TV' then
      raise_application_error(-20001, apex_string.format('Show "%s" is of wrong category', l_show_rec.show_title));
    end if;

    if l_show_rec.date_metadata_synchronized is null then

      -- API documentation: https://developer.themoviedb.org/reference/search-tv
      l_show_search_resp_body :=
        tmdb_request_api.make_request(
          p_url => apex_string.format('https://api.themoviedb.org/3/search/tv?query=%s', l_show_rec.show_title)
        );
      apex_debug.info(p_message => 'movie search json=' || l_show_search_resp_body);

      select
        tmdb_info.id,
        tmdb_info.first_air_date,
        tmdb_info.backdrop_path,
        tmdb_info.poster_path
      into
        l_show_rec.tmdb_id,
        l_show_rec.release_date,
        l_show_rec.backdrop_path,
        l_show_rec.poster_path
      from
        json_table(
          l_show_search_resp_body,
          '$.results[*]'
          columns (
            id number path '$.id',
            original_name varchar2(4000) path '$.original_name',
            name varchar2(4000) path '$.name',
            backdrop_path varchar2(4000) path '$.backdrop_path',
            poster_path varchar2(4000) path '$.poster_path',
            first_air_date date path '$.first_air_date'
            -- TODO: genre_ids is an array of numbers: [55, 34, 12]
            -- genre_ids varchar2(4000) path '$.genre_ids'
          )
        ) tmdb_info
      where
        -- original title and title could differ. Case in point is "The Tearsmith"
        -- which has original title "Fabbricante di lacrime" but title "The Tearsmith".
        -- Lets go with filtering only on `title` for now.
        tmdb_info.name = l_show_rec.show_title
      -- Just returning the first match. There are a number of cases returning
      -- more than one title, so we need to choose one. Could be incorrect.
      fetch first row only;

      l_show_rec.date_metadata_synchronized := sysdate;

      update show
      set row = l_show_rec
      where show_id = l_show_rec.show_id;


    end if;

    return l_show_rec;
  end get_tv_show_info;

end show_info_api;
/
--rollback not required
