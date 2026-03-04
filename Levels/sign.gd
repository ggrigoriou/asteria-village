extends Node2D

@onready var interactable: Interactable = $Interactable
var info_timer: Timer

var infos: Array[String] = [
	"At the top-right of the map,\nyou’ll find the Farmer.",
	"At the bottom-left of the map,\nyou’ll find the Miller.",
	"At the top-center of the map,\nyou’ll find the Mage and the Mystic Well.",
	"Good luck exploring the village!"
]

var info_index := 0
var cycling := false
var seconds_left := 5

const DEFAULT_TEXT := "Welcome to the village. Directions"
const COUNTDOWN_START := 5

func _ready() -> void:
	interactable.interact_name = DEFAULT_TEXT
	interactable.interact = Callable(self, "_instractions")

	info_timer = Timer.new()
	info_timer.wait_time = 1.0
	info_timer.one_shot = false
	add_child(info_timer)
	info_timer.timeout.connect(_on_info_timer_timeout)

func _instractions() -> void:
	if not cycling:
		# First press: start from the beginning
		cycling = true
		info_index = 0
		seconds_left = COUNTDOWN_START
		_update_interact_text()
		info_timer.start()
		return

	# Pressed again while cycling: go to next info immediately
	info_index += 1

	if info_index >= infos.size():
		# If it was the last one, finish and reset
		_finish_cycle()
		return

	seconds_left = COUNTDOWN_START
	_update_interact_text()
	info_timer.start() # restart so it feels consistent

func _on_info_timer_timeout() -> void:
	if not cycling:
		return

	seconds_left -= 1

	if seconds_left <= 0:
		info_index += 1

		if info_index >= infos.size():
			_finish_cycle()
			return

		seconds_left = COUNTDOWN_START

	_update_interact_text()

func _update_interact_text() -> void:
	interactable.interact_name = "%s (%d)" % [infos[info_index], seconds_left]

func _finish_cycle() -> void:
	cycling = false
	info_timer.stop()
	info_index = 0
	seconds_left = COUNTDOWN_START
	interactable.interact_name = DEFAULT_TEXT
