extends Node2D  # or StaticBody2D

@export var wheat_cost: int = 1
@export var flour_gain: int = 1
@onready var interactable: Interactable = $Interactable

func _ready() -> void:
	interactable.interact_name = "Trade wheat for some flour"
	interactable.interact = Callable(self, "_trade")

func _trade() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player and player.has_method("trade_wheat_for_flour"):
		player.trade_wheat_for_flour(wheat_cost, flour_gain)
		print("FLOURMAN: attempted trade")
	else:
		push_warning("FLOURMAN: Player missing trade_wheat_for_flour()")
