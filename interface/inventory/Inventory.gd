class_name Inventory
extends Resource

signal items_changed(indexes)

var drag_data = null

const Item = preload("res://items/Item.gd")

export(Array, Resource) var items := [] setget set_items

func init_item(item_index, item):
	var previousItem = items[item_index]
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	return previousItem

func swap_items(item_index, target_item_index):
	var targetItem = items[target_item_index]
	var item = items[item_index]
	items[target_item_index] = item
	items[item_index] = targetItem
	emit_signal("items_changed", [item_index, target_item_index])

func remove_item(item_index):
	var previousItem = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previousItem

func make_items_unique():
	var unique_items = []
	for item in items:
		if item is Item:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	items = unique_items

func save() -> void:
# warning-ignore:return_value_discarded
	ResourceSaver.save(get_save_path(), self)

func get_save_path() -> String:
	return resource_path.get_base_dir().plus_file("inventory.tres")

func set_items(new_items: Array) -> void:
	for index in new_items.size():
		var item = new_items[index]
		assert(item == null or item is Item, "Item %s is not an instance of InventoryItem"%[index])
	items = new_items
