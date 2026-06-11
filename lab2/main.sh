#!/bin/bash
# lab2/main.sh — Gerenciamento de usuários
# Narrativa: Tux configura acesso do novo colega urubu100

SPTECH_HOME="/home/sptech"
LAB_DIR="$SPTECH_HOME/lab2_tux"

section "Resetando ambiente do lab2"

if id "urubu100" &>/dev/null; then
  userdel -r urubu100 2>/dev/null || true
fi

reset_dir "$LAB_DIR"
mkdir -p "$LAB_DIR/instrucoes"

section "Montando cenário"

cat > "$LAB_DIR/checklist.txt" << 'EOF'
Checklist de onboarding:
[ ] Criar usuario
[ ] Definir senha
[ ] Criar diretorio de trabalho
[ ] Verificar acesso
EOF

cat > "$LAB_DIR/instrucoes/bemvindo_urubu100.txt" << 'EOF'
Ola! Voce foi adicionado ao time de infra.
Sua primeira tarefa esta no diretorio /home/urubu100 apos seu acesso ser criado.
EOF

cat > "$LAB_DIR/instrucoes/ramais.txt" << 'EOF'
Ramal TI: 2001
Ramal RH: 2002
Ramal Financeiro: 2003
EOF

chmod 644 "$LAB_DIR/checklist.txt"
chmod 644 "$LAB_DIR/instrucoes/bemvindo_urubu100.txt"
chmod 644 "$LAB_DIR/instrucoes/ramais.txt"

set_owner "$LAB_DIR"

section "Concluído"
echo ""
echo "  Diretório base: $LAB_DIR"
echo ""
echo "  Acesse com: cd ~/lab2_tux"
echo ""