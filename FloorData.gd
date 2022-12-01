class_name FloorData
extends Resource

export(int) var current_floor = 1
export(int) var enemies_diff = 1

func _init():
# warning-ignore:return_value_discarded
	pass

func upgrade_floor(amount):
	current_floor += amount
	Events.emit_signal("current_floor_changed", current_floor)
	save()

func upgrade_enemies(amount):
	enemies_diff += amount
	Events.emit_signal("enemies_diff_changed", enemies_diff)
	save()

func save() -> void:
# warning-ignore:return_value_discarded
	ResourceSaver.save(resource_path, self)
