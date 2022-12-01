extends Node2D

var a_timer_running = false
var b_timer_running = false

# Resource-Based Saving-System
#var _save: SaveGame = null

var _save := SaveGameAsJSON.new()

#onready var bats_section := $YSort/Mobs/Bats
#onready var bats_section_t := $YSort/Mobs/Bats/Timer

onready var player := $YSort/Player

onready var interface := $Interface
#onready var endroom := $Rooms.get_child($Rooms.get_child_count() - 1)
#onready var room := $Rooms.get_child(1)
onready var rooms := $Rooms
#onready var npc := $YSort/NPCs/NPC/DialogueInterface

func _ready():
# warning-ignore:return_value_discarded
	Events.connect("save_game", self, "_save_game")
# warning-ignore:return_value_discarded
	Events.connect("create_new_game", self, "_save_game")
	_create_or_load_save()
# warning-ignore:return_value_discarded
	#bats_section_t.connect("timeout", self, "_on_bats_spawner_timeout")
	
	#print(yield(SilentWolf.Scores.get_high_scores(0), "sw_scores_received"))


func _init():
	randomize()

func _process(_delta):
	pass
	#_bats_section_spawning()

#func _input(event):
#	if event.is_action_pressed("quit"):
#		_save.write_savegame()

#func _on_bats_spawner_timeout() -> void:
#	$YSort/Mobs/Bats/Spawner.spawn()
#	b_timer_running = false

# Resource-Based Saving-System
#func _create_or_load_save() -> void:
#	if SaveGame.save_exists():
#		_save = SaveGame.load_savegame()
#	else:
#		_save = SaveGame.new()
#		_save.write_savegame()

func _save_game() -> void:
	_save.write_savegame()

func _create_or_load_save() -> void:
	if _save.save_exists():
		_save.load_savegame()
	else:
		_save.write_savegame()
		
	#get_room(_save.floor_data)

	player.stats = _save.character
	interface.stats = _save.character
	interface.floor_data = _save.floor_data
	
	rooms.stats = _save.floor_data
	
	#SubmitScore.stats = _save.floor_data
	
	#endroom.stats = _save.floor_data
	#room.stats = _save.floor_data

	
	#npc.progress = _save.dialogue
	
	#reload_player_health()

#func _bats_section_spawning() -> void:
#	if bats_section.get_child_count() < 5 and not b_timer_running:
#		yield(get_tree().create_timer(0.85), "timeout")
#		bats_section_t.start()
#		b_timer_running = true

#func get_room(data) -> void:
#	if int(data.current_floor) % 10 == 0:
#		room = $Rooms.get_child(1)

#func reload_player_health() -> void:
#	player.stats.health = player.stats.max_health
