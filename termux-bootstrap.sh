#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
#  termux-bootstrap.sh
#  Run in Termux (NOT inside Ubuntu)
#  Installs proot-distro + Ubuntu, copies setup script
#  Repo: github.com/0xzvan/nexus-mcp-termux
# ============================================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

log()  { echo -e "${GREEN}[✓]${RESET} $1"; }
info() { echo -e "${BLUE}[i]${RESET} $1"; }
warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
step() { echo -e "\n${BOLD}${CYAN}── $1${RESET}"; }

echo -e "${CYAN}${BOLD}"
echo "  ┌──────────────────────────────────────────┐"
echo "  │  nexus-mcp-termux · Termux Bootstrap      │"
echo "  │  nexus-xyz/mcp-nexus-server               │"
echo "  │  Chain 3945 · testnet.rpc.nexus.xyz       │"
echo "  └──────────────────────────────────────────┘"
echo -e "${RESET}"

step "Updating Termux packages"
pkg update -y 2>/dev/null | tail -2
pkg upgrade -y 2>/dev/null | tail -2
log "Termux updated"

step "Installing proot-distro, git, curl"
pkg install -y proot-distro git curl 2>/dev/null | tail -3
log "Dependencies ready"

step "Installing Ubuntu 22.04 LTS"
if proot-distro list 2>/dev/null | grep -q "ubuntu.*installed"; then
  log "Ubuntu already installed"
else
  info "Downloading Ubuntu rootfs (~200MB)..."
  proot-distro install ubuntu 2>&1 | tail -5
  log "Ubuntu installed"
fi

step "Copying nexus-mcp-setup.sh into Ubuntu"
UBUNTU_ROOT="$PREFIX/../usr/var/lib/proot-distro/installed-rootfs/ubuntu/root"
SETUP_SRC="$(dirname "$0")/nexus-mcp-setup.sh"

# Fallback: same dir as this script, then $HOME
[ ! -f "$SETUP_SRC" ] && SETUP_SRC="$HOME/nexus-mcp-setup.sh"

if [ -f "$SETUP_SRC" ]; then
  mkdir -p "$UBUNTU_ROOT" 2>/dev/null || true
  cp "$SETUP_SRC" "$UBUNTU_ROOT/nexus-mcp-setup.sh" 2>/dev/null && \
    log "nexus-mcp-setup.sh → Ubuntu /root/" || \
    warn "Could not copy — manually place nexus-mcp-setup.sh at: $UBUNTU_ROOT/"
else
  warn "nexus-mcp-setup.sh not found next to this script"
  warn "Place it at: $HOME/nexus-mcp-setup.sh then re-run"
fi

step "Adding ubuntu alias"
grep -q "alias ubuntu=" "$HOME/.bashrc" 2>/dev/null || \
  echo "alias ubuntu='proot-distro login ubuntu'" >> "$HOME/.bashrc"
log "Alias 'ubuntu' added to ~/.bashrc"

echo ""
echo -e "${BOLD}${GREEN}Bootstrap done!${RESET}"
echo ""
echo -e "${BOLD}Next steps:${RESET}"
echo ""
echo -e "  ${YELLOW}1. Login Ubuntu:${RESET}"
echo -e "     ${CYAN}proot-distro login ubuntu${RESET}"
echo ""
echo -e "  ${YELLOW}2. Run setup (inside Ubuntu):${RESET}"
echo -e "     ${CYAN}bash ~/nexus-mcp-setup.sh${RESET}"
echo ""
echo -e "  ${YELLOW}3. Start MCP server (inside Ubuntu):${RESET}"
echo -e "     ${CYAN}~/start-nexus-mcp.sh${RESET}"
echo ""
echo -e "  ${YELLOW}Shortcut next time:${RESET}"
echo -e "     ${CYAN}source ~/.bashrc && ubuntu${RESET}"
echo ""
