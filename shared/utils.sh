#!/bin/bash
# shared/utils.sh
# Funções utilitárias compartilhadas entre todos os labs.

SPTECH_HOME="/home/sptech"

# Imprime seção
section() {
  echo ""
  echo "--- $1 ---"
}

# Remove e recria diretório (reset limpo)
reset_dir() {
  local dir="$1"
  rm -rf "$dir"
  mkdir -p "$dir"
}

# Cria arquivo com conteúdo opcional
create_file() {
  local path="$1"
  local content="${2:-}"
  echo "$content" > "$path"
}

# Define dono e permissão
set_owner() {
  local path="$1"
  local owner="${2:-sptech:sptech}"
  chown -R "$owner" "$path"
}