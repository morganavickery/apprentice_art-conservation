# Development Plan

An ordered sequence of work from project skeleton to a playable demo. Phases build on each other; tasks within a phase can mostly be done in any order. Not tied to dates.

Demo scope (from README): one object, three to four conditions, one mentor arc showing partial fading, two to three examination modes, a documentation step, playable in 10 to 15 minutes.


## Milestones

| # | Milestone | Done when |
|----|----|----|
| 1 | **Web smoke test** | A blank scene plus a Dialogic timeline runs in the Web Single-Threaded export in a browser. |
| 2 | **Data model** | One item with one condition renders from `.tres` Resources. |
| 3 | **Vertical slice** | A greybox case runs intake → debrief, with placeholder art and dialogue. |
| 4 | **Content lock** | All demo conditions, dialogue, and art are in. Changes after this are fixes only. |
| 5 | **Feature freeze** | Bug fixing, accessibility, and performance only. |
| 6 | **Demo build frozen** | Tagged release, hosted web link, offline desktop fallback. |


## Phase 0: Foundations

- [ ] Remove or replace placeholder main scene (`node.tscn`)
- [ ] Export a Web Single-Threaded build and run it locally in Chrome, Firefox, and Safari
- [ ] Confirm a Dialogic timeline plays in the web build
- [ ] Try the web build on a Chromebook (or low-spec laptop) to set a performance baseline
- [ ] Add export presets to the repo; decide whether `export_presets.cfg` is committed
- [ ] `EventBus`: define the first signals (case started/ended, tool used, condition identified, help requested, dialogue choice made)
- [ ] `GameState`: hold current case and a decision log; listen to `EventBus`
- [ ] `Telemetry`: write `EventBus` events to a local log file in `user://`
- [ ] `SaveSystem`: save and load `GameState` and `Settings` to `user://`; verify persistence in the browser
- [ ] **Milestone 1: web smoke test**


## Phase 1: Data model and first item

- [ ] Choose the demo object (with conservator input) and its three to four conditions
- [ ] Identify SME reviewers and schedule a first conversation
- [ ] Choose primary art sources (e.g., Met Open Access, Smithsonian Open Access) and record the choice in `docs/design/`
- [ ] `core/items/`: `ItemDefinition`, `ConditionDefinition`, `ConditionInstance` Resource classes
- [ ] Layer compositing: base asset + condition visual layers, with severity as a parameter
- [ ] One item and one condition authored as `.tres` in `games/conservator/`
- [ ] Source the base image for the demo object; log it in `ASSET_LOG.csv` before committing
- [ ] Document the data model in `docs/design/`
- [ ] **Milestone 2: data model**


## Phase 2: Examination and mentor systems

- [ ] `core/examination/`: framework for switching examination modes
- [ ] Visual light, UV, and raking light modes for the demo object
- [ ] Non-color cues for UV fluorescence (pattern, outline, or label)
- [ ] `core/mentor/`: mentor rule = event + conditions + scaffolding level → Dialogic timeline
- [ ] Scaffolding level per case, adjusted by player behavior
- [ ] First reactive mentor line and first conversation timeline, triggered through mentor rules
- [ ] Record dialogue choices in `GameState`


## Phase 3: Case flow

- [ ] Studio hub scene and case scene structure
- [ ] Case stages: intake, examination, diagnosis, planning, intervention, documentation, debrief
- [ ] Diagnosis: identify conditions and likely causes
- [ ] Planning: choose treatments and weigh risks
- [ ] Intervention with basic tactile feedback (placeholder sound and animation)
- [ ] `core/documentation/`: condition and treatment report form
- [ ] Debrief conversation that reflects the player's actual decisions
- [ ] **Milestone 3: vertical slice playable start to finish**


## Phase 4: Onboarding, accessibility, content

- [ ] `core/onboarding/`: preferences screen on first launch, revisitable from Settings
- [ ] `Settings` applied everywhere: text scaling, high-legibility font, contrast, color-blind modes, captions, reduced motion, volume, auto-advance, remappable input, hold vs. toggle
- [ ] `core/ui/`: shared theme that responds to `Settings`
- [ ] Author remaining demo conditions (three to four total)
- [ ] Write the full mentor arc, with fading visible across the case
- [ ] SME review #1: conditions, treatments, risks, and mentor dialogue
- [ ] Playtest #1 (colleagues or friendly testers): can people finish the case unaided?


## Phase 5: Feel and polish

- [ ] Final art for the demo object and condition layers (all logged)
- [ ] Tactile audio for tools and materials, with captions (all logged)
- [ ] Studio and workbench visual polish
- [ ] In-game credits generated from `ASSET_LOG.csv`
- [ ] Log export button for testers
- [ ] GitHub Actions: web build on push, published to a stable link
- [ ] Playtest #2
- [ ] Apply SME #1 and playtest feedback
- [ ] **Milestone 4: content lock**


## Phase 6: Hardening

- [ ] SME review #2 on the locked content
- [ ] Accessibility pass against the README checklist, including keyboard-only and screen-size checks
- [ ] Performance check on Chromebook and school-issued hardware
- [ ] Desktop builds (Windows, macOS, Linux) as an offline fallback
- [ ] Time a full playthrough (target: 10 to 15 minutes)
- [ ] **Milestone 5: feature freeze**


## Phase 7: Release

- [ ] Tag the demo release; freeze the hosted link
- [ ] Reset path so each visitor starts fresh (clear save between players)
- [ ] **Milestone 6: demo build frozen**


## Ongoing

- Log every third-party asset in `ASSET_LOG.csv` before committing it
- Check new UI against the accessibility list before calling it done
- Keep `README.md` current
- Record design decisions in `docs/design/`
- Decide on a license (code and content) before the public demo link goes live


## Open decisions

- [ ] Demo object and its conditions
- [ ] Primary art sources
- [ ] Mentor character (name, voice, portrait)
- [ ] Art direction for the workbench and studio
- [ ] Code and content license
