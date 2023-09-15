extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jump := false
var saving := false
var attacking := false
var player_life := 100
var knockback_vector := Vector2.ZERO

@onready var animation_action := $animation as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var ray_left := $ray_left as RayCast2D
@onready var ray_right := $ray_right as RayCast2D
@onready var kick_sound := $kick_sound as AudioStreamPlayer2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("interaction"):
		saving = true
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jump = true
	elif is_on_floor():
		is_jump = false	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	if Input.is_action_just_pressed("attack"):
		attacking = true
		await get_tree().create_timer(0.3).timeout
		attacking = false
	
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if saving:
		animation_action.play("sleep")
		player_life = 100
		await get_tree().create_timer(3).timeout
		saving = false
	elif attacking:
		kick_sound.play(0)
		animation_action.play("attacking")
	elif direction:
		velocity.x = direction * SPEED
		animation_action.play("run")
		animation_action.scale.x = direction
		if !is_jump:
			animation_action.play("run")
	elif is_jump:
		animation_action.play("jump")
	else:		
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation_action.play("idle")

	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		
	move_and_slide()
	
func animation_save(anime: bool):
	saving = anime


func _on_hurtbox_body_entered(body: Node2D) -> void:	
#	if body.is_in_group("enemies"):
#		queue_free()
	if body.is_in_group("enemies"):
		body.attack()
		await get_tree().create_timer(0.5).timeout
		if player_life < 0:
			queue_free()
		else:
			if ray_left.is_colliding():
				take_damage(Vector2(200, -200), 0.25, 13)
			if ray_right.is_colliding():
				take_damage(Vector2(-200, -200), 0.25, 13)
		
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
	
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25, damage:= 0.0):
	player_life -= damage
	print(player_life)
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.tween_property(self, 'knockback_vector', Vector2.ZERO, duration)
		animation_action.modulate = Color(1,0,0,1)
		knockback_tween.tween_property(animation_action, "modulate", Color(1,1,1,1), duration)
