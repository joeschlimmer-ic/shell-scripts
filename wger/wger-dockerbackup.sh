#!/bin/bash

today=$(date +%Y-%m-%d-T%H%M)

docker stop docker_cache_1
docker stop docker_nginx_1
docker stop docker_db_1
docker stop docker_web_1

docker run --rm --volumes-from docker_db_1 -v /home/joe/backup:/wgerbackup ubuntu bash -c "cd /var/lib/postgresql/data && tar cvf /wgerbackup/$today-wger-db-backup.tar ."
docker run --rm --volumes-from docker_web_1 -v /home/joe/backup:/wgerbackup ubuntu bash -c "cd /home/wger/media && tar cvf /wgerbackup/$today-wger-media-backup.tar . ; cd /home/wger/static && tar cvf /wgerbackup/$today-wger-static-backup.tar ."

docker start docker_db_1
docker start docker_web_1
docker start docker_cache_1
docker start docker_nginx_1

exit $?