# ANCHOR: class_name
class_name Spawner
extends Sprite
# END: class_name

# List of possible scenes to spawn
# ANCHOR: list_variable
export(Array, PackedScene) var list := []
# END: list_variable

# A percentage of spawning chance
export(int, 0, 100) var spawning_chance := 100

onready var parent := get_node("../")

# ANCHOR: ready
func _ready() -> void:
	# we hide the spawner in the running game
	texture = null
# END: ready


# ANCHOR: spawn_function
# ANCHOR: spawn_definition
func spawn() -> void:
# END: spawn_definition
	# ANCHOR: spawn_list_return
	if not list:
			return
	# END: spawn_list_return

	# ANCHOR: spawn_will_spawn
	# Check the percentage chance. `rand_range()` returns a number. If that
		# number is greater than spawning_chance, then we return and don't spawn
		# anything.
	var will_spawn := rand_range(0, 99) < spawning_chance
	if not will_spawn:
		return
	# END: spawn_will_spawn

	# ANCHOR: spawn_get_random_scene
	# Get a random scene resource from the list array.
	var random_scene_index := randi() % list.size()
	var scene: PackedScene = list[random_scene_index]
	# END: spawn_get_random_scene
	# ANCHOR: spawn_ensure_scene_valid
	# The array might have holes. We need to make sure we got an item.
	if not scene:
		return
	var node: Node2D = scene.instance()
	# END: spawn_ensure_scene_valid

	# ANCHOR: spawn_and_place
	parent.add_child(node)
	node.global_position = global_position
	# END: spawn_and_place
# END: spawn_function
