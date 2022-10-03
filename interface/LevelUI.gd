extends Label

var experience_required = 0

onready var player_stats = get_node("../../").get_node("YSort").get_node("Player").stats

func _process(_delta):
	update_required_experience()
	update_text(player_stats._stats.level, player_stats._stats.experience, player_stats._stats.experience_required)

func update_text(level, experience, required_exp):
	text = """Level: %s
			Experience: %s
			Next level: %s
			""" % [level, experience, required_exp]

func update_required_experience() -> void:
	experience_required = player_stats.get_required_experience(player_stats.level + 1)
