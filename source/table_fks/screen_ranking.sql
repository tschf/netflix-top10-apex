--liquibase formatted sql

--changeset tschf:alter_table_screen_ranking_fk1 endDelimiter:; rollbackEndDelimiter:;
alter table screen_ranking
add constraint screen_ranking_fk1 foreign key ("SHOW_ID") references "SHOW" ("SHOW_ID");
--rollback alter table screen_ranking drop constraint screen_ranking_fk1;

--changeset tschf:alter_table_screen_ranking_fk2 endDelimiter:; rollbackEndDelimiter:;
alter table screen_ranking
add constraint screen_ranking_fk2 foreign key ("COUNTRY_ID") references "COUNTRY" ("COUNTRY_ID");
--rollback alter table screen_ranking drop constraint screen_ranking_fk2;