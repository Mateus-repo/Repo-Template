# Design — {{PROJECT_NAME}}

> Fonte de verdade da interface (web, desktop, mobile ou jogo). Skill: `ui-design`.
> Se o projeto não tem UI, apaga este ficheiro.

## Direção

- **Tom/personalidade:** _ex.: acolhedor, minimalista, "cozy"_
- **Plataforma e tamanhos-alvo:** _ex.: desktop 1280×720+, mobile 360×640+_
- **Referências visuais:** _a preencher_

## Tokens

### Cor

| Token | Valor | Uso |
|-------|-------|-----|
| `--color-bg` | `#…` | Fundo base |
| `--color-surface` | `#…` | Cartões/painéis |
| `--color-text` | `#…` | Texto principal (contraste ≥ 4.5:1 com `bg`) |
| `--color-text-muted` | `#…` | Texto secundário |
| `--color-primary` | `#…` | Ação principal |
| `--color-danger` / `--color-success` / `--color-warning` | `#…` | Estados |

### Tipografia

| Papel | Família | Tamanho/peso/entrelinha |
|-------|---------|--------------------------|
| Título | | |
| Corpo | | |
| Legenda | | |

### Espaçamento (escala de 4/8)

`4 · 8 · 12 · 16 · 24 · 32 · 48 · 64`

### Raios, sombras, bordas

_a definir_

### Movimento

Duração 120–240 ms, *easing* suave; respeitar "reduzir movimento".

## Componentes

| Componente | Estados obrigatórios | Notas |
|------------|---------------------|-------|
| Botão | normal · hover · foco · pressionado · desativado · a carregar | |
| Campo de texto | normal · foco · erro · desativado | |
| Lista/tabela | vazio · a carregar · erro · com dados | |

## Princípios de layout

_Hierarquia, grelha, alinhamento, densidade._

## Acessibilidade

- Contraste ≥ 4.5:1 (texto) / 3:1 (UI) · alvos de toque ≥ 44 px · navegação por teclado/gamepad · foco visível · não depender só da cor.

## Registo de alterações de design

| Data | Alteração | Motivo |
|------|-----------|--------|
