const Item = preload("res://dictionary/item.gd")

@export
var all_items := {
	"small_healing_potion": Item.new("Poção de cura pequena", "Recupera 50 de HP", 50, 9999, Item.TYPES.POTION, "res://assets/drops/health.png"),
	"eagle_key": Item.new("Chave aguia guardiã", "Abre a jaula onde se encontra a aguia guardiã", 0, 1, Item.TYPES.KEY, "res://assets/drops/key.png")
} as Dictionary
