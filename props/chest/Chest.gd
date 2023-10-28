extends Area2D

const LOOT_SCENES := [
	preload("res://pickups/health/PickupHealth.tscn")
]

var _player: Player = null

onready var _animation_player := $AnimationPlayer as AnimationPlayer
onready var _tween := $Tween as Tween
onready var _path_follow := $Path2D/PathFollow2D as PathFollow2D
onready var _label := $Label

func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("body_entered", self, "p_is_on_chest")
# warning-ignore:return_value_discarded
	connect("body_exited", self, "p_not_on_chest")
	
	visible = false

# warning-ignore:unused_argument
func _physics_process(delta):
	if not _player == null and Input.is_action_just_pressed("use, interact"):
		_loot(_player)

# warning-ignore:unused_argument
func _loot(player : KinematicBody2D) -> void:
	set_deferred("monitoring", false)
	_animation_player.play("loot")
	yield(get_tree().create_timer(0.1), "timeout")
	_create_pickup()

func p_is_on_chest(player: KinematicBody2D) -> void:
	_player = player
	_label.show()

# warning-ignore:unused_argument
func p_not_on_chest(player: KinematicBody2D) -> void:
	_player = null
	_label.hide()

func _create_pickup() -> void:
	var loot = LOOT_SCENES[randi() % LOOT_SCENES.size()].instance()
	_path_follow.call_deferred("add_child", loot)
# warning-ignore:return_value_discarded
	_tween.interpolate_property(_path_follow, "unit_offset", 0, 1, 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
# warning-ignore:return_value_discarded
	_tween.start()


func _on_VisibilityNotifier2D_screen_entered():
	visible = true


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
