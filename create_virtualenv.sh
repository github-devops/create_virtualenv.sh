#!/usr/bin/env bash

set -e

#------------------------------------- VARIABLES -------------------------------------------

BASE_DIR="$(pwd)"
VENV_DIRS=(	bin	lib	include	share local )
FILE_REQUIREMENTS="${BASE_DIR}/requirements.txt"

#------------------------------------- FUNCTIONS -------------------------------------------

function error() {
    if [[ ! ${1} ]];then
        echo "ERROR: need argument"
        exit 1
    fi
    echo "ERROR: ${1}"
}

function is_answer_yes(){
    local message="${1}"
    echo -n "${message}"
    read answer
    [[ "${answer}" =~ ^[Yy]$ ]] && return 0 || return 1
}

function is_venv_active() {
    [ "$(which python)" == "${BASE_DIR}/bin/python" ] && return 0 || return 1
}

function install_pip() {
    if [[ ! "${1}" ]];then
        echo "specify version of python in the venv"
        exit 255
    fi
    virtualenv --python=python"${1}" "${BASE_DIR}/"
}

function remove_virtualenv(){
	rm -rf "${VENV_DIRS[@]}"
	sudo find . ! -regex ".*/\(create_virtualenv.sh\|.git.*\|requirements.txt\)" -delete
}

#------------------------------------- START -----------------------------------------------

if [ -d "${BASE_DIR}/bin" ];then
    echo "Virtualenv is exist"
    if ! is_answer_yes "Do you want to remove venv? [y/N] ";then
        echo "Good bye!" && exit 0
    fi
    remove_virtualenv
    if ! is_answer_yes "Do you want to create venv? [y/N] ";then
        echo "Good bye!" && exit 0
    fi
fi

if ! is_venv_active;then
    if ! install_pip 3; then
        error "virtualenv not installed"
        echo "use command: sudo apt-get update -y && sudo apt-get install virtualenv -y"
        exit 1
    fi
fi

if ! source "${BASE_DIR}/bin/activate" ;then
    echo "Virtualenv: FAILED"
    echo 'ERROR: line 68' && exit 1
fi

if [[ -f  "${FILE_REQUIREMENTS}" && ! $(cat "${FILE_REQUIREMENTS}") ]];then
    echo "Install  from requirements.txt ..."
    pip install -r "${FILE_REQUIREMENTS}"
fi

ln -s ${BASE_DIR}/bin/activate activate && chmod +x activate

echo "---------------------"
pip -V
pip list
echo "---------------------"
python -V
echo "---------------------"
echo "run command: \"source activate\" for use virtual enviroment"
echo "---------------------"

#------------------------------------- END -----------------------------------------------
