# Base class for mobs. Defines some functions you can reuse to create different
# kinds of mobs.
class_name Mob
extends KinematicBody2D

const EXPERIENCE := [
	preload("res://pickups/experience/PickupExperience.tscn")
]

const LOOT_SCENES := [
	preload("res://pickups/health/PickupHealth.tscn")
]

export var level  := 1
# The damage this mob inflicts when it hits the player.
export var damage := 1
# How much damage the mob can take before dying.
export var health := 2
# How much points the mob gives when killed.
export var points := 5
# How far from the player this mob will orbit. The export hint in parentheses limits
# The minimum and maximum orbit distance you can choose.
export (float, 100.0, 400.0, 1.0) var orbit_distance := 200.0
# Movement speed in pixels per second.
export var speed := 250.0

# This will be set if the robot is in view
var _target: Player = null
# if the robot can be attacked
var _target_within_range := false

# The velocity of the enemy
var _velocity := Vector2.ZERO
# How fast the enemy can react
var _drag_factor := 6.0
# Detects when player is close

#var health_charge := 1
#var loot_scale := Vector2(0.35, 0.35)

var floating_text = preload("res://interface/floating_text/FloatingText.tscn")
var crit_type = false

onready var root = get_node("../../../")
onready var player = root.get_node("YSort/Player")
onready var room = get_node("../")
onready var items = root.get_node("YSort/Items")

onready var _detection_area := $DetectionArea
# Detects when player is within attack range; smaller than detection area.
onready var _attack_area := $AttackArea
# Plays a sound when the mob dies.
onready var _die_sound := $DieSound
# Wind-up time just before attacking.
onready var _before_attack_timer := $BeforeAttackTimer
# Waiting time before attacking again.
onready var _cooldown_timer := $CoolDownTimer
# The enemy sprite itself. Unused in the base mob, but can be useful in
# inherited mobs.
onready var _sprite := $Sprite
# Another sprite that is visible when the enemy is alerted. Can be a different
# color, a "!" sign, anything.
onready var _sprite_alert := $Sprite/Alert
onready var _shadow := $Shadow
# The animation player.
onready var _animation_player := $AnimationPlayer
onready var _hurt_sound := $HurtSound

#onready var _tween_e := $TweenE as Tween
#onready var _tween_p := $TweenP as Tween
#onready var _experience_node := $Experience
#onready var _path_experience := $Experience/PathFollow2D as PathFollow2D
#onready var _path_pickup := $Path2D/PathFollow2D as PathFollow2D

onready var _timer := $Timer

func _ready() -> void:
	update_stats()
	
# warning-ignore:return_value_discarded
	Events.connect("crit_happened_t", self, "_on_crit_type_t")
# warning-ignore:return_value_discarded
	Events.connect("crit_happened_f", self, "_on_crit_type_f")
	# This area detects when the player gets in range of the mob. Use it to play
	# "wake-up" style animations, or get the mob to track the player.
# warning-ignore:return_value_discarded
	_detection_area.connect("body_entered", self, "_on_DetectionArea_body_entered")
# warning-ignore:return_value_discarded
	_detection_area.connect("body_exited", self, "_on_DetectionArea_body_exited")
	# This is another area that detects when the player gets within attack range.
# warning-ignore:return_value_discarded
	_attack_area.connect("body_entered", self, "_on_AttackArea_body_entered")
# warning-ignore:return_value_discarded
	_attack_area.connect("body_exited", self, "_on_AttackArea_body_exited")
	# We connect the die sound to call queue_free after it
# warning-ignore:return_value_discarded
	_die_sound.connect("finished", self, "_on_DieSound_finished")
	# There's a little wind up before attacking, and we attack once it times out.
# warning-ignore:return_value_discarded
	_before_attack_timer.connect("timeout", self, "_on_BeforeAttackTimer_timeout")
# warning-ignore:return_value_discarded
	_cooldown_timer.connect("timeout", self, "_on_CoolDownTimer_timeout")
	# _sprite_alert is when the player is in view. We start out with it invisible.
	
	visible = false

func _process(_delta):
	#var children = _path_pickup.get_children()
	#for childs in children:
	#	var items_layer = root.get_child(2)
	#
	#	_path_pickup.remove_child(childs)
	#	items_layer.call_deferred("add_child", childs)
	#	
	#	childs.global_position = self.global_position * 1.176
	pass

# This function can be used to know if the mob can attack.
#
# A mob can attack if and only if:
#
# 1. The player is in view.
# 2. The cooldown timer is not running.
# 3. The wind-up to attach timer is not running.
func is_ready_to_attack() -> bool:
	return (
		_target
		and _cooldown_timer.is_stopped()
		and _before_attack_timer.is_stopped()
	)


# Steers towards the target position. Use this to follow the player, or any
# other point of interest for the mob.
func follow(target_global_position: Vector2) -> void:
	var desired_velocity := global_position.direction_to(target_global_position) * speed
	var steering := desired_velocity - _velocity
	_velocity += steering / _drag_factor
	_velocity = move_and_slide(_velocity, Vector2.ZERO)


# Orbit around the target if there is one.
func orbit_target() -> void:
	if not _target:
		return
	var direction := _target.global_position.direction_to(global_position)
	var offset_from_target := direction.rotated(PI / 6.0) * orbit_distance
	follow(_target.global_position + offset_from_target)

func can_see_player():
	return _target != null

func _on_crit_type_t() -> void:
	crit_type = true

func _on_crit_type_f() -> void:
	crit_type = false

# Called by bullets.
func take_damage(amount: int) -> void:
	_hurt_sound.pitch_scale = rand_range(0.8, 1.2)
	
	health -= amount
	if health <= 0:
		_die()
	else:
		_animation_player.stop()
		_animation_player.play("hit")
		_hurt_sound.play()
	
	var text = floating_text.instance()
	if not crit_type:
		text.type = "Damage"
	else:
		text.type = "Critical"
	text.amount = amount
	add_child(text)

func update_stats() -> void:
	level = level
	
	health = health * level
	damage = damage * level
	
	points = points * level

# Disables the mob, plays the "die" animation and the "die" sound. Emits
# "mob_died" the global event bus, which will relay it. When the "die" sound
# finishes, the mob is removed.
func _die() -> void:
	#Events.emit_signal("mob_died", points)
	_create_experience()
	_create_pickup()
	
	_disable()
	_animation_player.play("die")
	_die_sound.play()

func _create_experience() -> void:
	Events.emit_signal("experience_collected", points)
	#for p in (points / 5.0):
	#	var experience = EXPERIENCE[randi() % EXPERIENCE.size()].instance()
	#	_path_experience.call_deferred("add_child", experience)
	#	experience.scale = Vector2(1.0, 1.0)

func _create_pickup() -> void:
	var loot = LOOT_SCENES[randi() % LOOT_SCENES.size()].instance()
	loot.global_position = self.global_position
	items.call_deferred("add_child", loot)

# Disables the mob. We remove anything that can trigger collisions again and
# leave the monster as an invisible wall. This is useful if you want to play
# death animations or sounds before queue_free, but don't want the mob to act
# anymore
func _disable() -> void:
	collision_layer = 0
	collision_mask = 0

	_detection_area.set_deferred("monitoring", false)
	_detection_area.set_deferred("monitorable", false)
	_detection_area.collision_layer = 0
	_detection_area.collision_mask = 0

	_attack_area.set_deferred("monitoring", false)
	_attack_area.set_deferred("monitorable", false)
	_attack_area.collision_mask = 0
	_attack_area.collision_layer = 0

	set_physics_process(false)


# When the die sound finishes playing, we can remove the mob.
func _on_DieSound_finished() -> void:
	queue_free()

# When the player enters the detection area, we set the _target variable and
# show the _sprite_alert node.
func _on_DetectionArea_body_entered(body: Player) -> void:
	_target = body
	_sprite_alert.visible = true


# When the player exists the detection area, we set _target to null and hide the
# _sprite_alert.
#
# If you want a mob that doesn't let the player go after seeing it, override
# this method and set it to pass. Then the mob will remember the player forever.
func _on_DetectionArea_body_exited(_body: Player) -> void:
	_target = null
	_sprite_alert.visible = false


# Called when the player is within attack range.
# warning-ignore:unused_argument
func _on_AttackArea_body_entered(body: Player) -> void:
	_target_within_range = true


# Called when the player exits attack range.
func _on_AttackArea_body_exited(_body: Player) -> void:
	_target_within_range = false


# Called when the wind-up before attacking has ran out. The mob should now
# attack.
func _on_BeforeAttackTimer_timeout() -> void:
	pass


# Called when the attack was launched and recovered from. The mob is ready to
# attack again now.
func _on_CoolDownTimer_timeout() -> void:
	pass


func _on_VisibilityNotifier2D_screen_entered():
	visible = true

func _on_VisibilityNotifier2D_screen_exited():
	visible = false
