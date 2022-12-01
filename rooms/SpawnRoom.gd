extends Node2D

const ENEMIES: Dictionary = {"BAT":preload("res://mobs/bat/Bat.tscn")}

onready var tilemap: TileMap = get_node("Navigation2D/TileMap")
onready var entrance: Node2D = get_node("Entrance")
onready var door_container: Node2D = get_node("Doors")
onready var player_detector: Area2D = get_node("Area2D")

func _ready():
# warning-ignore:return_value_discarded
	player_detector.connect("body_entered", self, "player_detected")
func open_doors() -> void:
	for door in door_container.get_children():
		door.open()

func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position), 17)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position) + Vector2.UP, 2)

func player_detected(body: KinematicBody2D) -> void:
	if body:
		player_detector.queue_free()
		_close_entrance()
