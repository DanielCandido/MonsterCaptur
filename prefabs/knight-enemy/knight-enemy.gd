extends CharacterBody2D


const JUMP_VELOCITY = -400.0
var enemy_level = 6
var total_life = 400
var enemy_life

@onready var SPEED = 8000.00
@onready var wall_detector := $wall_detector as RayCast2D
@onready var texture = $texture as AnimatedSprite2D
@onready var damaged_sound = $texture/damaged_sound as AudioStreamPlayer2D
@onready var battle_sound = $field_of_vision/batle_sound as AudioStreamPlayer2D
@onready var collision = $hitbox/hitbox as CollisionShape2D
@onready var _damage_timer = $damage_timer as Timer

var sound_battle_playing := false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 1

func _ready():
	enemy_life = total_life + enemy_level * 3.75

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
	
	_death()

	move_and_slide()
	
func attack():
	texture.play("attack")
	collision.transform.x = Vector2(1.4, 0)
	SPEED = 0
	await get_tree().create_timer(0.5).timeout
	collision.transform.x = Vector2(1, 0)
	texture.play("walk")
	SPEED = 8000.00

func _death():
	if enemy_life <= 0:
		texture.play("death")

func _take_damage(_damage = 0.0):
	_damage_timer.start()
	damaged_sound.play(0)
	texture.play("damage")
	enemy_life -= _damage
	print(enemy_life)
	set_physics_process(false)
	

func _on_damage_timer_timeout():
	damaged_sound.stop()
	texture.play("walk")
	set_physics_process(true)
	
