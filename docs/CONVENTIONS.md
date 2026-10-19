# Convenções — {{PROJECT_NAME}}

> Carregado automaticamente em cada sessão (via `opencode.json › instructions`). **Mantém curto e prático.**
> Precedência: o que o código existente já faz > este documento > preferências gerais do agente.

## Estrutura

- Código em `src/`, testes em `tests/` (ou junto do código, conforme a stack) — _confirmar com `/bootstrap`_.
- Um módulo = uma responsabilidade. Ficheiros < ~300 linhas, funções < ~40 linhas (referências, não dogmas).

## Reutilização e módulos

- **Procura antes de escrever:** `docs/MODULES.md` + `bash scripts/find-reuse.sh <termos>`.
- Funções puras, entradas/saídas explícitas, sem globais; I/O e estado nas bordas; dependências por parâmetro.
- Regra do 1-2-3: 1 consumidor → privado na feature · 2.º consumidor → `shared/<conceito>/` · 3.º caso → generalizar.
- Cada módulo: ponto de entrada único (API pública mínima), `README.md`, testes sobre a API pública. Importar sempre pelo ponto de entrada.
- Sem `utils`/`helpers` genéricos: agrupar por conceito.

## Nomes

- Ficheiros/pastas: _ex.: `kebab-case`_ · Tipos/classes: `PascalCase` · funções/variáveis: _ex.: `camelCase`_ · constantes: `UPPER_SNAKE_CASE`.
- Nomes dizem **o quê**, não **como**. Evita abreviaturas obscuras. Booleanos: `isX`, `hasX`, `canX`.

## Estilo

- Formatação automática (formatter da stack) — nunca discutir estilo à mão.
- Comentários explicam o **porquê**; o código explica o **como**.
- Sem código morto nem *feature flags* esquecidas.

## Documentação

- Docstring em **tudo** o que é exportado: o quê, parâmetros, retorno, erros, efeitos, exemplo (formato idiomático da stack).
- `README.md` em cada módulo (modelo: `docs/templates/MODULE_README.md`); linha em `docs/MODULES.md` para o que é reutilizável.
- Língua: _identificadores em inglês; docstrings/README em PT-PT_ (ajustar ao projeto).
- Código e docs mudam no mesmo commit.

## Erros e logging

- Erros tratados nas fronteiras; mensagens acionáveis; nunca engolir exceções em silêncio.
- Logs com nível (`debug/info/warn/error`); nunca registar segredos ou dados pessoais.

## Dependências

- Preferir biblioteca padrão. Nova dependência: justificar em `DECISIONS.md` (manutenção, tamanho, licença).

## Git

- Conventional Commits (em inglês). Branches: `feat/…`, `fix/…`, `chore/…` (trabalho longo pode ficar em `ai/<tema>`).

## Específico da stack ({{STACK}})

_A preencher com `/bootstrap`: formatter, linter, gestor de pacotes, estrutura típica._

## Comandos

Ver tabela em `AGENTS.md` §1.
