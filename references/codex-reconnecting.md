# Codex Reconnecting

## Symptom

`Codex` may show repeated `Reconnecting`, stall while streaming, or partially load when ordinary HTTPS works but WebSocket traffic is blocked, rewritten, or sent through a path that does not properly support upgrades.

## Official OpenAI Guidance

OpenAI's network guidance for ChatGPT and Codex says some features rely on secure WebSockets in addition to normal HTTPS requests.

Important destinations mentioned by OpenAI include:

- `wss://ws.chatgpt.com`
- `chatgpt.com` over TCP `443` for Codex-related WebSocket upgrades when URL-path filtering is limited

OpenAI also recommends allowing these domain families on managed networks:

- `*.chatgpt.com`
- `*.openai.com`
- `*.auth.openai.com`
- `*.oaistatic.com`
- `*.oaiusercontent.com`
- `*.oaistatsig.com`
- `auth0.openai.com`
- `android.chat.openai.com`

## What This Skill Does

- Routes the broader OpenAI and ChatGPT surface through the proxy
- Keeps `chatgpt.com` in the `Codex` strategy group
- Adds `oaistatsig.com` coverage for feature and client behavior endpoints
- Prefers `VLESS Reality` for Codex while keeping `Shadowsocks` fallback

## Practical Fix Checklist

- use `Rule` mode in the client
- do not force the `Codex` or `Proxy` group to `DIRECT`
- ensure TCP `443` WebSocket upgrades are supported end to end
- avoid TLS-inspecting proxies or enterprise web filters in front of the VPN
- refresh the subscription after rule changes

## Share-Safe Note

Do not publish live subscription URLs, active UUIDs, or active Shadowsocks passwords in public troubleshooting notes.
