extends Node
## Single source of truth for current progress, case state, and player
## decisions (including dialogue choices).
##
## Updated in response to EventBus signals. SaveSystem serializes it;
## nothing else should keep a parallel copy of this state.
