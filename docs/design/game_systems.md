# Game Systems: Inquiry, Consequences, Progression

Series-level design for three systems that sit on top of the case flow. All three are game-agnostic and belong in `core/`; profession-specific content (questions, treatments, tools, ranks) lives under `games/<game>/`.


## 1. Inquiry: asking questions

**Intent:** The more the player can ask about, the better. Some questions will not have answers; some things are just unknown. That is the reality of the field.

**Where players ask**
- **Case file:** documented records about the object (overview, technical notes, condition and treatment history, provenance, exhibition history).
- **Mentor ("ask an expert"):** questions about what the player is seeing or deciding.
- **Consultants (future):** experts from other disciplines (e.g., art historian, curator, chemist, painter), called in to give interpretations specific to their discipline. Different consultants may read the same evidence differently; the player uses them to narrow down decisions.

**Questions are authored options, never free text.** Each question is available from one or more sources, and each source gives its own answer.

**Every answer has a status:**

| Status | Meaning | Example (Wheat Field) |
|----|----|----|
| Known | Documented and agreed | Painted at Saint-Rémy, June 1889 |
| Partial | Some evidence, incomplete | The lining *may* have been done to secure a tear |
| Unknown | No record exists | Who lined the canvas, and when |
| Disputed | Sources disagree | Which version of the composition came first |

An "unknown" answer is still an answer, written in the voice of the source ("There's nothing in the file on that.").

**Design notes**
- Asking is an action: it goes through `EventBus`, so mentor rules can react and Telemetry can log what players ask.
- Questions can unlock from examination: noticing something makes new questions available.
- Open question: should consulting have a cost (time, budget, mentor patience) so that choosing whom to call is itself a decision?


## 2. Consequences: decisions with weight

**Intent:** The player may take a different approach from (a) what was actually done in the past and (b) what would be best practice today. As in a real lab, they make supervised decisions, and those decisions have consequences. Some things can be undone by the mentor; some treatments are beyond the point of undoing or repair. That is just how it is.

This mirrors real conservation ethics: reversibility and minimal intervention are core principles of the profession, so the mechanic teaches the value.

**Every treatment step has a reversibility level:**

| Level | Meaning | Example |
|----|----|----|
| Reversible | The player can undo it | Applying a removable test patch |
| Mentor-reversible | Only the mentor can undo it, and doing so is noted | Removing a newly applied retouching |
| Irreversible | Permanent change to the object | Removing original material (e.g., the embedded wheat husk) |

**Supervision fades with scaffolding.** Early on, the mentor warns before irreversible steps; later, the mentor may only ask "Are you sure?", or say nothing.

**Consequences persist.** The object's changed state is recorded in `GameState`, shown on the object, written into the documentation, and discussed at debrief. The debrief compares three things: what the player did, what was done historically, and what current practice would suggest.

**Reconciling with "failure is informative, not punishing":** consequences are permanent *for the object*, not for the player's progress. A damaging choice does not end the case or block advancement; it becomes the most important thing to talk about.

**Open questions**
- Saving: if the player can reload before an irreversible step, choices lose weight. Options: autosave immediately after irreversible actions, or one save slot per case.
- Authoring scope: debriefs should respond to the object's resulting state (rules over state) rather than to every possible path, to keep branching manageable.


## 3. Progression: earning trust and tools

**Intent:** Not every tool is available at once. As the player gains experience, they gain access and permission to use more tools. Experience (XP) leads to promotion, and with each promotion the mentor trusts them with more equipment.

This is the cognitive apprenticeship model in mechanical form: scaffolding fades (the mentor says less) while autonomy grows (the player can do more).

**Structure**
- XP is earned from case actions and outcomes.
- Ranks follow a real career ladder (e.g., technician → assistant conservator → associate conservator → conservator), each with a set of permitted tools and treatments.
- Every examination tool and treatment has a required rank.
- Promotion is a mentor moment (a conversation), not just a pop-up.

**What earns XP matters.** Rewarding only correct answers or completion invites gaming the system. Reward the habits of expert practice:
- Thorough examination before treatment
- Spot tests before treatment
- Asking appropriate questions and consulting before deciding
- Restraint (choosing not to intervene when that is right)
- Complete, accurate documentation

**Open questions**
- Can a poor decision cost XP or trust, or does it only earn less?
- How much progression appears in the demo (one case)? Possibly one promotion or one tool unlock, to show the system exists.


## Data model additions (draft)

Generic names for `core/`; to be finalized with the Phase 1 data model.

```
InquiryQuestion
  id, prompt_text
  available_from: [source]        (case_file, mentor, consultant:<discipline>)
  answers: {source: InquiryAnswer}
  unlocked_by (optional event or finding)

InquiryAnswer
  status                          (known, partial, unknown, disputed)
  text or dialogue timeline
  citations

TreatmentStep
  id, display_name
  reversibility                   (reversible, mentor_reversible, irreversible)
  required_rank
  effects on condition state

ExaminationTool
  id, display_name
  required_rank

Rank
  id, display_name, xp_threshold
  permitted tools and treatments
```

`GameState` additions: XP, rank, object state changes, questions asked, consultants called.
`EventBus` additions: question asked, consultant called, treatment step applied, step undone, XP earned, promoted.
