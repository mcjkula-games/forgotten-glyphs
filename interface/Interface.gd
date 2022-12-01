extends CanvasLayer

var stats: CharacterStats setget set_stats
var floor_data: FloorData setget set_floor

var ignore_value_change := false
var experience_required = 0

onready var health_label := $Health
onready var stamina_label := $Stamina
onready var fps_label := $FPS
onready var level_label := $Level
onready var floor_label := $Floor
onready var diff_label := $Difficulty
onready var enemies_label := $Enemies setget update_enemies_count
onready var vignette := $ColorRect

func _ready():
# warning-ignore:return_value_discarded
	Events.connect("player_health_changed", self, "update_health_label")
# warning-ignore:return_value_discarded
	Events.connect("player_stamina_changed", self, "update_stamina_label")
# warning-ignore:return_value_discarded
	Events.connect("current_floor_changed", self, "update_current_floor")
# warning-ignore:return_value_discarded
	Events.connect("enemies_diff_changed", self, "update_enemies_diff")
# warning-ignore:return_value_discarded
	Events.connect("get_enemies_count", self, "update_enemies_count")
	
	vignette.visible = true

# warning-ignore:unused_argument
func _process(delta):
	if stats:
		update_required_experience()
		update_level_l(stats.level, stats.experience, experience_required)
	
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func set_stats(new_stats: CharacterStats) -> void:
	stats = new_stats
	ignore_value_change = true

	update_health_label(new_stats.health)
	update_required_experience()
	update_level_l(new_stats.level, new_stats.experience, experience_required)
	update_stamina_label(new_stats.stamina)

	ignore_value_change = false

func set_floor(new_stats: FloorData) -> void:
	floor_data = new_stats
	ignore_value_change = true

	update_current_floor(new_stats.current_floor)
	update_enemies_diff(new_stats.enemies_diff)

	ignore_value_change = false

func update_health_label(_health: int):
	yield(get_tree().create_timer(0.1), "timeout")
	health_label.text = str(_health) + " / " + str(stats.max_health)

func update_stamina_label(_stamina: float):
	stamina_label.text = str(round(_stamina))

func update_level_l(level, experience, required_exp):
	level_label.text = """Level: %s
			Experience: %s
			Next level: %s
			""" % [level, experience, required_exp]

func update_required_experience() -> void:
	experience_required = stats.get_required_experience(stats.level + 1)


func update_current_floor(current_floor) -> void:
	floor_label.text = "Floor: " + str(current_floor)

func update_enemies_diff(enemies_diff) -> void:
	diff_label.text = "Difficulty: " + str(enemies_diff)

func update_enemies_count(enemies_count) -> void:
	enemies_label.text = "Enemies: " + str(enemies_count)
