# MODULES — {{PROJECT_NAME}}

> Catálogo de módulos e de funções/componentes **reutilizáveis**. É a primeira coisa a consultar **antes de escrever código novo** (skill `reusable-modules`) e a última a atualizar **antes de fechar uma tarefa** (skill `code-documentation`).
> Procura rápida: `bash scripts/find-reuse.sh <termo> [termo…]`.
> Regra: se é exportado e usado (ou utilizável) fora do seu ficheiro, tem linha aqui. Código e catálogo mudam no **mesmo commit**. Se discordam, o código manda.

## Módulos

| Módulo | Caminho | Propósito (1 frase) | API pública (resumo) | Depende de |
|--------|---------|---------------------|----------------------|------------|
| _a preencher_ | | | | |

## Funções, tipos e componentes reutilizáveis

Agrupa por **conceito** (texto, datas, validação, ficheiros, HTTP…), não por ficheiro.

| Nome | Caminho | Assinatura | O que faz | Pura? | Erros | Usado por |
|------|---------|------------|-----------|-------|-------|-----------|
| _a preencher_ | | | | | | |

<!-- Exemplo de linha:
| `chunk` | `src/shared/lists/chunk.ts` | `chunk<T>(items: T[], size: number): T[][]` | Divide uma lista em blocos de tamanho fixo | sim | `RangeError` se `size` ≤ 0 | `billing`, `export` |
-->

## Duplicações conhecidas (a resolver)

_Código semelhante que ainda não foi unificado, com a tarefa associada (`T-NNN`). Vazio é o objetivo._

## Convenções do catálogo

- Remove a linha quando remove o código. Não deixes entradas órfãs.
- Mudou a assinatura ou os erros → atualiza a linha **e** a docstring **e** o README do módulo.
- Função privada (só usada no próprio módulo) **não** entra aqui.
