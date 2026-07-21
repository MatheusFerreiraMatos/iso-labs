#!/bin/bash
# lab3/main.sh — Gerenciamento de usuários e grupos (Squad de desenvolvimento)
# O script apenas limpa resquícios de execuções anteriores.
# O aluno deve executar os comandos para criar/modificar/remover.

SPTECH_HOME="/home/sptech"
LAB_DIR="$SPTECH_HOME/lab3_equipe"

section "Resetando ambiente do lab3"

# Remove usuários e grupos que possam ter sobrado de rodadas anteriores
for user in harry hermione ron draco crabbe goyle; do
    if id "$user" &>/dev/null; then
        userdel -r "$user" 2>/dev/null || true
    fi
done

for group in front-end back-end; do
    if getent group "$group" &>/dev/null; then
        groupdel "$group" 2>/dev/null || true
    fi
done

# Cria diretório de trabalho com um arquivo de instruções rápido
reset_dir "$LAB_DIR"

cat > "$LAB_DIR/LEIA-ME.txt" << 'EOF'
Missão: Gerenciar a equipe de desenvolvimento
=============================================
Siga as tarefas do questionário no Moodle.
Todos os comandos devem ser executados com sudo (você tem permissão).
Use os comandos:
  adduser, addgroup, usermod, deluser (ou userdel), delgroup (ou groupdel)
  su, exit, id, groups, ls /home, cat /etc/passwd

Bom trabalho!
EOF

chmod 644 "$LAB_DIR/LEIA-ME.txt"
set_owner "$LAB_DIR"

section "Concluído"
echo ""
echo "  Diretório base: $LAB_DIR"
echo "  Ambiente limpo. Nenhum usuário/grupo pré-existente."
echo "  Leia o arquivo LEIA-ME.txt e vá para o Moodle."
echo ""