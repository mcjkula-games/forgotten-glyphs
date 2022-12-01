extends Node2D

onready var player_detector: Area2D = $Area2D
onready var escape_stone: Sprite = $Area2D2/Sprite2
onready var detect_player: Area2D = $Detect
onready var teleport_particles: Particles2D = $Particles2D
onready var timer: Timer = $Timer
onready var timer2: Timer = $Timer2

#var stats = FloorData setget set_stats
onready var parent = get_node("../")
onready var character = get_node("../../")._save.character
onready var stats = parent.stats

func _ready():
# warning-ignore:return_value_discarded
	player_detector.connect("body_entered", self, "stone_activated")
	escape_stone.visible = false
# warning-ignore:return_value_discarded
	detect_player.connect("body_entered", self, "start_teleport")
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "teleporting")
# warning-ignore:return_value_discarded
	#timer2.connect("timeout", self, "_save")

func stone_activated(body: KinematicBody2D) -> void:
	if body:
		escape_stone.visible = true

func start_teleport(body: KinematicBody2D) -> void:
	if body:
		teleport_particles.emitting = true
		timer.start()

func teleporting() -> void:
	get_tree().change_scene("res://LoadingScreen.tscn")
	_save()
	# warning-ignore:return_value_discarded
	#SceneTransistor.start_transition_to("res://Game.tscn")
	#timer2.start()

# warning-ignore:function_conflicts_variable
func _save() -> void:
	stats.upgrade_floor(1)
	SilentWolf.Scores.persist_score(character.name, stats.current_floor)
	if int(stats.current_floor) % 5 == 0:
			stats.upgrade_enemies(1)
	Events.emit_signal("save_game")
	
func set_stats(new_stats: FloorData) -> void:
	if new_stats == stats:
		return
	stats = new_stats
