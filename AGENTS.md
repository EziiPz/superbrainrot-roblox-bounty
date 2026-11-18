# SuperBrainrot entry build brief

This repository contains the make.fun `roblox-brainrot-01` entry for **SuperBrainrot**, a Roblox brainrot egg tycoon. The published experience is [place 114987169439816](https://www.roblox.com/games/114987169439816). `main.ts` packages the Studio place, its matching source tree, screenshots, and play metadata into the local make.fun output.

## Place and source invariant

`game.rbxl` is the place saved from Roblox Studio. The Luau files under `src/` must stay byte-for-byte equal to the corresponding scripts inside that place. When the place scripts change, use `rojo syncback` to regenerate `src/` from `game.rbxl`, then verify the source files against the place before committing.

Never run `rojo build` over `game.rbxl`: that would replace the Studio-saved place with a newly built file. Keep the saved place intact and use `default.project.json` as the mapping for source synchronization.

## Rebuilding the entry output

From the repository root, run the local builder to prepare the grader output:

```sh
mkdir -p out && MAKEFUN_OUTPUT_DIR=out node main.ts
```

The builder copies `game.rbxl`, `PLAY.json`, `src/`, and `screenshots/` into `out/`, then writes `out/dossier.json`. On PowerShell, set `$env:MAKEFUN_OUTPUT_DIR = "out"`, create `out`, and run `node main.ts`.

## Files to preserve

Do not edit or remove `LICENSE` or anything under `vendor/`; the output builder depends on the vendored make.fun library. Do not write into the staging directory used to prepare this entry. Do not overwrite the Studio place with Rojo output, and do not make source edits that break the byte-equality between `src/` and the scripts in `game.rbxl`. Keep screenshots and tour references in sync when the approved screenshot set changes.
