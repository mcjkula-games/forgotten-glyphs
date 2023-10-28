extends Pickup

var floating_text = preload("res://interface/floating_text/FloatingText.tscn")

var item_name
var p_i_range

func _ready() -> void:
	item_name = "Potion"

func _process(_delta):
	if p_i_range:
		if Input.is_action_just_pressed("pickup"):
			#PlayerInventory.add_item(item_name, 1)
			queue_free()
	else:
		pass
	

func _on_player_pickup(_player: Player) -> void:
	p_i_range = true

func _on_player_left(_player: Player) -> void:
	p_i_range = false
