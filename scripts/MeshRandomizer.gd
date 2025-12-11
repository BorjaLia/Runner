extends Node3D

@export var model_scenes: Array[PackedScene]

@export var shared_texture: Texture2D

@export var force_white_color: bool = true

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	if model_scenes.size() > 0:
		var template_material = mesh_instance.get_surface_override_material(0)
		var template_shadow = mesh_instance.cast_shadow
		
		var selected_scene = model_scenes.pick_random()
		
		var new_model = selected_scene.instantiate()
		
		add_child(new_model)
		
		if template_material:
			_apply_settings_recursively(new_model, template_material, template_shadow)
		
		mesh_instance.queue_free()

func _apply_settings_recursively(node: Node, template_mat: Material, shadow_setting: GeometryInstance3D.ShadowCastingSetting) -> void:
	if node is MeshInstance3D:
		node.cast_shadow = shadow_setting
		
		var target_texture = shared_texture
		
		if target_texture == null:
			var original_mat = node.get_active_material(0)
			if original_mat is StandardMaterial3D:
				target_texture = original_mat.albedo_texture
		
		var new_mat = template_mat.duplicate()
		
		if target_texture:
			new_mat.set_shader_parameter("albedo_texture", target_texture)
			
		if force_white_color:
			new_mat.set_shader_parameter("albedo_color", Color.WHITE)
		
		node.set_surface_override_material(0, new_mat)

	for child in node.get_children():
		_apply_settings_recursively(child, template_mat, shadow_setting)
