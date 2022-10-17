class_name Weapon
extends Node2D

export var damage := 1.0
export var speed := 1.0
export var critical_chance := 1.0

var current_animation_index := 0
var crit_happened = false

onready var _animation_player := $AnimationPlayer
onready var _audio := $AudioStreamPlayer2D
# The cool down timer can be used to prevent firing very rapidly
onready var _cooldown_timer := $CoolDownTimer
onready var weapon_area := $Hitbox

onready var parent := get_node("../../")

func _ready() -> void:
	_cooldown_timer.wait_time = 1.0 / speed
	
# warning-ignore:return_value_discarded
	weapon_area.connect("body_entered", self, "_on_body_entered")

func crit():
	var cc = critical_chance / 100
	
	var prob = rand_range(0.0, 1.0)
	if prob < cc:
		Events.emit_signal("crit_happened_t")
		if not crit_happened:
			damage = damage * 2
		crit_happened = true
		damage = damage
	else:
		Events.emit_signal("crit_happened_f")
		if crit_happened:
# warning-ignore:integer_division
			damage = damage / 2
		crit_happened = false
		damage = damage
	return damage

func _rotation():
	if parent.rotation_degrees > 360:
		parent.rotation_degrees = 0
	if parent.rotation_degrees < 0:
		parent.rotation_degrees = 360
	
	if current_animation_index == 0:
		if parent.rotation_degrees < 80 or parent.rotation_degrees > 260:
			parent.show_behind_parent = true
		else:
			parent.show_behind_parent = false
	if current_animation_index == 1:
		if parent.rotation_degrees < 80 or parent.rotation_degrees > 260:
			parent.show_behind_parent = false
		else:
			parent.show_behind_parent = true

func _hit_body(body: Node) -> void:
	if not body.has_method("take_damage"):
		return
	body.take_damage(damage)

func _on_body_entered(body: Node) -> void:
	_hit_body(body)
