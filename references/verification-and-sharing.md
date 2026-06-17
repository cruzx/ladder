# Verification And Sharing

## Server Checks

- `docker ps` shows the Marzban container running
- `systemctl status caddy` is healthy
- `ss -tulpn` shows listeners on `443`, `2053`, and `8443`
- the panel responds over `https://__SERVER_DOMAIN__:8443`

## Subscription Checks

- Clash Meta subscription contains both `type: ss` and `type: vless`
- Reality entries contain both `public-key` and `short-id`
- Standard Clash subscription still works without Reality-specific fields

## Routing Checks

- `chatgpt.com` resolves to the `Codex` group
- `ws.chatgpt.com` resolves through the same proxied path as `chatgpt.com`
- `youtube.com` resolves to `Video`
- `netflix.com` resolves to `Streaming`
- `figma.com` resolves to `Design`
- `instagram.com`, `x.com`, `facebook.com`, `reddit.com`, `discord.com`, `telegram.org`, `pinterest.com` resolve to `Social`
- domestic sites resolve to `DIRECT`
- unmatched traffic resolves to `DIRECT`

## Codex Reconnecting Checks

- `oaistatsig.com` is routed through the proxy path
- the chosen client can pass secure WebSocket upgrades over TCP `443`
- `Codex` or `Proxy` is not forced to `DIRECT`
- no upstream TLS interception or URL rewriting breaks `chatgpt.com` or `ws.chatgpt.com`

## Sharing Checklist

- Replace `__SERVER_IP__`, `__SERVER_DOMAIN__`, `__ADMIN_USERNAME__`, and all credentials before sending
- Remove any active subscription paths such as `/sub/...`
- Remove any generated VLESS UUIDs and Shadowsocks passwords unless the pack is intended for direct use by a trusted recipient
- Remove any screenshots or logs that expose credentials
- Prefer sending the template files from `assets/` rather than a live server dump
