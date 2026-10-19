---
description: Auto-revisão do trabalho recente → REVIEW.md (e corrige os blockers)
---
Usa a skill `code-review` para rever: $ARGUMENTS (se vazio: alterações desde o último milestone/revisão).

Estado do git:
!`git log --oneline -15`
!`git diff --stat HEAD~5..HEAD 2>/dev/null | tail -20`

Regista a revisão em `REVIEW.md`, corrige tudo o que for `blocker`/`major` simples, abre tarefas em `TODO.md` para o resto e manda ideias para `IDEAS.md`. Para uma segunda opinião independente, delega no subagente `@reviewer`.
