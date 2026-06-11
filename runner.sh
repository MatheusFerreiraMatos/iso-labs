#!/bin/bash
# runner.sh — Script fixo na VM. Não editar.
# O conteúdo dos labs fica no GitHub.

LAB="$1"
GITHUB_RAW="https://raw.githubusercontent.com/MatheusFerreiraMatos/iso-labs/main"
TMP_SCRIPT=$(mktemp)

if [ -z "$LAB" ]; then
  echo "[ERRO] Nenhum lab especificado."
  exit 1
fi

echo ""
echo "=========================================="
echo "  ISO Labs — lab$LAB"
echo "=========================================="
echo ""
echo "Preparando ambiente do lab$LAB..."

# Baixa utils e main.sh e concatena num único arquivo
curl -fsSL "$GITHUB_RAW/shared/utils.sh"  >> "$TMP_SCRIPT"
echo ""                                    >> "$TMP_SCRIPT"
curl -fsSL "$GITHUB_RAW/lab$LAB/main.sh"  >> "$TMP_SCRIPT"

# Executa tudo num único shell
bash "$TMP_SCRIPT"

rm -f "$TMP_SCRIPT"

echo ""
echo "Ambiente pronto. Bom lab!"
echo ""
