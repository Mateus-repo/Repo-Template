# ARCHITECTURE — {{PROJECT_NAME}}

> Como o sistema está organizado **hoje** (não como gostaríamos). Atualizar no mesmo commit que muda a estrutura.
> Se este documento contradiz o código, o código manda — corrige o documento.

## Visão geral

<!-- Um parágrafo + diagrama simples (ASCII ou Mermaid). -->
_A preencher com `/bootstrap`._

```mermaid
flowchart LR
    A[Entrada] --> B[Núcleo] --> C[Saída]
```

## Estrutura de pastas

```
src/
  ...
```

## Módulos e responsabilidades

| Módulo | Responsabilidade | Depende de | Notas |
|--------|------------------|------------|-------|
| _a preencher_ | | | |

**Regra de dependências:** _ex.: `ui → app → domain`; `domain` não importa nada de fora._

Catálogo de funções/componentes reutilizáveis: `docs/MODULES.md`. Cada módulo tem o seu `README.md`.

## Fluxos principais

1. _ex.: Utilizador faz X → módulo A valida → módulo B persiste → resposta_

## Dados e persistência

_Modelos principais, onde e como são guardados, migrações._

## Integrações externas

| Serviço/API | Para quê | Configuração (variáveis) | Falha → comportamento |
|-------------|----------|--------------------------|------------------------|

## Decisões relevantes

Ver `DECISIONS.md` (referenciar D-NNN aqui).

## Limitações e dívida técnica conhecidas

_Lista curta e honesta._
