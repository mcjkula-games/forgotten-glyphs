class_name HammerWeapon
extends Weapon

var swing_animation_index := [
	"swing",
	"second_swing",
]

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	_rotation()
	
	if Input.is_action_pressed("attack") and _cooldown_timer.is_stopped():
		attack()
	if Input.is_action_pressed("secondary_attack"):
		pass
		
func _hit_body(body: Node) -> void:
	if not body.has_method("take_damage"):
		return
	body.take_damage(crit())

func _rotation():
	if parent.rotation_degrees > 360:
		parent.rotation_degrees = 0
	if parent.rotation_degrees < 0:
		parent.rotation_degrees = 360

	if current_animation_index == 0:
		yield(get_tree().create_timer(0.70), "timeout")
		
		if parent.rotation_degrees > 265 or parent.rotation_degrees < 145:
			parent.show_behind_parent = true
		else:
			parent.show_behind_parent = false
	if current_animation_index == 1:
		yield(get_tree().create_timer(0.70), "timeout")
		
		if parent.rotation_degrees > 265 or parent.rotation_degrees < 45:
			parent.show_behind_parent = false
		else:
			parent.show_behind_parent = true

func attack() -> void:
	_cooldown_timer.start()
	
	_animation_player.play(swing_animation_index[current_animation_index])
	current_animation_index += 1
		
	if current_animation_index > 1:
		current_animation_index = 0
	_audio.play()
