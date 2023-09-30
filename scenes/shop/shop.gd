extends Node2D

@onready var _animation := $AnimationPlayer as AnimationPlayer
@onready var _welcome_audio := $welcome as AudioStreamPlayer2D
@onready var _see_you_later_audio := $seeYouLater as AudioStreamPlayer2D
var _body_player
var _entered_area = false
var _shop_is_opened = false
const Item = preload("res://dictionary/item.gd")
const ItemData = preload("res://dictionary/items_dictionary.gd")

var items

# Called when the node enters the scene tree for the first time.
func _ready():
	_animation.play("shop")
	items = ItemData.new().shop_items
	var idx = 0
	for key in items:
		idx += 1
		var slot = get_node("Container/slot" + str(idx))
		var currentItem = items[key]
		currentItem.amount = 999
		slot.item = currentItem

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_show_shop()
	_close_shop()

func _show_shop():
	if _entered_area and _body_player != null and !_shop_is_opened and Input.is_action_just_pressed("interaction"):
		_welcome_audio.play()
		owner._open_shop()
		$bgColor.show()
		$Container.show()
		_shop_is_opened = true
		ProjectSettings.set_setting("shop_is_opened", true)

func _close_shop():
	if _entered_area and _body_player != null and _shop_is_opened and Input.is_action_just_pressed("cancel"):
		_see_you_later_audio.play()
		owner._close_shop()
		$bgColor.hide()
		$Container.hide()
		_shop_is_opened = false
		ProjectSettings.set_setting("shop_is_opened", false)
		
func _buy(item: Item, amount: int = 1) -> void:
	if owner.name == 'world':
		owner.player.inventory.send_item(item, amount)
	
func _on_area_body_entered(body):	
	if body.is_in_group("player"):
		_body_player = body
		_entered_area = true


func _on_area_body_exited(body):
	if body.is_in_group("player"):
		_body_player = null
		_entered_area = false
