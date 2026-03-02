extends Node2D  # or StaticBody2D

@export var wheat_amount: int = 1
@onready var interactable: Interactable = $Interactable

func _ready() -> void:
	interactable.interact_name = "Ask for some wheat"
	interactable.interact = Callable(self, "_give_wheat")

func _give_wheat() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player and player.has_method("add_wheat"):
		player.add_wheat(wheat_amount)
		print("WHEATMAN: gave %d wheat" % wheat_amount)
	else:
		push_warning("WHEATMAN: Player missing add_wheat()")
