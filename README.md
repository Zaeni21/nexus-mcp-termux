# nexus-mcp-termux

Auto setup & run [nexus-xyz/mcp-nexus-server](https://github.com/nexus-xyz/mcp-nexus-server) via Termux → proot-distro Ubuntu on Android.

## Network Info

| | |
|---|---|
| Network | Nexus Testnet |
| Chain ID | `3945` |
| RPC | `https://testnet.rpc.nexus.xyz` |
| Explorer | `https://nexus.testnet.blockscout.com` |
| Currency | NEX |

---

## Installation

### Step 1 — Termux

```bash
pkg install git

git clone https://github.com/Zaeni21/nexus-mcp-termux.git

cd nexus-mcp-termux

ls

bash termux-bootstrap.sh
```

### Step 2 — Login Ubuntu

```bash
proot-distro login ubuntu
```

### Step 3 — Run setup (inside Ubuntu)

```bash
bash ~/nexus-mcp-setup.sh
```

### Step 4 — Start server (inside Ubuntu)

```bash
~/start-nexus-mcp.sh          # production
~/start-nexus-mcp.sh dev      # hot reload
```

---

## What `nexus-mcp-setup.sh` does

1. Checks you're inside Ubuntu (proot-distro)
2. Installs: `curl`, `git`, `redis-server`, `build-essential`
3. Installs Node.js 20 LTS via NodeSource
4. Installs `pnpm` globally
5. Prompts for **Commonstack API key** → saved to `~/.nexus-mcp.conf`
6. Prompts for wallet private key (optional, testnet only)
7. Clones `nexus-xyz/mcp-nexus-server`
8. Writes `.env.local` with correct RPC, chain ID, explorer, API keys
9. Runs `pnpm install` + `pnpm build`
10. Starts Redis daemon
11. Generates `~/start-nexus-mcp.sh`

---

## MCP Endpoint

```
http://localhost:3000/sse
```

Transport: SSE (via `@vercel/mcp-adapter`)

## Available MCP Tools

| Tool | Description |
|------|-------------|
| `getNetworkInfo` | Chain info & RPC status |
| `getBalance` | NEX balance of an address |
| `getTransaction` | Tx details by hash |
| `getBlock` | Block by number |
| `callContract` | Read-only contract call |
| `getLogs` | Filter event logs |
| `sendRawTransaction` | Submit signed tx |

---

## Commonstack API

Single API key for Claude, GPT-4o, Gemini, DeepSeek & more.

```
Base URL : https://api.commonstack.ai/v1
Docs     : https://docs.commonstack.ai
```

The `.env.local` is configured to route Anthropic SDK calls through Commonstack:

```env
ANTHROPIC_API_KEY=your-commonstack-key
ANTHROPIC_BASE_URL=https://api.commonstack.ai/v1
```

---

## Files

```
nexus-mcp-termux/
├── termux-bootstrap.sh    ← run in Termux first
├── nexus-mcp-setup.sh     ← run inside Ubuntu
└── README.md

Generated after setup:
~/mcp-nexus-server/        ← cloned nexus-xyz repo
  .env.local               ← env config (chmod 600)
~/.nexus-mcp.conf          ← saved API key (chmod 600)
~/start-nexus-mcp.sh       ← convenience run script
~/.claude_desktop_config.json
```

---

## Links

- Nexus: [nexus.xyz](https://nexus.xyz)
- Explorer: [nexus.testnet.blockscout.com](https://nexus.testnet.blockscout.com)
- MCP Server repo: [nexus-xyz/mcp-nexus-server](https://github.com/nexus-xyz/mcp-nexus-server)
- Commonstack: [commonstack.ai](https://commonstack.ai)
