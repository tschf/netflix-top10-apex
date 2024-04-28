!rm -rf source/apex/application/f100
apex export -applicationid 100 -expType APPLICATION_SOURCE,READABLE_YAML -dir source/apex/application/f100

PRO Clearing checksum to avoid accidental deployment (for changeset id "apex_f100")
update databasechangelog
set md5sum = null
where id = 'apex_f100';
commit;
