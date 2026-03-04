extends Node2D

@export var coin_cost: int = 1
@export var flour_gain: int = 1
@onready var interactable: Interactable = $Interactable
@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

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
	
	if player and player.has_method("make_a_wish") and player.coin > 0:
		player.make_a_wish(coin_cost)
		start_wish_countdown()
		sfx.play()
		print("COINMAN: attempted to make a wish")
	else:
		start_wish_countdown(3, false)
		push_warning("COINMAN: Player missing make_a_wish()")

func start_wish_countdown(interval: int = 10, wish: bool = true) -> void:
	is_wishing = true
	var random_wish = wishes.pick_random()
	var time_left = interval
	
	# Create a loop for the countdown
	if wish:
		while time_left > 0:
			interactable.interact_name = "%s (%s)" % [random_wish, time_left]
			
			# Wait for 1 second using a SceneTreeTimer
			await get_tree().create_timer(1.0).timeout
			time_left -= 1
	else: 
		while time_left > 0:
			interactable.interact_name = "%s (%s)" % ["You need a Coin", time_left]
			
			# Wait for 1 second using a SceneTreeTimer
			await get_tree().create_timer(1.0).timeout
			time_left -= 1
	
	# Reset back to default
	interactable.interact_name = "Make a wish"
	is_wishing = false
