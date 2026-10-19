#!/usr/bin/env bash
# Ritual de arranque: contexto rápido do estado do repo.
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

# relógio: reinicia se não existir ou tiver > 8h
F=.opencode/.session-start
if [[ ! -f "$F" ]] || (( $(date +%s) - $(cat "$F" 2>/dev/null || echo 0) > 28800 )); then
  bash scripts/clock.sh reset >/dev/null 2>&1 || true
fi

echo "=== $(date '+%Y-%m-%d %H:%M') ==="
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "--- git ---"
  echo "branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  git status --short | head -20
  echo "--- últimos commits ---"
  git log --oneline -8 2>/dev/null
else
  echo "(não é um repositório git)"
fi

echo "--- PROGRESS › Estado atual ---"
awk '/^## Estado atual/{f=1;next} /^## /{f=0} f' PROGRESS.md 2>/dev/null | sed '/^$/d' | head -15

echo "--- TODO › Agora ---"
awk '/^## Agora/{f=1;next} /^## /{f=0} f' TODO.md 2>/dev/null | sed '/^$/d' | head -10

echo "--- QUESTIONS › Abertas ---"
awk '/^## Abertas/{f=1;next} /^## /{f=0} f' QUESTIONS.md 2>/dev/null | grep -E '^### Q-' | head -10 || true

echo "--- BUGS abertos ---"
awk '/^## Abertos/{f=1;next} /^## /{f=0} f' BUGS.md 2>/dev/null | grep -E '^### B-' | head -10 || true

echo "--- relógio ---"
bash scripts/clock.sh 2>/dev/null
