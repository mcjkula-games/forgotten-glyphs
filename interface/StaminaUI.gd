extends Label

onready var player_stats = get_node("../../").get_child(0).get_node("Player").stats

func _ready():
	update_text(player_stats.stamina)
# warning-ignore:return_value_discarded
	Events.connect("player_stamina_changed", self, "update_text")
# warning-ignore:return_value_discarded
	#Events.connect("player_health_changed", self, "update_text")

func update_text(_stamina: float):
	text = str(round(_stamina))
