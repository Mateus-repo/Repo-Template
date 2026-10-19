#!/usr/bin/env bash
# Uso: bash scripts/commit.sh "feat(scope): mensagem" [caminhos...]
# - valida Conventional Commits
# - faz stage (de tudo, ou só dos caminhos dados)
# - bloqueia ficheiros sensíveis e padrões de segredos
set -euo pipefail

msg="${1:-}"
shift || true
if [[ -z "$msg" ]]; then echo 'Uso: bash scripts/commit.sh "tipo(scope): mensagem" [caminhos...]' >&2; exit 1; fi

re='^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-zA-Z0-9_./-]+\))?!?: .{3,}'
if ! [[ "$msg" =~ $re ]]; then
  echo "Mensagem fora do formato Conventional Commits: $msg" >&2
  echo "Exemplos: feat(ui): add settings screen | fix(parser): handle empty input | docs: update roadmap" >&2
  exit 2
fi

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Não é um repositório git." >&2; exit 1; }

if [[ $# -gt 0 ]]; then git add -- "$@"; else git add -A; fi

if git diff --cached --quiet; then echo "Nada para commitar."; exit 0; fi

# ficheiros sensíveis
bad_files="$(git diff --cached --name-only | grep -Ei '(^|/)(\.env(\.[^/]*)?|[^/]*\.pem|[^/]*\.p12|[^/]*\.pfx|id_rsa|id_ed25519|credentials\.json)$' | grep -Evi '\.env\.(example|sample|template)$' || true)"
if [[ -n "$bad_files" ]]; then
  echo "BLOQUEADO — ficheiros sensíveis em stage:" >&2; echo "$bad_files" >&2
  git reset -q
  exit 3
fi

# padrões de segredos nas linhas adicionadas
pat='-----BEGIN [A-Z ]*PRIVATE KEY-----|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{36,}|github_pat_[A-Za-z0-9_]{50,}|(^|[^A-Za-z0-9])sk-[A-Za-z0-9_-]{32,}|xox[baprs]-[A-Za-z0-9-]{10,}'
added="$(git diff --cached -U0 --no-color | grep -E -e '^\+[^+]' || true)"
if printf '%s\n' "$added" | grep -Eq -e "$pat"; then
  echo "BLOQUEADO — possível segredo no diff. Remove-o (usa variáveis de ambiente) e tenta de novo." >&2
  git reset -q
  exit 3
fi

git commit -q -m "$msg"
echo "Commit feito: $(git log -1 --pretty='%h %s')"
