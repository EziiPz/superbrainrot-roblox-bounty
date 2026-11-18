# SuperBrainrot

SuperBrainrot is a Roblox brainrot egg tycoon. Roll the egg's rarity at the roll stick, hatch it at the egg place, and collect the brainrot it reveals. Carry brainrots to the ten platforms on your base to display them and earn cash over time. Spend that cash to improve egg luck and make the roll stick faster.

Entered in: [make.fun](https://make.fun)

[![make.fun](https://img.shields.io/badge/make.fun-build%20for%20roblox--brainrot--01-blue)](https://make.fun)
[![Recording](https://img.shields.io/badge/transcripts-recorded%20live-2ea44f)](https://make.fun)
[![Roblox](https://img.shields.io/badge/roblox-SuperBrainrot-red)](https://www.roblox.com/games/114987169439816)

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
