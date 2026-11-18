# Build brief for the make.fun Roblox brainrot bounty

You are building the entry in this repository for `roblox-brainrot-01`. The place must be built during this recorded session, not copied from another game or from a previous unrecorded session.

## Game to build

Create a polished but simple 3D Roblox brainrot tycoon named **SuperBrainrot**:

- A built 3D world with a central egg area, a roll stick, and 10 display platforms on a base.
- `roll` world part with a ProximityPrompt: pressing `E` rerolls the egg rarity shown inside the `EGG` container above `egg place`.
- `egg place` world part with a ProximityPrompt: pressing `E` hatches the current egg.
- Egg rarities and brainrot rarities with clearly different drop rates. Higher egg rarity improves the chance of rarer brainrots.
- Hatch result is granted by server-authoritative weighted RNG. The player receives the brainrot as a **Tool** in the Backpack.
- The player can carry the brainrot to a base platform and use a ProximityPrompt there to place it on display.
- Each displayed brainrot generates cash per second according to rarity.
- Cashbuy upgrades for egg luck and roll-stick speed. Show costs and current levels in the UI.
- Clean compact HUD with cash, income, current egg, roll cooldown, upgrade panel, and brainrot inventory list. Use `Basic_UI_Pack` templates/assets if present in the starter place; otherwise create a clean custom UI from ImageLabels/ImageButtons. Never let the UI fill the whole screen.
- Use `Script` for authoritative server logic, `LocalScript` for UI/feedback, and `ModuleScript` for config. Communicate through `ReplicatedStorage` RemoteEvents.
- Do not use FOLK assets. Do not copy code from outside this repository. Write the Luau yourself in this session.

## Repository deliverables

- `src/` contains the Luau sources that match the place. Keep paths under `src/ReplicatedStorage`, `src/ServerScriptService`, and `src/StarterPlayerScripts` as appropriate.
- Keep `default.project.json` consistent with `src/`.
- Build/regenerate `game.rbxl` from the project (Rojo is available; Studio MCP is available).
- Run the game in Roblox Studio at least once, fix compile/runtime errors, and capture 3 or 4 real gameplay screenshots into `screenshots/`. The first screenshot by name should be the strongest 3D game view.
- `PLAY.json` must contain exactly:
  `{"url":"https://www.roblox.com/games/114987169439816","place_id":114987169439816,"universe_id":10777485735}`
- `README.md` must include the three live make.fun badge images for this competition:
  `https://make.fun/badge/roblox-brainrot-01.svg`,
  `https://make.fun/badge/roblox-brainrot-01/EziiPz/superbrainrot-roblox-bounty/rank.svg`,
  `https://make.fun/badge/roblox-brainrot-01/EziiPz/superbrainrot-roblox-bounty/reward.svg`,
  plus a link to `https://make.fun/bounty/roblox-brainrot-01`. Do not leave `{owner}` or `{repo}` placeholders.
- `TOUR.json` should describe the keys to reach each screenshot if practical.
- Verify locally with `mkdir -p out && MAKEFUN_OUTPUT_DIR=out node main.ts`.
- Commit the finished work with a clear message and push `main` to `origin` using `git -c credential.helper=manager push origin main`.
- Print the full final commit SHA in your final answer.

## Working style

Work iteratively in several visible steps: write an initial implementation, run/check it, then revise and improve it. Do not write everything as one final file change. Keep the user informed in short progress messages between steps.
