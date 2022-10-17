class_name CharacterStats
extends Resource

# The health property uses a setter to ensure that it never goes above
# max_health or below 0.
export var max_health := 50 setget set_max_health
var health = max_health setget set_health

export(int) var level = 1

export var experience_total = 0
export var experience = 0
export var experience_required = 0 setget get_required_experience

var stamina = 100.0 setget set_current_stamina

func _init():
# warning-ignore:return_value_discarded
	Events.connect("mob_died", self, "gain_experience")
# warning-ignore:return_value_discarded
	Events.connect("experience_collected", self, "gain_experience")

	update_stats()

func save() -> void:
# warning-ignore:return_value_discarded
	ResourceSaver.save(resource_path, self)

func set_max_health(new_max_health: int) -> void:
	max_health = new_max_health
	save()

# Health setter, we make sure health is always between 0 and max
func set_health(new_health: int) -> void:
# warning-ignore:narrowing_conversion
	health = clamp(new_health, 0, max_health)
	Events.emit_signal("player_health_changed", health)

func update_max_health() -> void:
	max_health = max_health
	set_health(max_health)

func max_health_changer(new_max_health: int) -> void:
	max_health = new_max_health
	set_max_health(max_health)

func get_required_experience(lvl: int):
	return round(pow(lvl, 1.8) + lvl * 4)

func level_up():
	level += 1
	experience_required = get_required_experience(level + 1)
	Events.emit_signal("player_level_up")
	
	# For each level up we add 25% health based on the current_health
	max_health = max_health + (max_health * (0.2 / (level / 2)))
	update_max_health()

func gain_experience(amount):
	experience_total += amount
	experience += amount
	while experience >= experience_required:
		experience -= experience_required
		level_up()
	save()

func set_current_stamina(_stamina: float) -> void:
	stamina = _stamina
	Events.emit_signal("player_stamina_changed", stamina)

func update_stats() -> void:
	experience_required = get_required_experience(level + 1)
