extends CanvasLayer

@onready var container: Control = $Control
@onready var menu_buttons: VBoxContainer = $Control/VBoxContainer
@onready var resume_btn: Button = $Control/VBoxContainer/ResumeButton
@onready var quit_btn: Button = $Control/VBoxContainer/QuitButton

@onready var start_label: Label = $Control/StartLabel

const MAIN_MENU_PATH: String = "res://scenes//main_menu.tscn"

var waiting_for_key: bool = false

func _ready() -> void:
	resume_btn.pressed.connect(prepare_to_resume)
	quit_btn.pressed.connect(quit_to_menu)
	
	get_tree().paused = true
	
	container.visible = true
	menu_buttons.visible = false
	start_label.visible = true
	
	waiting_for_key = true

func _input(event: InputEvent) -> void:
	if waiting_for_key:
		if event is InputEventKey and event.pressed:
			resume_game()
			get_viewport().set_input_as_handled()
		elif event is InputEventMouseButton and event.pressed:
			resume_game()
		return

	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	var is_paused = not get_tree().paused
	
	if is_paused:
		get_tree().paused = true
		container.visible = true
		menu_buttons.visible = true
		start_label.visible = false
		waiting_for_key = false
	else:
		prepare_to_resume()

func prepare_to_resume() -> void:
	menu_buttons.visible = false
	start_label.visible = true
	waiting_for_key = true

func resume_game() -> void:
	waiting_for_key = false
	container.visible = false
	get_tree().paused = false

func quit_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
