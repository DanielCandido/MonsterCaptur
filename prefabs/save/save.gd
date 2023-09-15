extends Area2D

var entered_area := false;

@onready var sound_fire := $fire/sound_fire as AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sound_fire.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if (body.name == 'player'):
		entered_area = true
		sound_fire.volume_db = 1.5
		sound_fire.play(0)
	

func _on_body_exited(body):
	if (body.name == 'player'):
		entered_area = false
		sound_fire.stop()

func _physics_process(delta):
	if entered_area and Input.is_action_just_pressed("interaction"):
		$notification.show_notification("Jogo Salvo", 3.0)
