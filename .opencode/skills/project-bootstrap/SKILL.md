---
name: project-bootstrap
description: Configurar um projeto novo ou um template acabado de copiar — detetar a stack, preencher comandos em AGENTS.md, ARCHITECTURE.md, docs/CONVENTIONS.md, README, ROADMAP e TODO iniciais, garantir que scripts/check.sh funciona e ficar pronto para trabalho autónomo. Usa SEMPRE quando o utilizador pedir /bootstrap, quando AGENTS.md ainda tiver comandos "TODO" ou placeholders {{...}}, quando o repo estiver vazio/novo, ou ao adotar este template num projeto existente.
---

# Project bootstrap

Objetivo: em ~15–30 min, passar de "template com placeholders" a "projeto pronto para trabalho autónomo, com comandos reais e plano inicial".

## Passos

### 1. Reconhecer o terreno
- Existe código? `ls`, ficheiros de manifesto (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `*.csproj`/`*.sln`, `project.godot`, `pom.xml`, `build.gradle`…).
- `git log --oneline | head`, README existente, issues/notas do utilizador (`$ARGUMENTS` do comando).
- Projeto **vazio**: usa a descrição/stack dos placeholders em `README.md`/`AGENTS.md`. Se a stack é `por definir`, decide-a pelos 5 ângulos (`decide-without-asking`) com base no objetivo e regista em `DECISIONS.md` (ex.: `D-002 — Stack`).

### 2. Placeholders
Se ainda existirem `{{PROJECT_NAME}}`, `{{DESCRIPTION}}`, `{{STACK}}`, `{{DATE}}` nos `.md` da raiz/`docs/`: corre `bash scripts/init.sh "Nome" "Descrição" "Stack"` (se tiver a informação) ou substitui à mão. Datas com `date +%Y-%m-%d`.

### 3. Comandos reais
Descobre e **testa de facto** cada comando (instalar, correr, build, testes, lint). Preenche a tabela em `AGENTS.md §1` e `docs/TESTING.md`. Se algum não existir, cria a tarefa em `TODO.md` para o adicionar (ex.: configurar linter/formatter).

### 4. `scripts/check.sh`
`bash scripts/check.sh` deteta stacks comuns. Corre-o: se não cobre o projeto (monorepo, stack rara), cria `scripts/check.local.sh` com os passos reais (lint → typecheck → test → build) e `exit` não-zero em falha. Tem de ser **rápido** e **determinístico**.

### 5. Documentos
- `ARCHITECTURE.md`: estrutura de pastas real, módulos, fluxos, dependências (ou o plano inicial, se vazio).
- `docs/CONVENTIONS.md`: formatter/linter, nomes e estrutura **deduzidos do código existente**; não impor o que o projeto não usa. Secção da stack preenchida.
- `README.md`: o que faz, como correr, estrutura. Sem inventar funcionalidades que não existem.
- `docs/DESIGN.md`: se tem UI, preenche a direção e tokens a partir do que existe (ou propõe); se não tem UI, **apaga** o ficheiro e retira-o da tabela em `AGENTS.md §3`.
- `docs/GLOSSARY.md`: termos do domínio já visíveis.
- `docs/MODULES.md`: se já há código, cataloga módulos e funções reutilizáveis existentes; se é vazio, deixa o cabeçalho. Cria `README.md` nos módulos principais (modelo `docs/templates/MODULE_README.md`).
- **Estrutura:** compara as pastas reais com a skill `project-structure`; se estiver desorganizada, **não reorganizes tudo agora** — cria tarefas em `TODO.md` (uma por módulo). Define em `ARCHITECTURE.md` a regra de dependências e onde vive o código partilhado.
- `.gitignore`/`.editorconfig`: ajusta à stack (ex.: `bin/`, `obj/`, `.godot/`).
- `.env.example` se há configuração por ambiente.

### 6. Roadmap e fila inicial
- `ROADMAP.md`: visão em 1–3 frases, princípios, fora de escopo, M0 (fundações) e M1 (MVP) com critérios mensuráveis. Se o utilizador não definiu direção, propõe uma **versão provisória** e marca-a como tal (`DECISIONS.md` → `Provisória`).
- `TODO.md`: 5–15 tarefas S/M com aceitação (skill `planning`), a primeira já em *Agora*. Substitui a tarefa `T-001` (bootstrap) marcando-a feita.

### 7. Linha de base
`bash scripts/check.sh` → regista o estado em `PROGRESS.md › Estado atual` (build/testes) e, se houver falhas pré-existentes, em `BUGS.md`. Commit: `chore: bootstrap project configuration`.

### 8. Perguntas (só as essenciais)
Se, depois dos 5 ângulos, houver ambiguidade de produto que bloqueia o M1, escreve-a em `QUESTIONS.md` com recomendação por defeito — e **continua** com o que não depende dela.

## Critério de "pronto"

- [ ] Nenhum `{{...}}` nos documentos preenchíveis; comandos em `AGENTS.md` sem `TODO` (ou com tarefa associada).
- [ ] `bash scripts/check.sh` corre e o resultado está registado.
- [ ] `ARCHITECTURE.md`, `ROADMAP.md`, `TODO.md` refletem a realidade.
- [ ] `docs/MODULES.md` preenchido (ou cabeçalho pronto) e regra de estrutura/dependências definida.
- [ ] Primeira tarefa em *Agora* tem aceitação verificável.
- [ ] Commit feito; resumo curto ao utilizador (stack, comandos, milestones, perguntas).

## Adotar o template num projeto existente

Copia `.opencode/`, `scripts/`, `opencode.json`, os `.md` de gestão e `docs/`. **Não** sobrescrevas README/.gitignore existentes — faz *merge*. Extrai estado atual do projeto para `PROGRESS.md`/`ARCHITECTURE.md` e transforma backlog existente em `TODO.md`.
