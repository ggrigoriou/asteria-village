extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var hud := get_tree().current_scene.get_node_or_null("HUD")
var wheat: int = 0
var flour: int = 0

func _ready():
	update_animation_parameters(starting_direction)
	await get_tree().process_frame
	_update_hud()

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_raw_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	update_animation_parameters(input_direction)
	
	velocity = input_direction * move_speed
	move_and_slide()
	
	pick_new_state()

func update_animation_parameters(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)

func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func add_wheat(amount: int) -> void:
	wheat += amount
	print_inventory("add_wheat(%d)" % amount)
	_update_hud()

func trade_wheat_for_flour(wheat_cost: int = 1, flour_gain: int = 1) -> bool:
	if wheat < wheat_cost:
		print("NOT ENOUGH WHEAT: have=%d need=%d" % [wheat, wheat_cost])
		print_inventory("trade_failed")
		_update_hud()
		return false

	wheat -= wheat_cost
	flour += flour_gain
	print("TRADE OK: -%d wheat, +%d flour" % [wheat_cost, flour_gain])
	print_inventory("trade_ok")
	_update_hud()
	return true

func print_inventory(context: String = "") -> void:
	print("INV %s -> wheat=%d, flour=%d" % [context, wheat, flour])

func _update_hud() -> void:
	if hud and hud.has_method("set_counts"):
		hud.set_counts(wheat, flour)
