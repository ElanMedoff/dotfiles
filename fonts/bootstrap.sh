#! /bin/bash

source ~/.dotfiles/helpers.sh

h_validate_num_args --num=1 "$@"
h_validate_package_manager $1

if [[ $1 == "--pm=dnf" ]]
then
  h_cecho --noop "fonts already in the correct directory"
else
  for dir in ~/.dotfiles/fonts/.local/share/fonts/*
  do
    h_cecho --doing "copying the fonts in $dir"
    for file in "$dir"/*
    do
      cp -n "$file" ~/Library/Fonts
    done
  done
fi