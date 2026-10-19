# <nome-do-módulo>

> <Uma frase: o que este módulo faz.>

**Não faz:** <limites explícitos — o que fica fora deste módulo e onde vive>.

## API pública

Ponto de entrada: `<caminho/index>`. Tudo o resto é interno e **não** deve ser importado de fora.

| Símbolo | Assinatura | Descrição | Erros |
|---------|------------|-----------|-------|
| `exemplo()` | `exemplo(x: T, opts?: Opts): R` | O que faz, numa linha | `ErroX` se … |

## Exemplo de uso

```
// o exemplo mais pequeno que mostra o caso típico (deve correr de facto)
```

## Dependências

- **Permitidas:** <módulos/bibliotecas de que depende>.
- **Proibidas:** <ex.: UI, framework web, acesso direto a BD>.

## Notas e limitações

- <decisões relevantes (ref. D-NNN), casos-limite, desempenho, thread-safety>.

## Testes

`<comando para correr só os testes deste módulo>` — testes sobre a API pública em `<caminho>`.
