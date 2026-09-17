#!/usr/bin/env bash
# Register the Homepage dashboard's MCP endpoint with Claude Code and Codex.
#
# Homepage (gethomepage.dev) v2 ships an MCP endpoint at /api/mcp that lets an
# agent read and validate the dashboard config. It is token-authenticated.
# Machine-local settings in ~/.dotfilesrc:
#   HOMEPAGE_MCP_URL        e.g. http://homepage.example:3001/api/mcp
#   HOMEPAGE_MCP_TOKEN_REF  1Password reference, e.g. op://Vault/Item/credential
# The token is read from 1Password at install time and stored in each agent's
# own MCP config as an environment variable. Nothing secret lives in this repo.

installing_banner "homepage-mcp"

: "${HOMEPAGE_MCP_URL:?Set HOMEPAGE_MCP_URL in ~/.dotfilesrc}"
: "${HOMEPAGE_MCP_TOKEN_REF:?Set HOMEPAGE_MCP_TOKEN_REF in ~/.dotfilesrc}"

token="$(op read "$HOMEPAGE_MCP_TOKEN_REF")"
[[ -n "$token" ]] || { echo "Could not read $HOMEPAGE_MCP_TOKEN_REF" >&2; exit 1; }

# --allow-http: mcp-remote refuses plain http except for localhost; LAN Homepage is http.
# mcp-remote expands ${VAR} in --header values from its environment.
header='X-Homepage-MCP-Token:${HOMEPAGE_MCP_TOKEN}'

if is_installed claude; then
  claude mcp remove homepage -s user >/dev/null 2>&1 || true
  claude mcp add homepage -s user -e "HOMEPAGE_MCP_TOKEN=$token" -- \
    npx -y mcp-remote "$HOMEPAGE_MCP_URL" --allow-http --header "$header"
fi

if is_installed codex; then
  codex mcp remove homepage >/dev/null 2>&1 || true
  codex mcp add homepage --env "HOMEPAGE_MCP_TOKEN=$token" -- \
    npx -y mcp-remote "$HOMEPAGE_MCP_URL" --allow-http --header "$header"
fi
