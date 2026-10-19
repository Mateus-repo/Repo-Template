---
name: reusable-modules
description: Escrever código em módulos e funções reutilizáveis que qualquer outra parte do programa possa chamar — reutilizar antes de escrever, funções puras com entradas e saídas explícitas, dependências injetadas, API pública mínima, promoção para shared quando há um segundo consumidor, e registo em docs/MODULES.md. Usa SEMPRE antes de criar uma função, classe, componente, hook ou módulo novo, quando fores copiar e colar código, quando uma função depender de estado global, quando o utilizador pedir código modular, reutilizável ou desacoplado, e ao desenhar a interface de um módulo.
---

# Reusable modules

Meta: cada peça de código é **útil fora do sítio onde nasceu**. Qualquer parte do programa deve poder chamá-la sem saber como funciona por dentro — e sem arrastar meio projeto atrás.

## 1. Reutilizar antes de escrever (obrigatório)

Antes de criar qualquer função/classe/componente:

1. `bash scripts/find-reuse.sh <termos>` (usa 2–3 sinónimos: `chunk split batch`).
2. Lê `docs/MODULES.md` (catálogo) e a pasta `shared/`.
3. Decide:
   - **Existe e serve** → usa-a. Não reimplementes.
   - **Existe e serve quase** → generaliza-a (parâmetro com default, ou extrai a parte comum), com testes que provam que os chamadores antigos não mudaram. Não copies.
   - **Não existe** → cria-a no sítio certo (secção 3) e regista-a no catálogo.
4. Encontraste duplicação já existente? Não a resolvas a meio da tarefa: cria `T-NNN` em `TODO.md` (ou resolve em commit `refactor` separado).

## 2. Desenhar uma função reutilizável

| Propriedade | Regra |
|-------------|-------|
| **Pura sempre que possível** | Mesmas entradas → mesma saída; sem I/O, sem relógio, sem aleatoriedade escondidos |
| **Entradas explícitas** | Tudo o que precisa vem por parâmetro. Nada de globais, singletons, variáveis de ambiente lidas lá dentro |
| **Saída previsível** | Devolve valor (não muda argumentos). Tipo de retorno claro; sem `null`/exceção surpresa |
| **Uma coisa só** | Descreve-se numa frase sem "e". Verbo + objeto (`parseDuration`, `groupByDay`) |
| **Dependências injetadas** | Relógio, ficheiros, HTTP, BD entram como parâmetro/interface → testável e trocável |
| **Parâmetros contidos** | ≤ 4; acima disso, objeto de opções com defaults sensatos |
| **Sem flags booleanas que mudam o comportamento** | Duas funções com nomes claros > `doX(data, true)` |
| **Erros consistentes** | Mesma estratégia em todo o projeto (exceções tipadas **ou** `Result`), documentada |
| **Agnóstica do contexto** | Não conhece UI, framework, rotas, nem quem a chama |
| **Idempotente / segura a repetir** | Quando faz sentido (ex.: normalizar, validar, escrever com chave) |

Efeitos (I/O, rede, estado, UI) vão para as **bordas**; o miolo é lógica pura. Uma função de borda é fina: lê → chama o miolo → escreve.

```ts
// ✗ Difícil de reutilizar: global, I/O e lógica misturados
function saveReport() {
  const rows = db.query("select * from sales")       // global
  const total = rows.reduce((a, r) => a + r.value, 0)
  fs.writeFileSync(CONFIG.out, `Total: ${total}`)      // global + I/O
}

// ✓ Peças reutilizáveis
export const sumBy = <T>(items: T[], pick: (x: T) => number): number =>
  items.reduce((acc, x) => acc + pick(x), 0)                       // pura
export const formatTotal = (total: number): string => `Total: ${total}`  // pura
export async function saveReport(src: SalesSource, out: Writer) {  // borda fina
  out.write(formatTotal(sumBy(await src.all(), (r) => r.value)))
}
```

## 3. Onde vive o código novo (regra do 1-2-3)

- **1 consumidor:** fica **dentro da feature**, privado (não exportado).
- **2.º consumidor aparece:** **promove** para `shared/<conceito>/` (move com `git mv`, exporta, documenta, regista em `docs/MODULES.md`).
- **3.º caso com variações:** só agora generalizas/parametrizas. Antes disso, duas cópias pequenas são melhores que uma abstração errada.
- Nunca em `utils`/`helpers` genéricos: organiza por **conceito** (`shared/dates/`, `shared/validation/`). Ver `project-structure`.

## 4. Desenhar um módulo reutilizável

1. **Propósito em 1 frase** + o que **não** faz (vai para o README do módulo).
2. **API pública mínima** num único ponto de entrada (`index`, `__init__`, `mod.rs`, exports). Tudo o resto é interno. Quem importa vai **só** pelo ponto de entrada, nunca a ficheiros internos.
3. **Dependências declaradas e permitidas** (regra em `ARCHITECTURE.md`); sem ciclos; o módulo não importa quem o usa.
4. **Contrato testado:** testes contra a API pública (não contra detalhes internos) — assim podes mudar o interior à vontade.
5. **Configuração explícita** (parâmetros/objeto de config), não lida de ficheiros ou ambiente por dentro.
6. **Estabilidade:** mudar a API pública = mudança deliberada (atualiza chamadores, README, `MODULES.md`, `CHANGELOG`). Prefere acrescentar a alterar.

**Teste do transplante:** consegues copiar a pasta do módulo para outro projeto, levando só os imports declarados no README, e usá-lo? Se não, há acoplamento escondido — encontra-o e corta-o.

## 5. Registar no catálogo

Ao criar/alterar/remover uma função ou módulo reutilizável → linha em `docs/MODULES.md`: nome · caminho · assinatura · o que faz (1 linha) · pura? · erros · usado por. Sem registo, ninguém o encontra e vai ser reescrito (ver `code-documentation`).

## Checklist antes de dar por feito

- [ ] Procurei antes de escrever (`find-reuse.sh` + catálogo); nada duplicado.
- [ ] Cada função nova faz uma coisa, tem entradas/saídas explícitas e não lê estado escondido.
- [ ] Efeitos ficaram nas bordas; o miolo é puro e testado.
- [ ] Só se exporta o necessário; ponto de entrada único.
- [ ] Docstring + README do módulo + linha em `docs/MODULES.md`.
- [ ] Testes sobre a API pública, incluindo casos-limite.
- [ ] Passa o teste do transplante (ou está registado porque não passa).

## Anti-padrões

`utils.ext` com 40 funções soltas · função que lê config global · flag booleana que inverte o comportamento · copiar-colar com pequenas variações · wrapper trivial sem valor · "framework interno" antes de haver 3 casos · módulo que importa o código que o chama · export de tudo "por precaução" · generalizar com 8 parâmetros opcionais para servir um caso hipotético.
