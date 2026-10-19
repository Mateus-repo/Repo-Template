---
name: project-docs
description: Como ler, escrever e manter os ficheiros .md de gestão do projeto (README, ROADMAP, TODO, PROGRESS, DECISIONS, QUESTIONS, BUGS, REVIEW, IDEAS, ARCHITECTURE, CHANGELOG, docs/*). Usa SEMPRE que fores criar, atualizar ou consultar qualquer um destes documentos, registar uma decisão, bug, ideia, pergunta ou progresso, ou quando não souberes onde guardar uma informação. Usa também no fim de cada tarefa para saber exatamente o que atualizar.
---

# Project docs — onde vai cada coisa e como escrever

Os `.md` são a **memória do projeto**: sobrevivem a compressão de contexto e a novas sessões. Código e docs mudam **no mesmo commit**.

## 1. Onde guardo isto?

| Tenho… | Vai para | Formato |
|--------|----------|---------|
| Uma tarefa concreta a fazer | `TODO.md` | `- [ ] T-NNN [P?] [S/M/L] Título — aceitação: …` |
| Algo que comecei/acabei | `TODO.md` (marcar) + `PROGRESS.md` | entrada do diário |
| Uma escolha entre alternativas | `DECISIONS.md` | `D-NNN` (ver modelo no ficheiro) |
| Um bug | `BUGS.md` | `B-NNN [P?]` |
| Uma dúvida que só o utilizador resolve | `QUESTIONS.md` | `Q-NNN` com recomendação por defeito |
| "Seria fixe se…" | `IDEAS.md` › Caixa de entrada | 1–2 linhas, com data |
| Achado de revisão | `REVIEW.md` | `R-NNN` + tabela de achados |
| Mudança de direção/milestone | `ROADMAP.md` (propor; utilizador confirma) | tabela de milestones |
| Mudança visível para quem usa | `CHANGELOG.md` › Por lançar | Adicionado/Alterado/Corrigido |
| Mudança de estrutura/módulos | `ARCHITECTURE.md` | tabela de módulos |
| Termo do domínio | `docs/GLOSSARY.md` | tabela |
| Convenção de código nova | `docs/CONVENTIONS.md` | regra curta + exemplo |
| Decisão visual / token de design | `docs/DESIGN.md` | tokens/componentes |

Se a informação serve para **decidir o que fazer a seguir** → `TODO`/`ROADMAP`. Se serve para **entender o que aconteceu** → `PROGRESS`/`DECISIONS`. Se serve para **não esquecer uma ideia** → `IDEAS`.

## 2. Regras de escrita

- **Factos verificáveis, sem floreados.** "Testes: 42 ✅ / 1 ❌ (`test_parse_empty`)" > "quase tudo a funcionar".
- **IDs estáveis** (`T-001`, `D-001`, `B-001`, `Q-001`, `R-001`, `M1`). Incrementa o maior existente; nunca reutilizes.
- **Datas ISO** `AAAA-MM-DD`. Obtém a data real com `date`, não adivinhes.
- **Mais recente primeiro** em diários e listas de histórico.
- **Referências cruzadas:** `T-012` ← `B-003`; `D-004` em `ARCHITECTURE.md`; commit com hash curto.
- **Curto:** `Estado atual` ≤ 30 linhas. Passou das ~400 linhas → arquiva.
- **Honestidade:** se algo falhou ou foi assumido, escreve-o. `DECISIONS.md` distingue `Aceite` de `Provisória`.
- **Sem placeholders esquecidos** (`{{...}}`, `TODO` soltos) em ficheiros já preenchíveis.
- Docs e código discordam → **o código manda**; corrige o doc.

## 3. Rotinas

### Ao terminar uma tarefa
1. `TODO.md`: marca `[x]`, move para *Feitas*, adiciona tarefas derivadas.
2. `PROGRESS.md`: atualiza *Estado atual*; entrada no diário se foi relevante.
3. Se tomaste uma decisão não-trivial → `DECISIONS.md`.
4. Se encontraste/corrigiste um bug → `BUGS.md`.
5. Se há mudança visível → `CHANGELOG.md`. Se mudou estrutura → `ARCHITECTURE.md`.
6. Se te ocorreram ideias → `IDEAS.md` (e **não** as implementes).
7. Commit.

### Ao iniciar sessão
Ver skill `session-handoff` (Arranque).

### Quando o utilizador responde a uma pergunta
Move `Q-NNN` para *Respondidas* com a resposta e a data; aplica; se alterou algo relevante, `DECISIONS.md`; desbloqueia as tarefas em `TODO.md › Bloqueadas`.

### Triagem de ideias (quando a fila acaba)
Para cada ideia: serve o `ROADMAP`? valor/esforço? duplicada? → **Promover** (cria `T-NNN`), **Adiar** ou **Rejeitar** (com motivo, para não rediscutir).

## 4. Modelos rápidos

```
- [ ] T-014 [P1] [M] Validar input do formulário — aceitação: campos inválidos mostram erro; 5 casos-limite testados  (ref: M1)
```
```
### 2026-03-02 14:10 — Parser de configuração  (duração: 1h 20m)
- Feito: T-011, T-012
- Decisões: D-006 (formato TOML)
- Descobertas: B-004 (crash com ficheiro vazio) corrigido
- Estado ao sair: build ✅ · testes ✅ (57) · branch main · a1b2c3d
- Próximo passo: T-013 mensagens de erro
```
```
### D-006 — Formato de configuração: TOML  (2026-03-02) — Provisória
- Contexto: precisamos de config legível por humanos, com comentários.
- Opções: A) JSON B) YAML C) TOML
- Análise: precedente (nenhum) · intenção (utilizador edita à mão) · evidência (TOML tem parser padrão na stack) · risco (baixo, fácil converter) · simplicidade (TOML)
- Decisão: C
- Pressupostos: utilizador não precisa de aninhamento profundo
- Como reverter: converter com script (~1h)
```
