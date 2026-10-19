---
name: ui-design
description: Desenhar e rever interfaces com qualidade profissional — hierarquia visual, espaçamento, tipografia, cor e contraste, estados de componentes, acessibilidade, movimento e consistência via design tokens em docs/DESIGN.md. Usa SEMPRE que criares, alteres ou revejas qualquer UI (web, desktop, mobile, jogos), quando o utilizador falar em visual, layout, design, tema, "ficar bonito", "melhorar a interface", ou antes de escrever código de UI. Evita interfaces genéricas, inconsistentes ou inacessíveis.
---

# UI design

Uma boa UI é **clara, consistente e previsível** primeiro; bonita depois — e a beleza nasce da disciplina (escala, alinhamento, contraste), não de enfeites.

## Processo

1. **Brief (2 min)** — quem usa, em que contexto (ecrã, rato/toque/gamepad, pressa?), qual a **tarefa principal** do ecrã, qual o **tom** (calmo, enérgico, sério, "cozy"…). Escreve em `docs/DESIGN.md › Direção`.
2. **Tokens antes de componentes** — define cor, tipografia, espaçamento, raios, sombras, movimento em `docs/DESIGN.md`. O código usa **tokens**, nunca valores soltos ("#3a7bd5", "13px").
3. **Estrutura antes de estilo** — esboça a hierarquia do ecrã (o que é 1.º, 2.º, 3.º) em texto/ASCII; só depois estilo.
4. **Componentes com todos os estados** (ver §5).
5. **Implementa** reutilizando componentes; nada de estilos "one-off" repetidos.
6. **Revê** com a checklist (§9) e **verifica no ecrã real** (tamanhos pequeno e grande). Regista decisões em `docs/DESIGN.md › Registo`.

Se existir UI prévia, **respeita o sistema existente** (tokens, componentes, padrões) antes de introduzir algo novo.

## 1. Hierarquia

- Um **ponto focal** por ecrã. Ação principal destacada (cor, tamanho, posição); secundárias discretas; destrutivas separadas e confirmadas.
- Hierarquia por **tamanho, peso, contraste, espaço** — não por 6 cores diferentes.
- Agrupa por proximidade (lei da proximidade): espaço **dentro** do grupo < espaço **entre** grupos.
- Leitura natural: esquerda→direita, cima→baixo (ajusta para RTL se aplicável).

## 2. Espaçamento e layout

- **Escala fixa** (4/8): `4 · 8 · 12 · 16 · 24 · 32 · 48 · 64`. Nunca valores arbitrários.
- Mais espaço em branco do que parece necessário; densidade só em ferramentas de especialista.
- **Alinha** a uma grelha/eixos comuns; margens consistentes; mesma largura máxima de leitura (45–75 caracteres por linha).
- Responsivo/adaptável: define 2–3 *breakpoints* (ou tamanhos-alvo), conteúdo reflui, nada de scroll horizontal acidental. Em desktop/jogos: testa resolução mínima **e** ecrãs grandes/ultrawide.

## 3. Tipografia

- **1–2 famílias** no máximo; escala modular (ex.: 12 · 14 · 16 · 20 · 24 · 32).
- Corpo ≥ 16 px equivalente (≥ 14 em UIs densas); entrelinha 1.4–1.6 para texto corrido; títulos 1.1–1.3.
- 2–3 pesos (regular, médio, negrito). Maiúsculas só em etiquetas curtas.
- Texto curto e acionável: botões com **verbo** ("Guardar", "Criar pedido"), erros que dizem **o que fazer**, sem jargão técnico.

## 4. Cor e contraste

- Paleta pequena: **neutros** (fundo, superfície, bordas, texto) + **1 cor primária** + **semânticas** (sucesso/aviso/erro/info). Neutros fazem 80% do trabalho.
- Contraste **WCAG**: texto normal ≥ 4.5:1; texto grande e elementos de UI ≥ 3:1. Verifica de facto (não "a olho").
- **Nunca só cor** para transmitir significado (junta ícone/texto/forma).
- Suporta tema claro/escuro se fizer sentido, via tokens (não duplicar estilos).
- Evita preto/branco puros em grandes áreas; usa neutros ligeiramente tingidos pela cor primária.

## 5. Estados (o que separa amador de profissional)

Cada componente interativo define: **normal · hover · foco (visível!) · pressionado · desativado · a carregar · erro · sucesso**.
Cada **vista de dados** define: **vazio** (com orientação/ação), **a carregar** (esqueleto/spinner), **erro** (com retry), **parcial**, **muitos dados** (paginação/scroll), **texto longo** (truncar/quebrar).
Formulários: etiquetas visíveis (não só placeholder), validação clara junto ao campo, valores preservados em erro, estado de submissão.

## 6. Acessibilidade (mínimos não-negociáveis)

- Navegável por **teclado** (e gamepad, se aplicável) com ordem lógica e **foco visível**.
- Alvos de toque/clique ≥ 44×44 px (≥ 24 px com espaçamento em desktop denso).
- Texto alternativo em imagens significativas; etiquetas em controles; semântica correta (botão é botão, não `div`).
- Respeita "reduzir movimento"; nada pisca > 3×/s; áudio/vídeo com controlo.
- Texto redimensionável sem partir o layout; não bloquear zoom.

## 7. Movimento

Serve para **explicar** (de onde veio, para onde vai), não para decorar. 120–240 ms; *ease-out* para entrar, *ease-in* para sair; anima `transform`/`opacity`. Feedback imediato (< 100 ms) ao input.

## 8. Padrões de estilo e consistência

- Uma única família de ícones, um raio de borda base (+1 variante), 2–3 níveis de elevação, bordas **ou** sombras (não tudo).
- Componentes reutilizáveis: botão, campo, cartão, modal, lista, tabs, toast. Variantes por propriedades, não cópias.
- Mesma ação = mesmo aspeto e mesmo sítio em todo o lado.
- **Evita o genérico:** escolhe uma direção e comete-te (tipografia com carácter, paleta coerente, um detalhe memorável) — mas sem sacrificar legibilidade nem consistência.

## 9. Checklist de revisão

- [ ] Há um ponto focal e a ação principal é óbvia?
- [ ] Só valores da escala de espaçamento/tipografia/tokens de cor?
- [ ] Contraste verificado (4.5:1 / 3:1)? Sem informação só por cor?
- [ ] Todos os estados definidos (interação **e** dados)?
- [ ] Foco visível e uso por teclado/gamepad OK?
- [ ] Textos curtos, claros, com verbos; erros acionáveis?
- [ ] Testado em tamanho mínimo e grande; sem overflow/cortes?
- [ ] Reutiliza componentes existentes; sem estilos duplicados?
- [ ] `docs/DESIGN.md` atualizado (tokens/componentes/decisão)?

## 10. Notas por plataforma

- **Web:** HTML semântico, CSS variáveis para tokens, *mobile-first*, `prefers-color-scheme`/`prefers-reduced-motion`.
- **Desktop (WinForms/WPF/Qt/Electron…):** respeita convenções do SO, DPI scaling, atalhos de teclado, estados de janela redimensionada.
- **Mobile:** zonas de polegar, gestos com alternativa visível, *safe areas*, teclado a cobrir campos.
- **Jogos:** legibilidade a distância/em movimento, contraste sobre fundo variável, ancoragem a cantos/safe area em ecrãs diferentes, navegação por gamepad, escala de UI configurável, feedback sonoro/visual de cada ação. Separa **dados/lógica** da **apresentação** para testar sem render.

## Anti-padrões

Valores mágicos de cor/espaço · 5 tamanhos de botão · texto cinza claro sobre branco · modal sobre modal · placeholder como etiqueta · ícones sem texto em ações importantes · estados vazios em branco · animações lentas que bloqueiam o uso · "depois trato da acessibilidade".
