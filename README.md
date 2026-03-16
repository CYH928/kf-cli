# kf-cli - KnowledgeFactory Native CLI Plugin

**Version**: 0.1.0
**Status**: Tested (8/8 commands pass)

## Overview

Native CLI-based Claude Code plugin for Obsidian knowledge management. Drop-in replacement for kf-claude — same commands, same templates, same output — without Docker or MCP dependencies.

## Why kf-cli?

- **No Docker required** — uses yt-dlp, gh CLI, WebFetch, and direct file operations
- **Faster** — local I/O 100-500x faster than MCP Docker, no cold start penalty
- **Simpler** — fewer moving parts, easier to debug
- **Coexists** with kf-claude — use both simultaneously via namespaced commands

## Prerequisites

```bash
brew install yt-dlp gh jq uv
```

Verify: `yt-dlp --version && gh --version && jq --version && uvx --version`

## Commands

| Command | Description |
|---------|-------------|
| `/kf-cli:capture <content>` | Smart router — auto-detects YouTube, GitHub, URL, or text |
| `/kf-cli:youtube-note <url>` | YouTube video note with transcript and curriculum |
| `/kf-cli:idea <text>` | Quick idea capture with AI tagging |
| `/kf-cli:gitingest <github-url>` | GitHub repository analysis digest |
| `/kf-cli:study-guide <source>` | Comprehensive study guide from any content |
| `/kf-cli:article <topic>` | Article with auto-generated Gemini hero image |
| `/kf-cli:publish <filename>` | Publish to GitHub Pages (sharehub) |
| `/kf-cli:share <filename>` | Share via URL-encoded link (no server) |
| `/kf-cli:bulk-auto-tag` | Bulk AI tagging for existing notes |
| `/kf-cli:semantic-search <query>` | Search vault via Obsidian REST API |
| `/kf-cli:setup` | Setup wizard with dependency checks |

See [COMMANDS.md](COMMANDS.md) for full reference.

## Project Structure

```
kf-cli/
├── .claude-plugin/
│   └── marketplace.json       # Plugin manifest (11 commands)
├── commands/                   # Command .md files (prompt definitions)
├── templates/                  # Symlinked from kf-claude
├── scripts/
│   ├── core/                   # Symlinked: publish.sh, fetch-youtube-transcript.sh
│   └── helpers/common.sh       # Utility functions
├── SKILL.md                    # CLI-native skill definition
├── COMMANDS.md                 # Full command reference
├── MIGRATION.md                # Migration guide from kf-claude
├── TROUBLESHOOTING.md          # Common issues and fixes
├── CHANGELOG.md                # Version history
└── README.md
```

## Migration from kf-claude

Both plugins coexist. Use `/kf-cli:command` instead of `/kf-claude:command`. See [MIGRATION.md](MIGRATION.md).

## License

MIT

## Credits

Built by ZorCorp
Based on kf-claude architecture
