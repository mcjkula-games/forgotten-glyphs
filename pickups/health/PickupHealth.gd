# Increases the robot's health when collected.
extends Pickup

export var add_health = 1

var floating_text = preload("res://interface/floating_text/FloatingText.tscn")

var already_full_life = false
var item_name

func _ready() -> void:
	item_name = "Potion"

func _on_player_pickup(player: Player) -> void:
	_light.visible = false
	var text = floating_text.instance()
	
	if player.stats.health != player.stats.max_health:
		already_full_life = false
		player.stats.health += add_health
		
		text.type = "Heal"
		text.amount = add_health
		player.add_child(text)
		
		_disable()
		_animation_player.play("destroy")
	elif not destroying:
		#_animation_player.play("idle (full_health)")
		_animation_player.play("idle")
