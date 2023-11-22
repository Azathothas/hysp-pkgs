#!/usr/bin/env bash

###ENV (Exported or passed Inline)
# #Example:
# export GITHUB_TOKEN="$UNDERPRIVILEGED_READ_ONLY_GH_TOKEN" #Required to get around github api rate limits
# export BIN="eget" #placeholder for [bin] name = "$BIN", must be same in source_bin
# export REPO="zyedidia/eget" #NOT URL, Only $AUTHOR/$REPO_NAME
# export SOURCE_BIN="Azathothas/Toolpacks" #Full: https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/$BIN

##Usage: 
# Actions: BIN="$BIN" REPO="$REPO" SOURCE_BIN="Azathothas/Toolpacks" bash "$GITHUB_WORKSPACE/main/.github/scripts/pkg_metafetcher_x86_64.sh"
# General: 

#Fetch raw json
PKG_METADATA="$(curl -qfsSL "https://api.github.com/repos/$SOURCE_BIN/contents/x86_64/$BIN" -H "Authorization: Bearer $GITHUB_TOKEN")" && export PKG_METADATA="$PKG_METADATA"
REPO_METADATA="$(curl -qfsSL "https://api.github.com/repos/$REPO" -H "Authorization: Bearer $GITHUB_TOKEN")" && export REPO_METADATA="$REPO_METADATA"
RELEASE_METADATA="$(curl -qfsSL "https://api.github.com/repos/$REPO/releases/latest" -H "Authorization: Bearer $GITHUB_TOKEN")" && export RELEASE_METADATA="$RELEASE_METADATA"

#Parse
NAME="$(echo $REPO_METADATA | jq -r '.name')" && export NAME="$NAME"
AUTHOR="$(echo $REPO_METADATA | jq -r '.owner.login')" && export AUTHOR="$AUTHOR"
DESCRIPTION="$(echo $REPO_METADATA | jq -r '.description')" && export DESCRIPTION="$DESCRIPTION"
LANGUAGE="$(echo $REPO_METADATA | jq -r '.language')" && export LANGUAGE="$LANGUAGE"
LICENSE="$(echo $REPO_METADATA | jq -r '.license.name')" && export LICENSE="$LICENSE"
LAST_UPDATED="$(echo $REPO_METADATA | jq -r '.pushed_at')" && export LAST_UPDATED="$LAST_UPDATED"
PKG_VERSION="$(echo $RELEASE_METADATA | jq -r '.tag_name')" && export PKG_VERSION="$PKG_VERSION"
PKG_RELEASED="$(echo $RELEASE_METADATA | jq -r '.published_at')" && export PKG_RELEASED="$PKG_RELEASED"
REPO_URL="$(echo $REPO_METADATA | jq -r '.html_url')" && export REPO_URL="$REPO_URL"
SIZE="$(echo $PKG_METADATA | jq -r '.size' | awk '{printf "%.2f MB\n", $1 / (1024 * 1024)}')" && export SIZE="$SIZE"
SHA="$(echo $PKG_METADATA | jq -r '.sha')" && export SHA="$SHA"
SOURCE_URL="$(echo $PKG_METADATA | jq -r '.download_url')" && export SOURCE_URL="$SOURCE_URL"
STARS="$(echo $REPO_METADATA | jq -r '.stargazers_count')" && STARS="$STARS"
TOPICS="$(echo "$REPO_METADATA" | jq -c -r '.topics')" && export TOPICS="$TOPICS"

#Print for sanity
echo -e "\n\n"
echo -e "[+] Name: $NAME"
echo -e "[+] Description: $DESCRIPTION"
echo -e "[+] Author: $AUTHOR"
echo -e "[+] Repo: $REPO_URL"
echo -e "[+] Stars: $STARS⭐"
echo -e "[+] Version: $PKG_VERSION"
echo -e "[+] Updated On: $PKG_RELEASED"
echo -e "[+] Size: $SIZE"
echo -e "[+] SHA-SUM: $SHA"
echo -e "[+] Source: $SOURCE_URL"
echo -e "[+] Topics: $TOPICS"
echo -e "[+] Language: $LANGUAGE"
echo -e "[+] License: $LICENSE"
echo -e "[+] Last Commit: $LAST_UPDATED"
echo -e "\n\n"
#EOF
