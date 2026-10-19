---
name: decide-without-asking
description: Método de decisão em 5 ângulos para resolver dúvidas sozinho antes de perguntar ao utilizador. Usa SEMPRE que sentires vontade de fazer uma pergunta, tiveres duas ou mais opções, requisitos ambíguos, uma escolha de design/biblioteca/estrutura, ou quando o utilizador usar /decide. Obriga a analisar precedente, intenção, evidência externa, risco/reversibilidade e simplicidade, e a registar a decisão. Só termina em pergunta ao utilizador se for um bloqueio real.
---

# Decide without asking — os 5 ângulos

Objetivo: transformar "não sei, pergunto" em "analisei de 5 maneiras e decidi — ou sei exatamente o que perguntar".

## Passo 0 — É mesmo uma decisão?

Se a resposta está no código, nos docs, no `git log`, em `DECISIONS.md` ou na documentação oficial → **vai ler**. Muitas "dúvidas" acabam aqui.

## Passo 1 — Formula a questão e as opções

Uma frase para a questão. 2–4 opções reais (inclui "não fazer nada" e "a mais simples").

## Passo 2 — Os 5 ângulos (1–3 linhas cada, por opção quando relevante)

1. **Precedente** — O que o repo já faz? Há padrão, convenção, decisão anterior (`DECISIONS.md`, `docs/CONVENTIONS.md`, `git log`, código vizinho)? Consistência vence quase sempre.
2. **Intenção** — Que objetivo do utilizador isto serve (`README`, `ROADMAP`, `PROGRESS`, mensagens, respostas anteriores em `QUESTIONS.md`)? Qual opção ele escolheria? Qual o *espírito* do pedido, não só a letra?
3. **Evidência externa** — O que dizem a documentação oficial, o ecossistema, benchmarks, issues conhecidos? (skill `research-first`.) Não assumas APIs de memória.
4. **Risco e reversibilidade** — Pior caso se estiver errado? Custo de desfazer (minutos vs. dias)? Toca em dados, segurança, dinheiro, API pública? **Barato e reversível → decide já.**
5. **Simplicidade e custo** — Qual cumpre os requisitos com menos partes móveis e menos código? **Pré-mortem:** "daqui a um mês esta opção falhou — porquê?" Para cada opção, o motivo mais provável.

*Opcional para decisões grandes:* delega o plano no subagente `@critic` (advogado do diabo) para um 6.º olhar.

## Passo 3 — Pontuar e decidir

| Opção | Precedente | Intenção | Evidência | Risco (↓ melhor) | Simplicidade | Total |
|-------|-----------|----------|-----------|------------------|--------------|-------|
| A | | | | | | |

Escala 0–2 por ângulo (risco: 2 = baixo). Não é matemática — é uma forma de ver se **um** ângulo domina ou se há empate.

- **Uma opção claramente à frente (ou confiança ~70%+)** → decide.
- **Empate e reversível** → escolhe a mais simples e reversível; ou faz um **spike** ≤ 15 min para ganhar evidência.
- **Empate e irreversível/alto impacto** → possível bloqueio real (Passo 5).

## Passo 4 — Registar e seguir

Escreve em `DECISIONS.md` (`D-NNN`): contexto, opções, 5 ângulos numa linha cada, decisão, **pressupostos**, **como reverter**. Estado `Provisória` se assumiste algo sobre o que o utilizador quer. Depois continua o trabalho.

## Passo 5 — Quando é mesmo um bloqueio

Só perguntas se, depois dos 5 ângulos, se verifica **um** de:
- precisas de credenciais/acessos/segredos que não tens;
- ação destrutiva, irreversível ou com custo financeiro;
- ambiguidade de **produto** que muda substancialmente o resultado e os ângulos 1–2 não decidem;
- contradiz uma instrução explícita do utilizador;
- sai do âmbito do repo (publicar, enviar, apagar dados de terceiros).

Como perguntar bem (`QUESTIONS.md`, `Q-NNN`):
- Contexto em 1–2 linhas e o que ficou **já tentado** (os 5 ângulos, resumidos).
- Opções fechadas (A/B/C), não "o que achas?".
- **Recomendação por defeito** + "farei isto se não houver resposta".
- O que fica bloqueado e o que farás entretanto.
- Agrupa várias perguntas num lote.

Depois: marca as tarefas dependentes como bloqueadas e **continua com outras**.

## Anti-padrões

- Perguntar para "confirmar" algo que já decidiste bem.
- Perguntar o que se resolve lendo 3 ficheiros.
- Fazer a mesma pergunta de 3 maneiras.
- Decidir em silêncio (sem registo) — a decisão desaparece.
- Paralisar por escolhas pequenas: nomes, ordem, formatação → decide em 10 segundos.
