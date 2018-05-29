#!/bin/sh

set -euf -o pipefail


find_closure () {
  find /usr/local -type f -name 'closure-compiler*.jar' | head -n 1
}

exec java -jar $(find_closure) "${@}"
