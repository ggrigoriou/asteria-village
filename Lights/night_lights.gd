extends Node2D

@export var time_system: TimeSystem

@export_range(0, 23) var day_start_hour: int = 6
@export_range(0, 59) var day_start_minute: int = 30

@export_range(0, 23) var night_start_hour: int = 19
@export_range(0, 59) var night_start_minute: int = 30

@export var night_energy: float = 1.0
@export var day_energy: float = 0.0

@onready var light: PointLight2D = $PointLight2D

func _process(_delta: float) -> void:
	if time_system == null:
		return

	var now := _to_minutes(time_system.date_time.hours, time_system.date_time.minutes)
	var day_start := _to_minutes(day_start_hour, day_start_minute)
	var night_start := _to_minutes(night_start_hour, night_start_minute)

	var is_night := (now < day_start) or (now >= night_start)
	light.energy = night_energy if is_night else day_energy

func _to_minutes(h: int, m: int) -> int:
	return h * 60 + m
