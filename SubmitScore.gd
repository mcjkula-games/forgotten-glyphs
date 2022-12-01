extends Control

var _save := SaveGameAsJSON.new()

func _ready():
# warning-ignore:return_value_discarded
	$VBoxContainer/MarginContainer2/Button.connect("pressed", self, "submit_score")
	$VBoxContainer/MarginContainer/Label.grab_focus()

func submit_score() -> void:
	_save.character.name = $VBoxContainer/MarginContainer/Label.text
	yield(get_tree().create_timer(0.5), "timeout")
	_save.write_savegame()
	yield(get_tree().create_timer(0.5), "timeout")
	SilentWolf.Scores.persist_score(_save.character.name, _save.floor_data.current_floor)
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Dungeon.tscn")
