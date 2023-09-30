extends Control
@onready var item: Item
@onready var amount: int

var show_button = false
var selected_slot = false

enum item_list {
	AMOUNT,
	DESCRIPTION,
	IMAGE,
	UNIQUE_KEY,
	TYPE,
	NAME
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if item != null:
		$sprite.texture = load(item.image)
		$amount.text = str(amount)
	
	if Input.is_action_just_pressed("right_click") and selected_slot:
		show_button = !show_button
	
	$Button.disabled = !show_button
	if show_button:
		$Button.show()
	else:
		$Button.hide()


func _get_drag_data(at_position: Vector2):
	var data := {
		"sprite": $sprite.texture,
		"amount": $amount.text,
		"backup": self
	}
	
	var preview = self.duplicate()
	preview.get_node("background").hide()
	preview.get_node("amount").hide()
	#preview.get_node("sprite").get_rect().position = -preview.get_rect().size / 2
	preview.set_size(Vector2(16, 16))
	
	_set_empty_slot()
	set_drag_preview(preview)
	
	return data

func _set_empty_slot() -> void:
	$sprite.texture = null
	$amount.text = ""
	
func _can_drop_data(at_position, data) -> bool:
	return true

func _buy() -> void:
	print("Comprar")

func _drop_data(at_position: Vector2, data):	
	data.backup.get_node("sprite").texture = $sprite.texture
	data.backup.get_node("amount").text = $amount.text
	
	$sprite.texture = data.sprite
	$amount.text = data.amount


func _on_button_pressed():
	print("Comprar")
	print(item)


func _on_mouse_entered():
	selected_slot = true


func _on_mouse_exited():
	selected_slot = false
