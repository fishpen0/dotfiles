#!/usr/bin/env bash

# Do Generic Tasks
run_generic() {
  generic/init.sh
}

# Do OSX Tasks
run_osx() {
  echo "Mac OS Detected."
  cd mac
  #./init.sh
  cd ../
  run_generic
}

run_osx