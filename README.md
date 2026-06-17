# Ladder

A shareable Codex-focused proxy deployment skill for **Evoxt** and **Google Cloud**.

This repository helps you deploy a self-hosted proxy node optimized for:

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

It is built to keep **domestic traffic direct** and proxy only the international apps and domains that are more likely to be blocked.

## What is inside

- A reusable Codex skill: [`SKILL.md`](./SKILL.md)
- A server install script for Ubuntu VPS: [`scripts/install-server.sh`](./scripts/install-server.sh)
- Marzban, Caddy, Clash template, and Xray Reality templates under [`assets/`](./assets)
- Notes for fixing Codex `Reconnecting` under [`references/codex-reconnecting.md`](./references/codex-reconnecting.md)
- A provider comparison for Evoxt vs Google Cloud under [`references/provider-comparison.md`](./references/provider-comparison.md)

## Who this is for

Use this repo if you want to:

- deploy your own VPS proxy node
- optimize the connection for Codex and ChatGPT
- route only blocked international services through the proxy
- keep China domestic websites direct
- share a clean template pack with friends or teammates

## Provider choice

### Evoxt

Best for:

- lower and more predictable monthly cost
- simpler personal long-term use
- bundled traffic allowances

Typical public price examples in the included notes:

- `VM-1`: about `$5.99/month`
- `VM-2`: about `$11.99/month`

### Google Cloud

Best for:

- users who already use GCP
- temporary testing
- short-lived projects using credits

Important note:

- outbound traffic can become much more expensive than the VM itself

Read the full comparison here:

- [references/provider-comparison.md](./references/provider-comparison.md)

## Quick start

### 1. Choose your provider

Pick one:

- Evoxt
- Google Cloud

If you are unsure, start with **Evoxt**.

### 2. Create a VPS

Recommended:

- Region: `Tokyo` first, `Osaka` second
- OS: recent Ubuntu
- Size:
  - personal use: start from 1 vCPU / 2 GB RAM
  - shared use: 2 vCPU / 4 GB RAM or higher

### 3. Prepare the placeholders

Before deployment, replace these placeholders in the templates:

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

### 4. Deploy the server stack

This repo uses:

- Caddy
- Marzban
- Shadowsocks
- VLESS Reality

Main files:

- [`assets/server/marzban/.env.example`](./assets/server/marzban/.env.example)
- [`assets/server/marzban/docker-compose.yml`](./assets/server/marzban/docker-compose.yml)
- [`assets/server/caddy/Caddyfile.example`](./assets/server/caddy/Caddyfile.example)
- [`assets/server/xray/core-config-reality.template.json`](./assets/server/xray/core-config-reality.template.json)
- [`assets/server/templates/clash-classic-default.yml`](./assets/server/templates/clash-classic-default.yml)

After filling values, run:

```bash
bash scripts/install-server.sh
```

Run it on the VPS as `root`.

### 5. Import the client configuration

If you want a manual Clash/Mihomo client template, use:

- [`assets/client/codex-optimized-clash.template.yaml`](./assets/client/codex-optimized-clash.template.yaml)

This template is already tuned to:

- send China traffic direct
- proxy OpenAI and Codex-related domains
- optimize common international apps into separate groups

### 6. Fix Codex Reconnecting if needed

If Codex reconnects repeatedly, read:

- [references/codex-reconnecting.md](./references/codex-reconnecting.md)

This repo already bakes in the main routing idea:

- proxy the broader OpenAI surface
- allow secure WebSocket traffic over TCP `443`
- keep `chatgpt.com`, `ws.chatgpt.com`, `oaistatic.com`, `oaiusercontent.com`, and `oaistatsig.com` on the proxied path

### 7. Fix missing Reality `short-id` in Marzban subscriptions

Some Marzban builds may omit `sid` in generated Reality subscriptions.

Use:

- [`scripts/patch_marzban_share_sid.py`](./scripts/patch_marzban_share_sid.py)

## Routing behavior

The included rules are designed so that:

- China domestic domains go `DIRECT`
- unknown traffic defaults to `DIRECT`
- only selected international apps are proxied

Pre-optimized buckets include:

- `Codex`: ChatGPT, OpenAI, Sora
- `AI`: GitHub, Google, Notion
- `Video`: YouTube
- `Streaming`: Netflix
- `Design`: Figma
- `Social`: Instagram, X, Facebook, Telegram, Discord, Reddit, Pinterest
- `Music`: Spotify

## Share safely

Before sharing with someone else:

- remove real IPs
- remove real domains
- remove UUIDs
- remove passwords
- remove private keys
- remove subscription links and tokens
- remove screenshots that expose secrets

Use the templates under [`assets/`](./assets) instead of exporting a live server dump.

## Verification checklist

See:

- [references/verification-and-sharing.md](./references/verification-and-sharing.md)

## Chinese guide | 中文说明

这是一个适合 **Evoxt** 和 **Google Cloud** 的自建代理技能仓库，重点是优化：

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

核心目标：

- 只有国外常见被墙服务走代理
- 国内网站默认直连
- 尽量减少 Codex `Reconnecting`
- 可以把这套方案脱敏后分享给别人

### 怎么用

1. 先选服务器提供商

- 想省钱、长期稳定使用：优先 `Evoxt`
- 已经在用 GCP、想临时测试或用赠金：可以选 `Google Cloud`

2. 开一台 Ubuntu VPS

推荐：

- 地区优先 `Tokyo`，其次 `Osaka`
- 个人使用建议从 `1 vCPU / 2 GB RAM` 起步
- 多人共用建议 `2 vCPU / 4 GB RAM` 或更高

3. 把模板里的占位符替换掉

要替换的内容包括：

- 服务器 IP
- 域名
- 管理员用户名和密码
- Shadowsocks 密码
- VLESS UUID
- Reality 公私钥和 short-id

4. 部署服务端

主要用到：

- `Caddy`
- `Marzban`
- `Shadowsocks`
- `VLESS Reality`

入口脚本：

```bash
bash scripts/install-server.sh
```

5. 导入客户端规则

手动导入 Clash 或 Mihomo 时，使用：

- [`assets/client/codex-optimized-clash.template.yaml`](./assets/client/codex-optimized-clash.template.yaml)

这份规则已经帮你做好：

- 国内网站直连
- OpenAI / Codex 相关域名走代理
- YouTube、Netflix、Figma、社交媒体、Spotify 分组优化

6. 如果 Codex 老是 Reconnecting

直接看：

- [references/codex-reconnecting.md](./references/codex-reconnecting.md)

7. 如果 Marzban 生成的 Reality 订阅缺少 `sid`

用这个补丁：

- [`scripts/patch_marzban_share_sid.py`](./scripts/patch_marzban_share_sid.py)

### 发给别人之前要注意

- 去掉真实 IP
- 去掉真实域名
- 去掉密码、UUID、私钥
- 去掉订阅链接和 token
- 尽量发模板，不要直接发线上配置导出

## Notes

- This repository is a template and skill pack, not a managed VPN service.
- Recheck provider pricing before purchase.
- The pricing snapshot in the included notes is dated **June 17, 2026**.
