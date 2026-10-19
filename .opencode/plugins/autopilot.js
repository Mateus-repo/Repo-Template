// Autopilot (experimental) — mantém o agente a trabalhar durante um orçamento de tempo.
// Ativar: /autopilot [min]  (ou: bash scripts/autopilot.sh start 120)
// Parar:  /autopilot-stop · scripts/autopilot.sh stop "motivo" · ficheiro STOP · Esc/erro
// Só atua se .opencode/autopilot.state existir com active=1. Ignora sub-sessões.
import { existsSync, readFileSync, writeFileSync } from "node:fs"
import { join } from "node:path"

const STATE = ".opencode/autopilot.state"

function readState(dir) {
  const p = join(dir, STATE)
  if (!existsSync(p)) return null
  const st = {}
  for (const line of readFileSync(p, "utf8").split("\n")) {
    const i = line.indexOf("=")
    if (i > 0) st[line.slice(0, i).trim()] = line.slice(i + 1).trim()
  }
  return st
}

function writeState(dir, st) {
  const body = Object.entries(st).map(([k, v]) => `${k}=${v ?? ""}`).join("\n") + "\n"
  writeFileSync(join(dir, STATE), body)
}

export const Autopilot = async ({ client, directory }) => {
  let lastPromptAt = 0

  const log = async (level, message) => {
    try {
      await client.app.log({ body: { service: "autopilot", level, message } })
    } catch {
      // ignorar
    }
  }

  const deactivate = async (st, reason) => {
    st.active = "0"
    st.reason = reason
    writeState(directory, st)
    await log("info", `Autopilot parado: ${reason}`)
  }

  const send = (sessionID, text) => {
    const body = { parts: [{ type: "text", text }] }
    const fn = client.session.promptAsync ?? client.session.prompt
    // fire-and-forget: não bloquear o loop de eventos
    Promise.resolve(fn.call(client.session, { path: { id: sessionID }, body })).catch((e) =>
      log("error", `Falha a enviar prompt: ${String(e)}`),
    )
  }

  return {
    event: async ({ event }) => {
      const st = readState(directory)
      if (!st || st.active !== "1") return

      // Erro ou interrupção (Esc) → parar de propósito
      if (event.type === "session.error") {
        await deactivate(st, "erro ou interrupção")
        return
      }
      if (event.type !== "session.idle") return

      const sessionID = event.properties?.sessionID
      if (!sessionID) return

      // ignorar sub-sessões (subagentes) e outras sessões
      try {
        const s = await client.session.get({ path: { id: sessionID } })
        if (s?.data?.parentID) return
      } catch {
        // se não conseguir verificar, segue
      }
      if (st.session && st.session !== sessionID) return
      if (!st.session) st.session = sessionID

      if (Date.now() - lastPromptAt < 3000) return

      if (existsSync(join(directory, "STOP"))) {
        await deactivate(st, "ficheiro STOP encontrado")
        return
      }

      const start = Number(st.start) || Date.now() / 1000
      const budget = Number(st.budget_min) || 120
      const count = Number(st.count) || 0
      const max = Number(st.max) || 60
      const elapsed = Math.floor((Date.now() / 1000 - start) / 60)
      const remaining = budget - elapsed

      // já pedimos wrap-up e a sessão ficou idle outra vez → terminar
      if (st.wrapup === "1") {
        await deactivate(st, "orçamento esgotado (wrap-up feito)")
        return
      }

      if (count >= max) {
        await deactivate(st, `limite de ${max} iterações`)
        return
      }

      lastPromptAt = Date.now()

      if (remaining <= 0) {
        st.wrapup = "1"
        st.count = String(count + 1)
        writeState(directory, st)
        send(
          sessionID,
          `[AUTOPILOT] Orçamento de ${budget} min esgotado (decorridos ${elapsed} min). ` +
            `Termina o que está a meio, corre scripts/check.sh, atualiza TODO.md/PROGRESS.md, faz commit e ` +
            `escreve o resumo final (skill session-handoff). Depois corre: bash scripts/autopilot.sh stop "orçamento esgotado".`,
        )
        return
      }

      st.count = String(count + 1)
      writeState(directory, st)
      send(
        sessionID,
        `[AUTOPILOT ${count + 1}/${max}] Decorridos ${elapsed} min, restam ~${remaining} min. ` +
          `Continua o loop de trabalho (AGENTS.md §4): relê PROGRESS.md/TODO.md/QUESTIONS.md, escolhe a próxima tarefa e executa-a. ` +
          `Não peças confirmações. Se tiveres dúvidas, aplica os 5 ângulos (skill decide-without-asking) e decide. ` +
          `Se a fila acabou, segue AGENTS.md §4.4. Se estiveres mesmo bloqueado em tudo, regista em QUESTIONS.md e corre ` +
          `bash scripts/autopilot.sh stop "motivo". Se já não há trabalho útil: bash scripts/autopilot.sh stop "concluído".`,
      )
    },
  }
}
