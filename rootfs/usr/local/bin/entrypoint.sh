#!/bin/ash
  if [ -f ${1} ]; then
    echo "converting ${1} to markdown"
    cat ${1} | sarif-to-markdown-table > ${APP_ROOT}/sarif.md
    echo "markdown=$(cat ${APP_ROOT}/sarif.md)" >> $GITHUB_OUTPUT
  fi