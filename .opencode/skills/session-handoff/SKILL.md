---
name: session-handoff
description: Rituais de início e fim de sessão para não perder contexto — arranque (ler PROGRESS, QUESTIONS, TODO, ROADMAP), checkpoints, pausas e handoff final (atualizar docs, verificar, commitar, resumir). Usa SEMPRE no início de qualquer sessão de trabalho, depois de o contexto ser comprimido, quando o utilizador pedir /start, /handoff ou /status, quando o orçamento de tempo estiver a acabar, ou quando fores parar por qualquer motivo.
---

# Session handoff

A sessão seguinte (tu, depois de uma compressão de contexto, ou outro agente) só sabe o que está **escrito nos ficheiros**.

## Arranque (≈ 2 min)

1. `bash scripts/session-start.sh` — data, branch, git, últimos commits, estado, relógio.
2. `PROGRESS.md` → *Estado atual* e última entrada do diário.
3. `QUESTIONS.md` → **há respostas novas?** (campo `Resposta:` preenchido). Aplica-as, move para *Respondidas*, desbloqueia tarefas.
4. `TODO.md` → *Agora* e *Bloqueadas*; `ROADMAP.md` → milestone atual; `BUGS.md` → P0/P1 abertos.
5. `DECISIONS.md` por alto; `ARCHITECTURE.md` se for mexer em estrutura.
6. Se `git status` mostra alterações não commitadas que não são tuas desta sessão (ex.: checkpoint WIP): percebe o que são antes de continuar.
7. Corre `bash scripts/check.sh` para saber o estado **real** (não confies em "estava verde").
8. Define a meta da sessão (1–3 linhas) no `PROGRESS.md` e **começa**.

## Durante: checkpoints (a cada ~25 min ou ao fim de cada tarefa)

- `TODO.md` e `PROGRESS.md › Estado atual` atualizados (o que estou a fazer, o que falta, saúde do build).
- Commit (`auto-commit`).
- `bash scripts/clock.sh` — quanto tempo resta?

## Pausa/interrupção inesperada

Se vais parar sem fim planeado (erro, limite, bloqueio): faz **commit do que está estável**, escreve em `PROGRESS.md › Estado atual` exatamente **onde ficaste e qual é o próximo passo concreto** (comando a correr, ficheiro a editar). Se o repo ficou a meio de algo, diz qual ficheiro/branch.

## Fim de sessão / handoff (≈ 5 min)

1. Termina com segurança o que está a meio — ou isola (branch/stash/commit WIP) e documenta.
2. `bash scripts/check.sh`. Se falha e não corriges: `BUGS.md` + diz no resumo.
3. Atualiza: `TODO.md` · `PROGRESS.md` (*Estado atual* + entrada nova no diário) · `DECISIONS.md` · `BUGS.md` · `CHANGELOG.md` · `ROADMAP.md` (estados dos milestones) · `IDEAS.md`.
4. Triagem rápida de `QUESTIONS.md`: perguntas ainda precisas? agrupadas? com recomendação por defeito?
5. Commit final (`bash scripts/commit.sh "docs: handoff <data>" ...` ou commits lógicos).
6. Se estiver o autopilot ativo: `bash scripts/autopilot.sh stop "<motivo>"`.
7. Resumo ao utilizador (≤ 10 linhas).

### Entrada do diário (modelo)

```
### AAAA-MM-DD HH:MM — título curto  (duração: Xh Ym)
- Meta: …  → Resultado: cumprida / parcial (porquê)
- Feito: T-0xx, T-0yy
- Decisões: D-0xx (resumo)
- Descobertas/problemas: …
- Estado ao sair: build ✅/❌ · testes ✅/❌ (n) · branch · hash
- Próximo passo concreto: …
```

### Resumo final ao utilizador

1. **Feito** (IDs + 1 linha cada)  2. **Decidi eu** (D-NNN, para validares)  3. **Preciso de ti** (Q-NNN, com a minha recomendação)  4. **Estado** (build/testes/branch)  5. **Próximo passo**.
Se algo **não funcionou**, diz-o sem rodeios com o diagnóstico (erro, comando, o que já excluíste).

## Recuperar depois de compressão de contexto

Não confies no resumo — repete o **Arranque**. O estado verdadeiro é: ficheiros `.md` + `git log` + `git status` + `scripts/check.sh`.
