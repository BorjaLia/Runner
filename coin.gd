extends Area3D

var rotate_speed: float = 3.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	rotate_y(rotate_speed * delta)

func _on_body_entered(body: Node3D) -> void:
	if "Player" in body.name:
		Global.score += 1
		print("Score: ", Global.score)
		queue_free()
