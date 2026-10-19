---
name: auto-commit
description: Fazer commits git pequenos, frequentes e bem descritos (Conventional Commits), com verificação de segredos, e perceber o plugin de auto commit que guarda checkpoints. Usa SEMPRE que terminares uma unidade lógica de trabalho, antes de mudar de tarefa, quando o utilizador pedir /commit, "guarda", "faz commit", ou quando houver alterações por commitar. Cobre mensagens, granularidade, branches, push, o que nunca commitar e como recuperar de erros.
---

# Auto commit

Dois mecanismos complementares:

1. **Tu** fazes commits com significado (`scripts/commit.sh`) — o histórico legível.
2. **O plugin** `auto-commit.js` faz `chore(wip): checkpoint` quando a sessão fica idle — rede de segurança contra perda de trabalho.

## Quando commitar

Depois de **cada unidade lógica** que deixa o repo num estado coerente: uma funcionalidade pequena, um fix, um refactor, uma atualização de docs. Regra: se tiveres de escrever "e" na mensagem, provavelmente são dois commits.

Antes de commitar: `bash scripts/check.sh` verde. Código partido não vai para commit "a sério" (o checkpoint WIP automático é a única exceção — e é isso mesmo que ele é).

## Como

```bash
bash scripts/commit.sh "feat(settings): persist user preferences"            # tudo o que mudou
bash scripts/commit.sh "docs: update roadmap after M1" ROADMAP.md PROGRESS.md  # só alguns ficheiros
```

O script valida o formato, faz stage, **bloqueia ficheiros sensíveis e padrões de segredos** e commita. Para separar alterações misturadas, faz vários commits com caminhos específicos (ou `git add -p`).

## Mensagens — Conventional Commits (inglês)

`tipo(âmbito): resumo no imperativo, minúsculas, sem ponto, ≤ 72 caracteres`

| Tipo | Quando |
|------|--------|
| `feat` | funcionalidade nova visível |
| `fix` | correção de bug |
| `refactor` | muda estrutura sem mudar comportamento |
| `perf` | melhora desempenho |
| `test` | só testes |
| `docs` | só documentação |
| `style` | formatação (sem lógica) |
| `build` / `ci` | build, dependências, pipeline |
| `chore` | manutenção, tarefas diversas |
| `revert` | reverte um commit |

Corpo (opcional, quando o *porquê* não é óbvio): linha em branco + 1–3 linhas sobre **porquê** e trade-offs. Rodapé: `Refs: T-012, B-003`; mudança incompatível: `feat(api)!: …` + `BREAKING CHANGE: …`.

Exemplos bons: `fix(parser): handle empty config file` · `refactor(order): extract price calculation` · `test(cart): cover negative quantity`.
Maus: `update`, `fix stuff`, `wip`, `mudanças`.

## O que nunca commitar

`.env*` (exceto `.env.example`), chaves privadas, tokens, credenciais, dumps de dados reais, binários grandes gerados, `node_modules`, builds. Se o script bloquear: **remove o segredo**, usa variável de ambiente e atualiza `.env.example`. Se um segredo **já foi commitado**: considera-o comprometido → regista em `QUESTIONS.md` (precisa de rotação pelo utilizador) e não tentes reescrever histórico partilhado sem pedido.

## Branches

- Trabalho curto: na branch atual. Trabalho longo/experimental: `ai/<tema>` ou `feat/<tema>`.
- Antes de operações arriscadas (refactor grande, migração): cria uma branch ou uma tag `before-<tema>`.
- Nunca `git push --force`, nunca reescrever histórico partilhado, nunca `reset --hard` com trabalho por guardar (as permissões em `opencode.json` já protegem).
- `git push` pede confirmação; não é necessário para trabalhar. (Quiser push automático: `"push": true` em `.opencode/autocommit.json`.)

## Checkpoints WIP

Os commits `chore(wip): checkpoint (N ficheiros)` são normais. Não os "limpes" (squash/rebase) sem o utilizador pedir. Quando pedirem, `git rebase -i` interativo não funciona no agente: usa `git reset --soft <base>` + commits novos organizados.

## Se algo correr mal

| Situação | Ação |
|----------|------|
| Commitaste ficheiro a mais | `git reset --soft HEAD~1`, ajusta o stage, recommita |
| Mensagem errada (último commit, não publicado) | `git commit --amend -m "…"` |
| Commit partiu algo | `git revert <hash>` (não reescreve histórico) |
| Perdeste alterações | `git reflog` + `git checkout <hash> -- ficheiro` |
| Plugin não commita | `git status`; `.opencode/autocommit.json`; log do OpenCode (segredo detetado?) |

## Desligar/ajustar o plugin

`.opencode/autocommit.json` → `{ "enabled": false }` ou variável de ambiente `AUTOCOMMIT=off`.
