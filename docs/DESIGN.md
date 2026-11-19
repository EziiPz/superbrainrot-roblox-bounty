# System notes from a playable entry

## What the first minute teaches

A new session opens inside a compact tycoon space whose bright props make the egg station easy to notice.
The player begins with enough cash to understand that money is already part of the loop.
No stored profile is loaded by this server script, so a fresh join receives the same initial balance.
A short route connects the roll stick, the egg display, and a row of places for collected characters.
The proximity prompts turn those world objects into the first controls a player is likely to discover.
The prompt asks for a brief hold, which makes the interaction visible even before the player studies the HUD.
The opening action is not a purchase; it is a choice of which egg will sit in the shared display.
The second action requests a hatch from that displayed egg and begins a short reveal sequence.
The resulting character is delivered as a Tool, so the player can see and carry the reward immediately.
The inventory panel provides a second view of that Tool and its earning potential.
A player can then walk to a platform and use the stored character there as a visible base resident.
Once placed, that resident contributes a recurring amount to the cash total.
The two upgrade cards turn those early earnings into either better egg selection or shorter waits.
A complete first loop therefore crosses three spaces: station, inventory, and platform.
The game communicates those spaces through repeated object names, prompts, and HUD labels.
This visible chain reduces the need for a written tutorial before the first meaningful decision.
The saved place supplies the physical layout while the scripts provide the transaction rules.
The entry bundles both forms so a reviewer can inspect the world and the implementation together.

## A loop made of small decisions

Rolling determines the egg model and the rate table used by the following hatch.
The player approaches the stick, activates its prompt, and waits for the server's cooldown check.
A successful roll changes the model at the egg stand and informs the player with a toast.
The client receives a refreshed snapshot after a successful roll rather than calculating a new egg locally.
The hatch interaction reads whichever egg the server currently considers active.
A successful hatch asks the client to show a randomized card sequence for a short interval.
The character chosen for the reward is already settled on the server before that sequence begins.
After the reveal, the player sees a result card and a Tool in the inventory.
The Tool creates a tactile bridge between a collectible entry in the HUD and the avatar.
The player can hold a reward and trigger a platform prompt, or use the base button to request placement.
An occupied platform rejects the placement request and leaves the existing resident in place.
A successful placement removes the corresponding Tool and adds a display model to the world.
The server recalculates income from occupied platforms and starts paying it on its one-second loop.
Cash then funds the next luck or speed purchase, shifting the odds or the waiting rhythm.
That repeated cycle gives rarity a visible purpose and income a near-term use.
The player can continue gathering characters until all ten platform indices are occupied.
The basic loop has a short horizon, so each hatch, placement, and upgrade gives immediate feedback.
The larger visual collection acts as a progress board that grows as the player fills the base.
The economy is intentionally legible: each resident exposes its per-second earning value in several places.

## Where the rarity decision happens

The stick interaction asks the shared configuration module to select an egg index.
That module starts from a fixed list of eight weights, one for each configured egg.
It modifies the weights before drawing a random value across their combined total.
The first two indices lose weight as luck rises, while indices four through seven gain weight.
The third entry remains neutral under that adjustment, so it can become more common relative to others.
The final configured index has a starting weight of zero and remains unreachable through this table.
The total is used as a denominator implicitly by the weighted draw rather than by a hard-coded percentage.
This means each listed weight expresses relative influence, not an independent promise of probability.
Luck makes the upper group heavier and the lower group lighter at the same time.
It does not add a separate chance roll after the egg has been selected.
A rate table belongs to the selected egg and describes the tier roll made during hatching.
The client displays those tier chances, while the server performs the actual random draw.
The egg weights and tier rates are two distinct distributions and should never be confused.
One distribution chooses which egg is present; the other chooses which tier comes out of that egg.
The tier picker draws a value from zero to one hundred and walks the egg's cumulative rate values.
Only tiers up to the egg's maximum are considered by that walk.
A missed range falls back to the first tier, making a complete rate row important for predictable outcomes.
The configuration keeps a separate income and color beside each tier name.
Those attributes shape both the reward's financial value and its visual treatment.
A small probability tail makes higher-income rewards feel exceptional rather than routine.
That tension gives the player a reason to compare the displayed rates before hatching.
A tier's color also carries into the inventory accent and final reward presentation.
The rate table is sent in each state snapshot so the client can render the current egg's odds.
The odds panel displays zero-rate tiers with subdued styling instead of presenting a misleading percentage.
This makes the currently impossible upper egg distinguishable from an egg with a merely tiny chance.
Luck changes egg selection, not the tier distribution of an egg after it is chosen.
That separation keeps the upgrade's stated effect focused on reaching stronger egg types.

## Egg families and their shape

The starter entry is a guaranteed common outcome, giving the first hatch a predictable introduction.
The next egg adds a gold tier while retaining a larger common share.
The third family introduces diamond outcomes and distributes probability across three tiers.
The fourth family opens the lava tier and spreads its chances among four outcomes.
The fifth family includes the galaxy tier while removing the bottom outcome from its rate row.
The sixth family begins at diamond and can reach the rainbow tier.
The seventh family reaches the hacker tier, the highest income category in the shared table.
The eighth family's rates describe rare visual possibilities even though the roll weights do not select it.
Each family points to an asset model name used when the server updates the world display.
Each tier points to a folder from which a character model name is chosen.
The naming relationship is important because a missing folder or empty folder falls back to a generic name.
A name fallback preserves the transaction path, although a matching display model may then be absent.
Asset lookup checks a nested model collection first and then broadens the search to storage and workspace.
The checked locations let a Studio place organize its resources without changing the shared config format.
A random character is selected uniformly from the children in the chosen tier folder.
Uniform name selection means the tier rate and the individual model count together shape perceived variety.
Adding another child to one folder changes the names' relative frequency without changing tier odds.
Keeping tier folders curated therefore matters as much as tuning the numeric rate rows.
Income climbs sharply across the tier list to make rare placements meaningful over time.
The same configured color and income are carried into the rate table, Tool tooltip, inventory row, and result card.
This reuse prevents separate UI code from inventing its own values for the same reward.
It also means a tier configuration edit affects both the economy and several feedback surfaces.
A reviewer can compare those surfaces without opening the script because the values appear in the game.
The data table is small enough to audit manually, but its index ordering is a critical invariant.
Every egg rate array must align with the shared tier order or a percentage will describe the wrong reward.
Every folder reference must have a corresponding model collection if the visual reward is to match its label.
The eighth row illustrates why content availability and probability availability are separate checks.
A future release could make that family selectable only after deliberately assigning it a positive weight.

## The reveal has two timelines

The server runs the tier draw and picks the final character before asking the client to animate.
It also creates a sequence of decoy names with their own colors and rarity labels.
The actual result is appended to that sequence so the final display can be selected from the same list.
The client cycles through candidates on a short timer while the egg model shakes in the world.
The visible shuffle is theater; it does not influence the reward or call the random generator.
This division lets the animation feel uncertain without letting the interface decide ownership.
The server schedules the result message after the animation duration has elapsed.
A small hatch cooldown blocks an immediate second hatch from the same player state.
The world model is nudged through short randomized offsets and rotations, then returned to its saved pivot.
The shake routine stops early if the egg disappears before the sequence finishes.
A Tool is built around an invisible handle so the character model can follow the avatar's held item.
The handle is non-colliding and massless, reducing unwanted movement forces from the display model.
Descendant parts are welded to the handle after being made non-anchored and non-interactive.
The model is cloned without changing its authored scale, preserving its Studio proportions in hand.
The Tool stores the tier and income as attributes for presentation or later inspection.
The tooltip exposes the rarity and expected earning rate while the item is held.
The backpack becomes the durable-in-session container for the new Tool.
A separate inventory table stores the matching name, tier, income, and Tool reference for server decisions.
The result popup expands with a tween after it receives the authoritative name and earnings.
The first reveal message opens the card, while the later result message replaces the uncertain display.
A delayed hide closes the card unless a newer reveal has advanced its stamp.
That stamp prevents an older timer from hiding a more recent result.
The player receives a toast as well, so a reward remains acknowledged even if the popup is closed.
The egg shake and card shuffle create parallel motion without adding network calls each animation frame.

## From carried reward to resident model

The inventory list and the Roblox Backpack are two representations of one session reward.
The inventory table is the server's lookup source when a placement request arrives.
The held Tool is preferred when the player has equipped a tracked reward.
If no tracked Tool is being held, placement falls back to the first server inventory entry.
The client can request a particular platform index or request the server's first available index.
A request for the automatic choice scans indices from the beginning and stops at the first empty place.
A full set of ten returns a clear toast instead of trying to create an eleventh platform.
An occupied index is rejected before the display is cloned.
After choosing the reward, the server removes its inventory record and destroys the matching Tool.
The source model is found again from the reward's tier folder so the base display is a fresh clone.
If the exact named model is unavailable, the code can fall back to the first model in that folder.
The clone is fitted to the platform holder's footprint when its horizontal bounds exceed the limit.
Its pivot rotation is retained so authored facing direction survives the placement operation.
The code then corrects the bounding box's lower edge to rest on the holder surface.
Every display part is anchored and has collision, query, and touch interaction disabled.
Anchoring keeps the collectible still and avoids ongoing physics work for decorative residents.
An occupied slot stores the name, tier, income, owner name, and resulting model reference.
The income pass sums stored values for the player whose name matches each slot owner.
The HUD gets a sorted snapshot of slots so platform labels update in stable numeric order.
The world model and the slot record are removed together when the owner leaves the session.
The current layout uses one global table of ten indices rather than a separate map per player.
That choice matches a single visible BASE in the saved place but limits simultaneous ownership separation.
A larger multiplayer version should key slots by both player and slot number.
It should also check that each player owns the base containing the requested platform.
The removal of a reward before later model checks means failed placement needs careful handling.
A safer transaction validates the index, holder, asset, and ownership before consuming inventory.
That ordering protects a collected reward from missing geometry or malformed remote input.

## Cash and the two upgrades

A new player receives five hundred cash units when their server state is created.
Each occupied platform contributes its configured tier income once per second.
The server adds that accumulated rate to cash on a repeating one-second task.
Cash is rounded down when it is sent to the client, keeping the display free of fractions.
The server retains the underlying numeric value for future purchases.
The interface shows current cash and total income beside the top bar icons.
A placed reward increases income, so adding another resident has a direct economy effect.
The luck upgrade changes the weighting of egg choices for that player.
Its initial price is three hundred and grows by a factor of one point eight per level.
A purchase subtracts the current price only when the server confirms sufficient funds.
Its level then rises, and later roll requests use the updated value.
The speed upgrade follows a separate cost curve that begins at four hundred.
Its level controls the waiting interval between accepted rolls.
The base delay is six seconds divided by the current speed level.
The interval is clamped at one point two seconds to avoid an arbitrarily fast roll loop.
Both upgrade cards show the level, next price, and short effect summary.
The HUD recomputes those labels from server snapshots rather than predicting a successful purchase.
A failed purchase returns a message with the amount still needed.
The purchase response refreshes the view, keeping cash and upgrade status aligned.
Increasing luck changes relative egg weights rather than adding to a single fixed rarity percentage.
Increasing speed improves interaction cadence but does not change the tier result of a chosen egg.
The exponential price rise gives early purchases an attainable cost and later ones a longer savings target.
The current implementation has no persistent save layer, so these balances exist only for the active server session.
That boundary should be visible in any expectation about returning players or cross-server progress.
A durable economy would need a profile service, retry behavior, and safe shutdown handling.

## Server decisions and client presentation

The server script owns player cash, luck, speed, inventory records, placed-slot records, and timing gates.
It picks egg indices, reward tiers, reward names, and authoritative earning values.
It clones the egg display and the reward models into the replicated world.
It validates upgrade affordability and applies the actual costs.
It pays income and recalculates a player's rate after placements change.
The client script owns screen construction, layout, text formatting, button connections, and animation.
It displays messages sent by the server and does not mint money or create reward records.
The client can ask for a roll, hatch, placement, luck purchase, or speed purchase.
The server receives action strings through one RemoteEvent and selects a known handler by action name.
A placement argument is converted to a number before the server chooses a slot.
The remote boundary must treat every client call as a request, including calls made without visible buttons.
A modified client can fire the same RemoteEvent faster than a human can activate a prompt.
The server therefore needs its own cooldown, affordability, inventory, range, and ownership checks.
The current roll path checks a per-player timer before changing the shared egg.
The hatch path uses a per-player timer but does not verify that the sender is near the egg station.
The prompt is a useful normal control, not a security barrier around the RemoteEvent.
Upgrade handlers check server cash before changing either level.
The placement handler uses server-held reward records rather than a client-supplied tier or income.
That prevents a forged payload from directly selecting a high-value reward.
The platform index still needs strict bounds and ownership validation before any state is consumed.
Unknown action names simply do not match a handler and produce no reward change.
The client must never be treated as a source for cash totals, price, tier, model path, or earning rate.
A future remote schema should reject malformed types and out-of-range values with explicit reasons.
Rate limiting should be applied to every action rather than relying on interface delays.
Server state should be committed only after all world and ownership checks succeed.
Client effects can then be triggered by the committed server result.

## The screen layout as navigation

The display is assembled at runtime beneath one ScreenGui rather than saved as a large static hierarchy.
A centered top strip holds cash, income, and inventory count.
Its two small toggle chips open the left and right panels independently.
The left panel starts on the egg information tab and shares its space with upgrade cards.
The right panel summarizes carried characters and the ten platform positions.
The hatch result sits near the screen center while notifications appear above it.
The color system uses deep purple surfaces with brighter gold, green, and blue accents.
Gold draws attention to money, prices, and tier headings.
Green communicates recurring yield, while tier colors distinguish the rarities.
The gacha view contains one row per configured tier with chance and income text.
Unavailable outcomes are dimmed so the table still retains a stable row order.
The upgrade view displays separate level, cost, effect, and purchase controls for each path.
The inventory view creates rows only as needed and hides unused rows after each update.
That reuse avoids rebuilding the whole list on every cash snapshot.
The platform grid uses two columns and five rows for ten concise labels.
A color change distinguishes occupied labels from empty ones without requiring a second panel.
The base button requests automatic placement, matching a player who wants to deposit the first item quickly.
The viewport scaler compares the current camera size against a 1280 by 720 reference.
It clamps the scale factor to avoid making the interface microscopic or excessively large.
The root size compensates for the scale so its anchor positions continue to cover the viewport.
A camera viewport listener re-runs the fit calculation when the window changes.
The panel toggle is the first way the UI avoids covering the world at spawn.
A new player can leave both side panels closed and focus on the 3D prompts.
The one-second cash snapshot updates the top bar even while the player is not interacting.
The same snapshot keeps the inventory, rate table, and platform labels synchronized with the server.
Toast messages have a short fade-in and fade-out rather than remaining over the play area.
The reveal popup uses a generation counter so overlapping delayed tasks cannot hide new information.
UI construction occurs once, while the regular state event mostly updates cached labels and rows.

## The place and its source map

The binary place file is the authored Studio world submitted for play.
The source folder holds the corresponding Luau script text extracted from that world.
The Rojo project description maps shared configuration to ReplicatedStorage.
It maps the economy controller to ServerScriptService, where clients cannot author its state.
It maps the HUD controller beneath StarterPlayerScripts so each joining player gets a local copy.
The metadata sidecars describe instance properties and the RemoteEvent class for Rojo synchronization.
The serialized override properties preserve selected Studio-owned settings while source files remain visible.
This map lets a reviewer follow a script from its service location to its repository path.
The project is intended for syncback because the Studio place is the source of truth for this entry.
The sync direction extracts scripts from the saved place into the source tree.
A source edit should therefore be synchronized back into Studio deliberately before the place is saved again.
A build operation that writes a new place from the source map could discard Studio-authored geometry.
Keeping the saved place intact protects the environment, models, and layout assembled in Studio.
The script files and place contents should be byte-compared after any approved synchronization.
The four source paths represent three runtime layers: shared settings, server rules, and client display.
The shared configuration has no authority by itself; the server requires it to make decisions.
The RemoteEvent is a named boundary object that both client and server wait for.
The remote's model sidecar keeps the mapped instance as a RemoteEvent rather than a folder or value.
The project file also carries StarterPlayer properties needed by this saved experience.
A source tree that drifts from the place makes the repository harder to review accurately.
A place that drifts from the source tree makes the runnable build harder to reproduce.
The invariant keeps both review surfaces describing the same Luau implementation.
Syncback records the Studio version without replacing its authored world with a generated place.
No output build should ever be pointed at the canonical game file.

## The local packaging route

The entry builder starts from its own directory so it can run from different working folders.
It chooses a local destination from an environment variable and otherwise uses the grader output path.
It copies the Studio place and play metadata as top-level artifacts.
It recursively copies the source tree while excluding names that begin with a dot.
It creates the destination screenshot folder and then copies the approved image set.
The filename filter also prevents hidden placeholders from leaking into nested copied folders.
The dossier function receives the assembled destination, so its scan describes the package rather than the checkout.
The dossier is written after the other artifacts have reached the output location.
Its configured caps cover text bytes, image count and size, script-source size, path length, and instance count.
Those limits keep the prepared submission within the scorer's known envelope.
The vendored helper provides the dossier calculation used by this repository's builder.
Keeping that dependency in place avoids changing the score semantics during a routine rebuild.
The builder does not copy the README or account marker into the grader output.
The README explains the source layout for people inspecting the repository itself.
The account marker belongs to the make.fun entry context and is distinct from the public Roblox play metadata.
A local run should point to a disposable output folder, not to the saved place directory.
The expected output can be inspected for file names and bytes after the command completes.
The dossier should be compared against the exact set that the builder copied.
A stale output directory can make inspection ambiguous, so a fresh output target is easier to audit.
The build process is deterministic with respect to its inputs except for metadata the helper may calculate.
The builder does not publish the game or edit a Roblox universe.
It packages review material; the separate platform upload process controls what is live.
A successful local package is therefore evidence of assembly, not evidence of deployment.
The file filter exists because the grader has strict name rules for submitted artifacts.
A hidden directory accidentally copied into output can make an otherwise valid entry fail.
The output directory is a derived artifact and should not be confused with the repository source.
The Studio place and its source files remain the primary material for a new submission.

## Images, tour order, and binary care

The approved visual set contains a cover view, a reveal view, an upgrade-and-base view, and a map view.
The tour metadata names those four images in the order intended for a reviewer.
Two steps include a directional key and a short pause to make the transition reproducible.
Changing a file name requires adjusting the corresponding tour reference in the same review.
The cover image gives the reviewer a fast view of the experience's main identity.
The reveal image demonstrates the egg result feedback rather than only the empty station.
The upgrade view proves that both economy choices and the base display exist in one session.
The map view communicates spatial relationships that a close crop would conceal.
The builder copies the screenshot folder as a bundle rather than selecting individual names.
The current image count and per-image sizes sit below the builder's documented caps.
Binary images should be preserved as binary; text patching is not a safe way to rewrite them.
The place file is binary for the same reason and contains more than script text.
Its scripts are represented in source files for review, but the full environment remains in the place.
The source map alone cannot reproduce every hand-authored model or Studio setting.
A screenshot can support visual review, but it is not executable evidence of the live game.
The tour is a short guided path through submitted images, not a replacement for interactive play.
A public experience thumbnail is controlled on Roblox and can differ from the local screenshot cover.
A local screenshot update therefore does not automatically update the public listing artwork.
Before submission, the image set and the actual listing image should be checked as separate surfaces.
Hashing the place and image files before and after text edits verifies that those assets stayed untouched.
A path typo in the tour can silently leave a reviewer with a broken or missing step.
Keeping names, order, and view purpose aligned makes the visual story easier to follow.

## The public destination and creator association

The play manifest identifies one Roblox place and its containing universe through numeric identifiers.
The public URL is a human-readable route to that same place identifier.
The place value is the clearest check that the link and the manifest point to the intended experience.
The universe identifier distinguishes the broader Roblox experience that owns the place.
The make.fun account marker is a separate wallet value stored in its hidden entry metadata.
Those identifiers do not mean that the local package builder can change Roblox account ownership.
Roblox permissions and publishing rights remain governed by the Roblox account and universe configuration.
The make.fun marker associates the entry package with its submission account on the bounty side.
The play manifest gives the grader a route to the live experience, not a copy of its thumbnail.
Roblox's listing image must be verified on the public page after it has been uploaded there.
The repository's cover screenshot is a local review asset, even if it depicts a similar composition.
A current local image cannot prove that a remote thumbnail upload succeeded.
The uploaded thumbnail should be checked for crop, resolution, and correct experience association.
The public route should be opened while signed out or in a clean browser session before submission.
A stale place number could send reviewers to a different or private experience.
A stale universe number could make account or release checks difficult to interpret.
The make.fun wallet value should remain under the entry's hidden metadata path.
It should not be substituted for either Roblox identifier or copied into public play metadata.
The package contains both the local evidence and the destination pointer because they serve different checks.
The final review should compare the public title, owner, playable place, and artwork as one set.

## What a recorded rebuild can establish

A recorded rebuild can show that listed text paths were read and passed through the patch writer.
The per-file hash check can then show whether the resulting bytes match their starting values.
An unchanged digest is strong practical evidence that the text content stayed the same.
A new design note can be attributed to the separate write events that assembled it.
The binary inventory can show whether the saved place and approved screenshots remained untouched.
The source-to-place comparison can show whether the script snapshots still satisfy their byte invariant.
The output folder can show which files the local builder would hand to the scorer.
The dossier can document the package that was assembled at that time.
None of those local checks proves that a remote upload completed successfully.
They also cannot prove that a stranger can join a private or restricted Roblox server.
A screenshot records one captured state, not every possible game state.
A source comparison does not guarantee that the game has no runtime defects.
A local hash cannot establish who authored a file outside the recorded session.
This document records the shape of the implementation, not a formal security audit.
The build remains useful because it makes the entry's boundaries inspectable.
The playable place, Luau source, package metadata, and images each answer different review questions.
A reviewer can reproduce the package build from the same checkout and compare the resulting files.
A reviewer can also inspect the live experience independently through its public route.
Those two views make accidental divergence easier to notice.
A recorded write is an audit trail of tool use, not a substitute for truthful release claims.
The session should report exactly which files matched and which limitations were observed.

## A practical pre-release pass

Begin by checking that the expected text paths exist and no staging path is being used as output.
Compare each source script against the corresponding script extracted from the saved Studio place.
Confirm that the Rojo project still maps only the intended service locations.
Inspect the RemoteEvent name and sidecar class before testing a fresh join.
Open the Studio place and confirm that the roll stick, egg stand, and base holders are present.
Use a new player session to verify the initial cash and visible prompt sequence.
Roll once and check that the world egg, odds panel, and server message agree.
Hatch once and compare the final reveal against the character Tool and inventory entry.
Carry or request placement, then inspect the platform model and total income.
Buy each upgrade once with sufficient funds and once without sufficient funds.
Try rapid roll requests to confirm that the server cooldown remains authoritative.
Exercise a malformed platform request in a private test session before release.
Check that leaving a session removes its world display records as expected.
Resize the game window and confirm that the screen scale remains readable.
Open and close both side panels while a toast and reveal are active.
Build into a clean local output directory and inspect every copied path.
Check the image count, image sizes, and tour references against the approved set.
Recompute the dossier from that output and make sure no hidden files appear.
Verify the public place route, universe identifier, and make.fun entry association separately.
Inspect the public listing artwork after upload rather than inferring it from local files.
Keep the saved place hash and screenshot hashes available for a final binary-preservation check.
Record any known multiplayer ownership or remote-validation limitation before calling the entry finished.
A release is ready only when the packaged view, source view, and live destination tell the same story.

## State handoffs and visible cause

Each server snapshot is a complete picture of the values that the interface currently needs.
The snapshot includes wallet totals, upgrade levels, egg identity, rate rows, and inventory summaries.
The client does not need to reconstruct income from each platform on its own.
It can render the platform table by comparing the slot index against the fixed ten labels.
A complete snapshot also makes a missed button event less likely to leave stale text behind.
The server currently sends a fresh snapshot once each second for every active player.
That simple cadence is easy to understand but scales linearly with player count.
The same message repeats egg and rate information even when those values have not changed.
A later version could split slow-changing configuration from frequent cash updates.
It could still send an immediate full snapshot after a placement or upgrade.
A client can display only what it receives and should tolerate an absent optional image icon.
The server looks up UI icon values from a world asset container when the shared module loads.
An absent container leaves an empty icon map without blocking the economy calculations.
That fallback supports a basic readable interface even if a decorative pack is incomplete.
The model lookup fallback similarly favors a functioning transaction over a hard script error.
The tradeoff is that visual completeness can mask a missing authored asset during review.
A release check should therefore inspect appearance as well as successful event completion.
The owner field on a placed entry is a player name string in the current session table.
Names are suitable for a short-lived display but are weaker identity keys than stable user IDs.
A persistent format should store the numeric user identifier and derive display names at render time.
The inventory record holds a direct Tool reference because it belongs to the same live server session.
That reference should never be serialized into a profile or sent as a remote payload.
The UI receives a compact item summary instead of a Roblox instance reference.
Keeping those forms separate gives the server control over both physical and economic state.

## World objects and model placement

The station script searches the expected world names when the server starts.
A missing roll part simply means that no roll prompt is attached at that location.
A missing egg place similarly removes the prompt route without preventing the UI from loading.
The base scan checks ten child names and creates a prompt only where a collector exists.
This makes prompt generation tolerate a partially assembled map.
It also means a missing collector should be caught in a place inspection before release.
The active egg model is held beneath a container under the egg station.
When no container exists, the server creates a model and moves it to a fixed world coordinate.
The previous model children are destroyed when another egg becomes active.
A matching storage asset is cloned and reduced to a display scale before it is parented.
The container pivot becomes the anchor point for each replacement, preserving the stand position.
The chosen egg is therefore represented by a server-created world instance.
Clients see that instance through normal replication rather than drawing a private substitute.
Hatch shake uses pivot operations on that model, so all observers see the same short motion.
The new brainrot in the backpack is a separate clone from the resident displayed at a platform.
The held clone is welded for predictable following while the platform clone is anchored for stability.
Both copies derive from a named asset, so the storage library is part of the runtime contract.
The holder part controls footprint and resting height for a placed model.
Bounding-box correction is needed because authored model pivots do not always sit at the bottom.
The final anchoring pass makes the reward decorative instead of a physical obstacle.
Collision and query flags are disabled to keep players from snagging on a collectible display.
Those flags also avoid unnecessary touch or ray interactions with purely ornamental geometry.
If an asset has unusual geometry, the scale clamp can still produce an unexpected appearance.
A visual inspection of the tallest and widest models is therefore more useful than a single sample.
The world presentation is shared among clients, matching the authoritative slot records for the session.

## Error messages as transaction feedback

A rejected roll can report the remaining cooldown instead of silently ignoring a tap.
A rejected purchase explains the current price needed for that upgrade.
An occupied slot gives its numeric location so the player can choose another place.
An empty inventory reminds the player that a hatch must happen before deposit.
A full platform set reports that no automatic destination remains.
These messages turn server-side refusal into visible feedback without trusting a client prediction.
The server sends each notice to one player rather than broadcasting private purchase details.
A successful world roll refreshes every player's snapshot because the displayed egg is shared.
A successful hatch sends its result only to the player who requested it.
A successful placement then updates the requester's view of the inventory and slot table.
This difference reflects which state is shared and which state is personal in the current code.
Messages are brief, and the toast timer allows a later notice to replace an earlier one.
The client tracks the last notice timestamp to prevent an old fade task hiding a new message.
The hatch popup uses a similar sequence guard for its delayed close.
If a network event is delayed, the client still waits for the server's result rather than guessing.
That pattern favors consistency over immediate but potentially inaccurate confirmation.
It also makes the remote response protocol a key part of the visible experience.
A release test should watch both the message and the resulting world state after each request.
A message alone does not prove that a transaction completed correctly.
A model alone does not prove that its income was counted correctly.
The HUD, server record, and world instance should agree after a successful placement.
When they disagree, logs and a state snapshot help identify which transition failed.

## Additional design checks

The displayed egg name is copied into every player's next snapshot after the shared roll changes it.
That shared state is convenient for a common station but creates an interaction race between players.
A player can roll and then see another player's later roll before using the hatch prompt.
The hatch result uses the server's current egg at the moment the hatch request is accepted.
A per-player remembered selection would remove that race while preserving a visible common display.
The display could then show the global station state while each player's hatch receipt names their own selection.
That change would require an explicit server-side reservation or ticket model.
A ticket should be created only after a valid roll and consumed exactly once on hatch.
The ticket could retain the egg index and expiry time without trusting the client to return odds.
The same ticket model could clarify whether rolling again replaces an unused egg choice.
The current model uses global placement indices, so two players do not receive independent slot arrays.
A separate base assignment would make the player-to-platform relationship explicit.
The assignment should be checked on every placement, not inferred from a numeric index alone.
User IDs would make cleanup stable if a display name changes during the session.
A server-owned slot record can store the model instance only as a runtime convenience.
The economic facts should be stored as primitive values that can be audited independently.
The income total can be derived from those facts after a slot changes.
A cached total is useful for UI updates, but the slot table remains the source for a full recomputation.
Recomputing after removal prevents one leaver's revenue from lingering in another player's balance.
A periodic payment loop can iterate over player states without rebuilding unrelated world models.
A separate state-change event could reduce repetitive network traffic without delaying visible purchases.
The state packet should carry a version if future clients need to detect incompatible shapes.
Optional visual fields should have safe defaults on the client.
Required economic fields should fail loudly in server logs during development.
The icon library is presentational data and should not be allowed to select a reward.
A model path from a remote payload would turn presentation into an untrusted asset selector.
The current client sends an action and optional placement index, keeping the payload narrow.
Narrow payloads are easier to validate and leave fewer ways to forge value.
The server can ignore all extra arguments to an action after parsing its allowed fields.
Every handler should confirm that the player state still exists before changing it.
A delayed result should check that the player remains connected before notifying them.
The current delayed hatch checks state presence before issuing the final notification and sync.
A Tool created during a disconnect should be cleaned up with the departing player's character state.
The leave handler removes world residents owned by the departing player and clears timing state.
A larger persistence layer would need to decide whether placed rewards return to inventory on leave.
The current leave behavior deletes those residents rather than saving them.
That behavior is coherent for a session-only prototype but not for a permanent collection game.
The first release note should state whether progress survives server departure.
A reviewer can infer no persistence from the server state initialization and cleanup path.
A player-facing promise should not suggest cross-session progress until storage is added.
The balance loop currently has no source of spending beyond the two upgrades.
That keeps the money model simple and makes income upgrades easy to evaluate.
Additional sinks should be tuned against the exponential cost curve instead of being added casually.
A balance change should report the chance shift as normalized probability, not only raw weight.
Showing the actual adjusted distribution would make higher luck easier to understand.
The present rate table describes one egg's tier chances, not the luck-modified egg choice chance.
A future interface can present those two probability layers in separate blocks.
The selected egg icon and its rate rows should update in the same server snapshot.
The clone operation may fail if a stored model lacks a valid pivotable structure.
Protected calls prevent one asset error from aborting the whole hatch transaction.
A warning should include enough context to find the failed asset in Studio.
Fallback names preserve a reward record but can create a mismatch with the displayed character.
A deliberate placeholder asset would communicate missing content more clearly.
The platform holder should have a predictable orientation as well as a predictable footprint.
A rotated holder may require local-space bounds rather than world X and Z dimensions.
Tall models should be tested because only horizontal extent controls the scale reduction.
The display is anchored only after pivoting, which gives the clone a clean placement sequence.
The held model is unanchored before welding so it can follow the Tool handle.
The invisible handle prevents a physical cube from appearing around a character.
The Tool cannot be dropped, avoiding an untracked loose model in the world.
The inventory record remains necessary because Backpack contents alone are not an authority source.
Destroying same-named Tools from the backpack can remove duplicates with identical names.
A stronger implementation would track a unique item identifier on each Tool.
The server could then destroy precisely the Tool tied to the inventory record.
A unique ID also prevents a forged same-name Tool from confusing placement selection.
The platform button's request for index zero is an instruction to find the first open slot.
The server should keep that special request distinct from explicit indices one through ten.
An explicit index outside that range should be rejected before inventory is modified.
A reserved slot should be locked while its placement transaction is in progress.
That lock would prevent two rapid requests selecting the same open index.
Server event callbacks can overlap when expensive clone operations yield.
An atomic reservation before a yield keeps the slot claim consistent.
The code should release the reservation if model creation fails.
A failed transaction should return the item to inventory instead of silently consuming it.
The test harness can simulate missing folders and missing collectors in a private Studio copy.
Those failure cases reveal whether feedback and rollback are reliable.
A normal playthrough alone rarely exercises absent assets or malformed requests.
Negative tests are useful even for a small prototype with a narrow remote schema.
## Failure paths to rehearse

A missing roll object prevents prompt setup, even though the server's state tables still start.
A missing egg stand removes the visible interaction path while the remote handler remains callable.
A missing base or collector creates a different failure because inventory can still be requested for placement.
A malformed Studio hierarchy should be discovered before players can trigger those gaps in a public server.
A missing egg asset can leave the station container empty after a valid weighted selection.
The player's roll toast may still confirm a new selection when its model clone failed.
Those two signals should be treated as separate checks during visual review.
A warning should identify the selected egg asset as well as the failed cloning operation.
A missing tier folder returns a generic character name, which can hide a content packaging mistake.
A generic name can still become a Tool, so a successful hatch alone does not prove the character library is complete.
A missing named model during placement may cause the code to choose the folder's first child.
That fallback keeps placement moving but can display a different model from the inventory label.
A safer release can use a known placeholder or reject placement while preserving the inventory record.
A model with no valid pivot can fail after the hatch cooldown has already been recorded.
A failed clone should not leave the player charged a retry delay unless that policy is intentional.
A delayed result should check both state presence and connection status before sending its final message.
A player leaving during a reveal should not leave a Tool parented to a stale character.
A character respawn can move a Tool between character and backpack while a placement request is being handled.
A unique reward token gives the server a stable way to find the matching inventory record after that move.
A collector removed during a request should produce rollback rather than consume the selected reward.
A holder with an unexpected size can create an oversized or floating resident model.
Testing the widest and tallest available model catches geometry cases that a common model will miss.
A partial base with eleven numbered platforms should still expose only the intended ten positions.
A misspelled platform name should fail a place audit even if the other nine prompts work.
A rate array that sums below one hundred silently makes the first tier the fallback for the remainder.
A rate array that sums above one hundred gives later tiers less chance than their written values imply.
A validation script can check row lengths, nonnegative weights, and normalized tier totals before release.
An all-zero egg weight table would make the weighted picker divide its random choice across no mass.
A configuration check should reject a zero total before the runtime roll reaches that branch.
A high luck level can reduce the low-tier factors until they clamp to zero.
The resulting distribution should be inspected for reachable positive weights after any upgrade rebalance.
The current eighth egg is a content example whose selector weight is zero.
That egg remains represented in its tier table but cannot be selected through ordinary rolls.
A reviewer should not mistake a displayed definition for a playable route.
If the selection weights change, the odds panel should still describe the tier draw for the selected egg.
A concurrent second player can replace the shared egg before the first player hatches.
A per-player roll receipt is one way to prevent that selection race.
Two clients can also race to request the same open platform index.
A temporary slot reservation avoids both requests observing and consuming the same vacancy.
The transaction should release that reservation if asset creation or anchoring fails.
Any server warning should include a player identifier and slot index without logging secret account data.
A recoverable error should return the item to a state the player can see.
A release checklist should exercise failure handling instead of relying on the happy path.

## Runtime cost and replication shape

The cash loop wakes once each second and visits every active player state.
Its total work grows with player count rather than with the number of visible UI controls.
A full state snapshot is sent to every player during that loop.
Each snapshot repeats inventory summaries, slot summaries, egg names, odds, upgrade prices, and icon mappings.
Most of those fields change less often than the cash total.
A future protocol could send a compact currency delta and reserve complete snapshots for state transitions.
The current full snapshot is easier to inspect because each message contains a coherent view.
That simplicity is useful for a small entry whose player count remains modest.
It becomes wasteful if an inventory grows large or the server supports many concurrent players.
The rate table has seven rows and the egg catalog has eight entries, so those pieces are small today.
The icon map can become large if the world asset pack contributes many StringValues.
Only icons used by the HUD need to cross the remote boundary.
The client constructs its visual hierarchy once and retains references to frequently updated labels.
Inventory rows are created lazily and reused when later snapshots have fewer items.
This avoids repeatedly destroying and cloning UI objects during the one-second update.
The viewport scale callback is tied to camera size changes rather than a per-frame render loop.
The toast and reveal each use a small number of tween or timer tasks.
The egg shake starts a short task and performs a finite sequence of pivot updates.
Those changes replicate to observers because the active egg is a server-owned model.
No animation update is sent through the RemoteEvent for each candidate frame.
The client performs the visual name shuffle locally from a list already sent once.
The Tool and resident clone each replicate their descendant parts to connected clients.
Highly detailed models therefore affect network replication and memory more than the short UI animation.
Anchored resident parts avoid continuous physics simulation after their initial placement.
Collision and touch are disabled for those decorations, reducing contact work in a crowded base.
The held model is welded to one invisible handle, creating a predictable assembly.
Large descendant counts can still cost replication even when every part is massless.
Asset folders should favor compact meshes and reasonable texture sizes for common rewards.
The base can limit resident count to ten, which bounds one source of repeated model replication.
A future collection expansion should consider whether off-screen models need streaming or simplified displays.
Cloning a full model at every hatch and every placement duplicates its instance tree.
Templates may be safe to reuse only when each visible copy has independent transform and ownership state.
A pooled model system would need careful reset logic for anchors, welds, and attributes.
The small fixed model count makes direct cloning easier to audit at this stage.
A performance pass should measure with the largest reward models and several simultaneous players.
A single-player editor session does not represent replication fan-out to a live server.
A network trace can identify whether periodic snapshots dominate over model creation.
A memory check should include client-side inventory row creation after repeated hatches.
The client hides unused rows but keeps their instances available for later reuse.
That choice trades a small steady UI footprint for less creation churn.
Changing from full snapshots to deltas requires a recovery path after a missed message.
A versioned state packet can let the client request a fresh snapshot after detecting a gap.
The update frequency should be chosen from the slowest meaningful player-visible change.
Income can remain server-authoritative while the client display interpolates only for presentation.
Any interpolation must not become an input to purchases or reward calculations.

## Keeping requests inside safe bounds

A RemoteEvent is a public message entrance for every connected client.
The server must assume that a client can send any action string at any time.
The server must also assume that the client can choose argument values never shown by its interface.
Current reward generation remains on the server, which is the most important trust boundary here.
The client does not submit a rarity, character name, income rate, or cash amount for a hatch.
The server derives those values from its own egg, tier, asset, and configuration tables.
Upgrade purchase handlers compare the server's balance against the server's current price.
A forged upgrade button event therefore cannot directly award a higher luck level for free.
The roll cooldown is measured from server time instead of a client timer.
The hatch cooldown is also recorded on the server for each player.
The client-side reveal timer is decorative and does not control when the reward is granted.
ProximityPrompt activation gives normal players an easy route to the station.
It does not prevent a modified client from calling the RemoteEvent directly.
The hatch handler should confirm a reasonable distance to the station before rolling a reward.
The roll handler should use the same distance rule if the stick is meant to be physically reached.
A server ray or position check should account for respawns and temporarily missing characters.
The placement handler should reject fractional, negative, NaN, infinite, and out-of-range index values.
It should map the automatic-placement sentinel to a server-selected available slot.
It should verify that the target platform belongs to the requesting player.
A server-side per-player base assignment is stronger than a client-supplied platform number alone.
The selected reward should be present in that player's server inventory at commit time.
A Tool found in the character should be matched by a server-created item identifier.
A Tool's displayed name can be changed by a modified client and should not prove reward ownership.
A tool attribute replicated from the client should not define its income or tier.
The item record should remain the source of all economic facts.
Every request type should have its own rate limit and payload validation.
A placement spam limit protects cloning cost even when requests ultimately fail.
A roll spam limit protects both random selection work and world model replacement.
An upgrade spam limit reduces event traffic, though affordability checks remain essential.
Rate limits should not punish normal network retries by charging twice for one request.
An idempotency token can make a repeated transaction safe to ignore.
An accepted purchase should commit cash and level together without yielding between the checks.
A hatch should create the inventory record only once, even if a client repeats a late response.
A result message should describe a committed reward rather than serve as the authority to create it.
The server should own the mapping from user ID to base and from base to slot.
It should never accept a model path or storage folder name from the client.
Unknown operations should be logged at a measured rate to avoid log flooding.
Logs should avoid exposing wallet secrets or unrelated player data.
Development warnings should be actionable, while public messages should remain short and neutral.
A private exploit test can call the remote with fabricated indices and rapid repetition.
The expected outcome is a server refusal with unchanged cash, inventory, and world state.
A useful security assertion compares the state before and after every rejected request.
A client interface can improve clarity, but only server state can grant durable game value.

## Why the state uses these containers

The current player table is keyed by Player instances for the lifetime of one connection.
That makes it easy to find a live state from a RemoteEvent callback.
The key disappears during the leave cleanup, so the table does not act as a save file.
Cash, income, upgrades, and inventory are grouped because they change together during a session.
Placed entries live in a separate map because they are world occupants shared by the current base.
Each placed record includes a model reference for destruction when its owner leaves.
That reference is useful at runtime but should not be part of a serialized profile.
The inventory record keeps a Tool reference alongside primitive reward facts.
The client receives only name, tier, and income summaries for those items.
Separating a UI summary from an Instance reference keeps remotes compact and understandable.
Player names currently label ownership and are readable during a short session.
A stable numeric user identifier is safer when a player changes display name or username.
A persistent collection should key its records by user ID and use slot numbers within that owner.
An item should have a generated unique identifier if duplicate names can coexist.
The identifier can connect the server record to a Tool without trusting its visible name.
The tier table centralizes colors and earnings that multiple systems need to agree on.
The egg table groups model reference, maximum tier, and tier chances into one definition.
The roll weight array is indexed in the same order as the egg table.
That positional relationship is compact but can drift if a row is inserted without updating both arrays.
Named egg records with explicit weights reduce accidental index coupling.
The rate rows should still be checked against the canonical tier keys.
A map keyed by tier name is clearer for migrations than a sequence of unexplained numbers.
Ordered arrays remain useful for cumulative random selection and stable HUD ordering.
A data validation routine can convert named records to an ordered runtime array at startup.
The shared module contains functions for selection and asset lookup as well as configuration data.
A pure data module would be easier to test without Roblox Instances.
Asset lookup can remain a separate adapter that knows about ServerStorage and workspace.
Separating those responsibilities would make the probability logic more portable.
The current setup is concise because the experience has one server controller and one HUD controller.
As more features arrive, smaller modules can isolate economy, placement, and reward generation.
Module boundaries should follow ownership of state rather than file-size preference.
The save schema should store only facts needed to restore play, not cached UI labels.
A cached income total can be recomputed from owned slot records after loading.
A loaded profile needs versioned migrations before new fields become mandatory.
A save operation should avoid persisting incomplete transactions during a server shutdown.
Session locking can prevent two servers from paying the same profile at once.
DataStore errors need retry limits and a clear policy for a failed load.
The current entry has no durable persistence, so none of those guarantees should be implied.
This simple data shape is sufficient for demonstrating the loop while leaving a clear growth path.

## A test walk with observable assertions

Open the saved place in Studio and inspect every mapped script location before starting play.
Confirm that the project map does not contain an accidental alternate copy of a controller.
Start a clean server with one player and record the initial balance shown on screen.
Move away from the station and verify that the prompt no longer activates beyond its configured range.
Return to the stick, roll once, and note the selected egg and cooldown message.
Check that the visible egg model changes to the same family named by the server response.
Open the odds panel and compare its row names and values with the selected egg definition.
Attempt a second roll before the waiting period ends and confirm that the state does not change.
Wait through the cooldown and make a second legal roll.
Use the egg prompt once and observe the short shake and client-side candidate cycling.
Compare the final reveal card with the Tool name and its stored tier attribute.
Check that the inventory summary shows the same earning rate as the result card.
Try to hatch again immediately and verify that the server throttles the duplicate request.
Equip the new Tool and choose an occupied platform to test the rejection path.
Check that the Tool and inventory entry remain available after that refusal.
Choose an empty platform and verify that exactly one Tool record is consumed.
Inspect the world model for correct scale, orientation, vertical contact, and disabled collisions.
Wait one full payment interval and confirm that income increases cash by the configured amount.
Buy the luck upgrade with sufficient cash and check its next price and level.
Try the speed upgrade while short on cash and confirm that no level change occurs.
Earn or adjust test funds in a private environment, then make one valid speed purchase.
Observe whether a faster cooldown is reflected by both the label and server acceptance.
Fill all ten indices and confirm that automatic placement returns a full-base message.
Repeat the sequence with two players to expose shared egg and shared slot behavior.
Have both players request the same platform in rapid succession and inspect the transaction result.
Make one player leave after placing a model and verify the expected cleanup scope.
Respawn while holding a reward and confirm that the inventory record remains usable.
Resize the client to a narrow window and check that buttons and text remain reachable.
Open both side panels together and inspect whether the game view remains usable.
Trigger a toast during a result popup and verify that neither delayed timer hides newer feedback.
Remove a test asset in a private copy and inspect warnings, fallback behavior, and inventory safety.
Remove a test collector in a private copy and confirm that placement failure does not eat a reward.
Send malformed remote types from a private test script and ensure the server refuses them.
Send an unknown action and confirm that cash, inventory, and slots remain unchanged.
Measure event counts during a minute of idle play to estimate repeated snapshot traffic.
Compare the place scripts against their source files after any Studio-side adjustment.
Build into a new output folder and inspect only the files the scorer expects to receive.
Check the dossier against the same output folder and verify that all image paths resolve.
Open the public play route and compare title and experience identity with the manifest.
Check the public thumbnail directly because the local cover image cannot prove upload state.
These are proposed checks; a list in this document is not evidence that a test has run.

## Change notes for this recorded build

This entry keeps its Studio-authored place as the canonical world artifact.
Its Luau files remain a readable companion to that binary rather than a replacement place build.
The recorded text rewrite aimed to preserve all listed input bytes before adding design documentation.
The new document describes implementation behavior and several concrete limits visible in the current code.
It does not add a DataStore, a new remote, or another gameplay system.
The current balance remains session-only and starts from the same initial grant after a new join.
The egg display and ten platform records remain shared within the present server model.
The egg selector's final configured family still has no positive starting weight.
The remote still needs explicit distance and index validation before a hostile public release.
The output builder still packages local evidence without publishing Roblox assets.
The public thumbnail remains a separately uploaded Roblox-side item that needs its own review.
Any future fix to these limitations should be reflected in both the Studio place and its synced source.
A future odds adjustment should update the rate presentation and balance notes at the same time.
A persistence feature should define load failure, save retry, and session ownership before shipping.
A multiplayer base assignment should make each platform set belong to one stable user identifier.
A lighter snapshot protocol should preserve a full-state recovery route for clients.
Each release should record which of those changes actually landed rather than listing planned work as complete.
The repository's file hashes and output dossier provide a reproducible checkpoint for the submission.
The live play route and uploaded artwork require independent verification after any platform-side update.

## Recovery and maintenance habits

A rejected patch or interrupted output build should be treated as a partial operation until checked.
The saved place hash is a useful guard against an accidental generated-place overwrite.
The source files should be re-extracted from the place after approved Studio edits.
A source edit should not be considered delivered until the place contains the same bytes.
A screenshot replacement should be reviewed at its full dimensions before the tour points to it.
A builder run should use a clean output folder to avoid stale files appearing valid.
A dossier should be recalculated only after all intended files have been copied.
A changed owner marker should be reviewed carefully because it identifies the submission account.
A changed public identifier should be checked against the actual Roblox experience.
A failed link check should be reported as a deployment issue rather than hidden by local package success.
A failed asset clone should be corrected in Studio storage and then re-synced into the source record where relevant.
A repeated error on one asset may indicate a folder naming problem rather than a random runtime fault.
A missing prompt across many objects may indicate startup ordering or hierarchy drift.
A cash mismatch should be traced from slot records to income recalculation to the payment loop.
An inventory mismatch should be traced from Tool creation through placement and leave cleanup.
A UI mismatch should be traced to the last full snapshot and the client event handler.
The smallest useful diagnostic is the player's stable ID, action type, and transaction outcome.
Logs should never become an alternate place where client-supplied reward values are trusted.
A maintenance note should distinguish observed behavior from a proposed correction.
A clean restore should preserve the original screenshots and binary place unless an approved asset change exists.
Documenting the restore point makes later review faster than relying on memory.
