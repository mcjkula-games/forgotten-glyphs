extends Position2D

onready var label = get_node("Label")
onready var tween = get_node("Tween")
var type = ""
var amount = 0

var velocity = Vector2(0, 0)
var max_size = Vector2(1, 1)

func _ready():
	label.set_text(str(amount))
	match type:
		"Full Health":
			label.set("custom_colors/font_color", Color(0.921875, 0.921875, 0.921875))
			label.set_text("Full Health!")
		"Heal":
			label.set("custom_colors/font_color", Color(0.186207, 0.828125, 0.181152))
		"Damage":
			label.set("custom_colors/font_color", Color(0.921875, 0.921875, 0.921875))
		"Critical":
			max_size = Vector2(1.5, 1.5)
			label.set("custom_colors/font_color", Color(0.894531, 0.150253, 0.150253))

	randomize()
	var side_movement = randi() % 81 - 40
	velocity = Vector2(side_movement, 20)
	tween.interpolate_property(self, "scale", scale, max_size, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "scale", max_size, Vector2(0.1, 0.1), 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
	tween.start()

func _on_Tween_tween_all_completed():
	self.queue_free()
	
func _process(delta):
	position -= velocity * delta
