extends CanvasLayer

onready var _anim_player = $AnimationPlayer

func _ready():
	_anim_player.play("change_scene")

func change_scene() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Dungeon.tscn")
