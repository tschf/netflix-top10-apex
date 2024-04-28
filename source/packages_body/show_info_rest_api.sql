--liquibase formatted sql

--changeset tschf:show_info_rest_api_body runOnChange:true endDelimiter:/ rollbackEndDelimiter:/
create or replace package body show_info_rest_api
as

  procedure show_details(
    p_show_id in show.show_id%type
  )
  as
    l_json_out varchar2(32767);
    l_show_rec show%rowtype;

    e_not_implemented exception;
  begin

    select * into l_show_rec
    from show
    where show_id = p_show_id;

    -- We have previously synchronized data from TMDB. So call the procedure
    -- to sync that data across.
    if l_show_rec.date_metadata_synchronized is null then
      if l_show_rec.category = 'Films' then
        l_show_rec := show_info_api.get_movie_show_info(p_show_id => p_show_id);
      elsif l_show_rec.category = 'TV' then
        raise e_not_implemented;
      end if;
    end if;

    l_json_out := json_object(
        'success' value true,
        'showTitle' value l_show_rec.show_title,
        'releaseDate' value l_show_rec.release_date,
        'posterPath' value l_show_rec.poster_path
      );

    owa_util.mime_header('application/json', false);
    htp.p('Content-Length: ' || length(l_json_out));
    owa_util.http_header_close;

    sys.htp.p(l_json_out);
  exception when others then
    apex_debug.error('Unhandled Exception. SHOW_ID=%s; SQLERRM=%s', p_show_id, sqlerrm);
    -- catch all and don't raise exception since it's used over REST
    l_json_out := json_object(
      'success' value false,
      'message' value 'Cannot get show info. Likely cause is cannot find show in The Movie DB or calling unimplemented category (TV)'
    );
    owa_util.mime_header('application/json', false);
    htp.p('Content-Length: ' || length(l_json_out));
    owa_util.http_header_close;

    sys.htp.p(l_json_out);
  end show_details;

end show_info_rest_api;
/
--rollback not required
