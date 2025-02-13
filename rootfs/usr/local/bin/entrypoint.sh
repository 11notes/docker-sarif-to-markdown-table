#!/bin/sh
  printf '%d args:' "$#"
  printf " '%s'" "$@"
  printf '\n'
  
  ls -lah /github/*

  echo -e "\n\n# TEST" >> /github/workspace/README.md