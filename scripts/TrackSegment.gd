extends Node3D

const LENGTH: float = 20.0

@export var barrier_scene: PackedScene
@export var train_scene: PackedScene
@export var coin_scene: PackedScene
@export var high_barrier_scene: PackedScene

@export var obstacle_chance: float = 0.65 
@export var coin_chance: float = 0.7   

@onready var spawn_points = [
	$SpawnContainer/Left,
	$SpawnContainer/Center,
	$SpawnContainer/Right
]

func _ready() -> void:
	$VisibleOnScreenNotifier3D.screen_exited.connect(_on_screen_exited)

func _on_screen_exited() -> void:
	queue_free()

func spawn_items() -> void:
	var lanes = spawn_points.duplicate()
	lanes.shuffle()
	
	var escape_lane = lanes.pop_front()
	
	if randf() < obstacle_chance:
		spawn_obstacle(escape_lane, true)
	elif randf() < coin_chance:
		spawn_coin(escape_lane)
	
	for lane in lanes:
		if randf() < obstacle_chance:
			spawn_obstacle(lane, false)
		elif randf() < coin_chance:
			spawn_coin(lane)

func spawn_obstacle(parent_point: Node3D, forbid_trains: bool = false) -> void:
	var obstacle
	
	if forbid_trains:
		if randf() < 0.5:
			obstacle = barrier_scene.instantiate()
		else:
			obstacle = high_barrier_scene.instantiate()
	else:
		var roll = randf()
		if roll < 0.2:
			obstacle = barrier_scene.instantiate()
		elif roll < 0.8:
			obstacle = train_scene.instantiate()
		else:
			obstacle = high_barrier_scene.instantiate()
	
	parent_point.add_child(obstacle)

func spawn_coin(parent_point: Node3D) -> void:
	var coin = coin_scene.instantiate()
	coin.position.y = 1.0 
	parent_point.add_child(coin)
