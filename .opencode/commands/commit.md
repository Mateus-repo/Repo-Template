---
description: Commits organizados (Conventional Commits) do trabalho pendente
---
Usa a skill `auto-commit`.

Estado atual:
!`git status --short`

Corre `bash scripts/check.sh` primeiro. Se passar, separa as alterações em commits lógicos (um por unidade) com `bash scripts/commit.sh "tipo(scope): mensagem" caminhos...`. Se falhar, não commits código partido — corrige ou regista em `BUGS.md`. Contexto extra: $ARGUMENTS
