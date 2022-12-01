extends Node2D

const Fireball := preload("res://weapons/book/Fireball.tscn")
const MeleeProjectile := preload("res://weapons/sword/MeleeProjectile.tscn")

#onready var _attack_sound := $AudioStreamPlayer
#onready var _animation_player := $AnimationPlayer
onready var _shoot_position := $Position2D
onready var _cooldown_timer := $Timer

export var speed := 1.0

onready var parent := get_node("../../")
onready var player := get_node("../../../")

func _ready():
	_cooldown_timer.wait_time = 1.0 / speed

func use_1() -> void:
	_cooldown_timer.wait_time = 1.0 / speed
	_cooldown_timer.start()
	shoot(Fireball)
	#_attack_sound.pitch_scale = rand_range(1.7, 2.6)

func use_2() -> void:
	_cooldown_timer.wait_time = 1.0 / (speed * 0.75)
	_cooldown_timer.start()
	shoot(MeleeProjectile)
	#_attack_sound.pitch_scale = rand_range(1.7, 2.6)

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	var mouse_position := get_global_mouse_position()
	_rotation()
	
	if mouse_position.x - global_position.x < 0:
		self.scale.y = -1.12
	else:
		self.scale.y = 1.12
	
	if Input.is_action_pressed("attack") and _cooldown_timer.is_stopped():
		use_1()
	if Input.is_action_pressed("secondary_attack") and _cooldown_timer.is_stopped():
		use_2()

func _rotation():
	if parent.rotation_degrees > 360:
		parent.rotation_degrees = 0
	if parent.rotation_degrees < 0:
		parent.rotation_degrees = 360
	
	if parent.rotation_degrees < 25 or parent.rotation_degrees > 170:
		parent.show_behind_parent = true
	else:
		parent.show_behind_parent = false

func shoot(projectile: PackedScene) -> void:
	var projectile_instance := projectile.instance()
	projectile_instance.position = _shoot_position.global_position
	projectile_instance.direction = global_position.direction_to(get_global_mouse_position())
	add_child(projectile_instance)
