#!/usr/bin/env bash

set -e

BASE_DIR="$(pwd)"
#------------------------------------- FUNCTIONS -------------------------------------------
function error() {
    if [[ ${1} = '' ]];then
        echo "ERROR: need argument"
        exit 1
    fi
    echo "ERROR: ${1}"
}

function is_answer_yes(){
    local message="${1}"
    echo -n "${message}"
    read answer
    [[ "$answer" =~ ^[Yy]$ ]] && return 0 || return 1
}

function is_venv_dev_active() {
    [ "$(which python)" == "${BASE_DIR}/venv_dev/bin/python" ] && return 0 || return 1
}

function install_pip() {
    if [[ -z "${1}" ]];then
        echo "specify version of python in the venv"
        exit 255
    fi
    PYTHON_VERSION="${1}"
    virtualenv --python=python"${1}" "${BASE_DIR}/venv_dev"
}

#------------------------------------- START -----------------------------------------------

if [ -d "${BASE_DIR}/venv_dev" ];then
    echo "Virtualenv is exist"
    if ! is_answer_yes "Do you want override venv? [y/N] ";then
        echo "Good bye!" && exit 0
    fi
fi

rm -rf "${BASE_DIR}/venv_dev"

if ! is_venv_dev_active;then
    if ! install_pip 3; then
        error "virtualenv not installed"
        echo "use command: sudo apt-get install virtualenv"
        exit 1
    fi
fi

if ! source "${BASE_DIR}/venv_dev/bin/activate";then
    echo "Virtualenv: FAILED"
    exit 2
fi

if [ -f "${BASE_DIR}/requirements.txt" ];then
    pip install -r requirements.txt
fi

echo "---------------------"
pip -V
pip list
echo "---------------------"
python -V
echo "---------------------"

exit "${?}"
#------------------------------------- END -----------------------------------------------
