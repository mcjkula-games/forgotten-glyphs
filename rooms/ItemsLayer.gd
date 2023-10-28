extends Node2D

var item_count = 0

var timer

func _process(_delta):
	var children = self.get_child_count()
	if children > item_count:
		item_count += children - item_count
		
		var new_count = (children - 1)
		var newest_item = get_child(new_count)
		timer = Timer.new()
		
		newest_item.add_child(timer)
		timer.one_shot = true
		timer.wait_time = 600.0
		timer.connect("timeout", self, "_timeout", [newest_item])
		timer.start()
		
	if children < item_count:
		item_count -= -(children - item_count)

func _timeout(item) -> void:
	item.queue_free()
