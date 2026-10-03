import { execFile } from "node:child_process";
import { promisify } from "node:util";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const execFileAsync = promisify(execFile);

interface CompatContext {
  cwd: string;
  hasPendingMessages?: () => boolean;
  hasQueuedMessages?: () => boolean;
  sessionManager?: { getBranch?: () => unknown[] };
}

interface CompatApi {
  getSessionName?: () => string | Promise<string>;
  on: (
    event: string,
    handler: (event: unknown, ctx: unknown) => unknown,
  ) => void;
}

// for embedding in a shell script
function shellQuote(value: string): string {
  return `'${value.replaceAll("'", `'"'"'`)}'`;
}

function textOf(content: unknown): string {
  if (!Array.isArray(content)) return "";
  const parts: string[] = [];
  for (const block of content) {
    if (
      block &&
      typeof block === "object" &&
      "type" in block &&
      block.type === "text" &&
      "text" in block &&
      typeof block.text === "string"
    ) {
      parts.push(block.text);
    }
  }
  return parts.join(" ");
}

function lastUserText(list: unknown[]): string | undefined {
  for (let i = list.length - 1; i >= 0; i--) {
    // accepts a ({ message }) or a bare message object
    let value = list[i];
    if (value && typeof value === "object" && "message" in value) {
      value = value.message;
    }
    if (!value || typeof value !== "object") continue;
    if (!("role" in value) || value.role !== "user") continue;
    if (!("content" in value)) continue;
    const text = textOf(value.content).replaceAll(/\s+/g, " ").trim();
    if (text) return text;
  }
  return undefined;
}

export default function (pi: ExtensionAPI) {
  const api = pi as unknown as CompatApi;

  api.on("agent_end", async (event: unknown, rawCtx: unknown) => {
    if (!rawCtx || typeof rawCtx !== "object") return;
    const ctx = rawCtx as CompatContext;

    if (
      typeof ctx.hasPendingMessages === "function"
        ? ctx.hasPendingMessages()
        : typeof ctx.hasQueuedMessages === "function"
          ? ctx.hasQueuedMessages()
          : false
    ) {
      return;
    }

    const cwd = typeof ctx.cwd === "string" ? ctx.cwd : "";
    const project = cwd.split("/").filter(Boolean).pop() ?? "session";

    let sessionName = "";
    try {
      if (typeof api.getSessionName === "function") {
        sessionName = await api.getSessionName();
      }
    } catch {
      // fallback to project name below
    }

    let prompt: string | undefined;
    try {
      prompt = lastUserText(ctx.sessionManager?.getBranch?.() ?? []);
    } catch {
      // try the event payload next
    }
    if (!prompt && event && typeof event === "object" && "messages" in event) {
      const messages = event.messages;
      if (Array.isArray(messages)) prompt = lastUserText(messages);
    }

    const title = `agent done: ${sessionName || project}`;
    const body = prompt
      ? `${prompt.length > 140 ? `${prompt.slice(0, 139)}…` : prompt}\n${project}`
      : project;

    const script = `
if [ -n "$TMUX" ] && [ -n "$TMUX_PANE" ]; then
  active=$(tmux display-message -p -t "$TMUX_PANE" '#{?#{&&:#{pane_active},#{window_active}},1,0}' 2>/dev/null)
  [ "$active" = "1" ] && exit 0
fi
exec notify-send -a agent -i ghostty -- ${shellQuote(title)} ${shellQuote(body)}
`;

    try {
      await execFileAsync("sh", ["-c", script]);
    } catch {
      // tmux gone or notify-send missing
    }
  });
}
