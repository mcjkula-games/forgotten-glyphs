class_name WeaponHolder
extends Area2D

export var weapon_scene: PackedScene setget set_weapon_scene

# This is the unique child of the node. It only accepts a spell
var weapon: Weapon

onready var _weapon_spawning_point := $WeaponSpawningPoint

var selected_weapon = 0

var weapons = [
	preload("res://weapons/sword/Sword.tscn"),
	preload("res://weapons/hammer/Hammer.tscn"),
]

func _physics_process(_delta: float):
	var mouse_direction = get_global_mouse_position()
	# This function makes the node rotate towards the mouse
	look_at(mouse_direction)
	
	#if rotation_degrees > 360 or rotation_degrees < -360:
	#	rotation_degrees = 0
	
	if Input.is_action_just_pressed("ui_slot_1"):
		selected_weapon = 1
		set_weapon_scene(weapons[0])
	if Input.is_action_just_pressed("ui_slot_2"):
		selected_weapon = 2
		set_weapon_scene(weapons[1])

# This function takes care of replacing the current spell instance with a new
# one.
func set_weapon_scene(scene: PackedScene) -> void:
	weapon_scene = scene
	if weapon:
		weapon.queue_free()

	# If the node hasn't been added to the scene tree yet, pause the function until it emits its "ready" signal.
	# This is necessary if you assign a spell scene in the Inspector, as Godot will try to run this function right after creating this node in memory, before adding it to the scene tree.
	if not is_inside_tree():
		yield(self, "ready")

	if weapon_scene:
		var new_weapon = scene.instance()
		assert(new_weapon is Weapon, "You passed a scene that is not a Spell to the SpellHolder.")

		weapon = new_weapon
		_weapon_spawning_point.add_child(weapon)
	Events.emit_signal("selected_weapon_changed", scene)


func _disable() -> void:
	set_weapon_scene(null)
