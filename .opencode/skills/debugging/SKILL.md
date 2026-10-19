---
name: debugging
description: Método sistemático para diagnosticar e corrigir bugs, falhas de testes, erros de build, crashes e comportamento inesperado. Usa SEMPRE que algo falhar, um teste partir, houver uma mensagem de erro, o resultado não for o esperado, uma correção não funcionar, ou o utilizador reportar um problema. Reproduzir, gerar hipóteses alternativas, isolar, corrigir a causa raiz e deixar teste de regressão.
---

# Debugging

Não adivinhes. **Reproduz → observa → hipotetiza → testa → corrige a causa → prova.**

## 1. Reproduzir

- Comando/passos **mínimos** que falham, de forma determinística. Sem reprodução, não há correção — só esperança.
- Regista o comando exato e o output **completo** (não parafraseies a mensagem de erro).
- Intermitente? Procura o que varia: dados, tempo, ordem, concorrência, ambiente, cache.

## 2. Ler o que o sistema te diz

- Stack trace de **baixo para cima** até ao teu código; mensagem de erro completa; logs à volta do momento.
- O que mudou? `git log -p`, `git diff`, `git stash` para comparar. **Bisect** quando "funcionava ontem": `git bisect start; git bisect bad; git bisect good <hash>` + comando de teste.

## 3. Hipóteses — sempre mais do que uma

Escreve **3–5 hipóteses** diferentes antes de mexer (usa o espírito dos 5 ângulos):

1. Dados/input inesperado · 2. Estado/ordem de execução · 3. Ambiente/configuração/versão · 4. Lógica do meu código · 5. Dependência/biblioteca/plataforma.

Para cada uma: **que observação a confirmaria ou excluiria?** Ordena por (probabilidade × baixo custo de testar). Testa uma de cada vez e **regista** em `BUGS.md` (`H1 ✗ excluída: …`).

## 4. Isolar

- Reduz: remove código/dados até ao mínimo que ainda falha.
- Instrumenta: logs/asserts/prints temporários nos pontos de decisão (e **remove-os** depois).
- Divide-e-conquista: o problema está antes ou depois deste ponto?
- Compara um caso que funciona com um que falha — a diferença é a pista.

## 5. Corrigir a causa, não o sintoma

- Pergunta "porquê?" até chegares a algo que, se mudado, torna o bug impossível ("5 porquês").
- Evita *patches* que escondem (try/catch vazio, `if` para o caso específico, sleep, retry cego).
- Procura o **mesmo padrão noutros sítios** (grep) — bugs repetem-se.

## 6. Provar

- Teste de regressão que falhava e agora passa (skill `testing-verification`).
- `bash scripts/check.sh` verde; reproduz o cenário original e confirma.
- Regista em `BUGS.md`: sintoma, causa raiz, correção (commit), teste. Commit `fix(scope): …` com `Refs: B-NNN`.

## Quando a tua correção não funcionou

Diz-o claramente (no registo e na mensagem final) e acrescenta o **diagnóstico**: o que tentaste, o output real, que hipóteses ficam excluídas e porquê. **Não repitas a mesma abordagem uma 3.ª vez.** Muda de ângulo: outra hipótese, outra ferramenta, outro nível (rede, SO, versão, cache), ou questiona o pressuposto de que "o problema está onde estou a olhar".

## Armadilhas comuns

| Sintoma | Suspeita rápida |
|---------|-----------------|
| "Funciona na minha máquina" | versões, variáveis de ambiente, ficheiros não commitados, caminhos absolutos, maiúsculas/minúsculas |
| Só falha às vezes | concorrência, tempo, ordem de testes, estado partilhado, aleatoriedade sem *seed* |
| Mudou sem eu mexer | atualização de dependência, cache, dados, relógio/timezone |
| Erro enorme e confuso | procura a **primeira** linha de erro; o resto é consequência |
| Correção "óbvia" não resolve | estás a olhar para o sítio errado; confirma que o teu código está mesmo a correr (build antigo? cache?) |
| Memória/CPU a crescer | recursos não libertados, listeners, caches sem limite, loops de eventos |

## Limites de tempo

2 tentativas falhadas na mesma linha de investigação → muda de estratégia. 30+ min sem progresso → regista o estado em `BUGS.md` (reprodução, hipóteses excluídas), marca a tarefa bloqueada e avança. Nunca deixes o repo partido.
