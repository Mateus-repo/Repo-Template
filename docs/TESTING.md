# Testes — {{PROJECT_NAME}}

> Estratégia de verificação. Skill: `testing-verification`.

## Filosofia

- Testa **comportamento**, não implementação. Testes rápidos, determinísticos, independentes.
- Cada bug corrigido ganha um teste de regressão.
- Pirâmide: muitos unitários · alguns de integração · poucos ponta-a-ponta.
- Sem testes automáticos possíveis (ex.: UI, jogo)? Define **verificação manual reprodutível** (passos escritos) e regista-a na tarefa.

## Comandos

| O quê | Comando |
|-------|---------|
| Tudo | `bash scripts/check.sh` |
| Unitários | `TODO` |
| Integração | `TODO` |
| Um teste | `TODO` |
| Cobertura | `TODO` |

## O que tem de ter testes

- Lógica de domínio e regras de negócio · parsing/validação · cálculos · casos-limite e erros.

## O que se verifica manualmente

_Lista de fluxos de UI/fluxos visuais + passos._

## Dados de teste

_Onde estão, como se geram; nada de dados reais/pessoais._

## Problemas conhecidos (flaky, lentos)

_Nenhum._
