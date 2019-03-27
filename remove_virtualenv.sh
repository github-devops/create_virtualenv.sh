#!/usr/bin/env bash

set -e
#------------------------------------- VARIABLES -------------------------------------------
BASE_DIR="$(pwd)"
VENV_DIRS=( bin lib include share )
#------------------------------------- FUNCTIONS -------------------------------------------
function is_answer_yes(){
    local message="${1}"
    echo -n "${message}"
    read answer
    [[ "$answer" =~ ^[Yy]$ ]] && return 0 || return 1
}

function rm_venv(){
	rm -rf "${VENV_DIRS[@]}"
	sudo find . ! -regex ".*/\(create_virtualenv.sh\|.git.*\|requirements.txt\|remove_virtualenv.sh\)" -delete
}

#------------------------------------- START -----------------------------------------------

if [ -d "${BASE_DIR}/bin" ];then
    echo "Virtualenv is exist"
    if ! is_answer_yes "Do you want remove venv? [y/N] ";then
        echo "Good bye!" && exit 0
    fi
fi

rm_venv

exit "${?}"
#------------------------------------- END -----------------------------------------------
