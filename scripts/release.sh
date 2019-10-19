#!/bin/bash

set -ef

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "pull request build."
    exit 0
fi

curr_ver=$(git describe --tags --abbrev=0 2>/dev/null || true)
next_ver=$(scripts/changelog.sh -v)
if [ "$curr_ver" = "$next_ver" ]; then
    echo 'skip relsease beacase version is same.'
    exit 0
fi

version=$(scripts/changelog.sh -v)
desc=$(scripts/changelog.sh -d | awk '{ORS="\\n";print;}' | tr '"' "'")

body=$(cat << EOF
{
  "tag_name": "$version",
  "target_commitish": "master",
  "name": "$version",
  "body": "$desc",
  "draft": false,
  "prerelease": false
}
EOF
)

curl -sSL -X POST -d "$body" -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$TRAVIS_REPO_SLUG/releases"
