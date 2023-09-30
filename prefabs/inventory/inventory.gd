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
	

func send_item(item: Item):
	_inventory_list.append(item)
	var slot = get_node("Container/slot1")
	slot.item = item
	slot.amount = 4
	
func update_slot(slot_index: int, new_amount: int) -> void:
	_inventory_list[slot_index][item_list.AMOUNT] = new_amount
	get_tree().call_group("inventory", "update_item_slot", slot_index, new_amount)
	
func delete_slot(slot_index: int) -> void:
	_inventory_list.remove_at(slot_index)
	get_tree().call_group("inventory", "delete_inventory_slot", slot_index)

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
