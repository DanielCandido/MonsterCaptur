extends Node2D

@export var x := 0.0 as float
@export var y := 0.0 as float
@onready var vision := $vision as RayCast2D
@onready var battle_sound := $batle_sound as AudioStreamPlayer2D

var starting := false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	vision.target_position.x = x
	vision.target_position.y = y
	
	if vision.is_colliding() and !starting:
		print("play")
		battle_sound.play(0)
	elif !vision.is_colliding():
		battle_sound.stop()
		
