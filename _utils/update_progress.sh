#!/usr/bin/env bash

# Purpose: Update progress bar :)
# Date   : 2018 Aug 12th
# Author : Ky-Anh Huynh

_START_DIR="$(dirname "${BASH_SOURCE[0]:-.}")/"
_VI_DIR="$_START_DIR/../"
_EN_DIR="$_START_DIR/../../dlang-tour-english/"

_TOTAL="$(find "$_EN_DIR" -type f -iname "*.md" | wc -l)"
_CURRENT="$(find "$_VI_DIR"/{basics,welcome,gems} -type f -iname "index.yml" -exec cat {} \; | grep '^- '| wc -l)"
_PERCENT="$(( $_CURRENT * 100 / $_TOTAL ))"

echo ":: translated: $_CURRENT, total: $_TOTAL, percent: $_PERCENT"

cd "$_START_DIR" || exit
echo "<progress max=\"100\" value=\"$_PERCENT\"><strong>Progress: $_PERCENT% done.</strong></progress>" \
  > "progress.html"

wkhtmltoimage  --width 100 --height 24 progress.html progress.svg
#sed -i -e '/viewBox=/d' progress.svg
#sed -i -e 's/<svg width=.*/<svg/' progress.svg
sed -i -e 's/font-family="Bitstream Vera Sans".*//' progress.svg
