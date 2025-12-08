extends Node3D

const LENGTH: float = 20.0

func _ready() -> void:
	$VisibleOnScreenNotifier3D.screen_exited.connect(_on_screen_exited)

func _on_screen_exited() -> void:
	queue_free()
