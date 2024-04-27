--liquibase formatted sql

--changeset tschf:create_view_screen_ranking_v runOnChange:true endDelimiter:; rollbackEndDelimiter:;
create or replace force view screen_ranking_v
as
select
  screen_ranking.screen_ranking_id,
  screen_ranking.country_id,
  screen_ranking.week,
  show.category,
  screen_ranking.weekly_rank,
  show.show_title,
  show.season_title,
  screen_ranking.cumulative_weeks_in_top_10,
  case
    -- Class reference: https://apex.oracle.com/pls/apex/r/apex_pm/ut/color-and-status-modifiers
    when show.category = 'Films' then 'u-color-9'
    when show.category = 'TV' then 'u-color-4'
    -- we shouldn't hit the else case, but just in-case
    else 'u-color-29'
  end badge_css_classes
from
  screen_ranking
  join show on (screen_ranking.show_id = show.show_id)
;
--rollback not required

--changeset tschf:comments_screen_ranking_last_top_week_v runOnChange:true endDelimiter:; rollbackEndDelimiter:;
comment on table screen_ranking_v is 'View with join to country to have friendly name and a css class for cards report';
--rollback not required