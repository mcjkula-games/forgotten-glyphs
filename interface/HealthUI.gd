extends Label

#onready var player_stats = get_node("../../").get_node("YSort").get_node("Player").stats

#func _ready():
# warning-ignore:return_value_discarded
#	Events.connect("player_health_changed", self, "update_text")

#func update_text(_health: int):
#	text = str(_health) + " / " + str(player_stats.max_health)
