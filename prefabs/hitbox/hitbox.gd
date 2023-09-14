extends Area2D



func _on_body_entered(body: Node2D) -> void:	
	print(body.name)
	if body.name == 'player':		
		owner.texture.play("damage")
		owner.SPEED = 0
		await get_tree().create_timer(0.5).timeout		
		owner.texture.play("walk")
		owner.SPEED = 8000
