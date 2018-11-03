#!/usr/bin/env bash

# Do Generic Tasks
run_generic() {
  generic/init.sh
}

# Do Debian Tasks
run_debian() {
  echo "Debian based OS Detected."
  debian/init.sh
  run_generic
}

# Do RHEL Tasks
run_rhel() {
  echo "Rhel based OS Detected."
  rhel/init.sh
  run_generic
}

# Do OSX Tasks
run_osx() {
  echo "Mac OS Detected."
  cd mac
  #./init.sh
  cd ../
  run_generic
}

# Detect OS
unsupported() {
  echo "\nUnsupported OS! Exiting...\n" >&2
  exit 1
}

detect_distro() {
  # TODO: detect rhel v deb
  echo "distro"
}

detect_os() {
  case "$OSTYPE" in
    linux*)   detect_distro ;;
    darwin*)  run_osx ;; 
    win*)     run_windows ;;
    cygwin*)  ;&
    bsd*)     ;&
    solaris*) ;&
    *)        unsupported ;;
  esac
}

detect_os