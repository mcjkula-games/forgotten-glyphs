extends Node2D

const ENEMIES: Dictionary = {"BAT":preload("res://mobs/bat/Bat.tscn")}

# "res://mobs/bat/Bat.tscn"

#var stats = FloorData setget set_stats

onready var parent = get_node("../")
onready var stats = parent.stats

onready var tilemap: TileMap = get_node("Navigation2D/TileMap")
onready var entrance: Node2D = get_node("Entrance")
onready var door_container: Node2D = get_node("Doors")
onready var player_detector: Area2D = get_node("Area2D")
onready var enemy_pos_container: Node2D = get_node("EnemyPos")

var num_enemies: int

# warning-ignore:unused_signal
signal stats_loaded

func _ready():
	num_enemies = enemy_pos_container.get_child_count()
# warning-ignore:return_value_discarded
	player_detector.connect("body_entered", self, "player_detected")
	_spawn_enemies()


func _spawn_enemies() -> void:
	#yield(get_tree().create_timer(0.1), "timeout")
	for e in enemy_pos_container.get_children():
		var enemy: KinematicBody2D = ENEMIES.BAT.instance()
		var __ = enemy.connect("tree_exited", self, "_on_enemy_killed")
		enemy.global_position = e.position
		enemy.level = stats.enemies_diff
		#print(enemy.level)
		self.add_child(enemy)

func _on_enemy_killed() -> void:
	parent.enemies_count -= 1
	Events.emit_signal("get_enemies_count", parent.enemies_count)
	num_enemies -= 1
	if num_enemies == 0:
		open_doors()
		_reopen_entrance()

func open_doors() -> void:
	for door in door_container.get_children():
		door.open()
		var index = self.get_index()
		parent.get_child(index + 1).get_node("Navigation2D/TileMap3").queue_free()

func _close_entrance() -> void:
	yield(get_tree().create_timer(0.33), "timeout")
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position), 17)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position) + Vector2.UP, 0)

func _reopen_entrance() -> void:
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position), 0)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position) + Vector2.UP, 0)

func player_detected(body: KinematicBody2D) -> void:
	if body:
		player_detector.queue_free()
		_close_entrance()

func set_stats(new_stats: FloorData) -> void:
	if new_stats == stats:
		return
	stats = new_stats
