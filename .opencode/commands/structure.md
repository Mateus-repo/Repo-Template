---
description: Audita organização de pastas, documentação e reutilização de código, e corrige
---
Usa as skills `project-structure`, `code-documentation` e `reusable-modules` para auditar: $ARGUMENTS (se vazio: todo o código do projeto).

Avisos automáticos:
!`bash scripts/structure-check.sh`

Faz, por esta ordem, com commits pequenos e separados (nunca misturar com mudanças de comportamento):

1. **Estrutura** — corrige os avisos (ficheiros grandes, pastas-gaveta, nomes vagos) com `git mv`/divisão; `bash scripts/check.sh` verde a cada passo.
2. **Reutilização** — procura duplicação (`bash scripts/find-reuse.sh` com termos das funções suspeitas); unifica em `shared/<conceito>/` ou abre `T-NNN` se for grande.
3. **Documentação** — README em cada módulo sem ele, docstrings nas funções exportadas sem contrato, `docs/MODULES.md` e `ARCHITECTURE.md` sincronizados com o código.
4. Regista o que fizeste em `PROGRESS.md`; o que não coube vai para `TODO.md`; ideias para `IDEAS.md`.
