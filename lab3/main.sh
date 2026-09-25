#!/bin/bash
# lab3/main.sh — Gerenciamento de Usuários e Grupos (aula 15/09/2026)
# Ementa E5 · Sprint 2
# Narrativa: Tux monta o acesso do novo time e desliga o estagiário anterior.
# O script limpa resquícios, monta o ponto de partida e NÃO cria a equipe:
# quem cria usuários e grupos é o aluno, pelas questões do Moodle.

SPTECH_HOME="/home/sptech"
LAB_DIR="$SPTECH_HOME/lab3_tux"

# Tudo que este lab cria ou espera encontrar. (Não usar o nome GROUPS: é variável do bash.)
USUARIOS_LAB="urubu100 batatinha tux estagiario_antigo svc_backup"
GRUPOS_LAB="marketing financeiro projeto_antigo"

section "Resetando ambiente do lab3"

if [ "$EUID" -ne 0 ]; then
  echo "  ERRO: este lab precisa rodar como root (use: sudo systemctl start lab@3)."
  exit 1
fi

# Encerra sessões abertas (ex.: aluno esqueceu de dar exit depois do su)
for u in $USUARIOS_LAB; do
  pkill -KILL -u "$u" 2>/dev/null || true
done
sleep 1

for u in $USUARIOS_LAB; do
  if id "$u" &>/dev/null; then
    userdel -r "$u" 2>/dev/null || true
  fi
  if id "$u" &>/dev/null; then
    echo "  ERRO: o usuário $u ainda existe. Feche todos os terminais que estejam na sessão dele (exit) e reinicie o lab."
    exit 1
  fi
  # Sobra de tentativa anterior (userdel sem -r deixa a pasta para trás)
  rm -rf "/home/$u"
done

for g in $GRUPOS_LAB; do
  if getent group "$g" &>/dev/null; then
    groupdel "$g" 2>/dev/null || true
  fi
  if getent group "$g" &>/dev/null; then
    echo "  ERRO: o grupo $g ainda existe. Reinicie o lab."
    exit 1
  fi
done

reset_dir "$LAB_DIR"

section "Montando cenário"

# Estagiário anterior: usuário padrão com pasta pessoal, arquivo e grupo próprio
groupadd projeto_antigo
adduser --disabled-password --gecos "" --uid 1500 estagiario_antigo >/dev/null
usermod -aG projeto_antigo estagiario_antigo
echo "Relatorio final do estagio - entregue em setembro." > /home/estagiario_antigo/relatorio_final.txt
chown estagiario_antigo:estagiario_antigo /home/estagiario_antigo/relatorio_final.txt

# Conta de serviço: usuário de sistema, sem pasta pessoal e sem login interativo
adduser --system --no-create-home --shell /usr/sbin/nologin svc_backup >/dev/null 2>&1

# Confere o cenário antes de liberar o aluno
if ! id -u estagiario_antigo &>/dev/null || ! id -u svc_backup &>/dev/null || ! getent group projeto_antigo &>/dev/null; then
  echo "  ERRO: não foi possível montar o cenário. Reinicie o lab; se repetir, chame o professor."
  exit 1
fi

cat > "$LAB_DIR/chamado.txt" << 'EOF'
Chamado #3021 - Onboarding do time de Marketing
================================================
Solicitante: RH
Responsavel: Tux (estagiario de TI)

O novo time comeca na segunda-feira e o estagiario anterior foi desligado.
Prepare o acesso da equipe e limpe o que sobrou do desligamento.

Siga as questoes do Moodle, na ordem.
Comandos de administracao exigem sudo.
Quando trocar de usuario, lembre de voltar para o sptech antes de continuar.
EOF

chmod 644 "$LAB_DIR/chamado.txt"

set_owner "$LAB_DIR"

section "Concluído"
echo ""
echo "  Diretório base: $LAB_DIR"
echo "  Ambiente pronto. Leia o chamado: cat ~/lab3_tux/chamado.txt"
echo "  Depois siga as questões do Moodle."
echo ""
