// Auto commit — rede de segurança.
// Quando a sessão fica idle e há alterações, faz um commit "chore(wip): checkpoint".
// Config: .opencode/autocommit.json  |  desligar: AUTOCOMMIT=off
// Segurança: nunca commita ficheiros sensíveis nem diffs com padrões de segredos.
import { existsSync, readFileSync } from "node:fs"
import { join } from "node:path"

const DEFAULTS = {
  enabled: true,
  push: false,
  minIntervalSeconds: 15,
  blockSecrets: true,
  message: "chore(wip): checkpoint",
}

const SENSITIVE_FILE =
  /(^|\/)(\.env(\.[^/]*)?|[^/]*\.pem|[^/]*\.p12|[^/]*\.pfx|id_rsa|id_ed25519|credentials\.json)$/i
const SAFE_ENV_FILE = /\.env\.(example|sample|template)$/i
const SECRET_PATTERNS = [
  /-----BEGIN [A-Z ]*PRIVATE KEY-----/,
  /AKIA[0-9A-Z]{16}/,
  /ghp_[A-Za-z0-9]{36,}/,
  /github_pat_[A-Za-z0-9_]{50,}/,
  /(^|[^A-Za-z0-9])sk-[A-Za-z0-9_-]{32,}/,
  /xox[baprs]-[A-Za-z0-9-]{10,}/,
]

function loadConfig(dir) {
  try {
    const p = join(dir, ".opencode", "autocommit.json")
    if (existsSync(p)) return { ...DEFAULTS, ...JSON.parse(readFileSync(p, "utf8")) }
  } catch {
    // config inválida → usa defaults
  }
  return { ...DEFAULTS }
}

export const AutoCommit = async ({ client, $, directory }) => {
  let busy = false
  let lastRun = 0

  const log = async (level, message) => {
    try {
      await client.app.log({ body: { service: "auto-commit", level, message } })
    } catch {
      // logging nunca pode partir o plugin
    }
  }

  const git = async (...args) => {
    const r = await $`git -C ${directory} ${args}`.quiet().nothrow()
    return { code: r.exitCode, out: r.stdout.toString() }
  }

  const checkpoint = async (cfg) => {
    const inside = await git("rev-parse", "--is-inside-work-tree")
    if (inside.code !== 0) return

    // não mexer a meio de merge/rebase/cherry-pick
    const gd = (await git("rev-parse", "--git-dir")).out.trim()
    const gitDir = gd.startsWith("/") || /^[A-Za-z]:/.test(gd) ? gd : join(directory, gd)
    for (const marker of ["MERGE_HEAD", "rebase-merge", "rebase-apply", "CHERRY_PICK_HEAD", "REVERT_HEAD"]) {
      if (existsSync(join(gitDir, marker))) return
    }

    const status = await git("status", "--porcelain")
    if (status.code !== 0 || !status.out.trim()) return

    await git("add", "-A")

    const names = (await git("diff", "--cached", "--name-only")).out
      .split("\n")
      .map((s) => s.trim())
      .filter(Boolean)

    for (const f of names) {
      if (SENSITIVE_FILE.test(f) && !SAFE_ENV_FILE.test(f)) {
        await git("reset", "-q", "HEAD", "--", f)
        await log("warn", `Ficheiro sensível ignorado no checkpoint: ${f}`)
      }
    }

    if (cfg.blockSecrets) {
      const diff = (await git("diff", "--cached", "-U0", "--no-color")).out
      const added = diff.split("\n").filter((l) => l.startsWith("+") && !l.startsWith("+++"))
      const hit = added.some((l) => SECRET_PATTERNS.some((re) => re.test(l)))
      if (hit) {
        await git("reset", "-q")
        await log("warn", "Possível segredo no diff — checkpoint cancelado. Remove o segredo e volta a tentar.")
        return
      }
    }

    const staged = await git("diff", "--cached", "--quiet")
    if (staged.code === 0) return // nada em stage

    const count = (await git("diff", "--cached", "--name-only")).out.split("\n").filter(Boolean).length
    const res = await git("commit", "-q", "-m", `${cfg.message} (${count} ficheiros)`)
    if (res.code !== 0) {
      await log("warn", "Commit falhou (hooks ou config git?). Alterações ficam em stage.")
      return
    }
    await log("info", `Checkpoint feito (${count} ficheiros).`)

    if (cfg.push) {
      const p = await git("push", "-q")
      if (p.code !== 0) await log("warn", "git push falhou (sem remote/upstream?).")
    }
  }

  return {
    event: async ({ event }) => {
      if (event.type !== "session.idle") return
      const cfg = loadConfig(directory)
      if (!cfg.enabled || process.env.AUTOCOMMIT === "off" || busy) return
      if (Date.now() - lastRun < cfg.minIntervalSeconds * 1000) return
      busy = true
      try {
        await checkpoint(cfg)
      } catch (e) {
        await log("error", `auto-commit: ${String(e)}`)
      } finally {
        busy = false
        lastRun = Date.now()
      }
    },
  }
}
