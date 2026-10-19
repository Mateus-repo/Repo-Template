---
name: refactoring-modular
description: Escrever código modular e refatorar com segurança — responsabilidades claras, ficheiros e funções pequenas, baixo acoplamento, sem duplicação — sem mudar comportamento. Usa SEMPRE que um ficheiro passar das ~300 linhas, uma função das ~40, houver duplicação, acoplamento forte, "god objects", antes de adicionar uma funcionalidade a código confuso, ao desenhar a estrutura de um módulo novo, ou quando o utilizador pedir para organizar, limpar ou modularizar código.
---

# Refactoring & modular code

Refactor = mudar **estrutura** mantendo **comportamento**. Se o comportamento muda, não é refactor.

Ver também: `reusable-modules` (desenhar para reutilização), `project-structure` (onde vive cada coisa) e `code-documentation` (README e docstrings a acompanhar a mudança).

## Princípios de código modular

- **Uma responsabilidade por módulo/função** ("e" na descrição = dois módulos).
- **Fronteiras explícitas:** cada módulo expõe uma interface pequena e esconde o resto.
- **Dependências numa direção** (ex.: `ui → app → domain`). O domínio não conhece UI, BD ou framework.
- **Dados à volta, efeitos nas bordas:** lógica pura no centro (fácil de testar); I/O, rede, UI e estado global nas margens.
- **Composição > herança.** **Nomes > comentários.** **Pequeno > esperto.**
- Referências (não dogmas): função < ~40 linhas · ficheiro < ~300 linhas · ≤ 4 parâmetros · aninhamento ≤ 3 níveis.

## Sinais de que é preciso refatorar (code smells)

| Smell | Remédio |
|-------|---------|
| Função/ficheiro enorme | Extrair função/módulo por responsabilidade |
| Duplicação (3+ vezes) | Extrair função/componente comum (não antes de 2–3 casos reais) |
| Muitos parâmetros | Objeto de parâmetros / tipo próprio |
| `if/switch` repetido por tipo | Polimorfismo / tabela de despacho |
| Nomes vagos (`data`, `manager`, `utils`) | Renomear pelo que **é** ou **faz** |
| Pasta `utils`/`helpers` a crescer | Mover para o módulo dono do conceito |
| Estado global / singletons por todo o lado | Passar dependências explicitamente |
| Ciclos de dependência | Extrair a parte comum para um terceiro módulo; inverter dependência |
| Comentários a explicar código confuso | Reescrever o código; deixar comentário só para o *porquê* |
| Código morto / flags esquecidas | Apagar (o git guarda o histórico) |

## Procedimento seguro

1. **Rede de segurança:** há testes a cobrir o código? Se não, escreve **testes de caracterização** (fixam o comportamento atual) antes de mexer. Sem testes possíveis → verificação manual escrita.
2. `bash scripts/check.sh` verde **antes** de começar. Commit limpo de base (ou tag `before-refactor-<tema>`).
3. **Passos pequenos**, cada um com check verde e commit próprio (`refactor(scope): …`). Mover → renomear → extrair → simplificar, **uma coisa de cada vez**.
4. Nunca misturar refactor com mudança de comportamento ou correção de bug no mesmo commit.
5. Reorganização grande: **estrangula** gradualmente (cria o novo caminho ao lado, migra chamadas, remove o antigo) em vez de reescrever tudo de uma vez.
6. Atualiza `ARCHITECTURE.md` (módulos, dependências) e `DECISIONS.md` se mudou a estrutura.
7. Se o check falhar e não perceberes porquê em ~2 tentativas: `git revert`/`git checkout` do passo e tenta um passo mais pequeno.

## Desenhar um módulo novo

1. Escreve em 1 frase **o que faz** e **o que não faz**.
2. Define a **interface pública** mínima (funções/tipos) antes da implementação.
3. Decide as dependências permitidas (segue a regra em `ARCHITECTURE.md`).
4. Escreve o primeiro teste contra a interface.
5. Estrutura típica: `modulo/` com `index` (API pública), ficheiros internos por responsabilidade, testes ao lado ou em `tests/`.

## Quando NÃO refatorar

- Sem testes nem forma de verificar → primeiro cria a rede de segurança.
- Código que vai ser apagado/substituído em breve.
- A meio de uma funcionalidade ou bug — termina, commita, depois refatora.
- "Por gosto": só refatora com motivo (vai mexer ali, está a atrasar, causa bugs).

## Regra do escuteiro

Deixa o código **ligeiramente melhor** do que o encontraste nas zonas por onde passas — mas em commits separados e sem alargar o âmbito da tarefa. Refactors maiores → tarefa própria em `TODO.md`.
