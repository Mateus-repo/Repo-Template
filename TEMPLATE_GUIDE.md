# Guia do template

Este repositório é um **template** para começar projetos de programação com o [OpenCode](https://opencode.ai) já preparado: documentos de gestão, skills, comandos, agentes, *auto commit* e modo autónomo.

## 1. Começar um projeto novo

```bash
cp -r repo-template meu-projeto && cd meu-projeto     # ou "Use this template" no GitHub
bash scripts/init.sh "Meu Projeto" "Descrição curta" "Stack (ex.: TypeScript + React)"
opencode
```

`init.sh` substitui os placeholders (`{{PROJECT_NAME}}`, `{{DESCRIPTION}}`, `{{STACK}}`, `{{DATE}}`), inicia o git se necessário, move este guia para `docs/TEMPLATE_GUIDE.md` e faz o primeiro commit.

Depois, dentro do OpenCode:

1. `/bootstrap` — o agente deteta a stack, preenche comandos de build/teste, `ARCHITECTURE.md`, `docs/CONVENTIONS.md`, primeiro `ROADMAP.md` e `TODO.md`.
2. Revê o `ROADMAP.md` (é a tua direção; o agente propõe, tu decides).
3. `/autopilot 120` — e deixa-o trabalhar.

## 2. Como o agente trabalha

- **Arranque:** lê `AGENTS.md`, `PROGRESS.md`, `QUESTIONS.md`, `TODO.md`, `ROADMAP.md`.
- **Loop:** escolhe tarefa → planeia → implementa → verifica → regista → commita → repete.
- **Autonomia:** só pára para bloqueios reais. Antes de perguntar, analisa a dúvida de **5 ângulos** (precedente, intenção, evidência externa, risco/reversibilidade, simplicidade) e decide, registando em `DECISIONS.md`.
- **Perguntas:** vão para `QUESTIONS.md` (em lote, com recomendação por defeito). **Responde por baixo da pergunta** no ficheiro, ou no chat; o agente lê na próxima sessão.
- **Ideias:** vão para `IDEAS.md`; não viram código sem passarem para o `TODO.md`/`ROADMAP.md`.

## 3. Comandos

| Comando | O que faz |
|---------|-----------|
| `/bootstrap` | Configura o projeto (1ª vez) |
| `/start` | Ritual de arranque de sessão e arranque de trabalho |
| `/plan <objetivo>` | Decompõe um objetivo em tarefas com critérios de aceitação |
| `/autopilot [min]` | Trabalho autónomo longo (omissão: 120 min) |
| `/autopilot-stop` | Pára o autopilot |
| `/decide <questão>` | Análise de 5 ângulos + decisão registada |
| `/review [âmbito]` | Auto-revisão → `REVIEW.md` |
| `/structure [âmbito]` | Audita pastas, documentação e reutilização, e corrige |
| `/module <nome>` | Cria um módulo novo (API pública, README, testes) e regista-o |
| `/commit` | Commit organizado do trabalho pendente |
| `/handoff` | Fecha a sessão: atualiza docs e resume |
| `/status` | Resumo rápido do estado do projeto |

## 4. Auto commit

O plugin `.opencode/plugins/auto-commit.js` faz um commit `chore(wip): checkpoint` sempre que a sessão fica idle e há alterações.

- Config em `.opencode/autocommit.json` (ver abaixo) ou `AUTOCOMMIT=off` no ambiente.
- Bloqueia ficheiros sensíveis (`.env`, chaves…) e padrões de segredos no diff.
- **Não** faz push por defeito (`"push": true` para ativar).
- Os commits "a sério" (com boa mensagem) são feitos pelo agente via skill `auto-commit` / `scripts/commit.sh`.

```json
{ "enabled": true, "push": false, "minIntervalSeconds": 15, "blockSecrets": true, "message": "chore(wip): checkpoint" }
```

## 5. Autopilot (experimental)

`/autopilot` escreve `.opencode/autopilot.state` e o plugin `autopilot.js` volta a enviar um prompt de continuação quando o agente fica idle, até:

- acabar o orçamento de tempo (omissão 120 min) — dá uma última mensagem para fazer handoff;
- `scripts/autopilot.sh stop "motivo"` (o agente chama quando acaba ou fica bloqueado);
- existir um ficheiro `STOP` na raiz;
- erro ou interrupção tua (Esc) — **pára de propósito**;
- limite de iterações (omissão 60).

Se a API de plugins mudar e o plugin não funcionar, o resto continua válido: o agente segue o protocolo de autonomia do `AGENTS.md` na mesma, só não é re-acordado automaticamente.

## 6. Personalizar

- **Permissões:** `opencode.json` (`git push` pede confirmação; `push --force`, `sudo`, `rm -rf /` negados).
- **Skills:** `.opencode/skills/<nome>/SKILL.md`. O nome da pasta tem de ser igual ao `name:`. Mantém < 500 linhas e descrições "insistentes" sobre *quando* usar.
- **Língua:** os docs estão em PT-PT; os commits em inglês. Muda o `AGENTS.md` (secção 9) se preferires outra.
- **Skills globais:** copia pastas de `.opencode/skills/` para `~/.config/opencode/skills/` para usares em todos os projetos.

## 7. Estrutura, documentação e reutilização

O template empurra o agente a escrever código **modular e reutilizável**, bem organizado e documentado:

- **Skills:** `reusable-modules` (reutilizar antes de escrever; funções puras; API mínima; regra do 1-2-3), `project-structure` (onde vive cada coisa; por funcionalidade; mover com segurança) e `code-documentation` (docstrings, README por módulo, comentários só para o porquê).
- **Catálogo:** `docs/MODULES.md` lista módulos e funções reutilizáveis. O agente consulta-o (e corre `scripts/find-reuse.sh`) antes de criar código novo, e atualiza-o no mesmo commit.
- **Modelo de README de módulo:** `docs/templates/MODULE_README.md`.
- **Auditoria:** `scripts/structure-check.sh` (ficheiros grandes, módulos sem README, pastas `utils/misc/old`, backups, placeholders). Só avisa; `--strict` falha. Corre dentro de `scripts/check.sh`.
- **Comandos:** `/module <nome>` cria um módulo completo; `/structure` audita e corrige.
- **Ajustar limites:** `MAX_FILE_LINES=400 bash scripts/structure-check.sh`.

## 8. Windows

Os scripts são `bash` (Git Bash ou WSL). Os plugins são JavaScript puro e funcionam em qualquer sistema.

## 9. Resolução de problemas

| Sintoma | Verifica |
|---------|----------|
| Skill não aparece | `SKILL.md` em maiúsculas; frontmatter com `name` e `description`; `name` = nome da pasta; reinicia o OpenCode |
| Plugin não corre | Ficheiro em `.opencode/plugins/`; reinicia; vê o log do OpenCode |
| Auto commit não commita | `git status`; `.opencode/autocommit.json`; segredo detetado (ver log) |
| Agente pára demasiado cedo | Usa `/autopilot`; confirma que `QUESTIONS.md` não tem bloqueios |
