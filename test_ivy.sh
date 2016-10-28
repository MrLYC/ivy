#!/bin/bash

IVY_PATH=""

init() {
    echo 123 > ${IVY_SOURCE}/123
    export IVY_PATH="${IVY_PATH};/123"

    mkdir -p ${IVY_SOURCE}/456
    echo 456 > ${IVY_SOURCE}/456/456
    export IVY_PATH="${IVY_PATH};/456/456"

    mkdir -p ${IVY_TARGET}/789
    echo 789 > ${IVY_TARGET}/789/789
    export IVY_PATH="${IVY_PATH};/789/789"

    mkdir -p ${IVY_SOURCE}/abc
    echo abc > ${root}/source/abc/abc
    mkdir -p ${IVY_TARGET}/abc
    echo abc > ${IVY_TARGET}/abc/abc
    export IVY_PATH="${IVY_PATH};/abc/abc"
}

check() {
    if [[ "$1" != "$(realpath $2)" ]]; then
        echo "$1 is not equals to $2"
    fi
}

check_result() {
    for i in $(echo "${IVY_PATH}" | tr ";" "\n"); do
        if [[ "$i" != "" ]]; then
            check "${IVY_SOURCE}$i" "${IVY_TARGET}$i"
        fi
    done
}

root=`pwd`/test
export IVY_SOURCE=${root}/source
export IVY_TARGET=${root}/target
export IVY_PATH=""

if [[ -e "${root}" ]]; then
    rm -rf "${root}"
fi

mkdir -p ${IVY_SOURCE}
mkdir -p ${IVY_TARGET}

init

./ivy

check_result
