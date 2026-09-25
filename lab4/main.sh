#!/bin/bash
# lab4/main.sh — Permissões de Arquivos no Linux (aula 22/09/2026)
# Ementa E11 · Sprint 2
# Narrativa: Tux organiza a pasta compartilhada do time de Marketing.
# O script limpa resquícios, cria os usuários/grupo e monta arquivos com
# donos e permissões propositalmente ruins. Quem corrige é o aluno,
# pelas questões do Moodle.
#
# A pasta fica em /srv (e não em ~/lab4_tux) porque o home do sptech é 750:
# outros usuários não conseguiriam entrar nele para testar as permissões.

SPTECH_USER="sptech"
LAB_DIR="/srv/lab4_tux"

USUARIOS_LAB="urubu100 urubu200 urubu300"
GRUPOS_LAB="marketing"

section "Resetando ambiente do lab4"

if [ "$EUID" -ne 0 ]; then
  echo "  ERRO: este lab precisa rodar como root (use: sudo systemctl start lab@4)."
  exit 1
fi

if ! id "$SPTECH_USER" &>/dev/null; then
  echo "  ERRO: o usuário $SPTECH_USER não existe nesta máquina. Chame o professor."
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

rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"

section "Montando cenário"

# Time de Marketing: urubu100 e urubu200 são do grupo; urubu300 fica de fora.
# As contas nascem sem senha: o aluno define as que precisar (passwd).
groupadd marketing
for u in $USUARIOS_LAB; do
  adduser --disabled-password --gecos "" "$u" >/dev/null
done
usermod -aG marketing urubu100
usermod -aG marketing urubu200

cd "$LAB_DIR" || exit 1

echo "Vendas do trimestre: 1200 unidades." > relatorio_vendas.txt
echo "chave_api=EXEMPLO-NAO-USAR" > credenciais.txt
printf '#!/bin/bash\necho "deploy ok"\n' > deploy.sh
echo "Campanha Q4: descontos de 10%." > campanha_q4.txt
echo "Lembretes do time." > notas.txt
printf '#!/bin/bash\necho "limpeza ok"\n' > limpar.sh
echo "Ata da reuniao de segunda." > ata_reuniao.txt

mkdir projeto_marketing
echo "Briefing da campanha." > projeto_marketing/briefing.txt
echo "Orcamento aprovado." > projeto_marketing/orcamento.txt

cat > chamado.txt << 'EOF'
Chamado #3022 - Pasta compartilhada do Marketing
=================================================
Solicitante: Gerencia de Marketing
Responsavel: Tux (estagiario de TI)

A pasta do time esta com donos e permissoes fora do lugar:
tem arquivo aberto para qualquer um e arquivo que o time nao consegue usar.
Organize os acessos e depois confirme, testando com os usuarios do time.

Usuarios do time: urubu100, urubu200 e urubu300.
Siga as questoes do Moodle, na ordem.
Comandos de administracao exigem sudo.
Quando trocar de usuario, lembre de voltar para o sptech antes de continuar.
EOF

# Donos e permissões iniciais (propositalmente ruins)
chown -R "$SPTECH_USER":"$SPTECH_USER" "$LAB_DIR"

chown urubu100:marketing relatorio_vendas.txt
chmod 777 relatorio_vendas.txt

chown root:root ata_reuniao.txt
chmod 644 ata_reuniao.txt

chmod 644 credenciais.txt deploy.sh limpar.sh chamado.txt
chmod 664 campanha_q4.txt
chmod 400 notas.txt

chmod 755 "$LAB_DIR" projeto_marketing
chmod 644 projeto_marketing/briefing.txt projeto_marketing/orcamento.txt

# Confere o cenário antes de liberar o aluno
ERRO=0
[ "$(stat -c '%U:%G %a' relatorio_vendas.txt)" = "urubu100:marketing 777" ] || ERRO=1
[ "$(stat -c '%a' credenciais.txt)" = "644" ] || ERRO=1
[ "$(stat -c '%U:%a' ata_reuniao.txt)" = "root:644" ] || ERRO=1
[ "$(stat -c '%a' notas.txt)" = "400" ] || ERRO=1
id -nG urubu100 | grep -qw marketing || ERRO=1
id -nG urubu200 | grep -qw marketing || ERRO=1
id -nG urubu300 | grep -qw marketing && ERRO=1
if [ "$ERRO" -ne 0 ]; then
  echo "  ERRO: não foi possível montar o cenário. Reinicie o lab; se repetir, chame o professor."
  exit 1
fi

section "Concluído"
echo ""
echo "  Diretório base: $LAB_DIR"
echo "  Ambiente pronto. Acesse com: cd $LAB_DIR"
echo "  Leia o chamado: cat chamado.txt"
echo "  Depois siga as questões do Moodle."
echo ""
