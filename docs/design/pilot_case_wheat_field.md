# Pilot Case: Wheat Field with Cypresses

**Object:** Vincent van Gogh, *Wheat Field with Cypresses*, 1889. Oil on canvas, 73.2 × 93.4 cm.
**Holder:** The Metropolitan Museum of Art, accession 1993.132, object ID 436535.
**Source page:** https://www.metmuseum.org/art/collection/search/436535

Status: chosen as the pilot case. Candidate conditions drafted below; not yet reviewed by a conservator.


## Idea

Fold the real object's technical study, conservation history, and exhibition history into the game, so players learn about the actual artwork. In the campaign, the player's case mirrors the treatment the painting actually received.

Players can look up details about each piece. Some details will not be available, and that is fine: gaps in the record are the reality of the field.


## Framing

The player works in a modern, present-day conservation lab and functionally relives and re-enacts past conservations that happened. For this case, the painting arrives in its 1993 state, as it was when it came to The Met, and is treated in the modern lab.

Implications:

* **Intake** presents the painting as it arrived in 1993: grime, retouched cypress, existing lining.
* **Examination** uses present-day tools, so the player may notice things the 1993 conservator did not have the means to see. Later technical findings (2016 notes, 2023 macro-XRF) become discoveries rather than lookups.
* **The object file** is limited to what was known up to 1993; findings made after that are earned through examination or revealed at debrief.
* **Debrief** compares the player's treatment with what actually happened in 1993, and with what later study revealed.
* **Treatment choices** must respect what is sourced: the real treatment was a surface clean, so more invasive options exist as choices with consequences, not as the expected path.


## Available material

| Material | Where | License status |
|----|----|----|
| Main image (post-treatment) | Met API `primaryImage` | CC0 (`isPublicDomain: true`) |
| Three raking/detail photographs of impasto (`suppl_CH-001` to `-003`) | Met API `additionalImages` | Listed on a public domain object; confirm the Open Access icon on each |
| X-radiograph (`suppl_CH-004`) | Met API `additionalImages` | Same as above |
| Overview, technical notes, provenance, exhibition history, references | Met website only (not in the API) | **Not CC0.** Met-authored text; use as a factual source, write our own wording, cite it |
| Interactive 3D representation | Met website | Unknown; check host and license before use |


## Source facts relevant to conservation

Paraphrased from the Met's technical notes (Charlotte Hale, 2016) and references. Not for in-game use as written.

**Support and ground**

* Standard size 30 canvas; *toile ordinaire* from Tasset et L'Hôte, Paris. Thread-count analysis matches it to the same bolt as 67 other Van Gogh paintings (Feb 1888 – July 1890).
* Thin, single-layer commercial white ground; canvas weave crowns show as dark flecks where brushwork is open.

**Paint and technique**

* Laid in with fluid blue and green, visible through gaps in the wheat field.
* A reserve was left for the cypresses; the sky slightly overlaps the reserve and the tree edges are painted over the sky. Visible in the X-radiograph.
* Worked wet-into-wet, mostly far to near; very heavy impasto, varying by feature (broad curves in the sky, flickering strokes in the cypresses, hatching in the wheat, loops in the grass).
* X-radiographs show no changes of mind during painting.
* A wheat husk is embedded in the paint: material evidence it was painted outdoors.

**Condition (as of 2016)**

* Overall condition excellent.
* Canvas has been lined, possibly to secure an old tear in the left middle ground. The lining did not flatten the impasto. Van Gogh himself expected thickly painted studies on thin canvas would need lining (letter 800).
* Original tacking edges intact.
* Two damages either side of the top of the larger cypress. The tree's profile has been retouched, possibly not as originally painted; paint traces on the adjacent clouds may be fragments of the original profile.
* Minor losses at the edges; some sharp impasto tips broken in the past.
* Little craquelure overall; localized cracks in the zinc white of the sky (zinc white is slow to dry). Areas where zinc white is mixed with cobalt blue appear crack-free.
* Light weave impressions in foreground impasto, from rolling or stacking the unstretched canvas for storage or shipping.

**Treatment history**

* c. 1900: listed in the dealer Julien Leclercq's records as "damaged" (Johanna van Gogh-Bonger's list).
* Lining: date and conservator unknown.
* Cypress retouching: date and conservator unknown.
* 1993: surface-cleaned on arrival at The Met by Hubert von Sonnenburg, who found the wheat husk. (The Met's footnote spells the name "Hubertus von Sonnenberg"; the 2023 reference spells it "Hubert von Sonnenburg.")
* 2023: technical study including macro X-ray fluorescence (Hale and Centeno, in Stein, *Van Gogh's Cypresses*).

**Other threads with game potential**

* Four versions of the composition (this study, a reed-pen drawing, the London studio version, a smaller replica). Scholars disagreed for decades about which came first.
* The London version's 1987 technical study (*National Gallery Technical Bulletin* 11) compared X-radiographs of the two paintings.
* A forgery (F729, Otto Wacker) was painted after a detail of this work.
* Provenance runs through the Mendelssohn family in Berlin during the Nazi era and was researched by The Met in 1998. Handle with care if used.


## Candidate conditions

Each maps to something in the real record. Severity and appearance are authored; the existence of the condition is sourced.

| Condition | Revealed by | Real-world basis | Treatment decision |
|----|----|----|----|
| Surface grime, with embedded debris | Visual, magnification | 1993 surface cleaning | Surface clean after a spot test. One "debris" item is the wheat husk: original material that must not be removed. |
| Retouched cypress profile over old damages | UV, magnification | Damages and retouching at the top of the cypress | Document; decide whether to leave or remove the retouching. No single right answer, since the original profile is uncertain. |
| Old tear, already lined | Raking light, X-radiograph, reverse of canvas | Lining, possibly for a tear; dealer's "damaged" note | Recognize and document a past treatment; no new intervention needed. |
| Impasto damage: broken tips, zinc white cracks, weave impressions | Raking light, magnification | Condition notes | Distinguish artist-era features (weave impressions, zinc white drying cracks) from damage; monitor or consolidate only if lifting. |

Not sourced, so not used unless a conservator confirms: varnish (presence, type, or removal), UV fluorescence appearance, lining date or method.


## Design implications

* **Reference, not prerequisite.** Real-world information lives in an in-game object file the player can consult, and in a debrief that compares the player's choices with the real treatment.
* **Gaps are content.** Each record section can be documented, partial, unknown, or disputed. "No record of who lined this canvas" is a real answer.
* **Base asset is the post-treatment photo.** Condition layers recreate the painting's pre-treatment state.
* **Examination modes map onto real images:** raking light (detail photographs), X-radiography (the real X-radiograph). UV has no real image and would be authored.
* **Data model:** items need sourced reference records (overview, technical notes, condition and treatment history, provenance, exhibition history, citations), kept generic in `core/` and filled in under `games/conservator/`.
* **Looking something up is an action.** It should go through `EventBus`, so mentor rules can react and Telemetry can log it.


## Open questions

- [x] Framing: modern lab re-enacting the painting's 1993 arrival (see Framing)
- [ ] Should the object file be limited to what was known by 1993, or show everything known today?
- [ ] Which present-day examination tools does the lab have? (Each one needs real or authored imagery for this painting.)
- [ ] Is the painting varnished, and what does it look like under UV? (Ask a conservator.)
- [ ] Confirm Open Access status of the X-radiograph and detail photographs
- [ ] Host and license of the 3D representation; is it usable (e.g., as a height or normal map for raking light)?
- [ ] Contact the Met's paintings conservation department as an SME and for permission to quote
- [ ] How the game credits the Met without implying endorsement
- [ ] Whether to add X-radiography as an examination mode in the demo


