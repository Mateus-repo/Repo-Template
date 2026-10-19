#!/usr/bin/env bash
# Auditoria de estrutura, documentação e modularidade.
# Só dá AVISOS (exit 0) por defeito. Com --strict (ou STRICT_STRUCTURE=1) falha se houver avisos.
# Uso: bash scripts/structure-check.sh [--strict]
# Variáveis: MAX_FILE_LINES (omissão 300)
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

STRICT=0
[[ "${1:-}" == "--strict" || "${STRICT_STRUCTURE:-}" == "1" ]] && STRICT=1
MAX="${MAX_FILE_LINES:-300}"
CODE_EXT='(js|jsx|mjs|cjs|ts|tsx|py|rs|go|java|kt|cs|c|cc|cpp|h|hpp|rb|php|swift|gd|lua|vue|svelte)'
warns=0
warn() { warns=$((warns+1)); echo "  ⚠ $*"; }

# lista de ficheiros do projeto (respeita .gitignore quando há git)
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  raw="$(git ls-files -co --exclude-standard)"
else
  raw="$(find . -type f -not -path './.git/*' -not -path '*/node_modules/*' -not -path '*/.venv/*' \
         -not -path '*/dist/*' -not -path '*/build/*' -not -path '*/target/*' | sed 's|^\./||')"
fi
files=""
while IFS= read -r f; do [[ -n "$f" && -f "$f" ]] && files+="$f"$'\n'; done <<<"$raw"

code="$(printf '%s' "$files" | grep -E "\.${CODE_EXT}$" | grep -Ev '(^|/)(node_modules|vendor|dist|build|generated|migrations)/|\.min\.' || true)"
src_code="$(printf '%s\n' "$code" | grep -E '^(src|app|lib)/' || true)"

echo "▶ Estrutura e documentação"

# 1. ficheiros de código demasiado grandes
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  n=$(wc -l < "$f" | tr -d ' ')
  (( n > MAX )) && warn "$f tem $n linhas (> $MAX): dividir por responsabilidade (skill refactoring-modular)"
done <<<"$code"

# 2. módulos (pastas em src/app/lib com ≥ 3 ficheiros de código) sem README.md
mods="$(printf '%s\n' "$src_code" | grep -Ev '(^|/)(tests?|__tests__|fixtures)/' \
  | awk -F/ 'NF>2{d=$1; for(i=2;i<NF;i++) d=d"/"$i; c[d]++} END{for(k in c) if(c[k]>=3) print k}' | sort)"
while IFS= read -r d; do
  [[ -z "$d" ]] && continue
  [[ -f "$d/README.md" ]] || warn "módulo '$d' sem README.md (modelo: docs/templates/MODULE_README.md)"
done <<<"$mods"

# 3. pastas-gaveta e nomes vagos
vague="$(printf '%s' "$files" | awk -F/ '{for(i=1;i<NF;i++) print $i}' | sort -u \
  | grep -Ei '^(utils?|helpers?|misc|stuff|temp|tmp|new|old|final|copy|backup|test2)$' || true)"
while IFS= read -r d; do
  [[ -z "$d" ]] && continue
  warn "pasta '$d': nome vago/gaveta — organizar por conceito (skill project-structure)"
done <<<"$vague"

# 4. ficheiros de backup / cópias
bk="$(printf '%s' "$files" | grep -Ei '(\.(bak|orig|rej|swp)$|~$|(_old|_copy|_backup|-copy)\.[a-z0-9]+$)' || true)"
while IFS= read -r f; do [[ -n "$f" ]] && warn "ficheiro de backup/cópia: $f (o git guarda o histórico)"; done <<<"$bk"

# 5. placeholders esquecidos nos .md
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  case "$f" in .opencode/*|docs/templates/*|TEMPLATE_GUIDE.md|docs/TEMPLATE_GUIDE.md) continue;; esac
  grep -qE '\{\{(PROJECT_NAME|DESCRIPTION|STACK|DATE)\}\}' "$f" && warn "placeholder por substituir em $f"
done <<<"$(printf '%s' "$files" | grep -E '\.md$' || true)"

# 6. catálogo de módulos por preencher quando já há código
if [[ -n "$src_code" && -f docs/MODULES.md ]] && grep -q '_a preencher_' docs/MODULES.md; then
  warn "docs/MODULES.md ainda por preencher e já existe código em src/ (skill code-documentation)"
fi

echo
if (( warns == 0 )); then echo "OK: estrutura sem avisos."; exit 0; fi
echo "$warns aviso(s)."
(( STRICT )) && exit 1
exit 0
