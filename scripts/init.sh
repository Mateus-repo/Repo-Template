#!/usr/bin/env bash
# Uso: bash scripts/init.sh "Nome do Projeto" "Descrição curta" "Stack"
# Substitui placeholders, inicia o git e faz o primeiro commit.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

NAME="${1:-}"
DESC="${2:-}"
STACK="${3:-por definir}"
if [[ -z "$NAME" || -z "$DESC" ]]; then
  echo 'Uso: bash scripts/init.sh "Nome do Projeto" "Descrição curta" "Stack"' >&2
  exit 1
fi
DATE="$(date +%Y-%m-%d)"

# escapa \ & | para usar em sed com delimitador |
esc() { printf '%s' "$1" | sed -e 's/[\\&|]/\\&/g'; }
N="$(esc "$NAME")"; D="$(esc "$DESC")"; S="$(esc "$STACK")"

shopt -s nullglob
files=(./*.md docs/*.md)
for f in "${files[@]}"; do
  [[ "$(basename "$f")" == "TEMPLATE_GUIDE.md" ]] && continue
  sed -i.bak \
    -e "s|{{PROJECT_NAME}}|$N|g" \
    -e "s|{{DESCRIPTION}}|$D|g" \
    -e "s|{{STACK}}|$S|g" \
    -e "s|{{DATE}}|$DATE|g" "$f"
  rm -f "$f.bak"
done

# guia do template passa para docs/
if [[ -f TEMPLATE_GUIDE.md ]]; then mv TEMPLATE_GUIDE.md docs/TEMPLATE_GUIDE.md; fi
mkdir -p src && touch src/.gitkeep

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git init -q -b main 2>/dev/null || { git init -q && git checkout -q -b main; }
  echo "Repositório git iniciado."
fi

if [[ -n "$(git status --porcelain)" ]]; then
  git add -A
  git commit -q -m "chore: initialize project from template" && echo "Primeiro commit feito."
fi

left="$(grep -l -e '{{PROJECT_NAME}}' -e '{{DESCRIPTION}}' -e '{{STACK}}' -e '{{DATE}}' ./*.md docs/*.md 2>/dev/null | grep -v 'docs/TEMPLATE_GUIDE.md' || true)"
if [[ -n "$left" ]]; then echo "Atenção: placeholders por substituir em:"; echo "$left"; fi

cat <<MSG

Pronto: $NAME
Próximos passos:
  1. opencode
  2. /bootstrap
  3. /autopilot 120
MSG
