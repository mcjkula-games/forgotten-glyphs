class_name SwordWeapon
extends Weapon

var swing_animation_index := [
	"swing",
	"second_swing",
]

var whirlwind_animation_index := [
	"whirlwind_n",
	"whirlwind_b"
]

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	._rotation()

	if Input.is_action_pressed("attack") and _cooldown_timer.is_stopped():
		if not Input.is_action_just_pressed("secondary_attack"):
			attack()
	if Input.is_action_pressed("secondary_attack"):
		if not Input.is_action_pressed("attack"):
			secondary_attack()

func _hit_body(body: Node) -> void:
	if not body.has_method("take_damage"):
		return
	body.take_damage(crit())

func attack() -> void:
	_cooldown_timer.start()
	
	_animation_player.play(swing_animation_index[current_animation_index])
	current_animation_index += 1
		
	if current_animation_index > 1:
		current_animation_index = 0
	_audio.play()

func secondary_attack() -> void:
	_animation_player.play(whirlwind_animation_index[current_animation_index])
