extends Area2D

var troop = null
const Item = preload("res://dictionary/item.gd")
const ItemData = preload("res://dictionary/items_dictionary.gd")

var collectable_data

# Called when the node enters the scene tree for the first time.
func _ready():
	collectable_data = ItemData.new().all_items["eagle_key"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(troop) and Input.is_action_just_pressed("interaction"):
		troop.inventory.send_item(collectable_data)

		if get_parent() is RigidBody2D:
			get_parent().queue_free()
			return
	
		queue_free()


func _on_body_entered(body: CharacterBody2D):
	print(body)
	if (!body.is_in_group("enemies") and body.player_id == 1):
		troop = body
