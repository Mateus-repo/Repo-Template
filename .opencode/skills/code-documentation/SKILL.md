---
name: code-documentation
description: Documentar o código e o projeto em camadas — docstrings em tudo o que é público, README em cada módulo, catálogo docs/MODULES.md, comentários só para o porquê, exemplos de uso — e manter a documentação sempre sincronizada com o código. Usa SEMPRE ao criar ou alterar funções, classes, componentes ou módulos exportados, ao criar uma pasta de módulo, antes de dar uma tarefa como feita, quando o utilizador pedir para documentar, comentar ou explicar o código, e ao rever documentação desatualizada.
---

# Code documentation

Documentar **tudo o que outra parte do programa (ou outra pessoa) vai usar**. Código sem contrato escrito não é reutilizável: obriga a ler a implementação.

## As 4 camadas

| Camada | Onde | Conteúdo | Obrigatório para |
|--------|------|----------|------------------|
| 1. Projeto | `README.md`, `ARCHITECTURE.md` | O que é, como correr, como está organizado | Sempre |
| 2. Módulo | `<modulo>/README.md` (modelo: `docs/templates/MODULE_README.md`) | Propósito, o que **não** faz, API pública, exemplo, dependências, notas | Todo o módulo/pasta com ≥ 3 ficheiros de código |
| 3. Símbolo | Docstring/comentário de documentação ao lado da função/classe/tipo | Contrato completo (abaixo) | Tudo o que é **exportado/público** |
| 4. Linha | Comentário no código | O **porquê** não óbvio (decisão, workaround, armadilha) | Só quando necessário |

Mais o **catálogo** `docs/MODULES.md`: uma linha por função/módulo reutilizável (skill `reusable-modules`).

## Contrato de uma função pública

Escreve, por esta ordem (omite o que não se aplica):

1. **Uma frase** no imperativo/presente: o que faz (não como).
2. **Parâmetros:** nome, tipo, significado, restrições (ex.: `> 0`, não vazio), valores por defeito.
3. **Retorno:** tipo e significado, incluindo casos especiais (vazio, `null`, não encontrado).
4. **Erros:** que falhas pode haver e como são sinalizadas (exceção/`Result`/código).
5. **Efeitos secundários:** I/O, estado mutado, rede, tempo, aleatoriedade. Se for **pura**, di-lo.
6. **Exemplo mínimo** executável (o melhor teste da API; idealmente doctest/exemplo testado).
7. Complexidade ou limites **só** se relevantes (ex.: O(n²), thread-safety).

### Formato por linguagem (usa o idiomático da stack)

```ts
/**
 * Divide `items` em blocos de tamanho `size`.
 * Pura. Não altera o array original.
 *
 * @param items Lista a dividir.
 * @param size  Tamanho de cada bloco (inteiro > 0).
 * @returns Lista de blocos; o último pode ser menor. Lista vazia → `[]`.
 * @throws {RangeError} se `size` não for inteiro positivo.
 * @example chunk([1,2,3,4,5], 2) // [[1,2],[3,4],[5]]
 */
```

```python
def chunk(items: list[T], size: int) -> list[list[T]]:
    """Divide `items` em blocos de tamanho `size`. Pura.

    Args:
        items: Lista a dividir.
        size: Tamanho de cada bloco (int > 0).
    Returns:
        Lista de blocos; o último pode ser menor. Vazia -> [].
    Raises:
        ValueError: se `size` não for inteiro positivo.
    Example:
        >>> chunk([1, 2, 3, 4, 5], 2)
        [[1, 2], [3, 4], [5]]
    """
```

Rust: `///` com secções `# Errors`, `# Panics`, `# Examples` (doctests). Go: comentário a começar pelo nome (`// Chunk divide…`). C#: `/// <summary>`, `<param>`, `<returns>`, `<exception>`. GDScript: `##` acima da função.

## README de módulo

Copia `docs/templates/MODULE_README.md` e preenche: propósito (1 frase) · o que **não** faz · API pública (tabela) · exemplo de uso · dependências permitidas · decisões/limitações · como testar. Máx. ~1 ecrã. Cria-o **quando crias o módulo**, não depois.

## Comentários dentro do código

- Explica o **porquê**, nunca repetes o **o quê**. Comentário que descreve código confuso → reescreve o código.
- Marca workarounds com contexto: `// Workaround: API X devolve 200 com corpo vazio (ver B-004)`.
- `TODO` no código só com referência a uma tarefa: `// TODO(T-031): …`.
- Nada de código comentado: o git guarda o histórico.

## Manter sincronizado (parte da Definition of Done)

No **mesmo commit** que altera comportamento ou API pública:
- [ ] Docstring atualizada (assinatura, erros, exemplo ainda corre).
- [ ] README do módulo reflete a API.
- [ ] `docs/MODULES.md` com a entrada nova/alterada/removida.
- [ ] `CHANGELOG.md` se a mudança é visível para quem usa.
- [ ] `ARCHITECTURE.md` se a estrutura ou as dependências mudaram.

Docs e código discordam → **o código manda**; corrige a doc. Nunca deixes doc que mente.

## Língua

Segue a língua já usada no código. Se o projeto é novo: identificadores em inglês; docstrings e README na língua definida em `docs/CONVENTIONS.md` (por defeito PT-PT). Sê consistente.

## Revisão rápida (auto-verificação)

1. Alguém que nunca viu o módulo consegue usá-lo só com o README + docstrings?
2. Os exemplos correm de facto? (testa-os)
3. Há símbolos exportados sem docstring? (`grep` pelos exports e confirma)
4. Os nomes dizem o que fazem sem precisar do comentário?

## Anti-padrões

Docstring que só repete o nome (`/** Gets the user. */`) · documentação gerada em massa sem conteúdo real · README com funcionalidades que não existem · comentários a pedir desculpa · exemplos que já não compilam · doc só em chat e não no repo.
