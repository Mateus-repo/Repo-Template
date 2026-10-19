---
name: project-structure
description: Organizar pastas e ficheiros do projeto de forma clara e previsível — onde vive cada coisa, estrutura por funcionalidade, raiz limpa, testes a espelhar o código, nomes consistentes e como mover ou renomear com segurança. Usa SEMPRE ao criar um projeto ou módulo novo, ao criar pastas ou ficheiros, quando não souberes onde colocar algo, quando uma pasta tiver demasiados ficheiros, quando aparecerem pastas utils, helpers ou misc, ou quando o utilizador pedir para organizar, arrumar ou reestruturar o projeto.
---

# Project structure

Objetivo: qualquer pessoa (ou agente) deve **adivinhar onde está** uma coisa em < 10 segundos e **saber onde pôr** uma coisa nova sem pensar.

## Princípios

1. **Por funcionalidade/domínio, não por tipo técnico.** `src/billing/` (com tudo o que é de faturação) > `src/controllers/`, `src/models/`, `src/views/` espalhados. Começa simples (plano) e agrupa quando houver 2+ funcionalidades.
2. **Previsível:** o mesmo padrão em todos os módulos. Se um módulo tem `index`, `types`, `README.md` e `tests`, todos têm.
3. **Raiz limpa:** na raiz só manifestos, docs de gestão, config e as pastas de topo (`src/`, `tests/`, `docs/`, `scripts/`, `assets/`). Código e dados soltos na raiz = desordem.
4. **Pouco fundo:** ≤ 3–4 níveis de profundidade. Pasta com 1 só ficheiro raramente se justifica; pasta com > ~10 ficheiros irmãos pede subdivisão por conceito.
5. **Dependências numa direção** (regra em `ARCHITECTURE.md`): `app/ui → features → core`; `infra` implementa o que o `core` precisa. Nunca o contrário.
6. **Testes a espelhar o código:** `src/a/b.ext` ↔ `tests/a/b.test.ext` (ou testes ao lado, conforme a stack — uma só convenção em todo o projeto).
7. **Gerado ≠ fonte:** builds, caches, dados locais e segredos fora do git (`.gitignore`).

## Layout base (agnóstico de linguagem)

```
src/
  core/            # regras de negócio puras: sem I/O, sem framework
  <feature>/       # uma pasta por funcionalidade
    index.*        # API pública do módulo (e só ela)
    <ficheiros internos por responsabilidade>
    README.md      # o que faz, API, exemplos (docs/templates/MODULE_README.md)
  shared/          # reutilizável por 2+ módulos, organizado por CONCEITO
    text/  dates/  validation/  http/ ...
  infra/           # adaptadores para o exterior: BD, rede, ficheiros, APIs
  app/             # ponto de entrada e composição (liga as peças)
tests/             # espelha src/
docs/              # CONVENTIONS, MODULES, TESTING, DESIGN, GLOSSARY
scripts/           # utilitários de desenvolvimento
assets/            # imagens, fontes, dados estáticos (se aplicável)
```

## Adaptar à stack (deduz do que já existe; não impor)

| Stack | Estrutura típica |
|-------|------------------|
| Node / TypeScript | `src/<feature>/index.ts`, `tests/` ou `*.test.ts` ao lado; `src/shared/` |
| Python (pacote) | `src/<pacote>/<modulo>/__init__.py` (API pública), `tests/` espelhado |
| Python web (Flask/FastAPI) | `app/` com `blueprints|routers/<feature>/`, `services/` (lógica), `templates/`, `static/`, `tests/` |
| Rust | `src/<mod>/mod.rs`, crates em `crates/` num workspace se crescer |
| Go | `cmd/<app>/`, `internal/<pacote>/`, `pkg/` só se for mesmo para exportar |
| .NET | uma solução, projetos por camada/feature, `*.Tests` por projeto |
| Godot | `scenes/`, `scripts/`, `assets/`, `autoload/`; agrupa por entidade (`player/`: cena + script + assets) |
| Front-end web | `components/<Nome>/`, `pages|routes/`, `hooks|composables/`, `lib/`, `styles/` |

## Onde ponho isto?

| Tenho… | Vai para |
|--------|----------|
| Regra de negócio sem I/O | `core/` (ou o módulo da feature, se só ela a usa) |
| Função usada por 1 feature | Dentro dessa feature (privada) |
| Função usada por 2+ features | `shared/<conceito>/` (ver skill `reusable-modules`) |
| Acesso a BD / rede / disco / API externa | `infra/` (ou `adapters/`) atrás de uma interface |
| Configuração e constantes | `config/` ou módulo de config único; nunca espalhadas |
| Tipos/modelos partilhados | Junto do módulo dono; `shared/types` só se transversais |
| Script de desenvolvimento | `scripts/` (documentado no README) |
| Documentação | `docs/` (por módulo: `README.md` na pasta do módulo) |
| Dados de teste | `tests/fixtures/` |

## Nomes

- Pastas e ficheiros pelo que **são**, na convenção da stack (ver `docs/CONVENTIONS.md`); consistentes em todo o repo.
- **Proibido** como nome de pasta/ficheiro: `misc`, `stuff`, `temp`, `new`, `old`, `final`, `copy`, `backup`, `test2`. O histórico está no git.
- `utils/` e `helpers/` são **gavetas**: aceita-as só como `shared/<conceito>/`. Se encontrares uma gaveta, distribui o conteúdo pelos módulos donos.
- Ficheiro com o nome do que exporta (`parse-config.ts` exporta `parseConfig`). Um conceito principal por ficheiro.

## Quando criar / dividir

- **Criar pasta de módulo** quando há ≥ 2 ficheiros que mudam juntos e formam um conceito.
- **Dividir ficheiro** > ~300 linhas ou com 2+ responsabilidades (skill `refactoring-modular`).
- **Dividir pasta** > ~10 ficheiros irmãos: agrupa por conceito (não por tipo de ficheiro).
- **Não** crias estrutura para o futuro "caso venha a ser preciso": estrutura segue o código real.

## Mover / renomear com segurança

1. `bash scripts/check.sh` verde antes.
2. `git mv` (preserva histórico); atualiza imports/referências com pesquisa global (`grep -rn "nome-antigo"`).
3. **Só moves no commit** (`refactor(structure): move X to Y`), sem mudar comportamento.
4. `bash scripts/check.sh` verde depois. Atualiza `ARCHITECTURE.md`, README do módulo e `docs/MODULES.md` (caminhos) no mesmo commit.
5. Reorganização grande: faz por módulo, um commit de cada vez.

## Auditoria

`bash scripts/structure-check.sh` aponta: ficheiros demasiado grandes, módulos sem README, pastas-gaveta, nomes proibidos, ficheiros `.bak/.orig`, placeholders esquecidos. Corre-o ao fim de cada bloco de trabalho e na triagem de fim de fila (`/structure`).

## Anti-padrões

Estrutura por tipo técnico que obriga a mexer em 5 pastas por funcionalidade · pasta `utils` a crescer · código na raiz · duas pastas para o mesmo conceito · caminhos relativos com `../../../..` (sinal de módulo no sítio errado ou de falta de alias) · ficheiros gerados versionados · cópias `file_old.ext`.
