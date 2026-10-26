extends Node
## Game-wide signals for every meaningful player action (tool used,
## condition identified, help requested, and so on).
##
## Emitters call EventBus.<signal>.emit(...); GameState, mentor rules, and
## Telemetry connect to these signals rather than to each other.
