# Ladder

A shareable, Codex-focused proxy deployment skill for **Evoxt** and **Google Cloud**.

This repository is designed for people who want to deploy a self-hosted proxy node that works well for:

- Codex
- ChatGPT
- YouTube
- Netflix
- Figma
- Instagram
- X / Twitter
- Facebook
- Spotify
- Pinterest

The default routing strategy is simple:

- China domestic traffic stays `DIRECT`
- only likely blocked international services go through the proxy
- Codex and OpenAI traffic gets special handling to reduce `Reconnecting`

## Highlights

- Provider choice guidance for **Evoxt** and **Google Cloud**
- Ubuntu VPS deployment templates
- `Marzban + Caddy + Shadowsocks + VLESS Reality` stack
- Split-routing templates for Clash / Mihomo
- Codex-specific routing notes for WebSocket stability
- Sanitized, shareable templates with placeholders instead of personal secrets

## Repository structure

- [`README.md`](./README.md): project overview and usage guide
- [`SKILL.md`](./SKILL.md): reusable Codex skill entry
- [`assets/`](./assets): client and server templates
- [`references/`](./references): troubleshooting, pricing, verification, and workflow notes
- [`scripts/`](./scripts): deployment and patch helper scripts
- [`agents/openai.yaml`](./agents/openai.yaml): skill metadata for agent use

## Choose a provider

### Evoxt

Choose Evoxt if you want:

- lower and more predictable monthly cost
- simpler long-running personal use
- bundled transfer with less billing surprise

Typical examples from the included pricing note:

- `VM-1`: about `$5.99/month`
- `VM-2`: about `$11.99/month`

### Google Cloud

Choose Google Cloud if you want:

- GCP project controls and APIs
- short-lived test environments
- trial-credit experiments

Important warning:

- outbound traffic can cost much more than the VM itself

Full comparison:

- [references/provider-comparison.md](./references/provider-comparison.md)

## Recommended defaults

- Region: `Tokyo` first, `Osaka` second
- OS: recent Ubuntu release
- Personal use: `1 vCPU / 2 GB RAM` minimum
- Shared use: `2 vCPU / 4 GB RAM` or higher
- Panel: `Marzban`
- Front end: `Caddy`
- Compatibility transport: `Shadowsocks` on `443`
- Codex-first transport: `VLESS Reality` on `2053`

## Quick start

### 1. Create a VPS

Start with either:

- Evoxt in Japan
- Google Cloud in `asia-northeast1` or `asia-northeast2`

If you are unsure, start with **Evoxt**.

### 2. Replace the placeholders

Before deployment, replace these values in the templates:

- `__SERVER_IP__`
- `__SERVER_DOMAIN__`
- `__ADMIN_USERNAME__`
- `__ADMIN_PASSWORD__`
- `__SS_PASSWORD__`
- `__VLESS_UUID__`
- `__REALITY_PRIVATE_KEY__`
- `__REALITY_PUBLIC_KEY__`
- `__REALITY_SERVER_NAME__`
- `__REALITY_SHORT_ID__`

Primary files:

- [`assets/server/marzban/.env.example`](./assets/server/marzban/.env.example)
- [`assets/server/marzban/docker-compose.yml`](./assets/server/marzban/docker-compose.yml)
- [`assets/server/caddy/Caddyfile.example`](./assets/server/caddy/Caddyfile.example)
- [`assets/server/xray/core-config-reality.template.json`](./assets/server/xray/core-config-reality.template.json)
- [`assets/server/templates/clash-classic-default.yml`](./assets/server/templates/clash-classic-default.yml)
- [`assets/client/codex-optimized-clash.template.yaml`](./assets/client/codex-optimized-clash.template.yaml)

### 3. Deploy the server stack

Run this on the VPS as `root` after preparing the final config files:

```bash
bash scripts/install-server.sh
```

The stack installs and prepares:

- Docker
- Caddy
- UFW
- vnStat
- Marzban

### 4. Configure your client

For manual Clash or Mihomo import, use:

- [`assets/client/codex-optimized-clash.template.yaml`](./assets/client/codex-optimized-clash.template.yaml)

The included rules already optimize these groups:

- `Codex`: ChatGPT, OpenAI, Sora
- `AI`: GitHub, Google, Notion
- `Video`: YouTube
- `Streaming`: Netflix
- `Design`: Figma
- `Social`: Instagram, X, Facebook, Telegram, Discord, Reddit, Pinterest
- `Music`: Spotify

## Codex optimization

This repo is intentionally tuned for Codex, especially when ordinary HTTPS works but the app keeps reconnecting.

What it does:

- keeps the broader OpenAI surface on the proxied path
- covers domains such as `chatgpt.com`, `openai.com`, `oaistatic.com`, `oaiusercontent.com`, and `oaistatsig.com`
- assumes secure WebSocket traffic over TCP `443` must work end to end
- prefers `VLESS Reality` while keeping `Shadowsocks` as a fallback

Read the dedicated note here:

- [references/codex-reconnecting.md](./references/codex-reconnecting.md)

## Known Marzban issue

Some Marzban builds may omit the Reality `short-id` from generated subscriptions.

If that happens, use:

- [`scripts/patch_marzban_share_sid.py`](./scripts/patch_marzban_share_sid.py)

## Verification

Before calling the setup complete, check:

- panel is reachable on `https://your-domain:8443`
- ports `443`, `2053`, and `8443` are listening
- subscription output contains both `ss` and `vless`
- Reality entries include `public-key` and `short-id`
- domestic sites go `DIRECT`
- Codex and major blocked services follow the intended proxy groups

Full checklist:

- [references/verification-and-sharing.md](./references/verification-and-sharing.md)

## Share safely

Before sharing this setup with anyone else:

- remove real IP addresses
- remove real domains
- remove usernames and passwords
- remove UUIDs and private keys
- remove subscription URLs and tokens
- remove screenshots that expose secrets

If you are publishing a reusable package, share the files under [`assets/`](./assets) instead of a live server export.

## Chinese Guide | 中文说明

这是一个适合 **Evoxt** 和 **Google Cloud** 的自建代理技能仓库，重点是让下面这些服务更稳定：

- Codex
- ChatGPT
- YouTube
- Netflix
- Figma
- Instagram
- X / Twitter
- Facebook
- Spotify
- Pinterest

默认策略是：

- 国内网站直连
- 只有常见被墙的国外服务走代理
- 对 Codex / OpenAI 做额外优化，尽量减少 `Reconnecting`

### 适合谁用

如果你想做下面这些事，这个仓库就适合：

- 自己搭一台代理 VPS
- 优化 Codex 和 ChatGPT 的连接体验
- 只代理国外受限服务，不影响国内网站
- 把脱敏后的模板分享给朋友或同事

### 怎么选

- 想省钱、长期稳定用：优先 `Evoxt`
- 已经在用 GCP、想临时测试或用赠金：选 `Google Cloud`
- 不确定怎么选：先上 `Evoxt`

### 怎么用

1. 开一台 Ubuntu VPS
2. 替换模板里的占位符
3. 按仓库里的模板准备服务端配置
4. 在 VPS 上运行：

```bash
bash scripts/install-server.sh
```

5. 客户端导入：

- [`assets/client/codex-optimized-clash.template.yaml`](./assets/client/codex-optimized-clash.template.yaml)

### 这套规则帮你做了什么

- 国内网站默认直连
- OpenAI / Codex 相关域名走代理
- YouTube、Netflix、Figma、社交媒体、Spotify 分组优化
- Codex 的 WebSocket 场景单独照顾

### 如果 Codex 老是 Reconnecting

直接看：

- [references/codex-reconnecting.md](./references/codex-reconnecting.md)

### 如果 Marzban 的 Reality 订阅缺少 `sid`

用这个补丁：

- [`scripts/patch_marzban_share_sid.py`](./scripts/patch_marzban_share_sid.py)

### 分享给别人前要做什么

- 去掉真实 IP
- 去掉真实域名
- 去掉用户名、密码、UUID、私钥
- 去掉订阅链接和 token
- 尽量分享模板，不要直接导出线上配置

## Notes

- This repository is a template and skill pack, not a managed VPN service.
- Recheck provider pricing before purchase.
- The pricing snapshot in the included notes is dated **June 17, 2026**.
