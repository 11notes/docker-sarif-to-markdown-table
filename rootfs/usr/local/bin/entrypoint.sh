#!/bin/ash
  SARIF=/github/home/${1}
  SARIF_MD=/github/home/sarif.md
  if [ -f ${SARIF} ]; then
    cat ${SARIF} | sarif-to-markdown-table > ${SARIF_MD}
    cat ${SARIF_MD}
    echo "markdown=$(cat ${SARIF_MD})" >> $GITHUB_OUTPUT
  fi