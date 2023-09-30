extends Resource

enum TYPES {
	POTION,
	KEY,
	ARMOR,
	SWORD,
}

class Item:
	var name: String
	var description: String
	var value: int
	var max_amount: int
	var type: TYPES
	var image: String
	
func _init(name: String, description: String, value: int, max_amount: int, type: TYPES, image: String):
	self.name = name
	self.description = description
	self.value = value
	self.max_amount = max_amount
	self.type = type
	self.image = image
