extends CharacterBody3D

@export var jump_force: float = 10.0
@export var gravity: float = 20.0
@export var lane_speed: float = 10.0

var current_lane: int = 0
var target_x: float = 0.0
var is_dead: bool = false
var is_rolling: bool = false

var score_accumulator: float = 0.0

@onready var col_stand: CollisionShape3D = $CollisionStand
@onready var col_roll: CollisionShape3D = $CollisionRoll
@onready var visuals: Node3D = $Visuals

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	_handle_input()
	
	velocity.z = -Global.speed
	
	velocity.x = 0 
	position.x = move_toward(position.x, target_x, lane_speed * delta)
	
	move_and_slide()

	if not is_dead:
		score_accumulator += Global.speed * delta
		Global.score = int(score_accumulator)

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.is_in_group("obstacle"):
			var normal = collision.get_normal()
			if normal.z > 0.5:
				game_over()

func _handle_input() -> void:
	if Input.is_action_just_pressed("move_left"):
		change_lane(-1)
	elif Input.is_action_just_pressed("move_right"):
		change_lane(1)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if is_rolling:
			stop_roll()
		velocity.y = jump_force

	if Input.is_action_just_pressed("roll"):
		if is_on_floor():
			start_roll()
		else:
			velocity.y = -jump_force * 1.5

func change_lane(direction: int) -> void:
	current_lane += direction
	current_lane = clamp(current_lane, -1, 1)
	target_x = current_lane * Global.LANE_WIDTH

func start_roll() -> void:
	if is_rolling: return
	
	is_rolling = true
	
	col_stand.disabled = true
	col_roll.disabled = false
	
	visuals.scale.y = 0.5
	
	await get_tree().create_timer(1.0).timeout
	
	if not is_dead:
		stop_roll()

func stop_roll() -> void:
	is_rolling = false
	col_stand.disabled = false
	col_roll.disabled = true
	
	visuals.scale.y = 1.0

func game_over() -> void:
	if is_dead: return
	is_dead = true
	print("CRASH! Distance: ", Global.score, " Coins: ", Global.coins)
	Global.reset_game()
	get_tree().reload_current_scene()
