extends CanvasLayer

@onready var score_label: Label = $Control/VBoxContainer/ScoreLabel
@onready var coin_label: Label = $Control/VBoxContainer/CoinLabel
@onready var content: Control = $Control

const MAIN_MENU_PATH: String = "res://scenes//main_menu.tscn"

func _ready() -> void:
	content.visible = false
	
	$Control/VBoxContainer/RetryButton.pressed.connect(_on_retry_pressed)
	$Control/VBoxContainer/MenuButton.pressed.connect(_on_menu_pressed)

func show_screen(final_score: int, final_coins: int) -> void:
	score_label.text = "Distance: " + str(final_score) + "m"
	coin_label.text = "Coins Collected: " + str(final_coins)
	
	content.visible = true
	
	get_tree().paused = true

func _on_retry_pressed() -> void:
	Global.reset_game()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
