extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1
var _state_machine
var _is_attacked = false
var _is_death = false

@onready var _wall_detector := $wall_detector as RayCast2D
@onready var _damage_timer := $damage_timer as Timer
@onready var _death_timer := $death_timer as Timer
@onready var _hurtbox := $collision_hurtbox as CollisionObject2D

# Info skeleton
@export var enemy_level = 6
var total_life = 3500.00
var total_attack = 35
var enemy_life
var basic_attack
var total_exp = 300
const SPEED = 88.0
const JUMP_VELOCITY = -400.0
var last_direction = 0

#Drop key
var drop_key = preload("res://prefabs/drops/eagle_key/eagle_key.tscn")

@export_category("Objects")
@export var _animation_tree: AnimationTree = null

func  _ready():
	enemy_life = total_life + enemy_level * 3.75
	basic_attack = total_attack + enemy_level * 0.85
	_state_machine = _animation_tree["parameters/playback"]

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = direction * SPEED * delta
	
	if !_is_attacked and !_is_death:
		_move()
		_wall()
	
	_animated()

	move_and_slide()

func _move():	
	if direction != 0:
		last_direction = direction
		_animation_tree["parameters/walk/blend_position"].x = direction
		_animation_tree["parameters/damage/blend_position"].x = direction
		_animation_tree["parameters/death/blend_position"].x = direction
		
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func _wall():
	_wall_detector.set
	if _wall_detector.is_colliding():
		var dir = direction + direction * -1
		direction *= -1
		_wall_detector.scale.x *= -1

func _take_damage(damage = 0.0):
	enemy_life -= damage
	direction = 0
	velocity.x = 0
	if (enemy_life > 0):
		_is_attacked = true
		_damage_timer.start()
		await get_tree().create_timer(0.8).timeout
#		print("enemy_life: " + str(enemy_life) + " direction: " + str(last_direction))	
		direction = last_direction
		velocity.x = direction * SPEED
	elif !_is_death:
		_death()
		
func _death():
	_is_death = true
	_spawn_item()
	_death_timer.start()
		
func _spawn_item() -> void:
	var sceneItem = drop_key.instantiate() as Area2D	
	sceneItem.transform.origin = Vector2(self.global_position.x, self.global_position.y)	
	owner.add_child(sceneItem)

func _animated():
	if _is_death:
		_state_machine.travel("death")
		return
	
	if _is_attacked:
		_state_machine.travel("damage")
		return
	
	if direction != 0:
		_state_machine.travel("walk")
		return

func _on_damage_timer_timeout():
	_is_attacked = false	
	


func _on_death_timer_timeout():
	queue_free()


func _on_hitbox_body_entered(body):
	if (body.player_id == 1):
		body._damage_collision()
