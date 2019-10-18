#!/bin/bash

function usage {
  cat <<EOF
Usage: $(basename "$0") [OPTION]...
  -v          version name
  -d          description
  -h          display help
EOF
  exit 2
}

vflg=0
dflg=0

while getopts :vdh OPT
do
    case $OPT in
        v) vflg=1
            ;;
        d) dflg=1
            ;;
        h|*) usage
            ;;
    esac
done

if [ $vflg -eq 1 ]; then
    python -c "import sys,json; print(json.load(open('package.json')).get('version'))"
    exit 0
fi

if [ $dflg -eq 1 ]; then
    tag=$(git describe --tags --abbrev=0 2>/dev/null || true)
    if [ "$tag" = "" ]; then
        git log --pretty=oneline
    else
        git log --pretty=oneline $tag...
    fi
    exit 0
fi
