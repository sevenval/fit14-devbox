#!/bin/bash

_printLine() {
    if [ "$2" ] && [ -z "${2##[0-9]}" ] && [ "$2" -eq 1 ]; then
        sResult="OK"
    else
        sResult="FAILED"
        failed=$((failed + 1))
    fi

    printf " - %-70s %s\n" "$1:" "$sResult"

    if [ "$3" ]; then
        if [ -z "${3##[0-9]}" ]; then
            exit "$3"
        else
            exit
        fi
    fi
}

_shutdown() {
    status="${PIPESTATUS[0]}"
    if [ "$status" != "0" ];then
        echo "FAILED with $status in $sMessage";
    fi
}
