extends Control

var main_menu = load("res://scenes/main_menu.tscn")

func _ready() -> void:
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_cancel'):
		get_tree().paused = false
		get_viewport().set_input_as_handled()
		queue_free()

func _on_back_to_game_pressed() -> void:
	get_tree().paused = false
	queue_free()
	
func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu)
