extends CanvasLayer

var stats: CharacterStats setget set_stats

var ignore_value_change := false
var experience_required = 0

onready var health_label := $Health
onready var stamina_label := $Stamina
onready var fps_label := $FPS
onready var level_label := $Level

func _ready():
# warning-ignore:return_value_discarded
	Events.connect("player_health_changed", self, "update_health_label")
# warning-ignore:return_value_discarded
	Events.connect("player_stamina_changed", self, "update_stamina_label")

# warning-ignore:unused_argument
func _process(delta):
	if stats:
		update_required_experience()
		update_level_l(stats.level, stats.experience, experience_required)
	
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func set_stats(new_stats: CharacterStats) -> void:
	stats = new_stats
	ignore_value_change = true

	update_health_label(new_stats.max_health)
	update_required_experience()
	update_level_l(new_stats.level, new_stats.experience, experience_required)
	update_stamina_label(new_stats.stamina)

	ignore_value_change = false

func update_health_label(_health: int):
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
