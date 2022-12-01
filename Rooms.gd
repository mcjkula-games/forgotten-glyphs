extends Node

var stats = FloorData setget set_stats

const SPAWN_ROOMS: Array = [preload("res://rooms/Room2.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://rooms/Room.tscn")]
# const WAVE_MISSION_ROOMS: Array = []
const BOSS_ROOMS: Array = [preload("res://rooms/BossRoom.tscn")]
const END_ROOMS: Array = [preload("res://rooms/Room3.tscn")]

const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: int = 0
const RIGHT_WALL_INDEX: int = 42
const LEFT_WALL_INDEX: int = 41

export(int) var num_levels: int = 3

var enemies_count = 0

onready var player: KinematicBody2D = get_parent().get_node("YSort/Player")
#onready var dummy: KinematicBody2D = get_parent().get_node("YSort/Mobs/Dummy")

func _ready() -> void:
	_spawn_rooms()

func _spawn_rooms() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	var previous_room: Node2D
	
	if not int(stats.current_floor) % 10 == 0:
		num_levels = 4
		
		for i in num_levels:
			var room: Node2D
			
			if i == 0:
				room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instance()
				player.position = room.get_node("PlayerSpawnPos").position
				#dummy.position = room.get_node("DummyPos").position
			else:
				if i == num_levels - 1:
					room = END_ROOMS[randi() % END_ROOMS.size()].instance()
				else:
					room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instance()
					if i == 1:
						room.get_node("Navigation2D/TileMap3").queue_free()
					
				var previous_room_tilemap: TileMap = previous_room.get_node("Navigation2D/TileMap")
				var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Node2D")
				var exit_tile_pos: Vector2 = previous_room_tilemap.world_to_map(previous_room_door.position) + Vector2.UP * 2
				
				var corridor_height: int = randi() % 3 + 2
				for y in corridor_height:
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-2, -y), LEFT_WALL_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-1, -y), FLOOR_TILE_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(0, -y), FLOOR_TILE_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(1, -y), RIGHT_WALL_INDEX)
					
				var room_tilemap: TileMap = room.get_node("Navigation2D/TileMap")
				room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.world_to_map(room.get_node("Entrance/Position2D2").position).x * TILE_SIZE
			
			add_child(room)
			count_enemies(room)
			previous_room = room
	else:
		num_levels = 3
		
		for i in num_levels:
			var room: Node2D
			
			if i == 0:
				room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instance()
				player.position = room.get_node("PlayerSpawnPos").position
			else:
				if i == num_levels - 1:
					room = END_ROOMS[randi() % END_ROOMS.size()].instance()
				else:
					room = BOSS_ROOMS[randi() % BOSS_ROOMS.size()].instance()
					if i == 1:
						room.get_node("Navigation2D/TileMap3").queue_free()
				
				var previous_room_tilemap: TileMap = previous_room.get_node("Navigation2D/TileMap")
				var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Node2D")
				var exit_tile_pos: Vector2 = previous_room_tilemap.world_to_map(previous_room_door.position) + Vector2.UP * 2
				
				var corridor_height: int = randi() % 3 + 2
				for y in corridor_height:
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-2, -y), LEFT_WALL_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-1, -y), FLOOR_TILE_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(0, -y), FLOOR_TILE_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(1, -y), RIGHT_WALL_INDEX)
					
				var room_tilemap: TileMap = room.get_node("Navigation2D/TileMap")
				room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.world_to_map(room.get_node("Entrance/Position2D2").position).x * TILE_SIZE
			
			add_child(room)
			previous_room = room

func count_enemies(room):
	if room.has_node("EnemyPos") or room.has_node("BossPos"):
		var enemies = room.get_node("EnemyPos").get_child_count()
		enemies_count += enemies
		Events.emit_signal("get_enemies_count", enemies_count)

func set_stats(new_stats: FloorData) -> void:
	if new_stats == stats:
		return
	stats = new_stats
