extends Node2D

@onready var player = $player as CharacterBody2D
@onready var camera = $cam as Camera2D
@onready var enemy = $enemy as CharacterBody2D
@onready var battle_sound = $field_of_vision2/battle_sound as AudioStreamPlayer2D
@onready var button_restart = $restart as Button
@onready var last_position_player_x := 29.00
@onready var last_position_player_y := 253.00

# Called when the node enters the scene tree for the first time.
func _ready():
	player.follow_camera(camera)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	_player_death()
		
func _player_death():
	if player != null and player.is_death:
		battle_sound.stop()
		button_restart.disabled = false
		player.set_collision_mask_value(3, false)
		player.set_collision_mask_value(5, false)

func saveGame():
	last_position_player_x = player.global_position.x
	last_position_player_y = player.global_position.y
	player._save()

func restart():
	player.queue_free()
		
	button_restart.disabled = true
	var player_scene = preload("res://models/character/player.tscn")
	player = player_scene.instantiate() as CharacterBody2D
	player.transform.origin = Vector2(last_position_player_x, last_position_player_y)
	player.name = 'player'
	add_child(player)
	player.set_collision_mask_value(3, true)
	player.set_collision_mask_value(5, true)
	player.follow_camera(camera)

func _on_entered_boss_area(body):	
	if body.player_id == 1:
		battle_sound.play(0)

func _on_exit_boss_area(body):
	if body.player_id == 1:
		battle_sound.stop()

func _on_restart_game():
	restart()
