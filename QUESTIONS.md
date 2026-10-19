# QUESTIONS — {{PROJECT_NAME}}

> Perguntas ao **utilizador**. Só entram aqui **bloqueios reais** (ver `AGENTS.md` §4.3) — depois de analisados os 5 ângulos.
> O agente pergunta **em lote**, dá uma **recomendação por defeito** e continua a trabalhar no que não depende da resposta.
> **Utilizador:** responde por baixo de `Resposta:` (basta uma linha). O agente lê no arranque.

## Modelo

```
### Q-NNN — Pergunta curta  (AAAA-MM-DD) — Prioridade: alta/média/baixa
- **Contexto:** porque é que isto importa.
- **Já tentei (5 ângulos):** precedente: … · intenção: … · evidência: … · risco: … · simplicidade: …
- **Opções:** A) … B) …
- **Recomendação por defeito:** A, porque …  (é o que farei se não houver resposta)
- **Bloqueia:** T-00X (ou "nada, só afina")
- **Entretanto:** o que vou fazer.
- **Resposta:** (utilizador)
```

## Abertas

_Nenhuma._

## Respondidas

_Nenhuma._
