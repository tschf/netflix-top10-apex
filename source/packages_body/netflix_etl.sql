--liquibase formatted sql

--changeset tschf:netflix_etl_package_body runOnChange:true endDelimiter:/ rollbackEndDelimiter:/
create or replace package body netflix_etl
as

  procedure sync_to_table(p_upload_file in blob)
  as
  begin

    -- Table for netflix countries so we can build a filter
    merge into country tgt
    using (
      select
        parsed.col001 country_name,
        parsed.col002 country_iso2
      from
        table(apex_data_parser.parse(
          p_content => p_upload_file,
          p_file_name => 'upload.tsv',
          -- skip header row
          p_skip_rows => 1
        )) parsed
      group by col001, col002
    ) src
    on (src.country_iso2 = tgt.country_iso2)
    when not matched then insert
    (
      tgt.country_name,
      tgt.country_iso2
    )
    values
    (
      src.country_name,
      src.country_iso2
    )
    when matched then update
    set tgt.country_name = src.country_name;

    -- Shows can appear across multiple weeks/countries. So we split show to its
    -- own table. Plus, we need to grab additional show info later, so it's better
    -- in its own table
    merge into show tgt
    using (
      select
        parsed.col004 category,
        parsed.col006 show_title,
        case when parsed.col004 = 'TV' then parsed.col007 end season_title
      from
        table(apex_data_parser.parse(
          p_content => p_upload_file,
          p_file_name => 'upload.tsv',
          -- skip header row
          p_skip_rows => 1
        )) parsed
      group by col004, col006, col007
    ) src
    on (
      tgt.category = src.category
      and tgt.show_title = src.show_title
      and tgt.season_title = src.season_title )
    when not matched then insert
    (
      tgt.show_title,
      tgt.season_title,
      tgt.category
    )
    values
    (
      src.show_title,
      src.season_title,
      src.category
    );

    -- The underlying ranking data
    merge into screen_ranking tgt
    using (
      select
        country.country_id,
        to_date(parsed.col003, 'YYYY-MM-DD') week,
        parsed.col004 category,
        to_number(parsed.col005) weekly_rank,
        show.show_id,
        to_number(parsed.col008) cumulative_weeks_in_top_10
      from
        table(apex_data_parser.parse(
          p_content => p_upload_file,
          p_file_name => 'upload.tsv',
          -- skip header row
          p_skip_rows => 1
        )) parsed
        join country on (country.country_iso2 = parsed.col002)
        join show on (
          show.category = parsed.col004
          and show.show_title = parsed.col006
          -- our transformation leaves season_title as null if its not a TV show
          and (show.season_title = case when parsed.col004 = 'TV' then parsed.col007 end or show.season_title is null)
        )
    ) src
    on (
      tgt.country_id = src.country_id
      and tgt.week = src.week
      and tgt.category = src.category
      and tgt.weekly_rank = src.weekly_rank
      and tgt.show_id = src.show_id
    )
    when not matched then insert
    (
      tgt.country_id,
      tgt.week,
      tgt.category,
      tgt.weekly_rank,
      tgt.show_id,
      tgt.cumulative_weeks_in_top_10
    )
    values
    (
      src.country_id,
      src.week,
      src.category,
      src.weekly_rank,
      src.show_id,
      src.cumulative_weeks_in_top_10
    );
  end sync_to_table;

end netflix_etl;
/
--rollback not required
