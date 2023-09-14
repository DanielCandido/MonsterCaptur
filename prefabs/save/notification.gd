extends CanvasLayer

@onready var panel := $Panel as Panel
@onready var label := $Panel/Label as Label

func _ready():
	panel.visible = false
	label.visible = false
	panel.hide()
	label.hide()

func show_notification(message: String, duration: float = 2.0):	
	label.text = message	
	panel.visible = true
	label.visible = true
	panel.show()
	label.show()	
	await get_tree().create_timer(duration).timeout
	label.text = ''
	panel.visible = false
	label.visible = false
	panel.hide()
	label.hide()	
	

