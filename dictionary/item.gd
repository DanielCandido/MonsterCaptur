class_name Item

var id: int
var name: String
var description: String
var value: int
var max_amount: int
var type: TYPES
var image: String
var market_value: float
var amount: int
	
enum TYPES {
	POTION,
	KEY,
	ARMOR,
	SWORD,
}
	
func _init(
	id: int,
	name: String,
	description: String,
	value: int,
	max_amount: int,
	type: TYPES,
	image: String,
	market_value: float,
	amount: int = 1
	):
		
	self.id = id
	self.name = name
	self.description = description
	self.value = value
	self.max_amount = max_amount
	self.type = type
	self.image = image
	self.market_value = market_value
	self.max_amount = amount
