#!/usr/bin/env bash

find . -type f -name "*.ino" | while read -r file; do echo "$file";
  file=$( echo "$file" | cut -c 3- )
  echo -e "\n" >> ./examples.lua
  echo -e "examples.$file = [[\n" >> ./examples.lua
  cat "$file" >> ./examples.lua
  echo -e "\n]]" >> ./examples.lua
done
