#!/bin/ash
  GITHUB_WORKFLOW_HOME=/github/home
  if [ -f ${1} ]; then
    cat ${1} | sarif-to-markdown-table > ${GITHUB_WORKFLOW_HOME}/sarif.md
    cat ${GITHUB_WORKFLOW_HOME}/sarif.md

    # multiline GITHUB_OUTPUT
    EOF=$(dd if=/dev/urandom bs=15 count=1 status=none | base64)
    echo "markdown<<$EOF" >> $GITHUB_OUTPUT
    echo "$(cat ${GITHUB_WORKFLOW_HOME}/sarif.md)" >> $GITHUB_OUTPUT
    echo "$EOF" >> $GITHUB_OUTPUT
  else
    echo "sarif report ${1} does not exist or path is wrong. Use ${GITHUB_WORKFLOW_HOME} within containers"
    ls -lah ${GITHUB_WORKFLOW_HOME}/*
  fi