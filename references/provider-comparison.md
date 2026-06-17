# Provider Comparison

## Snapshot Date

This pricing snapshot is based on sources checked on June 17, 2026. Recheck before publishing or purchasing.

## Fast Recommendation

- Choose `Evoxt` for lower and more predictable monthly cost.
- Choose `Google Cloud` for flexibility, APIs, and short-term experimentation.

## Evoxt

### When to prefer it

- Personal proxy use
- Shareable low-maintenance VPS setup
- Users who care more about bundled transfer than cloud features

### Price examples

Evoxt publishes straightforward monthly VPS pricing.

- Standard network includes `Japan (Tokyo)`.
- Premium network includes `Japan (Osaka)`.

Representative plans from the public pricing page:

- `VM-0.5`: 1 core, 512 MB RAM, 5 GB storage
  - Tokyo standard: `$2.99/month`
  - Osaka premium: `$2.99/month`
- `VM-1`: 1 core, 2 GB RAM, 20 GB storage
  - Tokyo standard: `$5.99/month`
  - Osaka premium: `$5.99/month`
- `VM-2`: 2 cores, 4 GB RAM, 30 GB storage
  - Tokyo standard: `$11.99/month`
  - Osaka premium: `$11.99/month`

Transfer allowances differ by network tier:

- Tokyo standard `VM-1`: `1000 GB/month`
- Osaka premium `VM-1`: `500 GB/month`
- Tokyo standard `VM-2`: `2000 GB/month`
- Osaka premium `VM-2`: `1000 GB/month`

Upgrade prices listed by Evoxt:

- extra IPv4: `$3/month`
- extra vCore: `$3/month`
- extra 1 GB RAM: `$2/month`
- extra transfer:
  - Standard: `$3/TB`
  - Premium: `$12/TB`
  - Premium Plus: `$24/TB`

### Practical read

- For a small Codex-focused node, `VM-1` is usually a sensible starting point.
- `VM-2` is safer when multiple people share the node or when the panel and multiple transports run together.

## Google Cloud

### When to prefer it

- Existing GCP users
- Users who want infrastructure APIs and project-level controls
- Temporary testing with cloud credits

### Important cost behavior

Google Cloud VM cost is not the full story. The biggest risk is outbound internet traffic.

- Compute Engine bills by usage time for VM resources.
- Disk and networking are billed separately.
- Premium Tier is the default for internet data transfer.

### Region availability

- `asia-northeast1`: Tokyo, supports `E2`
- `asia-northeast2`: Osaka, supports `E2`

### Price examples

For a rough VM-only reference, a third-party GCP price index listed:

- `e2-small` in Tokyo: about `$0.0215/hour`, about `$15.69/month`
- `e2-medium` in Tokyo: about `$0.043/hour`, about `$31.38/month`

Use the official Google Cloud pricing calculator for a final quote.

### Official egress pricing to watch

From Google Cloud's VPC internet data transfer pricing for Tokyo and Osaka class regions:

- to North America:
  - first 1 GiB each month: free
  - next 1 to 1024 GiB: `$0.12/GiB`
- to China destinations excluding Hong Kong:
  - 0 to 1024 GiB: `$0.23/GiB`

### Practical read

- Even if the VM itself looks affordable, sustained proxy traffic can become very expensive.
- GCP makes more sense for testing or short-lived use than for a cheap always-on personal proxy.

## Suggested Choice Matrix

- Lowest predictable monthly cost: `Evoxt`
- Best for Codex with minimal setup friction: `Evoxt`
- Best for cloud-native experimentation: `Google Cloud`
- Best when expecting large monthly outbound traffic: `Evoxt`
- Best when using trial credits and cleaning up quickly: `Google Cloud`

## What To Tell Users

If the user asks which provider to choose and gives no extra constraints:

- Recommend `Evoxt` for long-running personal use.
- Recommend `Google Cloud` only when the user explicitly values GCP features or wants to spend credits.
