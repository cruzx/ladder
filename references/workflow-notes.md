# Workflow Notes

## Recommended Defaults

- Provider choice:
  - `Evoxt` first for predictable cost
  - `Google Cloud` second for flexibility or credits
- Region: `Tokyo` first, `Osaka` second
- OS: recent Ubuntu release with `apt`
- TLS front end: `Caddy`
- Panel: `Marzban`
- Compatibility transport: `Shadowsocks` on `443`
- Codex-first transport: `VLESS Reality` on `2053`
- Panel HTTPS: `8443`

## Why Keep Two Protocols

- `VLESS Reality` is usually better for Codex and other modern blocked services.
- `Shadowsocks` is useful as a compatibility fallback and for clients that do not support Reality.

## Provider Routing

### Evoxt

- Use the bundled server templates almost as-is.
- Prefer simple public IPv4 deployment.
- Expect easier monthly budgeting.

### Google Cloud

- Use the same app-layer templates after the VM is created.
- Add a stronger warning around egress charges before deployment.
- Budget alerts are useful but are not a hard stop. Operators still need local traffic limits and cleanup discipline.

## Routing Strategy

The bundled Clash template is intentionally conservative:

- Chinese domains and Chinese IPs go `DIRECT`
- The named international apps go through dedicated proxy groups
- All unmatched traffic goes `DIRECT`

This avoids forcing all overseas traffic through the proxy and matches the goal of proxying only likely blocked services.

## App Buckets

- `Codex`: ChatGPT, OpenAI, Sora
- `AI`: GitHub, Google, Notion
- `Video`: YouTube
- `Streaming`: Netflix
- `Social`: Instagram, X, Facebook, Pinterest, Telegram, Discord, Reddit
- `Design`: Figma
- `Music`: Spotify

## Codex Reconnecting Mitigation

For Codex, do not proxy only a minimal subset of OpenAI traffic. Cover the broader surface:

- `*.chatgpt.com`
- `*.openai.com`
- `*.auth.openai.com`
- `*.oaistatic.com`
- `*.oaiusercontent.com`
- `*.oaistatsig.com`

The reason is OpenAI's published network guidance: some ChatGPT and Codex features depend on secure WebSockets over TCP `443`.
