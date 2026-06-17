---
name: evoxt-codex-proxy
description: Deploy and optimize a shareable proxy node on Evoxt or Google Cloud using Marzban, Caddy, Shadowsocks, and VLESS Reality. Use this skill when the user wants a self-hosted proxy for Codex, ChatGPT, YouTube, Netflix, Figma, social apps, provider selection guidance, price-aware tradeoffs, or sanitized shareable templates.
---

# Evoxt Codex Proxy

## Overview

This skill turns a fresh Ubuntu VM into a shareable proxy node tuned for Codex and other common international apps. It includes provider selection guidance for Evoxt and Google Cloud, Reality plus Shadowsocks setup guidance, a Marzban subscription fix, and split-routing templates that keep domestic traffic direct.

## When To Use

Use this skill when the user wants any of the following:

- Build a self-hosted proxy on Evoxt or another VPS
- Choose between Evoxt and Google Cloud before deploying
- Improve Codex or ChatGPT performance with route-specific proxy rules
- Fix or reduce Codex `Reconnecting` behavior caused by blocked WebSocket traffic
- Set up VLESS Reality plus a compatibility fallback
- Generate a shareable bundle without leaking personal IPs, passwords, local paths, or subscription tokens
- Export a reusable skill or template pack for teammates or friends

## Workflow

### 1. Confirm the target

- Prefer Japan `Tokyo` or `Osaka` for users in China who want better Codex and streaming latency.
- Use Ubuntu on the VPS. The bundled install script targets modern Ubuntu with `apt`, Docker, Caddy, `ufw`, and `vnstat`.
- Before deployment, read [references/provider-comparison.md](./references/provider-comparison.md) and let the user choose the provider.
- Decide whether the output is:
  - a live deployment on the user's VPS
  - a sanitized shareable pack
  - both

### 1a. Provider decision

- Use `Evoxt` when the user wants predictable monthly cost, bundled transfer, and the shortest path to a working node.
- Use `Google Cloud` when the user wants more control, richer cloud tooling, or short-term trial credits, but warn that egress can dominate total cost.
- If the user does not know which to choose, recommend:
  - `Evoxt` for personal long-running proxy use
  - `Google Cloud` for testing, temporary use, or users who already manage GCP

### 2. Deploy the base stack

- Use the templates in [assets/server](./assets/server) as the source of truth.
- Fill placeholders before deployment:
  - `__SERVER_DOMAIN__`
  - `__ADMIN_USERNAME__`
  - `__ADMIN_PASSWORD__`
  - `__REALITY_PRIVATE_KEY__`
  - `__REALITY_SERVER_NAME__`
  - `__REALITY_SHORT_ID__`
- Run [scripts/install-server.sh](./scripts/install-server.sh) on the VPS after copying the server bundle into place.

### 3. Add Codex-friendly transport

- Keep both protocols:
  - `VLESS Reality` for Codex, OpenAI, and modern clients
  - `Shadowsocks` as fallback for compatibility
- The provided core config template already includes both:
  - `443` for Shadowsocks
  - `2053` for VLESS Reality
- After changing the core config, verify ports are listening and the Marzban container is healthy.

### 4. Fix the Marzban Reality subscription bug

- Some Marzban builds omit `short-id` in generated Reality subscriptions.
- If the generated Clash Meta or VLESS subscription is missing `sid`, run [scripts/patch_marzban_share_sid.py](./scripts/patch_marzban_share_sid.py) inside the Marzban container, then restart the container.
- This patch is intentionally isolated as a script so the operator can apply it without hand-editing container files.

### 5. Apply split routing

- The Clash template in [assets/server/templates/clash-classic-default.yml](./assets/server/templates/clash-classic-default.yml) is tuned for:
  - domestic sites direct
  - unspecified traffic direct
  - only selected international apps proxied
- The client-side example in [assets/client/codex-optimized-clash.template.yaml](./assets/client/codex-optimized-clash.template.yaml) is for manual import when a user does not want to rely on the Marzban subscription renderer.
- For Codex specifically, keep the broader OpenAI surface proxied so `Reconnecting` loops are less likely. See [references/codex-reconnecting.md](./references/codex-reconnecting.md).

### 6. Verify behavior

- Verify the live server:
  - HTTPS panel responds on `8443`
  - `443` and `2053` are listening
  - Marzban returns both `SS` and `VLESS Reality` for Clash Meta
- Verify routing:
  - domestic domains resolve to `DIRECT`
  - `chatgpt.com`, `openai.com`, `youtube.com`, `netflix.com`, `figma.com`, `instagram.com`, `x.com`, `facebook.com`, `spotify.com`, `pinterest.com` match their intended proxy groups
- Verify Codex stability:
  - `ws.chatgpt.com` and `chatgpt.com` are not blocked or rewritten
  - secure WebSocket traffic over TCP `443` is allowed through the chosen path
  - OpenAI domains such as `*.chatgpt.com`, `*.openai.com`, `*.oaistatic.com`, `*.oaiusercontent.com`, and `*.oaistatsig.com` are not filtered
- Use [references/verification-and-sharing.md](./references/verification-and-sharing.md) for the final checklist.

## Resources

### scripts/

- `install-server.sh`: installs Docker, Caddy, `ufw`, `vnstat`, copies templates, and starts Marzban
- `patch_marzban_share_sid.py`: fixes missing Reality `short-id` in generated subscriptions

### references/

- `workflow-notes.md`: deployment decisions and recommended defaults
- `codex-reconnecting.md`: Codex WebSocket and OpenAI domain guidance
- `provider-comparison.md`: Evoxt vs Google Cloud selection and price notes
- `verification-and-sharing.md`: sanitization and final QA checklist

### assets/

- `server/`: shareable server-side templates for Marzban, Caddy, and Xray
- `client/`: client-side Clash/Mihomo template for manual import

## Sanitization Rules

Before sharing any output from this skill:

- Replace real IPs with placeholders like `__SERVER_IP__`
- Replace real domains with placeholders like `__SERVER_DOMAIN__`
- Remove passwords, JWTs, API keys, private keys, and subscription tokens
- Remove local machine paths and user names
- Do not embed screenshots that expose credentials or panel URLs unless they are redacted

If the user explicitly wants a public share pack, prefer the files in `assets/` and regenerate final values from placeholders instead of copying any live deployed config verbatim.
