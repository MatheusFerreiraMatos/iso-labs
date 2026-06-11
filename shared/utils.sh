#!/bin/bash
# shared/utils.sh
# Funções utilitárias compartilhadas entre todos os labs.

SPTECH_HOME="/home/sptech"

section() {
  echo ""
  echo "--- $1 ---"
}

reset_dir() {
  local dir="$1"
  rm -rf "$dir"
  mkdir -p "$dir"
}

create_file() {
  local path="$1"
  local content="${2:-}"
  printf "%b\n" "$content" > "$path"
}

set_owner() {
  local path="$1"
  local owner="${2:-sptech:sptech}"
  chown -R "$owner" "$path"
}