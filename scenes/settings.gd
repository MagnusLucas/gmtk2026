extends Control
var main_menu = load("res://scenes/main_menu.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)
