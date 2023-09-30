const Item = preload("res://dictionary/item.gd")

@export
var all_items := {
	"small_healing_potion": Item.new(1, "Poção de cura pequena", "Recupera 50 de HP", 50, 9999, Item.TYPES.POTION, "res://assets/drops/health.png", 15.0, 1),
	"medium_healing_potion": Item.new(2, "Poção de cura média", "Recupera 150 de HP", 50, 9999, Item.TYPES.POTION, "res://assets/drops/health.png", 35.0, 1),
	"eagle_key": Item.new(3, "Chave aguia guardiã", "Abre a jaula onde se encontra a aguia guardiã", 0, 1, Item.TYPES.KEY, "res://assets/drops/key.png", 0, 1)
} as Dictionary

@export
var shop_items := {
	"small_healing_potion": Item.new(1, "Poção de cura pequena", "Recupera 50 de HP", 50, 9999, Item.TYPES.POTION, "res://assets/drops/health.png", 15.0, 1),
	"medium_healing_potion": Item.new(2, "Poção de cura média", "Recupera 150 de HP", 50, 9999, Item.TYPES.POTION, "res://assets/drops/health.png", 35.0, 1),
}
