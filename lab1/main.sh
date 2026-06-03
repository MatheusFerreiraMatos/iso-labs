#!/bin/bash
# lab1/main.sh — Comandos básicos: navegação, listagem, disco e manipulação de arquivos
# Narrativa: Tux, novo estagiário de infraestrutura.
# O script monta o cenário. O aluno executa os comandos e responde o Moodle.

# ---------------------------------------------------------------------------
# CENÁRIO
# ---------------------------------------------------------------------------
# O script cria um ambiente "bagunçado" no home do sptech.
# O aluno precisa navegar, inspecionar, organizar e responder o que encontrou.
# As respostas corretas no Moodle só são possíveis executando os comandos certos.
# ---------------------------------------------------------------------------

SPTECH_HOME="/home/sptech"
BASE="$SPTECH_HOME/estagio_tux"

section "Resetando ambiente do lab1"
reset_dir "$BASE"

section "Montando cenário"

# Estrutura de diretórios
mkdir -p "$BASE/documentos"
mkdir -p "$BASE/downloads"
mkdir -p "$BASE/temp"

# Arquivos espalhados (simulando bagunça do primeiro dia)
create_file "$BASE/bem_vindo.txt"         "Ola Tux! Bem-vindo ao time de infraestrutura."
create_file "$BASE/pendencias.txt"        "1. Organizar arquivos\n2. Checar espaco em disco\n3. Enviar relatorio ao gestor"
create_file "$BASE/downloads/manual.txt"  "Manual do sistema - versao 1.0"
create_file "$BASE/downloads/lixo.txt"    "Arquivo temporario - pode apagar"
create_file "$BASE/temp/rascunho.txt"     "Rascunho do relatorio mensal."

# Arquivo que o aluno deve mover para documentos/Relatorios (tarefa 8)
create_file "$BASE/tarefa_diaria.txt"     "Atividades do dia:\n- Verificar servidores\n- Atualizar documentacao\n- Reuniao com o time"

# Diretório que o aluno vai criar (Relatórios) NÃO existe — ele que cria
# Diretório temp existe e deve ser excluído recursivamente (tarefa 10)

# Permissões
chmod 644 "$BASE/bem_vindo.txt"
chmod 644 "$BASE/pendencias.txt"
chmod 644 "$BASE/tarefa_diaria.txt"
chmod 755 "$BASE/documentos"
chmod 755 "$BASE/downloads"
chmod 755 "$BASE/temp"

set_owner "$BASE"

section "Concluído"
echo ""
echo "  Diretório base: $BASE"
echo ""
echo "  Acesse com: cd ~/estagio_tux"
echo ""