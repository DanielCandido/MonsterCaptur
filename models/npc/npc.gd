extends CharacterBody2D

#player info
const _original_speed = 250.0
const JUMP_VELOCITY = -350.0
var SPEED = _original_speed
var direction = 0
var player_life = 350.00
var _attack_type
var _current_animation = "idle"
var knockback_vector := Vector2.ZERO
var total_life = 350.00

#player state
@onready var _is_death := false
@onready var animation_action := $texture as Sprite2D
var _is_attacking = false
var _is_attacked = false
var _last_direction = 0

#basic attack
var _basic_attack_damage = 80.0

#swordfire attack
var _fire_attack_damage_active = false
var _fire_attack_animation = false
var _fire_attack_cooldown_time = 0.0
var _fire_attack_cooldown_active = false
var _fire_attack_damage = 22.0

#fireball attack
var _fireball_attack_active = false
var _fireball_attack_cooldown_active = false
var _fireball_attack_cooldown_time = 0.0
var _fireball_increase_damage = 0.0
var _fireball_damage = 13.50

#squat
var _is_squatting = false

#skills
@onready var _fire_attack_cooldown := $skills/sword_fire_attack/fire_attack_cooldown as ProgressBar
@onready var _fire_attack_animation_timer := $skills/sword_fire_attack/fire_attack_animation_timer as Timer
@onready var _fireball_attack_cooldown := $skills/fireball_attack/fireball_attack_cooldown as ProgressBar
@onready var _fireball_attack_animation_timer := $skills/fireball_attack/fireball_attack_animation_timer as Timer

@onready var _attack_timer := $attack_timer as Timer
@onready var _life_bar := $skills/life_bar as ProgressBar
@onready var remote_transform := $remote as RemoteTransform2D
@onready var player_id := 1
@onready var inventory := $inventory as Node

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var enemy

#animations
var _state_machine
@export_category("Objects")
@export var _animation_tree: AnimationTree = null

var basic_attack_animation = [
	"basic_attack",
	"basic_attack_2"
]
var current_attack_index := 1 as int

func _ready():
	_state_machine = _animation_tree["parameters/playback"]
	_life_bar.max_value = player_life
	_life_bar.value = player_life

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	_life_bar.value = player_life
	
	_active_fireball_attack()
	_active_fire_attack()
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	if !_fire_attack_animation and !_is_death:
		_attack()
	
	if !_is_attacking and !_fire_attack_animation and !_is_death and !_fireball_attack_active and !_is_attacked:
		_move()
	
	if _fire_attack_cooldown_active:
		_fire_attack_cooldown_time += delta
		_cooldown("sword_fire")
		
	if _fireball_attack_cooldown_active:
		_fireball_attack_cooldown_time += delta
		_cooldown("fireball")
		
	if _fireball_attack_active and enemy != null:
		var damage = _fireball_damage + _fireball_increase_damage
		print("total_damage: " + str(damage))
		enemy._take_damage(damage)
		_fireball_increase_damage += delta * 0.004
		
	_squat()
		
	_animated()
	move_and_slide()

func _cooldown(attack_type: String):
	if attack_type == "sword_fire":
		if _fire_attack_cooldown_time > 7.0:
			_fire_attack_damage_active = false
		
		if _fire_attack_cooldown_time < _fire_attack_cooldown.max_value:
			_fire_attack_cooldown.value = _fire_attack_cooldown_time
		elif _fire_attack_cooldown.value == _fire_attack_cooldown.max_value:
			_fire_attack_cooldown_time = 0
			_fire_attack_cooldown_active = false
			
	if attack_type == "fireball":		
		if _fireball_attack_cooldown_time < _fireball_attack_cooldown.max_value:
			_fireball_attack_cooldown.value = _fireball_attack_cooldown_time
		elif _fireball_attack_cooldown.value == _fireball_attack_cooldown.max_value:
			_fireball_attack_cooldown_time = 0
			_fireball_attack_cooldown_active = false

func _cancel_move():
	direction = 0
	SPEED = 0

func _return_move():
	direction = _last_direction
	SPEED = _original_speed

func _move():
	direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		_animation_tree["parameters/idle/blend_position"].x = direction
		_animation_tree["parameters/run/blend_position"].x = direction
		_animation_tree["parameters/death/blend_position"].x = direction
		_animation_tree["parameters/basic_attack/blend_position"].x = direction
		_animation_tree["parameters/basic_attack_2/blend_position"].x = direction
		_animation_tree["parameters/fire_attack/blend_position"].x = direction
		_animation_tree["parameters/damage/blend_position"].x = direction
		_animation_tree["parameters/fireball/blend_position"].x = direction
		_animation_tree["parameters/squat/blend_position"].x = direction
		
		velocity.x = direction * SPEED
		_last_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func _attack():
	if Input.is_action_pressed("attack") and !_is_attacking:
		direction = 0
		velocity.x = 0
		_attack_timer.wait_time = 0.35
		_attack_timer.start()
		_is_attacking = true
		_attack_type = "basic_attack"
		current_attack_index = 0 if current_attack_index != 0 else 1
		
func _active_fireball_attack():
	if Input.is_action_just_pressed("fireball_attack") and !_fireball_attack_cooldown_active:
		_attack_type = "fireball"
		_fireball_attack_cooldown_active = true
		_fireball_attack_animation_timer.start()
		_fireball_attack_active = true
		direction = 0
		velocity.x = 0

func _active_fire_attack():
	_attack_type = "sword_fire"
	if Input.is_action_just_pressed("fire_attack") and !_fire_attack_animation and !_fire_attack_cooldown_active and !_is_death:
		_fire_attack_cooldown_active = true
		_fire_attack_animation = true
		_fire_attack_damage_active = true
		_fire_attack_animation_timer.start()
		direction = 0
		velocity.x = 0
		
func _squat():
	if Input.is_action_just_pressed("squat") and direction != 0 and  !_is_attacking and !_is_attacked and !_is_squatting:
		SPEED += 30
		_is_squatting = true
		await get_tree().create_timer(1).timeout
		_is_squatting = false
		SPEED = _original_speed

func _death():
	_is_death = true
	velocity.x = 0
	direction = 0
	self.set_collision_mask_value(3, false)
	await get_tree().create_timer(1.5).timeout
	set_physics_process(false)

func _damage_collision():
	player_life -= 33.5
	
	if player_life <= 0:
		_death()
	else:
		if _last_direction > 0:
			var force = Vector2(-300, -300)
			_knockback(force, 0.25)
		elif _last_direction < 0:
			var force = Vector2(300, -300)
			_knockback(force, 0.25)
		_is_attacked = true
		await get_tree().create_timer(1).timeout
		_is_attacked = false

func _knockback(knockback_force := Vector2.ZERO, duration := 0.25) -> void:
	knockback_vector = knockback_force
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.tween_property(self, 'knockback_vector', Vector2.ZERO, duration)
		animation_action.modulate = Color(1,0,0,1)
		knockback_tween.tween_property(animation_action, "modulate", Color(1,1,1,1), duration)


func _animated():
	if _is_death == true:
		_state_machine.travel("death")
		return
		
	if _is_squatting:
		_state_machine.travel("squat")
		return

	if _is_attacked:
		_state_machine.travel("damage")
		return

	if _fire_attack_animation:
		_state_machine.travel("fire_attack")
		return
		
	if _fireball_attack_active:
		_state_machine.travel("fireball")
		return
	
	if _is_attacking:
		_state_machine.travel(basic_attack_animation[current_attack_index])
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

func _recovery_hp(hp: float):
	player_life += hp
	_life_bar.value = player_life

func _on_attack_timer_timeout():
	_is_attacking = false
	_attack_type = null

func _on_attack_area_body_entered(body: Node2D):	
	if body.is_in_group("enemies"):
		var total_attack = _basic_attack_damage
		
		if _fire_attack_damage_active:
			total_attack += _fire_attack_damage

		print("dano causado " + str(total_attack))
		
		body._take_damage(total_attack)

func _on_fire_attack_animation_timer_timeout():
	_fire_attack_animation = false
	_attack_type = null

func _on_fireball_attack_animation_timer_timeout():
	_fireball_attack_active = false
	_attack_type = null
	_fireball_increase_damage = 0.0
	enemy = null

func _on_fireball_area_body_entered(body):
	if body.is_in_group("enemies"):
		enemy = body
 
func _on_fireball_area_body_exited(body):
	if body.is_in_group("enemies"):
		enemy = null
