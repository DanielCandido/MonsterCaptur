extends Area2D

var entered_area := false;
var player_scene = preload("res://models/character/player.tscn")
var player_instance = null
var animation_player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	entered_area = true
	

func _on_body_exited(body):
	entered_area = false

func _physics_process(delta):
	if entered_area and Input.is_action_just_pressed("interaction"):
		print("Abre notificação")
		$notification.show_notification("Salvo", 3.0)		
