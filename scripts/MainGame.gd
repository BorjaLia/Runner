extends Node3D

@export var track_scene: PackedScene
var segment_length: float = 20.0
var amount_to_spawn: int = 15
var spawn_z: float = 0.0

var segments_spawned: int = 0
var speed_increase_interval: int = 10 
var max_speed: float = 25.0

@onready var player: CharacterBody3D = $Player
@onready var game_over_menu: CanvasLayer = $GameOverMenu

func _ready() -> void:
	if player.has_signal("player_crashed"):
		player.player_crashed.connect(_on_player_crashed)
	
	spawn_z = 0.0 
	for i in range(amount_to_spawn):
		var is_safe_zone = i < 3
		spawn_segment(is_safe_zone)

func _process(delta: float) -> void:
	var player_z = player.global_position.z
	if spawn_z - player_z > -140.0:
		spawn_segment(false)

func spawn_segment(is_safe_zone: bool) -> void:
	var segment = track_scene.instantiate()
	segment.position.z = spawn_z
	add_child(segment)
	
	if not is_safe_zone:
		segment.spawn_items()
	
	spawn_z -= segment_length
	
	segments_spawned += 1
	if segments_spawned % speed_increase_interval == 0:
		if Global.speed < max_speed:
			Global.increase_speed()
			print("Speed Up! New Speed: ", Global.speed)

func _on_player_crashed() -> void:
	game_over_menu.show_screen(Global.score, Global.coins)
