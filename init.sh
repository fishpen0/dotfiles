#!/usr/bin/env bash

# Do Generic Tasks
run_generic() {
  ./generic/generic.sh
}

# Do Debian Tasks
run_debian() {
  echo "debian"
}

# Do RHEL Tasks
run_rhel() {
  echo "rhel"
}

# Do OSX Tasks
run_osx() {
  echo "OSX!"
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
run_generic
