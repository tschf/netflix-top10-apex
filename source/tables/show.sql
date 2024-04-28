--liquibase formatted sql

--changeset tschf:create_table_show endDelimiter:; rollbackEndDelimiter:;
create table show(
  show_id number generated by default on null as identity primary key,
  category varchar2(5) not null check (category in ('Films', 'TV')),
  show_title varchar2(512) not null,
  season_title varchar2(512),
  date_metadata_synchronized date,
  tmdb_id number,
  release_date date,
  backdrop_path varchar2(4000),
  poster_path varchar2(4000),
  constraint show_uk1 unique (category, show_title, season_title),
  constraint show_ck1 check (category = 'Films' or season_title is not null)
);
--rollback drop table show;

--changeset tschf:comments_show runOnChange:true endDelimiter:; rollbackEndDelimiter:;
comment on table show is 'A show represents a movie or a tv season. The title and
category come with the Netflix feed file. For other data, we need to rely on an
external service to get that information - so those fields are nulled until the info
is requested.

It make more sense to load them on demand due to the large number of titles that
the user may never be interested in.';

comment on column show.season_title is 'A TV series must have a season title, for movies this will be null';
comment on column show.date_metadata_synchronized is 'Date additional show information was fetched from upstream dataprovider (currently the movie db). We only get the title and category from the netflix feed, so we want to capture additional info';
--rollback not required
