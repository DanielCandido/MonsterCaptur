extends CharacterBody2D

var _state_machine
const SPEED = 250.0
const JUMP_VELOCITY = -350.0
var _is_attacking = false
var _attack_type

@onready var _attack_timer := $attack_timer as Timer
@onready var _is_death := false
@onready var remote_transform := $remote as RemoteTransform2D
@onready var player_id := 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export_category("Objects")
@export var _animation_tree: AnimationTree = null

func _ready():
	_state_machine = _animation_tree["parameters/playback"]

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	_attack()
	_move()
	_animated()
	move_and_slide()
	
func _move():
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		_animation_tree["parameters/idle/blend_position"].x = direction
		_animation_tree["parameters/run/blend_position"].x = direction
		_animation_tree["parameters/death/blend_position"].x = direction
		_animation_tree["parameters/basic_attack/blend_position"].x = direction
		
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func _attack():
	if Input.is_action_pressed("attack") and !_is_attacking:
		set_physics_process(false)
		_attack_timer.wait_time = 0.35
		_attack_timer.start()
		_is_attacking = true
		_attack_type = "basic_attack"
		
func _death():
	_is_death = true
		
func _animated():
	if _is_death == true:
		_state_machine.travel("death")
		return
		
	if _is_attacking:
		_state_machine.travel(_attack_type)
		return
	
	if velocity.y < 0:
		_state_machine.travel("jump")
		return
	
	if velocity.x > 1 or velocity.x < 0:
		_state_machine.travel("run")
		return
	
	_state_machine.travel("idle")
	
func _follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path


func _on_attack_timer_timeout():
	_is_attacking = false
	_attack_type = null
	set_physics_process(true)


func _on_attack_area_body_entered(body: Node2D):
	if body.is_in_group("enemies"):
		body._take_damage(80.5)
