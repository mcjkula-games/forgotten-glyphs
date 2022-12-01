extends Sprite

func _ready():
# warning-ignore:return_value_discarded
	$Tween.connect("tween_completed", self, "_on_Tween_completed")
	
	$Tween.interpolate_property(self, "modulate:a", 0.5, 0.0, 0.5, 3, 1)
	$Tween.start()

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Tween_completed(object: Object, key: NodePath) -> void:
	queue_free()
