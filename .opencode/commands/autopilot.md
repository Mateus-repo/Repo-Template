---
description: Trabalho autónomo longo (omissão 120 min) — só pára em bloqueios reais
---
Ativa o autopilot e começa a trabalhar.

1. Corre: `bash scripts/autopilot.sh start $ARGUMENTS` (sem argumento = 120 minutos).
2. Segue a skill `autonomous-workflow` e o protocolo de `AGENTS.md` §4 do início ao fim.
3. Não peças confirmações. Dúvidas → 5 ângulos (`decide-without-asking`) → decide e regista em `DECISIONS.md`.
4. Faz commit por unidade lógica e checkpoint de `PROGRESS.md` a cada ~25 min (usa `bash scripts/clock.sh` para veres o tempo).
5. Quando acabar o trabalho útil, ficares bloqueado em tudo ou o tempo esgotar: `bash scripts/autopilot.sh stop "motivo"` e escreve o resumo final.
