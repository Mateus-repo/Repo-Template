# REVIEW — {{PROJECT_NAME}}

> Auto-revisões do agente (e revisões do utilizador). Corre `/review` antes de fechar um milestone, antes de commits grandes e depois de blocos longos de trabalho autónomo.
> Skill: `code-review`. Para uma segunda opinião independente usa o subagente `@reviewer`; para atacar um plano usa `@critic`.

## Checklist rápida (por revisão)

- [ ] **Correção:** faz o que o critério de aceitação pede? Casos-limite e erros tratados?
- [ ] **Testes:** cobrem o comportamento novo e os bugs corrigidos? Passam de forma determinística?
- [ ] **Design:** responsabilidades claras, módulos pequenos, acoplamento baixo, sem duplicação evidente?
- [ ] **Legibilidade:** nomes, estrutura, comentários só onde explicam o *porquê*?
- [ ] **Segurança:** input validado, segredos fora do repo, dependências justificadas? (`security-review`)
- [ ] **Performance:** nada claramente quadrático/bloqueante em caminhos quentes?
- [ ] **UI/UX** (se aplicável): estados (vazio/carregar/erro), contraste, foco, responsividade? (`ui-design`)
- [ ] **Docs:** README/ARCHITECTURE/CHANGELOG/CONVENTIONS refletem a realidade?
- [ ] **Git:** commits pequenos, mensagens claras, sem ficheiros que não pertencem?

## Severidade dos achados

`blocker` (não fechar sem corrigir) · `major` · `minor` · `nit` · `idea` (vai para IDEAS.md)

## Revisões

### Modelo

```
### R-NNN — Âmbito (AAAA-MM-DD) — Resultado: ✅ ok / ⚠️ com ressalvas / ❌ não passa
- **Âmbito:** commits/ficheiros revistos.
- **Achados:**
  | # | Severidade | Onde | Problema | Ação | Estado |
  |---|------------|------|----------|------|--------|
- **O que está bem:** …
- **Riscos residuais:** …
```

_Nenhuma revisão ainda._
