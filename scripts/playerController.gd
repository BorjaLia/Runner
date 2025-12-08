extends CharacterBody3D

@export var jump_force: float = 10.0
@export var gravity: float = 20.0
@export var lane_speed: float = 10.0

var current_lane: int = 0
var target_x: float = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	_handle_input()
	
	velocity.z = -Global.speed
	
	velocity.x = 0
	position.x = move_toward(position.x, target_x, lane_speed * delta)
	
	move_and_slide()

func _handle_input() -> void:
	if Input.is_action_just_pressed("move_left"):
		change_lane(-1)
	elif Input.is_action_just_pressed("move_right"):
		change_lane(1)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	if Input.is_action_just_pressed("roll") and is_on_floor():
		print("Rolling!")

func change_lane(direction: int) -> void:
	current_lane += direction
	
	current_lane = clamp(current_lane, -1, 1)
	
	target_x = current_lane * Global.LANE_WIDTH
