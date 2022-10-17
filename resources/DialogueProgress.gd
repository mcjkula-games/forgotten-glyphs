class_name DialogueProgress
extends Resource

export var already_interact = false
export var much_interact = false

func _init():
	pass
# warning-ignore:return_value_discarded
	#Events.connect("save_dialogue_p", self, "save")

func save() -> void:
# warning-ignore:return_value_discarded
	ResourceSaver.save(resource_path, self)
