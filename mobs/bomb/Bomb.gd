extends Mob

onready var _shock_area := $ShockArea

func _ready() -> void:
# warning-ignore:return_value_discarded
	_animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
# warning-ignore:return_value_discarded
	_shock_area.connect("body_entered", self, "_on_ShockArea_body_entered")

# Called when the player is within attack range.
# We start the explosion animation
func _on_AttackArea_body_entered(_body: Player) -> void:
	_sprite_alert.visible = true
	_animation_player.play("will_explode")
	# If we entered the explosion animation, we're done, there's no turning back
	_attack_area.disconnect("body_exited", self, "_on_AttackArea_body_exited")


# Called when the player exits attack range.
# We restore normal animation
func _on_AttackArea_body_exited(_body: Player) -> void:
	_sprite_alert.visible = false
	# after reset, the bomb will resume the "hover" animation
	_animation_player.play("RESET")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "will_explode":
		_die_sound.play()
		_disable()
		_animation_player.play("explode")
	elif anim_name == "RESET":
		_animation_player.play("hover")


func _on_ShockArea_body_entered(body: Player) -> void:
	# We want shockarea to hit the player, but also enemies, which includes the
	# bomb itself. So we make sure the body isn't the bomb
	if body == self:
		return
	if body.has_method("take_damage"):
		body.take_damage(damage)

func take_damage(_amount: int) -> void:
	pass
#	if health <= 0:
#		_disable()
#		_die()
#	else:
#		_animation_player.stop()
#		_animation_player.play("hit")
#		_hurt_sound.play()
#	
#	var text = floating_text.instance()
#	if not crit_type:
#		text.type = "Damage"
#	else:
#		text.type = "Critical"
#	text.amount = amount
#	text.scale = Vector2(8.0, 8.0)
#	add_child(text)

func _disable() -> void:
	._disable()
	#_shock_area.set_deferred("monitoring", false)
	#_shock_area.set_deferred("monitorable", false)
	#_shock_area.collision_mask = 0
	#_shock_area.collision_layer = 0

#func _enable() -> void:
#	_shock_area.set_deferred("monitoring", true)
#	_shock_area.set_deferred("monitorable", true)
#	_shock_area.collision_mask = 1
#	_shock_area.collision_layer = 0
