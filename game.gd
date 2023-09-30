extends Node2D

@onready var player = $npc as CharacterBody2D
@onready var camera = $cam as Camera2D
var _inventory_is_opened = false
var _shop_is_opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player._follow_camera(camera)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_inventory_is_opened = ProjectSettings.get_setting("inventory_is_opened")
	_shop_is_opened = ProjectSettings.get_setting("shop_is_opened")
	
	var _player_process = !_inventory_is_opened and !_shop_is_opened
	player.set_physics_process(_player_process)
	
func _open_shop():
	player._cancel_move()
	await get_tree().create_timer(1).timeout
	_shop_is_opened = true
	

func _close_shop():
	player._return_move()
	_shop_is_opened = false
