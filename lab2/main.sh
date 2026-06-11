#!/bin/bash
# lab2/main.sh — Gerenciamento de usuários
# Narrativa: Tux precisa criar e configurar o acesso de um novo colega (urubu100)
# O script prepara o contexto. O aluno executa os comandos e responde o Moodle.

SPTECH_HOME="/home/sptech"
LAB_DIR="$SPTECH_HOME/lab2_tux"

section "Resetando ambiente do lab2"

# Remove usuário urubu100 se já existir de execução anterior
if id "urubu100" &>/dev/null; then
  userdel -r urubu100 2>/dev/null || true
fi

# Remove diretório do lab se existir
reset_dir "$LAB_DIR"

section "Montando cenário"

# Cria estrutura de boas vindas para o novo colega
# O aluno vai encontrar isso depois de criar o usuário e navegar
mkdir -p "$LAB_DIR/instrucoes"

create_file "$LAB_DIR/instrucoes/bemvindo_urubu100.txt" "Ola! Voce foi adicionado ao time de infra.\nSua primeira tarefa esta no diretorio /home/urubu100 apos seu acesso ser criado."
create_file "$LAB_DIR/instrucoes/ramais.txt"            "Ramal TI: 2001\nRamal RH: 2002\nRamal Financeiro: 2003"
create_file "$LAB_DIR/checklist.txt"                    "Checklist de onboarding:\n[ ] Criar usuario\n[ ] Definir senha\n[ ] Criar diretorio de trabalho\n[ ] Verificar acesso"

chmod 644 "$LAB_DIR/instrucoes/bemvindo_urubu100.txt"
chmod 644 "$LAB_DIR/instrucoes/ramais.txt"
chmod 644 "$LAB_DIR/checklist.txt"

set_owner "$LAB_DIR"

section "Concluído"
echo ""
echo "  Diretório base: $LAB_DIR"
echo ""
echo "  Acesse com: cd ~/lab2_tux"
echo ""
