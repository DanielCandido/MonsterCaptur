extends Node2D

@onready var player = $npc as CharacterBody2D
@onready var camera = $cam as Camera2D
@onready var _inventory_is_opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player._follow_camera(camera)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
