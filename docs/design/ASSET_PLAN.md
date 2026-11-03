# Asset Plan

An ordered to-do list for making condition overlays and other art: what to make, with which tool, and where it goes. Companion to `conditions_reference.md` (what each condition needs) and `DEVELOPMENT_PLAN.md` (when it fits in the overall project).

Uses the Vos opener (*Alice Barney in White Satin*), confirmed in Step 0. Its conditions (surface grime, discolored varnish, edge losses) also appear in Penniman, Bricher, and De Haas, so the work carries over if the opener changes.


## Conventions

**Folders** (inside `games/conservator/assets/`):

| Folder | Contents |
|----|----|
| `art/` | Base images of paintings (post-treatment photos) |
| `conditions/<condition_id>/` | Library textures for one condition. Created so far: `surface_grime/`, `discolored_varnish/`, `paint_loss/` |
| `tools/` | Tool sprites (swab, loupe, lamps, bottles) |

**Names:** `<condition_id>_<type>.png`, using the asset codes from `conditions_reference.md` in lowercase: `vis`, `uv`, `rak` (normal map), `prog`, `dmg`. Examples: `surface_grime_vis.png`, `paint_loss_shape_01_rak.png`.

**Format:** PNG with transparency, except base images, which are JPEG (photos, no transparency, smaller web build) at 2048 px on the long edge. Tileable textures at 1024 × 1024.

**Working files** (`.kra`, `.ptex`) stay out of Git. Material Maker projects live in `material maker/` at the repo root, which `.gitignore` excludes. Other working files stay outside the repo, in a folder that mirrors the one above (e.g., `~/Documents/apprentice_art_src/`). Only exported PNGs are committed.

**Logging:** third-party assets get an `ASSET_LOG.csv` row before committing. Suggested: log your own work too, with license "original", so in-game credits are complete.


## Which tool for what

| Tool | Makes |
|----|----|
| Material Maker | Tileable procedural textures and their normal maps: dust, haze, ground, putty, cracks, weave |
| Krita | Hand-drawn shapes and sprites: loss shapes, tool sprites, touch-ups to exported textures |
| Laigter | Normal maps from Krita shapes (for raking light) |
| Godot | Masks (`NoiseTexture2D`, seeded) and color shifts (shaders). No image files needed. |
| Canva | Reference boards; cleanup of your own photos (e.g., background remover, Magic Eraser). Don't put Canva stock media into assets: its license isn't open. |


## Step 0: Decisions

- [x] Confirm the opening case: Vos, *Alice Barney in White Satin*
- [x] Base image working resolution: 2048 px on the long edge for now; revisit after the web smoke test (some Chromebooks cap texture size around 4096 px).
- [x] Create the folders above (each needs a `.gitkeep` until it has a file, or Git won't track it). Condition folders exist for the opening case's three conditions; add others as needed.


## Step 1: References (Canva)

One page per condition. Label each image with its source URL and exactly what it shows.

- [ ] **Surface grime:** cleaning windows where only grime was removed. Note the color and where grime collects (recesses, bottom edge).
- [ ] **Discolored varnish:** half-cleaned paintings and cleaning windows. Use the eyedropper to record the color of the same paint under varnish and after cleaning. Three to five of these pairs are the input for the varnish shader.
- [ ] **Varnish under UV:** greenish fluorescence of natural resin varnish; retouching showing as dark patches.
- [ ] **Varnish mid-removal:** streaky, uneven, partly dissolved.
- [ ] **Paint losses:** edge losses showing ground, losses down to canvas; raking-light photos showing depth.
- [ ] **Fills before inpainting:** white putty, level with the surface.

Done when each condition has three to five images you could point to and say "this is what it looks like."


## Step 2: One condition end to end (surface grime)

Goal: prove the chain *Material Maker → PNG → Godot* works before making everything else. This is the art side of Milestone 2.

- [x] Download the Vos base image from Smithsonian Open Access (CC0), resize to the working resolution → `art/vos_alice_barney.jpg`. Add the `ASSET_LOG.csv` row by hand (the fetch tool only handles the Met).
- [x] **Material Maker:** fine dust and grain texture, grey-brown, mostly transparent, tileable → `conditions/surface_grime/surface_grime_vis.png`
- [x] **Godot:** test scene with the overlay on the base image, masked by seeded noise, with a severity slider
- [x] Compare against the Canva references at severities 0.3, 0.6, and 0.9; adjust and re-export until it reads as grime
- [ ] **Krita:** swab sprite in two states → `tools/swab_clean.png`, `tools/swab_grime.png`


## Step 3: The rest of the opening case

**Discolored varnish**

- [x] No VIS file: a shader color shift, tuned with the color pairs from Step 1, masked by Godot noise for uneven thickness
- [ ] **Material Maker:** application map, grayscale and tileable: brush streaks, pooling, uneven coverage → `conditions/discolored_varnish/discolored_varnish_mask.png`. One map drives the visible thickness, the UV haze pattern (the non-color cue), and the streaky mid-removal state, so they line up.
- [ ] **Krita:** amber swab state → `tools/swab_amber.png`

**Paint loss (edges)**

- [ ] **Krita:** 8 to 12 irregular loss shapes, white on transparent, varied sizes and ragged edges → `conditions/paint_loss/paint_loss_shape_01_vis.png`, `_02`, … (these act as masks: the ground shows through them)
- [ ] **Material Maker:** ground texture, off-white with faint canvas weave, tileable → `conditions/paint_loss/paint_loss_ground_vis.png`
- [ ] **Laigter:** a normal map for each loss shape, edges recessed → `conditions/paint_loss/paint_loss_shape_01_rak.png`, … If a loss looks raised instead of sunken under the light, use Laigter's invert option.
- [ ] **Material Maker:** smooth white fill putty → `conditions/paint_loss/paint_loss_prog.png`

**Raking light check**

- [ ] **Godot:** one loss shape with its normal map under a movable light, to confirm raking light reads correctly


## Step 4: Workbench placeholders

Rough is fine; final art is Phase 5.

- [ ] **Krita:** loupe, UV lamp, raking lamp, solvent bottle (with a text label, not color alone), spatula, fine brush → `tools/`


## Later

Not needed for the demo's first pass.

* Damage overlays (DMG): abrasion from over-cleaning, solvent damage. Needed once consequences are built (Phase 3).
* Craquelure, cupped cracking, weave impressions, broken impasto (Material Maker), for Wheat Field and Bricher
* Debris and inclusion sprites (Wheat Field)
* Audio and captions (Phase 5)
* Final art pass (Phase 5)


