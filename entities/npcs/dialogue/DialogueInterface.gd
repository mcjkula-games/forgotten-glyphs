extends CanvasLayer

var progress: DialogueProgress setget set_progress

export(String, FILE, "*.json") var dialogue_file
export(String, FILE, "*.json") var again_dialogue_file
export(String, FILE, "*.json") var much_dialogue_file

var text_streaming = false
var dialogues = []
var current_dialogue_index = 0
var interact = false
#var already_interact = false
#var much_interact = false

onready var control = $Control 

func _ready():
	$Control.visible = false
	
	current_dialogue_index = -1
	
func play():
	$Control.visible = true
	text_streaming = true
	
	if not progress.already_interact:
		dialogues = load_dialogue()
		next_line()
	elif progress.already_interact and not progress.much_interact:
		dialogues = load_again_dialogue()
		next_line()
	else:
		dialogues = load_much_dialogue()
		next_line()

func next_line():
	current_dialogue_index += 1
	interact = true
	
	if current_dialogue_index >= len(dialogues):
		Events.emit_signal("dialogue_finished")
		
		if progress.already_interact:
			progress.already_interact = false
			progress.much_interact = true

		text_streaming = false
		interact = false
		$Control.visible = false
		progress.already_interact = true
		current_dialogue_index = -1
		progress.save()
		return
	
	$Control/RichTextLabel2.text = dialogues[current_dialogue_index]['name']
	$Control/RichTextLabel.text = dialogues[current_dialogue_index]['text']
	
	$Control/RichTextLabel.percent_visible = 0
	$Control/Tween.interpolate_property(
		$Control/RichTextLabel, "percent_visible", 0, 1, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Control/Tween.start()

func load_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())

func load_again_dialogue():
	var file = File.new()
	if file.file_exists(again_dialogue_file):
		file.open(again_dialogue_file, file.READ)
		return parse_json(file.get_as_text())

func load_much_dialogue():
	var file = File.new()
	if file.file_exists(much_dialogue_file):
		file.open(much_dialogue_file, file.READ)
		return parse_json(file.get_as_text())

func speed_up():
	$Control/Tween.playback_speed = INF

func set_progress(new_progress: DialogueProgress) -> void:
	if new_progress == progress:
		return
	progress = new_progress

func _on_Tween_tween_all_completed():
	text_streaming = false
	$Control/Tween.playback_speed = 1
