extends StaticBody2D

onready var _anim_player : AnimationPlayer = get_node("AnimationPlayer")

func open() -> void:
	_anim_player.play("open")
