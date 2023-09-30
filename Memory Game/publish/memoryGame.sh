#!/bin/sh
echo -ne '\033c\033]0;Memory Game\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/memoryGame.x86_64" "$@"
