extends Label

# warning-ignore:unused_argument
func _process(delta):
		self.text = "FPS: " + str(Engine.get_frames_per_second())
