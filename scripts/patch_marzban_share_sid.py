from pathlib import Path

path = Path("/code/app/subscription/share.py")
source = path.read_text()

old = """                if sids := inbound.get("sids"):
                    inbound["sid"] = random.choice(sids)
"""

new = """                if sids := inbound.get("sids"):
                    host_inbound["sid"] = random.choice(sids)
"""

if old not in source:
    raise SystemExit("target snippet not found")

path.write_text(source.replace(old, new, 1))
print("patched")
