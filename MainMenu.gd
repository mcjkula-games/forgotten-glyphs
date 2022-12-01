extends Control

var directory = Directory.new();
var SaveExists = directory.file_exists("user://save.json")

func _ready():
# warning-ignore:return_value_discarded
	$VBoxContainer/PlayButton.connect("pressed", self, "_on_Play_pressed")
# warning-ignore:return_value_discarded
	$VBoxContainer/NewButton.connect("pressed", self, "_on_New_pressed")
# warning-ignore:return_value_discarded
	$VBoxContainer/QuitButton.connect("pressed", self, "_on_Quit_pressed")
# warning-ignore:return_value_discarded
	$VBoxContainer2/Button.connect("pressed", self, "_on_Leaderboard_pressed")
	$VBoxContainer/NewButton.grab_focus()
	
	if SaveExists:
		$VBoxContainer/PlayButton.visible = true
		

func _on_Play_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Dungeon.tscn")

func _on_New_pressed():
	var dir = Directory.new()
	if ("user://save.json"):
		dir.remove("user://save.json")
	
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://SubmitScore.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func _on_Leaderboard_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://addons/silent_wolf/Scores/Leaderboard.tscn")
