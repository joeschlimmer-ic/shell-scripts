#!/bin/bash

today=$(date +%Y-%m-%d-T%H%M)

docker stop wger_cache
docker stop wger_nginx
docker stop wger_db
docker stop wger_server

docker run --rm --volumes-from wger_db -v /home/joe/backup:/wgerbackup ubuntu bash -c "cd /var/lib/postgresql/data && tar cvf /wgerbackup/$today-wger-db-backup.tar ."
docker run --rm --volumes-from wger_server -v /home/joe/backup:/wgerbackup ubuntu bash -c "cd /home/wger/media && tar cvf /wgerbackup/$today-wger-media-backup.tar . ; cd /home/wger/static && tar cvf /wgerbackup/$today-wger-static-backup.tar ."

docker start wger_db
docker start wger_server
docker start wger_cache
docker start wger_nginx

exit $?
