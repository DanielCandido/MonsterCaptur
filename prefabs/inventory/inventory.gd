extends Node

@onready var grid := $layer/texture/container/grid as GridContainer
@onready var layer := $layer as CanvasLayer

var _inventory_opened = false

enum item_list {
	AMOUNT,
	DESCRIPTION,
	IMAGE,
	UNIQUE_KEY,
	TYPE,
	NAME
}

var _inventory_list: Array

func _process(delta):
	pass

func send_item(list: Array):
	var new_list: Array = list.duplicate(true)
	
	for i in _inventory_list.size():
		if _inventory_list[i][item_list.NAME] == new_list[item_list.NAME]:
			if _inventory_list[i][item_list.AMOUNT] < 9:
				_inventory_list[i][item_list.AMOUNT] += 1
				get_tree().call_group("inventory", "update_item_slot", i, _inventory_list[i][item_list.AMOUNT])
				return
	
	_inventory_list.append(new_list)
	get_tree().call_group("inventory", "create_item_slot", new_list)
	var item = TextureRect.new()
	var image_path = list[item_list.IMAGE] as String
	item.name = list[item_list.NAME]
	item.texture = load(list[item_list.IMAGE])
	item.tooltip_text = list[item_list.NAME] + "\n" + list[item_list.DESCRIPTION]
	item.custom_minimum_size.x = 30
	item.custom_minimum_size.y = 30
	item.set_global_position(Vector2(10, 10))
	item.position.y = 10
	grid.add_child(item)
	
func update_slot(slot_index: int, new_amount: int) -> void:
	_inventory_list[slot_index][item_list.AMOUNT] = new_amount
	get_tree().call_group("inventory", "update_item_slot", slot_index, new_amount)
	
func delete_slot(slot_index: int) -> void:
	_inventory_list.remove_at(slot_index)
	get_tree().call_group("inventory", "delete_inventory_slot", slot_index)

func show_inventory(position := Vector2.ZERO):
	layer.visible = !layer.visible
	print(position)
	layer.transform.origin.x = position[0] - 107
	layer.transform.origin.y = position[1] - 135

func _on_visibility_changed():
	print("Changed visibility " + str(self.visible))
