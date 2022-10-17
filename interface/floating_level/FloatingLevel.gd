extends Position2D

onready var label = get_node("Label")
onready var tween = get_node("Tween")
var input = "LEVEL UP!"

var velocity = Vector2(0, 0)
var max_size = Vector2(1.5, 1.5)

func _ready():
	label.set_text(input)

	velocity = Vector2(0, 25)
	tween.interpolate_property(self, "scale", scale, max_size, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "scale", max_size, Vector2(0.1, 0.1), 0.001, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4)
	tween.start()

func _on_Tween_tween_all_completed():
	self.queue_free()
	
func _process(delta):
	position -= velocity * delta
