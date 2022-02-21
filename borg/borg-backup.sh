#!/bin/sh
# Version 1.0

##### GETTING STARTED #####
# Copy the script to ~/.borg. 
# Init your repo on the remote server.
# Use repokey-blake2 as the encryption method.
## borg init user@server:repo_name -e repokey-blake2
# Export the key and copy it to a safe place.
## borg key export user@server:repo_name local_file_name

# Update 'REPO_NAME' with the name of your repo.
export BORG_REPO=borg@server:repo

# Update BORG_PASSPHRASE with your repo's password.
export BORG_PASSPHRASE=''

# Some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression lz4               \
    --exclude-caches                \
                                    \
    ::'{hostname}-{now}'            \
    # You may specify multiple directories here.
    # Put a new directory on each line and end with a backslash - \
    # Wrap paths with spaces in directory names in double quotes
    # Examples:
    #/path/one                   \
    #/path/two                   \
    #/path/three                 \
    #"/path/four/My Awesome Dir/"


backup_exit=$?

info "Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                          \
    --list                          \
    --prefix '{hostname}-'          \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6               \

prune_exit=$?

# Use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup and Prune finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup and/or Prune finished with warnings"
else
    info "Backup and/or Prune finished with errors"
fi

exit ${global_exit}
