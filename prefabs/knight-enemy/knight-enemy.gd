extends CharacterBody2D


const JUMP_VELOCITY = -400.0

@onready var SPEED = 8000.00
@onready var wall_detector := $wall_detector as RayCast2D
@onready var texture = $texture as AnimatedSprite2D
@onready var damaged_sound = $texture/damaged_sound as AudioStreamPlayer2D
@onready var battle_sound = $field_of_vision/batle_sound as AudioStreamPlayer2D

var sound_battle_playing := false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 1

func _physics_process(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	wall_detector.set
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
		
	if direction == 1:
		texture.flip_h = false
	else:
		texture.flip_h = true
		
	velocity.x = direction * SPEED * delta

	move_and_slide()
	
func attack():
	texture.play("attack")
	SPEED = 0
	await get_tree().create_timer(0.5).timeout
	texture.play("walk")
	SPEED = 8000.00

func _on_area_2d_body_entered(body):
	if body.name == 'player':
		battle_sound.play(0)
		
func _on_field_of_vision_body_exited(body):
	if body.name == 'player':
		battle_sound.stop()
