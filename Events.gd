# Auto-loaded node that only emits signals.
#
# Any node in the game can use it to emit signals, like so:
#
# Events.emit_signal("mob_died", 10)
#
# Any node in the game can connect to the events:
#
# Events.connect("mob_died", self, "_on_Events_mob_died")
#
# This allows nodes to easily communicate accross the project without needing to
# know about each other. We mainly use it to update the heads-up display, like
# the player's health and score.
extends Node

# warning-ignore:unused_signal
signal selected_spell_changed(new_selected_spell_scene)
# warning-ignore:unused_signal
signal selected_weapon_changed(new_selected_weapon_scene)
# warning-ignore:unused_signal
signal mob_died(points)
# warning-ignore:unused_signal
signal experience_collected(amount)
# warning-ignore:unused_signal
signal enemy_health_changed(new_health)
# warning-ignore:unused_signal
signal player_level_up()
# warning-ignore:unused_signal
signal player_max_health_changed(new_max_health)
# warning-ignore:unused_signal
signal player_health_changed(new_health)
# warning-ignore:unused_signal
signal player_health(_health)
# warning-ignore:unused_signal
signal player_stamina_changed(new_stamina)

# warning-ignore:unused_signal
signal crit_happened_t()
# warning-ignore:unused_signal
signal crit_happened_f()

# warning-ignore:unused_signal
signal dialogue_finished()
# warning-ignore:unused_signal
signal save_dialogue_p()
