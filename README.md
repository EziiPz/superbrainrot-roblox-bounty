# SuperBrainrot

SuperBrainrot is a Roblox brainrot egg tycoon. Roll the egg's rarity at the roll stick, hatch it at the egg place, and collect the brainrot it reveals. Carry brainrots to the ten platforms on your base to display them and earn cash over time. Spend that cash to improve egg luck and make the roll stick faster.

Entered in: [make.fun](https://make.fun)

[![make.fun · roblox-brainrot-01](https://make.fun/badge/roblox-brainrot-01.svg)](https://make.fun/bounty/roblox-brainrot-01?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)
[![rank](https://make.fun/badge/roblox-brainrot-01/EziiPz/superbrainrot-roblox-bounty/rank.svg)](https://make.fun/bounty/roblox-brainrot-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)
[![reward](https://make.fun/badge/roblox-brainrot-01/EziiPz/superbrainrot-roblox-bounty/reward.svg)](https://make.fun/bounty/roblox-brainrot-01?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)

Play SuperBrainrot: [roblox.com/games/114987169439816](https://www.roblox.com/games/114987169439816)

## How it is built

The game world is saved from Roblox Studio in `game.rbxl`. The matching Luau sources live in `src/`, which holds the same scripts as files synced back from the place. The Rojo project description maps those files to their Roblox services, while the Studio-saved place remains the game submitted for play.

`main.ts` prepares the make.fun output by copying `game.rbxl`, `PLAY.json`, `src/`, and `screenshots/`, then writing `dossier.json` with the vendored make.fun library. This keeps the published place, the editable scripts, and the entry metadata together in the submission.

## How to run

Run the local output builder from the repository root:

```sh
mkdir -p out && MAKEFUN_OUTPUT_DIR=out node main.ts
```

The command creates the local `out/` directory with the entry files and dossier used for verification.

## Layout

- `game.rbxl` — Roblox Studio place for SuperBrainrot.
- `default.project.json` — Rojo mapping for the source tree.
- `src/ReplicatedStorage/` — shared configuration and remote definition.
- `src/ServerScriptService/` — authoritative tycoon and hatching logic.
- `src/StarterPlayerScripts/` — HUD and client-side interactions.
- `PLAY.json` — the published Roblox place link and IDs.
- `screenshots/` — cover, hatch, upgrades/base, and map views.
- `TOUR.json` — screenshot tour steps and their keypresses.
- `main.ts` — local make.fun output builder.
