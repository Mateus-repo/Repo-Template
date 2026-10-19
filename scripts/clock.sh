#!/usr/bin/env bash
# Relógio da sessão autónoma. O agente não sente o tempo passar — usa isto.
#   bash scripts/clock.sh          -> mostra decorrido / restante
#   bash scripts/clock.sh reset    -> reinicia
# Orçamento: autopilot.state (budget_min) > $AUTONOMY_BUDGET_MIN > 120
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
mkdir -p .opencode
F=.opencode/.session-start
now="$(date +%s)"

if [[ "${1:-}" == "reset" || ! -f "$F" ]]; then echo "$now" > "$F"; fi
start="$(cat "$F")"

budget="${AUTONOMY_BUDGET_MIN:-120}"
if [[ -f .opencode/autopilot.state ]]; then
  b="$(grep -E '^budget_min=' .opencode/autopilot.state | cut -d= -f2 || true)"
  s="$(grep -E '^start=' .opencode/autopilot.state | cut -d= -f2 || true)"
  a="$(grep -E '^active=' .opencode/autopilot.state | cut -d= -f2 || true)"
  [[ -n "$b" ]] && budget="$b"
  [[ "$a" == "1" && -n "$s" ]] && start="$s"
fi

el=$(( (now - start) / 60 ))
rem=$(( budget - el ))
echo "agora: $(date '+%Y-%m-%d %H:%M')"
echo "decorrido: ${el} min · orçamento: ${budget} min · restante: ${rem} min"
if (( rem <= 0 )); then echo "ORÇAMENTO ESGOTADO → faz handoff (skill session-handoff)."; fi
