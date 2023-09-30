extends Control
@export var itemPath = ""
@export var amountValue = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$sprite.texture = load(itemPath)
	$amount.text = amountValue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
	
func _drop_data(at_position: Vector2, data):	
	data.backup.get_node("sprite").texture = $sprite
	data.backup.get_node("amount").text = $amount.text
	
	$sprite.texture = data.sprite
	$amount.text = data.amount
	
