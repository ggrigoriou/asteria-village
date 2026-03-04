extends Node2D  # or StaticBody2D

@onready var interactable: Interactable = $Interactable
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

var anim_name := "new_animation"

func _ready() -> void:
	interactable.interact_name = "Ring the Bell"
	interactable.interact = Callable(self, "_hit_bell")
	animation.animation_finished.connect(_on_anim_finished)
	animation.sprite_frames.set_animation_loop(anim_name, false)

func _hit_bell() -> void:
	if animation:
		animation.stop()
		animation.frame = 0
		animation.play(anim_name)
		sfx.play()
		print("Ding Dong")
	else:
		push_warning("LEVER: Missing animation")

func _on_anim_finished() -> void: 
	animation.stop()
