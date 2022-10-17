extends InteractionManager

onready var dialogueint = get_parent().get_node("DialogueInterface")
onready var label = get_parent().get_node("Label")

# warning-ignore:unused_argument
func _physics_process(delta):
	if current_interaction != null and not dialogueint.interact:
		label.visible = true
	else:
		label.visible = false

func recieve_interaction() -> void:
	if not dialogueint.text_streaming:
		dialogueint.play()
	else:
		dialogueint.speed_up()
