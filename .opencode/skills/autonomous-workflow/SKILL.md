---
name: autonomous-workflow
description: Como trabalhar de forma autónoma durante sessões longas (~2 horas ou mais) sem interromper o utilizador. Usa SEMPRE que o utilizador pedir trabalho longo/autónomo, usar /autopilot, disser "continua", "trabalha sozinho", "faz o que for preciso", ou quando tiveres uma fila de tarefas por cumprir. Cobre o loop de trabalho, gestão do tempo, checkpoints, o que fazer quando a fila acaba, como sobreviver a compressão de contexto e quando (e só quando) parar.
---

# Autonomous workflow

**Meta:** entregar o máximo de trabalho verificado, em sessões de ~2h, **sem** pedir input ao utilizador a não ser em bloqueios reais.

## Mentalidade

- Tu és o responsável pela decisão. O utilizador delegou para não ser interrompido.
- Um palpite razoável, registado e reversível vale mais que uma pergunta que bloqueia horas.
- Mas autonomia ≠ imprudência: verifica tudo, protege dados, não saias do âmbito.

## Setup (1 minuto)

1. `bash scripts/session-start.sh` → contexto + relógio.
2. Ler `PROGRESS.md`, `QUESTIONS.md`, `TODO.md`, `ROADMAP.md`, `BUGS.md`.
3. Confirma o orçamento: `bash scripts/clock.sh` (omissão 120 min).
4. Define a **meta da sessão** em 1–3 linhas (ex.: "fechar M1: T-004..T-009") e escreve-a no topo da entrada de hoje em `PROGRESS.md`.

## Loop

```
repetir:
  tarefa = topo de TODO › Agora   (senão: ROADMAP; senão: §"Quando a fila acaba")
  se tarefa é L ou vaga → decompor (skill planning)
  implementar em passos pequenos
  verificar (scripts/check.sh + critério de aceitação)  → skill testing-verification
  registar (TODO, PROGRESS, DECISIONS/BUGS/CHANGELOG)    → skill project-docs
  commit                                                 → skill auto-commit
  a cada ~25 min: checkpoint (PROGRESS › Estado atual) + bash scripts/clock.sh
  se restam < 10 min → começar handoff
```

Não escrevas mensagens para o utilizador entre tarefas. Escreve ficheiros.

## Quando surge uma dúvida

1. Primeiro tenta resolver **lendo** (código, docs, git log, DECISIONS).
2. Depois skill `decide-without-asking` (5 ângulos) → decide e regista.
3. Só se for **bloqueio real** → `QUESTIONS.md` (com recomendação por defeito) e **passa a outra tarefa**.

Bloqueio real = credenciais/acessos que não tens · ação destrutiva/irreversível ou com custo · ambiguidade de produto que muda muito o resultado · contradiz instrução explícita · sai do âmbito do repo.

## Quando uma tarefa falha ou encravas

- 2 tentativas falhadas na mesma abordagem → pára, muda de estratégia (skill `debugging`: hipóteses alternativas).
- 30+ min numa só tarefa sem progresso mensurável → regista em `BUGS.md`/`QUESTIONS.md`, marca a tarefa como bloqueada, **avança** para outra.
- Nunca deixes o repo partido ao mudar de tarefa: ou funciona, ou está num commit/branch isolado, ou foi revertido.

## Quando a fila acaba

Sem inventar âmbito, por ordem: (1) lacunas de testes · (2) `/review` ao trabalho recente e corrigir blockers · (3) refactor de smells já conhecidos · (4) sincronizar docs ↔ código · (5) triagem de `IDEAS.md` (promover só o que serve o ROADMAP). Se nada disto fizer sentido → termina.

## Sobreviver à compressão de contexto

O contexto pode ser resumido a meio. Defesas:
- `PROGRESS.md › Estado atual` sempre verdadeiro (o que estou a fazer, o que falta, estado dos testes).
- Cada tarefa tem critério de aceitação **escrito** em `TODO.md`.
- Decisões em `DECISIONS.md`, não só na cabeça.
- Depois de uma compressão: repete o ritual de arranque (não confies no resumo).

## Parar (só nestes casos)

- Orçamento de tempo esgotado → handoff (skill `session-handoff`).
- Fila vazia e nada útil a fazer → `bash scripts/autopilot.sh stop "concluído"`.
- **Tudo** o que resta está bloqueado → regista em `QUESTIONS.md`, `bash scripts/autopilot.sh stop "bloqueado: <resumo>"`.
- O utilizador interrompeu ou pediu para parar.

## Resumo final (≤ 10 linhas)

Feito (IDs) · Decisões tuas (D-NNN) · Bloqueado/perguntas (Q-NNN) · Estado (build/testes/branch) · Próximo passo.
Se algo **não funcionou**, di-lo e inclui o diagnóstico (erro, comando, o que já excluíste).
