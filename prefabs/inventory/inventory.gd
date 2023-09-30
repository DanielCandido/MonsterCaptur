extends Node

@onready var grid := $layer/texture/container/grid as GridContainer
@onready var layer := $layer as CanvasLayer

const Item = preload("res://dictionary/item.gd")

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
	show_inventory()
	hide_inventory()
	

func send_item(item: Item, amount: int = 1):
	var exist_item = exist_in_inventory(item.id)
	if (exist_item > -1):
		var slot = get_node("Container/slot" + str(exist_item + 1))
		var item_inventory = _inventory_list[exist_item]
		item_inventory["amount"] += 1
		slot.amount = item_inventory["amount"]
	else:
		var slot_empty = exist_slot_empty()
		if slot_empty > -1:
			item['amount'] = amount
			_inventory_list.append(item)
			var slot = get_node("Container/slot" + str(slot_empty + 1))
			slot.item = item
			slot.amount = item["amount"]
		else:
			print("Inventário cheio")
	
func exist_in_inventory(id: int):
	var _index = -1
	var _currentIndex = 0
	for item in _inventory_list:
		if item.id == id:
			_index = _currentIndex
			break
		_currentIndex += 1
	
	return _index
	
func exist_slot_empty():
	var _index = -1
	var total_items = _inventory_list.size()
	if total_items < 18:
		_index = total_items
		
	return _index
		
func update_slot(slot_index: int, new_amount: int) -> void:
	_inventory_list[slot_index]['amount'] = new_amount
	var slotName = "Container/slot" + str(slot_index + 1)
	var slot = get_node(slotName)	
	slot.amount = new_amount
	slot.show_button = false
	
func delete_slot(slot_index: int) -> void:
	_inventory_list.remove_at(slot_index)
	var slotName = "Container/slot" + str(slot_index + 1)
	var slot = get_node(slotName)
	slot.item = null
	slot.amount = 0
	slot.show_button = false
	
func hide_inventory():
	if Input.is_action_just_pressed("cancel"):
		$bgColor.hide()
		$Container.hide()
		ProjectSettings.set_setting("inventory_is_opened", false)

func show_inventory():
	if Input.is_action_just_pressed("inventory"):
		$bgColor.show()
		$Container.show()
		ProjectSettings.set_setting("inventory_is_opened", true)

func _on_visibility_changed():
	print("Changed visibility " + str(self.visible))

func _get_current_slot(item: Item):
	var idx = 0
	for it in _inventory_list:
		if it.id == item.id:
			break
		idx += 1
	
	return idx

func _use_item(item: Item):
	if item.type == item.TYPES.POTION:
		if owner.is_in_group("player"):
			owner._recovery_hp(item.value)
			item.amount -= 1
			var current_slot = _get_current_slot(item)
			if item.amount == 0:
				delete_slot(current_slot)
			else:				
				update_slot(current_slot, item.amount)
