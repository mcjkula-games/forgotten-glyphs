class_name SaveGameAsJSON
extends Reference

const SAVE_GAME_PATH := "user://save.json"

var character: Resource = CharacterStats.new()
var dialogue: Resource = DialogueProgress.new()
var floor_data: Resource = FloorData.new()
#var inventory: Resource = Inventory.new()

var _file := File.new()

func save_exists() -> bool:
	return _file.file_exists(SAVE_GAME_PATH)

func write_savegame() -> void:
	var error := _file.open(SAVE_GAME_PATH, File.WRITE)
	if error != OK:
		printerr("Could not open the file %s. Aborting save operation. Error code: %s" % [SAVE_GAME_PATH, error])
		return

	var data := {
		"player":
		{
			"name": character.name,
			"max_health": character.max_health,
			"health": character.health,
			"level": character.level,
			"experience_total": character.experience_total,
			"experience": character.experience,
			"experience_required": character.experience_required,
		},
		"dialogue":
		{
			"already_interact": dialogue.already_interact,
			"much_interact": dialogue.much_interact,
		},
		"floor":
		{
			"current_floor": floor_data.current_floor,
			"enemies_diff": floor_data.enemies_diff,
		}
	}
	
	var json_string := JSON.print(data)
	_file.store_string(json_string)
	_file.close()

func load_savegame() -> void:
	var error := _file.open(SAVE_GAME_PATH, File.READ)
	if error != OK:
		printerr("Could not open the file %s. Aborting load operation. Error code: %s" % [SAVE_GAME_PATH, error])
		return

	var content := _file.get_as_text()
	_file.close()

	var data: Dictionary = JSON.parse(content).result

	character = CharacterStats.new()
	character.name = data.player.name
	character.max_health = data.player.max_health
	character.health = data.player.health
	character.level = data.player.level
	character.experience_total = data.player.experience_total
	character.experience = data.player.experience
	character.experience_required = data.player.experience_required

	dialogue = DialogueProgress.new()
	dialogue.already_interact = data.dialogue.already_interact
	dialogue.much_interact = data.dialogue.much_interact
	
	floor_data = FloorData.new()
	floor_data.current_floor = data.floor.current_floor
	floor_data.enemies_diff = data.floor.enemies_diff
