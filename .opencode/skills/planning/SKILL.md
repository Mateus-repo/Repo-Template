---
name: planning
description: Decompor objetivos, features ou milestones em tarefas pequenas, ordenadas e verificáveis, com critérios de aceitação, prioridade e tamanho. Usa SEMPRE que o utilizador pedir "planeia", "/plan", uma nova funcionalidade, um milestone, uma tarefa grande (L) ou vaga, quando a fila de TODO.md estiver vazia, ou antes de começar qualquer trabalho com mais de ~3 passos. Produz entradas prontas para TODO.md e, se necessário, propostas para ROADMAP.md.
---

# Planning

Um bom plano é uma lista de tarefas que um agente consegue **começar sem perguntas** e **provar que acabou**.

## Processo

1. **Objetivo** — 1 frase: que resultado observável existe no fim? Para quem?
2. **Contexto** — lê `ROADMAP.md`, `ARCHITECTURE.md`, `DECISIONS.md`, código relevante. Não planeies no vácuo.
3. **Âmbito** — o que **não** está incluído (vai para `IDEAS.md` se for tentador).
4. **Fatiar verticalmente** — cada tarefa entrega valor ou progresso *verificável* de ponta a ponta (ex.: "criar e listar itens") em vez de camadas soltas ("fazer toda a BD"). Primeiro um **esqueleto andante** (a fatia mais fina que funciona), depois engrossar.
4b. **Reutilização** — para cada tarefa que cria código: o que já existe e posso reutilizar (`docs/MODULES.md`, `scripts/find-reuse.sh`)? Em que módulo vive o código novo (skill `project-structure`)? Inclui na tarefa os docs/README/entrada em `MODULES.md`.
5. **Riscos primeiro** — o que pode matar o plano (API desconhecida, performance, integração)? Faz um **spike** de ≤ 30 min cedo. Regista o resultado.
6. **Ordenar** — dependências → risco → valor → esforço. Tarefas P0/P1 no topo.
7. **Dimensionar** — S (< 30 min) · M (30–90 min) · L (> 90 min → **decompor mais**). Nada de L em `Agora`.
8. **Critérios de aceitação** — verificáveis por comando ou passos manuais explícitos.
9. **Escrever** em `TODO.md` e, se mudar a direção, propor em `ROADMAP.md`.

## Formato de tarefa

```
- [ ] T-021 [P1] [M] Guardar definições em ficheiro — aceitação: reiniciar a app mantém as definições; ficheiro inválido cai nos defaults com aviso; 3 testes novos  (ref: M1, D-004)
```

**Bons critérios:** "`scripts/check.sh` verde e o comando `x --help` lista a opção `--out`" · "com a lista vazia aparece o texto 'Sem itens'" · "300 ms ou menos para 10k linhas (benchmark em `tests/bench`)".
**Maus critérios:** "funciona bem", "código limpo", "melhorar UX".

## Checklist de um bom plano

- [ ] Cada tarefa é S ou M, com aceitação verificável.
- [ ] Há uma fatia ponta-a-ponta cedo (esqueleto andante).
- [ ] Riscos desconhecidos têm spike antes das tarefas que dependem deles.
- [ ] Testes e docs fazem parte das tarefas (não são "depois").
- [ ] Tarefas que criam código indicam o que reutilizam e onde o código novo vai viver.
- [ ] Dependências entre tarefas estão explícitas (`depende de T-0xx`).
- [ ] Nada fora do âmbito entrou; ideias foram para `IDEAS.md`.
- [ ] Sabes qual é a primeira tarefa e podes começá-la agora.

## Planos para milestones

Para cada milestone no `ROADMAP.md`: objetivo mensurável · critérios de conclusão (checkboxes) · riscos conhecidos · dependências. Detalha só o atual e o seguinte; os restantes ficam como objetivos de uma linha.

## Replaneamento

Se a realidade divergiu (estimativa errada ×2, requisito mudou, descoberta nova): para, atualiza `TODO.md`, regista o porquê em `PROGRESS.md` (e `DECISIONS.md` se mudou a abordagem), e continua. Plano desatualizado é pior que nenhum plano.
