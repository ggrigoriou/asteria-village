extends StaticBody2D

@onready var interactable: Area2D = $Interactable
var is_showing := false

@export var sign_text: String = "Welcome to the village."

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact() -> void:
	var dialogue = get_tree().current_scene.get_node_or_null("DialogueUI")
	if not dialogue:
		return

	dialogue.show_dialogue(sign_text)

	while dialogue.is_open():
		await get_tree().process_frame
