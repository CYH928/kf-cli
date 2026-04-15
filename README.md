# kf-cli — Obsidian Knowledge Capture for Claude Code & OpenClaw

A skill package that captures YouTube videos, articles, ideas, and GitHub repos into an Obsidian vault with AI auto-tagging. Publishes to GitHub Pages. No Docker. No MCP. Just CLI tools.

kf-cli is a **pure skill**: it exposes commands and templates only. Identity (who the agent is) and model choice (how it thinks) live in the agent or runtime that invokes the skill.

---

## Install — Option 1: Shell installer (agent-agnostic)

Installs to `~/.agents/skills/kf-cli/` — the standard skill root scanned by OpenClaw and compatible with any framework that reads Markdown-with-frontmatter skills.

```bash
curl -fsSL https://raw.githubusercontent.com/ZorCorp/kf-cli/master/install.sh | sh
```

Update:

```bash
curl -fsSL https://raw.githubusercontent.com/ZorCorp/kf-cli/master/install.sh | sh -s -- --update
```

Uninstall:

```bash
curl -fsSL https://raw.githubusercontent.com/ZorCorp/kf-cli/master/install.sh | sh -s -- --uninstall
```

## Install — Option 2: Claude Code plugin marketplace

For Claude Code users who want plugin-manager integration:

```
/plugin marketplace add ZorCorp/zorskill
/plugin install kf-cli
```

---

## Prerequisites

```bash
brew install yt-dlp gh jq uv
```

Verify: `yt-dlp --version && gh --version && jq --version && uvx --version`

---

## Configuration

The skill resolves the vault path at runtime:

1. `$KF_VAULT_PATH` environment variable (if set and contains `notes/`)
2. Current working directory (if it contains `notes/`)
3. `$HOME/Documents/Obsidian/myrag` (fallback default)

For publishing, run `/kf-cli:setup` inside your vault to create `.claude/config.local.json` with `sharehub_repo` and `sharehub_url`.

Optional env vars:

| Var | Purpose | Default |
|---|---|---|
| `KF_VAULT_PATH` | Vault root | `$HOME/Documents/Obsidian/myrag` |
| `SHAREHUB_URL` | Published base URL | (required for publish) |
| `KF_SHARE_BASE_URL` | Share-link base URL | `https://example.com/share` |
| `GEMINI_IMG_GEN_DIR` | Gemini image-generator skill dir | `$HOME/.claude/skills/gemini-image-generator` |

---

## Commands

| Command | Description |
|---|---|
| `/kf-cli:capture <content>` | Smart router — YouTube, GitHub, URL, or text |
| `/kf-cli:youtube-note <url>` | YouTube note with transcript and curriculum |
| `/kf-cli:idea <text>` | Quick idea capture with AI tagging |
| `/kf-cli:gitingest <github-url>` | GitHub repo analysis digest |
| `/kf-cli:study-guide <source>` | Comprehensive study guide |
| `/kf-cli:article <topic>` | Article with auto-generated hero image |
| `/kf-cli:publish <file>` | Publish note to GitHub Pages |
| `/kf-cli:share <file>` | Generate shareable URL (no server) |
| `/kf-cli:semantic-search <query>` | Ripgrep + optional rerank over the vault |
| `/kf-cli:bulk-auto-tag` | AI-tag all untagged notes |
| `/kf-cli:setup` | Configure publishing destination |

See `COMMANDS.md` for details.

---

## Invocation patterns

- **Claude Code** — invoke commands as `/kf-cli:<command>`. The session's model handles all AI work.
- **OpenClaw, single-agent** — list `kf-cli` in one agent's allowed skills. That agent's configured model runs the commands.
- **OpenClaw, multi-agent** — list `kf-cli` on any agent that needs it. Each uses its own model.
- **Plain CLI** — `scripts/**/*.sh` is directly callable; `commands/*.md` are portable prompt templates any framework that reads Markdown skills can consume.

The model is always chosen by the invoker, never by the skill.

---

## Contributing

Source: `github.com/ZorCorp/kf-cli`. PRs welcome. Before submitting:

```bash
# Audit checks — must all pass
KF=.
grep -riE "claude-(sonnet|opus|haiku)|gpt-[0-9]|gemini-[0-9]|glm-|ollama/|minimax" "$KF" && echo "FAIL: model names" && exit 1
grep -rF "Documents/Obsidian" "$KF" | grep -v 'KF_VAULT_PATH' && echo "FAIL: hardcoded vault path" && exit 1
grep -riE "\bKira\b|\bZorro\b" "$KF" && echo "FAIL: identity leak" && exit 1
echo "PASS — skill is identity-free"
```

---

## License

MIT.
