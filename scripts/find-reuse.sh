#!/usr/bin/env bash
# Reutilizar antes de escrever: procura no catálogo e no código algo que já faça o que precisas.
# Uso: bash scripts/find-reuse.sh termo [termo...]     (ex.: find-reuse.sh chunk split batch)
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1
if [[ $# -eq 0 ]]; then echo "Uso: bash scripts/find-reuse.sh termo [termo...]" >&2; exit 1; fi

in_git=0; git rev-parse --is-inside-work-tree >/dev/null 2>&1 && in_git=1

for t in "$@"; do
  esc="$(printf '%s' "$t" | sed 's/[][\.*^$(){}?+|/]/\\&/g')"
  echo "=== '$t'"

  echo "--- catálogo (docs/MODULES.md)"
  grep -n -i -F -- "$t" docs/MODULES.md 2>/dev/null | head -10

  echo "--- definições no código"
  pat="(function|def|fn|func|class|struct|enum|trait|interface|type|const|let|var|record)[[:space:]].*${esc}"
  if (( in_git )); then
    git grep --untracked -n -i -I -E "$pat" -- . ':!docs' ':!*.md' ':!.opencode' ':!*.lock' ':!*-lock.json' 2>/dev/null | head -25
  else
    grep -rn -i -I -E "$pat" . --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=docs \
      --exclude-dir=.opencode --exclude='*.md' 2>/dev/null | head -25
  fi

  echo "--- nomes de ficheiros"
  if (( in_git )); then git ls-files -co --exclude-standard; else find . -type f -not -path './.git/*' -not -path '*/node_modules/*'; fi \
    | grep -i -F -- "$t" | head -10
  echo
done
echo "Nada relevante? Cria o código no sítio certo (skill reusable-modules) e regista-o em docs/MODULES.md."
