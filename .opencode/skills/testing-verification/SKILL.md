---
name: testing-verification
description: Provar que o trabalho está realmente feito — escrever testes, correr scripts/check.sh, definir verificação manual reprodutível e aplicar a Definition of Done. Usa SEMPRE antes de marcar uma tarefa como concluída, depois de corrigir um bug, ao adicionar lógica não-trivial, quando não existirem testes, ou quando algo "parece funcionar". Nada está feito sem evidência.
---

# Testing & verification

> "Acho que funciona" ≠ "verifiquei que funciona".

## Definition of Done (resumo)

Critério de aceitação cumprido **com evidência** · `bash scripts/check.sh` verde · testes novos/atualizados · docs afetados atualizados · `TODO`/`PROGRESS` atualizados · commit feito · regressões conhecidas registadas em `BUGS.md`.

## Ciclo

1. **Antes de codar:** relê o critério de aceitação. Como o vou provar? Escreve isso primeiro (teste, ou passos manuais).
2. **Teste primeiro quando possível** — sobretudo em bugs: reproduz com um teste que **falha**, corrige, vê-o passar (regressão garantida).
3. **Implementa** o mínimo para passar.
4. **Corre** `bash scripts/check.sh` (e o teste específico).
5. **Verifica o comportamento real** — corre a aplicação/comando/ecrã, não só os testes. Testes verdes com a app a falhar acontece.
6. **Regista a evidência** em `PROGRESS.md` (nº de testes, comando manual, output relevante).

## Que testes escrever

| Tipo | Quando | Características |
|------|--------|-----------------|
| Unitário | lógica pura, regras, parsing, cálculos | rápido, sem I/O, muitos |
| Integração | módulos juntos, BD, ficheiros, API própria | alguns, isolados, dados de teste |
| Ponta-a-ponta | fluxos críticos do utilizador | poucos, estáveis |
| Regressão | cada bug corrigido | nomeia o bug (`test_B004_empty_config`) |

Boas práticas: um comportamento por teste · nomes que descrevem o comportamento (`returns_error_when_input_is_empty`) · padrão **Arrange–Act–Assert** · sem dependência de ordem/hora/rede · dados mínimos · mocks só nas fronteiras · casos-limite (vazio, nulo, máximo, negativo, unicode, concorrência).

## Quando não dá para automatizar (UI, jogos, hardware)

- Escreve **passos manuais reprodutíveis** em `docs/TESTING.md` ou na tarefa: "1. abrir X · 2. clicar Y · 3. esperado: Z".
- Extrai a lógica para funções puras testáveis e deixa a camada de UI **fina**.
- Para UI web, considera testes de componentes/E2E; para jogos, testes da lógica/simulação sem render.
- Se **não consegues** verificar (sem ambiente, sem ferramentas), diz-o **explicitamente** no resumo — "implementado, **não verificado**: motivo" — e abre tarefa em `TODO.md`.

## Falhas

- **Teste falha:** lê o erro inteiro; não "ajustes o teste para passar" a não ser que o teste esteja objetivamente errado (e justifica-o). Skill `debugging`.
- **Teste flaky:** não o ignores nem repitas até passar — encontra a causa (tempo, ordem, estado partilhado, rede); regista em `docs/TESTING.md › Problemas conhecidos` e `BUGS.md`.
- **Não consegues corrigir já:** nunca apagues/saltes testes para fazer o check passar sem registar em `BUGS.md` e no commit.

## Anti-padrões

- Marcar `[x]` por ter escrito o código.
- Testes que afirmam o que o código faz (espelho) em vez do que **deve** fazer.
- Cobertura como objetivo em si (cobre comportamento, não linhas).
- Verificação só "no caminho feliz".
- Declarar sucesso com base num comando que não correu ou cujo output não leste.
