extends Node3D

const LENGTH: float = 20.0

@export var barrier_scene: PackedScene
@export var train_scene: PackedScene
@export var coin_scene: PackedScene

@export var obstacle_chance: float = 0.4
@export var coin_chance: float = 0.5

@onready var spawn_points = [
	$SpawnContainer/Left,
	$SpawnContainer/Center,
	$SpawnContainer/Right
]

func _ready() -> void:
	$VisibleOnScreenNotifier3D.screen_exited.connect(_on_screen_exited)
	spawn_items()

func _on_screen_exited() -> void:
	queue_free()

func spawn_items() -> void:
	for point in spawn_points:
		if randf() < obstacle_chance:
			spawn_obstacle(point)
		elif randf() < coin_chance:
			spawn_coin(point)

func spawn_obstacle(parent_point: Node3D) -> void:
	var obstacle
	if randf() > 0.5:
		obstacle = barrier_scene.instantiate()
	else:
		obstacle = train_scene.instantiate()
	
	parent_point.add_child(obstacle)

func spawn_coin(parent_point: Node3D) -> void:
	var coin = coin_scene.instantiate()
	coin.position.y = 1.0 
	parent_point.add_child(coin)
