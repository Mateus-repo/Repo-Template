---
description: Cria um módulo novo (estrutura, API pública, README, testes) e regista-o em docs/MODULES.md
---
Usa as skills `reusable-modules`, `project-structure` e `code-documentation` para criar o módulo: $ARGUMENTS

1. **Reutilizar primeiro:** `bash scripts/find-reuse.sh` com termos do módulo. Se já existir algo parecido, estende-o em vez de duplicar.
2. **Sítio:** privado dentro de uma feature, ou `shared/<conceito>/` se for usado por 2+ módulos (segue `ARCHITECTURE.md` e `docs/CONVENTIONS.md`).
3. **Estrutura:** ponto de entrada com a API pública mínima; ficheiros internos por responsabilidade; `README.md` (a partir de `docs/templates/MODULE_README.md`); testes sobre a API pública.
4. **Qualidade:** funções puras com entradas/saídas explícitas, dependências injetadas, docstring em tudo o que exportas.
5. **Registo:** linha em `docs/MODULES.md`; atualiza a tabela de módulos em `ARCHITECTURE.md`.
6. `bash scripts/check.sh` verde → `bash scripts/commit.sh "feat(<modulo>): add <modulo> module"`.
