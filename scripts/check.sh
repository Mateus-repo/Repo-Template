#!/usr/bin/env bash
# Verificação completa: deteta a stack e corre lint + testes (+ build quando existir).
# Para personalizar: cria scripts/check.local.sh (tem prioridade total).
# Sai com código != 0 se algo falhar.
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

if [[ -f scripts/check.local.sh ]]; then exec bash scripts/check.local.sh; fi

fail=0
ran=0
step() { # step "nome" comando...
  local name="$1"; shift
  ran=$((ran+1))
  echo "▶ $name"
  if "$@"; then echo "  ✔ $name"; else echo "  ✘ $name"; fail=$((fail+1)); fi
}
has() { command -v "$1" >/dev/null 2>&1; }
npm_script() { [[ -f package.json ]] && grep -q "\"$1\"[[:space:]]*:" package.json; }
# o 'npm init' cria um script de teste que falha de propósito: não conta
npm_test_stub() { grep -Eq '"test"[[:space:]]*:[[:space:]]*"[^"]*no test specified' package.json; }
# pytest sai com 5 quando não há testes: não é falha
pytest_ok() { pytest -q; local c=$?; [[ $c -eq 0 || $c -eq 5 ]]; }

# Node / TypeScript
if [[ -f package.json ]]; then
  pm=npm; [[ -f pnpm-lock.yaml ]] && pm=pnpm; [[ -f yarn.lock ]] && pm=yarn; [[ -f bun.lockb || -f bun.lock ]] && pm=bun
  npm_script lint      && step "lint ($pm)"      $pm run lint
  npm_script typecheck && step "typecheck ($pm)" $pm run typecheck
  npm_script test      && ! npm_test_stub && step "test ($pm)" $pm run test
  npm_script build     && step "build ($pm)"     $pm run build
fi

# Python
if [[ -f pyproject.toml || -f requirements.txt || -f setup.py ]]; then
  has ruff   && step "ruff"   ruff check .
  has mypy   && [[ -f pyproject.toml ]] && grep -q '\[tool.mypy\]' pyproject.toml && step "mypy" mypy .
  has pytest && step "pytest" pytest_ok
fi

# Rust
if [[ -f Cargo.toml ]]; then
  step "cargo clippy" cargo clippy --all-targets -- -D warnings
  step "cargo test"   cargo test
fi

# Go
if [[ -f go.mod ]]; then
  step "go vet"  go vet ./...
  step "go test" go test ./...
fi

# .NET
if compgen -G "*.sln" >/dev/null || compgen -G "*.csproj" >/dev/null || compgen -G "*/*.csproj" >/dev/null || compgen -G "*/*/*.csproj" >/dev/null; then
  step "dotnet build" dotnet build --nologo -v q
  step "dotnet test"  dotnet test --nologo -v q --no-build
fi

# Godot (sem testes por defeito: apenas verificação de scripts, se o binário existir)
if [[ -f project.godot ]]; then
  if has godot; then step "godot (carregar projeto)" godot --headless --quit --path .; else echo "ℹ Godot: binário 'godot' não encontrado no PATH — verificação manual necessária."; fi
fi

# Estrutura, documentação e modularidade (só avisos; ver scripts/structure-check.sh)
[[ -x scripts/structure-check.sh || -f scripts/structure-check.sh ]] && bash scripts/structure-check.sh || true
echo

# Shell scripts do próprio repo
for f in scripts/*.sh; do step "bash -n $f" bash -n "$f"; done

echo
if (( ran == 0 )); then echo "Nenhuma verificação detetada."; exit 0; fi
if (( fail > 0 )); then echo "FALHOU: $fail de $ran verificações."; exit 1; fi
echo "OK: $ran verificações passaram."
