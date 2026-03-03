extends DirectionalLight2D

@export var day_color: Color
@export var night_color: Color
@export var day_start: DateTime
@export var night_start: DateTime
@export var transition_time: int = 30
@export var time_system: TimeSystem

var in_transition := false

enum DayState { DAY, NIGHT }
var current_state: DayState = DayState.DAY

@onready var time_map := {
	DayState.DAY: day_start,
	DayState.NIGHT: night_start,
}

@onready var transition_map := {
	DayState.DAY: DayState.NIGHT,
	DayState.NIGHT: DayState.DAY,
}

@onready var color_map := {
	DayState.DAY: day_color,
	DayState.NIGHT: night_color,
}

func _ready() -> void:
	assert(time_system != null)
	assert(day_start != null and night_start != null)

	var now := time_system.date_time
	if now.diff_without_days(day_start) < 0 or now.diff_without_days(night_start) >= 0:
		current_state = DayState.NIGHT

func _process(_delta: float) -> void:
	update_light(time_system.date_time)

func update_light(game_time: DateTime) -> void:
	var next_state: DayState = transition_map[current_state]
	var change_time: DateTime = time_map[next_state]
	var time_diff: int = change_time.diff_without_days(game_time)

	var window := transition_time * 60

	if in_transition:
		update_transition(time_diff, next_state, window)
	elif time_diff > 0 and time_diff < window:
		in_transition = true
		update_transition(time_diff, next_state, window)
	else:
		color = color_map[current_state]

func update_transition(time_diff: int, next_state: DayState, window: int) -> void:
	var ratio := 1.0 - (float(time_diff) / float(window))
	ratio = clamp(ratio, 0.0, 1.0)

	color = color_map[current_state].lerp(color_map[next_state], ratio)

	if ratio >= 1.0:
		current_state = next_state
		in_transition = false
