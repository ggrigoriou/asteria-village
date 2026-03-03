extends Node2D

@export var coin_cost: int = 1
@export var flour_gain: int = 1
@onready var interactable: Interactable = $Interactable

# A list of short, flavor-text wishes
var wishes: Array[String] = [
	# --- The "Classic" Wishes ---
	"I want gold!", 
	"Endless flour!", 
	"Infinite power!", 
	"Eternal youth!",
	
	# --- The "Meta/Funny" Wishes ---
	"A better frame rate!",
	"Skip the tutorial!",
	"A bigger inventory!",
	"Delete the slimes!",
	"I wish for more wishes!",
	"Just a sandwich...",
	
	# --- The "Mystical/Vague" Wishes ---
	"To see the stars...",
	"The truth of the void!",
	"To forget that one thing.",
	"Silence in the woods.",
	
	# --- The "Humble" Wishes ---
	"Dry socks for once.",
	"A nap. A long nap.",
	"Nicer weather tomorrow.",
	"A slightly faster walk."
]
var is_wishing: bool = false

func _ready() -> void:
	interactable.interact_name = "Make a wish"
	interactable.interact = Callable(self, "_trade")

func _trade() -> void:
	# 1. Check if we are already in the middle of a wish
	if is_wishing:
		return

	var player := get_tree().get_first_node_in_group("player")
	
	if player and player.has_method("make_a_wish"):
		player.make_a_wish(coin_cost)
		start_wish_countdown()
		print("COINMAN: attempted to make a wish")
	else:
		push_warning("COINMAN: Player missing make_a_wish()")

func start_wish_countdown() -> void:
	is_wishing = true
	var random_wish = wishes.pick_random()
	var time_left = 10
	
	# Create a loop for the countdown
	while time_left > 0:
		interactable.interact_name = "%s (%s)" % [random_wish, time_left]
		
		# Wait for 1 second using a SceneTreeTimer
		await get_tree().create_timer(1.0).timeout
		time_left -= 1
	
	# Reset back to default
	interactable.interact_name = "Make a wish"
	is_wishing = false
