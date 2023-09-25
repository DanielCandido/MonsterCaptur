extends Area2D

var troop = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@export var collectable_data: Array = Array([
	"eagle_key",
	"Chave que abre a gaiola do Aguia Guardiã",
	"res://assets/drops/key.png",
	"",
	"",
	"Aguia guardiã"
])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if is_instance_valid(troop) and Input.is_action_just_pressed("interaction"):
		troop.inventory.send_item(collectable_data)

		if get_parent() is RigidBody2D:
			get_parent().queue_free()
			return
	
		queue_free()


func _on_body_entered(body: CharacterBody2D):
	print(body)
	if (!body.is_in_group("enemies") and body.player_id == 1):
		troop = body
