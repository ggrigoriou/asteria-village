extends Node2D  # or StaticBody2D

@export var coin_cost: int = 1
@export var flour_gain: int = 1
@onready var interactable: Interactable = $Interactable

func _ready() -> void:
	interactable.interact_name = "Trade flour for some coins"
	interactable.interact = Callable(self, "_trade")

func _trade() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player and player.has_method("trade_flour_for_coin"):
		player.trade_flour_for_coin(flour_gain, coin_cost)
		print("COINMAN: attempted trade")
	else:
		push_warning("COINMAN: Player missing trade_flour_for_coin()")
