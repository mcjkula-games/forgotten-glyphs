# The base node representing all pickups.
#
# This class takes care of:
#
# 1. Detecting the player body.
# 2. Detecting the player's SpellHolder area.
#
# That's it. Whatever happens when either a body or an area enters is up to the
# script that inherit this class.
class_name Pickup
extends Area2D

var destroying = false

onready var _audio := $AudioStreamPlayer2D
onready var _animation_player := $AnimationPlayer
onready var _pickup_area := $PickupArea

# ANCHOR: ready_connect
func _ready() -> void:
# warning-ignore:return_value_discarded
	_pickup_area.connect("body_entered", self, "_on_player_pickup")
# warning-ignore:return_value_discarded
	_pickup_area.connect("body_exited", self, "_on_player_left")
# warning-ignore:return_value_discarded
	connect("area_entered", self, "_on_spell_holder_pickup")
# END: ready_connect

	_animation_player.play("idle")


# ANCHOR: virtual_functions
# Virtual function (scripts that extend this class should override this
# function). Called when the Robot touches the pickup.
# warning-ignore:unused_argument
func _on_player_pickup(player: Player) -> void:
	pass

# warning-ignore:unused_argument
func _on_player_left(player: Player) -> void:
	pass

# Virtual function. Called when the Robot's SpellHolder touches the pickup.
# warning-ignore:unused_argument
func _on_spell_holder_pickup(holder: SpellHolder) -> void:
	pass
# END: virtual_functions

# ANCHOR: disable
# Call this when someone loots the pickup to prevent it from getting looted
# twice. This is important if you want to play an animation before freeing the
# pickup.

func _disable() -> void:
	# The set_deferred() function waits for the end of the current frame to
	# change the property in quotes to the value passed as the second argument.
	#
	# You need that for some physics properties or Godot will give you an error.
	# Turning off monitoring and monitorable will prevent the area from
	# detecting anything else.
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	#disconnect("body_entered", self, "_on_player_pickup")
	#disconnect("area_entered", self, "_on_spell_holder_pickup")
# END: disable

# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "destroy":
		destroying = true
