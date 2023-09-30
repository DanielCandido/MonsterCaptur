extends Resource

const Item = preload("res://dictionary/item.gd")

class ItemData:
	var all_items: Dictionary

	func _init():
		all_items = {
			"small_healing_potion": Item.new("Poção de cura pequena", "Recupera 50 de HP", 50, 9999, Item.TYPES.POTION, "res://assets/drops/health.png"),
			"egle_key": Item.new("Chave aguia guardiã", "Abre a jaula onde se encontra a aguia guardiã", 0, 1, Item.TYPES.KEY, "res://assets/drops/key.png")
		}
