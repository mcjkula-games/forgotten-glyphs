extends Node2D

var a_timer_running = false
var b_timer_running = false

# Resource-Based Saving-System
#var _save: SaveGame = null

var _save := SaveGameAsJSON.new()

onready var bombs_section := $YSort/Mobs/Bombs
onready var bombs_section_l := $YSort/Labels/BOMB_AREA/TimerLabel
onready var bombs_section_t := $YSort/Mobs/Bombs/Timer

onready var bats_section := $YSort/Mobs/Bats
onready var bats_section_t := $YSort/Mobs/Bats/Timer

onready var player := $YSort/Player

onready var interface := $Interface
onready var npc := $YSort/NPCs/NPC/DialogueInterface

func _ready():
	_create_or_load_save()
# warning-ignore:return_value_discarded
	bombs_section_t.connect("timeout", self, "_on_bomb_spawner_timeout")
# warning-ignore:return_value_discarded
	bats_section_t.connect("timeout", self, "_on_bats_spawner_timeout")

func _process(_delta):
	_bomb_section_spawning()
	_bats_section_spawning()

func _input(event):
	if event.is_action_pressed("quit"):
		_save.write_savegame()

func _on_bomb_spawner_timeout() -> void:
	$YSort/Mobs/Bombs/Spawner.spawn()
	a_timer_running = false

func _on_bats_spawner_timeout() -> void:
	$YSort/Mobs/Bats/Spawner.spawn()
	b_timer_running = false

# Resource-Based Saving-System
#func _create_or_load_save() -> void:
#	if SaveGame.save_exists():
#		_save = SaveGame.load_savegame()
#	else:
#		_save = SaveGame.new()
#		_save.write_savegame()

func _create_or_load_save() -> void:
	if _save.save_exists():
		_save.load_savegame()
	else:
		_save.write_savegame()

	player.stats = _save.character
	interface.stats = _save.character
	npc.progress = _save.dialogue
	
	reload_player_health()

func _bomb_section_spawning() -> void:
	if bombs_section.get_child_count() < 3 and not a_timer_running:
		yield(get_tree().create_timer(0.85), "timeout")
		bombs_section_t.start()
		a_timer_running = true
		
	if a_timer_running:
		bombs_section_l.text = str(round(bombs_section_t.time_left)) + "s"
		bombs_section_l.show()
	else:
		bombs_section_l.hide()

func _bats_section_spawning() -> void:
	if bats_section.get_child_count() < 5 and not b_timer_running:
		yield(get_tree().create_timer(0.85), "timeout")
		bats_section_t.start()
		b_timer_running = true

func reload_player_health() -> void:
	player.stats.health = player.stats.max_health
