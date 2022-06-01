#!/bin/bash

CMD="ffmpeg"
TYPE="STREAM"

while [[ $# > 1 ]]
do
key="$1"

if [[ "${key}" == "-frames:v" ]]; then
    TYPE="SNAPSHOT"
fi

case ${key} in
    -pix_fmt)
        CMD+=" $1 vaapi"
        shift
    ;;
    -filter:v)
        if [[ "${TYPE}" == "STREAM" ]]; then
            CMD+=" $1"
        else
            shift
        fi
    ;;
    *)
        CMD+=" $1"
    ;;
esac
shift
done

CMD="${CMD//scale=/scale_vaapi=}"

exec $CMD ${!#}
