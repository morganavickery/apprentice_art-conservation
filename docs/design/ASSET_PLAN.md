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

**Names:** `<condition_id>_<type>.png`, using the asset codes from `conditions_reference.md` in lowercase: `vis`, `uv`, `rak` (normal map), `prog`, `dmg`, `mask`. Examples: `surface_grime_vis.png`, `paint_loss_edge_01_rak.png`.

**Format:** PNG with transparency, except base images, which are JPEG (photos, no transparency, smaller web build) at 2048 px on the long edge. Tileable textures at 1024 × 1024.

**Working files** (`.kra`, `.ptex`) stay out of Git. Material Maker projects live in `material maker/` and Krita files in `krita/`, both at the repo root and excluded by `.gitignore`. Only exported PNGs are committed.

**Logging:** third-party assets get an `ASSET_LOG.csv` row before committing. Suggested: log your own work too, with license "original", so in-game credits are complete.


## Which tool for what

| Tool | Makes |
|----|----|
| Material Maker | Tileable procedural textures and their normal maps: dust, haze, ground, putty, cracks, weave |
| Krita | Hand-drawn shapes and sprites: loss shapes, tool sprites, touch-ups to exported textures |
| Laigter | Normal maps from Krita shapes (for raking light) |
| Godot | Masks (`NoiseTexture2D`, seeded, or library shapes placed by `ShapeMask`) and color shifts (shaders). |
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
- [x] **Material Maker:** application map, grayscale and tileable: brush streaks, pooling, uneven coverage → `conditions/discolored_varnish/discolored_varnish_mask.png`. One map drives the visible thickness, the UV haze pattern (the non-color cue), and the streaky mid-removal state, so they line up.
- [ ] **Krita:** amber swab state → `tools/swab_amber.png`

**Paint loss (edges)**

- [ ] **Krita:** 8 to 12 irregular loss shapes, white on transparent, varied sizes and ragged edges → `conditions/paint_loss/paint_loss_edge_01_vis.png`, `paint_loss_cluster_01_vis.png`, … (these act as masks: the ground shows through them). See the loss shape spec below.
- [x] **Material Maker:** ground texture, off-white with faint canvas weave, tileable → `conditions/paint_loss/paint_loss_ground_vis.png`
- [ ] **Laigter:** a normal map for each loss shape, edges recessed → `conditions/paint_loss/paint_loss_edge_01_rak.png`, … If a loss looks raised instead of sunken under the light, use Laigter's invert option.
- [ ] **Material Maker:** smooth white fill putty → `conditions/paint_loss/paint_loss_prog.png`

**Loss shape spec**

Godot's `ShapeMask` (`core/items/shape_mask.gd`) places these shapes on a painting by region preset, seed, and severity, scaling, flipping, and rotating them, so one set serves every painting. References and what they show: `conditions_reference.md`, Paint loss, Reference notes.

| Kind | Count | Used by | What it looks like |
|----|----|----|----|
| `edge` | 5 | the `edges` preset (Vos, Wheat Field) | A ragged band with its flat side along the bottom of the canvas. Godot rotates it to whichever edge it is placed on. |
| `cluster` | 4 | interior presets (scattered patches, single spot) | A group of angular flakes away from any edge. |
| `crack` | 2 | interior presets | A thin line of small flecks, as along a crack or old fold. |

All kinds:

* **Canvas:** 512 × 512 px, transparent background. In game a shape is drawn between about 90 and 430 px wide on a 2048 px painting, so 512 is never enlarged.
* **Color:** anything; only transparency is used. White is easiest to check.
* **Fill:** fully opaque inside the loss, with crisp edges. No soft, textured, or semi-transparent brushes: partial transparency shows as partial loss.
* **Edges:** many short straight segments that jog every 10 to 30 px, breaking along the crack network. Avoid long straight lines and smooth curves.
* **Detached flakes:** 8 to 25 px across. Smaller ones disappear when the shape is scaled down.
* **Clean canvas:** no stray marks. Before exporting, view the shape over a dark background to catch faint strokes.
* **Variety:** vary depth, density, and which side is heavier. Avoid distinctive features: the game flips and repeats shapes, and a memorable one gives the repetition away.
* **Export:** PNG with "Store alpha channel" on. Working file: `krita/paint_loss_<kind>_<nn>.kra`.
* **Names:** `paint_loss_<kind>_<nn>_vis.png`, numbered from `01` within each kind; normal maps use the same name with `_rak`.

By kind:

* **`edge`:** the flat side runs along the bottom row of the canvas and tapers out at least 16 px before the left and right sides (otherwise the band ends in a visible vertical cut). The band reaches 60 to 150 px up, with one or two bays up to about 250 px. Detached flakes sit just above the band; the top 200 px stays otherwise empty.
* **`cluster`:** centered, at least 16 px from every side, 150 to 350 px across, built from plates 15 to 60 px wide, with 5 to 12 detached flakes around it.
* **`crack`:** a chain of flecks 3 to 12 px wide and 250 to 450 px long, roughly straight or gently bent, at least 16 px from every side.

After exporting, add each shape's row to `ASSET_LOG.csv` (license "original"), then add it to the Loss node's `shape_textures` list in `games/conservator/sandbox/condition_test.tscn` to see it in the sandbox.

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


