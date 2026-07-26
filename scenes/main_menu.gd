extends Control

var LEVEL_MAIN = load("res://scenes/level_manager.tscn")
const SETTINGS = preload("res://scenes/settings.tscn")
const CREDITS = preload("res://scenes/credits.tscn")

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL_MAIN)

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_packed(SETTINGS)

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_packed(CREDITS)

func _on_quit_pressed() -> void:
	get_tree().quit()
