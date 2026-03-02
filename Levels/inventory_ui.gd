extends CanvasLayer

@onready var label: Label = get_node_or_null("PanelContainer/Label") as Label

func _ready() -> void:
	if label == null:
		push_error("HUD: Label not found at 'PanelContainer/Label'. Check node names/structure.")
	else:
		# optional: initial text
		label.text = "Wheat: 0\nFlour: 0"

func set_counts(wheat: int, flour: int) -> void:
	if label == null:
		push_warning("HUD: set_counts called but label is null.")
		return
	label.text = "Wheat: %d\nFlour: %d" % [wheat, flour]
