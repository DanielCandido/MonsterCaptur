extends CharacterBody2D

const SPEED = 200.0
const JUMP_FORCE = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_life := 100
var direction
var knockback_vector := Vector2.ZERO
var is_saving := false
var is_jumping := false
var is_attacking := false
var is_deathing := false

@onready var is_death := false
@onready var animation_action := $animation as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var ray_left := $ray_left as RayCast2D
@onready var ray_right := $ray_right as RayCast2D
@onready var kick_sound := $kick_sound as AudioStreamPlayer2D
@onready var collision := $collision as CollisionShape2D
@onready var hurtbox := $hurtbox as Area2D
@onready var basic_attack := $attack_area/basic_attack as CollisionShape2D

@onready var _attack_timer := $attack_timer as Timer
@onready var _death_timer := $death_timer as Timer
@onready var _save_timer := $save_timer as Timer
@onready var player_id := 1

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !is_death and !is_saving:
		_basic_attack()
		_move()
		_jump()
		_knockback()
		
	_set_state()
		
	move_and_slide()

func _basic_attack() -> void:
	if Input.is_action_just_pressed("attack") and is_attacking == false:
		set_physics_process(false)
		is_attacking = true
		_attack_timer.start()
		kick_sound.play(0)
		basic_attack.transform.x = Vector2(3, 0)
		await get_tree().create_timer(0.5).timeout
		basic_attack.transform.x = Vector2(1, 0)

func _move() -> void:
	direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
		animation_action.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func _jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

func _knockback() -> void:
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

func _save():
	_save_timer.start()
	is_saving = true
	player_life = 100

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if !is_death:
			body.attack()
			if ray_left.is_colliding():
				take_damage(Vector2(200, -200), 0.25, 13)
			if ray_right.is_colliding():
				take_damage(Vector2(-200, -200), 0.25, 13)
		else:
			body.battle_sound.stop()
		
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
	
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25, damage:= 0.0):
	player_life -= damage
	print(player_life)
	
	if player_life <= 0:
		is_deathing = true
		_death_timer.start()
		
	elif knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.tween_property(self, 'knockback_vector', Vector2.ZERO, duration)
		animation_action.modulate = Color(1,0,0,1)
		knockback_tween.tween_property(animation_action, "modulate", Color(1,1,1,1), duration)
	
func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
	
	if is_attacking:
		state = "basic_attack"
		
	if is_deathing:
		state = "deathing"
		
	if is_death:
		state = "death"
		
	if is_saving:
		state = "sleep"
		
	if is_saving:
		state = "sleep"
	
	if animation_action.name != state:
		animation_action.play(state)

func _on_attack_timer_timeout():	
	is_attacking = false
	set_physics_process(true)

func _on_death_timer_timeout():
	set_physics_process(true)
	is_deathing = false
	is_death = true

func _on_save_timer_timeout():
	is_saving = false
