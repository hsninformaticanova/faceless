#!/usr/bin/env bash
# Publica este diretório no GitHub usando uma conta DIFERENTE da que está
# configurada na máquina, sem tocar em ~/.gitconfig, no keyring nem nas
# chaves SSH locais.
#
# A autenticação acontece dentro de um container descartável: o `gh` imprime
# um código, você autoriza no navegador, e ao fim do comando a credencial
# desaparece junto com o container.
#
#   ./publicar.sh hsninformaticanova/faceless
#
set -euo pipefail

REPO="${1:-}"
if [[ -z "$REPO" ]]; then
  echo "uso: $0 <usuario>/<repositorio>" >&2
  echo "exemplo: $0 hsninformaticanova/faceless" >&2
  exit 1
fi

if [[ ! -f index.html ]]; then
  echo "ERRO: rode este script de dentro da pasta site/." >&2
  exit 1
fi

# O container roda como root e o repositório pertence ao usuário do host;
# sem safe.directory o git recusa operar por segurança.
docker run --rm -it \
  -v "$PWD:/site" \
  -w /site \
  -e REPO="$REPO" \
  alpine:3.20 sh -c '
    set -e
    apk add --no-cache git github-cli >/dev/null

    git config --global --add safe.directory /site
    git config --global user.name  "FacelessOS"
    git config --global user.email "noreply@users.noreply.github.com"

    echo
    echo "=== Autorize a conta dona de $REPO ==="
    echo "Vai aparecer um código: abra https://github.com/login/device"
    echo "e cole o código, logado NA CONTA CERTA."
    echo
    gh auth login --hostname github.com --git-protocol https --web

    echo
    echo "Conta autenticada:"
    gh api user --jq .login

    gh auth setup-git

    git remote remove origin 2>/dev/null || true
    git remote add origin "https://github.com/$REPO.git"

    # Cria o repositório se ainda não existir; ignora o erro se já existir.
    gh repo create "$REPO" --public --description "Site do app OAuth FacelessOS" 2>/dev/null || true

    git add -A
    git commit -m "site do app OAuth" 2>/dev/null || echo "(nada novo para commitar)"
    git branch -M main
    git push -u origin main

    echo
    echo "Ativando o GitHub Pages..."
    gh api -X POST "repos/$REPO/pages" \
      -f "source[branch]=main" -f "source[path]=/" 2>/dev/null \
      || echo "(Pages já ativo, ou ative em Settings > Pages)"
  '

USUARIO="${REPO%%/*}"
PROJETO="${REPO##*/}"
echo
echo "Pronto. Em alguns minutos o site responde em:"
echo "  https://${USUARIO}.github.io/${PROJETO}/"
echo
echo "Próximo passo: verifique esse domínio no Google Search Console"
echo "e preencha as três URLs na Tela de permissão OAuth."
