#!/bin/bash
# lab2/main.sh — Aprofundamento: flags, caminhos, ocultos e curingas
# Narrativa: Tux agora precisa organizar um diretório mais complexo
# e entender os detalhes de cada comando.

# ---------------------------------------------------------------------------
# CENÁRIO
# ---------------------------------------------------------------------------
# O script cria um ambiente com arquivos ocultos, links e subpastas.
# O aluno precisa usar flags (-l, -a, -R), curingas (*) e entender
# a diferença entre caminhos absolutos/relativos.
# ---------------------------------------------------------------------------

SPTECH_HOME="/home/sptech"
BASE="$SPTECH_HOME/profundo_tux"

section "Resetando ambiente do lab2"
reset_dir "$BASE"

section "Montando cenário avançado"

# 1. Estrutura de diretórios (mais profunda)
mkdir -p "$BASE/projetos/src/antigo"
mkdir -p "$BASE/projetos/bin"
mkdir -p "$BASE/documentos_antigos"
mkdir -p "$BASE/backups"

# 2. Arquivos "normais" (visíveis)
create_file "$BASE/relatorio_final.txt"    "Relatorio final aprovado pelo gestor."
create_file "$BASE/backup_antigo.log"      "Backup realizado em 01/01/2023 - 500MB"
create_file "$BASE/backups/backup_novo.log" "Backup atual - 50MB"

# 3. Arquivo OCULTO (começa com .)
create_file "$BASE/.config_secreto.txt"    "Usuario=admin\nSenha=123456"

# 4. Arquivo com ESPAÇO no nome (clássico problema para iniciantes)
create_file "$BASE/lista de compras.txt"   "1. Pao\n2. Leite\n3. Ovos"

# 5. Arquivos dentro das subpastas
create_file "$BASE/projetos/src/main.c"    "#include <stdio.h>\nint main() { return 0; }"
create_file "$BASE/projetos/src/antigo/old.c" "// Codigo legado"
create_file "$BASE/projetos/bin/executavel"    "#!/bin/bash\necho 'Executando...'"
chmod +x "$BASE/projetos/bin/executavel"

# 6. LINK SIMBÓLICO (para testar ls -l e remoção de link)
ln -s "$BASE/relatorio_final.txt" "$BASE/relatorio_rapido"

# 7. Deixar um diretório propositalmente "cheio" para testar rmdir vs rm -r
# (já está cheio por causa do src/antigo)

# Permissões diferenciadas (um arquivo somente leitura para testar rm -f)
chmod 444 "$BASE/backup_antigo.log"

# Ajustando dono
set_owner "$BASE"

section "Concluído"
echo ""
echo "  Diretório base: $BASE"
echo ""
echo "  DICA: Explore com diferentes flags:"
echo "    ls -l      (detalhes)"
echo "    ls -a      (mostra ocultos)"
echo "    ls -R      (recursivo)"
echo "    ls -la     (combinação)"
echo ""
echo "  Acesse com: cd ~/profundo_tux"
echo ""