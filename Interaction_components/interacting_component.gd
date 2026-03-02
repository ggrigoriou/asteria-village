extends Node2D

@onready var interact_label: Label = $InteractLabel

var current_interactions: Array[Interactable] = []
var can_interact := true

func _unhandled_input(event: InputEvent) -> void:
	if !event.is_action_pressed("interact"):
		return
	if !can_interact or current_interactions.is_empty():
		return

	current_interactions.sort_custom(_sort_by_nearest)
	var top := current_interactions[0]

	if !top.is_interactable:
		return

	can_interact = false
	interact_label.hide()

	top.interact.call()

	can_interact = true

func _process(_delta: float) -> void:
	if can_interact and !current_interactions.is_empty():
		current_interactions.sort_custom(_sort_by_nearest)
		var top := current_interactions[0]

		if top.is_interactable:
			interact_label.text = "%s (E)" % top.interact_name
			interact_label.show()
			return

	interact_label.hide()

func _sort_by_nearest(a: Interactable, b: Interactable) -> bool:
	return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)

func _on_interact_range_area_entered(area: Area2D) -> void:
	if area is Interactable:
		current_interactions.push_back(area)

func _on_interact_range_area_exited(area: Area2D) -> void:
	if area is Interactable:
		current_interactions.erase(area)
