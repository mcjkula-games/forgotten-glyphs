class_name Player
extends KinematicBody2D

var stats: CharacterStats setget set_stats

# The character's speed in pixels per second.
export var speed := 150.0
export var roll_speed := 250.0
export var accel := 500.0

export var friction := 500.0
# Controls how quickly the body reaches its desired velocity. A value of 1 makes
# the character move instantly at its maximum speed.
export(float, 0.01, 1.0) var drag_factor := 0.12

enum {
	MOVE,
	ROLL,
	INTERACT,
}

var velocity := Vector2.ZERO
var state = MOVE
var roll_direction = Vector2.DOWN

var floating_numbers = preload("res://interface/floating_text/FloatingText.tscn")
var level_up_anim := preload("res://interface/floating_level/FloatingLevel.tscn")

onready var _camera: ShakingCamera2D = $ShakingCamera2D
onready var _damage_audio = $DamageAudio
onready var _death_audio = $DeathAudio
onready var _skin := $Body
onready var _weapon_holder := $WeaponHolder
onready var _weapon_spawn := $WeaponHolder/WeaponSpawningPoint
onready var _animation_player := $Body/AnimationPlayer
onready var _trail := $Body/Trail

onready var _health_timer := $Timers/HealthRegenarationTimer
onready var _stamina_timer := $Timers/StaminaRegenarationTimer

onready var interaction_manager := $InteractionManager
#onready var _spell_holder := $SpellHolder

func _ready() -> void:
	#Events.emit_signal("player_health", max_health)
# warning-ignore:return_value_discarded
	Events.connect("dialogue_finished", self, "on_dialogue_finished")
# warning-ignore:return_value_discarded
	Events.connect("player_level_up", self, "on_level_up")
	# When the death audio finished playing, we go to the game over screen by
	# calling get_tree().change_scene().
	_death_audio.connect("finished", get_tree(), "change_scene", ["res://interface/GameOver.tscn"])
	
# warning-ignore:return_value_discarded
	_health_timer.connect("timeout", self, "_on_health_regen")
# warning-ignore:return_value_discarded
	_stamina_timer.connect("timeout", self, "_on_stamina_regen")
	
	if not stats:
		return
	
	#stats.update_max_health()

# This is the same steering movement code you used since the start of the
# course.
func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			_skin.set_physics_process(true)
			_weapon_spawn.get_child(0).set_physics_process(true)
			move_state(delta)
		ROLL:
			roll_state(delta)
		INTERACT:
			_weapon_holder.hide()
			if Input.is_action_just_pressed("use, interact"):
				interaction_manager.initiate_interaction()
			_skin.set_physics_process(false)
			_weapon_spawn.get_child(0).set_physics_process(false)
	
	if Input.is_action_pressed("secondary_attack") and not _weapon_holder.selected_weapon == 2:
		_weapon_spawn.global_position = _weapon_holder.global_position
		_weapon_holder.set_physics_process(false)
	else:
		_weapon_spawn.position = Vector2(17, 0)
		_weapon_holder.set_physics_process(true)

func move_state(delta) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		roll_direction = direction
		var desired_velocity := speed * direction
		var steering := desired_velocity - velocity
		velocity += steering * drag_factor
		velocity = velocity.move_toward(direction * speed, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll") and stats.stamina >= 20:
		stats.stamina -= 20
		state = ROLL
	
	if Input.is_action_just_pressed("use, interact"):
		if interaction_manager.current_interaction != null:
			interaction_manager.initiate_interaction()
				
			state = INTERACT

func roll_state(_delta):
	velocity = roll_direction * roll_speed
	if not _trail.flip_h:
		_animation_player.play("right_roll")
	else:
		_animation_player.play("left_roll")
	move()

func _on_health_regen() -> void:
	if not stats.health == stats.max_health:
		stats.health += 1

func _on_stamina_regen() -> void:
	if not stats.stamina >= 100:
		stats.stamina += 1

# Called by the Teleport node when we walk over it. This jumps to the win screen
# scene.
func teleport() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://interface/WinGame.tscn")

func on_level_up():
	var text = level_up_anim.instance()
	add_child(text)

# Called by enemy bullets when they hit the robot.
func take_damage(amount: int) -> void:
	if stats.health <= 0:
		return

	stats.set_health(stats.health - amount)
	#print(_stats.health)
	# If the health is lower or equal to zero, we're dead, so we disable
	# movement.
	if stats.health <= 0:
		_disable()
		# We play the death animation and sound too.
		_skin.die()
		_death_audio.play()
		_weapon_holder.hide()
		#_spell_holder.hide()
	else:
		_damage_audio.play()
		_camera.shake_intensity += 0.6
	
	var text = floating_numbers.instance()
	text.type = "Damage"
	text.amount = amount
	add_child(text)

func roll_animation_finished():
	velocity = velocity * 0.75
	state = MOVE

func on_dialogue_finished() -> void:
	_weapon_holder.show()
	state = MOVE

func move() -> void:
	velocity = move_and_slide(velocity)

func set_stats(new_stats: CharacterStats) -> void:
	if new_stats == stats:
		return
	stats = new_stats

# Makes the player interact with nothing and stop receiving inputs
func _disable() -> void:
	set_process(false)
	set_physics_process(false)
	collision_layer = 0
	collision_mask = 0
