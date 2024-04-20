--liquibase formatted sql

--changeset tschf:netflix_etl_package_body runOnChange:true endDelimiter:/ rollbackEndDelimiter:/
create or replace package body netflix_etl
as

  procedure sync_to_table(p_upload_file in blob)
  as
  begin
    merge into screen_ranking tgt
    using (
      select
        'Australia' country_name,
        'AU' country_iso2,
        trunc(sysdate) week,
        'Films' category,
        1 weekly_rank,
        'TODO' show_title,
        'TODO' season_title,
        1 cumulative_weeks_in_top_10
      from dual
    ) src
    on (
      tgt.country_iso2 = src.country_iso2
      and tgt.week = src.week
      and tgt.category = src.category
      and tgt.weekly_rank = src.weekly_rank
      and tgt.show_title = src.show_title
      and tgt.season_title = src.season_title
    )
    when not matched then insert
    (
      tgt.country_name,
      tgt.country_iso2,
      tgt.week,
      tgt.category,
      tgt.weekly_rank,
      tgt.show_title,
      tgt.season_title,
      tgt.cumulative_weeks_in_top_10
    )
    values
    (
      src.country_name,
      src.country_iso2,
      src.week,
      src.category,
      src.weekly_rank,
      src.show_title,
      src.season_title,
      src.cumulative_weeks_in_top_10
    );
  end sync_to_table;

end netflix_etl;
/
--rollback not required
