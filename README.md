# Apprentice

**Apprentice** is a series of cozy, workbench-style simulation games about niche professional practice. Each game places the player inside the work of an under-known profession, apprenticing under a mentor who models expert noticing early and steps back as the player's judgment develops.

The first game, **The Conservator's Apprentice**, is set in an art and manuscript conservation studio. Players diagnose damage, test materials, make treatment decisions, and document their findings.

> **Status:** Prototype / proof of concept, in development as a playable demo for ISLS 2027. Expect things to change.


## Design commitments

These shape technical decisions as much as content decisions:

* **Never a student, always already a practitioner.** The player is never quizzed or lectured; knowledge is reference, not prerequisite.
* **Failure is informative, not punishing.** Mistakes produce consequences the player can read and learn from.
* **Scaffolding fades.** The mentor models expert noticing early and steps back over time, sometimes before the player feels fully ready.
* **The game is not secretly easier than it looks.** Real difficulty conveys intellectual respect.
* **Low gates to play.** Free, open, and playable in a browser or on a personal or school-issued computer, with no install required for the web version.
* **Accessible by default.** Players set their own gameplay and usability preferences during onboarding.
* **No AI agents in the game.** All dialogue is human-written and scripted. Players make choices from authored options; there is no free-text input and no generative AI at runtime.

Theoretical grounding: cognitive apprenticeship, authentic activity, and communities of practice. Target audience: youth, particularly those underrepresented in STEM, in informal and out-of-school contexts.


## Tech stack

| Layer | Choice | Why |
|----|----|----|
| Engine | [Godot 4](https://godotengine.org/) (version pinned below) | Free and open source, no licensing fees. 2D is first-class. Exports to web and all desktop platforms. |
| Language | GDScript | Similar to Python, native to Godot, and fully supported in web exports (C# is not). |
| Presentation | 2D, fixed workbench view | Immersion comes from feedback density and object authenticity, not dimensionality. |
| UI | Figma prototypes → Godot Control nodes | The interface *is* the world; designed like an application, built with Godot's box-model UI system. |
| Dialogue | [Dialogic 2](https://github.com/dialogic-godot/dialogic) | Choice-based, visual-novel-style dialogue with conditions and variables. GDScript-native, so it exports to web. All dialogue lives here. |
| Mentor triggers | Custom mentor-rules system (`core/mentor/`) | Decides *when* the mentor speaks during cases, based on player actions, help requests, and scaffolding level, then plays the matching Dialogic timeline. |
| Item and case data | Godot custom Resources (`.tres`) | Typed, editable in Godot's Inspector as forms, and stored as diffable text. |
| Art | Open-access museum collections, openly licensed artists, original work | No AI-generated art. All sources tracked in the asset license log. |
| Audio | Freesound and other openly licensed sources | Tactile sound feedback is central to the "satisfying" feel. |
| Version control | Git + GitHub |    |
| Builds | GitHub Actions → web build (**planned**) | Every push produces a current playable link for testers and SMEs. |

### Pinned versions

| Tool | Version | Notes |
|----|----|----|
| Godot | **4.7.2.stable** | Standard build, not .NET. Dialogic 2 requires Godot 4.5 or newer. |
| Dialogic | **2.0 Alpha 20** | Committed to `addons/`. Upgrade only deliberately, and test existing timelines after any upgrade; Dialogic is still in alpha and has introduced breaking changes between releases. |

Everyone working on the project, and any automated builds, must use these exact versions.

### Target platforms






1. **Web (primary):** HTML5 export using Godot's single-threaded web option, so it runs on Chromebooks and standard browsers without special server configuration.
2. **Desktop:** Windows, macOS, and Linux downloads.

The baseline is a cursor and keyboard. Touch and tablet play are not a priority for the prototype.


## Gameplay flow

### Session flow

```
Launch
  └─ Onboarding (first launch only; revisitable from Settings)
       ├─ Gameplay and accessibility preferences
       └─ (future) Research participation consent
  └─ Studio (hub)
       └─ Case
            1. Intake       Object arrives with provenance and a request
            2. Examination  Inspect under visual light, UV, raking light
            3. Diagnosis    Identify conditions and their likely causes
            4. Planning     Choose treatments; weigh risks
            5. Intervention Carry out treatment with tactile feedback
            6. Documentation Complete a condition and treatment report
            7. Debrief      Mentor conversation about the case
  └─ Return to studio → next case
```

### The mentor

All mentor dialogue is scripted and choice-based, in the style of a visual novel. Players choose from authored response options; they never type free text. The mentor appears in two ways:

* **Conversations:** intake briefings, debriefs, and story moments, with dialogue choices that let players express their reasoning and make decisions.
* **Reactive input during cases:** remarks triggered by what the player does. A mentor rule pairs a game event with conditions and a scaffolding level, for example *player applies a treatment before testing it, scaffolding high → mentor prompts a spot test*. A reactive moment can open into a short conversation with choices.

Mentor rules decide **when** the mentor speaks; Dialogic timelines hold **what** she says. Writing everything in one tool keeps all dialogue in one place.

Player dialogue choices are recorded in `GameState` alongside case decisions, so they persist in saves, appear in debugging logs, and can shape later mentor responses.

Scaffolding level is set per case and adjusted by player behavior, so the mentor models heavily in early cases and asks questions instead of answering them in later ones.

### Modes

* **Campaign (prototype focus):** Authored cases with fixed conditions, narrative, and mentor dialogue written around specific findings.
* **Infinite mode (future):** The player graduates from apprentice to independent practitioner. Items are drawn from the same asset library with randomized conditions and no campaign scaffolding.

### Demo scope (ISLS 2027)

One object, three to four conditions, one complete mentor arc showing partial fading, two to three examination modes, and a documentation step. Playable in 10 to 15 minutes.


## Architecture

### Core vs. game content

The repository separates **reusable infrastructure** from **profession-specific content**, so later Apprentice games share the same foundation.

* `core/` knows about *items, conditions, tools, cases, and mentors* in general. It never refers to conservation.
* `games/conservator/` supplies the conservation-specific items, conditions, examination modes, art, and dialogue.

### Condition layer system

Every item is a clean base asset plus a set of compositable **condition layers**. Each condition is defined once and can appear on many items.

```
ItemDefinition
  base_asset
  provenance
  conditions: [ConditionInstance]
      condition: ConditionDefinition
      severity: 0.0 – 1.0
  campaign_metadata (optional)
      narrative
      scaffolding_level
      dialogue references

ConditionDefinition
  id, display_name
  visual_layer
  cause
  diagnostic_tools        (which examination modes reveal it)
  treatments
  treatment_risks
  if_untreated
```

The campaign uses the full structure. Infinite mode uses everything except `campaign_metadata`. Severity is a parameter rather than a separate condition, so one illustration serves many cases.

### Global systems (autoloads)

| System | Responsibility |
|----|----|
| `GameState` | Single source of truth for current progress, case state, and player decisions. |
| `EventBus` | Game-wide signals (tool used, condition identified, help requested, and so on). Mentor rules and logging both listen here. |
| `Settings` | Player preferences and accessibility options, applied everywhere. |
| `SaveSystem` | Serializes `GameState` and `Settings` to disk (browser storage on web). |
| `Telemetry` | Local session logging for debugging and usability (see below). |

Because all meaningful actions go through `EventBus` and land in `GameState`, saving, logging, and mentor reactions all draw on the same information.


## Accessibility and player preferences

Preferences are set during onboarding and can be changed any time in Settings.

* **Color vision:** Color-blind modes, plus redundant non-color cues (pattern, outline, label) for anything currently communicated by color, including UV fluorescence.
* **Text:** Text scaling, a high-legibility font option, and adjustable contrast.
* **Audio:** Captions for all meaningful sound, including tool and material feedback, plus separate volume controls.
* **Pacing:** No timed reading. Dialogue advances only on player input unless auto-advance is turned on.
* **Motion:** Reduced-motion option.
* **Input:** Remappable keys, and a hold-vs-toggle choice for sustained actions.

New features should be checked against this list before they are considered done.


## Data and logging

**Prototype phase:** Logging exists for **debugging, usability, and accessibility troubleshooting only.**

* Logs are stored **locally on the player's device** as structured event records drawn from `EventBus`.
* **Nothing is sent over the network.**
* Players or testers can export a log file manually to share with the developer.

**Future:** An opt-in research consent step in onboarding, with its own documentation and review, before any research data collection.


## Assets and licensing

All third-party assets must be openly licensed (public domain, CC0, CC BY, or similar) and recorded **before** they are committed.

* **License log:** `docs/assets/ASSET_LOG.csv`, one row per asset, with these columns: file path, title, creator, source URL, license, date accessed, modifications made, and required attribution text.
* **Credits:** In-game credits are generated from the license log.
* **No AI-generated art.**
* **Source files:** Large working files (high-resolution photos, layered art files) live outside the repository. Only export-ready assets are committed.


## Repository structure

```
/
├── README.md
├── project.godot
├── core/                     # Reusable Apprentice infrastructure
│   ├── autoload/             # GameState, EventBus, Settings, SaveSystem, Telemetry
│   ├── items/                # Item and condition Resource classes, layer compositing
│   ├── examination/          # Examination-mode framework
│   ├── mentor/               # Mentor-rules system and scaffolding levels
│   ├── documentation/        # Report and form framework
│   ├── onboarding/           # Preferences and (future) consent flow
│   └── ui/                   # Shared UI components and accessibility theming
├── games/
│   └── conservator/          # The Conservator's Apprentice
│       ├── items/            # ItemDefinition resources
│       ├── conditions/       # ConditionDefinition resources
│       ├── cases/            # Campaign case definitions
│       ├── dialogue/         # Dialogic timelines (conversations and reactive lines)
│       ├── mentor_rules/     # When the mentor speaks: event + condition + scaffolding level
│       └── assets/           # Art and audio
├── addons/                   # Third-party Godot plugins (e.g., Dialogic)
├── docs/
│   ├── assets/ASSET_LOG.csv
│   └── design/               # Design notes and decisions
└── .github/workflows/        # Build automation (planned)
```


## Getting started






1. Install **Godot** at the pinned version above (standard build, not .NET).
2. Clone this repository.
3. Open Godot, choose **Import**, and select `project.godot`. Dialogic is included in `addons/`; no separate install is needed.


## Roadmap

- [x] Pin exact Godot and Dialogic versions
- [x] Create project skeleton
- [x] Choose dialogue system (Dialogic 2)
- [ ] Global systems: `GameState`, `EventBus`, `Settings`, `SaveSystem`, `Telemetry` (registered as autoload stubs)
- [ ] Onboarding preferences screen
- [ ] Condition layer system with one item and one condition
- [ ] Examination modes: visual, UV, raking light
- [ ] Full demo case, start to finish
- [ ] Web build and automated publishing
- [ ] SME review pass
- [ ] ISLS 2027 demo


## License

**TBD.** Code and content may be licensed separately.

## Credits

Created by Morgan Vickery. Subject-matter review by practicing conservators. Third-party asset credits are listed in `docs/assets/ASSET_LOG.csv`.