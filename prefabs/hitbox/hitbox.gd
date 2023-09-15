extends Area2D

var total_life := 600.00

func _on_body_entered(body: Node2D) -> void:
	if body.name == 'player':
		take_damage(Vector2(200, -200), 0.25, 100)
		


func take_damage(knockback_force := Vector2.ZERO, duration := 0.25, damage:= 0.0):
	owner.damaged_sound.play(0)
	total_life -= damage
	print(total_life)
	
	if total_life <= 0:
		owner.SPEED = 0
		owner.texture.play("death")
		await get_tree().create_timer(0.8).timeout
		owner.queue_free()
	else:
		owner.texture.play("damage")
		owner.SPEED = 0
		await get_tree().create_timer(0.3).timeout
		owner.texture.play("walk")
		owner.SPEED = 8000
