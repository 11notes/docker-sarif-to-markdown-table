#!/bin/ash
  if [ -z "${1}" ]; then
    echo $@
    echo "${1}" | sarif-to-markdown-table > ${APP_ROOT}/sarif.md
    cat ${APP_ROOT}/sarif.md
    echo "markdown=$(cat ${APP_ROOT}/sarif.md)" >> $GITHUB_OUTPUT
  else
    exec "$@"
  fi