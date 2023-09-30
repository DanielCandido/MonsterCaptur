extends Node2D

@onready var sound := $sound as AudioStreamPlayer2D
@onready var sound_button := $SoundButton as Button

var _is_sound = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	play()

func play():
	if _is_sound and !sound.playing:		
		sound.volume_db = -10.0
		sound.play()
		
		if sound.finished:
			sound.play()
	elif !_is_sound: 
		sound.stop()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_sound_button_pressed():
	_is_sound = !_is_sound
