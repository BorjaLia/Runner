extends Node3D

@export var track_scene: PackedScene


var segment_length: float = 20.0
var amount_to_spawn: int = 15
var spawn_z: float = 0.0

@onready var player: CharacterBody3D = $Player

func _ready() -> void:
	spawn_z = 0.0 
	
	for i in range(amount_to_spawn):
		spawn_segment()

func _process(delta: float) -> void:
	var player_z = player.global_position.z
	
	if spawn_z - player_z > -140.0:
		spawn_segment()

func spawn_segment() -> void:
	var segment = track_scene.instantiate()
	
	segment.position.z = spawn_z
	
	add_child(segment)
	
	spawn_z -= segment_length
