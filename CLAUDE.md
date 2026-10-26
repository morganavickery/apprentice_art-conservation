# CLAUDE.md

Guidance for Claude Code working in this repository. Read `README.md` first; it describes the game, the gameplay flow, and the architecture.

## Project in one paragraph

**The Conservator's Apprentice** is the first game in the **Apprentice** series: cozy, workbench-style 2D simulations of niche professional practice, built in Godot. The player apprentices under a mentor conservator, examining, diagnosing, treating, and documenting damaged art and manuscripts. It is a prototype for a playable demo at ISLS 2027. Morgan is the sole developer and content author.

## Pinned versions (do not change without asking)

- Godot **4.7.2.stable**, standard build. **GDScript only. No C# / .NET.**
- Dialogic **2.0 Alpha 20**, in `addons/dialogic/`. **Never edit files inside `addons/`.**
- Renderer: **Compatibility** (`gl_compatibility`). Primary target is the **Web Single-Threaded** export, with Windows, macOS, and Linux desktop builds secondary.

## Architecture rules

- **`core/` is game-agnostic.** It must never reference conservation, conservators, or any profession-specific content. Profession-specific content lives in `games/conservator/`. Later Apprentice games will reuse `core/`.
- **Global systems are autoloads:** `GameState`, `EventBus`, `Settings`, `SaveSystem`, `Telemetry` (plus `Dialogic`, registered by the plugin).
- **All meaningful player actions are emitted through `EventBus`** and recorded in `GameState`. Saving, logging, and mentor reactions all read from these; do not create parallel state.
- **Item and condition data are custom Godot Resources** (`.tres`), designed to be easy to edit in the Inspector. Follow the condition-layer structure in the README.
- **Dialogue:** All mentor text lives in Dialogic timelines. The mentor-rules system in `core/mentor/` decides *when* the mentor speaks; Dialogic holds *what* is said. Player dialogue choices are recorded in `GameState`.

## Hard constraints

- **No AI agents, LLMs, or generative AI in the game.** All dialogue is scripted and choice-based; there is no free-text input.
- **No network calls.** Telemetry writes local logs only.
- **No AI-generated art or audio.** Every third-party asset must have a row in `docs/assets/ASSET_LOG.csv` before it is committed.
- **Accessibility is part of "done."** New UI should respect `Settings`: text scaling, color-blind modes with non-color cues, captions for meaningful audio, no timed reading, reduced motion, and remappable input.
- Keep the web build lightweight; avoid features that require multithreading or special server headers.

## Working with Morgan

- Morgan has a software engineering and UX background and a PhD in learning sciences, and is **new to Godot**. Briefly explain Godot-specific concepts (scenes, nodes, signals, autoloads, Resources) when they first come up, without over-explaining general programming.
- **Preserve Morgan's own phrasing** when editing documentation or design text.
- Prefer small, reviewable changes. Explain what changed and why, and suggest a commit message.
- Ask before adding dependencies, plugins, or changing project settings.
