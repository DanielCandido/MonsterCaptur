extends Node

enum item_list {
	AMOUNT,
	a,
	b,
	c,
	d,
	NAME
}

var _inventory_list: Array

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
	
func update_slot(slot_index: int, new_amount: int) -> void:
	_inventory_list[slot_index][item_list.AMOUNT] = new_amount
	get_tree().call_group("inventory", "update_item_slot", slot_index, new_amount)
	
func delete_slot(slot_index: int) -> void:
	_inventory_list.remove_at(slot_index)
	get_tree().call_group("inventory", "delete_inventory_slot", slot_index)
