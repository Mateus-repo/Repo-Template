# DECISIONS — {{PROJECT_NAME}}

> Registo de decisões (ADR curto). **Regista sempre** que escolheres entre alternativas reais, sobretudo quando decidiste *tu* em vez de perguntar.
> Lê antes de reabrir um assunto. Para mudar uma decisão: cria uma nova que a **substitui** (não apagues a antiga).
> Estados: `Aceite` · `Provisória` (assumida sem confirmação do utilizador — revisitar se for importante) · `Substituída por D-NNN`.

## Modelo

```
### D-NNN — Título  (AAAA-MM-DD) — Estado
- **Contexto:** o problema e as restrições.
- **Opções:** A) … B) … C) …
- **Análise (5 ângulos):** precedente · intenção · evidência externa · risco/reversibilidade · simplicidade — 1 linha cada.
- **Decisão:** a escolhida e porquê.
- **Pressupostos:** o que assumi sem confirmar.
- **Como reverter:** passos/custo.
- **Consequências:** o que muda; o que fica mais difícil.
```

## Decisões

### D-001 — Usar o template de repositório com documentos de gestão  ({{DATE}}) — Aceite
- **Contexto:** projeto novo, desenvolvido com agentes de IA durante sessões longas.
- **Decisão:** manter estado do projeto em ficheiros `.md` versionados (`PROGRESS`, `TODO`, `DECISIONS`…) para sobreviver a compressão de contexto e a trocas de sessão.
- **Como reverter:** apagar os ficheiros de gestão e simplificar `AGENTS.md`.

### D-002 — Código modular, reutilizável e documentado por defeito  ({{DATE}}) — Aceite
- **Contexto:** muito código é escrito por agentes em sessões longas; sem regras, aparecem duplicação, gavetas `utils` e módulos que ninguém sabe usar.
- **Decisão:** reutilizar antes de escrever (`docs/MODULES.md` + `scripts/find-reuse.sh`); funções puras e módulos com API pública mínima; estrutura por funcionalidade; tudo o que é público documentado (docstring + README de módulo). Skills `reusable-modules`, `project-structure`, `code-documentation`.
- **Como reverter:** remover as três skills e as regras correspondentes em `AGENTS.md` §5 e `docs/CONVENTIONS.md`.
