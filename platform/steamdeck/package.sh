#!/usr/bin/env bash

# Resolve this script's directory, even if sourced
this_script="${BASH_SOURCE[0]:-${(%):-%x}}"
script_dir="$(cd "$(dirname "$this_script")" && pwd)"

: # TIL : in bash is like pass in python