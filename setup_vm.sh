#!/bin/bash
# setup_vm.sh
# Roda UMA VEZ na VM modelo como root.
# Após executar, salvar a VM como .ova para distribuir aos alunos.

set -e

GITHUB_RAW="https://raw.githubusercontent.com/MatheusFerreiraMatos/iso-labs/main"
INSTALL_DIR="/opt/iso-labs"
SERVICE_PATH="/etc/systemd/system/lab@.service"

echo ""
echo "=========================================="
echo "  ISO Labs — Setup da VM modelo"
echo "=========================================="
echo ""

if [ "$EUID" -ne 0 ]; then
  echo "[ERRO] Execute com sudo: sudo bash setup_vm.sh"
  exit 1
fi

echo "[1/4] Criando $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"

echo "[2/4] Baixando scripts do GitHub..."
curl -fsSL "$GITHUB_RAW/shared/utils.sh" -o "$INSTALL_DIR/utils.sh"
curl -fsSL "$GITHUB_RAW/runner.sh"        -o "$INSTALL_DIR/runner.sh"
chmod +x "$INSTALL_DIR/runner.sh"
chmod +x "$INSTALL_DIR/utils.sh"

echo "[3/4] Instalando lab@.service..."
curl -fsSL "$GITHUB_RAW/lab%40.service" -o "$SERVICE_PATH"

echo "[4/4] Recarregando systemd..."
systemctl daemon-reload

echo ""
echo "=========================================="
echo "  Setup concluído!"
echo ""
echo "  Teste com:"
echo "    sudo systemctl start lab@1"
echo "    ls ~/estagio_tux"
echo ""
echo "  Após validar, exporte a VM como .ova."
echo "=========================================="
echo ""
