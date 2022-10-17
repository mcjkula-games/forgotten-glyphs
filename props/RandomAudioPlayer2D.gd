# Plays a random sound from an array of provided sound files.
#
# If no sounds are set in the array, will play the set `stream` property like
# any regular AudioStreamPlayer2D.
#
# Additionally to playing a random sound, it can also randomize the pitch, so
# even the same sound can sound slightly different on each play.
#
# This script only works in-game, not in the editor.
#
# ANCHOR: head
class_name RandomAudioPlayer2D
extends AudioStreamPlayer2D
# END: head

# A list of sounds to play from. If no additional sound is provided, then the 
# RandomAudioPlayer2D will act as a normal audio player
# ANCHOR: var_sounds
export(Array, AudioStream) var sounds = []
# END: var_sounds

# If this is true, the pitch will be shifted on each different play
# ANCHOR: var_randomize
export var randomize_pitch := true
# END: var_randomize

# ANCHOR: play
# ANCHOR: play_definition
func play(from_position = 0.0) -> void:
# END: play_definition
	if sounds:
		stream = sounds[randi() % sounds.size()]
	if randomize_pitch:
		pitch_scale = rand_range(0.9, 1.6)
	.play(from_position)
# END: play
