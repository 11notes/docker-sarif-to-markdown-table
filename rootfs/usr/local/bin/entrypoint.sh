#!/bin/ash
  if [ -f ${1} ]; then
    cat ${1} | sarif-to-markdown-table > ${APP_ROOT}/sarif.md
    echo "markdown=$(cat ${APP_ROOT}/sarif.md)" >> $GITHUB_OUTPUT
  fi