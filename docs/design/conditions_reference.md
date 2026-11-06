# Conditions, Treatments, and Assets Reference (Paintings)

Working reference for mocking up condition overlays and treatment assets. Scope: paintings on canvas and panel. Works on paper and manuscripts get their own reference later.

**Status: draft.** Compiled from the Met's technical notes for *Wheat Field with Cypresses*, SAAM treatment records (see `case_candidates.md`), and background reading (Wikipedia: *Paintings conservator*; *Conservation and restoration of paintings*). Every condition and treatment needs SME review before content lock.

Source tags: **\[Met\]** Met technical notes, **\[SAAM\]** SAAM treatment records, **\[WP\]** Wikipedia background reading, **\[verify\]** common in practice but not yet in our sources.


## How the layers work

A painting is a stack of physical strata, and the game renders it the same way. Each condition lives on one stratum:

```
7  Surface        grime, debris
6  Varnish        discolored varnish, bloom
5  Later paint    old retouching, overpaint
4  Paint          flaking, losses, cracks, abrasion, fading
3  Ground         (exposed by losses)
2  Support        tears, distortion, mold, water damage, panel splits
1  Structure      lining, stretcher or panel, tacking edges
```

Because treatment reaches strata top-down, **order matters naturally**: you cannot inpaint a loss under grime and varnish, and cleaning over flaking paint removes original paint. The stack is the sequencing logic of the tutorial.

**Base image:** the CC0 post-treatment photo. Overlays recreate a pre-treatment state; treatment removes them and reveals the real photo.

**Painting-neutral overlays.** Every overlay comes from one shared texture library that can be applied to any painting in the game. Infinite mode requires this, and the campaign uses the same structure. Campaign fidelity is about the treatments, sequences, and methods, not the visuals: if a painting historically had surface grime, the case applies the surface grime overlay, even if it lands in a different place than it did on the real painting. A painting's in-game "before" state will not match its real before-treatment photos, and that is fine.

**Placement.** A condition instance places a library texture on a painting with:
- **Region preset:** overall, edges, corners, lower half, upper half, scattered patches, or a single spot
- **Seed:** varies the mask so the same texture looks different on each painting (random in infinite mode, fixed per campaign case so it is the same every playthrough)
- **Severity (0.0–1.0):** drives opacity, mask extent, or both

**Generated, not photographed.** Examination views and treatment effects are produced by shaders that transform the base image's colors (e.g., darken and add a fluorescent veil for UV; shift toward yellow-brown for discolored varnish; desaturate for fading), combined with library textures.

**Backburner:** painting-specific extras such as real X-radiographs or per-painting height maps. Revisit after the core system works.


## Asset types

| Code | Asset | Notes |
|----|----|----|
| VIS | Visible-light texture | Tileable, painting-neutral texture with alpha (or a color shift for varnish). Never drawn for a specific painting. |
| MASK | Distribution mask | Grayscale noise or shape set; generated from region preset + seed, thresholded by severity. |
| UV | UV-fluorescence texture | What the condition looks like under UV. Needs a non-color cue too (pattern, outline, or label). |
| RAK | Raking-light texture | Tileable height or normal map for surface topography (cracks, cupping, distortion). |
| IR / XR | Infrared or X-ray texture | Only for conditions that show there (e.g., losses and fills read differently in X-ray). Painting-specific real images are optional item extras, not library assets. |
| PROG | Treatment progress | Usually none: treatment erases the overlay through a brush mask. Some need an intermediate state (e.g., varnish partly dissolved, fill before inpainting). |
| DMG | Damage overlay | Added, not removed: the result of a wrong or badly sequenced treatment. Irreversible. |
| TOOL | Tool sprite and cursor | Shared across conditions (see Tools). |
| SFX | Sound + caption | Tactile feedback; every meaningful sound needs a caption. |


## Treatments

Reversibility follows the game's three levels. Removal is inherently irreversible; additive conservation materials are chosen to be removable by a skilled conservator; tests and documentation change nothing. Ranks follow the draft ladder in `game_systems.md`.

| Treatment | What it does | Reversibility | Rank | Source |
|----|----|----|----|----|
| Documentation | Records condition, photographs, notes | Reversible | 1 | \[WP\] |
| Spot test | Tests a solvent or method on a tiny, discreet area | Reversible | 1 | \[SAAM\] \[WP\] |
| No treatment / monitor | A deliberate choice to leave a condition | Reversible | 1 | \[Met\] |
| Surface cleaning | Removes dirt and grime (e.g., pH-balanced water-based solution) | Irreversible | 1 | \[SAAM\] \[Met\] |
| Consolidation | Secures loose or flaking paint with adhesive | Mentor-reversible | 2 | \[SAAM\] \[WP\] |
| Varnish removal | Removes discolored varnish with solvents or solvent gel | Irreversible | 2 | \[SAAM\] \[WP\] |
| Retouching / overpaint removal | Removes later paint that covers original | Irreversible | 3 | \[WP\] \[verify\] |
| Filling | Puts putty-like material in paint losses, level with the surface | Mentor-reversible | 3 | \[SAAM\] \[WP\] |
| Inpainting | Paints only within losses or fills, with removable conservation paint | Mentor-reversible | 3 | \[SAAM\] \[WP\] |
| Varnishing | Applies a stable, non-yellowing varnish | Mentor-reversible | 3 | \[SAAM\] \[WP\] |
| Humidification and flattening | Relaxes distortion or cupping with moisture and weights | Mentor-reversible \[verify\] | 4 | \[SAAM\] |
| Tear repair | Mends torn canvas with adhesive or sewing | Mentor-reversible | 4 | \[WP\] |
| Strip-lining | Reinforces weakened tacking edges | Mentor-reversible | 4 | \[WP\] |
| Lining removal | Removes a failed lining | Irreversible | 4 | \[WP\] |
| Facing | Secures the paint with tissue before structural work | Mentor-reversible | 4 | \[WP\] |

Historical only (appear in object histories, not as player options): full lining, cradling, transfer. \[WP\]


## Conditions

### Stratum 7: Surface

#### Surface grime

* **Cause:** dust, soot, smoke, handling, airborne pollutants. \[WP\]
* **Revealed by:** visible light; a cleaning test shows how much comes off.
* **Treatments:** spot test → surface cleaning.
* **Mistreatment:** cleaning too aggressively abrades paint or reaches into varnish unevenly.
* **Assets:**
  * VIS: grey-brown film, heavier in recesses of impasto and along the bottom edge.
  * MASK: uneven distribution.
  * RAK: grime sits in the valleys of brushwork (subtle).
  * DMG: abrasion (see Abrasion).
  * SFX: swab on surface; caption "Swab rolling over the surface."
  * Extra: dirty swab texture (swabs picking up grey-brown grime). Strong tactile payoff.
* **Cases:** Vos \[SAAM\], Wheat Field \[Met\], Penniman \[SAAM\], Bricher \[SAAM\], De Haas \[SAAM\].

#### Embedded debris vs. original inclusions

* **Cause:** non-original debris stuck in the paint or grime; or material that was there from the start (e.g., the wheat husk painted into *Wheat Field with Cypresses* outdoors). \[Met\]
* **Revealed by:** magnification, raking light.
* **Treatments:** remove debris mechanically; leave original inclusions and document them.
* **Mistreatment:** removing an original inclusion. Irreversible.
* **Assets:**
  * VIS: small sprites (fibers, grit, a husk), each tagged as debris or original.
  * RAK: small raised bumps.
  * DMG: small socket left in the paint where an original inclusion was removed.
* **Cases:** Wheat Field \[Met\].

### Stratum 6: Varnish

#### Discolored (yellowed) varnish

* **Cause:** natural resin varnishes yellow and darken with age; may also be non-original, added later. \[SAAM\] \[WP\]
* **Revealed by:** visible light (overall yellow-brown cast); UV (natural resin varnish fluoresces, typically greenish); spot test.
* **Treatments:** spot test → varnish removal → (later) varnishing.
* **Mistreatment:** wrong solvent or too much action dissolves original paint or glazes.
* **Assets:**
  * VIS: global color shift (multiply layer, yellow-brown) with uneven thickness: denser in recesses, thinner on high points.
  * MASK: thickness variation; removal reveals the base image underneath through a brush mask. One tileable application map (brush streaks, pooling, uneven coverage) drives VIS, UV, and PROG, so a streak sits in the same place in every view.
  * UV: greenish fluorescent veil; non-color cue: haze pattern + "varnish" label. Streaks and uneven application that are faint in visible light show strongly here.
  * PROG: partly dissolved state (streaky, uneven) mid-removal: thin areas clear first, thick streaks last.
  * DMG: paint loss or blurred glazes where the solvent bit into paint.
  * SFX: solvent swab; caption "Swab lifting softened varnish."
  * Extra: amber swab texture.
* **Cases:** Vos \[SAAM\], Penniman \[SAAM\], Bricher \[SAAM\], De Haas \[SAAM\].
* **Reference notes** (from cleaning-window photos; used to tune the shader):
  * Visible light: blue drops most, then green; red barely changes. Light varnish keeps about 70 to 80% of blue, 85 to 97% of green, 89 to 105% of red; heavy varnish behaves like light varnish compounded (about three layers). Darks shift toward olive and amber without losing brightness.
  * UV: aged natural resin fluoresces milky green, more where thicker; cleaned areas go dark blue-violet. Earlier partial cleanings show as sharp-edged or stepped boundaries.

#### Varnish bloom (blanching) \[verify\]

* **Cause:** moisture causes a milky, hazy surface in some varnishes.
* **Revealed by:** visible light (grey-white haze), raking light.
* **Treatments:** regeneration or varnish removal \[verify\].
* **Assets:** VIS: patchy milky haze; MASK: patches.
* **Cases:** none yet.

### Stratum 5: Later paint

#### Old retouching / overpaint

* **Cause:** earlier restorations painted over damage, sometimes beyond the losses, or discolored over time. \[Met\] \[WP\]
* **Revealed by:** UV (retouching shows as dark patches against fluorescing varnish); magnification (color or texture mismatch).
* **Treatments:** document; leave, or remove (retouching removal) followed by filling and inpainting.
* **Mistreatment:** removing retouching may expose damage or remove original paint fragments underneath; the original appearance may be unknowable.
* **Assets:**
  * VIS: slightly mismatched color patches with flatter texture.
  * UV: dark patches; non-color cue: outline + label.
  * DMG: exposed loss that is larger than expected.
* **Cases:** Wheat Field (cypress profile) \[Met\].

### Stratum 4: Paint

#### Flaking / lifting paint

* **Cause:** poor adhesion between paint and ground or support; movement of the support with humidity; age. \[SAAM\] \[WP\]
* **Revealed by:** raking light (flakes catch the light), magnification.
* **Treatments:** consolidation first, before any cleaning.
* **Mistreatment:** cleaning or handling before consolidation knocks flakes off: they become losses. Irreversible.
* **Assets:**
  * VIS: small lifted islands of paint with dark edges.
  * RAK: raised edges, cast shadows.
  * PROG: consolidated state (flat, no shadow).
  * DMG: converts to a loss.
  * SFX: soft brush or syringe; caption "Adhesive flowing under the flake."
* **Cases:** Penniman \[SAAM\].

#### Paint loss

* **Cause:** flaking, abrasion, impact, tears. \[SAAM\] \[Met\] \[WP\]
* **Revealed by:** visible light; raking light shows depth.
* **Treatments:** filling → inpainting (after cleaning and varnishing).
* **Mistreatment:** inpainting beyond the edges of the loss covers original paint (overpaint).
* **Assets:**
  * VIS: opaque patches showing ground (white or off-white) or bare canvas or wood.
  * RAK: recessed edges.
  * PROG: filled state (smooth, white putty, level).
  * DMG: inpainting spilled over original paint.
  * SFX: spatula smoothing fill; brush for inpainting.
* **Cases:** Vos (edges) \[SAAM\], Penniman (to bare wood) \[SAAM\], Wheat Field (edges, cypress) \[Met\].
* **Reference notes** (from before/after photos; used to draw the loss shapes):
  * Losses break along the crack network: clusters of small angular flakes with straight-segment edges, plus detached flakes nearby, rather than single smooth blobs.
  * Edge losses form a ragged band along the canvas edge, deeper in some places than others.
  * Along cracks or old folds, losses can be thin lines of small flecks.
  * What shows through varies: white or cream ground most often, but also colored grounds (blue, grey, red), a brown underlayer, or bare canvas with its weave clearly visible. One loss can show two depths.

#### Age cracks and drying cracks (craquelure)

* **Cause:** age cracks from movement of the support; drying cracks from slow-drying paint (e.g., zinc white). \[Met\] \[WP\]
* **Revealed by:** raking light, magnification.
* **Treatments:** usually none: document. Consolidate only if lifting.
* **Mistreatment:** treating stable cracks as damage.
* **Assets:**
  * VIS: fine dark crack network (tileable, masked).
  * RAK: hairline grooves.
* **Cases:** Wheat Field (zinc white in the sky) \[Met\], De Haas \[SAAM\].

#### Curled / cupped cracking

* **Cause:** paint islands between cracks curl up as the canvas and paint move. \[SAAM\]
* **Revealed by:** raking light (strong).
* **Treatments:** humidification and flattening, then consolidation.
* **Assets:**
  * VIS: crack network with lighter raised rims.
  * RAK: cupped islands (strong normal-map relief).
  * PROG: flattened state.
* **Cases:** Bricher \[SAAM\].

#### Broken impasto

* **Cause:** sharp peaks of thick paint snapped off by contact, packing, or framing. \[Met\]
* **Revealed by:** raking light, magnification.
* **Treatments:** usually none: document.
* **Assets:** VIS: small flat-topped peaks; RAK: truncated peaks.
* **Cases:** Wheat Field \[Met\].

#### Weave impressions

* **Cause:** canvas weave pressed into soft impasto when paintings were rolled or stacked before fully dry. An artist-era feature, not damage. \[Met\]
* **Revealed by:** raking light.
* **Treatments:** none: document. A lesson in distinguishing history from damage.
* **Assets:** RAK: faint grid texture in impasto areas only.
* **Cases:** Wheat Field \[Met\].

#### Abrasion

* **Cause:** past over-cleaning or routine dusting wearing the paint surface. \[WP\]
* **Revealed by:** magnification (thinned paint, exposed ground at high points).
* **Treatments:** usually limited inpainting; often left.
* **Assets:** VIS: thinned paint at high points; also used as a DMG overlay for aggressive cleaning.
* **Cases:** none yet; mostly a consequence.

#### Fading

* **Cause:** light exposure fades fugitive pigments and dyes. \[WP\]
* **Revealed by:** comparison with protected areas (e.g., under the frame rebate).
* **Treatments:** none; preventive recommendation (light levels) in documentation.
* **Assets:** VIS: desaturation mask, with an unfaded strip at the edge.
* **Cases:** none yet.

### Stratum 2: Support

#### Tear

* **Cause:** impact, handling. \[Met\] \[WP\]
* **Revealed by:** visible light, raking light, X-ray, reverse of the canvas.
* **Treatments:** tear repair (adhesive or sewing), then fill and inpaint.
* **Assets:** VIS: torn line with distorted edges; RAK: raised, out-of-plane edges; reverse-of-canvas view.
* **Cases:** Wheat Field (old, already lined) \[Met\].

#### Buckling / planar distortion

* **Cause:** humidity changes; the canvas and stretcher expand and contract. \[SAAM\] \[WP\]
* **Revealed by:** raking light (strong).
* **Treatments:** humidification and flattening, then stabilizing.
* **Assets:** RAK: broad waves; VIS: subtle light gradients only.
* **Cases:** De Haas \[SAAM\].

#### Mold \[verify for cases\]

* **Cause:** high humidity, water damage. \[WP\]
* **Revealed by:** visible light, UV (some molds fluoresce).
* **Treatments:** isolate; surface cleaning; preventive recommendation.
* **Assets:** VIS: spotty colonies; UV: fluorescent spots.
* **Cases:** none yet.

#### Water damage / tide lines \[verify for cases\]

* **Cause:** flooding, leaks. \[WP\]
* **Revealed by:** visible light, UV.
* **Assets:** VIS: tide-line stains, blanching.
* **Cases:** none yet.

#### Panel split or warp (wood panels)

* **Cause:** wood moving with humidity. \[WP\]
* **Revealed by:** raking light, reverse of panel.
* **Treatments:** rejoining splits; today, preserving rather than correcting warp (cradling is historical only).
* **Assets:** VIS: split line; RAK: step across the split.
* **Cases:** possibly Penniman (panel) \[verify\].

### Stratum 1: Structure

#### Old lining

* **Cause:** a past treatment: a new canvas adhered to the back for support. \[Met\] \[WP\]
* **Revealed by:** reverse of the canvas, tacking edges, raking light (flattened impasto if done badly).
* **Treatments:** usually none: recognize and document. Lining removal only if the adhesive has failed.
* **Assets:** reverse-of-canvas view (a second canvas visible behind the original); tacking edge detail.
* **Cases:** Wheat Field \[Met\].

#### Weakened tacking edges

* **Cause:** age, handling, tension. \[WP\]
* **Revealed by:** inspection of the edges.
* **Treatments:** strip-lining.
* **Assets:** edge detail view with frayed canvas.
* **Cases:** none yet.


## Tools (shared assets)

| Tool | Used for | Assets |
|----|----|----|
| Loupe / magnifier | Close inspection | Zoom-lens view, cursor |
| UV lamp | UV fluorescence | Lamp sprite, dark-room view toggle |
| Raking light | Topography | Movable light source (drives the RAK maps) |
| Cotton swab | Spot tests, cleaning, varnish removal | Clean, grime-brown, and amber swab states |
| Solvent / gel | Varnish removal | Bottle sprites (labeled, not color-coded alone) |
| Scalpel | Mechanical debris removal | Blade sprite |
| Fine brush / syringe | Consolidation, inpainting | Brush, syringe sprites |
| Spatula | Filling | Spatula sprite, fill putty |
| Palette | Inpainting color matching | Palette with mixed colors |
| Weights and moisture | Humidification and flattening | Blotter, weights sprites |
| Camera / report form | Documentation | Report UI (in `core/documentation/`) |


## Open questions

- [ ] SME review of every condition, treatment, reversibility level, and rank
- [ ] Which conditions the opening case (Vos) needs, and their exact assets
- [ ] Base image working resolution (affects every overlay and mask)
- [x] Shared texture library vs. per-painting overlays: shared, painting-neutral library for both modes
- [ ] Reverse-of-canvas views: one generic back per support type (consistent with the neutral library)?
- [ ] How library textures scale across paintings of very different sizes and resolutions
- [ ] Generic sprite set for inclusions and debris (fibers, grit, plant matter) so cases like the Wheat Field husk use library sprites


